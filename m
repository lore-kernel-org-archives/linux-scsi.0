Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716E946A611
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 04:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792384205; cv=pass; b=eLAYVJC3glBdE9URi1fToXZWZIsyvNYs4HD6u/WYdF88LrzMiwoDrySBzlnfLWM9mlyLpbV242HPxNqaAkXVr9zQd/FsuXjwEUJH1EMFt8yDus/PChRGye3R4aWOQ4c15IXQ1lKfC3IQGFoexfJ6t7jjaqORlszRORKveo3TbV4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792384205; c=relaxed/simple;
	bh=asE30SXVAoP90qhP9dNI0QR+nkwcC4PqmT3gY2NE+Dk=;
	h=In-Reply-To:References:MIME-Version:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FZ5RlSQIN8BVmyLnq7WGaWKyV/RAdq88wlGx0e9RujXgvWfEjoksTu0YpIMLdUDw9nIf58S1rXXgV8p/yJRJycnAZhS3GULFkArSJTaEuGdhuMQw7WUq0puEevFzK14jZzoAXUidacolpYQm1D05VOcOTng1KuACsiotc7QtvkI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rX/rQ0HE; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rX/rQ0HE"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5337c7b9937so323131cf.0
        for <linux-scsi@vger.kernel.org>; Sun, 18 Oct 2026 21:29:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792384197; cv=none;
        d=google.com; s=arc-20260327;
        b=HNLLULjSr+8YQPA0ktNJ4CrzP/xxhs7WaltSFtpivaiyVepiAJiFOaTaZ00peHFQEu
         6uKjls9m8JnrFP4HI9e43asBzmK6JX6rvF5/iSW4FnwtFH6oKUo20PkQRgFj96c02psi
         Wnjeg5gcjwqwrRCTa9CtGIb80eBNHK/35ztDSDDbJj2b5/RyR/Icxj3r/UZCiispsego
         GueQw1h3nmhGCIquDKDw/KHZq2pbHeeglTKfcMTpSk78V0e5kKyZw+9bpgQxrM7ouJPa
         GKACwbwJCS1kvfB54G7p8bSRpVZF/OXozaHPjz0GqH/Fu7tVwSbnAnG0fLXJLnL5JtT4
         mrJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:references
         :in-reply-to:dkim-signature;
        bh=asE30SXVAoP90qhP9dNI0QR+nkwcC4PqmT3gY2NE+Dk=;
        fh=vYlNc98LFKbeu0a7Vdjhct3OhWIXa3cK89qBBrbSw+4=;
        b=mPLSi19KvQhoMEaaGpVRRXfSvP8HLVSJ3HKEjXHQhKzH4hp936f0p96b1NgDjnYL79
         ccBZGeCae7BVS+DUfsM9NEctBhZWRdYeyEbmGJIovnpZaKacd0Qxd0HnHKVAYGG/7HZr
         ydOBxScJbl9a+BHSNxXLVUoXeCxBRn1fZW49ZM984Suc1HDmuCzRUSiozYCynsi9lQoj
         zq9KPwc8PVbNOE6/OfVl2f7jQ3q2ruEycoO1DprMOp80hsXGG6vnr0BbMqff0ZNvkM1D
         0I9IVmdYk1mGXaV1dVF2ALLnK9I6pgb9/kgyeGLmBMwwrJ68M+H2pz76ZUfJWpqjCvj2
         yeIg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792384197; x=1792988997; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :references:in-reply-to:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=asE30SXVAoP90qhP9dNI0QR+nkwcC4PqmT3gY2NE+Dk=;
        b=rX/rQ0HEKLJX8qBzFVQDFAiMyp/Zpn4YvJngjq2qxJL0TQl1+f3Qhr9zfPMQgC7yka
         OyyUFmVHDrAAdGlrqIea2RR6Fg/fS8knB9pX9awXJuKRaSrpaTUY35+AlGcHn0tHuOv0
         4KgKF2hf6E+rhzy7uiM9QM8n1i2Yxot4Kb+/doUezMR6iODptFXeBoTnshovBnhKT91P
         aHOHMoMzWT2vEB7ZMMvfI83/thn6XBI8CD4invQSbHSr8+kNS1l8ONs9zDMwvzchxWmg
         fvZtRNDyw82opiqdL2/0+N9k0ibVU8s3M0DIQm6bXACy/o5EFaW9Z3NLClCIFLmvBGI0
         48oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792384197; x=1792988997;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :references:in-reply-to:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=asE30SXVAoP90qhP9dNI0QR+nkwcC4PqmT3gY2NE+Dk=;
        b=bXZ88YM09jb0y0nDg3LeqaQQGOcSBg+vRJ1IYf6uj/kpWnMqfpF8mfqIG44u0gFeJp
         Q346qFrxULGvRnYiIcTPwfm/+k/8pAGzj4+htGYYqYi2Q074BE4FBQOYCq+nH3/OM6ye
         y3eB869CAiSDPnGyIyQ30im0wjhRuNCJ4v7BXrlGBrCvpcHHZrHsrdr475XE92C6pkKL
         CvFW6G45jDeculCMTaQss29gI7Hy+ZNpn5Fo6PVD1JSnlZ/DDv2x7tYO1EcTAeHpgVCU
         j+NLN53MiEJfoVEe4l5vH8cArbx6tha8DZOtKi30hdQ8i4PAFCYuI+UiE0OzXd5PM+y5
         +OCQ==
