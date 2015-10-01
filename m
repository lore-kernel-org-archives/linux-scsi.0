From: Joel Stanley <joel@jms.id.au>
Subject: [PATCH] be2iscsi: Fix bad WARN_ON
Date: Thu,  1 Oct 2015 17:32:58 +0930
Message-ID: <1443686578-13030-1-git-send-email-joel@jms.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33679 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937AbbJAID5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2015 04:03:57 -0400
Received: by pacex6 with SMTP id ex6so67423749pac.0
        for <linux-scsi@vger.kernel.org>; Thu, 01 Oct 2015 01:03:56 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jayamohan.kallickal@avagotech.com, minh.tran@avagotech.com, sony.john-n@avagotech.com
Cc: JBottomley@odin.com, linux-scsi@vger.kernel.org

GCC 5 helpfully warns us that the WARN_ON check may be buggy:

drivers/scsi/be2iscsi/be_main.c: In function =E2=80=98be_sgl_create_con=
tiguous=E2=80=99:
drivers/scsi/be2iscsi/be_main.c:3187:18: warning: logical not is only
applied to the left hand side of comparison [-Wlogical-not-parentheses]
  WARN_ON(!length > 0);
                    ^

Add the brackets that the check was was looking for.

Signed-off-by: Joel Stanley <joel@jms.id.au>
---
 drivers/scsi/be2iscsi/be_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be=
_main.c
index 7a6dbfb..0b87abb 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3184,7 +3184,7 @@ be_sgl_create_contiguous(void *virtual_address,
 {
 	WARN_ON(!virtual_address);
 	WARN_ON(!physical_address);
-	WARN_ON(!length > 0);
+	WARN_ON(!(length > 0));
 	WARN_ON(!sgl);
=20
 	sgl->va =3D virtual_address;
--=20
2.5.0

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
