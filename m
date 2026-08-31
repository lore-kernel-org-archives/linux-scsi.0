Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5873DAAB1
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 08:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788164773; cv=pass; b=XEGaWCij1V1FSzQnhKyyylLI06/cBvUATYFfNmobwfzAbfA9J9PSxDXgf24epKeVYLBUo0L0NGK3mYeI5+BbI+0lUQ+5oLnL1CI8Hds3eOZ4xNb6cwmxN86g75u3v5J5quHULTKj/561e2TiQLj/n+ATGBnWjQICHNRgOVRCUqA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788164773; c=relaxed/simple;
	bh=L50lYICP106cKUnxwcy3VRTlzI/KCvX3m5TcfCKQ+uY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=te/VGDQqMloo3vv+b2uf61GKnvl+Qu/iehxntJMVsdeGaR2j3nTief2uB/hTYbl2p7vRTyRILtBwRAj93TsZcAzAvCB6YC6ZELHFEYCF/JFIGCnFLW0ab3zvif9TZTVZELngdv2gPfF7jWWzpLvrIds8lpeAKNdaoB1abrUYgv4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tDs5ZxsA; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tDs5ZxsA"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51c01c79467so367171cf.0
        for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 01:26:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788164771; cv=none;
        d=google.com; s=arc-20260327;
        b=NU0+8w5k3DX/eQ/FiWLOkJJCIh9jOiLsKOoULqRrO1nDGnQ6CqDUdbHkJxQpPJh5WM
         Yd+x3Cxan64D91xqSw/3Sh4wOTkGZGRvZn4mzxHPX9y+5b3EHzAvA/cJFlgpDtbmJMGn
         apY9xwcbCnt4FZPAqBC4YnjBlED/1growpGYXLR2AdrZP5OIm+tdtxBkVWV9OIamLxOX
         43y+73FiitlQ0lcSpKyXrP2pvBrGFJ6Zqfi/kzNltlCksvgnJO1u3qc0tKVykjFI7LRN
         VMViQjHCAy8H05TmSBrgKrfFXe6xIt1zXKthFqL+EWAamWGuB8hzqbsVgw6b8/Pyi0mr
         xhOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=L50lYICP106cKUnxwcy3VRTlzI/KCvX3m5TcfCKQ+uY=;
        fh=f9/VcjgqmhjeO2xeqvn7QATDWbastD6G5BTgpTIBKTw=;
        b=WAw5750K0VaA/9y/9+B8bmTsGSKFyPnaliVKq/zsU3c+OCZj6i98Z8xtmSMpyN1Vcm
         FRY+cY3fHkJDfzmjjg2y339Lo81t9w3X7GxVdVf/tARjZkCCKJD6UZ0PnULJ3sRo5Pz6
         g9HFa8fK4xsdFbAHL9qNvshfVHQvMkhfiJmRdpvIscqONUVL763QK4qcZBrkxtxY+pd4
         I/L0iZp2KetFwoJ8mRBdZNrOY4EHXvmxj0hP5if3qcelpQ0f4v0HVRshtgahgZl2kuJD
         Xwt7eBsr444wofmHeB4WcuSsKGFUen8T/AxwuK+m8NTj+C1oB4aY/8Wcdi4l3DsePfDI
         gmnA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788164771; x=1788769571; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L50lYICP106cKUnxwcy3VRTlzI/KCvX3m5TcfCKQ+uY=;
        b=tDs5ZxsA8eAthtxPfEYQVkB4LNXNAh0IKPq+qmRZMAg2QD4kV5SyfJQhYCFxAKeS08
         kdiWrNZaIYsEBpRpcKh1mqrDvExO2lFOCVWsRLai27b+ObncNljSADSlf0texI/+zPMD
         UlvaNYurtRGLaS9kmmi6ASAp6TO+if/yoqrWv/UWmKcqEP+Q/ePTgt9mK3s9fmrIYPvx
         xHH1llvM4XKq0new2KRAo16pDt5qae7YPPeBe+XIVeIHqEj9iFmn/cZFWnFTPjpQvSV4
         SlhWVNxA0q2PiEi1EaNG8zKrRV4Y56+xyE1RYtcyCfLIEVzuwXJfJbmIm7hh7O3ZbM/5
         38NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788164771; x=1788769571;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=L50lYICP106cKUnxwcy3VRTlzI/KCvX3m5TcfCKQ+uY=;
        b=VHrv72lphO8dT7MZFl9L4xNG1uso53Hsob0bjOMU1lLD5SymwXGXGbjuVwMRtzqAQ1
         8PHW1oGtPnFd57NyikwSCqNMvspcJOeXThEV5gMKuZhzKbjxm8rS+A0O6/ugTdpudfBs
         W6lwGLP9irLy5FvskiKyY3FgsRPKvuuAnUX3HCPFT2Uhjj0/B1snNJLaQcN4DxH6SEio
         GBzzDzx8IjfdMDl2NYHxQEconRUhD97Rl9OYm/0WfTmzP4H9ojwk42L5rYaMIRoAkOb0
         +r+IdNLelFRetVAsYv5Dxe7KvJC4dJ5O4FqQ/H6Oq3lGwWhcdfyYpbS5cMGP9VIqAztg
         92Mg==
