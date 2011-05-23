From: akpm@linux-foundation.org
Subject: [patch 3/6] osst: wrong index used in inner loop
Date: Mon, 23 May 2011 15:29:12 -0700
Message-ID: <201105232229.p4NMTDTP016152@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757828Ab1EWW3R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 May 2011 18:29:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, roel.kluin@gmail.com, osst@riede.org

From: Roel Kluin <roel.kluin@gmail.com>

Index i was already used in the outer loop.  Fixes a potentially-infinite
loop.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Willem Riede <osst@riede.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/osst.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/osst.c~osst-wrong-index-used-in-inner-loop drivers/scsi/osst.c
--- a/drivers/scsi/osst.c~osst-wrong-index-used-in-inner-loop
+++ a/drivers/scsi/osst.c
@@ -4702,8 +4702,9 @@ static int __os_scsi_tape_open(struct in
 				STp->partition = STp->new_partition = 0;
 				if (STp->can_partitions)
 					STp->nbr_partitions = 1;  /* This guess will be updated later if necessary */
-				for (i=0; i < ST_NBR_PARTITIONS; i++) {
-					STps = &(STp->ps[i]);
+				int j;
+				for (j = 0; j < ST_NBR_PARTITIONS; j++) {
+					STps = &(STp->ps[j]);
 					STps->rw = ST_IDLE;
 					STps->eof = ST_NOEOF;
 					STps->at_sm = 0;
_
