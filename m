Received: from mail-pf1-f228.google.com (mail-pf1-f228.google.com [209.85.210.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04AFD38B7A6
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2026 09:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.228
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776158409; cv=pass; b=UlXEZlDaFRfyQmzH/ngESyuHnEoHsqM9FzH4l2xi3A1Fit/GE4I1M58KfK8CGRuvC3KIwr2qp9OKHXJ8kEx1AinAve9ODDkctYZxmjZAz8wIw3Ci/sEeE6I2WqajKX8+AnJupdj0ebfd8qw6krh7oNMRe+A94ed7gg93c13KIaY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776158409; c=relaxed/simple;
	bh=RuD/HJuKk2zPC3QR4ycAFIuUJFmkalObwFEV6pAFQNk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CCLFmin6DLVP4+HJ/L7TPvAsLvaYEogbTaThfK8pt/goBHWNURwiXuWvJY0nWBXqyrX94tD9kZyIxGnbv8GMeUbw79cvJgLwoZ2FJcV/1sGriambYmVWWlBKuhHUB4mnTfDgfg5bKI+7Y5r2Hd+VyoHDvapBig+kdYSjI3vOQnw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=bXt2uBXg; arc=pass smtp.client-ip=209.85.210.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="bXt2uBXg"
Received: by mail-pf1-f228.google.com with SMTP id d2e1a72fcca58-8296dabef74so5169331b3a.1
        for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2026 02:20:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776158407; x=1776763207;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6tCYcmZNYiUj24L2Q8eRDG9xl1n0qFnwSLCZ6vXrneA=;
        b=rcUPAxlgxMbkVJjMBMghCX6ucX8SHZTEFzebeQrSnsRsJZbtgXR5xwlC83t9nVaRqP
         4b+5hwDrV73zbm/IuzFIVv7Gc7+NORjAArL1+peDdXhV6ymdnev+BgIeoN9kh/6K0nzJ
         wUC2a04Zstj0DvdfPO+04FD17O97k8gykcgQNzVRxhfCX5XKszeNOFS1vgn5/A5nDfUg
         DAs5ojlchYhn24V84RpBKP5GVs8NNTFdNTueStzBC7tkPdcr5HA1k8umD5mDHhdmJT/p
         F+djKUF61ynNnGtzARDeCI1Sk9zPeyuBu28tFscOqi238jqY8JjMxfw8veBLjimKhyfU
         KYAQ==
X-Gm-Message-State: AOJu0YzK8JeQu4P3nAmBBtR4k0o4Uhgxgv/fPc5i2z7FjzJ/h9ErO4sh
	BVpnb8gQ+1j36NEJDRruTwEHa8dLh/oEv7KFW8Gc4K9ngtvX5rmXM/7/uNXlhINwzjegcs6FkVz
	Dn2W42HlH+gEe1MTL1Q6MeGQeEHQNh5j+G3KbXeINkQekD73WJGzpLM9pjI6v/PmoxK15lwiGUS
	yILJU8n1afnAALmygiYcUs73OBCMm8s7IVuqNu63w/gOSxr2pMcemPmztD4mLwn4ibx4uGSxfE+
	MUWpcZoJnVWBcZU
X-Gm-Gg: AeBDieuFyO1drTeqaFL6qhoxUQhfpDgv7ZF3MlMLy5vSXV+DW9BYuUDYWOAtC+O1VT9
	+cZxYSJk8Tzq9s5Ma17NZTm5HI7Bd3fawRD3WbvWWnU1uthYjr+bjFXpBJYB9TZroCN+NLnqLTC
	nq7gVnCGgTKuKITmiQpJs9BunixgYmkphdLVW0i9iQNXRwXKpHTO/OTm3GLeGNNCwqQ+sOKfmuO
	Me1OQXzxZvj1dbQMzATHgSNVASeqVDeHqIZ+cgcCLxZuXM/WUoxOTFqaJmdpjl/33AlaLqjKr1X
	f4fIFRrY/Z28Hx3THqgaHdvMUgC5jeZ/agbT9xs18zlBFoYsUooXpIYETlW3wgPxlbA7avh+S/+
	BI+1tEmhryvh4a4/5RMqZIjkK3N6POLPVzXJGEcIuzZjx2nLupjMXqmE6i8Ei6OjOVi0Q6syl36
	V95tCVs17DyKTFQI1rd3upmmYP6QSxO6EUbtMrUggLoAlxQ6+y3qrQQW+e
X-Received: by 2002:a05:6a00:889:b0:82f:4566:bbdf with SMTP id d2e1a72fcca58-82f4566bf69mr6112932b3a.14.1776158407124;
        Tue, 14 Apr 2026 02:20:07 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-24.dlp.protect.broadcom.com. [144.49.247.24])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-82f55d7adc6sm108326b3a.7.2026.04.14.02.20.06
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Apr 2026 02:20:07 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-66e6f1b315dso1098114a12.3
        for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2026 02:20:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776158405; cv=none;
        d=google.com; s=arc-20240605;
        b=KAkLOMcNXggxq2t0vhQ173tS6fvDTRNWGk++oe4kt1CDyXbbKrD8RwkoqlPODCHEk1
         OpLyVmZvSwlo6Hcr+bYwcBOIuYNwIklCU98bzLZEPGLOeKiiVYnJWpUAVjilL8Bk7Yja
         vPXXVYGKTY4EtVZk8qaLxgbX/JcN9QDgi9HFF5EShHiPM7M93/uPPPrg55GZBLPolMIr
         l74TwAbwDS5/EPe98MyRifHOVbsaQfGwbYSCGzJsYMJ61xNfaTY5AE064TZtK22Q5t/A
         GKaT26/lQhWHsQ0h06hP8gNeVolvorERQLT+AWdQlcxYbIsKQysBHCwkeaH15vEjgBJm
         r7/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=6tCYcmZNYiUj24L2Q8eRDG9xl1n0qFnwSLCZ6vXrneA=;
        fh=9f15ZSM6ai6bIdPC3RWXgKqFPOKefmfqUfRUkgqmAPo=;
        b=IygfEoBRESSpo4N7QS9qV339qc0GCxNlA7oAtRF9a4fc/MT/+jS59t+Z5DZsINX23G
         RE5gjwoijz2PB7rAqf6rWaVtKTgLHNaKjxNEemzitgaN7dqs6XYfCLTScuwDXau55jDV
         LL0ONEJcC5mY+qWJNnu/V+9idETTER8tDEz129/rxknIpPB2fEXK+5S2lCJxdRnwSAOp
         es8ClLGkKUDXqvFcJ0jY0YctTOk5uMcQV3Qy1DrODhPPKYkE4oqiPRGiLOqtNgUGtGYp
         jZf9LbMS7QoJRabSLdakQckVckoTTEAy2RV/97kbpLNlDBe2NGsZ1X7TYyj2/6DUw9yl
         Zh+A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1776158405; x=1776763205; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6tCYcmZNYiUj24L2Q8eRDG9xl1n0qFnwSLCZ6vXrneA=;
        b=bXt2uBXgVZEZ244Sc8RsTLHmvjokz5dHPutMUHGVajTm3Eo5rvqsSZ2lBvTqhrxYfo
         i+BGlxZBJKQApVIIq3gLrrsQOamU5kHPywWFVC9TNOOFiXzL/qTvEgGLBQ9F2AeJ2NL4
         fqBtJdH/mgVvfEL9TBLW/ExHoou63km5KyqnM=
X-Received: by 2002:a17:907:8b8a:b0:b9c:c5a2:c82c with SMTP id a640c23a62f3a-b9d7267eedamr997548666b.40.1776158405070;
        Tue, 14 Apr 2026 02:20:05 -0700 (PDT)
X-Received: by 2002:a17:907:8b8a:b0:b9c:c5a2:c82c with SMTP id
 a640c23a62f3a-b9d7267eedamr997546066b.40.1776158404288; Tue, 14 Apr 2026
 02:20:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260413180003.76489-1-ranjan.kumar@broadcom.com>
 <20260413213335.4010d8f2@pumpkin> <5ecd8d50-d7dc-43a3-b157-8717c6fc02d4@kernel.org>
 <20260414081210.2b63e350@pumpkin> <a7101526-3b23-4474-afc8-bd39e7e3646f@kernel.org>
In-Reply-To: <a7101526-3b23-4474-afc8-bd39e7e3646f@kernel.org>
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
Date: Tue, 14 Apr 2026 14:49:48 +0530
X-Gm-Features: AQROBzDsPVEBLUcXgLkxLJNBeXQCV_8Vydhz7BNt8ge18DBwz0C0MP31y-mYtBY
Message-ID: <CAMFBP8O9oxBiYVHChBjdAQpca3P6wU=jSMHGexxKYXYPHQGL8A@mail.gmail.com>
Subject: Re: [PATCH v3] mpt3sas: Limit NVMe request size to 2 MiB
To: Damien Le Moal <dlemoal@kernel.org>, David Laight <david.laight.linux@gmail.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, 
	sathya.prakash@broadcom.com, chandrakanth.patil@broadcom.com, 
	stable@vger.kernel.org, Mira Limbeck <m.limbeck@proxmox.com>, 
	Keith Busch <kbusch@kernel.org>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000d35117064f681ad4"

--000000000000d35117064f681ad4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Damien and David,
Thanks for the suggestions.


On Tue, Apr 14, 2026 at 12:51=E2=80=AFPM Damien Le Moal <dlemoal@kernel.org=
> wrote:
>
> On 4/14/26 09:12, David Laight wrote:
> > On Tue, 14 Apr 2026 05:41:59 +0200
> > Damien Le Moal <dlemoal@kernel.org> wrote:
> >
> >> On 2026/04/13 22:33, David Laight wrote:
> >>> On Mon, 13 Apr 2026 23:30:03 +0530
> >>> Ranjan Kumar <ranjan.kumar@broadcom.com> wrote:
> >>>
> >>>> The HBA firmware reports NVMe MDTS values based on the underlying dr=
ive
> >>>> capability. However, due to the 4K PRP page size and a limit of
> >>>> 512 entries, the driver supports a maximum I/O transfer size of 2 Mi=
B.
> >>>>
> >>>> Limit max_hw_sectors to the smaller of the reported MDTS and the
> >>>> 2 MiB driver limit to prevent issuing oversized I/O that may lead
> >>>> to a kernel oops.
> >>>>
> >>>> Cc: stable@vger.kernel.org
> >>>> Fixes: 9b8b84879d4a ("block: Increase BLK_DEF_MAX_SECTORS_CAP")
> >>>> Reported-by: Mira Limbeck <m.limbeck@proxmox.com>
> >>>> Closes: https://lore.kernel.org/r/291f78bf-4b4a-40dd-867d-053b36c564=
b3@proxmox.com
> >>>> Link: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux=
.git/commit/?id=3D9b8b84879d4a
> >>>> Suggested-by: Keith Busch <kbusch@kernel.org>
> >>>> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
> >>>> ---
> >>>>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 14 +++++++++++++-
> >>>>  1 file changed, 13 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt=
3sas/mpt3sas_scsih.c
> >>>> index 6ff788557294..44dd439e6f17 100644
> >>>> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> >>>> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> >>>> @@ -2738,8 +2738,20 @@ scsih_sdev_configure(struct scsi_device *sdev=
, struct queue_limits *lim)
> >>>>                            pcie_device->enclosure_level,
> >>>>                            pcie_device->connector_name);
> >>>>
> >>>> +          /*
> >>>> +           * The HBA firmware passes the NVMe drive's MDTS
> >>>> +           * (Maximum Data Transfer Size) up to the driver. However=
,
> >>>> +           * the driver hardcodes a 4K page size for the PRP list,
> >>>                                              ^ buffer ?
>>>> I will change page size to "buffer size" .
> >>>> +           * accommodating at most 512 entries. This strictly limit=
s
> >>>> +           * the maximum supported NVMe I/O transfer to 2 MiB.
> >>>
> >>> Doesn't that make max_fw_entries 4096/8.
> >>
> >> What is max_fw_entries ?
> >
> > A mistype for max_hw_sectors :-(
> >
> >> What the above explains is that a single NVMe page (4K) can store 512 =
(4096/8)
> >> PRP entries, each pointing at a 4K nvme page, so 512*4096=3D2M maximum=
 size.
> >>
> >>> Assuming 4096 byte sectors the longest transfer is then 4096/8*4096.
> >>
> >> Yes, that's the SZ_2M Bytes.
> >
> > So write it as (4096/8)*4096
>
> See below.
>
> >>> So none of this has anything to to with SECTOR_SHIFT.
> >>
> >> Apparently, nvme_mdts is in bytes, even though the documentation in
> >> mpt3sas_base.h does not mention anything about its unit. So yes, we ne=
ed a
> >> SECTOR_SHIFT to convert that to 512B sectors unit.
> >
> > It is all very confusing because of the 4k and 512 byte sectors and the=
re
> > being another 512 constant.
> > Perhaps the best expression is:
> >       (4096 /* NVMe page */ / 8) * (4096 /* hw sector size */ >> SECTOR=
_SIZE)
>
> Yes, we could, but I think the comment is clear enough, so I have no issu=
e with
> the code as it is. But I will not fight this though. I will let Martin & =
James
> decide.
>
> >>>> +           *
> >>>> +           * Cap max_hw_sectors to the smaller of the drive's repor=
ted
> >>>> +           * MDTS or the 2 MiB driver limit to prevent kernel oopse=
s.
> >>>> +           */
> >>>> +          lim->max_hw_sectors =3D SZ_2M >> SECTOR_SHIFT;
> >>>>            if (pcie_device->nvme_mdts)
> >>>> -                  lim->max_hw_sectors =3D pcie_device->nvme_mdts / =
512;
> >>>> +                  lim->max_hw_sectors =3D min_t(u32, lim->max_hw_se=
ctors,
> >>>> +                                  pcie_device->nvme_mdts >> SECTOR_=
SHIFT);
> >>>
> >>> Why min_t() ?
> >>
> >> max_hw_sectors is unsigned int and nvme_mdts is u32. Not sure if that =
bothers
> >> min(). Worth trying.
> >
> > It doesn't bother it (any more).
>
> OK. Let's drop the min_t() then and use min().
>> I will drop min_t() and will use min().
>> I'll include these updates in the v4 patch.
>
> --
> Damien Le Moal
> Western Digital Research

