Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A393FBA7
	for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 08:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770883390; cv=none; b=QqYhzVJKcLwdzLj/Pn75j8duGWuGSQdSujyqaTOV/M0P/W2ch/0vwhgreHygoKvhmLbQe+M/dIwQtO4iEi398LBAEE+px9bLYvVkCPjIenGYVhh1EIo1kYZKKJnWTvfmVmcGGBGq6gn3lYWHpwvAKPMrW5H7mZuJ4vxvNpg9RvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770883390; c=relaxed/simple;
	bh=x/1NwjQR8WQrYs95rUypqiWEs4+Aa+xi0AWIGZ66VVg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cKiX8I81h3ASLmJTxpFx5vq/ZBXdKNrtGn1G6Jw50K6PNPMsRLeR/lRvcidfaogN2myDUFiHWEE9ULI+szBCMkqM1vCMhpZ/tz/yGA8NAeQ9I3H6S3farndvZx0u+JrlxkV2ueBzkhz1hrC74/995iNdvXqxnyg+ckWexhCucUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=MYYzriYe; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="MYYzriYe"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-43590777e22so3770524f8f.3
        for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 00:03:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1770883387; x=1771488187; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qIRCAVxhyJur4URYdmT/XFCiJu+Koro+ZoKkhnKQlTI=;
        b=MYYzriYeCaji/sAIZb6Uf1AI1ZDkG+31ZDijDUITzk4sK58sFal9MgY6S5HNN3how8
         H7jYwend0r1er7PmBdIXWJrzihSUdyG5J8XqkdSyzavi7BxsEHedLuXqdvMAWOpej5FF
         9UNeIisd/z4Tru82J5zRYc85kXcQNFythf1jCmamCNOkEDtmtjJ9ixl3a5aiYpm7loVb
         tnt18gD1XwcuKRVm8uSfQZp1VFIH6FiGFc1diMQhahNpWhCORuYztk6u1dDulmtW8S3y
         PYiWHkttYEkXtnc+F2oOAg8ItC2fWFXTsisyMoqf1kjNI0L7cy2m67K68l37zlgyhWXT
         +JjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770883387; x=1771488187;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qIRCAVxhyJur4URYdmT/XFCiJu+Koro+ZoKkhnKQlTI=;
        b=U2dQySP6GlVQY6Y1JbdBlCS9KxYxiER+SAKo967Uxw8qusjZEVt8SNQtv8iJL8c1jk
         XduAcx+6IWCTTzH1WlH1T/B7JZWoLvwxCo3pCZs9sJPYoQJi8PMywqMjFtUzP6YnDhy1
         V5qjpwcpVqeqcsKhmWVF7SsIvlX9XKUzmvioiQardEfyAk8uTsg+xxax2nhyzcX764Tx
         CuvBR/A2SZhK8ZITt3db6/HlZCkKK469e7EJUDcICbyAJ7llRCLi+JKOB0je7TQ2I7kX
         vtZjgG/5Q5CVHWS6gXLuZxsMIEkcdkFbsmLM9XDj2Tngp9ZjOgt2xoB8Ui/yTIOWHf7J
         +6Nw==
X-Forwarded-Encrypted: i=1; AJvYcCWI15MMs6B5YdiFBGVT1cLK30xeMaywbd4pwSo7KdflTv23JstTccgztoSvBsM/F/r3YLCAM8vFJIAa@vger.kernel.org
X-Gm-Message-State: AOJu0YyHKP1d+9hactZ1S9XU+Ma31+kGbkhLt8IynL7PctDxbGOUsggD
	nWO2H+FJbnraVhqI3hR5Y8dK8S7Ikd80svsepHxH6eNvyxyMUMptSxpmzKQwpOAss2w=
X-Gm-Gg: AZuq6aKNwpYCZtMz/p3oJSPWrVYudvG0Z1wSbNWIy9d/Ct/+0opBJlECdf4tk+N13pC
	4vxVQ9lnI73OKhOp5ccuEb0NITJcR5XRvI4vsFwzkv7fqFTLKFnk8TtVN1oc5nnrbZexVfydU5n
	8dE+QlnPIOemJeCf7iBBtjbVvlSVvhUR3yhvHPkoZKFnRxDPbGRz2upehpABXYefuyXwej1fRtp
	2LBLvgUw4LBphey48aITf0965dEb6tkiLRAkZ6UAAw+IIGNlR6RxsFxJZm2g7tFo5wTMFI7NHZi
	M9hPi6fWIwcNQ/0OHEcXPOEk2gIUtyp0mv375ySqz/bSeXqHbbwDVukKMEPTJ4X3XdCfp3nA/ND
	wtN3c6IGmaem9Z3ja43pU5+PMAtn4GMIBkoX6vEovuVmQpBcxYkTuaK53A4Yh5ipqSvPJfcYXA1
	yLmsyJB0BjjigHHmmYe+rT75uczAG6YGaEpVmM1n82dM5qKzXbG1n3PrZKW1OhuVcqyg6HTqqX3
	Jv/Y5ePCbEZ0MDKMVRRdXxFbTxUfRPVnMaNGgDC2NZQM11+E8dHd6P7IkjcPzcR/tO8Inc7