X-Forwarded-Encrypted: i=1; AKwUvBxC20BT3Tf3eJEWDGmuKTqWqHNgfyXah5j+MwmTuaYqYaf8VtQh3LFCXf0PcafvDvtK0SiyAurk/Vfv@vger.kernel.org
X-Gm-Message-State: AFq9FYIUZ3mtpw+ELhGmkbeuX8mECsdbDO7g0RF9VkMopA6IpEEQ9AXF
	YgkpJgLYcKO4JaE87vRlrptChOjbr6lOwWfrfEalLZs7wgtOhwDHlNu2W/UI5fvmtItdXmYZXuq
	K+7W1bh4rI5g0JDa+xyS9vuP/UXb4TDX5Gsi6NI/q
X-Gm-Gg: AYBFou2xtz5TwsSWDWxuz0ez6TFmBRGk/TbaDTxp/UvvPQl1vj2Le/RD7Ibz9zcvvvY
	5HbZkUs3QwKI71ULjlg36dHA07rq62I2z+fHhw3p+i9O4nASHhJretw/FNUkbYfXc2UWo77sPCD
	tEF1nLIdzMU9utPKYqDwFePI+smBZspvY/NSkzdMIUHkHNQMzZny9jPSdKH0VLZ2hFJqa9+gjlt
	ThGpnp3xNlQqf+Z+/pSwckWpgoO37MshIDvoDETXlvtr6ZplLHLrZqh/OhiOKv72ifuma2c5oD6
	sPehqLFe7lAgVvAkUNaJgULQmNgTLrnlJoH6tyO3Dk9xBqCu4HQlBw+YAN/MQKY1ogQDqsDBoBo
	E0JtcNw0=
X-Received: by 2002:a05:622a:90a:b0:52f:8389:29e0 with SMTP id
 d75a77b69052e-53649acf23cmr28899601cf.0.1792384196502; Sun, 18 Oct 2026
 21:29:56 -0700 (PDT)
Received: from 913411032810 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 18 Oct 2026 23:29:55 -0500
Received: from 913411032810 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 18 Oct 2026 21:29:41 -0700
In-Reply-To: <2e042211ca0ebc974ad5ec4c0de9f3f93b3c75c0.camel@iokpp.de>
References: <20261017084403.875420-1-stanleyjhu@google.com> <2e042211ca0ebc974ad5ec4c0de9f3f93b3c75c0.camel@iokpp.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Stanley Jhu <stanleyjhu@google.com>
Date: Sun, 18 Oct 2026 23:29:55 -0500
X-Gm-Features: AclHuK-HgN0FmhIdLMEsn6Gjhf6fsxEJCtdj6atYDCuubd88JF0LL5qqpkihSd8
Message-ID: <CAE14pdc3QJyxY+YizyUfi2+NTB4oxYyqu_zTyT__-LfMxJLMmQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] scsi: ufs: core: Factor hba->outstanding_reqs
 helper and fix double completion
To: Bean Huo <beanhuo@iokpp.de>, "Martin K . Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Bart Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 2026-10-18 at 21:52 +0200, Bean Huo wrote:
> One more place has the same problem. In ufshcd_abort(), the "cmd was completed,
> but without a notifying intr" path completes the request but leaves its bit set
> in hba->outstanding_reqs:

Good catch, thanks. I can confirm it. I will add a separate patch to fix
it in v3.
