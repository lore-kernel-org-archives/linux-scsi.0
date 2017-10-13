From: "Ouyangzhaowei (Charles)" <ouyangzhaowei@huawei.com>
Subject: [RESEND PATCH] scsi: shost->async_scan should be protected by
 mutex_lock
Date: Fri, 13 Oct 2017 14:55:18 +0800
Message-ID: <aae2bdef-2c21-d97d-43f5-5aff2934e8a9@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Tyrel Datwyler <turtle.in.the.kernel@gmail.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Suoben <suoben@huawei.com>, "Wulizhen (Pss)" <pss.wulizhen@huawei.com>
List-Id: linux-scsi@vger.kernel.org

shost->async_scan should be protected by mutex_lock, otherwise the check
of "called twice" won't work.

Signed-off-by: Ouyang Zhaowei <ouyangzhaowei@huawei.com>
---
 drivers/scsi/scsi_scan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index fd88dab..20d539b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1722,9 +1722,10 @@ static struct async_scan_data
*scsi_prep_async_scan(struct Scsi_Host *shost)
        if (strncmp(scsi_scan_type, "sync", 4) == 0)
                return NULL;

+       mutex_lock(&shost->scan_mutex);
        if (shost->async_scan) {
                shost_printk(KERN_DEBUG, shost, "%s called twice\n",
__func__);
-               return NULL;
+               goto unlock;
        }

        data = kmalloc(sizeof(*data), GFP_KERNEL);
@@ -1735,7 +1736,6 @@ static struct async_scan_data
*scsi_prep_async_scan(struct Scsi_Host *shost)
                goto err;
        init_completion(&data->prev_finished);

-       mutex_lock(&shost->scan_mutex);
        spin_lock_irqsave(shost->host_lock, flags);
        shost->async_scan = 1;
        spin_unlock_irqrestore(shost->host_lock, flags);
@@ -1751,6 +1751,8 @@ static struct async_scan_data
*scsi_prep_async_scan(struct Scsi_Host *shost)

  err:
        kfree(data);
+ unlock:
+       mutex_unlock(&shost->scan_mutex);
        return NULL;
 }
