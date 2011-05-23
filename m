From: akpm@linux-foundation.org
Subject: [patch 4/6] drivers/scsi/osst.c: fix warning
Date: Mon, 23 May 2011 15:29:13 -0700
Message-ID: <201105232229.p4NMTDmC016155@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757781Ab1EWW3P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 May 2011 18:29:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org

From: Andrew Morton <akpm@linux-foundation.org>

drivers/scsi/osst.c: In function '__os_scsi_tape_open':
drivers/scsi/osst.c:4705: warning: ISO C90 forbids mixed declarations and code

Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/osst.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/osst.c~drivers-scsi-osstc-fix-warning drivers/scsi/osst.c
--- a/drivers/scsi/osst.c~drivers-scsi-osstc-fix-warning
+++ a/drivers/scsi/osst.c
@@ -4698,11 +4698,12 @@ static int __os_scsi_tape_open(struct in
 			break;
 
 			if ((SRpnt->sense[2] & 0x0f) == UNIT_ATTENTION) {
+				int j;
+
 				STp->pos_unknown = 0;
 				STp->partition = STp->new_partition = 0;
 				if (STp->can_partitions)
 					STp->nbr_partitions = 1;  /* This guess will be updated later if necessary */
-				int j;
 				for (j = 0; j < ST_NBR_PARTITIONS; j++) {
 					STps = &(STp->ps[j]);
 					STps->rw = ST_IDLE;
_
