From: Dan Carpenter <error27@gmail.com>
Subject: [patch 2/2 v2] [SCSI] bfa: fix some endian bugs
Date: Thu, 14 Jul 2011 12:48:59 +0300
Message-ID: <20110714094859.GV18655@shale.localdomain>
References: <20110706074024.GE18655@shale.localdomain>
 <E5313AF6F2BFD14293E5FD0F94750F86A82D670214@HQ1-EXCH01.corp.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50867 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab1GNJum (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jul 2011 05:50:42 -0400
Content-Disposition: inline
In-Reply-To: <E5313AF6F2BFD14293E5FD0F94750F86A82D670214@HQ1-EXCH01.corp.brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jing Huang <huangj@Brocade.COM>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, "open list:BROCADE BFA FC SC..." <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, Krishna Gudipati <kgudipat@Brocade.com>

The initial problem that I noticed was that
"if (e10g.r.e10g_unall & 0x80)" is always false because e10g_unall
is only one bit wide.

It should be testing just "if (e10g.r.e10g_unall)" instead, but that
also has a problem on big endian systems because there was a typo
where it said __BIGENDIAN and it should have said __BIG_ENDIAN.

Also I updated the other two tests in the if else block to match as
well.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/bna/bfi.h b/drivers/net/bna/bfi.h
index 6050379..b2611ef 100644
--- a/drivers/net/bna/bfi.h
+++ b/drivers/net/bna/bfi.h
@@ -104,7 +104,7 @@ union bfi_addr_u {
  * Scatter Gather Element
  */
 struct bfi_sge {
-#ifdef __BIGENDIAN
+#ifdef __BIG_ENDIAN
 	u32	flags:2,
 			rsvd:2,
 			sg_len:28;
diff --git a/drivers/scsi/bfa/bfa_defs.h b/drivers/scsi/bfa/bfa_defs.h
index ed8d31b..1cefb11 100644
--- a/drivers/scsi/bfa/bfa_defs.h
+++ b/drivers/scsi/bfa/bfa_defs.h
@@ -731,7 +731,7 @@ struct sfp_mem_s {
 union sfp_xcvr_e10g_code_u {
 	u8		b;
 	struct {
-#ifdef __BIGENDIAN
+#ifdef __BIG_ENDIAN
 		u8	e10g_unall:1;   /* 10G Ethernet compliance */
 		u8	e10g_lrm:1;
 		u8	e10g_lr:1;
@@ -811,7 +811,7 @@ union sfp_xcvr_fc2_code_u {
 union sfp_xcvr_fc3_code_u {
 	u8		b;
 	struct {
-#ifdef __BIGENDIAN
+#ifdef __BIG_ENDIAN
 		u8	rsv4:1;
 		u8	mb800:1;    /* 800 Mbytes/sec */
 		u8	mb1600:1;   /* 1600 Mbytes/sec */
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index d6c2bf3..bc678c7 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -3589,11 +3589,11 @@ bfa_sfp_media_get(struct bfa_sfp_s *sfp)
 			 (xmtr_tech & SFP_XMTR_TECH_SA))
 			*media = BFA_SFP_MEDIA_SW;
 		/* Check 10G Ethernet Compilance code */
-		else if (e10g.b & 0x10)
+		else if (e10g.r.e10g_sr)
 			*media = BFA_SFP_MEDIA_SW;
-		else if (e10g.b & 0x60)
+		else if (e10g.r.e10g_lr && e10g.r.e10g_lrm)
 			*media = BFA_SFP_MEDIA_LW;
-		else if (e10g.r.e10g_unall & 0x80)
+		else if (e10g.r.e10g_unall)
 			*media = BFA_SFP_MEDIA_UNKNOWN;
 		else
 			bfa_trc(sfp, 0);
