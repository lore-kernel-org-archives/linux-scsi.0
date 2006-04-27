From: akpm@osdl.org
Subject: [patch 01/20] drivers/scsi: fix proc_scsi_write to return "length" on success with remove-single-device case
Date: Thu, 27 Apr 2006 02:32:55 -0700
Message-ID: <200604270934.k3R9YNvk025428@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:65231 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965034AbWD0Jeb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Apr 2006 05:34:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, suzuki@in.ibm.com


From: Suzuki <suzuki@in.ibm.com>

proc_scsi_write doesn't return the "length" upon successfully removing a
device; instead it returns 0.  This causes commands like "echo" to redo the
write(), which ends up in something like,

$ echo "scsi remove-single-device 0 0 3 0" > /proc/scsi/scsi
"-bash: echo: write error: No such device or address"

, even though the device was removed.

Signed-off-by: Suzuki K P <suzuki@in.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/scsi_proc.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN drivers/scsi/scsi_proc.c~drivers-scsi-fix-proc_scsi_write-to-return-length-on drivers/scsi/scsi_proc.c
--- 25/drivers/scsi/scsi_proc.c~drivers-scsi-fix-proc_scsi_write-to-return-length-on	Wed Apr 26 14:39:48 2006
+++ 25-akpm/drivers/scsi/scsi_proc.c	Wed Apr 26 14:39:48 2006
@@ -282,6 +282,8 @@ static ssize_t proc_scsi_write(struct fi
 		lun = simple_strtoul(p + 1, &p, 0);
 
 		err = scsi_remove_single_device(host, channel, id, lun);
+		if (!err)
+			err = length;
 	}
 
  out:
_
