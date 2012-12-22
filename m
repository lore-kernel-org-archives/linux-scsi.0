From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] target: initialize sense_reason_t ret in core_scsi3_emulate_pro_register()
Date: Sat, 22 Dec 2012 22:15:57 +0100
Message-ID: <1356210957-30089-1-git-send-email-geert@linux-m68k.org>
References: <y>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <y>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

drivers/target/target_core_pr.c: In function =E2=80=98core_scsi3_emulat=
e_pro_register=E2=80=99:
drivers/target/target_core_pr.c:2056: warning: =E2=80=98ret=E2=80=99 ma=
y be used uninitialized in this function

If !spec_i_pt, the "goto out_put_pr_reg" on line 2141 seems to be a rea=
l
case where ret is not initialized.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/target/target_core_pr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_co=
re_pr.c
index e35dbf8..c2e8026 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -2053,7 +2053,7 @@ core_scsi3_emulate_pro_register(struct se_cmd *cm=
d, u64 res_key, u64 sa_res_key,
 	/* Used for APTPL metadata w/ UNREGISTER */
 	unsigned char *pr_aptpl_buf =3D NULL;
 	unsigned char isid_buf[PR_REG_ISID_LEN], *isid_ptr =3D NULL;
-	sense_reason_t ret;
+	sense_reason_t ret =3D 0;
 	int pr_holder =3D 0, type;
=20
 	if (!se_sess || !se_lun) {
--=20
1.7.0.4
