Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599EE3FF8AA
	for <linux-scsi@vger.kernel.org>; Wed,  3 Jun 2026 20:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780519323; cv=none; b=Zt/t6y+IwTXTIjkBhkLJ+KOLcBcR6/GJ1wOb+wocOLL/HloBeNASgm2pzU8woqbEJr0pnoEats1G11wnCXdNeeFVkYZxh01FxS9iStiVx9DHidmdsBfqgnEsw5it7ouoBIenJpZySeF13pjiV8AzBr4wOS+fxjU8miTOFLAgLGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780519323; c=relaxed/simple;
	bh=6r7aiSGG3HfNEQdLKMO+qc53gHDujJmEknTqmImzIUE=;
	h=Message-ID:Date:MIME-Version:Subject:Cc:References:From:
	 In-Reply-To:Content-Type; b=dkUZodkMcJeeuCuS3i1SY5JkBWAJaFC1tc3HMjcw7K4rrjwqk0Clye/o9qTMWkwOsCVOnwgU+uKtSrOYiIXww27cy6BMK0gAV6UmAvBdXwsSveD92Eql6BPMm5sK2mTB/cD1KOEXq3eOqtcwMMFDsuqduTsNn5EcVuHbvxZuGuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hTzr/xmv; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hTzr/xmv"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-45ef4332d89so563912f8f.3
        for <linux-scsi@vger.kernel.org>; Wed, 03 Jun 2026 13:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780519321; x=1781124121; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=plob93CUsY59KTxyJOCCanfa9cZeC1KBx3jMt6kIIHI=;
        b=hTzr/xmvgrH7UHe1g77AzmDLxJVvrLjHq5yedX95tC33B4JJBClixYpZfr3rLrllID
         XyOSEQ1+8MUOVoMdLrjaVb7QlyPESsOiP4yPQU8OzS4muZvmOFg4uMnp0kAXTjXjO0e1
         wajLhk97QCZjhDtNctP/p/iDsDvvu/5DEu1o1XstiE0ZdlRioNi4jghnZrv2TCbzEV1y
         koBCRpH1RDDRnKZPY5MQKb3sjjuQj5npWmu/ih47iD/iDuTVfNJBrleSRb0NVY7phPMM
         35YX1+UwAqkSVdXUl+U9CZqPnpup+2PNksZjSmjjDiaHuSo38bdJukRyFOTfPxEHdiJ6
         lsEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780519321; x=1781124121;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:subject:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=plob93CUsY59KTxyJOCCanfa9cZeC1KBx3jMt6kIIHI=;
        b=J9ZUtBpIRp4GpnhCAoUnAWZuX7u6v5UZ+QK3pIzXl5fHN/7GWTs754aO5Wr3F9Tuab
         hUxVk2f9RwHDe3UvNaO+ikYTkBzCBIl7Evha4QoamJYww8umgcqUIj937JxtZ2cCKdDk
         /Toyh7aqZXjqDdfH29EJ6mG4KYsfMlLu00YTL4rVpQ2qEkr+AHVD9V3QlO+n2TY/0Mh6
         0NXtqtjYQ4HKNTyjhHXL0TmnMomI+/Ju4HB/y4FwUvKVIuaHHMaXjqVCSDVGtbiijqDZ
         971GisKQyFbr4qX/mxLpyDwy9gGkgehnuY//yJ8NfOfe8y0XaQihNUaEZAgAcq8MFBjR
         ONtg==
X-Forwarded-Encrypted: i=1; AFNElJ+bDPMqKHR0XqxjcZyhSOb7Kc75Cl00VUIzjCxXKjj+Edy0LDcEEWug0Oo/iw0tCRqQoqVs5kky97eC@vger.kernel.org
X-Gm-Message-State: AOJu0Yxc663fOxz260NdBSg9m52Q9pUjQjIDhFfdKrzI7UzUVznfgo4+
	SSYP5FwMuU6UlUQv4y5v37A8Ep/1/ZZsQlI8/G6JFsuCn/YFage9o5A=
X-Gm-Gg: Acq92OFFbplEHz5fOIB6d0ThvEMYmr0gBBBgyaNKOTnsAkiNVphOO9+YvW/5bHwidwQ
	oFtbNC0ZZB5rqjsE/ngG8qJWgRTdPParVeCuwPL71YafMAFKuySa0xjMiLKbBOBndSI0LRs9PUb
	WoQAA1zmqVtQp7PkCdB/Wy8qIf3LAQbgkv3mkC1cYJbhsZJpjjYL//N0v19MtXkwZeO1gma7PP+
	ntzi3DunjJIw+VwjVkeWoK/x1fLV2yywK8ijOWkplOZk9KhhpctSxmYal40tuHe/9huI0z4sZzf
	upsg3815ugLd8BfbnprAthqnJCh9KoCODWgN581VRuOcwv+A0ENyc/8g09u9myDjsDQMNCW3ohW
	cqw9e1QArkQknCxf2aD+3AP8DcPhGKRWA+dg1c+p5vsPZvHMysC3eF/1yRvQZUhGAd4+0h3+Xl/
	A8ez1sjZXOFDoYY46YX2z5CHvLWV9zLKHBUwDZnjtBwqD7FV9OzS42f+vcmXlJymrCRiZB+nE=
X-Received: by 2002:a05:600c:6286:b0:490:a2f4:c497 with SMTP id 5b1f17b1804b1-490b52ced77mr37377975e9.7.1780519320405;
        Wed, 03 Jun 2026 13:42:00 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc39e024sm21764485e9.4.2026.06.03.13.41.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 13:41:58 -0700 (PDT)
