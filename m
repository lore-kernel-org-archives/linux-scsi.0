Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56AA1C433DB
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 09:09:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20EFD64E4B
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 09:09:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbhB1JJE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Feb 2021 04:09:04 -0500
Received: from authsmtp20.register.it ([81.88.48.43]:51219 "EHLO
        authsmtp.register.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230075AbhB1JJE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Feb 2021 04:09:04 -0500
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Feb 2021 04:09:03 EST
Received: from [192.168.43.2] ([151.47.221.112])
        by cmsmtp with ESMTPSA
        id GHxUlYwKnh1v8GHxUlnH8X; Sun, 28 Feb 2021 10:01:49 +0100
X-Rid:  guido@trentalancia.com@151.47.221.112
Message-ID: <1614502908.6594.6.camel@trentalancia.com>
Subject: [PATCH RESEND v2] scsi: ignore Synchronize Cache command failures
 to keep using drives not supporting it
From:   Guido Trentalancia <guido@trentalancia.com>
To:     linux-scsi@vger.kernel.org
Date:   Sun, 28 Feb 2021 10:01:48 +0100
X-Priority: 1
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfKhi5SQh0KYqSRe32f2eO8bKVbgW8INWgj5x0RRqZGoGxBBgaDDaOWjE6XwcoH7DP8qClx+OZgXAC7dKEbGNdn6BExWZc/1qs34aaFAwXnNaaOjLQavf
 Agf8DuAOtlszfwqo3D7elIuubFvJuKl/qm0T1aDK1cQINt+jMqVhITGVxIRc+t45ijyQo+di2cSIfUJD8jn8awjXww5SXN0Kxgk=
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Many obsolete hard drives do not support the Synchronize Cache SCSI
command. Such command is generally issued during fsync() calls which
at the moment therefore fail with the ILLEGAL_REQUEST sense key.

Since this failure is currently treated as critical in the kernel SCSI
disk driver, such obsolete hard drives cannot be used anymore: they
cannot be formatted, mounted and/or checked using tools such as e2fsprogs.

Because there is nothing which can be done if the drive does not support
such command, such ILLEGAL_REQUEST should be treated as non-critical so
that the underlying operation does not fail and the obsolete hard drive
can be used normally.

This patch disables the Write Cache feature and therefore the cache
flushing functionality, as a precaution on hard drives which do not
support the Synchronize Cache command.

Fixes bug: https://bugzilla.kernel.org/show_bug.cgi?id=203635

Signed-off-by: Guido Trentalancia <guido@trentalancia.com>
---
 drivers/scsi/sd.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff -pru linux-5.0.2-orig/drivers/scsi/sd.c linux-5.0.2/drivers/scsi/sd.c
--- linux-5.0.2-orig/drivers/scsi/sd.c	2019-03-17 18:22:04.822720851 +0100
+++ linux-5.0.2/drivers/scsi/sd.c	2019-03-20 17:41:44.526957307 +0100
@@ -22,6 +22,10 @@
  *	 - Badari Pulavarty <pbadari@us.ibm.com>, Matthew Wilcox 
  *	   <willy@debian.org>, Kurt Garloff <garloff@suse.de>: 
  *	   Support 32k/1M disks.
+ *	 - Guido Trentalancia <guido@trentalancia.com> ignore Synchronize
+ *	   Cache command failures on hard-drives that do not support it
+ *	   and disable the Write Cache functionality on such devices as a
+ *	   precaution: this allows to keep using several obsolete drives.
  *
  *	Logging policy (needs CONFIG_SCSI_LOGGING defined):
  *	 - setting up transfer: SCSI_LOG_HLQUEUE levels 1 and 2
@@ -1633,6 +1637,20 @@ static int sd_sync_cache(struct scsi_dis
 	}
 
 	if (res) {
+		/*
+		 * sshdr.sense_key == ILLEGAL_REQUEST means this drive
+		 * doesn't support sync. There's not much to do and
+		 * sync shouldn't fail.
+		 */
+		if (sshdr->sense_key == ILLEGAL_REQUEST && sshdr->asc == 0x20) {
+			if (sdkp->WCE) {
+				sdkp->WCE = 0;
+				sd_printk(KERN_NOTICE, sdkp, "Drive does not support Synchronize Cache(10) command: disabling write cache.\n");
+				sd_set_flush_flag(sdkp);
+			}
+			return 0;
+		}
+
 		sd_print_result(sdkp, "Synchronize Cache(10) failed", res);
 
 		if (driver_byte(res) == DRIVER_SENSE)
@@ -2022,6 +2040,17 @@ static int sd_done(struct scsi_cmnd *SCp
 					req->rq_flags |= RQF_QUIET;
 				}
 				break;
+			case SYNCHRONIZE_CACHE:
+				if (sshdr.asc == 0x20) {
+					if (sdkp->WCE) {
+						sdkp->WCE = 0;
+						sd_printk(KERN_NOTICE, sdkp, "Drive does not support Synchronize Cache(10) command: disabling write cache.\n");
+						sd_set_flush_flag(sdkp);
+					}
+					SCpnt->result = 0;
+					good_bytes = scsi_bufflen(SCpnt);
+				}
+				break;
 			}
 		}
 		break;
