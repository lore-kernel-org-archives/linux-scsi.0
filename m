From: Martin Habets <errandir_news@mph.eclipse.co.uk>
Subject: [PATCH] st: remove unused st_buffer.in_use
Date: Wed, 28 Jun 2006 15:40:36 +0100
Message-ID: <20060628144036.GC31139@palantir8>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mra01.ch.as12513.net ([82.153.254.69]:30342 "EHLO
	mra01.ch.as12513.net") by vger.kernel.org with ESMTP
	id S1030379AbWF1Okw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jun 2006 10:40:52 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: linux-scsi@vger.kernel.org

Hi,

I noticed that in_use in st_buffer is not used. The patch below
against 2.6.17-rc3 removes it, assuming there is no future use for it.
It was tested in a sparc SS20 with a DLT4000.

Please CC me as I'm not subscribed to the list.

Thanks,
Martin

	Signed-off-by: Martin Habets <errandir_news@mph.eclipse.co.uk>
---
--- 2.6.17-rc3/drivers/scsi/st.h.orig	2006-05-01 10:30:53.000000000 +0100
+++ 2.6.17-rc3/drivers/scsi/st.h	2006-06-28 15:17:11.000000000 +0100
@@ -31,7 +31,6 @@
 
 /* The tape buffer descriptor. */
 struct st_buffer {
-	unsigned char in_use;
 	unsigned char dma;	/* DMA-able buffer */
 	unsigned char do_dio;   /* direct i/o set up? */
 	int buffer_size;
--- 2.6.17-rc3/drivers/scsi/st.c.orig	2006-05-01 11:04:24.000000000 +0100
+++ 2.6.17-rc3/drivers/scsi/st.c	2006-06-28 15:17:57.000000000 +0100
@@ -3599,7 +3599,6 @@
 	tb->use_sg = max_sg;
 	tb->frp = (struct st_buf_fragment *)(&(tb->sg[0]) + max_sg);
 
-	tb->in_use = 1;
 	tb->dma = need_dma;
 	tb->buffer_size = got;
 
