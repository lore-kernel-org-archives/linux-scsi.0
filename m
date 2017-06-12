From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v5 03/23] scsi: hisi_sas: optimise the usage of
 hisi_hba.lock
Date: Mon, 12 Jun 2017 09:26:28 +0100
Message-ID: <aec6fd20-3b7c-0684-7e49-57ff61de6064@huawei.com>
References: <201706110427.UEjoe6NO%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201706110427.UEjoe6NO%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linuxarm@huawei.com, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hch@infradead.org, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On 10/06/2017 21:44, kbuild test robot wrote:
> Hi Xiang,
>
> [auto build test WARNING on mkp-scsi/for-next]
> [also build test WARNING on v4.12-rc4 next-20170609]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/John-Garry/hisi_sas-hip08-support/20170611-014437
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
>
>
> coccinelle warnings: (new ones prefixed by >>)
>
>>> drivers/scsi/hisi_sas/hisi_sas_main.c:1208:1-18: ERROR: nested lock+irqsave that reuses flags from line 1178.
>
> vim +1208 drivers/scsi/hisi_sas/hisi_sas_main.c
>
> bf95e9ccc Xiang Chen 2017-06-09  1172  	if (rc) {
> bf95e9ccc Xiang Chen 2017-06-09  1173  		spin_unlock_irqrestore(&hisi_hba->lock, flags);
> 441c27401 John Garry 2016-08-24  1174  		goto err_out;
> bf95e9ccc Xiang Chen 2017-06-09  1175  	}
> bf95e9ccc Xiang Chen 2017-06-09  1176  	spin_unlock_irqrestore(&hisi_hba->lock, flags);
> bf95e9ccc Xiang Chen 2017-06-09  1177
> bf95e9ccc Xiang Chen 2017-06-09 @1178  	spin_lock_irqsave(&dq->lock, flags);
> bf95e9ccc Xiang Chen 2017-06-09  1179  	rc = hisi_hba->hw->get_free_slot(hisi_hba, dq);
> 441c27401 John Garry 2016-08-24  1180  	if (rc)
> 441c27401 John Garry 2016-08-24  1181  		goto err_out_tag;
> 441c27401 John Garry 2016-08-24  1182
> bf95e9ccc Xiang Chen 2017-06-09  1183  	dlvry_queue = dq->id;
> bf95e9ccc Xiang Chen 2017-06-09  1184  	dlvry_queue_slot = dq->wr_point;
> bf95e9ccc Xiang Chen 2017-06-09  1185
> 441c27401 John Garry 2016-08-24  1186  	slot = &hisi_hba->slot_info[slot_idx];
> 441c27401 John Garry 2016-08-24  1187  	memset(slot, 0, sizeof(struct hisi_sas_slot));
> 441c27401 John Garry 2016-08-24  1188
> 441c27401 John Garry 2016-08-24  1189  	slot->idx = slot_idx;
> 441c27401 John Garry 2016-08-24  1190  	slot->n_elem = n_elem;
> 441c27401 John Garry 2016-08-24  1191  	slot->dlvry_queue = dlvry_queue;
> 441c27401 John Garry 2016-08-24  1192  	slot->dlvry_queue_slot = dlvry_queue_slot;
> 441c27401 John Garry 2016-08-24  1193  	cmd_hdr_base = hisi_hba->cmd_hdr[dlvry_queue];
> 441c27401 John Garry 2016-08-24  1194  	slot->cmd_hdr = &cmd_hdr_base[dlvry_queue_slot];
> 441c27401 John Garry 2016-08-24  1195  	slot->task = task;
> 441c27401 John Garry 2016-08-24  1196  	slot->port = port;
> 441c27401 John Garry 2016-08-24  1197  	task->lldd_task = slot;
> 441c27401 John Garry 2016-08-24  1198
> 441c27401 John Garry 2016-08-24  1199  	memset(slot->cmd_hdr, 0, sizeof(struct hisi_sas_cmd_hdr));
> 441c27401 John Garry 2016-08-24  1200
> 441c27401 John Garry 2016-08-24  1201  	rc = hisi_sas_task_prep_abort(hisi_hba, slot, device_id,
> 441c27401 John Garry 2016-08-24  1202  				      abort_flag, task_tag);
> 441c27401 John Garry 2016-08-24  1203  	if (rc)
> 441c27401 John Garry 2016-08-24  1204  		goto err_out_tag;
> 441c27401 John Garry 2016-08-24  1205
> 405314df5 John Garry 2017-03-23  1206
> 405314df5 John Garry 2017-03-23  1207  	list_add_tail(&slot->entry, &sas_dev->list);
> 54c9dd2d2 John Garry 2017-03-23 @1208  	spin_lock_irqsave(&task->task_state_lock, flags);

I don't think that reusing flags variable is in error, as there would be 
no nested spinlock at this point within the function.

If it is not recommended or not permitted to reuse flags variable for 
separate spinlocks, then that can be changed - I don't know.

John

> 441c27401 John Garry 2016-08-24  1209  	task->task_state_flags |= SAS_TASK_AT_INITIATOR;
> 54c9dd2d2 John Garry 2017-03-23  1210  	spin_unlock_irqrestore(&task->task_state_lock, flags);
> 441c27401 John Garry 2016-08-24  1211
>
> :::::: The code at line 1208 was first introduced by commit
> :::::: 54c9dd2d26d0951891516a956893428feb9aea17 scsi: hisi_sas: fix some sas_task.task_state_lock locking
>
> :::::: TO: John Garry <john.garry@huawei.com>
> :::::: CC: Martin K. Petersen <martin.petersen@oracle.com>
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
>
> .
>
