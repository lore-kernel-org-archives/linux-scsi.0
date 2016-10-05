From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH] scsi: ufs: add support for BLKSECDISCARD
Date: Wed, 05 Oct 2016 10:40:58 -0700
Message-ID: <6d144790d772ee9cd84040a4cfb8198b@codeaurora.org>
References: <1469534210-4366-1-git-send-email-pawelx.wodkowski@intel.com>
 <4d1be162c6070166a4b6d6d6f96e5c45@codeaurora.org>
 <6284ADD9A1DC4F4183127093DD9ADA5F673C239A@IRSMSX106.ger.corp.intel.com>
 <FC1E60E8F450F44E9D257A008CFE06639B5F04@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59079 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932950AbcJERlB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Oct 2016 13:41:01 -0400
In-Reply-To: <FC1E60E8F450F44E9D257A008CFE06639B5F04@IRSMSX101.ger.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mielczarek, SzymonX" <szymonx.mielczarek@intel.com>
Cc: "Pielaszkiewicz, Tomasz" <tomasz.pielaszkiewicz@intel.com>, "Wodkowski, PawelX" <pawelx.wodkowski@intel.com>, linux-scsi@vger.kernel.org, Hunter@vger.kernel.org, "Hunter, Adrian" <adrian.hunter@intel.com>, Pielaszkiewicz@vger.kernel.org, Janca@vger.kernel.org, "Janca, Grzegorz" <grzegorz.janca@intel.com>, linux-scsi-owner@vger.kernel.org

Hi SzymonX,

On 2016-10-04 05:55, Mielczarek, SzymonX wrote:
> Hi Jadavani,
> 
> _> Did you mean sending purge when bProvisioningType is set to 02h
> (TPRZ = 0)? why do we want to send the purge if TPRZ is 1?_
> 
> By doing Purge we want to protect from die level attacks (JESD220B
> 12.2.3.3). Once Erase is enabled on partition, the Read will return
> zeros, however data can still reside in unmapped memory on flash
> (behind mapping/translation table) (12.2.2.2). We expose BLKSECDISCARD
> on "Erase enabled" partitions just to remove possibility on die level
> attacks.

Now it make sense, i wasn't expecting that this patch is to prevent die 
level attack. Do you want to make that explicit in the commit text?

> 
> Are you suggesting that this check is not required, and in any TPRZ
> (thus 02h and 03h) BLKSECDISCARD (this Purge) shall be enabled? That's
> also possible.

Yes, for BLKSECDISCARD, isn't it good to issue purge for TPRZ=0 
(bProvisioningType = 3) to make sure we can't read back data?

> 
> _> We had seen purge taking few mins to complete with some of the UFS
> device vendors._
> 
> _> Did you run any experiments to major the time taken for purge to
> complete?_
> 
> Yes, we did several experiments around Dec 2015, and the time of Purge
> operation with software overhead was varying between 100-500 seconds
> (!), with typical time approx. 350 seconds! We also consulted one
> vendor on this observation, and got response that Purge times over 1
> min are possible, depending on flash state.

That's true.
Purge time depends on flash state and it also varies a lot from vendor 
to vendor.
Anything over a min may not be good for user experience (especially for 
mobile) and user may simply abort (phone restart) thinking that device 
isn't stuck.

