From: David Jeffery <djeffery@redhat.com>
Subject: Re: [PATCH] st.c: possible memory use after free after MTSETBLK
 ioctl
Date: Mon, 28 Sep 2009 13:54:24 -0400 (EDT)
Message-ID: <84990656.575561254160464748.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
References: <511326308.574361254160109240.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbZI1RyY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Sep 2009 13:54:24 -0400
In-Reply-To: <511326308.574361254160109240.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

> On Fri, 25 Sep 2009, Kai Makisara wrote:
> 
> Having thought this a little more, it would probably be best to remove
> the 
> call to normalize_buffer() instead of trying to cope with it failing.
> This 
> just means that some memory may stay allocated longer. In the usage 
> scenarios coming into my mind, the buffer is either small or it will
> be 
> reallocated.
> 
> Would you like to make the patch?
> 
> Thanks,
> Kai

How does this look?  Compiles and passes initial tests.  I'd left the
normalize_buffer() in originally thinking there must be a reason for
it, but you're right it just seems to make buffer handling problematic.
This patch removes the normalize_buffer() call and the specialness of
changing from a 0 to non-zero blocksize to fix the possible use of
memory after it has been freed by the st driver.

signed-off-by: David Jeffery <djeffery@redhat.com>

--- a/drivers/scsi/st.c	2009-09-28 13:29:31.000000000 -0400
+++ b/drivers/scsi/st.c	2009-09-28 13:35:32.000000000 -0400
@@ -2859,11 +2859,8 @@
 			ioctl_result = st_int_ioctl(STp, MTBSF, 1);
 
 		if (cmd_in == MTSETBLK || cmd_in == SET_DENS_AND_BLK) {
-			int old_block_size = STp->block_size;
 			STp->block_size = arg & MT_ST_BLKSIZE_MASK;
 			if (STp->block_size != 0) {
-				if (old_block_size == 0)
-					normalize_buffer(STp->buffer);
 				(STp->buffer)->buffer_blocks =
 				    (STp->buffer)->buffer_size / STp->block_size;
 			}
