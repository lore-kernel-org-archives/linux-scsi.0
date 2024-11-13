Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E595174EFA;
	Wed, 13 Nov 2024 18:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731522089; cv=none; b=Da/hG+NeQB3q9r3RkJIzydxPoFDkQpwOmEf7eramhlsndZ4x/lXXuOYJA7rmkiLznc4WpuLKWwHl//Tca5lFt9Jv5JApWfDipw3QNbEWuWFBp7gxy4i/DX6pGxiSzbaQBSRitOnLMBLDJbwKgdYbP6OQzoHNMiVV+bazHUNsWtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731522089; c=relaxed/simple;
	bh=maGF5e81gW08mtf8HZcBaMzW8FlzArn8IOkgdyFyoI8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fq+yHeBwrFfhzpJbfziW5mYcYdMl4LagVAY5njEiqVuKvLnm1TcgO0H6N0scYPSkl+To4sKFZEWIz9GlDVmZ9zslRuxaeRHug9yuj4tAlXVKqboHwnsxLUMFAGo9bRNdwrXETa+tZqqAHRAhmWY3q+YFNjmq+XeBWKAlBVWwITg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TkHa+nAM; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TkHa+nAM"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-53d9ff8ef3aso1300661e87.1;
        Wed, 13 Nov 2024 10:21:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731522086; x=1732126886; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=maGF5e81gW08mtf8HZcBaMzW8FlzArn8IOkgdyFyoI8=;
        b=TkHa+nAMi6yQrzFzht5TkbemD/aNheW3myeUefrIZ0PoPV0BkDPbke8Q2dMr8oHTgx
         O4M4P8lPAToCuGImgwrkvNO5/iNbxzWgq2xLoQkskRLfIoxGS4DvQ64ZLhm21i0JFuNH
         SaeKo49i+xLurysjZlxmkPQZqUbFAdNfCFsKxsTSgH4XNQxda+6U4G4m3K/tMCYeZFY4
         zoAdjkA3TXkts+QUy3L3HuAKGqpAbuPmzaBUCYJr4N4rGCh+nfvSoesSEEhsZ81t2ef7
         nfYaD6Q7e54IMbsySqnd9KFrqL5D9QVDKzqe821XYgyzZxzdseihY8Q9pC4mL07URwms
         nDyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731522086; x=1732126886;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=maGF5e81gW08mtf8HZcBaMzW8FlzArn8IOkgdyFyoI8=;
        b=mMreBSvNdwPRbAmYkTwRPelo1DRBNgQgpmpxdzPhH/VbUgdNbqOp1NZy6fBshWVApE
         grS485B5+m6v3R512XKhz63EruRo60fr9aPYEtv/QqmXaL2O16J0k029E+w1mA6/UmXQ
         zDPhRn9AUhEiQsU1PTLpJDMHxWdsvsNLYDfEVGhbAsmMTAsEQF5PDB9JjriVZgz2oPqt
         IHxlD5L2hjPqbzIqa6rhLD51sQtXE0UTEfKu6oCm2QFNnRwOVre1nYNxPEH3pGS8nnYG
         I8+JJD4nVMykMLJDj+reY2YAlpljftJeAv5lhUEnCrkp7+MLLeCWoW+j58ASzIrFluxQ
         OE0g==
X-Forwarded-Encrypted: i=1; AJvYcCV+HIPIJ6s8SC+XnD0rgiEIyYCgyc2zqD7UbNjLa0Gy7LHpC50WpzJv3pdJa/kbpWLNnRrmbrh7ruG70QY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxa5Au9lujY8qvANm/aCTqajDiLKImwxJjqyNQoLH0pXVk2bqcO
	SXhzDkrTybx0F7PiAyMbYdWEd71mC8vjFd317bHGdiXpYf5emQPw
X-Google-Smtp-Source: AGHT+IH9Je3e3GglIUsXtHBNSX60GTLv0bYIQfSw6gtKL9hYYtIInDQzcAD1CpLef9b884I2u2Wa7g==
X-Received: by 2002:a05:6512:687:b0:539:f696:777c with SMTP id 2adb3069b0e04-53d862cb2e1mr10778335e87.29.1731522085871;
        Wed, 13 Nov 2024 10:21:25 -0800 (PST)
Received: from [10.176.235.56] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432d54e0fecsm34318395e9.4.2024.11.13.10.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2024 10:21:25 -0800 (PST)
Message-ID: <03dc2e67df8a26d204b457808329ee388715b67a.camel@gmail.com>
Subject: Re: [PATCH v2] scsi: ufs: core: Add ufshcd_send_bsg_uic_cmd() for
 UFS BSG
From: Bean Huo <huobean@gmail.com>
To: Ziqi Chen <quic_ziqichen@quicinc.com>, quic_asutoshd@quicinc.com, 
 quic_cang@quicinc.com, bvanassche@acm.org, mani@kernel.org,
 beanhuo@micron.com,  avri.altman@wdc.com, junwoo80.lee@samsung.com,
 martin.petersen@oracle.com,  quic_nguyenb@quicinc.com,
 quic_nitirawa@quicinc.com, quic_rampraka@quicinc.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Damien Le
 Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>, Peter Wang
 <peter.wang@mediatek.com>, Manivannan Sadhasivam
 <manivannan.sadhasivam@linaro.org>, Andrew Halaney <ahalaney@redhat.com>, 
 Maramaina Naresh <quic_mnaresh@quicinc.com>, open list
 <linux-kernel@vger.kernel.org>
Date: Wed, 13 Nov 2024 19:21:23 +0100
In-Reply-To: <20241113111409.935032-1-quic_ziqichen@quicinc.com>
References: <20241113111409.935032-1-quic_ziqichen@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2024-11-13 at 19:14 +0800, Ziqi Chen wrote:
> User layer applications can send UIC GET/SET commands via the BSG
> framework, and if the user layer application sends a UIC SET command
> to the PA_PWRMODE attribute, a power mode change shall be initiated
> in UniPro and two interrupts shall be triggered if the power mode is
> successfully changed, i.e., UIC Command Completion interrupt and UIC
> Power Mode interrupt.
>=20
> The current UFS BSG code calls ufshcd_send_uic_cmd() directly, with
> which the second interrupt, i.e., UIC Power Mode interrupt, shall be
> treated as unhandled interrupt. In addition, after the UIC command is
> completed, user layer application has to poll UniPro and/or M-PHY
> state
> machine to confirm the power mode change is finished.
>=20
> Add a new wrapper function ufshcd_send_bsg_uic_cmd() and call it from
> ufs_bsg_request() so that if a UIC SET command is targeting the
> PA_PWRMODE
> attribute it can be redirected to ufshcd_uic_pwr_ctrl().
>=20
> Signed-off-by: Can Guo <quic_cang@quicinc.com>
> Signed-off-by: Ziqi Chen <quic_ziqichen@quicinc.com>

Mabye this should be a bug fix.

Reviewed-by: Bean Huo <beanhuo@micron.com>

