From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Commit a692b0e broke my mvsas card
Date: Tue, 17 Apr 2012 10:17:34 -0700
Message-ID: <CABE8wwvThcO4B+qQUMBg+OMdTbF5VMZ0THD9SftSocj+oBOARw@mail.gmail.com>
References: <20120416224250.GA1983@bill-the-cat>
	<CABE8wwvbSsc02U_m+20-DQgsZ2gQCi_A6susCrmfyx_scQkccw@mail.gmail.com>
	<4F8CAC6F.6070907@ti.com>
	<1334620782.23541.2.camel@ultramagnus.opencreations.com>
	<4F8CCD0C.5060900@ti.com>
	<1334633159.13899.4.camel@dwillia2-mobl>
	<1334677637.3766.66.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:14164 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753946Ab2DQRRh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Apr 2012 13:17:37 -0400
Received: by bkcjm19 with SMTP id jm19so4805080bkc.25
        for <linux-scsi@vger.kernel.org>; Tue, 17 Apr 2012 10:17:35 -0700 (PDT)
In-Reply-To: <1334677637.3766.66.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Tom Rini <trini@ti.com>, linux-scsi@vger.kernel.org, Xiangliang Yu <yuxiangl@marvell.com>

On Tue, Apr 17, 2012 at 8:47 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Mon, 2012-04-16 at 20:25 -0700, Dan Williams wrote:
>> Agh, sorry, I rushed that one. =A0The phy array is initialized later=
, here
>> is another run at it:
>
> Are we sure it's initialised correctly in all the other SAS drivers t=
hat
> use (well, one other: aic94xx)?

Looks like we need:

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c
b/drivers/scsi/aic94xx/aic94xx_init.c
index ff80552..830f438 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -250,6 +250,7 @@ static int __devinit asd_common_setup(struct
asd_ha_struct *asd_ha)
                        SAS_LINK_RATE_1_5_GBPS;
                asd_ha->hw_prof.phy_desc[i].min_sata_lrate =3D
                        SAS_LINK_RATE_1_5_GBPS;
+               asd_ha->phys[i].sas_phy.id =3D i;
        }

        return 0;

> Given the oops issue, perhaps revert this for now and get a working
> patch in for the next merge window?

I have no strong feelings either way, but aic94xx and mvsas
maintainers have been hard to reach and I'm not encouraged more time
will yield a different result versus just moving ahead with these
fixes.

That said we still have Tom's discovery regression which is a separate =
issue.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
