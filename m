From: Joel Stanley <joel@jms.id.au>
Subject: [PATCH v2] be2iscsi: Fix bad WARN_ON
Date: Fri,  2 Oct 2015 11:02:45 +0930
Message-ID: <1443749565-8438-1-git-send-email-joel@jms.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:33473 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbbJBBdA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2015 21:33:00 -0400
Received: by pacex6 with SMTP id ex6so91335442pac.0
        for <linux-scsi@vger.kernel.org>; Thu, 01 Oct 2015 18:33:00 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jthumshirn@suse.de, jayamohan.kallickal@avagotech.com, JBottomley@odin.com
Cc: linux-scsi@vger.kernel.org

GCC 5 helpfully warns us that the WARN_ON check may be buggy:

drivers/scsi/be2iscsi/be_main.c: In function =E2=80=98be_sgl_create_con=
tiguous=E2=80=99:
drivers/scsi/be2iscsi/be_main.c:3187:18: warning: logical not is only
applied to the left hand side of comparison [-Wlogical-not-parentheses]
  WARN_ON(!length > 0);
                    ^

Check that length is not zero (and not less than zero, but it's
unsigned, so that will always be satisfied).

Signed-off-by: Joel Stanley <joel@jms.id.au>
---
v2: invert the check to lose the ! as suggested by Johannes

 drivers/scsi/be2iscsi/be_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be=
_main.c
index 7a6dbfb..c6110cb 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3184,7 +3184,7 @@ be_sgl_create_contiguous(void *virtual_address,
 {
 	WARN_ON(!virtual_address);
 	WARN_ON(!physical_address);
-	WARN_ON(!length > 0);
+	WARN_ON(length <=3D 0);
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
