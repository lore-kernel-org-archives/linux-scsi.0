From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v1] mpt3sas: Use driver scsi lookup to track outstanding
 IOs
Date: Tue, 26 Feb 2019 14:49:30 +0100
Message-ID: <0dfb09ca-8723-3a3c-a6a8-c643856c57e3@suse.de>
References: <1550751105-46065-1-git-send-email-sreekanth.reddy@broadcom.com>
 <d0672a75-2900-5f6b-368f-5808914322a8@suse.de>
 <CAK=zhgpuB9Y+Z1e64D1Dm4fJtJ2rjZPf5g_TLNwnKbauRpqrJQ@mail.gmail.com>
 <61a8f703-3f20-b777-08b9-54ae34dffa59@suse.de>
 <CAK=zhgrWWtCf+N7EmbhK69PEc2L0hfc8ybOyFddUed8yufhvJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------24537C9D0CDC54BB3BBA876A"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAK=zhgrWWtCf+N7EmbhK69PEc2L0hfc8ybOyFddUed8yufhvJQ@mail.gmail.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Sathya Prakash <Sathya.Prakash@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------24537C9D0CDC54BB3BBA876A
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/26/19 2:12 PM, Sreekanth Reddy wrote:
> On Tue, Feb 26, 2019 at 5:59 PM Hannes Reinecke <hare@suse.de> wrote:
>>
>> On 2/26/19 12:48 PM, Sreekanth Reddy wrote:
>>> On Tue, Feb 26, 2019 at 12:38 AM Hannes Reinecke <hare@suse.de> wrote:

[ .. ]
>>>
>>> Hannes,
>>>
>>> This API blk_mq_tagset_busy_iter() is not flexible to accommodate it
>>> into mpt3sas driver code. For example driver can’t exit from this API
>>> in-between if need, i.e. While processing Async Broadcast primitive
>>> event if host reset occurs then driver has to wait for this
>>> blk_mq_tagset_busy_iter() API to call the callback function for all
>>> the outstanding requests and no way to quit in-between.
>>>
>> This is actually not true; the return value from the iter function
>> determines if the loop should continue.
>> If the iter function returns false the loop will be terminated.
> 
> Oh ok I will look it again. Also I think this function can be used
> only if MQ is enabled, we can't use it in Non-MQ mode (as same fix
> need for stable kernels also).
> Driver's scsi lookup table mechanism works both in MQ & Non-MQ mode.
> 
> Also currently most of the customers are observing this issue with
> latest kernels as MQ is enabled by default and this fix is need very
> urgently.
> 
> Also in below thread we concluded that first we go with driver's scsi
> lookup table mechanism, as this fix is need very urgently and in pipe
> line we will work to use this  blk_mq_tagset_busy_iter() API.
> Here I am copying the Kashyap reply from below thread,
> "We will address this issue through <mpt3sas> driver changes in two steps.
> 1. I can use  driver's internal memory and will not rely on request/scsi
> command. Tag 0...depth loop  is not in main IO path, so what we need is
> contention free access of the list. Having driver's internal memory and
> array will provide that control.
> 2. As you suggested best way is to use busy tag iteration.  (only for blk-mq
> stack)"
> 
> https://patchwork.kernel.org/patch/10734933/
> 
Attached is a patch to demonstrate my approach.
I am aware that it'll only be useful for latest upstream where the 
legacy I/O path has been dropped completely, so we wouldn't need to 
worry about it.
For older releases indeed you would need to with something like your 
proposed patch, but for upstream I really would like to switch to
blk_mq_tagset_busy() iter.

Cheers,

Hannes

--------------24537C9D0CDC54BB3BBA876A
Content-Type: text/x-patch;
 name="0001-mpt3sas-use-blk_mq_tagset_busy_iter-to-iterate-comma.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-mpt3sas-use-blk_mq_tagset_busy_iter-to-iterate-comma.pa";
 filename*1="tch"

>From 15accbe5764884f11d0c65cd0d6c1a99513aba9a Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.com>
Date: Mon, 25 Feb 2019 20:57:18 +0100
Subject: [PATCH] mpt3sas: use blk_mq_tagset_busy_iter to iterate commands

