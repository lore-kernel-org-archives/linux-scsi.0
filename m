From: roel <roel.kluin@gmail.com>
Subject: [PATCH] osst: wrong index used in inner loop
Date: Sat, 19 Mar 2011 20:53:53 +0100
Message-ID: <4D8509D1.6080107@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36529 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757241Ab1CSTxz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Mar 2011 15:53:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>

Index i was already used in the outer loop.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/scsi/osst.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

I'm not sure if this is the right fix, maybe a break or return
is missing?

diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 521e218..d6d6d89 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -4702,8 +4702,9 @@ static int __os_scsi_tape_open(struct inode * inode, struct file * filp)
 				STp->partition = STp->new_partition = 0;
 				if (STp->can_partitions)
 					STp->nbr_partitions = 1;  /* This guess will be updated later if necessary */
-				for (i=0; i < ST_NBR_PARTITIONS; i++) {
-					STps = &(STp->ps[i]);
+				int j;
+				for (j=0; j < ST_NBR_PARTITIONS; j++) {
+					STps = &(STp->ps[j]);
 					STps->rw = ST_IDLE;
 					STps->eof = ST_NOEOF;
 					STps->at_sm = 0;
