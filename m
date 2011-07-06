From: Dan Carpenter <error27@gmail.com>
Subject: [patch 2/2] [SCSI] bfa: test is always false in bfa_sfp_media_get()
Date: Wed, 6 Jul 2011 10:40:24 +0300
Message-ID: <20110706074024.GE18655@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Jing Huang <huangj@brocade.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, "open list:BROCADE BFA FC SC..." <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

e10g.r.e10g_unall is only 1 bit so "if (e10g.r.e10g_unall & 0x80)"
is always false.  e10g is a union between an unsigned char and named
bitfields.  The intent here was to test the named bitfield by
itself.

We can change the previous tests as well.  That improves the
readability and it looks like it fixes a endian bug as well.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
I don't understand where __BIGENDIAN is defined.  Only this driver
references it.  How does that work?

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 052373b..090a19d 100644
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
