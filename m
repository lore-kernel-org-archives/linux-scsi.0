Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD70387357
	for <linux-scsi@vger.kernel.org>; Mon, 23 Mar 2026 09:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774257077; cv=none; b=bq0UFolXQjzm6GY+BZLhbLW2mbM0UI2UPyz7tk6TREjOjoNPRnOwd443x8lzVdY2s/ebNJXM9UoK5Z7GNosIrtPK24n//EHu5z+1gwLlD6Ioxqf+gxOoOhP5Xv+wckC7V0/xkVfISGhce9X/18N+dJPfhvpPbarJiCUJGD1cK4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774257077; c=relaxed/simple;
	bh=++LylD/RXLXE/a8HXhMPdF3SwAcM41xh3VrLvMoYJ24=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=okqkzvjlC813Ru54DF6t66pNMMv3fgn6z019ZXChIj6DYKk8qc8XXUMtL9XVVHrKJdzr/BjiXPvuY4EQ+80RU2nuihNGz6ROcrb337vOqBkqX5QEUMDzGD9bBJrjJBUz4tQrXGJdFZqK3Y0CCy2JGd5ZCyCD/hVWtdqcDHSRh7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H/zdKCzo; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H/zdKCzo"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4852afd42ceso31443355e9.2
        for <linux-scsi@vger.kernel.org>; Mon, 23 Mar 2026 02:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774257074; x=1774861874; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=++LylD/RXLXE/a8HXhMPdF3SwAcM41xh3VrLvMoYJ24=;
        b=H/zdKCzoVyCbkKBWj2Dn4dqiGM9c1U4fxrnC8hKAA1CkolJpWvCWOnQt6KTbxyw7mb
         L2Q8K/0tFYGFn1BdCh4jKn3MrRhFy+OqmI//gB8sWQQbj2F7PjngpoodtKl/WAH+rTn6
         HHiFruhTQbvQKOdALaAVznI2LtfF+Z/DspzUyzdLKtdG5GHodaWCfJqhddcujzqrFBhT
         w2v4oCTZfDyAb4NkvVxl/6e8JKUVtZSI5JY5R5wgM0WxT/c6hyGw8FbvFqScJf3tWxRw
         WPHOQKLN4kTEkfxgWUKjYTUqfkKm55ebthH6t/4i926u9Nrr6vmibAJ98h5UmklMCNSD
         znAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774257074; x=1774861874;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=++LylD/RXLXE/a8HXhMPdF3SwAcM41xh3VrLvMoYJ24=;
        b=p64jXXSD3HYYaD0FOSrthNacTrNks74z7/9kTpcOALQKhxjlhYx8Ky/FK4jYpGtusA
         0sllJ0za2agPmLB+DAlwifeae034lDwkDfaiwkaOttKr+RQ1p60dZUplS6Ct9cg0bBt4
         gNoSQAMow13hjgehd99hakgM+Y8YoWei9kLm0NLCr0ay/HK87hJGROEbARFONQcMwkn8
         Oh/3M8DGiEE5Mf5XsFozoC6iPLF5daanz8NctufEOIigvJrmkioF6k8JUXpCwKOUO7cd
         yyMYN9jlCHp8pyoFIY5cOk2qX+FILPl7Dw7efx5W/xTahLQUTqLc3VbZflE20GON472U
         CzuA==
X-Gm-Message-State: AOJu0YxgWJ2v81oxpBVyzX2xsJtPLHcoEoSt+dZRsvHzOYk7OYuuOfjz
	qqdFU+b2OUi/VOyeOjuYKBx2NKsbJH6AXvb8tM7m1kpGqHdXGeTT8Gwx
X-Gm-Gg: ATEYQzyN/N2pMTkfGMXRmJiOzIRHkz3IFAYE/t/PAAux4FIydJysNv9rrdrZsB+rvJn
	YmlH+H3FTHK/2aVuJzYiUZmmN1LNeBZ9ko1Vf9Ba611KCRZPSujES0H4rKSTePFkyep3IcLRmm8
	ta4PUuq0pCJXF7fEzZgK1EaxP5pFFBehQ4qSyMCsZ7z2aH6Gfr7sF/UNvG8eYF80fhMAAK7L3b6
	r6u3Hy9MLFHNnhs7xvueaPoS5o0m9Dmx6rq4rlRU4VxbCb0N8vAg26e72YtuUV5QBOvqzH/7u+j
	Ungph1gXK+rcTebh2MnqIomGFw17N/EFpEkhxihsq5CgwRY/61raA3r80+k39V3hFd5hFfIcita
	7Awr+jIU+HWFWHCCNN4vG8APFFMlW3MfkIiVpTU4NZPfFLogJhKcI4yykhXPPKtbuNRS6mVx+5E
	G7cvSiEM2UMu7P4iCMiUZ+T6p4Uw==
X-Received: by 2002:a05:600c:8583:b0:477:76bf:e1fb with SMTP id 5b1f17b1804b1-486fee118b5mr121293395e9.16.1774257074130;
        Mon, 23 Mar 2026 02:11:14 -0700 (PDT)
Received: from [10.176.235.211] ([137.201.254.43])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b6470393fsm29277096f8f.17.2026.03.23.02.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 02:11:13 -0700 (PDT)
Message-ID: <0a368bddbaa50d99258ffc954249f05d1bb7df30.camel@gmail.com>
Subject: Re: [PATCH v4 02/12] scsi: ufs: core: Pass force_pmc to
 ufshcd_config_pwr_mode() as a parameter
From: Bean Huo <huobean@gmail.com>
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
 bvanassche@acm.org,  beanhuo@micron.com, peter.wang@mediatek.com,
 martin.petersen@oracle.com,  mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Adrian
 Hunter <adrian.hunter@intel.com>, "Bao D. Nguyen"
 <quic_nguyenb@quicinc.com>, Archana Patni <archana.patni@intel.com>, open
 list <linux-kernel@vger.kernel.org>
Date: Mon, 23 Mar 2026 10:11:10 +0100
In-Reply-To: <20260321031021.1722459-3-can.guo@oss.qualcomm.com>
References: <20260321031021.1722459-1-can.guo@oss.qualcomm.com>
	 <20260321031021.1722459-3-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-03-20 at 20:10 -0700, Can Guo wrote:
> Currently, callers must manually toggle hba->force_pmc before and after
> calling ufshcd_config_pwr_mode() to force a Power Mode change. Introduce
> enum ufshcd_pmc_policy and refactor ufshcd_config_pwr_mode() to accept
> pmc_policy as a parameter to force a Power Mode change.
>=20
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>

looks good to me.

Reviewed-by: Bean Huo <beanhuo@micron.com>
