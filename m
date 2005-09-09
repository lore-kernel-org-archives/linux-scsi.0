From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] sg: do not set VM_IO flag on mmap-ed pages
Date: Fri, 09 Sep 2005 17:18:57 +1000
Message-ID: <43213761.8060403@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040807060003050209040602"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:20398 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1751423AbVIIHSf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Sep 2005 03:18:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, ahmed.teirelbar@adic.com

This is a multi-part message in MIME format.
--------------040807060003050209040602
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Further to the problem discussed in this post:
http://marc.theaimsgroup.com/?l=linux-scsi&m=112540053711489&w=2

It seems that the sg driver does not need to set the VM_IO flag
on pages that it memory maps to the user space since they are
not from the IO space. Ahmed Teirelbar <ahmed.teirelbar@adic.com>
wants the facility and has tested this patch as I have without
adverse effects.

Patch is against lk 2.6.13 with this "[PATCH] sg direct io/mmap
oops, st sync" applied.

The oops protection is still important. Some users really did
try and use dio transfers from the sg driver to memory mapped
IO space (on a video capture card if my memory serves) during the
lk 2.4 series. I'm not sure how successful it was but that will
now be politely refused in lk 2.6.13+ .

Changelog:
   - set the page flags for sg's reserved buffer mmap-ed
     to the user space to VM_RESERVED (rather than
     VM_RESERVED | VM_IO )

Signed-off-by: Douglas Gilbert <dougg@torque.net>

Doug Gilbert

--------------040807060003050209040602
Content-Type: text/x-patch;
 name="sg_lk2613kai_vmio.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg_lk2613kai_vmio.diff"

--- linux/drivers/scsi/sg.c	2005-09-01 21:30:39.000000000 +1000
+++ linux/drivers/scsi/sg.c2613kai_vmio	2005-09-08 20:36:39.000000000 +1000
@@ -61,7 +61,7 @@
 
 #ifdef CONFIG_SCSI_PROC_FS
 #include <linux/proc_fs.h>
-static char *sg_version_date = "20050901";
+static char *sg_version_date = "20050908";
 
 static int sg_proc_init(void);
 static void sg_proc_cleanup(void);
@@ -1300,7 +1300,7 @@
 		sg_rb_correct4mmap(rsv_schp, 1);	/* do only once per fd lifetime */
 		sfp->mmap_called = 1;
 	}
-	vma->vm_flags |= (VM_RESERVED | VM_IO);
+	vma->vm_flags |= VM_RESERVED;
 	vma->vm_private_data = sfp;
 	vma->vm_ops = &sg_mmap_vm_ops;
 	return 0;

--------------040807060003050209040602--
