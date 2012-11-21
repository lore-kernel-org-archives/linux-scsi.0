From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH] megaraid_sas: fix memory leak if SGL has zero length entries
Date: Wed, 21 Nov 2012 09:54:48 +0100
Message-ID: <1353488088-10684-1-git-send-email-bjorn@mork.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:55271 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079Ab2KUJEi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2012 04:04:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>, stable@vger.kernel.org

commit 98cb7e44 ([SCSI] megaraid_sas: Sanity check user
supplied length before passing it to dma_alloc_coherent())
introduced a memory leak.  Memory allocated for entries
following zero length SGL entries will not be freed.

Reference: http://bugs.debian.org/688198
Cc: <stable@vger.kernel.org>
Signed-off-by: Bj=C3=B8rn Mork <bjorn@mork.no>
---
 drivers/scsi/megaraid/megaraid_sas_base.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/m=
egaraid/megaraid_sas_base.c
index d2c5366..12b6be4 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4854,10 +4854,12 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *=
instance,
 				    sense, sense_handle);
 	}
=20
-	for (i =3D 0; i < ioc->sge_count && kbuff_arr[i]; i++) {
-		dma_free_coherent(&instance->pdev->dev,
-				    kern_sge32[i].length,
-				    kbuff_arr[i], kern_sge32[i].phys_addr);
+	for (i =3D 0; i < ioc->sge_count; i++) {
+		if (kbuff_arr[i])
+			dma_free_coherent(&instance->pdev->dev,
+					  kern_sge32[i].length,
+					  kbuff_arr[i],
+					  kern_sge32[i].phys_addr);
 	}
=20
 	megasas_return_cmd(instance, cmd);
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
