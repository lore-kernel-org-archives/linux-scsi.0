From: Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH] scsi, aic94xx Fix uninitialized warning
Date: Fri, 13 Sep 2013 08:31:36 -0400
Message-ID: <1379075496-20381-1-git-send-email-prarit@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046Ab3IMMbr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Sep 2013 08:31:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, dmilburn@redhat.com, "James E.J. Bottomley" <JBottomley@parallels.com>

=46ix uninitialized warning.

drivers/scsi/aic94xx/aic94xx_sds.c: In function =E2=80=98asd_process_ct=
rl_a_user=E2=80=99:
drivers/scsi/aic94xx/aic94xx_sds.c:597:21: error: =E2=80=98offs=E2=80=99=
 may be used uninitialized in this function [-Werror=3Dmaybe-uninitiali=
zed]
  asd_read_reg_string(asd_ha, buffer, asd_ha->hw_prof.flash.bar+offs,
                     ^
drivers/scsi/aic94xx/aic94xx_sds.c:985:6: note: =E2=80=98offs=E2=80=99 =
was declared here
  u32 offs, size;
      ^
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: dmilburn@redhat.com
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
---
 drivers/scsi/aic94xx/aic94xx_sds.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_sds.c b/drivers/scsi/aic94xx/=
aic94xx_sds.c
index edb43fd..2f1751a 100644
--- a/drivers/scsi/aic94xx/aic94xx_sds.c
+++ b/drivers/scsi/aic94xx/aic94xx_sds.c
@@ -982,7 +982,7 @@ static int asd_process_ctrl_a_user(struct asd_ha_st=
ruct *asd_ha,
 				   struct asd_flash_dir *flash_dir)
 {
 	int err, i;
-	u32 offs, size;
+	u32 uninitialized_var(offs), size;
 	struct asd_ll_el *el;
 	struct asd_ctrla_phy_settings *ps;
 	struct asd_ctrla_phy_settings dflt_ps;
--=20
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
