From: Dave Young <hidave.darkstar@gmail.com>
Subject: [PATCH 2/3][-mm] reclassify the sg_sysfs_class mutex
Date: Tue, 20 May 2008 17:58:51 +0800
Message-ID: <20080520095851.GB3201@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:54772 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765215AbYETJ5n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 May 2008 05:57:43 -0400
Received: by nf-out-0910.google.com with SMTP id d3so910295nfc.21
        for <linux-scsi@vger.kernel.org>; Tue, 20 May 2008 02:57:41 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: greg@kroah.com, matthew@wil.cx, kay.sievers@vrfy.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

[Please first apply the patch 1/3 before this]

To please lockdep here we use class_reclassify to change
the lock class of sg_sysfs_class

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

---
 drivers/scsi/sg.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux/drivers/scsi/sg.c	2008-05-19 12:41:05.000000000 +0800
+++ linux.new/drivers/scsi/sg.c	2008-05-19 14:08:19.000000000 +0800
@@ -1579,6 +1579,8 @@ init_sg(void)
 		rc = PTR_ERR(sg_sysfs_class);
 		goto err_out;
         }
+
+	class_reclassify(sg_sysfs_class);
 	sg_sysfs_valid = 1;
 	rc = scsi_register_interface(&sg_interface);
 	if (0 == rc) {
