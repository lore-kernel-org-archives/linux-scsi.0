From: "Jan Beulich" <JBeulich@suse.com>
Subject: [PATCH] fix buffer leak after "scsi: saner replacements for
 ->proc_info()"
Date: Wed, 29 May 2013 13:26:53 +0100
Message-ID: <51A6102D02000078000D9992@nat28.tlf.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat28.tlf.novell.com ([130.57.49.28]:45673 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965860Ab3E2M05 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-scsi@vger.kernel.org:2:1>);
	Wed, 29 May 2013 08:26:57 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, viro@zeniv.linux.org.uk
Cc: linux-scsi@vger.kernel.org

That patch failed to set proc_scsi_fops' .release method.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 drivers/scsi/scsi_proc.c |    1 +
 1 file changed, 1 insertion(+)

--- 3.10-rc3/drivers/scsi/scsi_proc.c
+++ 3.10-rc3-scsi-proc-leak/drivers/scsi/scsi_proc.c
@@ -84,6 +84,7 @@ static int proc_scsi_host_open(struct in
 
 static const struct file_operations proc_scsi_fops = {
 	.open = proc_scsi_host_open,
+	.release = single_release,
 	.read = seq_read,
 	.llseek = seq_lseek,
 	.write = proc_scsi_host_write