> 
> BR,
> 
> Szymon
> 
> -----Original Message-----
> From: Pielaszkiewicz, Tomasz
> Sent: Tuesday, October 4, 2016 1:41 PM
> To: subhashj@codeaurora.org; Wodkowski, PawelX
> <pawelx.wodkowski@intel.com>; Mielczarek, SzymonX
> <szymonx.mielczarek@intel.com>
> Cc: linux-scsi@vger.kernel.org; Hunter@vger.kernel.org; Hunter, Adrian
> <adrian.hunter@intel.com>; Pielaszkiewicz@vger.kernel.org;
> Janca@vger.kernel.org; Janca, Grzegorz <grzegorz.janca@intel.com>;
> linux-scsi-owner@vger.kernel.org
> Subject: RE: [PATCH] scsi: ufs: add support for BLKSECDISCARD
> 
> Hi,
> 
> Adding Szymon, who took over Pawel's work.
> 
> Tomek
> 
> -----Original Message-----
> 
> From: subhashj@codeaurora.org [mailto:subhashj@codeaurora.org]
> 
> Sent: Tuesday, September 27, 2016 10:18 PM
> 
> To: Wodkowski, PawelX
> 
> Cc: linux-scsi@vger.kernel.org; Hunter@vger.kernel.org; Hunter,
> Adrian; Pielaszkiewicz@vger.kernel.org; Pielaszkiewicz, Tomasz;
> Janca@vger.kernel.org; Janca, Grzegorz;
> linux-scsi-owner@vger.kernel.org
> 
> Subject: Re: [PATCH] scsi: ufs: add support for BLKSECDISCARD
> 
> Hi Pawel,
> 
> Please find some comments inline.
> 
> On 2016-07-26 04:56, Pawel Wodkowski wrote:
> 
>> Add BLKSECDISCAD feature support if LU is provisioned for TPRZ
> 
>> (bProvisioningType = 3).
> 
> Did you mean sending purge when bProvisioningType is set to 02h (TPRZ
> = 0)? why do we want to send the purge if TPRZ is 1?
> 
>> 
> 
>> To perform BLKSECDISCAD driver issue purge operation after each
> 
>> discard SCSI command with REQ_SECURE flag set, and delay calling
> 
>> scsi_done() till purge finish. This operation might long so block
> 
>> requests from SCSI layer in ufshcd_queueucommand() and then unblock
> it
> 
>> after purge finish.
> 
> We had seen purge taking few mins to complete with some of the UFS
> device vendors.
> 
> Did you run any experiments to major the time taken for purge to
> complete?
> 
>> 
> 
>> Signed-off-by: Pawel Wodkowski <pawelx.wodkowski@intel.com>
> 
>> ---
> 
>>  drivers/scsi/ufs/ufs.h    |  19 +++++
> 
>>  drivers/scsi/ufs/ufshcd.c | 187
> 
>> +++++++++++++++++++++++++++++++++++++++++++++-
> 
>>  drivers/scsi/ufs/ufshcd.h |   6 ++
> 
>>  3 files changed, 208 insertions(+), 4 deletions(-)
> 
>> 
> 
>> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h index
> 
>> b291fa6ed2ad..2f769974fda1 100644
> 
>> --- a/drivers/scsi/ufs/ufs.h
> 
>> +++ b/drivers/scsi/ufs/ufs.h
> 
>> @@ -132,12 +132,14 @@ enum flag_idn {
> 
>>             QUERY_FLAG_IDN_FDEVICEINIT      = 0x01,
> 
>>             QUERY_FLAG_IDN_PWR_ON_WPE         = 0x03,
> 
>>             QUERY_FLAG_IDN_BKOPS_EN         = 0x04,
> 
>> +          QUERY_FLAG_IDN_PURGE_EN         = 0x06,
> 
>>  };
> 
>> 
> 
>>  /* Attribute idn for Query requests */  enum attr_idn {
> 
>>             QUERY_ATTR_IDN_ACTIVE_ICC_LVL      = 0x03,
> 
>>             QUERY_ATTR_IDN_BKOPS_STATUS        = 0x05,
> 
>> +          QUERY_ATTR_IDN_PURGE_STATUS       = 0x06,
> 
>>             QUERY_ATTR_IDN_EE_CONTROL             = 0x0D,
> 
>>             QUERY_ATTR_IDN_EE_STATUS = 0x0E,
> 
>>  };
> 
>> @@ -247,6 +249,13 @@ enum {
> 
>>             UFSHCD_AMP                   = 3,
> 
>>  };
> 
>> 
> 
>> +/* Provisioning type */
> 
>> +enum unit_desc_param_provisioning_type {
> 
>> +          THIN_PROVISIONING_DISABLED                              =
> 0x00,
> 
>> +          THIN_PROVISIONING_ENABLED_TPRZ_0             = 0x02,
> 
>> +          THIN_PROVISIONING_ENABLED_TPRZ_1             = 0x03,
> 
>> +};
> 
>> +
> 
>>  #define POWER_DESC_MAX_SIZE
> 0x62
> 
>>  #define POWER_DESC_MAX_ACTV_ICC_LVLS
> 16
> 
>> 
> 
>> @@ -279,6 +288,16 @@ enum bkops_status {
> 
>>             BKOPS_STATUS_MAX                   =
> BKOPS_STATUS_CRITICAL,
> 
>>  };
> 
>> 
> 
>> +/* Purge operation status */
> 
>> +enum purge_status {
> 
>> +          PURGE_STATUS_IDLE             = 0x0,
> 
>> +          PURGE_STATUS_IN_PROGRESS      = 0x1,
> 
>> +          PURGE_STATUS_STOP_BY_HOST     = 0x2,
> 
>> +          PURGE_STATUS_SUCCESS          = 0x3,
> 
>> +          PURGE_STATUS_QUEUE_NOT_EMPTY  = 0x4,
> 
>> +          PURGE_STATUS_GENERAL_FAIL     = 0x5
> 
>> +};
> 
>> +
> 
>>  /* UTP QUERY Transaction Specific Fields OpCode */  enum
> query_opcode
> 
>> {
> 
>>             UPIU_QUERY_OPCODE_NOP                     = 0x0,
> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> 
>> index f8fa72c31a9d..4ca15a6f294c 100644
> 
>> --- a/drivers/scsi/ufs/ufshcd.c
> 
>> +++ b/drivers/scsi/ufs/ufshcd.c
> 
>> @@ -70,6 +70,9 @@
> 
>>  /* Task management command timeout */
> 
>>  #define TM_CMD_TIMEOUT 100 /* msecs */
> 
>> 
> 
>> +/* Purge operation timeout */
> 
>> +#define PURGE_TIMEOUT 9000 /* msecs */
> 
>> +
> 
>>  /* maximum number of retries for a general UIC command  */  #define
> 
> 
>> UFS_UIC_COMMAND_RETRIES 3
> 
>> 
> 
>> @@ -1382,11 +1385,13 @@ static int ufshcd_queuecommand(struct
> 
>> Scsi_Host *host, struct scsi_cmnd *cmd)
> 
>>             struct ufshcd_lrb *lrbp;
> 
>>             struct ufs_hba *hba;
> 
>>             unsigned long flags;
> 
>> +          bool secure;
> 
>>             int tag;
> 
>>             int err = 0;
> 
>> 
> 
>>             hba = shost_priv(host);
> 
>> 
> 
>> +          secure = !!(cmd->request->cmd_flags & REQ_SECURE);
> 
>>             tag = cmd->request->tag;
> 
>>             if (!ufshcd_valid_tag(hba, tag)) {
> 
>>                             dev_err(hba->dev,
> 
>> @@ -1420,6 +1425,17 @@ static int ufshcd_queuecommand(struct
> Scsi_Host
> 
>> *host, struct scsi_cmnd *cmd)
> 
>>                             cmd->scsi_done(cmd);
> 
>>                             goto out_unlock;
> 
>>             }
> 
>> +
> 
>> +          if (secure) {
> 
>> +                          if (hba->is_purge_in_progress) {
> 
>> +                                          secure = false;
> 
>> +                                          err =
> SCSI_MLQUEUE_HOST_BUSY;
> 
>> +                                          goto out_unlock;
> 
>> +                          }
> 
>> +
> 
>> +                          hba->is_purge_in_progress = true;
> 
>> +          }
> 
>> +
> 
>>             spin_unlock_irqrestore(hba->host->host_lock, flags);
> 
>> 
> 
>>             /* acquire the tag to make sure device cmds don't use it
> */ @@
> 
>> -1465,9 +1481,19 @@ static int ufshcd_queuecommand(struct Scsi_Host
> 
>> *host, struct scsi_cmnd *cmd)
> 
>>             /* issue command to the controller */
> 
>>             spin_lock_irqsave(hba->host->host_lock, flags);
> 
>>             ufshcd_send_command(hba, tag);
> 
>> +
> 
>> +          if (secure) {
> 
>> +                          hba->purge_timeout = jiffies +
> msecs_to_jiffies(PURGE_TIMEOUT);
> 
>> +
> 
>> +                          scsi_block_requests(hba->host);
> 
>> +          }
> 
>> +
> 
>>  out_unlock:
> 
>>             spin_unlock_irqrestore(hba->host->host_lock, flags);
> 
>>  out:
> 
>> +          if (err && secure && hba->is_purge_in_progress)
> 
>> +                          hba->is_purge_in_progress = false;
> 
>> +
> 
>>             return err;
> 
>>  }
> 
>> 
> 
>> @@ -1641,7 +1667,7 @@ static inline void
> ufshcd_put_dev_cmd_tag(struct
> 
>> ufs_hba *hba, int tag)
> 
>>   * ufshcd_exec_dev_cmd - API for sending device management requests
> 
> 
>>   * @hba - UFS hba
> 
>>   * @cmd_type - specifies the type (NOP, Query...)
> 
>> - * @timeout - time in seconds
> 
>> + * @timeout - time in miliseconds
> 
>>   *
> 
>>   * NOTE: Since there is only one available tag for device
> management
> 
>> commands,
> 
>>   * it is expected you hold the hba->dev_cmd.lock mutex.
> 
>> @@ -3306,6 +3332,18 @@ static int ufshcd_change_queue_depth(struct
> 
>> scsi_device *sdev, int depth)  static int
> 
>> ufshcd_slave_configure(struct scsi_device *sdev)  {
> 
>>             struct request_queue *q = sdev->request_queue;
> 
>> +          struct ufs_hba *hba = shost_priv(sdev->host);
> 
>> +          u8 provisioning_type;
> 
>> +          int err;
> 
>> +
> 
>> +          /* Check Provisioning type for this LUN.For TPRZ_1 set
> secure flag.
> 
>> */
> 
>> +          err = ufshcd_read_unit_desc_param(hba,
> 
>> +
> ufshcd_scsi_to_upiu_lun(sdev->lun),
> 
>> +
> UNIT_DESC_PARAM_PROVISIONING_TYPE,
> 
>> +                                          &provisioning_type, 1);
> 
>> +
> 
>> +          if (!err && provisioning_type ==
> THIN_PROVISIONING_ENABLED_TPRZ_1)
> 
>> +
> queue_flag_set_unlocked(QUEUE_FLAG_SECDISCARD, q);
> 
>> 
> 
>>             blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD -
> 1);
> 
>>             blk_queue_max_segment_size(q, PRDT_DATA_BYTE_COUNT_MAX);
> @@ -3536,9
> 
>> +3574,16 @@ static void __ufshcd_transfer_req_compl(struct
> 
>> ufs_hba *hba,
> 
>>                                             /* Mark completed
> command as NULL in LRB */
> 
>>                                             lrbp->cmd = NULL;
> 
>>                                             clear_bit_unlock(index,
> &hba->lrb_in_use);
> 
>> -                                           /* Do not touch lrbp
> after scsi done */
> 
>> -                                           cmd->scsi_done(cmd);
> 
>> -                                           __ufshcd_release(hba);
> 
>> +
> 
>> +                                          if
> (!(cmd->request->cmd_flags & REQ_SECURE)) {
> 
>> +                                                          /* Do not
> touch lrbp after scsi done */
> 
>> +
> cmd->scsi_done(cmd);
> 
>> +
> __ufshcd_release(hba);
> 
>> +                                          } else {
> 
>> +                                                          /*
> Schedule purge */
> 
>> +
> hba->purge_cmd = cmd;
> 
>> +
> schedule_delayed_work(&hba->purge_work, 1);
> 
>> +                                          }
> 
>>                             } else if (lrbp->command_type ==
> UTP_CMD_TYPE_DEV_MANAGE) {
> 
>>                                             if
> (hba->dev_cmd.complete)
> 
>> 
> complete(hba->dev_cmd.complete);
> 
>> @@ -4162,6 +4207,139 @@ static void ufshcd_check_errors(struct
> ufs_hba
> 
>> *hba)
> 
>>  }
> 
>> 
> 
>>  /**
> 
>> +* ufshcd_purge_handler - Issue purge operation after discard.
> 
>> +* @work: pointer to work structure
> 
>> +*
> 
>> +* Phisically remove all unmapped address space by seting
> fPurgeEnable
> 
>> and
> 
>> +* waiting operation to complete. SCSI command that issued purge
> will
> 
>> be blocked
> 
>> +* till this work finish. In case of error command result is
> 
>> overwritten by
> 
>> +* proper host byte error code. In all scenarios, when work is done
> 
>> scsi_done()
> 
>> +* is called to finish SCSI command.
> 
>> +*/
> 
>> +static void ufshcd_purge_handler(struct work_struct *work) {
> 
>> +          struct ufs_hba *hba = container_of(work, struct ufs_hba,
> 
>> +                                          purge_work.work);
> 
>> +          u32 next_purge_status = hba->purge_status;
> 
>> +          unsigned long delay_time = msecs_to_jiffies(20);
> 
>> +          int err = 0;
> 
>> +          int host_byte = 0;
> 
>> +          bool done = false;
> 
>> +
> 
>> +          WARN(!hba->is_purge_in_progress,
> 
>> +                                          "PURGE: Invalid state -
> purge not in progress\n");
> 
>> +
> 
>> +          if (hba->purge_status == PURGE_STATUS_IN_PROGRESS) {
> 
>> +                          err = ufshcd_query_attr_retry(hba,
> 
>> +
> UPIU_QUERY_OPCODE_READ_ATTR,
> 
>> +
> QUERY_ATTR_IDN_PURGE_STATUS, 0, 0,
> 
>> +
> &next_purge_status);
> 
>> +                          /*
> 
>> +                          * In case of err assume operation is
> still in progress.
> 
>> +                          * If error keep showing timout will
> eventualy kill purge.
> 
>> +                          */
> 
>> +                          if (err) {
> 
>> +                                          dev_dbg(hba->dev, "%s:
> failed to get purge status - assuming still
> 
>> in progress\n",
> 
>> +
> __func__);
> 
>> +                                          delay_time =
> msecs_to_jiffies(100);
> 
>> +                          }
> 
>> +
> 
>> +                          WARN(hba->purge_status ==
> PURGE_STATUS_IN_PROGRESS &&
> 
>> +                                          next_purge_status ==
> PURGE_STATUS_IDLE,
> 
>> +                                          "Invalid purge state:
> IDLE\n");
> 
>> +
> 
>> +                          /*
> 
>> +                          * This is not required but if something
> bad happen
> 
>> +                          * (ex card reset) we want to inform upper
> layer that
> 
>> +                          * purge might not be completed.
> 
>> +                          */
> 
>> +                          if (next_purge_status ==
> PURGE_STATUS_IDLE) {
> 
>> +                                          host_byte = DID_ERROR;
> 
>> +                                          done = true;
> 
>> +                          }
> 
>> +          } else if (hba->purge_cmd->result & 0xffff0000) {
> 
>> +                          /*
> 
>> +                          *  Don't issue purge if discard failed.
> Also don't touch cmd's
> 
>> +                          * error code.
> 
>> +                          */
> 
>> +                          next_purge_status =
> PURGE_STATUS_GENERAL_FAIL;
> 
>> +                          host_byte = 0;
> 
>> +                          done = true;
> 
>> +
> 
>> +          } else {
> 
>> +                          err = ufshcd_query_flag(hba,
> UPIU_QUERY_OPCODE_SET_FLAG,
> 
>> +
> QUERY_FLAG_IDN_PURGE_EN, NULL);
> 
>> +
> 
>> +                          if (err) {
> 
>> +                                          dev_err(hba->dev, "%s:
> flag set error (err=%d).\n",
> 
>> +                                                          __func__,
> err);
> 
>> +                                          next_purge_status =
> PURGE_STATUS_GENERAL_FAIL;
> 
>> +                                          host_byte = DID_ERROR;
> 
>> +                                          done = true;
> 
>> +                          } else {
> 
>> +                                          /* Some devices are
> timing out while checking purge
> 
>> +                                          * status just after
> setting fPurgeEnable flag. For them
> 
>> +                                          * assume purge is in
> progress. This will be validated
> 
>> +                                          * in next turn. Also give
> a little more time for
> 
>> +                                          * houskeeping.
> 
>> +                                          */
> 
>> +                                          dev_dbg(hba->dev, "%s:
> Purge started.\n", __func__);
> 
>> +                                          next_purge_status =
> PURGE_STATUS_IN_PROGRESS;
> 
>> +                                          delay_time =
> msecs_to_jiffies(100);
> 
>> +                          }
> 
>> +          }
> 
>> +
> 
>> +          if (!done) {
> 
>> +                          switch (next_purge_status) {
> 
>> +                          case PURGE_STATUS_QUEUE_NOT_EMPTY:
> 
>> +                                          /* This is retry
> condition */
> 
>> +                                          delay_time = 1;
> 
>> +                                          break;
> 
>> +
> 
>> +                          case PURGE_STATUS_IN_PROGRESS:
> 
>> +                                          break;
> 
>> +                          case PURGE_STATUS_SUCCESS:
> 
>> +                                          done = true;
> 
>> +                                          break;
> 
>> +                          default:
> 
>> +                                          /* Every other condition
> is a failure */
> 
>> +                                          host_byte = DID_ERROR;
> 
>> +                                          done = true;
> 
>> +                          }
> 
>> +          }
> 
>> +
> 
>> +          /*
> 
>> +          * If purge timeous out then finish SCSI command with
> error. If
> 
>> device
> 
>> +          * is still really doing purge, it will finish in
> background and all
> 
>> +          * further SCSI commands will fail till that moment.
> 
>> +          */
> 
>> +          if (!done && time_after(jiffies, hba->purge_timeout)) {
> 
>> +                          host_byte = DID_TIME_OUT;
> 
>> +                          next_purge_status =
> PURGE_STATUS_GENERAL_FAIL;
> 
>> +                          done = true;
> 
>> +          }
> 
>> +
> 
>> +          if (done) {
> 
>> +                          if (host_byte)
> 
>> +                                          hba->purge_cmd->result =
> host_byte;
> 
>> +
> 
>> +
> hba->purge_cmd->scsi_done(hba->purge_cmd);
> 
>> +                          hba->purge_cmd = NULL;
> 
>> +                          hba->is_purge_in_progress = false;
> 
>> +                          ufshcd_release(hba);
> 
>> +                          scsi_unblock_requests(hba->host);
> 
>> +
> 
>> +                          dev_dbg(hba->dev, "%s: purge %s\n",
> __func__,
> 
>> +                                          next_purge_status ==
> PURGE_STATUS_SUCCESS ?
> 
>> +
>       "done" : "failed");
> 
>> +          } else
> 
>> +                          schedule_delayed_work(&hba->purge_work,
> delay_time);
> 
>> +
> 
>> +          hba->purge_status = next_purge_status; }
> 
>> +
> 
>> +
> 
>> +/**
> 
>>   * ufshcd_tmc_handler - handle task management function completion
> 
>>   * @hba: per adapter instance
> 
>>   */
> 
>> @@ -6440,6 +6618,7 @@ int ufshcd_init(struct ufs_hba *hba, void
> 
>> __iomem *mmio_base, unsigned int irq)
> 
>>             /* Initialize work queues */
> 
>>             INIT_WORK(&hba->eh_work, ufshcd_err_handler);
> 
>>             INIT_WORK(&hba->eeh_work,
> ufshcd_exception_event_handler);
> 
>> +          INIT_DELAYED_WORK(&hba->purge_work,
> ufshcd_purge_handler);
> 
>> 
> 
>>             /* Initialize UIC command mutex */
> 
>>             mutex_init(&hba->uic_cmd_mutex);
> 
>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> 
>> index 4bb65669f052..c8462fac54eb 100644
> 
>> --- a/drivers/scsi/ufs/ufshcd.h
> 
>> +++ b/drivers/scsi/ufs/ufshcd.h
> 
>> @@ -545,6 +545,12 @@ struct ufs_hba {
> 
>> 
> 
>>             enum bkops_status urgent_bkops_lvl;
> 
>>             bool is_urgent_bkops_lvl_checked;
> 
>> +
> 
>> +          unsigned long purge_timeout;
> 
>> +          bool is_purge_in_progress;
> 
>> +          enum purge_status purge_status;
> 
>> +          struct delayed_work purge_work;
> 
>> +          struct scsi_cmnd *purge_cmd;
> 
>>  };
> 
>> 
> 
>>  /* Returns true if clocks can be gated. Otherwise false */
> 
> ---------------------------------------------------------------------
> Intel Technology Poland sp. z o.o.
> ul. S&#322owackiego 173 | 80-298 Gda&#324sk | S&#261d Rejonowy
> Gda&#324sk P&#243&#322noc | VII Wydzia&#322 Gospodarczy Krajowego
> Rejestru S&#261dowego - KRS 101882 | NIP 957-07-52-316 | Kapita&#322
> zak&#322adowy 200.000 PLN.
> 
>  Ta wiadomo&#347&#263 wraz z za&#322&#261cznikami jest przeznaczona
> dla okre&#347lonego adresata i mo&#380e zawiera&#263 informacje
> poufne. W razie przypadkowego otrzymania tej wiadomo&#347ci, prosimy o
> powiadomienie nadawcy oraz trwa&#322e jej usuni&#281cie; jakiekolwiek
> przegl&#261danie lub rozpowszechnianie jest zabronione.
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). If you are not the intended
> recipient, please contact the sender and delete all copies; any review
> or distribution by others is strictly prohibited.

Thanks,
Subhash

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
