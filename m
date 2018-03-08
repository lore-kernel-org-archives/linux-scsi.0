From: Wen Yang <wen.yang99@zte.com.cn>
Subject: [PATCH] scsi: Replace sdev_printk with printk_deferred to avoid
Date: Thu, 8 Mar 2018 16:50:06 +0800
Message-ID: <1520499006-19857-1-git-send-email-wen.yang99@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jiang.biao2@zte.com.cn, zhong.weidong@zte.com.cn, wen.yang99@zte.com.cn
List-Id: linux-scsi@vger.kernel.org

When scsi disks went wrong frequently, and with serial console 
attached, tasks may be blocked in the following flow for more than 10s:
[  557.369580]  <<EOE>>  [<ffffffff81309336>] blkcg_print_blkgs+0x76/0xf0   ----》 wait for blkg->q->queue_lock
[  557.369581]  [<ffffffff8130f236>] cfqg_print_rwstat_recursive+0x36/0x40
[  557.369583]  [<ffffffff81109393>] cgroup_seqfile_show+0x73/0x80
[  557.369584]  [<ffffffff81222b57>] ? seq_buf_alloc+0x17/0x40
[  557.369585]  [<ffffffff8122305a>] seq_read+0x10a/0x3b0
[  557.369586]  [<ffffffff811fe9be>] vfs_read+0x9e/0x170
[  557.369587]  [<ffffffff811ff58f>] SyS_read+0x7f/0xe0
[  557.369588]  [<ffffffff81697ac9>] system_call_fastpath+0x16/0x1b
That's  because the serial is very slow, and the other task hold the
q->queue_lock for very long time, waiting for the serial finishing 
writing.
PID: 319    TASK: ffff881ffb09edd0  CPU: 7   COMMAND: "kworker/u113:1"
...
 #4 [ffff881ffb0b7540] delay_tsc at ffffffff81326724
 #5 [ffff881ffb0b7548] __const_udelay at ffffffff81326678
 #6 [ffff881ffb0b7558] wait_for_xmitr at ffffffff814056e0
 #7 [ffff881ffb0b7580] serial8250_console_putchar at ffffffff814058ac
 #8 [ffff881ffb0b75a0] uart_console_write at ffffffff8140035a
 #9 [ffff881ffb0b75d0] serial8250_console_write at ffffffff814057fe
 #10 [ffff881ffb0b7618] call_console_drivers.constprop.17 at ffffffff81087011
 #11 [ffff881ffb0b7640] console_unlock at ffffffff810889e9
 #12 [ffff881ffb0b7680] vprintk_emit at ffffffff81088df4
 #13 [ffff881ffb0b76f0] dev_vprintk_emit at ffffffff81428e72
 #14 [ffff881ffb0b77a8] dev_printk_emit at ffffffff81428eee
 #15 [ffff881ffb0b7808] __dev_printk at ffffffff8142937e
 #16 [ffff881ffb0b7818] dev_printk at ffffffff8142942d
 #17 [ffff881ffb0b7888] sdev_prefix_printk at ffffffff81463771
 #18 [ffff881ffb0b7918] scsi_prep_state_check at ffffffff814598e4
 #19 [ffff881ffb0b7928] scsi_prep_fn at ffffffff8145992d
 #20 [ffff881ffb0b7960] blk_peek_request at ffffffff812f0826
 #21 [ffff881ffb0b7988] scsi_request_fn at ffffffff8145b588
 #22 [ffff881ffb0b79f0] __blk_run_queue at ffffffff812ebd63
 #23 [ffff881ffb0b7a08] blk_queue_bio at ffffffff812f1013        -----》acquired q->queue_lock and wait for console_write to finish
 #24 [ffff881ffb0b7a50] generic_make_request at ffffffff812ef209
 #25 [ffff881ffb0b7a98] submit_bio at ffffffff812ef351
 #26 [ffff881ffb0b7af0] xfs_submit_ioend_bio at ffffffffa0146a63 [xfs]
 #27 [ffff881ffb0b7b00] xfs_submit_ioend at ffffffffa0146b31 [xfs]
 #28 [ffff881ffb0b7b40] xfs_vm_writepages at ffffffffa0146e18 [xfs]
 #29 [ffff881ffb0b7bb8] do_writepages at ffffffff8118da6e

commit e480af09c49736848f749a43dff2c902104f6691 avoided the watchdog
trigger, but could not avoid tasks being blocked for long time.

This patch replacing the sdev_printk with async printk_deferred can
avoid task blocking because of the slow serial and unstable disks in
such senario. 

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Signed-off-by: Jiang Biao <jiang.biao2@zte.com.cn>
---
 drivers/scsi/scsi_lib.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a86df9c..2bbe34c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1297,8 +1297,10 @@ static int scsi_setup_cmnd(struct scsi_device *sdev, struct request *req)
 			 * commands.  The device must be brought online
 			 * before trying any recovery commands.
 			 */
-			sdev_printk(KERN_ERR, sdev,
-				    "rejecting I/O to offline device\n");
+			printk_deferred(KERN_ERR
+					"%s %s: rejecting I/O to offline device\n",
+					dev_driver_string(&sdev->sdev_gendev),
+					dev_name(&sdev->sdev_gendev));
 			ret = BLKPREP_KILL;
 			break;
 		case SDEV_DEL:
@@ -1306,8 +1308,10 @@ static int scsi_setup_cmnd(struct scsi_device *sdev, struct request *req)
 			 * If the device is fully deleted, we refuse to
 			 * process any commands as well.
 			 */
-			sdev_printk(KERN_ERR, sdev,
-				    "rejecting I/O to dead device\n");
+			printk_deferred(KERN_ERR
+					"%s %s: rejecting I/O to dead device\n",
+					dev_driver_string(&sdev->sdev_gendev),
+					dev_name(&sdev->sdev_gendev));
 			ret = BLKPREP_KILL;
 			break;
 		case SDEV_BLOCK:
@@ -1798,8 +1802,10 @@ static void scsi_request_fn(struct request_queue *q)
 			break;
 
 		if (unlikely(!scsi_device_online(sdev))) {
-			sdev_printk(KERN_ERR, sdev,
-				    "rejecting I/O to offline device\n");
+			printk_deferred(KERN_ERR
+					"%s %s: rejecting I/O to offline device\n",
+					dev_driver_string(&sdev->sdev_gendev),
+					dev_name(&sdev->sdev_gendev));
 			scsi_kill_request(req, q);
 			continue;
 		}
-- 
1.8.3.1