Message-ID: <4d3fda0b-36ff-4351-97b8-914c22b86c96@gmail.com>
Date: Wed, 3 Jun 2026 22:41:58 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] scsi: devinfo: drop redundant entries from
 scsi_static_device_list
Cc: Christoph Hellwig <hch@lst.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 SCSI-ML <linux-scsi@vger.kernel.org>
References: <20260523114034.326963-1-xose.vazquez@gmail.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <20260523114034.326963-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/23/26 1:40 PM, Xose Vazquez Perez wrote:

> These entries are redundant because they are already covered by existing
> prefix matches in the list and same flags:
> 
> {"NRC", "MBR-7", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
> {"NRC", "MBR-7.4", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
> 
> {"DELL", "PV660F", NULL, BLIST_SPARSELUN},
> {"DELL", "PV660F   PSEUDO", NULL, BLIST_SPARSELUN},
> 
> {"COMPAQ", "MSA1000", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
> {"COMPAQ", "MSA1000 VOLUME", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
> 
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: SCSI-ML <linux-scsi@vger.kernel.org>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>   drivers/scsi/scsi_devinfo.c | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
> index 68a992494b12..3a9b691d7e72 100644
> --- a/drivers/scsi/scsi_devinfo.c
> +++ b/drivers/scsi/scsi_devinfo.c
> @@ -148,12 +148,10 @@ static struct {
>   	{"COMPAQ", "LOGICAL VOLUME", NULL, BLIST_FORCELUN | BLIST_MAX_512}, /* Compaq RA4x00 */
>   	{"COMPAQ", "CR3500", NULL, BLIST_FORCELUN},
>   	{"COMPAQ", "MSA1000", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
> -	{"COMPAQ", "MSA1000 VOLUME", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
>   	{"COMPAQ", "HSV110", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
>   	{"DDN", "SAN DataDirector", "*", BLIST_SPARSELUN},
>   	{"DEC", "HSG80", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
>   	{"DELL", "PV660F", NULL, BLIST_SPARSELUN},
> -	{"DELL", "PV660F   PSEUDO", NULL, BLIST_SPARSELUN},
>   	{"DELL", "PSEUDO DEVICE .", NULL, BLIST_SPARSELUN},	/* Dell PV 530F */
>   	{"DELL", "PV530F", NULL, BLIST_SPARSELUN},
>   	{"DELL", "PERCRAID", NULL, BLIST_FORCELUN},
> @@ -213,7 +211,6 @@ static struct {
>   	{"NEC", "PD-1 ODX654P", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
>   	{"NEC", "iStorage", NULL, BLIST_REPORTLUN2},
>   	{"NRC", "MBR-7", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
> -	{"NRC", "MBR-7.4", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
>   	{"PIONEER", "CD-ROM DRM-600", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
>   	{"PIONEER", "CD-ROM DRM-602X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
>   	{"PIONEER", "CD-ROM DRM-604X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},

While reviewing this patch, Sashiko discovered an unrelated legacy bug by extension:

From: https://sashiko.dev/#/patchset/20260523114034.326963-1-xose.vazquez%40gmail.com

8>==============================================================================

commit 721e2689d447c8de8d1d7183a4deca12e9771da5
Author: Xose Vazquez Perez <xose.vazquez@gmail.com>
scsi: devinfo: drop redundant entries from scsi_static_device_list

These entries are redundant because they are already covered by existing
prefix matches in the list and same flags.

 > diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
 > index cf8dfab9489fc..f141cd9a91418 100644
 > --- a/drivers/scsi/scsi_devinfo.c
 > +++ b/drivers/scsi/scsi_devinfo.c
 > @@ -148,12 +148,10 @@ static struct {
 >       {"COMPAQ", "LOGICAL VOLUME", NULL, BLIST_FORCELUN | BLIST_MAX_512}, /* Compaq RA4x00 */
 >       {"COMPAQ", "CR3500", NULL, BLIST_FORCELUN},
 >       {"COMPAQ", "MSA1000", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
 > -     {"COMPAQ", "MSA1000 VOLUME", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},

This isn't a regression introduced by this patch, but does the handling of
strings from scsi_static_device_list lead to an out-of-bounds read and
kernel panic under fortify source bounds checking?

When devinfo is allocated via kmalloc(), the memory is uninitialized. Struct
fields like flags and compatible immediately follow the vendor (8 bytes) and
model (16 bytes) string arrays in memory.

When strings from this list exactly match the array length (like the 8-byte
vendor Nakamich or the 16-byte model Array Controller further down the list),
scsi_strcpy_devinfo() uses strncpy() which does not append a null terminator.

The manual termination branch is also skipped because from_length < to_length
is false:

drivers/scsi/scsi_devinfo.c:scsi_strcpy_devinfo() {
     ...
     strncpy(to, from, min(to_length, from_length));
     if (from_length < to_length) {
         if (compatible) {
             to[from_length] = '\0';
         }
     ...
}

Later, during device scanning, scsi_get_device_flags_keyed() calls
strlen(devinfo->vendor) and strlen(devinfo->model):
drivers/scsi/scsi_devinfo.c:scsi_get_device_flags_keyed() {
     ...
     if (memcmp(devinfo->vendor, vendor,
                 min(max, strlen(devinfo->vendor))))
     ...
}

Because the array lacks a null terminator, strlen() reads past the array
bounds into the adjacent struct fields until it finds a zero byte.

While this read doesn't cross the kmalloc slab boundary, kernels compiled
with fortify source instrument strlen() to validate the length against
the known array bounds. Since the null byte is located outside the array,
strlen() returns a value greater than or equal to the array's defined size,
causing fortify source to detect an overflow and execute fortify_panic().

8>==============================================================================
