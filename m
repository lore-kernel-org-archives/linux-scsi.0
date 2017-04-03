From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH] target/user: PGR Support
Date: Mon, 3 Apr 2017 11:53:02 -0500
Message-ID: <217216f0-ece5-e469-7787-6ef2f6a2c979@redhat.com>
References: <1490885269-47274-1-git-send-email-bryantly@linux.vnet.ibm.com>
 <CAABzzYiogV-OfcKUurAqHf7FGB=zwTSNFymxOWdw+75hPYdNdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAABzzYiogV-OfcKUurAqHf7FGB=zwTSNFymxOWdw+75hPYdNdg@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Shie-rei Huang <shierei@gmail.com>, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Cc: nab@linux-iscsi.org, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 04/03/2017 12:20 AM, Shie-rei Huang wrote:
> After a PGR command is processed in the kernel, is it possible for the
> user mode to be notified with the command so that the user mode has a
> chance to do its part of PGR processing. Below is one use case of it.
> Suppose two TCMU servers are set up as an active/passive cluster for
> high availability. An initiator's PGR command is sent to the active
> server only. But the active server's user mode would like the passive
> server to know about the PGR command also and sync up its configfs
> state with the active server. This is to make sure that when the
> active server dies, the passive server can take over with the correct
> PGR state.

We have been discussing this in a couple different threads, and it does
not work right now as you saw, but I am looking into and I think some
other people are too.

For HA we would need to handle these:

1. We can't just pass a raw PGR command to userspace, because we do not
have enough info. For commands where we need to know the I_T nexus the
command came in on, then we need to pass that info upwards. For example
a registration with SPEC_I_PT=0 ALL_TG _PT=0.

If we did a new netlink interface then we could pass that extra info
with the processed PGR info, or we could modify the existing tcmu one to
pass the raw PGR command with the transport info.

2. We do not want to return status for the PGR command before userspace
has distributed the PGR info. So, we can't do something really simple
like just send a netlink event and return status for the command
immediately, or we can't just modify the APTPL file to be usable when
APTPL is not used and then just watch it for changes from userspace.

We need some extra coordination like send a event to pass the PGR/I_T
Nexus info then the kernel needs to wait for a response and then it can
return status for the command.