X-Received: by 2002:a05:6000:2212:b0:436:30b0:75a2 with SMTP id ffacd0b85a97d-4378acb6ff6mr3535596f8f.56.1770883386824;
        Thu, 12 Feb 2026 00:03:06 -0800 (PST)
Received: from ?IPV6:2003:fa:af22:2200:e0d6:dee7:4f29:a60a? (p200300faaf222200e0d6dee74f29a60a.dip0.t-ipconnect.de. [2003:fa:af22:2200:e0d6:dee7:4f29:a60a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43783e5c635sm10869559f8f.37.2026.02.12.00.03.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Feb 2026 00:03:06 -0800 (PST)
Message-ID: <f231ed5f-6c0c-4b20-8bf5-cafbaca26255@grsecurity.net>
Date: Thu, 12 Feb 2026 09:03:05 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: lpfc: Properly set WC for DPP mapping
To: Justin Tee <justintee8345@gmail.com>
Cc: Justin Tee <justin.tee@broadcom.com>, Paul Ely <paul.ely@broadcom.com>,
 linux-scsi@vger.kernel.org, James Smart <jsmart2021@gmail.com>
References: <20260113222716.2454544-1-minipli@grsecurity.net>
 <CABPRKS89zwXdUT1Bhj37cQDyOHNupOJ-Ez6kS7Dp_pu06X9Myw@mail.gmail.com>
 <CABPRKS-ongXPqWVpNYiKvy_afVKn999bxtSEfsBVQ7z5JVCgeQ@mail.gmail.com>
 <59933d92-eefe-49f6-ad70-79fe7aef0f3c@grsecurity.net>
 <CABPRKS8C4WmEYX+jtAOTS_jeFYt_GeTp9uBoWzCMF8cUZxxzUA@mail.gmail.com>
 <CABPRKS_cT5f21A-Jkx_uhA+SF4THpPSaqKtk8mWk9nN4Gh9LFQ@mail.gmail.com>
 <82f38f49-2f50-4c8b-9482-e446e61d5006@grsecurity.net>
 <CABPRKS8yunk2P9vH0qr0Z-FS3Og17btQDa6dxYDs_2G-1QXkjg@mail.gmail.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <CABPRKS8yunk2P9vH0qr0Z-FS3Og17btQDa6dxYDs_2G-1QXkjg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------1taZu0JzOKJyqvu517kGm0D4"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------1taZu0JzOKJyqvu517kGm0D4
Content-Type: multipart/mixed; boundary="------------4et2LoUgCXkyTOjo4Jorcd2z";
 protected-headers="v1"
From: Mathias Krause <minipli@grsecurity.net>
To: Justin Tee <justintee8345@gmail.com>
Cc: Justin Tee <justin.tee@broadcom.com>, Paul Ely <paul.ely@broadcom.com>,
 linux-scsi@vger.kernel.org, James Smart <jsmart2021@gmail.com>
Message-ID: <f231ed5f-6c0c-4b20-8bf5-cafbaca26255@grsecurity.net>
Subject: Re: [PATCH] scsi: lpfc: Properly set WC for DPP mapping
References: <20260113222716.2454544-1-minipli@grsecurity.net>
 <CABPRKS89zwXdUT1Bhj37cQDyOHNupOJ-Ez6kS7Dp_pu06X9Myw@mail.gmail.com>
 <CABPRKS-ongXPqWVpNYiKvy_afVKn999bxtSEfsBVQ7z5JVCgeQ@mail.gmail.com>
 <59933d92-eefe-49f6-ad70-79fe7aef0f3c@grsecurity.net>
 <CABPRKS8C4WmEYX+jtAOTS_jeFYt_GeTp9uBoWzCMF8cUZxxzUA@mail.gmail.com>
 <CABPRKS_cT5f21A-Jkx_uhA+SF4THpPSaqKtk8mWk9nN4Gh9LFQ@mail.gmail.com>
 <82f38f49-2f50-4c8b-9482-e446e61d5006@grsecurity.net>
 <CABPRKS8yunk2P9vH0qr0Z-FS3Og17btQDa6dxYDs_2G-1QXkjg@mail.gmail.com>
In-Reply-To: <CABPRKS8yunk2P9vH0qr0Z-FS3Og17btQDa6dxYDs_2G-1QXkjg@mail.gmail.com>

--------------4et2LoUgCXkyTOjo4Jorcd2z
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12.02.26 01:01, Justin Tee wrote:
>> You're hard-coding PCI_64BIT_BAR4 here which *feels* inappropriate if =
we
>> went all the way with wrappers like lpfc_dual_chute_pci_bar_addr() and=

>> making sure to be using the BAR the device told us. In fact, that was
>> the reason, I did it like this, assuming it might be something else th=
an
>> WQ_PCI_BAR_4_AND_5, e.g. a BAR shared with the doorbell registers. If
>> that cannot happen, what's the reason to have 'dpp_offset'?
>=20
> Totally right, we actually only use WQ_PCI_BAR_4_AND_5 for dpp.
> Hence, the hardcode to PCI_64BIT_BAR4.  Please see revised patch
> below.

But this would still be inconsistent with the previous mapping of the
DPP region (wq->dpp_regaddr) which uses 'dpp_barset' as gathered from
the hardware. This, at least, opens the window for inconsistencies
if/when a future devices returns something else than WQ_PCI_BAR_4_AND_5.

>=20
> The reason for dpp_offset is to be able to store the dpp register
> address for each individual WQ created.  We can just add the
> dpp_offset from the response of our mailbox command on top of the base
> dpp register address.

Ahh, that makes totally sense. Thanks for the explanation.

>=20
>> Also, what's the reason to do the offset calculation in the caller?
>> ioremap_wc() can handle non-page-aligned / offset addresses just fine.=

>> That's why my version passed dpp_offset to lpfc_dpp_wc_map() and made =
it
>> adjust the to-be-mapped address before calling ioremap_wc(); to only
>> remap what's needed.
>> Same for the size: I just capped it to what's needed by its only user =
in
>> lpfc_sli4_wq_put(). Again, ioremap_wc() will do "The Right Thing(TM)"
>> and map all required pages.
>=20
> Sure, but the DPP apertures are contiguous anyways so what=E2=80=99s th=
e harm
> in a single ioremap_wc call and then have each wq->dpp_regaddr point
> to its corresponding dpp register address, it seemed simpler?

Yeah, you're right. I missed the point that there are multiple queues,
each with a different offest into the DPP region.

>=20
>> Out of curiosity, the I/O stalls are no longer happening with this ver=
sion?
> Yes, I/O stalls are no longer happening with that version and the
> revised patch below.

Perfect!

>=20
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_ini=
t.c
> index a116a16c4a6f..b5e53c7d33e7 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -12039,6 +12039,8 @@ lpfc_sli4_pci_mem_unset(struct lpfc_hba *phba)
>                 iounmap(phba->sli4_hba.conf_regs_memmap_p);
>                 if (phba->sli4_hba.dpp_regs_memmap_p)
>                         iounmap(phba->sli4_hba.dpp_regs_memmap_p);
> +               if (phba->sli4_hba.dpp_regs_memmap_wc_p)
> +                       iounmap(phba->sli4_hba.dpp_regs_memmap_wc_p);
>                 break;
>         case LPFC_SLI_INTF_IF_TYPE_1:
>                 break;
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.=
c
> index 734af3d039f8..f4bff6ee3a0b 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -15981,6 +15981,23 @@ lpfc_dual_chute_pci_bar_map(struct lpfc_hba
> *phba, uint16_t pci_barset)
>         return NULL;
>  }
>=20

> +static __maybe_unused void __iomem *
> +lpfc_dpp_wc_map(struct lpfc_hba *phba)
> +{
> +       if (!phba->sli4_hba.dpp_regs_memmap_wc_p) {
> +               void __iomem *dpp_map;
> +
> +               dpp_map =3D ioremap_wc(phba->pci_bar2_map,
> +                                    pci_resource_len(phba->pcidev,
> +                                                     PCI_64BIT_BAR4));=

> +
> +               if (dpp_map)
> +                       phba->sli4_hba.dpp_regs_memmap_wc_p =3D dpp_map=
;
> +       }
> +
> +       return phba->sli4_hba.dpp_regs_memmap_wc_p;
> +}

To address my propably just paranoia concerns, can you pass 'dpp_barset'
as an argument to lpfc_dpp_wc_map() and add the following at the begin
of the function?:

	/* DPP region is supposed to cover 64-bit BAR2 */
	if (WARN_ON(dpp_barset !=3D WQ_PCI_BAR_4_AND_5))
		return NULL;

That would make me more comfortable with hardcoding BAR.

> +
>  /**
>   * lpfc_modify_hba_eq_delay - Modify Delay Multiplier on EQs
>   * @phba: HBA structure that EQs are on.
> @@ -16944,9 +16961,6 @@ lpfc_wq_create(struct lpfc_hba *phba, struct
> lpfc_queue *wq,
>         uint8_t dpp_barset;
>         uint32_t dpp_offset;
>         uint8_t wq_create_version;
> -#ifdef CONFIG_X86
> -       unsigned long pg_addr;
> -#endif
>=20
>         /* sanity check on queue memory */
>         if (!wq || !cq)
> @@ -17132,14 +17146,15 @@ lpfc_wq_create(struct lpfc_hba *phba, struct
> lpfc_queue *wq,
>=20
>  #ifdef CONFIG_X86
>                         /* Enable combined writes for DPP aperture */
> -                       pg_addr =3D (unsigned long)(wq->dpp_regaddr) & =
PAGE_MASK;
> -                       rc =3D set_memory_wc(pg_addr, 1);
> -                       if (rc) {
> +                       bar_memmap_p =3D lpfc_dpp_wc_map(phba);
> +                       if (!bar_memmap_p) {
>                                 lpfc_printf_log(phba, KERN_ERR, LOG_INI=
T,
>                                         "3272 Cannot setup Combined "
>                                         "Write on WQ[%d] - disable DPP\=
n",
>                                         wq->queue_id);
>                                 phba->cfg_enable_dpp =3D 0;
> +                       } else {
> +                               wq->dpp_regaddr =3D bar_memmap_p + dpp_=
offset;
>                         }
>  #else
>                         phba->cfg_enable_dpp =3D 0;
> diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli=
4.h
> index ee58383492b2..b6d90604bb61 100644
> --- a/drivers/scsi/lpfc/lpfc_sli4.h
> +++ b/drivers/scsi/lpfc/lpfc_sli4.h
> @@ -785,6 +785,9 @@ struct lpfc_sli4_hba {
>         void __iomem *dpp_regs_memmap_p;  /* Kernel memory mapped addre=
ss for
>                                            * dpp registers
>                                            */
> +       void __iomem *dpp_regs_memmap_wc_p;/* Kernel memory mapped addr=
ess for
> +                                           * dpp registers with write =
combining
> +                                           */
>         union {
>                 struct {
>                         /* IF Type 0, BAR 0 PCI cfg space reg mem map *=
/

Thanks,
Mathias

--------------4et2LoUgCXkyTOjo4Jorcd2z--

--------------1taZu0JzOKJyqvu517kGm0D4
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsD5BAABCAAjFiEEd7J359B9wKgGsB94J4hPxYYBGYYFAmmNiTkFAwAAAAAACgkQJ4hPxYYBGYaP
/gv+NFWzh/Iszyku2tcrbma9QDih38viBTR5yW/Zosqxct/UjssR/Vi67m08yMTLqLzNtXrdp+qL
Ywf2XkfuU32IZvf02w/Hz7yGT09pmeT2zRo7jhUdbjD8vlit98eXh9MmPnyGSFiBf9xOIccjRpJt
Ulbf17FnwU8AMyUAPkjsCZ9PBvHCub6mRefV9ah2yJLFboT/bRsCB6OMbU9j7NZePbaos+lVqyb6
am1tuPgq/5HjOOXgqBMSQ09YvLlcYGoYU1GDCMx1bhPinxrRkldNDJK1QxBz+qQunbnjUguaBL7g
2VkUCV1zCkhTALgUVlvgIwOFSucfq2Jw/9scqi4N5qse09YRVq9Y4J4vGX2CF8kAP1abwoqnfVwH
Keiix4lp7xm3Qf2z7SV2DjBuTwI6AuFuv9/R2cCRqHsIcat0zydXlpxfTYGROU5dF73j8z4UlL9E
pHb5KxMUzKFVsq5noQSf5paDVPtACIviTauMlPNeWbTiFoPJmM877h8eN3/1
=lIMP
-----END PGP SIGNATURE-----

--------------1taZu0JzOKJyqvu517kGm0D4--
