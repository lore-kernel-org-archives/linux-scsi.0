Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10B52F744A
	for <linux-scsi@vger.kernel.org>; Wed,  8 Oct 2025 11:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759924026; cv=none; b=AUumhQkyZTWomtLGBz0Ipj4GksahDO5dGQqLAkg0TaflrfOcPmoUzoF7AH8wVxyXAeTRoGzFTov94kuT8TdCiOMf4Z605Nlilgxj3wszZyio34eNQlO64DLlwI7kYttEr/xtYs3gY2LbztEWBVRpgkhgFXTrwHXLVtfayIXScDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759924026; c=relaxed/simple;
	bh=QAaXwnrxU+DnZug9YvxAxePg+Hr+SBVv0b13M5xwyb4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BIoGkyKpD8fRTrLYfCeZyXX/bZptVLKkzAiBF2QQLYh5xmh3fbBLiHst1Y7Bk3cwMIO3ZpWBvphMSfrV2cfn/YTQNEDGAycOoB498na+QX8MIpRktah8MNEoyUrs78IJ0jH/42yPNd/s+y5Q52WI5Qzu0WoGqPIlHuBiDVeSZCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i+yyf1c5; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i+yyf1c5"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b3b3a6f4dd4so1351658266b.0
        for <linux-scsi@vger.kernel.org>; Wed, 08 Oct 2025 04:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759924023; x=1760528823; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QAaXwnrxU+DnZug9YvxAxePg+Hr+SBVv0b13M5xwyb4=;
        b=i+yyf1c53uiV7/BGFY5A+hpPKFUrbyCPfpohaTeQzp9AOu8qK48BZPgw9kw3RtZO50
         YaNEy8FkS/8HTnxOjxKQ0xUJr/AiXKuU/EMq4BQfix5hp8i0AxQmsRNK05RUZGQGEg7B
         9G/j1a5AP+WeVfjFZsul2maUUC9S7MFRlC5t4Q6BdmFMoqALBgbr1r8en7+TvEnpXKwB
         kL3zvgTJ8RPN8dPKE25k76jzs1uSp2CjpopB5L5eCQdm58xUkOrYDayloJ9T5KPUclmX
         sS/uvjhHq/mEIjTeUkpxbAaRXRTinpvCupSzureMq/UeZsHHy5EliM/7VZfhUfgIviHM
         VFgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759924023; x=1760528823;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QAaXwnrxU+DnZug9YvxAxePg+Hr+SBVv0b13M5xwyb4=;
        b=d7Z2lt4NTRlchlKIujajxQEhiVeEkzZurXyn0arRpDLGzZmbjuDo0TNNIpZLG3tC0/
         wN5iw+hcgPZ552pwifXd8kjHbUc7sPfa5cKnFdWWWp4zs3Jy3+3UFCVvoKME2KChE/Jq
         StfPGetYq6gdE/E7O07xG99B0TOaK1uJoFnATsWDEiklEtp/9/hX662OROcmN7yyJ9d0
         Y/mjv1AKtJUpi2QKx167rLAEbSi29MFNRtCLUm7b5wvoKFgnUUQsKKitVEfTS+qT9fmF
         aDf4ID2p+kBxkWzdjrWGqx2Uv1AhtCmKuupe+UmCbjSFM515leaqlu6GN/or5iS/2MMm
         SnTA==
X-Gm-Message-State: AOJu0Yyo6Dtz5BbkDBv5V6HLGTSQJkDkegkEloJ74h/2SxBfsAn07vRv
	B7PuwP7tovtcXvr9FOkFsPrHdqKGaEqk4ygYChGR1SXcivkjahEMSukv
X-Gm-Gg: ASbGncu/WHmm2xl3V46agEM4L3ZiFDAPfIIMOVfvEuH8l+droAUx3p0IVyCtP/yNL/G
	Dg5l5j6hmpkDaG7qxXzgjh0Y5m8nKkm4C0Tl9SWMj01ieNf2Qk9enF1R/+kpwJdXyFkTo+6L/+e
	4NMVkiR+hPxBrkwucEfUrUQ05eWddoyzeV7rpEh4Bv8cIvBYIIr5p+x/oEYd1gMAKn8KmbIlVvG
	JbNLA3HkrpTE1WAAAADZJ6ng0VNbo6drTB35mUQXfZig20vuLX6o43A4sOnV55FAH6U52NBILz8
	qNk6NpFWPTO0T0uCglyj+NroGdBbbbwoMsT1Vwj9b34kAOsn+TOOLzWaJo+9ExWB3EHo1izvic9
	kdcQwDPqBmOCyRp1yOC9zTkruYieFpvqY2TC1UIXsYFm+O51Bvw==
