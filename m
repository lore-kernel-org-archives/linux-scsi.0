From: akpm@osdl.org
Subject: [patch 01/31] drivers/scsi: fix proc_scsi_write to return "length" on success with remove-single-device case
Date: Thu, 08 Jun 2006 22:23:28 -0700
Message-ID: <200606090523.k595NSAb032228@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:61404 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965165AbWFIFXf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jun 2006 01:23:35 -0400
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
 1 file changed, 2 insertions(+)

diff -puN drivers/scsi/scsi_proc.c~drivers-scsi-fix-proc_scsi_write-to-return-length-on drivers/scsi/scsi_proc.c
--- devel/drivers/scsi/scsi_proc.c~drivers-scsi-fix-proc_scsi_write-to-return-length-on	2006-06-08 02:28:14.000000000 -0700
+++ devel-akpm/drivers/scsi/scsi_proc.c	2006-06-08 02:28:14.000000000 -0700
@@ -280,6 +280,8 @@ static ssize_t proc_scsi_write(struct fi
 		lun = simple_strtoul(p + 1, &p, 0);
 
 		err = scsi_remove_single_device(host, channel, id, lun);
+		if (!err)
+			err = length;
 	}
 
 	/*
_
