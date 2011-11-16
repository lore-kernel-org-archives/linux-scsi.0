From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 2/2] bfa: fix enidan and bit field check bug
Date: Wed, 16 Nov 2011 12:29:26 -0800
Message-ID: <1321475366-14801-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:54028 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753594Ab1KPUvY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Nov 2011 15:51:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, Jing Huang <huangj@brocade.com>

Fix some endian issue. __BIGENDIAN is not defined and it needs to be
replaced with __BIG_ENDIAN. Also fixed a bug in bit field access.
These two issues were reported by Dan Carpenter and he also provided a
patch a few months ago, but somehow his patch is still not accepted.

This patch has been tested with linux-net, and is intended to be include in
scsi-misc. 

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa_defs.h |    4 ++--
 drivers/scsi/bfa/bfa_ioc.c  |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_defs.h b/drivers/scsi/bfa/bfa_defs.h
index 7b3d235..b5a1595 100644
--- a/drivers/scsi/bfa/bfa_defs.h
+++ b/drivers/scsi/bfa/bfa_defs.h
@@ -902,7 +902,7 @@ struct sfp_mem_s {
 union sfp_xcvr_e10g_code_u {
 	u8		b;
 	struct {
-#ifdef __BIGENDIAN
+#ifdef __BIG_ENDIAN
 		u8	e10g_unall:1;   /* 10G Ethernet compliance */
 		u8	e10g_lrm:1;
 		u8	e10g_lr:1;
@@ -982,7 +982,7 @@ union sfp_xcvr_fc2_code_u {
 union sfp_xcvr_fc3_code_u {
 	u8		b;
 	struct {
-#ifdef __BIGENDIAN
+#ifdef __BIG_ENDIAN
 		u8	rsv4:1;
 		u8	mb800:1;    /* 800 Mbytes/sec */
 		u8	mb1600:1;   /* 1600 Mbytes/sec */
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 1ac5aec..eca7ab7 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -3727,11 +3727,11 @@ bfa_sfp_media_get(struct bfa_sfp_s *sfp)
 			 (xmtr_tech & SFP_XMTR_TECH_SA))
 			*media = BFA_SFP_MEDIA_SW;
 		/* Check 10G Ethernet Compilance code */
-		else if (e10g.b & 0x10)
+		else if (e10g.r.e10g_sr)
 			*media = BFA_SFP_MEDIA_SW;
-		else if (e10g.b & 0x60)
+		else if (e10g.r.e10g_lrm && e10g.r.e10g_lr)
 			*media = BFA_SFP_MEDIA_LW;
-		else if (e10g.r.e10g_unall & 0x80)
+		else if (e10g.r.e10g_unall)
 			*media = BFA_SFP_MEDIA_UNKNOWN;
 		else
 			bfa_trc(sfp, 0);
-- 
1.6.5.2

