From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [RESEND PATCH 8/8] iscsi: use pageslab
Date: Fri, 13 Jan 2006 18:05:56 -0600
Message-ID: <1137197156.2720.42.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:34228 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1423156AbWANAGc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 19:06:32 -0500
Received: from [192.168.0.6] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id k0E06Vhe021743
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2006 18:06:31 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

>From FUJITA Tomonori <tomof@acm.org> and
zhenyu.z.wang@intel.com:

We cannot handle filesystems like XFS becuase of the pages they
are sending us. We had thought page_count could be used to
work around this, but the correct test is for PageSlab.

The proper solution is to figure out what type of pages
filesystems can use so we do not have to add tests like
this or handle it in the block layer for all network block drivers
but the issue still has not been resolved on fs-devel
so we are sending this patch as a temporary fix.

This is last patch just in case it is Nakd with the explanation
that we need to push the correct fix through fs-devel, mm
or the block layer. The rest of the patchset can live without
the patch, but the driver will not work with filesystems like
XFS.

Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index b17c121..8146cf9 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -109,7 +109,7 @@ iscsi_buf_init_sg(struct iscsi_buf *ibuf
 	/*
 	 * Fastpath: sg element fits into single page
 	 */
-	if (sg->length + sg->offset <= PAGE_SIZE && page_count(sg->page) >= 2)
+	if (sg->length + sg->offset <= PAGE_SIZE && !PageSlab(sg->page))
 		ibuf->use_sendmsg = 0;
 	else
 		ibuf->use_sendmsg = 1;


