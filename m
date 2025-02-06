Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F8620C010;
	Thu,  6 Feb 2025 05:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738818766; cv=none; b=a5RJVH8IEryF1Aj4LhWVHw3LACBbfH7jJAmEYxOZStouErZ7U+yUCELA071sPNq0xWDbtJ8oLqa16+l0Osi4Q65Up/02tSJ5FdOImzWewLxfoQ95GGhZae97mMbWUBnFXokIIdTS2u7kkpJ/vQwbKFV74j0H7UbV8YMCpIfF/ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738818766; c=relaxed/simple;
	bh=dCKZuwHWUkaGofn8dDyAaPB7Hq1I1Ov8Ymi/q+s6598=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=doQSZ3U5v5Px+5n03Jnax7XDzKS0ZyR4m0GyhSyedlFejMv47kRvW60QJzv3K2Euaqz2WJPHEWrMt+KFXgHEt4cxnJtwx6G604vLrb7QOnT+vJL/VDbJVtlF+puyzhMbQoggUmrHXArbCZEX+XcJVoRicY0VHe7/Jm1ufbIe8B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A1AJehAJ; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A1AJehAJ"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-7b6c3629816so23284585a.1;
        Wed, 05 Feb 2025 21:12:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738818764; x=1739423564; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dCKZuwHWUkaGofn8dDyAaPB7Hq1I1Ov8Ymi/q+s6598=;
        b=A1AJehAJHptDaTucautBo0COJtfmYhBMQjmFqJWSnIUEE8A6/lNAc1eFNWPx4K8ojo
         H/8xy31gdN27jYihDfR8Ual8uFnGtB2AGonXs/nUyl1wOMAXBNdokAN6PGsR1jWE3vn2
         PLfvz4CcXCcKFRlPTVwwyru6GUdrZ0NUkIoPhXdBx0KLq9a5zPK9UfDTOeKXyEW/WJxM
         SGU0y3BzBUwFCS1crAE19dxyjRI2dI2BAUDZGREeeYDYIbk5EOyiZyXFOUjFLI1qnMdD
         Pz+4Tw+EBx3z5+f3qmXpnOdApAP5xppHKKKjner3jTBR+QymgSn6hWNSWc9IKVrUmGzf
         YiBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738818764; x=1739423564;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dCKZuwHWUkaGofn8dDyAaPB7Hq1I1Ov8Ymi/q+s6598=;
        b=rQ0I/V4vzTVSClXWdAWp5hLyPKf5Wij31njOzdrRmr4YOXj9kakIesVs/jBVZVHdzH
         Hbw8sYpuHvHhRAPqDZTUw12+2qtb4TZw3hndsycgcHaJlNgAFX5lFU6SlpnW6sz2UPsP
         PYMJEYDJirOk5mu8WNZC1KpP1H0L3t2iLnDpgf/zJaJjpEpthqJ5If4h8jEie1Juwlxg
         Vd7Eg4cmh0rOX9//G3M60cMiekgBe2eLpLu4O5CtOC3YmQ0PxOHW/mO7/oQdNC6KvGji
         W5NwCxkDAUqtniGBogtvWvgtc4lT7kfE072kRQ5AtJyNuVaquFBtYw2Sz7PiStl35KBp
         HOag==
X-Forwarded-Encrypted: i=1; AJvYcCXHtZeiAp2et09F+Y0cBBTuPdWGcHpbhXlo5pwfx9BL+NHCY7ISeG/PHiTz+rdPL6Qzn2nLwl+wRNmeZt0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7kptUh8+KUdhllTxullLaVHPD8NQx/aY+oNneNZ55R50SCOmo
	XxDrCOPQ9i5vcejSoR3ctgPKs0lBSsULrSq1/FZ5iVr8ZbAGsElkmUpiqpL+T0AcwGBcVDdgHyd
	ayaHQhY+g/G5ujqQQ0u2BIEcywE4=
X-Gm-Gg: ASbGncsV3jZnbN/Xx3q4EdzGr4ydvYA+2sqlDEAaLhKENeI8sgbI1oOjpL/KmQ5utXe
	iB8TYRoUCYHV5sChh0jfSam3Cj8csJDIh/LXDvxKAg1ilax1NiFippoP1VXkeqNRNg/NPOtzX
X-Google-Smtp-Source: AGHT+IGVk+WMwd9Q9upzXgIQfoPrAdr3Igwt1tPoWQ83Xs4r0SJjwIpGy0/DO+FZ6X3XxGHbu1LpSU13G8U1jTzIGfE=
X-Received: by 2002:a05:620a:bc6:b0:7b6:ce4c:69d2 with SMTP id
 af79cd13be357-7c03a02ef60mr746334585a.36.1738818764148; Wed, 05 Feb 2025
 21:12:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <d5d13945-da84-4886-bdc7-9a3ac182b2be@web.de> <20250202213239.49065-1-jiashengjiangcool@gmail.com>
 <6221018a-873d-4fd5-bfaa-5c83d09ea2ac@web.de> <CANeGvZX5gcYj+Wjp+t=GLtOePHBjMNmVxiPsk2nruqsbiRaqVQ@mail.gmail.com>
 <444d6d33-d916-467b-aea8-25c61977713a@web.de> <CANeGvZWWFk4HjFGnzqW9aGc_FPFw_8xx_vizY48AYsP2T7q_WQ@mail.gmail.com>
 <d4db5506-6ace-4585-972e-6b7a6fc882a4@web.de>
In-Reply-To: <d4db5506-6ace-4585-972e-6b7a6fc882a4@web.de>
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Date: Thu, 6 Feb 2025 00:12:33 -0500
X-Gm-Features: AWEUYZks8KLsnzgTsZA21c_maLrwgnqgn00aoq1SgqpbD8lvuXq5Nrkymfz7eu0
Message-ID: <CANeGvZWVJQdCDDboHN7RPm2aq+oBZYQ0CSWcPF5mVQxh2fb_CA@mail.gmail.com>
Subject: Re: [v3?] scsi: qedf: Replace kmalloc_array() with kcalloc()
To: Markus Elfring <Markus.Elfring@web.de>
Cc: linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com, 
	James Bottomley <James.Bottomley@hansenpartnership.com>, Javed Hasan <jhasan@marvell.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Saurav Kashyap <skashyap@marvell.com>, 
	LKML <linux-kernel@vger.kernel.org>, Arun Easi <arun.easi@cavium.com>, 
	Bart Van Assche <bvanassche@acm.org>, Manish Rangankar <manish.rangankar@cavium.com>, 
	Nilesh Javali <nilesh.javali@cavium.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Markus,

On Wed, Feb 5, 2025 at 3:12=E2=80=AFAM Markus Elfring <Markus.Elfring@web.d=
e> wrote:
>
> > Thanks, I have submitted the patch series.
> * Would a cover letter have been helpful?

Okay, I will resubmit the patech series with a cover letter.

>
> * Why did you find a =E2=80=9CRESEND=E2=80=9D relevant already?
>

My previous patch missed "Cc: stable", so I resend it.

> * Is there a need to increase version numbers?

Okay, I will keep v2.

-Jiasheng

>
>
> Regards,
> Markus
