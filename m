From: "Figo.zhang" <figo1802@gmail.com>
Subject: [PATCH]scsi_debug:c: fix call vfree()
Date: Sun, 07 Jun 2009 13:30:02 +0800
Message-ID: <1244352602.3355.17.camel@myhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.233]:64787 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbZFGFag (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Jun 2009 01:30:36 -0400
Received: by rv-out-0506.google.com with SMTP id f9so958158rvb.1
        for <linux-scsi@vger.kernel.org>; Sat, 06 Jun 2009 22:30:38 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org

vfree() does it's own 'NULL' check,so no need for check before
calling it.

Signed-off-by: Figo.zhang <figo1802@gmail.com>
---   
drivers/scsi/scsi_debug.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 213123b..c24af62 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2976,8 +2976,7 @@ bus_unreg:
 dev_unreg:
 	device_unregister(&pseudo_primary);
 free_vm:
-	if (dif_storep)
-		vfree(dif_storep);
+	vfree(dif_storep);
 	vfree(fake_storep);
 
 	return ret;
@@ -2995,8 +2994,7 @@ static void __exit scsi_debug_exit(void)
 	bus_unregister(&pseudo_lld_bus);
 	device_unregister(&pseudo_primary);
 
-	if (dif_storep)
-		vfree(dif_storep);
+	vfree(dif_storep);
 
 	vfree(fake_storep);
 }


