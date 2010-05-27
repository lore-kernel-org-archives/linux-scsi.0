From: Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH]: aic94xx: fix uninitialized variable warning
Date: Thu, 27 May 2010 14:24:59 -0400
Message-ID: <20100527182056.24051.65113.sendpatchset@prarit.bos.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644Ab0E0SZA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 May 2010 14:25:00 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o4RIP0gu028793
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 27 May 2010 14:25:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@suse.de
Cc: Prarit Bhargava <prarit@redhat.com>

=46ixes warning:

drivers/scsi/aic94xx/aic94xx_sds.c: In function =E2=80=98asd_process_ct=
rl_a_user=E2=80=99:
drivers/scsi/aic94xx/aic94xx_sds.c:985: error: =E2=80=98offs=E2=80=99 m=
ay be used uninitialized in this function

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

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
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
