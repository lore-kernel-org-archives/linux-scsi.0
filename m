Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644A952CCF5
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 13:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791984765; cv=pass; b=jzsDComjhIPDC5NYjk0+wne/FiLunYehmOretVZX0fEeVLt0xyWkvKZmopSKxwqsDjeSejAJjzAtfn59oNzJV9+wZCn1Ze80ChNMgYDLKiv0GeyLreHa8iPhm/FwheHGLUy+skfymCXQ8Uw8xyxGr5lD3kwr50fv2m6euiZHZ20=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791984765; c=relaxed/simple;
	bh=V7L0U99tvHTcidmbzjPFzdvF7D2gTMvorlFarKDKzI4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iGxHelkWU1U/w45rfsKJybD6Xgt8yjqsicNPk+ArzC4AeoxJqcZhq55iNOM0hWSA30nEjEgd/bMcOImTtaxvEqfiVVnP6XzgBLGINN3QWFbBIkrQNhUz32hUd1YuDLcoqrYaqr1ABD9nCle1N7+NNJorLUW2BV+Jv7JpsSG0eP0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gwb/F3+b; arc=pass smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gwb/F3+b"
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-4877837890fso2111489fac.2
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 06:32:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791984755; cv=none;
        d=google.com; s=arc-20260327;
        b=WP3moGJtoyKIUAtjL9wyq9Nr2Uk8b007yTA+PGuHZRDdfgyLWeuvf46JYIHbalAjaf
         Vr5kFq/1RL05zcvk+VyHTaZLl9SIR9IkDbCjhTbqH4phVJd69B6ROY9/6ag5xNnFae4S
         GiN9zuvXniw25MPo0YhZq6s/0+1Yc2Yj3NGgoNJ5NpD1MmwCeMXptdDwSjuVenKuiaJ0
         kzy75QfBY8Z3/X39AnPoW60GWq19M60t4zUJioyVTBkx1rUEewF6Bm+GM1N0i6dxtUal
         4cCmLE76YzzMphMteXUbCW6WepHRxlldryUVesROPssyeM1frSBeH6DOtzcC8CkaJU1l
         efLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0cq6NAcXfJKAWF6qtJbi/GVl7FMcXFpRqPlXUsw78lA=;
        fh=oaJrLIznoH60eTotQTUjeBSOHALKslWfOTMXeujw+18=;
        b=C2n2pB3N43sI3vbLSJB1z0WivYX31EtJit1dXwCGYzPU2X70M0aCUXqU1I9fOG8gem
         9xd5K31BSrBgjStx3//CzR7BU6p3gvF+cTjdKIvAzwMod5olCYoFS3ZB1HHodFIDCVu6
         0hSY1QERkSA+C5SidXR3E9RaG5lF1jLZLxc+/LD/lvONH1AUtrX8RhH+kSfBCyX0PzPE
         EBrEpm2TGPWGSIh7KpeqwK/XpeTh7qHBgHzfzUrMTC0ihlIOo9gGoED6HIrFs+zxBf/m
         e5EJAQEwfptoS0zAH03glKBYO+zWqbtrx11uWzFx2VAbzTEAXSAZdVID/2i0roRJU4xT
         m8Qw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791984755; x=1792589555; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0cq6NAcXfJKAWF6qtJbi/GVl7FMcXFpRqPlXUsw78lA=;
        b=gwb/F3+bhzEANoW8ytOJFrGW9BaO92DVTwjHSnHe0vfQQgYYeOdmOmIHo9Muo4a7YE
         Zn+0tb4foXBcrn0gJepRQib0Q2diRgzsfkkUu7EakFANYm6GEfSNtjAJATrIeXdqM66I
         kOuOoBcvGG0jEf1rQtRK/INo6nOmATIjoNeVIqkKK0DFrhKvIDNiz6QiG74GIRtt193s
         34u5G1mEEAihjPIESS+I3+ww4nHQC/tndVf6B4pwuG5SgEYMquwWZrPG+q18XZgWHNMf
         2376sF1DKXJLKnRWgRnrLIhom6XoJq3hWMBBDfVvM1x/A0VgKMHm3V3OkJKXcxRZP1ZO
         Lg1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791984755; x=1792589555;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0cq6NAcXfJKAWF6qtJbi/GVl7FMcXFpRqPlXUsw78lA=;
        b=AbsHD95C372PKenSzoOK38TBpPVH1DHW3PgG0Hb+AuLln3hK/4LiNWSoo5sWXrTLcy
         SCraUrv6mnQqfzV3J/JOrt65zmEpyd01WurqQJZmTlvRmhlW/HsTbIBzQI8kAEPBdRfl
         +P8XXCDV1M8pJD5o0zeNT6XF7nwdHXdg0pFWRFntxQhySPRetWHJnA2cCNpFocQMMvBk
         a8QY5e4WNbeBEK9ITux1vK00Po1gaupMB07gajHsAsttE1RA4Da7Po2M4JzRaH20UJ9q
         RzvE8jfWl0dWkTtHNHCvptK+rw52xsYFm1ppnxWVT909IJgq4YAIZJwpiTPnu8CabzJd
         0osg==
