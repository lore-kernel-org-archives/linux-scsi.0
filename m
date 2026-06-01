Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA0C13959D
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 04:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780289971; cv=pass; b=JXyu+SbPMN+IFRQXM3sOcNpVH6u/LiWCIcNNBx3ev5qbmu8QzrqXy+UBU+QDPGDYLCk639IdiokXFtFU/n5V0AkCDlv6vw8kS8kG9KTP86xYic9F9wIWxqeHuUvHfo62n+YNGo9Tdib8q88rHL6kvkb8yCfs9uMUHyGcgUwzmCM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780289971; c=relaxed/simple;
	bh=wBFVGCqCyESGZeWw0kFKKPpCRpxPQf8+k2stU6NaYlk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tdAgcEyJAlEKijFmw/kBsqr86hGWJLpqjQFAo53NM6HLrzSkSvH2JbpENo91OWbu754s228lLRe4IP2DkDzAi97sOiHBXXZotxHkelCnG6oLzoThW/yPhVXWAjRHfTmYKuyAeibJl4PxhamPGoAxqQqMWauGUuTokfwoZEpmDmc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=Xsn3tx9f; arc=pass smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="Xsn3tx9f"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-bebde8a0adfso19413166b.1
        for <linux-scsi@vger.kernel.org>; Sun, 31 May 2026 21:59:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780289968; cv=none;
        d=google.com; s=arc-20240605;
        b=Utv24DmByNEJGnoN1MPy1FL+bPCQlqopj41tkhsJrX5bydqJ4GE0si+zelgUdT6vM5
         7Z45DxDzubBcu/YgD0qg5m9M3OL7N0HyVFFgyzHT/rTzzBeqgf6zJz3yfE2vq4oq69Ms
         BfPgptH47mlUNhJrSwGm2PJkAOXkuAPrJ7WjFQA93Yr3J5ijsgA0xa/2HyIEH61auJQL
         L9u5elplYCZja9juV8KzPsatTw9ey7a9lRp4wvsc/ZiOATyFm5du36ahcpxc2LmXQxT0
         u/gCQoygpSlZ27CiWV7dmJAn4+I5hJk6j4tXQQ4nVUsNEWva+RBJPP0MQDmSxIuznHZB
         We+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=L+TBTZFxxv1JuC2qd1ez82wqnLD2VWaPg7OYnlws9+E=;
        fh=MZM/hKh8Mxj4XzXHSsB7eUZshT2tQzLKtz0Or+bO0r4=;
        b=Q39vWDdp67n3v/Na+9P27wtsjjH/PAqUWZN0LILP/X1Lin/x2TFCoi3EKNDDUuM/n7
         /wvo1xnqTOFmAd/cO5J5nw5p0idk+by+abSq7ZJ7HjP0vgx80ucZrc/TNm1S2TvBt7xe
         FE5qSVRK73ODOqHTTm4sdUdK9FWMwrBPgw+5eKRuDDLRvzR4PMGUd93OUKy6RooLLDMQ
         zkGmn9mttyZDUZLNvg02Bomrcn0d3uRngsRK0mpbN4n4Qn1fr866hO66MBzPvg2Y5ELB
         +ATPRFCXvWeCGD+mKzW42QNqTdXPm0+cXHM0a6rLA6ITemLKPeYPYu0KCmpWQGGXzWri
         4DSg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1780289968; x=1780894768; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L+TBTZFxxv1JuC2qd1ez82wqnLD2VWaPg7OYnlws9+E=;
        b=Xsn3tx9folCbb8zOE21GmsIkxXBXnMrsIEHyMeIpIM3KRgZLKvxuMECHiVEeSmRFHc
         gCGVeWQcZsRNTxDmKNFvY3qlrkAXMpV6ez67rLTX7J4oOoHdvW282LVVMxF8ZNTL1IW0
         R/9BS3GCS5ExkRvJZjDW5+YIxD6Z7J4D1ojrWadH1kgvvKCNYJXh24L1VtyudRlC2p/w
         v0KWKRrkf6mOZTN1Qfa11RmbNJbCxQKEI/9RV0zOUhw0XwP+/DXlEMFVy+Zpu4XOaiAx
         vtuu6N5vUSSJ6iB0IaJRkwQouXrbnQgcKuRsCZ/J4ToMzl0ArieSzHjuAChU2ZLp310s
         P+uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780289968; x=1780894768;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=L+TBTZFxxv1JuC2qd1ez82wqnLD2VWaPg7OYnlws9+E=;
        b=j1Z891BEPHvrqrzW+4Jmf6aP5UtfKEV9h4HEKsvIrvoqSUmMOmvDoFbLzKJzZWutxh
         FRVb4SNbfdR8swMVGhsjzuOYIum+fGTwx4lFxT388pkhtiMKK0VY4V9ZkPi4PLQNBFpS
         4lzCo9VHp6z84zeo7G89ZG2AUNWEYVvWamyIC+7zP+75ueDRsG0baPqkJvZlDecEqUOh
         PHhxMaV1Lmtx9PoNLASp/IGCYLFsLUDdW1+WV0u+nGsTI5cYnpvu9q/igKrf5YGnqtfS
         T7WVigEMNftVwH5c6Q14ZAZWvbdZ3EgyVccBpgiXc+zVJEMo7ztB4xfcSglG1yMpTlB5
         Z+6g==
