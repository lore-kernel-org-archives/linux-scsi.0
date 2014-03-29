From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 12/55] scsi: Mark function as static in bnx2fc/bnx2fc_els.c
Date: Sat, 29 Mar 2014 23:26:36 +0530
Message-ID: <9fe78fd25af3c2f7623075c50d4f01a63b0d2286.1396114897.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Eddie Wai <eddie.wai@broadcom.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, josh@joshtriplett.org
List-Id: linux-scsi@vger.kernel.org

Mark functions as static in bnx2fc/bnx2fc_els.c because they are not
used outside this file.

This eliminates the following warning in bnx2fc/bnx2fc_els.c:
drivers/scsi/bnx2fc/bnx2fc_els.c:256:6: warning: no previous prototype =
for =E2=80=98bnx2fc_srr_compl=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/bnx2fc/bnx2fc_els.c:366:6: warning: no previous prototype =
for =E2=80=98bnx2fc_rec_compl=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/bnx2fc/bnx2fc_els.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_els.c b/drivers/scsi/bnx2fc/bnx=
2fc_els.c
index b1c9a4f..3121da5 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_els.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_els.c
@@ -253,7 +253,7 @@ int bnx2fc_send_rls(struct bnx2fc_rport *tgt, struc=
t fc_frame *fp)
 	return rc;
 }
=20
-void bnx2fc_srr_compl(struct bnx2fc_els_cb_arg *cb_arg)
+static void bnx2fc_srr_compl(struct bnx2fc_els_cb_arg *cb_arg)
 {
 	struct bnx2fc_mp_req *mp_req;
 	struct fc_frame_header *fc_hdr, *fh;
@@ -363,7 +363,7 @@ srr_compl_done:
 	kref_put(&orig_io_req->refcount, bnx2fc_cmd_release);
 }
=20
-void bnx2fc_rec_compl(struct bnx2fc_els_cb_arg *cb_arg)
+static void bnx2fc_rec_compl(struct bnx2fc_els_cb_arg *cb_arg)
 {
 	struct bnx2fc_cmd *orig_io_req, *new_io_req;
 	struct bnx2fc_cmd *rec_req;
--=20
1.7.9.5
