From: Brian King <brking@us.ibm.com>
Subject: Re: System freeze when accessing st.ko and /dev/st0
Date: Fri, 06 Feb 2004 14:47:26 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4023FD5E.8060604@us.ibm.com>
References: <20040206194225.GA27385@mail.fortuitous.com> <4023F466.7000100@us.ibm.com> <20040206202903.GB1488@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040603030500060200040702"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:13197 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S265473AbUBFUrf
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2004 15:47:35 -0500
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: pac@fortuitous.com, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, Kai.Makisara@kolumbus.fi, dgilbert@interlog.com

This is a multi-part message in MIME format.
--------------040603030500060200040702
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Mike Anderson wrote:
> Brian King [brking@us.ibm.com] wrote:
> 
>>I have been debugging this same problem in sg today. It appears as if
>>kobj_unmap is never getting called when a device is deleted. When I
>>added a call to kobj_unmap, the problem went away. I'm currently working
>>on a patch for this.
>>
>>-Brian
> 
> 
> Are you indicating that we need a direct call to kobj_unmap along with
> the call to cdev_unmap?

No. We just need a call to cdev_unmap, which isn't getting done. The attached
patch should fix this for both sg and st. I have tested both and it works for me.
Phil, can you please apply and let me know if it fixes your problem? It should
apply against 2.6.2.

Thanks


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------040603030500060200040702
Content-Type: text/plain;
 name="patch-2.6.2-sg_st-cdev_unmap"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-2.6.2-sg_st-cdev_unmap"

diff -Naur linux-2.6.2/drivers/scsi/sg.c linux-2.6.2-cdev_unmap/drivers/scsi/sg.c
--- linux-2.6.2/drivers/scsi/sg.c	Fri Feb  6 14:12:22 2004
+++ linux-2.6.2-cdev_unmap/drivers/scsi/sg.c	Fri Feb  6 14:12:35 2004
@@ -1513,6 +1513,7 @@
 	if (sdp) {
 		sysfs_remove_link(&scsidp->sdev_gendev.kobj, "generic");
 		sysfs_remove_link(&sdp->cdev->kobj, "device");
+		cdev_unmap(MKDEV(SCSI_GENERIC_MAJOR, sdp->disk->first_minor), 1);
 		cdev_del(sdp->cdev);
 		sdp->cdev = NULL;
 		devfs_remove("%s/generic", scsidp->devfs_name);
diff -Naur linux-2.6.2/drivers/scsi/st.c linux-2.6.2-cdev_unmap/drivers/scsi/st.c
--- linux-2.6.2/drivers/scsi/st.c	Fri Jan  9 00:59:45 2004
+++ linux-2.6.2-cdev_unmap/drivers/scsi/st.c	Fri Feb  6 14:18:57 2004
@@ -3964,6 +3964,7 @@
 				for (j=0; j < 2; j++) {
 					sysfs_remove_link(&tpnt->modes[mode].cdevs[j]->kobj,
 							  "device");
+					cdev_unmap(MKDEV(SCSI_TAPE_MAJOR, TAPE_MINOR(i, mode, j)), 1);
 					cdev_del(tpnt->modes[mode].cdevs[j]);
 					tpnt->modes[mode].cdevs[j] = NULL;
 				}

--------------040603030500060200040702--

