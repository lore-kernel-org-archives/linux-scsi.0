From: Dashi DS1 Cao <caods1@lenovo.com>
Subject: A bug in scsi_alloc_target of drivers/scsi/scsi_scan.c
Date: Tue, 9 May 2017 09:08:14 +0000
Message-ID: <23B7B563BA4E9446B962B142C86EF24A02D029C9@CNMAILEX03.lenovo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: zh-CN
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

When debugging a race condition in scsi_remove_target of 3.12, I ran into this possible bug within scsi_alloc_target.
When an existing "struct scsi_target" is found and used, the starget just got through kzmalloc should be freed, rather than dong a "put_device(dev)".

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 81d4151..96795d4 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -483,7 +483,7 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,

        spin_unlock_irqrestore(shost->host_lock, flags);
        if (ref_got) {
-               put_device(dev);
+               kfree(starget);
                return found_target;
        }
        /*
--

Dashi Cao