X-Gm-Message-State: AFuF++mxHdbEb1Qp5LbBtLO1jsH4TkMchWK5JZMg8uOsKJEka3wLIRS6
	RwEX/aWtUZebt4Jr7eS+jl4/oUp6FvnZvC108qZ4WAom7h7nT9OHie1fjxr6aCnWdG9p7LAuTQd
	l/+x2gtGEuuYLtGIysFKfndN2Rsc/yJeLI2LVXqfx
X-Gm-Gg: AR+sD11LqQT9MMV0FQ7j9MxtupG+NnunNCnPjeyRd4VCBUvU21NwSNFaKruQe0HAa93
	r20PMjWfPIORPsgeGxMhDeB8d977kZqnj/OR8mZU7FM976Hi6wKbiuJ7ld71HKUoASb4ppT6yMT
	DJnM5phKe6WtSXO8N9xu1ePXwoLTovtZ6wuRtYFFNwfBSmsb7OZOVeK0rRLFdQMnAef9jUNP0Ng
	swus6NiupMfJB9MSTA09fDwfS9buRamPNbXgU23ZRNnlON0V6Kmj93/SzPLOFOR4VnDBbJZXAzP
	T/m8zrBVYFrnYYdeU6IjzhwHeXZ3JPjwQli77Tw+4+wWF3vgDqLc9Rst0ssV/JR4ylODkE69fH4
	2lg==
X-Received: by 2002:a05:622a:90b:b0:52b:806e:2633 with SMTP id
 d75a77b69052e-52ff716a474mr28081931cf.1.1788164769903; Mon, 31 Aug 2026
 01:26:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260827070345.2853821-1-jorge.ramirez@oss.qualcomm.com> <20260827070345.2853821-2-jorge.ramirez@oss.qualcomm.com>
In-Reply-To: <20260827070345.2853821-2-jorge.ramirez@oss.qualcomm.com>
From: Stanley Jhu <stanleyjhu@google.com>
Date: Mon, 31 Aug 2026 16:25:33 +0800
X-Gm-Features: AcwNN1WVv-1JxNRBi1FdqkSyKkrL3KqIt4GooQUTfRRAXFQqWs_ZljDsUxFdizM
Message-ID: <CAE14pdejGMw-4hpj+nydgMi_Ff0WiACEEisa6Y=wp5cV1H_NnA@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] ufs: rpmb: retry power-on UNIT ATTENTION on the
 RPMB WLUN
To: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>, beanhuo@iokpp.de, 
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, 
	alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org, 
	beanhuo@micron.com, can.guo@oss.qualcomm.com, sumit.garg@oss.qualcomm.com, 
	jenswi@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	op-tee@lists.trustedfirmware.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 27 Aug 2026 09:03:35 +0200, Jorge Ramirez-Ortiz wrote:
> After a power cycle, the first command sent to any UFS logical unit
> completes with CHECK CONDITION reporting a power-on UNIT ATTENTION.
> The SCSI core surfaces this condition to the caller rather than
> retrying it.
>
> For the RPMB well-known LU the first command after boot is the first
> RPMB frame, and RPMB has no earlier, guaranteed access that could clear
> the condition beforehand. The power-on UNIT ATTENTION therefore reaches
> RPMB and fails that first frame, breaking RPMB on every cold boot.
>
> The RPMB WLUN needs the power-on UNIT ATTENTION to be retried so that
> RPMB works from the very first access after a power cycle.
>
> Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>

Reviewed-by: Stanley Jhu <stanleyjhu@google.com>
