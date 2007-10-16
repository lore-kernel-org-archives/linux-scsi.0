From: akpm@linux-foundation.org
Subject: [patch 2/7] git scsi misc include fix
Date: Tue, 16 Oct 2007 14:28:20 -0700
Message-ID: <200710162128.l9GLSKUF018167@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37187 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965331AbXJPV3B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Oct 2007 17:29:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, pj@sgi.com

From: Paul Jackson <pj@sgi.com>

The added line in scsi_eh.h:
	struct scatterlist sense_sgl;
fails to compile, with the error:
	field 'sense_sgl' has incomplete type
unless scatterlist.h happens to be included
somehow already ... which it isn't always.

So include scatterlist.h in scsi_eh.h directly.

Signed-off-by: Paul Jackson <pj@sgi.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/scsi/scsi_eh.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/scsi/scsi_eh.h~git-scsi-misc-include-fix include/scsi/scsi_eh.h
--- a/include/scsi/scsi_eh.h~git-scsi-misc-include-fix
+++ a/include/scsi/scsi_eh.h
@@ -4,6 +4,7 @@
 #include <linux/scatterlist.h>
 
 #include <scsi/scsi_cmnd.h>
+#include <linux/scatterlist.h>
 struct scsi_device;
 struct Scsi_Host;
 
_
