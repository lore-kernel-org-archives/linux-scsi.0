Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793408244;
	b=nmvO6n5BwwQ7ZgXLwJB3wbsuh1SxTy1RGEykQqqIuGOKziGGQRWwSIiQCRVu4tz1sAY5
	 NiCaPCP9UoOnsK2oM/5dN5kwdOdo1pjY1rlKyMJTHQIeneVAUFarevasw0kUt+0VSk5sk
	 ZFDbjTnepodb4m4drJ6GzPbH4tsatTi2lK9a8ZEgmMdSzXk3E8dAVF6IZP6bK+DiLkKL1
	 toF3TxeFMxaJEAL/t99pvi1dqWXjoxDtD76rVPDbOHzAzMEcdSoHCaxZ0JiBAyB+DcaSg
	 cO2I3MOeLcTq2bIukgIvmGpaq36tBsOMKlJFI2qwFe4rmLxN0iqCleBU8jka/oSt6uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793408244;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=1a5ba9El8uBtN9AyapEO4moFvUDWJExS3FAAfaGjoFQ=;
	b=OS1ZT3lxLN5jgpbY4L2RFLa81Va+GVA+9YSiRQv2ZXGVquOTbGaQvWGmROocZId6mHwi
	 m9jtynk5D4RzpBUSCySOwUGqO9jvHCGEmSE1Ta97CxvazxI8G5u9JlU03lOR7r3VXk27t
	 fZopPHU7SdbqtdvYcF0dTZPS64u5b2m1+HUpFR4UpKZGvo0QcOJ6DQmqiepbOGdufNzoD
	 wGVP4nYMQXG8CTNadYroA9RgrsXFdCaY3wPkVvEh/g0xWTZt2qak7YI4qjY2xe923m92s
	 vOh88c05U93ZPOHayZBY50CYcGR3HFbk4IAe1IuIZSfJc5cgpG/huYXEsdv2bws0V+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AggrhFrB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15211606A31A;
	Sat, 31 Oct 2026 00:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AggrhFrB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3CE91F0093A;
	Sat, 31 Oct 2026 00:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793408243;
	bh=1a5ba9El8uBtN9AyapEO4moFvUDWJExS3FAAfaGjoFQ=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=AggrhFrBsxok3D29cccMsbgApZLfswqob6dJ3inMlPhvQ5Wxc5qcHH3johwx8NIX8
	 KZ4g7IDhKabQy0QpG+nrS9C3q6SJIz3OBXa2Nv6BZFkiIvwqfqUL3jfLOPmDtqtXtB
	 rmD34OgJi+v3pe4yht9pyLnXuQG1tEdpOmsGQfvHWbF+qprsIcDluUjo8eiBhOODbm
	 aRzCTfAgpNyxnhlIdywLcpiQXRGty5UHH8n8c8o6U2DYoC0/OcLyg+ZKxz6uUeXj89
	 jDUHadn9TYlbKxcZRjfLIbWb3j5ZGnjiRflGiL9JRAfweLmTIXeu99dBDaFZmXSNpo
	 0Y06sa4nhwEzg==
To: vince@palmit.com.au
Cc: linux-scsi@vger.kernel.org,  sathya.prakash@broadcom.com,
  sreekanth.reddy@broadcom.com,  suganath-prabu.subramani@broadcom.com,
  ranjan.kumar@broadcom.com,  James.Bottomley@HansenPartnership.com,
  mkp@kernel.org,  MPT-FusionLinux.pdl@broadcom.com,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: mpt3sas: Register devices during SANITIZE
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261020210856.42835-1-vince@palmit.com.au>
Message-ID: <yq1y0be3cwt.fsf@mail.kernel.org>
References: <20261020210856.42835-1-vince@palmit.com.au>
Date: Fri, 30 Oct 2026 20:57:22 -0400
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain


> A SAS disk being sanitized responds to TEST UNIT READY with NOT READY,
> ASC 0x04, ASCQ 0x1b. mpt3sas discovery maps this sense to
> DEVICE_START_UNIT and issues START UNIT repeatedly. The drive stays
> NOT READY until the sanitize operation completes, causing discovery to
> exhaust its retry budget and decline SCSI device registration.
>
> Allow registration only for the SANITIZE IN PROGRESS sense, so sd/sg
> can expose the target while retaining its actual NOT READY state. All
> other sense dispositions are unchanged.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
