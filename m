From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] fc_transport: Write outside array bounds
Date: Tue, 28 Jul 2009 14:40:03 +0200
Message-ID: <4A6EF1A3.6040607@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:57716 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935AbZG1MhP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jul 2009 08:37:15 -0400
Received: by ewy26 with SMTP id 26so3934711ewy.37
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jul 2009 05:37:15 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

If it's possible to turn on all the optional attributes, there are more
attributes than the length of array i->private_host_attrs[], so the last one
will be out-of-bounds. (There is a BUG_ON there, but it's after the write,
rather than before).

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Found with Parfait, http://research.sun.com/projects/parfait/

in fc_attach_transport()
...
count=0;
14 x SETUP_HOST_ATTRIBUTE_RD()
if (ft->vport_create)
	2 x SETUP_HOST_ATTRIBUTE_RD_NS()
1 x SETUP_HOST_ATTRIBUTE_RW()
1 - 4 x SETUP_PRIVATE_HOST_ATTRIBUTE_RW()

all these definitions set private_host_attrs[count] (21 elements)
and increase the index count thereafter.

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 292c02f..8092e56 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2123,8 +2123,12 @@ fc_attach_transport(struct fc_function_template *ft)
 		SETUP_PRIVATE_HOST_ATTRIBUTE_RW(issue_lip);
 	if (ft->vport_create)
 		SETUP_PRIVATE_HOST_ATTRIBUTE_RW(vport_create);
-	if (ft->vport_delete)
-		SETUP_PRIVATE_HOST_ATTRIBUTE_RW(vport_delete);
+	if (ft->vport_delete) {
+		if(count < FC_HOST_NUM_ATTRS)
+			SETUP_PRIVATE_HOST_ATTRIBUTE_RW(vport_delete);
+		else
+			count++;
+	}
 
 	BUG_ON(count > FC_HOST_NUM_ATTRS);
 
