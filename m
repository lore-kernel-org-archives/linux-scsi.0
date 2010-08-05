From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 29/42] drivers/scsi: Adjust confusing if indentation
Date: Thu, 5 Aug 2010 22:25:46 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1008052225240.31692@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:57967 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934228Ab0HEUZs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Aug 2010 16:25:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>, Willem Riede <osst@riede.org>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, osst-users@

From: Julia Lawall <julia@diku.dk>

Outdent the code following the if.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r disable braces4@
position p1,p2;
statement S1,S2;
@@

(
if (...) { ... }
|
if (...) S1@p1 S2@p2
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

if (p1[0].column == p2[0].column):
  cocci.print_main("branch",p1)
  cocci.print_secs("after",p2)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
This patch doesn't change the semantics of the code.  But it might not be
what is intended.

 drivers/scsi/st.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 24211d0..9c57a50 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4166,9 +4166,9 @@ out_free_tape:
 			if (STm->cdevs[j]) {
 				if (cdev == STm->cdevs[j])
 					cdev = NULL;
-					device_destroy(st_sysfs_class,
-						       MKDEV(SCSI_TAPE_MAJOR,
-							     TAPE_MINOR(i, mode, j)));
+				device_destroy(st_sysfs_class,
+					       MKDEV(SCSI_TAPE_MAJOR,
+						     TAPE_MINOR(i, mode, j)));
 				cdev_del(STm->cdevs[j]);
 			}
 		}
