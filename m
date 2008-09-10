From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] aacraid: disable local interrupts before calling
 scsi_sg_copy APIs
Date: Thu, 11 Sep 2008 03:01:18 +0900
Message-ID: <20080911030031Q.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:55037 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753870AbYIJSBm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2008 14:01:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, winfried@tilanus.com

James, can you apply this to scsi-fc-fixes (this needs to go to
2.6.26-stable too)?

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] aacraid: disable local interrupts before calling scsi_sg_copy APIs

This fixes the problem reported in:

http://bugzilla.kernel.org/show_bug.cgi?id=11529

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Reported-by: Winfried Tilanus <winfried@tilanus.com>
Tested-by: Winfried Tilanus <winfried@tilanus.com>
Cc: stable@vger.kernel.org
---
 drivers/scsi/aacraid/aachba.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index aa4e77c..160feab 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -404,13 +404,16 @@ static void get_container_name_callback(void *context, struct fib * fibptr)
 			char d[sizeof(((struct inquiry_data *)NULL)->inqd_pid)];
 			int count = sizeof(d);
 			char *dp = d;
+			unsigned long flags;
 			do {
 				*dp++ = (*sp) ? *sp++ : ' ';
 			} while (--count > 0);
 
+			local_irq_save(flags);
 			scsi_sg_copy_to_buffer(scsicmd, &inq, sizeof(inq));
 			memcpy(inq.inqd_pid, d, sizeof(d));
 			scsi_sg_copy_from_buffer(scsicmd, &inq, sizeof(inq));
+			local_irq_restore(flags);
 		}
 	}
 
@@ -793,6 +796,7 @@ static void get_container_serial_callback(void *context, struct fib * fibptr)
 	get_serial_reply = (struct aac_get_serial_resp *) fib_data(fibptr);
 	/* Failure is irrelevant, using default value instead */
 	if (le32_to_cpu(get_serial_reply->status) == CT_OK) {
+		unsigned long flags;
 		char sp[13];
 		/* EVPD bit set */
 		sp[0] = INQD_PDT_DA;
@@ -800,7 +804,9 @@ static void get_container_serial_callback(void *context, struct fib * fibptr)
 		sp[2] = 0;
 		sp[3] = snprintf(sp+4, sizeof(sp)-4, "%08X",
 		  le32_to_cpu(get_serial_reply->uid));
+		local_irq_save(flags);
 		scsi_sg_copy_from_buffer(scsicmd, sp, sizeof(sp));
+		local_irq_restore(flags);
 	}
 
 	scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
-- 
1.5.4.2

