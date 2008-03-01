From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 4/4] tgt: fix build errors when dprintk is defined
Date: Sat,  1 Mar 2008 15:36:37 +0900
Message-ID: <1204353397-29855-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1204353397-29855-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1204353397-29855-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1204353397-29855-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1204353397-29855-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:35757 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754286AbYCAGha (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 Mar 2008 01:37:30 -0500
In-Reply-To: <1204353397-29855-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

drivers/scsi/ibmvscsi/ibmvstgt.c: In function 'ibmvstgt_cmd_done':
drivers/scsi/ibmvscsi/ibmvstgt.c:292: error: 'cmd' undeclared (first use in this function)
drivers/scsi/ibmvscsi/ibmvstgt.c:292: error: (Each undeclared identifier is reported only once
drivers/scsi/ibmvscsi/ibmvstgt.c:292: error: for each function it appears in.)

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/ibmvscsi/ibmvstgt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/ibmvstgt.c
index 429bf53..e5881e9 100644
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c
+++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -290,7 +290,7 @@ static int ibmvstgt_cmd_done(struct scsi_cmnd *sc,
 	int err = 0;
 
 	dprintk("%p %p %x %u\n", iue, target, vio_iu(iue)->srp.cmd.cdb[0],
-		cmd->usg_sg);
+		scsi_sg_count(sc));
 
 	if (scsi_sg_count(sc))
 		err = srp_transfer_data(sc, &vio_iu(iue)->srp.cmd, ibmvstgt_rdma, 1, 1);
-- 
1.5.3.7

