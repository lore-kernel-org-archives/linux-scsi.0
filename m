From: David Jeffery <dhjeffery@gmail.com>
Subject: [PATCH] scsi: memory leak with 1MB tape I/O
Date: Wed, 11 Apr 2012 12:14:25 -0400
Message-ID: <4F85ADE1.30803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34779 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759525Ab2DKQCn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Apr 2012 12:02:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

There is a memory leak in the st driver when sending large enough reads or
writes using st's direct I/O path.  As part of mapping the application's
memory, a buffer to hold page pointers is allocated and the count of mapped
pages is stored in field do_dio.  A non-zero do_dio marks that direct I/O is
in use.

But do_dio is only 1 byte in size.  Mapping 256 4k pages overflows
do_dio and causes it to be set to 0, like direct I/O option was not
used.  When the I/O completes, the buffer to hold the page pointers is
not freed, and the page counts of the mapped pages are not reduced.
Every I/O of this size then leaks memory.

The size of do_dio needs to be increased to prevent it wrapping around.

signed-off-by: David Jeffery <djeffery@redhat.com>
---

--- a/drivers/scsi/st.h	2012-04-10 13:21:30.000000000 -0400
+++ b/drivers/scsi/st.h	2012-04-10 14:55:43.000000000 -0400
@@ -35,8 +35,8 @@
 /* The tape buffer descriptor. */
 struct st_buffer {
 	unsigned char dma;	/* DMA-able buffer */
-	unsigned char do_dio;   /* direct i/o set up? */
 	unsigned char cleared;  /* internal buffer cleared after open? */
+	unsigned short do_dio;  /* direct i/o set up? */
 	int buffer_size;
 	int buffer_blocks;
 	int buffer_bytes;
