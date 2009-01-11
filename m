From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] libfc: fix compile warning
Date: Sun, 11 Jan 2009 17:38:12 +0900
Message-ID: <20090111173657Z.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:41256 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbZAKIiV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Jan 2009 03:38:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, robert.w.love@intel.com

linux-next builds doesn't catch warnings like this?

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] libfc: fix compile warning

I got the following warnings on IA64:

drivers/scsi/libfc/fc_lport.c: In function 'fc_lport_recv_flogi_req':
drivers/scsi/libfc/fc_lport.c:788: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'u64'
drivers/scsi/libfc/fc_lport.c:792: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'u64'
scsi/libfc/fc_rport.c: In function 'fc_rport_recv_plogi_req':
/home/fujita/git/linux-2.6/drivers/scsi/libfc/fc_rport.c:968: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'u64'

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/libfc/fc_lport.c |    5 +++--
 drivers/scsi/libfc/fc_rport.c |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 0b9bdb1..be1e9bd 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -786,10 +786,11 @@ static void fc_lport_recv_flogi_req(struct fc_seq *sp_in,
 	remote_wwpn = get_unaligned_be64(&flp->fl_wwpn);
 	if (remote_wwpn == lport->wwpn) {
 		FC_DBG("FLOGI from port with same WWPN %llx "
-		       "possible configuration error\n", remote_wwpn);
+		       "possible configuration error\n",
+		       (unsigned long long)remote_wwpn);
 		goto out;
 	}
-	FC_DBG("FLOGI from port WWPN %llx\n", remote_wwpn);
+	FC_DBG("FLOGI from port WWPN %llx\n", (unsigned long long)remote_wwpn);
 
 	/*
 	 * XXX what is the right thing to do for FIDs?
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index e780d8c..4004313 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -966,7 +966,7 @@ static void fc_rport_recv_plogi_req(struct fc_rport *rport,
 	switch (rdata->rp_state) {
 	case RPORT_ST_INIT:
 		FC_DEBUG_RPORT("incoming PLOGI from %6x wwpn %llx state INIT "
-			       "- reject\n", sid, wwpn);
+			       "- reject\n", sid, (unsigned long long)wwpn);
 		reject = ELS_RJT_UNSUP;
 		break;
 	case RPORT_ST_PLOGI:
-- 
1.6.0.6