X-Google-Smtp-Source: AGHT+IHGB7nZFykLvMY4WwnMOJdISDTd3LpUbuJxhjfQTUQu94888oFE7TL8PefSeJedVtV9n5C9IA==
X-Received: by 2002:a17:907:7e82:b0:b41:c892:2c6e with SMTP id a640c23a62f3a-b50ac7e6c8emr358343966b.43.1759924022756;
        Wed, 08 Oct 2025 04:47:02 -0700 (PDT)
Received: from [10.176.235.211] ([137.201.254.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b486970b37bsm1681204166b.53.2025.10.08.04.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 04:47:02 -0700 (PDT)
Message-ID: <5f12fdaaa49aad21403a0a9b96d2b8b3a6d3ca1e.camel@gmail.com>
Subject: Re: [PATCH v2 3/3] scsi: ufs: core: Add OP-TEE based RPMB driver
 for UFS devices
From: Bean Huo <huobean@gmail.com>
To: Avri Altman <Avri.Altman@sandisk.com>, "avri.altman@wdc.com"
 <avri.altman@wdc.com>, "bvanassche@acm.org" <bvanassche@acm.org>, 
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "jejb@linux.ibm.com"
 <jejb@linux.ibm.com>,  "martin.petersen@oracle.com"
 <martin.petersen@oracle.com>, "can.guo@oss.qualcomm.com"
 <can.guo@oss.qualcomm.com>, "ulf.hansson@linaro.org"
 <ulf.hansson@linaro.org>,  "beanhuo@micron.com" <beanhuo@micron.com>,
 "jens.wiklander@linaro.org" <jens.wiklander@linaro.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org"
	 <linux-kernel@vger.kernel.org>
Date: Wed, 08 Oct 2025 13:47:00 +0200
In-Reply-To: <PH7PR16MB6196ADF912182709D465970DE5E6A@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <20251001060805.26462-1-beanhuo@iokpp.de>
	 <20251001060805.26462-4-beanhuo@iokpp.de>
	 <PH7PR16MB6196ADF912182709D465970DE5E6A@PH7PR16MB6196.namprd16.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2025-10-01 at 10:06 +0000, Avri Altman wrote:
> > From: Bean Huo <beanhuo@micron.com>
> >=20
> > This patch adds OP-TEE based RPMB support for UFS devices. This enables
> > secure RPMB operations on UFS devices through OP-TEE, providing the sam=
e
> > functionality available for eMMC devices and extending kernel-based sec=
ure
> > storage support to UFS-based systems.
> >=20
> > Benefits of OP-TEE based RPMB implementation:
> > - Eliminates dependency on userspace supplicant for RPMB access
> > - Enables early boot secure storage access (e.g., fTPM, secure UEFI
> > variables)
> > - Provides kernel-level RPMB access as soon as UFS driver is initialize=
d
> > - Removes complex initramfs dependencies and boot ordering requirements
> > - Ensures reliable and deterministic secure storage operations
> > - Supports both built-in and modular fTPM configurations
> >=20
> > Co-developed-by: Can Guo <can.guo@oss.qualcomm.com>
> > Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
> > Signed-off-by: Bean Huo <beanhuo@micron.com>
> Reviewed-by: Avri Altman <avri.altman@sandisk.com>
>=20
> Nit: Would it make sense to simplify things, e.g. :
> Instead of struct list_head rpmbs;
> Use:
> struct ufs_rpmb_dev *rpmbs[4];


Hi Avri,=20

I am working on the next version, seems we should keep struct list_head rpm=
bs.=20

On the hot path, runtime RPMB I/O operations use dev_get_drvdata(dev) to ge=
t the
device pointer directly, never searching through hba->rpmbs. Array's O(1) d=
irect
access advantage is therefore irrelevant. and the list is only accessed dur=
ing
probe/remove (one-time operations at boot/shutdown) where performance
differences are negligible. The list iterates only over active regions with=
out
NULL checks, while an array requires checking all 4 slots.

List uses 16 bytes per active region, array uses 32 bytes (4 =C3=97 8-byte =
pointers)
regardless of how many regions are active, most of UFS devices only enabled=
 1-2
RPMB regions, making the list more memory-efficient, right?


how do you think?

Kind regards,
Bean