--000000000000d35117064f681ad4
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
zZSItX49nLoa4TBbzuCzoINrv59QeSCVlVdAYussUS3840ZjvcYHSQx3tqYcBN+an07lDASmGEM5
7PEXJPVInjl/Fva3ksL3r8anR4PWc3Xz5jLD8Xg6BU4zmIcR/t1GlqWuz8uTWmQtm40C9m91Q9a+
2alIIV6BTs8IG2ELtt4EfcVvi5af+Hu878sGeBtMx6Z9ljoKl3MfvDdtUNO4bkJ97a7PXy/CKxiy
TApQj4qg9SKQcsH0xzQan67XeXjkvk4frNDhRikCAwEAAaOCAd0wggHZMA4GA1UdDwEB/wQEAwIF
oDAMBgNVHRMBAf8EAjAAMIGTBggrBgEFBQcBAQSBhjCBgzBGBggrBgEFBQcwAoY6aHR0cDovL3Nl
Y3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyNnNtaW1lY2EyMDIzLmNydDA5BggrBgEF
BQcwAYYtaHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyNnNtaW1lY2EyMDIzMGUGA1Ud
IAReMFwwCQYHZ4EMAQUDAzALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgoDAjA0MDIGCCsGAQUFBwIB
FiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzBBBgNVHR8EOjA4MDagNKAy
hjBodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjZzbWltZWNhMjAyMy5jcmwwJAYDVR0R
BB0wG4EZcmFuamFuLmt1bWFyQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBQAKTaeXHq6D68tUC3boCOFGLCgkjAdBgNVHQ4EFgQUfLdm66N7GfDsoL8cYp3s4YdO
isMwDQYJKoZIhvcNAQELBQADggIBAA/lnAxDb9jbesclnBxWIKUSxAMIrq4XKO5WKHUYIOOzd2sL
o59fH9AWg1AfVONfWIUNdWDrmNNLs0+drSKaZbGx2RWMbaL9ubo7+BTQV33ZRBxnnkmc9QszlOo5
m6FB9uPOGB9LvJMCkJ8S7hNc9G/p7dB79s1IKc8JGEDIrsgX3s4xSCJA20WdePHY5rLh5ySwXyI2
3sVTUC+oK0HJFRo+TpdMMtdpOetWzIkUbGceiOA2ur8372+0KOmvlIHA/jEnW3BRfmB2vmdk+raY
C/xbXY9JEfS6D881+X/90w+cCQ7nuA1OELebS1RbSdXT6YkRDPWYA/DPFhOYCAiMwVAPRaAH1AQc
8J8yTDigwRUCq4qKCYU9YnqQh3YZRbUYnW+i3+rAO2SUbKl0VM5y0tq+GOGLC7w+v6yGossZmy+6
3w72qp/Colr4r5ZaROb+L2FXqk4tL/HfkRhliyPPPNIjre2mIkvFuShk5A5FcvQYCzDtejAz9JHq
ZVJ1ZD+auQDbIUxT+Dn9bI5XkQnWJ9KrlcORtztdYTDafN8VQuweS3JY0X/VCNBNZkiYXd7fzOza
hvkw/S+v8cIfiakLKBREtiBHqWLdVf5CNDVYpd17yz0LGz0TKARbfuK/EiKflA10pnnnOB33Ru9D
WPp9aHW3szGYr3+H9AHS6IDwkIxyMYICVzCCAlMCAQEwYjBSMQswCQYDVQQGEwJCRTEZMBcGA1UE
ChMQR2xvYmFsU2lnbiBudi1zYTEoMCYGA1UEAxMfR2xvYmFsU2lnbiBHQ0MgUjYgU01JTUUgQ0Eg
MjAyMwIMDcMaKRu9LrbAxERoMA0GCWCGSAFlAwQCAQUAoIHHMC8GCSqGSIb3DQEJBDEiBCDho65j
BmL5iLCJLVxSGZhBcZ/V919noes6VWBSUu0oHTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwG
CSqGSIb3DQEJBTEPFw0yNjA0MTQwOTIwMDVaMFwGCSqGSIb3DQEJDzFPME0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEHMAsGCWCG
SAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQA6VDiGLeYEDonDyXmE5C55didHPs+GcwyruILPJTpK
I0KyO88gSMGphC2aQEGUW+baDnltdQ9OVF01/ROs1s5Kxdh4SQA704c68AhVox+dXprpYvJcwW76
MDvmsmM6AWCuJf4dpvAIjG48cveMnJng9cz5oV7SQkLG7u2s7mLpWZDxHvEX8ep77gc1jo4Qo48p
HM3Ecj8gA1qPpRqY6NfVkCdNvPHVxTgGqXOEl/fiGaYNxgRoZeu8A8tcJRY5QnNdl50qMnvAQchT
xLpeyMPCueUogPgYgDzyGbMCeo9ppdi6ZAqROZj07csCWnCAK+zxouVS12rDpOr4NzN2w9jR
--000000000000d35117064f681ad4--
