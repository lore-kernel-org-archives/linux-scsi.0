From: David Jeffery <djeffery@redhat.com>
Subject: [PATCH] st.c: possible memory use after free after MTSETBLK ioctl
Date: Thu, 24 Sep 2009 16:32:40 -0400 (EDT)
Message-ID: <2123868472.308991253824360715.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
References: <912553534.308131253824005002.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbZIXUcg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Sep 2009 16:32:36 -0400
Received: from int-mx05.intmail.prod.int.phx2.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.18])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8OKWeaL011276
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2009 16:32:41 -0400
Received: from mail02.corp.redhat.com (zmail02.collab.prod.int.phx2.redhat.com [10.5.5.42])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id n8OKWebh008624
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2009 16:32:40 -0400
In-Reply-To: <912553534.308131253824005002.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

A memory use after free bug can manifest if the MTSETBLK or SET_DENS_AND_BLK
ioctl features are used to set the tape's blocksize from 0 to non-zero.
After the driver sets the new block size, in this one case it calls
normalize_buffer() to free the device's internal data buffers.  However, the
ioctl code assumes there is always a buffer and does not check or allocate
a buffer if there isn't one.  So any following ioctl calls can corrupt
a part of memory by writing data to memory that the st driver had freed.

This small patch forces the st driver to allocate a minimal one page buffer
using enlarge_buffer() after the previous buffers were freed.


Signed-of-by: David Jeffery <djeffery@redhat.com>


--- a/drivers/scsi/st.c	2009-09-24 12:34:14.000000000 -0400
+++ b/drivers/scsi/st.c	2009-09-23 22:10:17.000000000 -0400
@@ -2776,8 +2776,12 @@
 			int old_block_size = STp->block_size;
 			STp->block_size = arg & MT_ST_BLKSIZE_MASK;
 			if (STp->block_size != 0) {
-				if (old_block_size == 0)
+				if (old_block_size == 0){
 					normalize_buffer(STp->buffer);
+					if (!enlarge_buffer(STp->buffer, PAGE_SIZE, STp->restr_dma)) {
+						printk(KERN_ERR "No st buffer!\n");
+					}
+				}
 				(STp->buffer)->buffer_blocks =
 				    (STp->buffer)->buffer_size / STp->block_size;
 			}