X-Forwarded-Encrypted: i=1; AKwUvBxZF2mWA38fnlvlkv+gbpPSvJoNL4/w/zBDk59n5226xR4F8aAy0PkpsNeTQkPKS12duw8BgXCLAFCi@vger.kernel.org
X-Gm-Message-State: AFq9FYILQQ7GNUUEtnQcb5I9VdE/ItAx4bLmxZIClRjJyZbaXIyH90IX
	bqjsG+h2I/vojSohxHDyGaT4ehbtXfVSo+lZQIQM3uCg8c+TC3KzgjcsQoPJckQSwpFUAXa1LWN
	bH4cR7AFvsjLv9WW118Icf2qoJQCHmEB+UZoXju7gnchZeRU=
X-Gm-Gg: AYBFou3FkGU8YXDmzMT64vf1omtLDZ12KtloPd3bWqX6d5SAW7PYzDreSbS9RRJYuhn
	H/7xyyApl0i9EkRM3TRZxqtDtx9TxGxlNwPi4n2jwYetA0HiSHvx39X7vcq5l3N+B48/8p5REI2
	xwdR+1w85E+6JgjV/M61grq/4nRyUgeSi7o1EIzplyML6tikYZveTGBAH3P1g/Abog1ezgpvhpX
	xMNtFoAp1VAwWAoI5XQy3goF0Kb5KmRax7UBx5X6B/4eHk+46KCaCG/it2+2+wlmBKgyU0QUUCy
	Q0qKQ4c2h5CcW4tEvOOqEfNV3KdtTbJGAsI8ThllSB66GEvXe6RST8gaNpIZVAB2SgALKukxr8n
	3IlC2W2GV/CWV
X-Received: by 2002:a05:6870:331f:b0:48f:e24e:6b6c with SMTP id
 586e51a60fabf-4a2a8b580eemr14205687fac.61.1791984754940; Wed, 14 Oct 2026
 06:32:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260804142800.4326-1-khomyakovilya@gmail.com> <111e94e9-79c9-48f2-8976-70470e59b89d@leemhuis.info>
In-Reply-To: <111e94e9-79c9-48f2-8976-70470e59b89d@leemhuis.info>
From: =?UTF-8?B?0JjQu9GM0Y8g0KXQvtC80Y/QutC+0LI=?= <khomyakovilya@gmail.com>
Date: Wed, 14 Oct 2026 16:32:23 +0300
X-Gm-Features: AclHuK9k2427IzCFQzfxk5ijt-NQbFahalRCOSjfqEOAYJAuXMNGRteO6GZZ_0o
Message-ID: <CABrBgxdQ1Jn40wR_yEzjxz=BO9YvM530fqTG=F4EvC3m=6RoZQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: mpi3mr: use DevicePage0 link rate only for
 direct-attached targets