X-Forwarded-Encrypted: i=1; AFNElJ/xqi8pzHuDwxxkVsS+E5ZAc7q2NUevbpi1qVe8z8EmPTboHNWcplOEuECxQT9MJ0S7FRTt9utiFXuI@vger.kernel.org
X-Gm-Message-State: AOJu0YxcV9OZ3mxoHFrJTZDxkPM9L6o+Ojt47s2M+X2oWeiIVS0MRiRh
	bjrzYPWvtI/oPlY+rPJTj3PR1w3xv/SxwE+htt8o+qGObcspsEExBpBTqcK+zB0g1FXh7ME26ot
	E8rwj65x7kaFLbXrDK+t3btklR4K2RgtQWKrZaSomZw==
X-Gm-Gg: Acq92OFoXdZ/wu7JLlIrZeSJr2Jl0bZZpqGfbDtDDEwK+mH5r/n1+nPCoOi551UF7Kp
	18/lfovXYHPPpw5c75+CxTmkuRNIB1UNTBIvcVMruibb7bECGtK4ubyEZiiMJLmgqo+3diITxeG
	tD6S+KuCv7yMdgCyKlEYceycWoMedBL3GFarnFfVP9N1gsfZB5Qf9MvSI71xU8GdRQy9YXvgle4
	hJxBQwseytPhXXZcq4xTgRqk1LaHugV4134mMgglUBpVSWUeZxvKn74M2i9Rnd6J/Wm+4jcA8B3
	oX+k5/o5R09rThr9YEuLxhGfUJGD5BBsPkydhqhDu50LJ6OZ4xk=
X-Received: by 2002:a17:907:1dd0:b0:beb:7979:47d5 with SMTP id
 a640c23a62f3a-beb7979599emr92349166b.6.1780289967892; Sun, 31 May 2026
 21:59:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ahs-bEsBJH0KhnsX@stanley.mountain>
In-Reply-To: <ahs-bEsBJH0KhnsX@stanley.mountain>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Mon, 1 Jun 2026 06:59:16 +0200
X-Gm-Features: AVHnY4LAehZcnZHdh13j_GDDl34f5hNMroM6OlI6VVhmBxdbnfHfcsO2NPSUDWE
Message-ID: <CAMGffEkmt_aXWrJq0Oj8kkEbQvsi7r9zrdOxV7KvcB2aOjVXPA@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm8001: Fix error code in non_fatal_log_show()
To: Dan Carpenter <error27@gmail.com>
Cc: Deepak Ukey <deepak.ukey@microchip.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Radha Ramachandran <radha@google.com>, 
	Viswas G <Viswas.G@microchip.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 30, 2026 at 9:45=E2=80=AFPM Dan Carpenter <error27@gmail.com> w=
rote:
>
> The non_fatal_log_show() function is supposed to return negative
> error codes on failure.  But because the error codes are saved in
> a u32 and then cast to signed long, they end up being high positive
> values instead of negative.  Remove the intermediary u32 variable
> to fix this bug.
>
> Fixes: dba2cc03b9db ("scsi: pm80xx: sysfs attribute for non fatal dump")
> Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_ctl.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm800=
1_ctl.c
> index bb38b2d63acb..a27f3287748e 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -588,10 +588,7 @@ static DEVICE_ATTR(fatal_log, S_IRUGO, pm8001_ctl_fa=
tal_log_show, NULL);
>  static ssize_t non_fatal_log_show(struct device *cdev,
>         struct device_attribute *attr, char *buf)
>  {
> -       u32 count;
> -
> -       count =3D pm80xx_get_non_fatal_dump(cdev, attr, buf);
> -       return count;
> +       return pm80xx_get_non_fatal_dump(cdev, attr, buf);
>  }
>  static DEVICE_ATTR_RO(non_fatal_log);
>
> --
> 2.53.0
>
