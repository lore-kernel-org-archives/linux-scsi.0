From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 5/10] mpt2sas: Use compat_ptr to setup the pointer compatibility.
Date: Wed, 16 Dec 2009 18:53:04 +0530
Message-ID: <20091216132256.GF31161@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:48478 "HELO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757220AbZLPNu1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Dec 2009 08:50:27 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


On ppc64, an 32bit application was failing due to data buffers not being
copied properly from user to kernel memory.  The problem due to improper
conversion of 32 to 64 bit pointers.  The fix is to use compat_ptr to
setup the pointer compatibility in the routine _ctl_compat_mpt_command.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Reviewed-by: Eric Moore <eric.moore@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index 198ecdd..fa9bf83 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -2203,14 +2203,10 @@ _ctl_compat_mpt_command(struct file *file, unsigned cmd, unsigned long arg)
 	karg.data_out_size = karg32.data_out_size;
 	karg.max_sense_bytes = karg32.max_sense_bytes;
 	karg.data_sge_offset = karg32.data_sge_offset;
-	memcpy(&karg.reply_frame_buf_ptr, &karg32.reply_frame_buf_ptr,
-	    sizeof(uint32_t));
-	memcpy(&karg.data_in_buf_ptr, &karg32.data_in_buf_ptr,
-	    sizeof(uint32_t));
-	memcpy(&karg.data_out_buf_ptr, &karg32.data_out_buf_ptr,
-	    sizeof(uint32_t));
-	memcpy(&karg.sense_data_ptr, &karg32.sense_data_ptr,
-	    sizeof(uint32_t));
+	karg.reply_frame_buf_ptr = compat_ptr(karg32.reply_frame_buf_ptr);
+	karg.data_in_buf_ptr = compat_ptr(karg32.data_in_buf_ptr);
+	karg.data_out_buf_ptr = compat_ptr(karg32.data_out_buf_ptr);
+	karg.sense_data_ptr = compat_ptr(karg32.sense_data_ptr);
 	state = (file->f_flags & O_NONBLOCK) ? NON_BLOCKING : BLOCKING;
 	return _ctl_do_mpt_command(ioc, karg, &uarg->mf, state);
 }
