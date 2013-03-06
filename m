From: "Jack Wang" <jack_wang@usish.com>
Subject: [PATCH] libsas: use right function to alloc smp response
Date: Wed, 6 Mar 2013 10:43:03 +0800
Message-ID: <00bf01ce1a14$54f3b950$fedb2bf0$@com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_00C0_01CE1A57.6316F950"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:45872 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab3CFCmz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Mar 2013 21:42:55 -0500
Content-Language: zh-cn
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'James E.J. Bottomley'" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, 'lindar_liu' <lindar_liu@usish.com>, xjtuwjp@gmail.com

This is a multi-part message in MIME format.

------=_NextPart_000_00C0_01CE1A57.6316F950
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit

In fact the disc_resp buffer will be overwrite by smp response, so we never
found this typo, correct it by using the right one.

>From 43c522be7a5b4ce89de725926a1fbabd70674c64 Mon Sep 17 00:00:00 2001
From: John Gong <john_gong@usish.com>
Date: Fri, 1 Mar 2013 04:08:18 -0500
Subject: [PATCH] use right function to alloc smp reponse

Signed-off-by: John Gong <john_gong@usish.com>
Signed-off-by: Jack Wang <jack_wang@usish.com>
---
 drivers/scsi/libsas/sas_expander.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c
b/drivers/scsi/libsas/sas_expander.c
index efc6e72..e071e08 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -388,7 +388,7 @@ int sas_ex_phy_discover(struct domain_device *dev, int
single)
 	if (!disc_req)
 		return -ENOMEM;
 
-	disc_resp = alloc_smp_req(DISCOVER_RESP_SIZE);
+	disc_resp = alloc_smp_resp(DISCOVER_RESP_SIZE);
 	if (!disc_resp) {
 		kfree(disc_req);
 		return -ENOMEM;
-- 
1.7.1

------=_NextPart_000_00C0_01CE1A57.6316F950
Content-Type: application/octet-stream;
	name="0001-use-right-function-to-alloc-smp-reponse.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-use-right-function-to-alloc-smp-reponse.patch"

>From 43c522be7a5b4ce89de725926a1fbabd70674c64 Mon Sep 17 00:00:00 2001=0A=
From: John Gong <john_gong@usish.com>=0A=
Date: Fri, 1 Mar 2013 04:08:18 -0500=0A=
Subject: [PATCH] use right function to alloc smp reponse=0A=
=0A=
Signed-off-by: John Gong <john_gong@usish.com>=0A=
Signed-off-by: Jack Wang <jack_wang@usish.com>=0A=
---=0A=
 drivers/scsi/libsas/sas_expander.c |    2 +-=0A=
 1 files changed, 1 insertions(+), 1 deletions(-)=0A=
=0A=
diff --git a/drivers/scsi/libsas/sas_expander.c =
b/drivers/scsi/libsas/sas_expander.c=0A=
index efc6e72..e071e08 100644=0A=
--- a/drivers/scsi/libsas/sas_expander.c=0A=
+++ b/drivers/scsi/libsas/sas_expander.c=0A=
@@ -388,7 +388,7 @@ int sas_ex_phy_discover(struct domain_device *dev, =
int single)=0A=
 	if (!disc_req)=0A=
 		return -ENOMEM;=0A=
 =0A=
-	disc_resp =3D alloc_smp_req(DISCOVER_RESP_SIZE);=0A=
+	disc_resp =3D alloc_smp_resp(DISCOVER_RESP_SIZE);=0A=
 	if (!disc_resp) {=0A=
 		kfree(disc_req);=0A=
 		return -ENOMEM;=0A=
-- =0A=
1.7.1=0A=
=0A=

------=_NextPart_000_00C0_01CE1A57.6316F950--