> Thanks,
> 
> -Shie-rei
> 
> On Thu, Mar 30, 2017 at 7:47 AM, Bryant G. Ly
> <bryantly@linux.vnet.ibm.com> wrote:
>> This adds PGR support for just TCMU, since tcmu doesn't
>> have the necessary IT_NEXUS info to process PGR in userspace,
>> so have those commands be processed in kernel.
>>
>> Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
>> ---
>>  drivers/target/target_core_configfs.c | 10 +++++-----
>>  drivers/target/target_core_device.c   | 27 +++++++++++++++++++++++++++
>>  drivers/target/target_core_pr.c       |  2 +-
>>  drivers/target/target_core_pscsi.c    |  3 ++-
>>  include/target/target_core_backend.h  |  1 +
>>  5 files changed, 36 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
>> index 38b5025..edfb098 100644
>> --- a/drivers/target/target_core_configfs.c
>> +++ b/drivers/target/target_core_configfs.c
>> @@ -1366,7 +1366,7 @@ static ssize_t target_pr_res_holder_show(struct config_item *item, char *page)
>>         struct se_device *dev = pr_to_dev(item);
>>         int ret;
>>
>> -       if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)
>> +       if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
>>                 return sprintf(page, "Passthrough\n");
>>
>>         spin_lock(&dev->dev_reservation_lock);
>> @@ -1506,7 +1506,7 @@ static ssize_t target_pr_res_type_show(struct config_item *item, char *page)
>>  {
>>         struct se_device *dev = pr_to_dev(item);
>>
>> -       if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)
>> +       if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
>>                 return sprintf(page, "SPC_PASSTHROUGH\n");
>>         else if (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS)
>>                 return sprintf(page, "SPC2_RESERVATIONS\n");
>> @@ -1519,7 +1519,7 @@ static ssize_t target_pr_res_aptpl_active_show(struct config_item *item,
>>  {
>>         struct se_device *dev = pr_to_dev(item);
>>
>> -       if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)
>> +       if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
>>                 return 0;
>>
>>         return sprintf(page, "APTPL Bit Status: %s\n",
>> @@ -1531,7 +1531,7 @@ static ssize_t target_pr_res_aptpl_metadata_show(struct config_item *item,
>>  {
>>         struct se_device *dev = pr_to_dev(item);
>>
>> -       if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)
>> +       if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
>>                 return 0;
>>
>>         return sprintf(page, "Ready to process PR APTPL metadata..\n");
>> @@ -1577,7 +1577,7 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
>>         u16 tpgt = 0;
>>         u8 type = 0;
>>
>> -       if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)
>> +       if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
>>                 return count;
>>         if (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS)
>>                 return count;
>> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
>> index c754ae3..83c0d77 100644
>> --- a/drivers/target/target_core_device.c
>> +++ b/drivers/target/target_core_device.c
>> @@ -1045,6 +1045,7 @@ passthrough_parse_cdb(struct se_cmd *cmd,
>>         sense_reason_t (*exec_cmd)(struct se_cmd *cmd))
>>  {
>>         unsigned char *cdb = cmd->t_task_cdb;
>> +       struct se_device *dev = cmd->se_dev;
>>
>>         /*
>>          * Clear a lun set in the cdb if the initiator talking to use spoke
>> @@ -1076,6 +1077,32 @@ passthrough_parse_cdb(struct se_cmd *cmd,
>>                 return TCM_NO_SENSE;
>>         }
>>
>> +       /*
>> +        * For PERSISTENT RESERVE IN/OUT, RELEASE, and RESERVE we need to
>> +        * emulate the response, since tcmu does not have the information
>> +        * required to process these commands.
>> +        */
>> +       if (!(dev->transport->transport_flags &
>> +             TRANSPORT_FLAG_PASSTHROUGH_PGR)) {
>> +               if (cdb[0] == PERSISTENT_RESERVE_IN) {
>> +                       cmd->execute_cmd = target_scsi3_emulate_pr_in;
>> +                       return TCM_NO_SENSE;
>> +               }
>> +               if (cdb[0] == PERSISTENT_RESERVE_OUT) {
>> +                       cmd->execute_cmd = target_scsi3_emulate_pr_out;
>> +                       return TCM_NO_SENSE;
>> +               }
>> +
>> +               if (cdb[0] == RELEASE || cdb[0] == RELEASE_10) {
>> +                       cmd->execute_cmd = target_scsi2_reservation_release;
>> +                       return TCM_NO_SENSE;
>> +               }
>> +               if (cdb[0] == RESERVE || cdb[0] == RESERVE_10) {
>> +                       cmd->execute_cmd = target_scsi2_reservation_reserve;
>> +                       return TCM_NO_SENSE;
>> +               }
>> +       }
>> +
>>         /* Set DATA_CDB flag for ops that should have it */
>>         switch (cdb[0]) {
>>         case READ_6:
>> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
>> index e180511..129ca57 100644
>> --- a/drivers/target/target_core_pr.c
>> +++ b/drivers/target/target_core_pr.c
>> @@ -4147,7 +4147,7 @@ target_check_reservation(struct se_cmd *cmd)
>>                 return 0;
>>         if (dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE)
>>                 return 0;
>> -       if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)
>> +       if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
>>                 return 0;
>>
>>         spin_lock(&dev->dev_reservation_lock);
>> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
>> index 94cda79..8943a62 100644
>> --- a/drivers/target/target_core_pscsi.c
>> +++ b/drivers/target/target_core_pscsi.c
>> @@ -1081,7 +1081,8 @@ static const struct target_backend_ops pscsi_ops = {
>>         .name                   = "pscsi",
>>         .owner                  = THIS_MODULE,
>>         .transport_flags        = TRANSPORT_FLAG_PASSTHROUGH |
>> -                                 TRANSPORT_FLAG_PASSTHROUGH_ALUA,
>> +                                 TRANSPORT_FLAG_PASSTHROUGH_ALUA |
>> +                                 TRANSPORT_FLAG_PASSTHROUGH_PGR,
>>         .attach_hba             = pscsi_attach_hba,
>>         .detach_hba             = pscsi_detach_hba,
>>         .pmode_enable_hba       = pscsi_pmode_enable_hba,
>> diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
>> index 1b0f447..e475531 100644
>> --- a/include/target/target_core_backend.h
>> +++ b/include/target/target_core_backend.h
>> @@ -10,6 +10,7 @@
>>   * backend module.
>>   */
>>  #define TRANSPORT_FLAG_PASSTHROUGH_ALUA                0x2
>> +#define TRANSPORT_FLAG_PASSTHROUGH_PGR          0x4
>>
>>  struct request_queue;
>>  struct scatterlist;
>> --
>> 2.5.4 (Apple Git-61)
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe target-devel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
