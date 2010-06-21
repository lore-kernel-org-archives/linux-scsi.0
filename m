From: Ravi Anand <ravi.anand@qlogic.com>
Subject: Re: [PATCH 04/11] qla4xxx: set correct value in sess->recovery_tmo
Date: Mon, 21 Jun 2010 16:35:24 -0700
Message-ID: <AC192039-EAE9-4625-8AF0-C4B9E1C8D47D@qlogic.com>
References: <20100616205111.GA8149@sles11sp1b1.qlogic.org>
 <4C1BFA2D.6050607@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:48976 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab0FUXf0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jun 2010 19:35:26 -0400
In-Reply-To: <4C1BFA2D.6050607@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, "james.bottomley@suse.de" <james.bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Mike,

Actually, that's not true.

When we call iscsi_block_session(), session is already down and we are not
sending any NOP.

FW closes connection after ka_timeout expire at FW level.  Then FW
sends notification to driver for DDB state change which basically indicates
that session is in failed state . After that driver mark device *missing* and call iscsi_block_sesstion().
At this point iSCSI connection is already closed,  so FW is not sending
any iSCSI NOP to target.

We are just using value of ka_timeout in sess->recovery_tmo because
we want to wait for some time for connection to comeback else
mark device dead.

Let us know if you see any issue with this implementation.

Thanks
Ravi
On Jun 18, 2010, at 3:58 PM, Mike Christie wrote:

> Actually, I am going to take back my ACK/review-by on this.
> 
> After discussing with Qlogic what the ka_timeout really is, it seems it 
> is the wrong value to use. When the session->recovery_tmo is running the 
> session is down so iscsi nops cannot be sent.
> 
> 
> 
> On 06/16/2010 03:51 PM, Vikas Chaudhary wrote:
>> Signed-off-by: Vikas Chaudhary<vikas.chaudhary@qlogic.com>
>> Signed-off-by: Ravi Anand<ravi.anand@qlogic.com>
>> ---
>>  drivers/scsi/qla4xxx/ql4_def.h  |    3 +--
>>  drivers/scsi/qla4xxx/ql4_init.c |    6 +++---
>>  drivers/scsi/qla4xxx/ql4_mbx.c  |    1 -
>>  drivers/scsi/qla4xxx/ql4_os.c   |    4 ++--
>>  4 files changed, 6 insertions(+), 8 deletions(-)
>> 
>> diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
>> index 4288026..2b53c79 100644
>> --- a/drivers/scsi/qla4xxx/ql4_def.h
>> +++ b/drivers/scsi/qla4xxx/ql4_def.h
>> @@ -239,12 +239,12 @@ struct ddb_entry {
>>  	uint32_t default_time2wait; /* Default Min time between
>>  				     * relogins (+aens) */
>> 
>> -	atomic_t port_down_timer; /* Device connection timer */
>>  	atomic_t retry_relogin_timer; /* Min Time between relogins
>>  				       * (4000 only) */
>>  	atomic_t relogin_timer;	/* Max Time to wait for relogin to complete */
>>  	atomic_t relogin_retry_count; /* Num of times relogin has been
>>  				       * retried */
>> +	uint16_t ka_timeout;
>> 
>>  	uint16_t port;
>>  	uint32_t tpgt;
>> @@ -394,7 +394,6 @@ struct scsi_qla_host {
>>  	uint32_t timer_active;
>> 
>>  	/* Recovery Timers */
>> -	uint32_t port_down_retry_count;
>>  	uint32_t discovery_wait;
>>  	atomic_t check_relogin_timeouts;
>>  	uint32_t retry_reset_ha_cnt;
>> diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
>> index d525405..6cdfe9f 100644
>> --- a/drivers/scsi/qla4xxx/ql4_init.c
>> +++ b/drivers/scsi/qla4xxx/ql4_init.c
>> @@ -548,6 +548,9 @@ static int qla4xxx_update_ddb_entry(struct scsi_qla_host *ha,
>>  	ddb_entry->default_relogin_timeout =
>>  		le16_to_cpu(fw_ddb_entry->def_timeout);
>>  	ddb_entry->default_time2wait = le16_to_cpu(fw_ddb_entry->iscsi_def_time2wait);
>> +	ddb_entry->ka_timeout = le16_to_cpu(fw_ddb_entry->ka_timeout);
>> +	if (ddb_entry->sess)
>> +		ddb_entry->sess->recovery_tmo = ddb_entry->ka_timeout;
>> 
>>  	/* Update index in case it changed */
>>  	ddb_entry->fw_ddb_index = fw_ddb_index;
>> @@ -633,7 +636,6 @@ static struct ddb_entry * qla4xxx_alloc_ddb(struct scsi_qla_host *ha,
>>  	}
>> 
>>  	ddb_entry->fw_ddb_index = fw_ddb_index;
>> -	atomic_set(&ddb_entry->port_down_timer, ha->port_down_retry_count);
>>  	atomic_set(&ddb_entry->retry_relogin_timer, INVALID_ENTRY);
>>  	atomic_set(&ddb_entry->relogin_timer, 0);
>>  	atomic_set(&ddb_entry->relogin_retry_count, 0);
>> @@ -1500,8 +1502,6 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
>>  	/* Device is back online. */
>>  	if (ddb_entry->fw_ddb_device_state == DDB_DS_SESSION_ACTIVE) {
>>  		atomic_set(&ddb_entry->state, DDB_STATE_ONLINE);
>> -		atomic_set(&ddb_entry->port_down_timer,
>> -			   ha->port_down_retry_count);
>>  		atomic_set(&ddb_entry->relogin_retry_count, 0);
>>  		atomic_set(&ddb_entry->relogin_timer, 0);
>>  		clear_bit(DF_RELOGIN,&ddb_entry->flags);
>> diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
>> index 75496fb..aa12ffd 100644
>> --- a/drivers/scsi/qla4xxx/ql4_mbx.c
>> +++ b/drivers/scsi/qla4xxx/ql4_mbx.c
>> @@ -287,7 +287,6 @@ qla4xxx_update_local_ifcb(struct scsi_qla_host *ha,
>>  	       min(sizeof(ha->alias), sizeof(init_fw_cb->Alias)));*/
>> 
>>  	/* Save Command Line Paramater info */
>> -	ha->port_down_retry_count = le16_to_cpu(init_fw_cb->conn_ka_timeout);
>>  	ha->discovery_wait = ql4xdiscoverywait;
>> 
>>  	if (ha->acb_version == ACB_SUPPORTED) {
>> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
>> index 38b1d38..11a4bd1 100644
>> --- a/drivers/scsi/qla4xxx/ql4_os.c
>> +++ b/drivers/scsi/qla4xxx/ql4_os.c
>> @@ -155,7 +155,7 @@ static void qla4xxx_recovery_timedout(struct iscsi_cls_session *session)
>>  		DEBUG2(printk("scsi%ld: %s: index [%d] port down retry count "
>>  			      "of (%d) secs exhausted, marking device DEAD.\n",
>>  			      ha->host_no, __func__, ddb_entry->fw_ddb_index,
>> -			      ha->port_down_retry_count));
>> +			      ddb_entry->ka_timeout));
>> 
>>  		DEBUG2(printk("scsi%ld: %s: scheduling dpc routine - dpc "
>>  			      "flags = 0x%lx\n",
>> @@ -286,7 +286,7 @@ int qla4xxx_add_sess(struct ddb_entry *ddb_entry)
>>  {
>>  	int err;
>> 
>> -	ddb_entry->sess->recovery_tmo = ddb_entry->ha->port_down_retry_count;
>> +	ddb_entry->sess->recovery_tmo = ddb_entry->ka_timeout;
>>  	err = iscsi_add_session(ddb_entry->sess, ddb_entry->fw_ddb_index);
>>  	if (err) {
>>  		DEBUG2(printk(KERN_ERR "Could not add session.\n"));
> 

