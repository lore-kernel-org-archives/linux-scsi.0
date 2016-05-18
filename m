From: Michael Cyr <mikecyr@linux.vnet.ibm.com>
Subject: Re: [PATCH] Fix for hang of Ordered task in TCM
Date: Wed, 18 May 2016 14:35:23 -0500
Message-ID: <82ddb84d-1a3c-f7ad-3f91-0a9506317bdf@linux.vnet.ibm.com>
References: <1463177741-4385-1-git-send-email-mikecyr@linux.vnet.ibm.com>
 <1463550825.22249.17.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1463550825.22249.17.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: rjui@broadcom.com, sbranden@broadcom.com, jonmason@broadcom.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On 5/18/16 12:53 AM, Nicholas A. Bellinger wrote:
> Hi Michael,
>
> On Fri, 2016-05-13 at 17:15 -0500, Michael Cyr wrote:
>> If a command with a Simple task attribute is failed due to a Unit
>> Attention, then a subsequent command with an Ordered task attribute will
>> hang forever.  The reason for this is that the Unit Attention status is
>> checked for in target_setup_cmd_from_cdb, before the call to
>> target_execute_cmd, which calls target_handle_task_attr, which in turn
>> increments dev->simple_cmds.  However, transport_generic_request_failure
>> still calls transport_complete_task_attr, which will decrement
>> dev->simple_cmds.  In this case, simple_cmds is now -1.  So when a
>> command with the Ordered task attribute is sent, target_handle_task_attr
>> sees that dev->simple_cmds is not 0, so it decides it can't execute the
>> command until all the (nonexistent) Simple commands have completed.
>>
> Thanks for reporting this bug.  Comments below.
>
>> The solution I've implemented is to move target_scsi3_ua_check, as well as
>> target_alua_state_check and target_check_reservation, into
>> target_execute_cmd, after the call to target_handle_task_attr.  I believe
>> this is actually the correct way this should be handled.  According to
>> SAM-4 r14, under section 5.14:
>>
>> "h) if a command other than INQUIRY, REPORT LUNS, REQUEST SENSE, or NOTIFY
>> DATA TRANSFER DEVICE enters the enabled command state while a unit
>> attention condition exists for the SCSI initiator port associated with
>> the I_T nexus on which the command was received, the device server shall
>> terminate the command with a CHECK CONDITION status. The device server
>> shall provide sense data that reports a unit attention condition for the
>> SCSI initiator port that sent the command on the I_T nexus."
>>
>> But according to section 8.5 and 8.6, a command which is not yet executed
>> because of the presence of other tasks in the task set (i.e., one for
>> which target_handle_task_attr returns true) would not enter the enabled
>> command state; it would be in the dormant command state.
>> target_execute_cmd would get called when a command entered the enabled
>> command state, and thus that is the appropriate place to check for Unit
>> Attenion.  Similarly, though not quite as explicit, section 5.3.3 tells
>> us that a Reservation Conflict status has a lower precedence than a Unit
>> Attention, and so this would also seem to be the appropriate place to
>> call target_check_reservation.  I'm less sure about
>> target_alua_state_check, since I'm not very familiar with ALUA.
>>
>> Signed-off-by: Michael Cyr <mikecyr@linux.vnet.ibm.com>
>> ---
>>   drivers/target/target_core_transport.c | 41 ++++++++++++++++++++--------------
>>   1 file changed, 24 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
>> index 6c089af..2ee5502 100644
>> --- a/drivers/target/target_core_transport.c
>> +++ b/drivers/target/target_core_transport.c
>> @@ -1303,23 +1303,6 @@ target_setup_cmd_from_cdb(struct se_cmd *cmd, unsigned char *cdb)
>>   
>>   	trace_target_sequencer_start(cmd);
>>   
>> -	/*
>> -	 * Check for an existing UNIT ATTENTION condition
>> -	 */
>> -	ret = target_scsi3_ua_check(cmd);
>> -	if (ret)
>> -		return ret;
>> -
>> -	ret = target_alua_state_check(cmd);
>> -	if (ret)
>> -		return ret;
>> -
>> -	ret = target_check_reservation(cmd);
>> -	if (ret) {
>> -		cmd->scsi_status = SAM_STAT_RESERVATION_CONFLICT;
>> -		return ret;
>> -	}
>> -
>>   	ret = dev->transport->parse_cdb(cmd);
>>   	if (ret == TCM_UNSUPPORTED_SCSI_OPCODE)
>>   		pr_warn_ratelimited("%s/%s: Unsupported SCSI Opcode 0x%02x, sending CHECK_CONDITION.\n",
>> @@ -1865,6 +1848,8 @@ static int __transport_check_aborted_status(struct se_cmd *, int);
>>   
>>   void target_execute_cmd(struct se_cmd *cmd)
>>   {
>> +	sense_reason_t ret;
>> +
>>   	/*
>>   	 * Determine if frontend context caller is requesting the stopping of
>>   	 * this command for frontend exceptions.
>> @@ -1899,6 +1884,28 @@ void target_execute_cmd(struct se_cmd *cmd)
>>   		return;
>>   	}
>>   
>> +	/*
>> +	 * Check for an existing UNIT ATTENTION condition
>> +	 */
>> +	ret = target_scsi3_ua_check(cmd);
>> +	if (ret) {
>> +		transport_generic_request_failure(cmd, ret);
>> +		return;
>> +	}
>> +
>> +	ret = target_alua_state_check(cmd);
>> +	if (ret) {
>> +		transport_generic_request_failure(cmd, ret);
>> +		return;
>> +	}
>> +
>> +	ret = target_check_reservation(cmd);
>> +	if (ret) {
>> +		cmd->scsi_status = SAM_STAT_RESERVATION_CONFLICT;
>> +		transport_generic_request_failure(cmd, ret);
>> +		return;
>> +	}
>> +
>>   	__target_execute_cmd(cmd);
>>   }
>>   EXPORT_SYMBOL(target_execute_cmd);
> So AFAICT for delayed commands, the above patch ends up skipping these
> three checks subsequently when doing __target_execute_cmd() directly
> from target_restart_delayed_cmds(), no..?
>
> After pondering this some more, what about moving these checks into
> __target_execute_cmd() to handle both target_core_transport.c cases
> instead..?
You're right, __target_execute_cmd is clearly the right place for the 
checks.
> We'll also need a parameter for internal COMPARE_AND_WRITE usage
> within compare_and_write_callback(), to bypass checks upon secondary
> ->execute_cmd() WRITE payload submission after READ + COMPARE has
> completed successfully.
I'm still learning about the target code, and I was unaware of 
COMPARE_AND_WRITE.  Thanks for pointing this out to me.  You're right 
here too, we need to make sure we only make the tests when the Compare 
and Write is first executed (to do the read), and not later when the 
write is done.
>
> WDYT..?
You've covered all the places that call __target_execute_cmd, so I think 
it's good.
>
> diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
> index fc91e85..e2c970a 100644
> --- a/drivers/target/target_core_internal.h
> +++ b/drivers/target/target_core_internal.h
> @@ -146,6 +146,7 @@ sense_reason_t	target_cmd_size_check(struct se_cmd *cmd, unsigned int size);
>   void	target_qf_do_work(struct work_struct *work);
>   bool	target_check_wce(struct se_device *dev);
>   bool	target_check_fua(struct se_device *dev);
> +void	__target_execute_cmd(struct se_cmd *, bool);
>
>   /* target_core_stat.c */
>   void	target_stat_setup_dev_default_groups(struct se_device *);
> diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
> index a9057aa..04f616b 100644
> --- a/drivers/target/target_core_sbc.c
> +++ b/drivers/target/target_core_sbc.c
> @@ -602,7 +602,7 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
>   	cmd->transport_state |= CMD_T_ACTIVE|CMD_T_BUSY|CMD_T_SENT;
>   	spin_unlock_irq(&cmd->t_state_lock);
>
> -	__target_execute_cmd(cmd);
> +	__target_execute_cmd(cmd, false);
>
>   	kfree(buf);
>   	return ret;
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 6c089af..f3e93dd 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1761,20 +1761,45 @@ queue_full:
>   }
>   EXPORT_SYMBOL(transport_generic_request_failure);
>
> -void __target_execute_cmd(struct se_cmd *cmd)
> +void __target_execute_cmd(struct se_cmd *cmd, bool do_checks)
>   {
>   	sense_reason_t ret;
>
> -	if (cmd->execute_cmd) {
> -		ret = cmd->execute_cmd(cmd);
> -		if (ret) {
> -			spin_lock_irq(&cmd->t_state_lock);
> -			cmd->transport_state &= ~(CMD_T_BUSY|CMD_T_SENT);
> -			spin_unlock_irq(&cmd->t_state_lock);
> +	if (!cmd->execute_cmd) {
> +		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> +		goto err;
> +	}
> +	if (do_checks) {
> +		/*
> +		 * Check for an existing UNIT ATTENTION condition after
> +		 * target_handle_task_attr() has done SAM task attr
> +		 * checking, and possibly have already defered execution
> +		 * out to target_restart_delayed_cmds() context.
> +		 */
> +		ret = target_scsi3_ua_check(cmd);
> +		if (ret)
> +			goto err;
>
> -			transport_generic_request_failure(cmd, ret);
> +		ret = target_alua_state_check(cmd);
> +		if (ret)
> +			goto err;
> +
> +		ret = target_check_reservation(cmd);
> +		if (ret) {
> +			cmd->scsi_status = SAM_STAT_RESERVATION_CONFLICT;
> +			goto err;
>   		}
>   	}
> +
> +	ret = cmd->execute_cmd(cmd);
> +	if (!ret)
> +		return;
> +err:
> +	spin_lock_irq(&cmd->t_state_lock);
> +	cmd->transport_state &= ~(CMD_T_BUSY|CMD_T_SENT);
> +	spin_unlock_irq(&cmd->t_state_lock);
> +
> +	transport_generic_request_failure(cmd, ret);
>   }
>
>   static int target_write_prot_action(struct se_cmd *cmd)
> @@ -1899,7 +1924,7 @@ void target_execute_cmd(struct se_cmd *cmd)
>   		return;
>   	}
>
> -	__target_execute_cmd(cmd);
> +	__target_execute_cmd(cmd, true);
>   }
>   EXPORT_SYMBOL(target_execute_cmd);
>
> @@ -1923,7 +1948,7 @@ static void target_restart_delayed_cmds(struct se_device *dev)
>   		list_del(&cmd->se_delayed_node);
>   		spin_unlock(&dev->delayed_cmd_lock);
>
> -		__target_execute_cmd(cmd);
> +		__target_execute_cmd(cmd, true);
>
>   		if (cmd->sam_task_attr == TCM_ORDERED_TAG)
>   			break;
> diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
> index ec79da3..334f107 100644
> --- a/include/target/target_core_fabric.h
> +++ b/include/target/target_core_fabric.h
> @@ -163,7 +163,6 @@ int	core_tmr_alloc_req(struct se_cmd *, void *, u8, gfp_t);
>   void	core_tmr_release_req(struct se_tmr_req *);
>   int	transport_generic_handle_tmr(struct se_cmd *);
>   void	transport_generic_request_failure(struct se_cmd *, sense_reason_t);
> -void	__target_execute_cmd(struct se_cmd *);
>   int	transport_lookup_tmr_lun(struct se_cmd *, u64);
>   void	core_allocate_nexus_loss_ua(struct se_node_acl *acl);
>
