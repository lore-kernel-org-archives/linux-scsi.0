From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] libata test-unit-ready for ATAPI devices
Date: Wed, 16 Nov 2005 19:01:17 +0900
Message-ID: <20051116100117.GA22225@htj.dyndns.org>
References: <20051116044841.GA11722@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.200]:55691 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1030263AbVKPKBY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Nov 2005 05:01:24 -0500
Received: by zproxy.gmail.com with SMTP id q3so1626090nzb
        for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2005 02:01:23 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20051116044841.GA11722@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Nov 15, 2005 at 11:48:41PM -0500, Jeff Garzik wrote:
> 
> The following patch clears the "I was just reset" condition from an
> ATAPI device, and waits for it to come online, before continuing with
> the probe.
> 
> Not checking this into any upstream-bound branch, as I'm not yet
> convinced of its value.
> 

How about the following one?  It doesn't make libata wait for the
device to become ready before trying to configure ATA stuff.  It just
makes sr wait for the device to become ready before performing SCSI
configuration.  Maybe both are needed?

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index d68cea7..9656421 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -44,6 +44,7 @@
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/blkdev.h>
+#include <linux/delay.h>
 #include <asm/uaccess.h>
 
 #include <scsi/scsi.h>
@@ -721,14 +722,53 @@ Enomem:
 	goto out;
 }
 
-static void get_capabilities(struct scsi_cd *cd)
+static int initial_test_unit_ready(struct scsi_cd *cd)
 {
-	unsigned char *buffer;
-	struct scsi_mode_data data;
 	unsigned char cmd[MAX_COMMAND_SIZE];
 	struct scsi_sense_hdr sshdr;
 	unsigned int the_result;
-	int retries, rc, n;
+	int retries = 5, becoming_ready = 0, first_becoming_ready = 1;
+
+	memset((void *)cmd, 0, MAX_COMMAND_SIZE);
+	cmd[0] = TEST_UNIT_READY;
+
+	while (--retries) {
+		the_result = scsi_execute_req (cd->device, cmd, DMA_NONE, NULL,
+					       0, &sshdr, SR_TIMEOUT,
+					       MAX_RETRIES);
+
+		if (scsi_status_is_good(the_result))
+			return 0;
+
+		if (!scsi_sense_valid(&sshdr))
+			continue;
+
+		becoming_ready = sshdr.sense_key == NOT_READY &&
+			sshdr.asc == 0x04 && sshdr.ascq == 0x01;
+
+		if (becoming_ready) {
+			if (first_becoming_ready) {
+				printk("%s: device is becoming ready, please "
+				       "be patient\n", cd->cdi.name);
+				retries = 30;	/* 15secs */
+				first_becoming_ready = 0;
+			}
+			msleep(500);
+		} else if (sshdr.sense_key != UNIT_ATTENTION)
+			break;
+	}
+
+	if (becoming_ready)
+		printk(KERN_WARNING "%s: device failed to become ready\n",
+		       cd->cdi.name);
+	return -1;
+}
+
+static void get_capabilities(struct scsi_cd *cd)
+{
+	unsigned char *buffer;
+	struct scsi_mode_data data;
+	int rc, n;
 
 	static char *loadmech[] =
 	{
@@ -750,23 +790,8 @@ static void get_capabilities(struct scsi
 		return;
 	}
 
-	/* issue TEST_UNIT_READY until the initial startup UNIT_ATTENTION
-	 * conditions are gone, or a timeout happens
-	 */
-	retries = 0;
-	do {
-		memset((void *)cmd, 0, MAX_COMMAND_SIZE);
-		cmd[0] = TEST_UNIT_READY;
-
-		the_result = scsi_execute_req (cd->device, cmd, DMA_NONE, NULL,
-					       0, &sshdr, SR_TIMEOUT,
-					       MAX_RETRIES);
-
-		retries++;
-	} while (retries < 5 && 
-		 (!scsi_status_is_good(the_result) ||
-		  (scsi_sense_valid(&sshdr) &&
-		   sshdr.sense_key == UNIT_ATTENTION)));
+	/* test for readiness */
+	initial_test_unit_ready(cd);
 
 	/* ask for mode page 0x2a */
 	rc = scsi_mode_sense(cd->device, 0, 0x2a, buffer, 128,
diff --git a/include/linux/libata.h b/include/linux/libata.h