Instead of blindly checking all possible commands one should be
using blk_mq_tagset_busy_iter() to traverse all active commands.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 262 +++++++++++++++++------------------
 1 file changed, 130 insertions(+), 132 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 8bb5b8f9f4d2..de165c19b53b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -4445,6 +4445,26 @@ static int _scsih_set_satl_pending(struct scsi_cmnd *scmd, bool pending)
 	return 0;
 }
 
+static bool _scsih_flush_running_cmds_iter(struct request *req, void *data, bool reserved)
+{
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
+	int count = *(int *)data;
+	struct scsiio_tracker *st;
+
+	count++;
+	_scsih_set_satl_pending(scmd, false);
+	st = scsi_cmd_priv(scmd);
+	mpt3sas_base_clear_st(ioc, st);
+	scsi_dma_unmap(scmd);
+	if (ioc->pci_error_recovery || ioc->remove_host)
+		scmd->result = DID_NO_CONNECT << 16;
+	else
+		scmd->result = DID_RESET << 16;
+	scmd->scsi_done(scmd);
+	return true;
+}
+
 /**
  * _scsih_flush_running_cmds - completing outstanding commands.
  * @ioc: per adapter object
@@ -4455,26 +4475,9 @@ static int _scsih_set_satl_pending(struct scsi_cmnd *scmd, bool pending)
 static void
 _scsih_flush_running_cmds(struct MPT3SAS_ADAPTER *ioc)
 {
-	struct scsi_cmnd *scmd;
-	struct scsiio_tracker *st;
-	u16 smid;
 	int count = 0;
 
-	for (smid = 1; smid <= ioc->scsiio_depth; smid++) {
-		scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
-		if (!scmd)
-			continue;
-		count++;
-		_scsih_set_satl_pending(scmd, false);
-		st = scsi_cmd_priv(scmd);
-		mpt3sas_base_clear_st(ioc, st);
-		scsi_dma_unmap(scmd);
-		if (ioc->pci_error_recovery || ioc->remove_host)
-			scmd->result = DID_NO_CONNECT << 16;
-		else
-			scmd->result = DID_RESET << 16;
-		scmd->scsi_done(scmd);
-	}
+	blk_mq_tagset_busy_iter(&ioc->shost->tag_set, _scsih_flush_running_cmds_iter, &count);
 	dtmprintk(ioc, ioc_info(ioc, "completing %d cmds\n", count));
 }
 
@@ -7280,6 +7283,105 @@ _scsih_sas_enclosure_dev_status_change_event(struct MPT3SAS_ADAPTER *ioc,
 	}
 }
 
+struct _scsih_query_and_abort_task_iter_data {
+	int query_count;
+	int termination_count;
+};
+
+static bool _scsih_query_and_abort_task_iter(struct request *req, void *data, bool reserved)
+{
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
+	struct scsiio_tracker *st = scsi_cmd_priv(scmd);
+	struct scsi_device *sdev = scmd->device;
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(sdev->host);
+	struct MPT3SAS_DEVICE *sas_device_priv_data = sdev->hostdata;
+	struct _scsih_query_and_abort_task_iter_data *iter_data = data;
+	Mpi2SCSITaskManagementReply_t *mpi_reply = ioc->tm_cmds.reply;
+	u16 ioc_status;
+	unsigned long flags;
+	u16 handle;
+	u32 lun;
+	u8 task_abort_retries;
+	int r;
+
+	if (!sas_device_priv_data || !sas_device_priv_data->sas_target)
+		return true;
+	/* skip hidden raid components */
+	if (sas_device_priv_data->sas_target->flags &
+	    MPT_TARGET_FLAGS_RAID_COMPONENT)
+		return true;
+	/* skip volumes */
+	if (sas_device_priv_data->sas_target->flags &
+	    MPT_TARGET_FLAGS_VOLUME)
+		return true;
+	/* skip PCIe devices */
+	if (sas_device_priv_data->sas_target->flags &
+	    MPT_TARGET_FLAGS_PCIE_DEVICE)
+		return true;
+
+	handle = sas_device_priv_data->sas_target->handle;
+	lun = sas_device_priv_data->lun;
+	iter_data->query_count++;
+
+	if (ioc->shost_recovery)
+		return false;
+
+	r = mpt3sas_scsih_issue_tm(ioc, handle, lun,
+				   MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK, st->smid,
+				   st->msix_io, 30, 0);
+	if (r == FAILED) {
+		sdev_printk(KERN_WARNING, sdev,
+			    "mpt3sas_scsih_issue_tm: FAILED when sending "
+			    "QUERY_TASK: scmd(%p)\n", scmd);
+		spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+		return false;
+	}
+	ioc_status = le16_to_cpu(mpi_reply->IOCStatus) & MPI2_IOCSTATUS_MASK;
+	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+		sdev_printk(KERN_WARNING, sdev,
+			    "query task: FAILED with IOCSTATUS(0x%04x), scmd(%p)\n",
+			    ioc_status, scmd);
+		return false;
+	}
+
+	/* see if IO is still owned by IOC and target */
+	if (mpi_reply->ResponseCode ==
+	    MPI2_SCSITASKMGMT_RSP_TM_SUCCEEDED ||
+	    mpi_reply->ResponseCode ==
+	    MPI2_SCSITASKMGMT_RSP_IO_QUEUED_ON_IOC) {
+		return true;;
+	}
+	task_abort_retries = 0;
+tm_retry:
+	if (task_abort_retries++ == 60) {
+		dewtprintk(ioc, ioc_info(ioc, "%s: ABORT_TASK: giving up\n",
+					 __func__));
+		return false;
+	}
+
+	if (ioc->shost_recovery)
+		return false;
+
+	r = mpt3sas_scsih_issue_tm(ioc, handle, sdev->lun,
+				   MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK, st->smid,
+				   st->msix_io, 30, 0);
+	if (r == FAILED || st->cb_idx != 0xFF) {
+		sdev_printk(KERN_WARNING, sdev,
+			    "mpt3sas_scsih_issue_tm: ABORT_TASK: FAILED : "
+			    "scmd(%p)\n", scmd);
+		goto tm_retry;
+	}
+
+	if (task_abort_retries > 1)
+		sdev_printk(KERN_WARNING, sdev,
+			    "mpt3sas_scsih_issue_tm: ABORT_TASK: RETRIES (%d):"
+			    " scmd(%p)\n",
+			    task_abort_retries - 1, scmd);
+
+	iter_data->termination_count += le32_to_cpu(mpi_reply->TerminationCount);
+	return true;
+}
+
 /**
  * _scsih_sas_broadcast_primitive_event - handle broadcast events
  * @ioc: per adapter object
@@ -7290,23 +7392,14 @@ static void
 _scsih_sas_broadcast_primitive_event(struct MPT3SAS_ADAPTER *ioc,
 	struct fw_event_work *fw_event)
 {
-	struct scsi_cmnd *scmd;
-	struct scsi_device *sdev;
-	struct scsiio_tracker *st;
-	u16 smid, handle;
-	u32 lun;
-	struct MPT3SAS_DEVICE *sas_device_priv_data;
-	u32 termination_count;
-	u32 query_count;
-	Mpi2SCSITaskManagementReply_t *mpi_reply;
 	Mpi2EventDataSasBroadcastPrimitive_t *event_data =
 		(Mpi2EventDataSasBroadcastPrimitive_t *)
 		fw_event->event_data;
-	u16 ioc_status;
-	unsigned long flags;
-	int r;
 	u8 max_retries = 0;
-	u8 task_abort_retries;
+	struct _scsih_query_and_abort_task_iter_data iter_data = {
+		.query_count = 0,
+		.termination_count = 0,
+	};
 
 	mutex_lock(&ioc->tm_cmds.mutex);
 	ioc_info(ioc, "%s: enter: phy number(%d), width(%d)\n",
@@ -7314,8 +7407,6 @@ _scsih_sas_broadcast_primitive_event(struct MPT3SAS_ADAPTER *ioc,
 
 	_scsih_block_io_all_device(ioc);
 
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	mpi_reply = ioc->tm_cmds.reply;
  broadcast_aen_retry:
 
 	/* sanity checks for retrying this loop */
