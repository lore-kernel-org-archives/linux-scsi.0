From: SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH] [SCSI] hpsa: use trans_support after value assigned
Date: Wed, 26 Mar 2014 15:24:02 +0900
Message-ID: <1395815042-26917-1-git-send-email-sj38.park@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: scameron@beardog.cce.hp.com, JBottomley@paralles.com
Cc: iss_storagedev@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, SeongJae Park <sj38.park@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Because trans_support be used when check i/o accelerator mode support
before its value assigned, it caused following build warning:

drivers/scsi/hpsa.c: In function =E2=80=98hpsa_init_one=E2=80=99:
drivers/scsi/hpsa.c:7468:20: warning: =E2=80=98trans_support=E2=80=99
may be used uninitialized in this function [-Wmaybe-uninitialized]
  if (trans_support & CFGTBL_Trans_io_accel1) {
                    ^
drivers/scsi/hpsa.c:7459:6: note: =E2=80=98trans_support=E2=80=99 was
declared here
  u32 trans_support;
      ^

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 drivers/scsi/hpsa.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 8cf4a0c..a4ae873 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -7455,7 +7455,7 @@ clean_up:
=20
 static void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
 {
-	u32 trans_support;
+	u32 trans_support =3D readl(&(h->cfgtable->TransportSupport));
 	unsigned long transMethod =3D CFGTBL_Trans_Performant |
 					CFGTBL_Trans_use_short_tags;
 	int i;
@@ -7479,7 +7479,6 @@ static void hpsa_put_ctlr_into_performant_mode(st=
ruct ctlr_info *h)
 	}
=20
 	/* TODO, check that this next line h->nreply_queues is correct */
-	trans_support =3D readl(&(h->cfgtable->TransportSupport));
 	if (!(trans_support & PERFORMANT_MODE))
 		return;
=20
--=20
1.8.3.2
