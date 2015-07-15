From: Kevin Groeneveld <kgroeneveld@lenbrook.com>
Subject: [PATCH] scsi: fix hang in scsi error handling
Date: Wed, 15 Jul 2015 08:47:29 -0400
Message-ID: <1436964449-31447-1-git-send-email-kgroeneveld@lenbrook.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.lenbrook.com ([206.191.95.214]:7925 "EHLO
	mail.lenbrook.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbbGOMyO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2015 08:54:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com
Cc: linux-scsi@vger.kernel.org, festevam@gmail.com, richard.zhu@freescale.com, arnd@arndb.de, linux@arm.linux.org.uk, Kevin Groeneveld <kgroeneveld@lenbrook.com>

With the following setup/steps I can consistently trigger the scsi host to
hang requiring a reboot:
1. iMX6Q processor with built in AHCI compatible SATA host
2. SATA port multiplier in CBS mode connected to iMX6Q
3. HDD connected to port multiplier
4. CDROM connected to port multiplier
5. trigger continuous I/O to HDD
6. repeatedly execute CDROM_DRIVE_STATUS ioctl on CDROM with no disc in
   drive

I don't think this issue is iMX6 specific but that is the only platform
I have duplicated the hang on.

To trigger the issue at least two CPU cores must be enabled and the HDD
access and CDROM ioctls must be happening concurrently. If I only enable
one CPU core the hang does not occur.

The following C program can be used to trigger the CDROM ioctl:

#include <stdio.h>
#include <fcntl.h>
#include <linux/cdrom.h>

int main(int argc, char* argv[])
{
	int fd;

	fd = open("/dev/cdrom", O_RDONLY | O_NONBLOCK);
	if(fd < 0)
	{
		perror("cannot open /dev/cdrom");
		return fd;
	}

	for(;;)
	{
		ioctl(fd, CDROM_DRIVE_STATUS, 0);
		usleep(100 * 1000);
	}
}

When the hang occurs shost->host_busy == 2 and shost->host_failed == 1 in
the scsi_eh_wakeup function. However this function only wakes the error
handler if host_busy == host_failed.

The patch changes the condition to test if host_busy >= host_failed and
updates the corresponding condition in scsi_error_handler. Without the
patch I can trigger the hang within seconds. With the patch I have not
duplicated the hang after hours of testing.

Signed-off-by: Kevin Groeneveld <kgroeneveld@lenbrook.com>
---
 drivers/scsi/scsi_error.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 106884a..853964b 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -61,7 +61,7 @@ static int scsi_try_to_abort_cmd(struct scsi_host_template *,
 /* called with shost->host_lock held */
 void scsi_eh_wakeup(struct Scsi_Host *shost)
 {
-	if (atomic_read(&shost->host_busy) == shost->host_failed) {
+	if (atomic_read(&shost->host_busy) >= shost->host_failed) {
 		trace_scsi_eh_wakeup(shost);
 		wake_up_process(shost->ehandler);
 		SCSI_LOG_ERROR_RECOVERY(5, shost_printk(KERN_INFO, shost,
@@ -2173,7 +2173,7 @@ int scsi_error_handler(void *data)
 	while (!kthread_should_stop()) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		if ((shost->host_failed == 0 && shost->host_eh_scheduled == 0) ||
-		    shost->host_failed != atomic_read(&shost->host_busy)) {
+		    shost->host_failed > atomic_read(&shost->host_busy)) {
 			SCSI_LOG_ERROR_RECOVERY(1,
 				shost_printk(KERN_INFO, shost,
 					     "scsi_eh_%d: sleeping\n",
-- 
1.7.4.1