To: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Ranjan Kumar <ranjan.kumar@broadcom.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, 
	Sumit Saxena <sumit.saxena@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
	mpi3mr-linuxdrv.pdl@broadcom.com, regressions@lists.linux.dev, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello.
After sending the email, I didn't receive any response from anyone.

Regards,
Ilya.

=D0=BF=D0=BD, 12 =D0=BE=D0=BA=D1=82. 2026=E2=80=AF=D0=B3. =D0=B2 18:48, Tho=
rsten Leemhuis <regressions@leemhuis.info>:
>
> On 8/4/26 16:28, Ilya Khomyakov wrote:
> > This patch fixes a regression in the Broadcom MPI3 Storage Controller
> > driver under drivers/scsi/mpi3mr/.
>
> Ilya, what's the status of this regression fix? It looks like it fall
> through the cracks. Or was there some progress that I missed (which can
> easily happen!)
>
> Ciao, Thorsten
> > Commit c273c14b0294 ("scsi: mpi3mr: Use negotiated link rate from
> > DevicePage0") changed mpi3mr to prefer the cached DevicePage0 rate.
> >
> > DevicePage0 stores negotiated_link_rate as one standalone MPI3 SAS
> > link-rate code, while SAS PHY Page 0 and SAS Expander Page 1 store logi=
cal
> > and physical rates as two nibbles of one packed byte.
> >
> > mpi3mr_get_sas_negotiated_logical_linkrate() currently sends both forma=
ts
> > through the same high-nibble extraction at its common exit. A valid
> > DevicePage0 value of 0x0b or 0x0c is therefore converted to zero. The l=
ater
> > minimum-rate safeguard then publishes the value as 1.5 Gbit/s.
> >
> > For example:
> >
> >   DevicePage0 value:            0x0b
> >   packed-field extraction:      (0x0b & 0xf0) >> 4 =3D 0x00
> >   minimum-rate substitution:    0x00 -> 0x08
> >   Linux SAS transport result:   1.5 Gbit/s
> >
> > There is also a topology distinction. The caller uses the returned valu=
e to
> > update the parent sas_phy. In an expander topology with the HBA-to-expa=
nder
> > link limited to 12 Gbit/s, DevicePage0 reported 0x0b for every tested
> > target, while Expander Page 1 reported 0xcc for several disk-facing PHY=
s
> > that were operating at 22.5 Gbit/s. The cached target value therefore
> > cannot unconditionally replace the local parent expander PHY value.
> >
> > The original failure was reproduced on an eHBA 9600 controller with a
> > SAS4016 IOC and a 46-PHY Microchip expander. Before the fix, a target w=
ith
> > DevicePage0 negotiated_link_rate 0x0b could remain visible in sysfs as
> > 1.5 Gbit/s when a replayed topology event contained current=3D0x0b and
> > previous=3D0x0b and therefore skipped the Linux-side update.
> >
> > Validate the standalone DevicePage0 code and use it directly only for a
> > directly attached target. For an expander-attached target, retain the
> > existing Expander Page 1 path because it describes the local parent
> > expander PHY being updated. Retain the SAS PHY Page 0 fallback when a
> > directly attached cached value is invalid.
> >
> > The topology-aware variant was tested in an out-of-tree mpi3mr 8.17.1.0=
.
> > build. After boot, Linux reported:
> >
> >   PHY 18: 12.0 Gbit/s
> >   PHY 19: 12.0 Gbit/s
> >   PHY 24: 22.5 Gbit/s
> >   PHY 25: 22.5 Gbit/s
> >   PHY 26: 22.5 Gbit/s
> >   PHY 27: 22.5 Gbit/s
> >   PHY 28: 12.0 Gbit/s
> >   PHY 30: 22.5 Gbit/s
> >
> > No tested PHY was incorrectly reported as 1.5 Gbit/s, and the 22.5 Gbit=
/s
> > disk-facing rates were preserved even though DevicePage0 contained 0x0b=
.
> >
> > Fixes: c273c14b0294 ("scsi: mpi3mr: Use negotiated link rate from Devic=
ePage0")
> > Signed-off-by: Ilya Khomyakov <khomyakovilya@gmail.com>
> >
> > ---
> >  drivers/scsi/mpi3mr/mpi3mr_transport.c | 46 ++++++++++++++++++++++----
> >  1 file changed, 39 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3=
mr/mpi3mr_transport.c
> > index 240f67a..740fccc 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
> > @@ -587,6 +587,30 @@ static enum sas_linkrate mpi3mr_convert_phy_link_r=
ate(u8 link_rate)
> >       return rc;
> >  }
> >
> > +/**
> > + * mpi3mr_sas_link_rate_valid - validate a standalone SAS link-rate co=
de
> > + * @link_rate: MPI3 standalone SAS negotiated link-rate code
> > + *
> > + * DevicePage0 stores one plain negotiated link-rate code. Accept only
> > + * negotiated data rates supported by the SAS transport conversion cod=
e;
> > + * reserved or transitional values must use the existing PHY-page path=
.
> > + *
> > + * Return: true for a supported negotiated data rate, false otherwise.
> > + */
> > +static bool mpi3mr_sas_link_rate_valid(u8 link_rate)
> > +{
> > +     switch (link_rate) {
> > +     case MPI3_SAS_NEG_LINK_RATE_1_5:
> > +     case MPI3_SAS_NEG_LINK_RATE_3_0:
> > +     case MPI3_SAS_NEG_LINK_RATE_6_0:
> > +     case MPI3_SAS_NEG_LINK_RATE_12_0:
> > +     case MPI3_SAS_NEG_LINK_RATE_22_5:
> > +             return true;
> > +     default:
> > +             return false;
> > +     }
> > +}
> > +
> >  /**
> >   * mpi3mr_delete_sas_phy - Remove a single phy from port
> >   * @mrioc: Adapter instance reference
> > @@ -2292,18 +2316,26 @@ void mpi3mr_expander_remove(struct mpi3mr_ioc *=
mrioc, u64 sas_address,
> >  static u8 mpi3mr_get_sas_negotiated_logical_linkrate(struct mpi3mr_ioc=
 *mrioc,
> >       struct mpi3mr_tgt_dev *tgtdev)
> >  {
> > -     u8 link_rate =3D MPI3_SAS_NEG_LINK_RATE_1_5, phy_number;
> > +     u8 cached_link_rate, link_rate =3D MPI3_SAS_NEG_LINK_RATE_1_5;
> > +     u8 phy_number;
> >       struct mpi3_sas_expander_page1 expander_pg1;
> >       struct mpi3_sas_phy_page0 phy_pg0;
> >       u32 phynum_handle;
> >       u16 ioc_status;
> >
> > -     /* First, try to use link rate from DevicePage0 (populated by fir=
mware) */
> > -     if (tgtdev->dev_spec.sas_sata_inf.negotiated_link_rate >=3D
> > -         MPI3_SAS_NEG_LINK_RATE_1_5) {
> > -             link_rate =3D tgtdev->dev_spec.sas_sata_inf.negotiated_li=
nk_rate;
> > -             goto out;
> > -     }
> > +     cached_link_rate =3D
> > +             tgtdev->dev_spec.sas_sata_inf.negotiated_link_rate;
> > +
> > +     /*
> > +      * For a directly attached target, DevicePage0 and the parent hos=
t PHY
> > +      * describe the same link, so the standalone cached code can be u=
sed
> > +      * without packed-field decoding. For an expander-attached target=
, the
> > +      * caller updates the parent expander PHY and DevicePage0 can dif=
fer from
> > +      * that local segment; retain the Expander Page 1 read in that ca=
se.
> > +      */
> > +     if ((tgtdev->devpg0_flag & MPI3_DEVICE0_FLAGS_ATT_METHOD_DIR_ATTA=
CHED) &&
> > +         mpi3mr_sas_link_rate_valid(cached_link_rate))
> > +             return cached_link_rate;
> >
> >       /* Fallback to reading from phy pages if DevicePage0 value not av=
ailable */
> >       phy_number =3D tgtdev->dev_spec.sas_sata_inf.phy_id;
>
