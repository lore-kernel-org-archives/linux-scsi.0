From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Commit a692b0e broke my mvsas card
Date: Tue, 17 Apr 2012 22:11:05 -0700
Message-ID: <CAA9_cmeY0VaRqgfjqZbFbqP8u+wvkJ8=dJUNk9kkBabAF15t1w@mail.gmail.com>
References: <20120416224250.GA1983@bill-the-cat>
	<CABE8wwvbSsc02U_m+20-DQgsZ2gQCi_A6susCrmfyx_scQkccw@mail.gmail.com>
	<4F8CAC6F.6070907@ti.com>
	<1334620782.23541.2.camel@ultramagnus.opencreations.com>
	<4F8CCD0C.5060900@ti.com>
	<1334633159.13899.4.camel@dwillia2-mobl>
	<1334677637.3766.66.camel@dabdike>
	<CABE8wwvThcO4B+qQUMBg+OMdTbF5VMZ0THD9SftSocj+oBOARw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64464 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab2DRFLG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Apr 2012 01:11:06 -0400
Received: by obbta14 with SMTP id ta14so6123089obb.19
        for <linux-scsi@vger.kernel.org>; Tue, 17 Apr 2012 22:11:05 -0700 (PDT)
In-Reply-To: <CABE8wwvThcO4B+qQUMBg+OMdTbF5VMZ0THD9SftSocj+oBOARw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Tom Rini <trini@ti.com>, linux-scsi@vger.kernel.org, Xiangliang Yu <yuxiangl@marvell.com>

On Tue, Apr 17, 2012 at 10:17 AM, Dan Williams <dan.j.williams@intel.co=
m> wrote:
> On Tue, Apr 17, 2012 at 8:47 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
>> On Mon, 2012-04-16 at 20:25 -0700, Dan Williams wrote:
>>> Agh, sorry, I rushed that one. =A0The phy array is initialized late=
r, here
>>> is another run at it:
>>
>> Are we sure it's initialised correctly in all the other SAS drivers =
that
>> use (well, one other: aic94xx)?
>
> Looks like we need:
>
> diff --git a/drivers/scsi/aic94xx/aic94xx_init.c
> b/drivers/scsi/aic94xx/aic94xx_init.c
> index ff80552..830f438 100644
> --- a/drivers/scsi/aic94xx/aic94xx_init.c
> +++ b/drivers/scsi/aic94xx/aic94xx_init.c
> @@ -250,6 +250,7 @@ static int __devinit asd_common_setup(struct
> asd_ha_struct *asd_ha)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0SAS_LINK_RATE_1_5_GBPS=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0asd_ha->hw_prof.phy_desc[i].min_sata_l=
rate =3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0SAS_LINK_RATE_1_5_GBPS=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 asd_ha->phys[i].sas_phy.id =3D i;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0return 0;
>
>> Given the oops issue, perhaps revert this for now and get a working
>> patch in for the next merge window?
>
> I have no strong feelings either way, but aic94xx and mvsas
> maintainers have been hard to reach and I'm not encouraged more time
> will yield a different result versus just moving ahead with these
> fixes.
>
> That said we still have Tom's discovery regression which is a separat=
e issue.

I take it back.

I overlooked what Tom said at the very beginning.  Everything is fixed
by the revert, and I now see why my later "fix" made it worse.  The
fix overlooked that mvsas is indeed initializing the phy ids, but in
the "multi-chip" case it does a rather annoying duplication of phy ids
in the array passed to libsas.  So, for example, chip0 has phy0-3 at
ha phy index 0-3 and chip1 has its phy0-3 at ha phy index 4-7.  So the
"fix" was breaking mvsas's ability to lookup phys by id and the
original commit is tripped up by mvsas's scheme of putting non-unique
ids in the sas_ha_struct.

Question for a later day, but why isn't mvsas creating a scsi_host per
chip??  That can only help performance and is more in line with
reality.

To properly support commit a692b0e mvsas would either need to convert
to a shost-per-chip or use a helper like:

static inline struct mvs_phy *to_mvs_phy(struct mvs_info *mvi, int phy_=
id)
{
        return mvi->phy[phy_id - mvi->chip->n_phy * mvi->id];
}

=2E..everywhere it converts from a libsas phy id back to a local phy st=
ructure.

Both of these options are way too big for 3.4-rc4, so I'll queue up
the revert with a Reported-by and Tested-by from Tom.

Thanks again for the report and help Tom.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
