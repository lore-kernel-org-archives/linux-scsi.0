Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD4C1FDE27
	for <linux-scsi@vger.kernel.org>; Tue,  4 Mar 2025 11:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741088290; cv=none; b=RbJfIxzSRtgbJk3S8QfgbCUCuGlmVZ1ZCaNo4qsa/fX5TTACiKAvyIXhyx2izGgFSfJ8aekWRMwbt17Wo2att51kBh0SdEXnqoz1pOHp3d5BzGKz9pF/MPYq7bHy2rmt714FvPCCYYl99lYquWliI1qkuCi+63xxi3xa0e7ZUuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741088290; c=relaxed/simple;
	bh=oC5qjHB1PX1QOUkEpX5gtofRWcRiWb2GfBc+5/XWrCM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HlnLjiHKxb6IblV/p+CNNczUCIADU1mpZT3/OnHNBYwQT0xPLbYdI06mnMqNkFGX6lSgeZe7rXryFFVcxEHkKoBEGv6XJWqX2FI6z7lvizd00BT2wZ6mU860PyZpdzUntaUng5tHWtJds0Iod9bnYI999Jnw7r+osxjp+RVVIYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Yt11mg9J; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Yt11mg9J"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7271cc3d73eso2992011a34.1
        for <linux-scsi@vger.kernel.org>; Tue, 04 Mar 2025 03:38:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741088287; x=1741693087; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oC5qjHB1PX1QOUkEpX5gtofRWcRiWb2GfBc+5/XWrCM=;
        b=Yt11mg9JVivfAiIYXPDkVigOhyxzDTG92BcJtdMuLOVovRLnRc1gdrxmXQjNHFGHg8
         0S9Fr1SCPNeJXomWm02Rr4So4pMlUk7v/N2X6ta6EfVRpzebPIMhyWfpZ15ZCOewR6tS
         Dec0wUrxTKrjgJNsMBJJ2wzv2Maj7DSps0d9UVaGmQoVTcyIOksEWe+1BMN+yHgvECbQ
         D2Xivg0U/Z4PqC+b+KfP2AYW/2VG8c15qgQ3U5MV3vtysjQsrv87/araLtOD4+HaGQE4
         ATJ8is+OAXeLLTEhasi4M+NVn0ti4Je6q7w1abzdgYAA6d6kLWVV3LcRvpnrcOCdF4Gv
         51tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741088287; x=1741693087;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oC5qjHB1PX1QOUkEpX5gtofRWcRiWb2GfBc+5/XWrCM=;
        b=f9/fbB8SJDztZbdKUoHHONfcvHtMVEJR4HQW9ysWHykokMBcxbI+CQi55BkV/JXxaK
         uEL9vW/7cBr1YMiN3gNdFh+OH0Io+yaYy9CS0+ZunDkRUWNIo7SB5rrr8i4IzIXtZKvc
         wUsgbLNt8QZQNKO8aLG7n1v/dbeVh9YBXM1lSbxpaZVcbIehBAPd207mgx/IdbPWhZpD
         XZCtvqMFN7mvDOFbWqtduU4G7MbCN0VSYqFACtctBh2Qpx5tY/TzpaYrk5EIiSAGJABd
         F0UCLBs6A71Fd8Up1KgoO0wMv/V7rrsaA38AF6FyL1kdIDD1fFJKorQNob2oFZX1QRdO
         pLkA==
X-Forwarded-Encrypted: i=1; AJvYcCU8DNFXny1po520KkyUc1UHQJfdD5thrnPQ+PZEvVVdfWoCb6HPczvmdBdEQKDtgdM8kkZSTTIDbt9Z@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7aVpo87yITlaii8ep419LNM76lfq0VCyOfGeusrYYLwVch3V+
	dv/eOccsrkNSByzuFrDjdZkX/nbXb0NHc0iW6eHuqeFS+S9om5oGLZZlJg2WCIE6QRkJmbLzG1K
	uTOcZPZu8i163tb+jACE1Ka8wwxnbmQbiDhnDmw==
X-Gm-Gg: ASbGncvj/7ClcDSW64m4OHN+funBWIIah2URgpPq6MZYE9GCMtcf88RRjT5dS3CEMiN
	RTIv7xp6JzIwVaZdrM0tNeq6EqGQU8dvo/40PhC9Jxl02ZEHeXRWDdTFN4sGmg/bJHBPedN9Fbb
	4R7VyCbt76Mc55GREWqa5FJDcs/MY=
X-Google-Smtp-Source: AGHT+IEl29p/uRr2dkieWp0OTEK1kdeHqqHxSZa3QXSfzg/07iBAOnkwXHFw1v1HZhu1dFp6njIHzwHLg7pvbXeNaRU=
X-Received: by 2002:a05:6830:929:b0:727:f8f:b25 with SMTP id
 46e09a7af769-728b82f3176mr9942270a34.20.1741088287678; Tue, 04 Mar 2025
 03:38:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250226220414.343659-1-peter.griffin@linaro.org>
 <20250226220414.343659-7-peter.griffin@linaro.org> <015ce85d-c62b-472c-8527-33217ad815eb@acm.org>
In-Reply-To: <015ce85d-c62b-472c-8527-33217ad815eb@acm.org>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Tue, 4 Mar 2025 11:37:56 +0000
X-Gm-Features: AQ5f1JoxKZtvBwSf5o93rOZKsNyWnyc_-Mlje4_RgWAiq42ic3vdnFhmRmm7aMA
Message-ID: <CADrjBPrOTMPh2BfROdMnCrPWBaKw+uQ=jH3yYNZ-HEKEjNahSA@mail.gmail.com>
Subject: Re: [PATCH 6/6] scsi: ufs: exynos: put ufs device in reset on .exit()
 and .suspend()
To: Bart Van Assche <bvanassche@acm.org>
Cc: alim.akhtar@samsung.com, James.Bottomley@hansenpartnership.com, 
	martin.petersen@oracle.com, krzk@kernel.org, linux-scsi@vger.kernel.org, 
	linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, willmcvicker@google.com, 
	tudor.ambarus@linaro.org, andre.draszik@linaro.org, ebiggers@kernel.org, 
	kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"

Hi Bart,

Thanks for the review feedback.

On Fri, 28 Feb 2025 at 19:21, Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 2/26/25 2:04 PM, Peter Griffin wrote:
> > GPIO_OUT[0] is connected to the reset pin of embedded UFS device.
> > Before powering off the phy assert the reset signal.
> Does the above apply to the GS implementation only or does it apply to
> all SoC's with an Exynos UFS host controller?

The reason I went with a generic approach (rather than adding another
SoC specific hook) was that exynos_ufs_dev_hw_reset() is already
called by all users of this driver. From that I concluded it is a
common register shared by all exynos implementations.

It is hard to be 100% sure though as I don't personally have any of
the other Exynos platforms supported by this driver to test on.
Another approach would be to add some more gs101 SoC specific hooks
for suspend() and exit() to exynos_ufs_drv_data() or another
EXYNOS_UFS_OPT_.

Thanks,

Peter
