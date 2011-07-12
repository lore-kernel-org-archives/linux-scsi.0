From: Jing Huang <huangj@Brocade.COM>
Subject: RE: [patch 2/2] [SCSI] bfa: test is always false in
 bfa_sfp_media_get()
Date: Mon, 11 Jul 2011 23:54:46 -0700
Message-ID: <E5313AF6F2BFD14293E5FD0F94750F86A82D670214@HQ1-EXCH01.corp.brocade.com>
References: <20110706074024.GE18655@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110706074024.GE18655@shale.localdomain>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, "open list:BROCADE BFA FC SC..." <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, Krishna Gudipati <kgudipat@Brocade.com>
List-Id: linux-scsi@vger.kernel.org

>-----Original Message-----
>From: Dan Carpenter [mailto:error27@gmail.com]
>Sent: Wednesday, July 06, 2011 12:40 AM
>To: Jing Huang
>Cc: James E.J. Bottomley; open list:BROCADE BFA FC SC...; linux-
>kernel@vger.kernel.org; kernel-janitors@vger.kernel.org
>Subject: [patch 2/2] [SCSI] bfa: test is always false in bfa_sfp_media_get()
>
>e10g.r.e10g_unall is only 1 bit so "if (e10g.r.e10g_unall & 0x80)"
>is always false.  e10g is a union between an unsigned char and named
>bitfields.  The intent here was to test the named bitfield by
>itself.
>
>We can change the previous tests as well.  That improves the
>readability and it looks like it fixes a endian bug as well.
>
>Signed-off-by: Dan Carpenter <error27@gmail.com>
>---
>I don't understand where __BIGENDIAN is defined.  Only this driver
>references it.  How does that work?
>
>diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
>index 052373b..090a19d 100644
>--- a/drivers/scsi/bfa/bfa_ioc.c
>+++ b/drivers/scsi/bfa/bfa_ioc.c
>@@ -3589,11 +3589,11 @@ bfa_sfp_media_get(struct bfa_sfp_s *sfp)
> 			 (xmtr_tech & SFP_XMTR_TECH_SA))
> 			*media = BFA_SFP_MEDIA_SW;
> 		/* Check 10G Ethernet Compilance code */
>-		else if (e10g.b & 0x10)
>+		else if (e10g.r.e10g_sr)
> 			*media = BFA_SFP_MEDIA_SW;
>-		else if (e10g.b & 0x60)
>+		else if (e10g.r.e10g_lr && e10g.r.e10g_lrm)
> 			*media = BFA_SFP_MEDIA_LW;
>-		else if (e10g.r.e10g_unall & 0x80)
>+		else if (e10g.r.e10g_unall)
> 			*media = BFA_SFP_MEDIA_UNKNOWN;
> 		else
> 			bfa_trc(sfp, 0);

Hi Dan,

__BIGENIDIAN is a bug and it needs to be replaced with __BIG_ENDIAN.
The first two changes will introduce endianness issue without having __BIGENDIAN fixed.
The third change is good but also needs the same fix to make the code endianness netural,.

Thanks
Jing
