From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 9/11] drivers/scsi: Correct NULL test
Date: Sat, 6 Feb 2010 09:44:39 +0100 (CET)
Message-ID: <Pine.LNX.4.64.1002060944160.8092@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

fcf is tested in the line just below, so the first test is not needed.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r@
expression *x;
expression e;
identifier l;
@@

if (x == NULL || ...) {
    ... when forall
    return ...; }
... when != goto l;
    when != x = e
    when != &x
*x == NULL
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/fcoe/libfcoe.c         |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 9823291..9b634bd 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -941,8 +941,6 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 	u32	desc_mask;
 
 	LIBFCOE_FIP_DBG(fip, "Clear Virtual Link received\n");
-	if (!fcf)
-		return;
 	if (!fcf || !fc_host_port_id(lport->host))
 		return;
 
