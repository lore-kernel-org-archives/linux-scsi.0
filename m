From: John Garry <john.garry@huawei.com>
Subject: Re: [bug report] scsi: hisi_sas: add internal abort to
 hisi_sas_abort_task()
Date: Wed, 12 Oct 2016 18:01:04 +0800
Message-ID: <57FE09E0.9050801@huawei.com>
References: <20161012061225.GK12841@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:35845 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932485AbcJLKH6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Oct 2016 06:07:58 -0400
In-Reply-To: <20161012061225.GK12841@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-scsi@vger.kernel.org

On 12/10/2016 14:12, Dan Carpenter wrote:
> Hello John Garry,
>
> The patch dc8a49cabc73: "scsi: hisi_sas: add internal abort to
> hisi_sas_abort_task()" from Aug 24, 2016, leads to the following
> static checker warning:
>
> 	drivers/scsi/hisi_sas/hisi_sas_main.c:848 hisi_sas_abort_task()
> 	error: we previously assumed 'slot' could be null (see line 847)
>
> drivers/scsi/hisi_sas/hisi_sas_main.c
>     809          spin_unlock_irqrestore(&task->task_state_lock, flags);
>     810          sas_dev->dev_status = HISI_SAS_DEV_EH;
>     811          if (task->lldd_task && task->task_proto & SAS_PROTOCOL_SSP) {
>                      ^^^^^^^^^^^^^^^
> We assume that ->lldd_task can be NULL.
>
>     812                  struct scsi_cmnd *cmnd = task->uldd_task;
>     813                  struct hisi_sas_slot *slot = task->lldd_task;
>     814                  u32 tag = slot->idx;
>     815
>     816                  int_to_scsilun(cmnd->device->lun, &lun);
>     817                  tmf_task.tmf = TMF_ABORT_TASK;
>     818                  tmf_task.tag_of_task_to_be_managed = cpu_to_le16(tag);
>     819
>     820                  rc = hisi_sas_debug_issue_ssp_tmf(task->dev, lun.scsi_lun,
>     821                                                    &tmf_task);
>     822
>     823                  /* if successful, clear the task and callback forwards.*/
>     824                  if (rc == TMF_RESP_FUNC_COMPLETE) {
>     825                          if (task->lldd_task) {
>     826                                  struct hisi_sas_slot *slot;
>     827
>     828                                  slot = &hisi_hba->slot_info
>     829                                          [tmf_task.tag_of_task_to_be_managed];
>     830                                  spin_lock_irqsave(&hisi_hba->lock, flags);
>     831                                  hisi_hba->hw->slot_complete(hisi_hba, slot, 1);
>     832                                  spin_unlock_irqrestore(&hisi_hba->lock, flags);
>     833                          }
>     834                  }
>     835
>     836                  hisi_sas_internal_task_abort(hisi_hba, device,
>     837                                               HISI_SAS_INT_ABT_CMD, tag);
>     838          } else if (task->task_proto & SAS_PROTOCOL_SATA ||
>     839                  task->task_proto & SAS_PROTOCOL_STP) {
>     840                  if (task->dev->dev_type == SAS_SATA_DEV) {
>     841                          hisi_sas_internal_task_abort(hisi_hba, device,
>     842                                                       HISI_SAS_INT_ABT_DEV, 0);
>     843                          rc = TMF_RESP_FUNC_COMPLETE;
>     844                  }
>     845          } else if (task->task_proto & SAS_PROTOCOL_SMP) {
>     846                  /* SMP */
>     847                  struct hisi_sas_slot *slot = task->lldd_task;
>
> We assign it to slot.

I will check this.

Thanks,
John

>
>     848                  u32 tag = slot->idx;
>                                    ^^^^^^^^^
> slot dereferenced without checking.
>
>     849
>     850                  hisi_sas_internal_task_abort(hisi_hba, device,
>     851                                               HISI_SAS_INT_ABT_CMD, tag);
>     852          }
>
>
>
> regards,
> dan carpenter
>
> .
>