@@ -7327,101 +7418,11 @@ _scsih_sas_broadcast_primitive_event(struct MPT3SAS_ADAPTER *ioc,
 			   ioc_info(ioc, "%s: %d retry\n",
 				    __func__, max_retries - 1));
 
-	termination_count = 0;
-	query_count = 0;
-	for (smid = 1; smid <= ioc->scsiio_depth; smid++) {
-		if (ioc->shost_recovery)
-			goto out;
-		scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
-		if (!scmd)
-			continue;
-		st = scsi_cmd_priv(scmd);
-		sdev = scmd->device;
-		sas_device_priv_data = sdev->hostdata;
-		if (!sas_device_priv_data || !sas_device_priv_data->sas_target)
-			continue;
-		 /* skip hidden raid components */
-		if (sas_device_priv_data->sas_target->flags &
-		    MPT_TARGET_FLAGS_RAID_COMPONENT)
-			continue;
-		 /* skip volumes */
-		if (sas_device_priv_data->sas_target->flags &
-		    MPT_TARGET_FLAGS_VOLUME)
-			continue;
-		 /* skip PCIe devices */
-		if (sas_device_priv_data->sas_target->flags &
-		    MPT_TARGET_FLAGS_PCIE_DEVICE)
-			continue;
-
-		handle = sas_device_priv_data->sas_target->handle;
-		lun = sas_device_priv_data->lun;
-		query_count++;
-
-		if (ioc->shost_recovery)
-			goto out;
-
-		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
-		r = mpt3sas_scsih_issue_tm(ioc, handle, lun,
-			MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK, st->smid,
-			st->msix_io, 30, 0);
-		if (r == FAILED) {
-			sdev_printk(KERN_WARNING, sdev,
-			    "mpt3sas_scsih_issue_tm: FAILED when sending "
-			    "QUERY_TASK: scmd(%p)\n", scmd);
-			spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-			goto broadcast_aen_retry;
-		}
-		ioc_status = le16_to_cpu(mpi_reply->IOCStatus)
-		    & MPI2_IOCSTATUS_MASK;
-		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
-			sdev_printk(KERN_WARNING, sdev,
-				"query task: FAILED with IOCSTATUS(0x%04x), scmd(%p)\n",
-				ioc_status, scmd);
-			spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-			goto broadcast_aen_retry;
-		}
-
-		/* see if IO is still owned by IOC and target */
-		if (mpi_reply->ResponseCode ==
-		     MPI2_SCSITASKMGMT_RSP_TM_SUCCEEDED ||
-		     mpi_reply->ResponseCode ==
-		     MPI2_SCSITASKMGMT_RSP_IO_QUEUED_ON_IOC) {
-			spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-			continue;
-		}
-		task_abort_retries = 0;
- tm_retry:
-		if (task_abort_retries++ == 60) {
-			dewtprintk(ioc,
-				   ioc_info(ioc, "%s: ABORT_TASK: giving up\n",
-					    __func__));
-			spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-			goto broadcast_aen_retry;
-		}
-
-		if (ioc->shost_recovery)
-			goto out_no_lock;
-
-		r = mpt3sas_scsih_issue_tm(ioc, handle, sdev->lun,
-			MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK, st->smid,
-			st->msix_io, 30, 0);
-		if (r == FAILED || st->cb_idx != 0xFF) {
-			sdev_printk(KERN_WARNING, sdev,
-			    "mpt3sas_scsih_issue_tm: ABORT_TASK: FAILED : "
-			    "scmd(%p)\n", scmd);
-			goto tm_retry;
-		}
-
-		if (task_abort_retries > 1)
-			sdev_printk(KERN_WARNING, sdev,
-			    "mpt3sas_scsih_issue_tm: ABORT_TASK: RETRIES (%d):"
-			    " scmd(%p)\n",
-			    task_abort_retries - 1, scmd);
-
-		termination_count += le32_to_cpu(mpi_reply->TerminationCount);
-		spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	}
-
+	if (ioc->shost_recovery)
+		goto out;
+	blk_mq_tagset_busy_iter(&ioc->shost->tag_set, _scsih_query_and_abort_task_iter, &iter_data);
+	if (ioc->shost_recovery)
+		goto out;
 	if (ioc->broadcast_aen_pending) {
 		dewtprintk(ioc,
 			   ioc_info(ioc,
@@ -7432,12 +7433,9 @@ _scsih_sas_broadcast_primitive_event(struct MPT3SAS_ADAPTER *ioc,
 	}
 
  out:
-	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
- out_no_lock:
-
 	dewtprintk(ioc,
 		   ioc_info(ioc, "%s - exit, query_count = %d termination_count = %d\n",
-			    __func__, query_count, termination_count));
+			    __func__, iter_data.query_count, iter_data.termination_count));
 
 	ioc->broadcast_aen_busy = 0;
 	if (!ioc->shost_recovery)
-- 
2.16.4


--------------24537C9D0CDC54BB3BBA876A--
