From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Bug 11529] aacraid - WARNING: at lib/scatterlist.c
Date: Wed, 10 Sep 2008 23:13:20 +0900
Message-ID: <20080910231313D.fujita.tomonori@lab.ntt.co.jp>
References: <bug-11529-11613@http.bugzilla.kernel.org/>
	<20080910124431.05EF911D10B@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:45397 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbYIJONZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2008 10:13:25 -0400
In-Reply-To: <20080910124431.05EF911D10B@picon.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Wed, 10 Sep 2008 05:44:31 -0700 (PDT)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=11529
> 
> 
> 
> 
> 
> ------- Comment #2 from winfried@tilanus.com  2008-09-10 05:44 -------
> The patch didn't apply, but adding the lines by hand worked.

Strange, I can cleanly apply the patch to 2.6.26.5 that the mailing
list delivered...


> It solved most of
> the warnings, but I am still left with two warnings at boottime:

Ah, sorry. Can you try this patch?

Thanks,


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
