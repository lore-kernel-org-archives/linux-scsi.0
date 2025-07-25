Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FC51EC01B;
	Fri, 25 Jul 2025 12:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753445800; cv=none; b=Q3sz25sh94RJ7S1p77NI+7LR+oK+rRcx+2enHg8JUuli/cpaGRwcZBzjTu6h0svBJtcnR1LdhoUBeP6LV6ghyzz5oG6ttNi5jDCgs0tHMwwwc0Ct8S3T/49qQnkhyhG4POZyPBPQU3TIS2+PAg/oQAa+EDF6h56ktUdCjsS7zvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753445800; c=relaxed/simple;
	bh=OuG1CTeRyKj1R4vzsa0DIZZsT/WphxujjGAB6utzPSM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EZseZQ/5P+oeFx96TZSqOIW+NMrxoAVNQznihJt8NuGfQVfelUC86tnzhzvgymZJY7FWy38yqtptrnsRLXQf3GKbnuFFyZVov6QniGrekC06rCysdo+W8+Zx5DOV4lOs6qRigAshVb467fa/k+tTgXWdkQbZ5YINDOfgM4WSJZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HhwJPIXe; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HhwJPIXe"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-32b7123edb9so26507001fa.2;
        Fri, 25 Jul 2025 05:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753445797; x=1754050597; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FWqM+C7auc61yVm1rsNVEwh3eE+ELNPdk6XGXZ1WIxc=;
        b=HhwJPIXe4fC1draeoaaDc6V3iWFtbgsnuLDiN9QmqvfcS80Z4OcdG09Zm1fogsWFLI
         EBuB8koGehjpgz3PmGpxDz63sV+wdyerxuTmHp0qP6j1Fa4HW6XDRDJaoXN/QNc2IMzG
         /LUGRwUAZtHjXM1xfGjI3XF7kGNNqerp87d1N6eccAIhVDGrsAX5EMYxl95FrHOswG4V
         1IJOo12OjMAmrZIVynLTPi66TPclaWnKRKtFIUvOkI6XN7DckIEPRIRETriHVfkRdGkR
         0o5Ekl6Yhnr8b6jaMtKTBPN5idmCkwRQeAamZALgG9plx6YfiV+2r4lI6bjK1Eo2LJE7
         SISg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753445797; x=1754050597;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FWqM+C7auc61yVm1rsNVEwh3eE+ELNPdk6XGXZ1WIxc=;
        b=M16xb+ROF8aYn6zmSL92V7FN2+/4W5269wjH5mZDSCJLziV5Zs0MEYvutEGQWkaXwG
         ynob+Zf1QCCb+VKMc3IVNFmkS9gWYODN8Nx/vLvstwY9xMThcpvVXlj/I3Zi7WcEYjZJ
         nn8nDzRmhpltwNe21sw1ckMz1oz5UN1jI7y9ZMRUK27Jq3fDZsREePFXbh17sHA4yd0n
         lpfnrTr6xID3V/XGbTnDA2DyleKBiWbrAEkeKMuN10o++RQJC4UkSObNSFHeb7gaWcU0
         x237er8+mUVmn4k62hpjOPimg9bXtUouDG66eErEuAIITgj+3iMVQxIDtzpGe2G2191K
         b2yA==
X-Forwarded-Encrypted: i=1; AJvYcCWGdDJcfOnVbh4h/n0GCOiTvFWBtAhl5REnMkT1hxEHN68EUvSkyWMOhPQQKDLG7zvJA9O59QgKjUdOHEA=@vger.kernel.org, AJvYcCXZzqLefHAbxowoxMxZ+z8EYEUvjbKU+PN0Ezm9q8zXLegL/ng3GESbCGSL24VhgN24UYWq0Z6DbTqJ4mVW@vger.kernel.org
X-Gm-Message-State: AOJu0YyiVVqp/u5ChF4fTGM+L0ke/8QFq6EaNgV+FP6VETjI5H+AL2Lp
	Q+E7SEzmftALgkUbf8nUCwX0rXgq3QDr/LvxdbaOuwqrwkRPR3VvBkYenuaXECo9TXlfL4C3o4e
	jvTjChDSC6pEz2unPk0wGuaUIBDYek5M=
X-Gm-Gg: ASbGnct94VBkxKL61HLY08EQnN0BQK/ywUEZ4bbDOAtTDHxdkg+5C4vBIH0Xm2yyZhU
	MKipABsPgKK5AaqCdMijfB7Y3+8j7t4yztIIX8pko9U9Hdi919YDu73JyUH3V4BfQtY1HANsFt8
	0gLNan9L+ibrhKZ0QqABwoAZcB3X0eugv7j+A/QL2RpcFNROq/hKO8ImVfeLqrAp//LEyvLw5gO
	/VD6iA7jiIW0y8zEmaRv7TVZPBDG/irXBFSrSJ+ag==
X-Google-Smtp-Source: AGHT+IHyqCZRpQ3iwmGQDc1/6kxptmmlPmdgHw1lqiVZmo2HMouuishREQW96mVd4w6lxf84JBGVClbJXSwOIYFcvQ4=
X-Received: by 2002:a05:651c:3248:10b0:32b:75d7:fc62 with SMTP id
 38308e7fff4ca-331ee7aab3dmr3420251fa.38.1753445796930; Fri, 25 Jul 2025
 05:16:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250706092522.9298-1-pranav.tyagi03@gmail.com> <yq1bjp9rqh5.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1bjp9rqh5.fsf@ca-mkp.ca.oracle.com>
From: Pranav Tyagi <pranav.tyagi03@gmail.com>
Date: Fri, 25 Jul 2025 17:46:24 +0530
X-Gm-Features: Ac12FXwul_qh-KD85e-MrQnYOfSIuco3toGb2OQLyA0Tzh4yRvOKtzf3etCfmig
Message-ID: <CAH4c4jKgPv-Mb1=WvOW+jvGMABXcEgaDMxV0Wit32LPgJitekQ@mail.gmail.com>
Subject: Re: [PATCH] target/core: replace strncpy with strscpy
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, skhan@linuxfoundation.org, 
	linux-kernel-mentees@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 25, 2025 at 7:22=E2=80=AFAM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Pranav,
>
> > strncpy() is deprecated and its use is discouraged. Replace strncpy()
> > with safer strscpy() as the p_buf buffer should be NUL-terminated,
> > since it holds human readable debug output strings.
>
> If you must do this, please change all the similar occurrences of
> strncpy() in that file instead of just one of them.
>
> However, given the fixed size of the buffer and the length of all the
> defined static strings, what is the actual problem you are fixing?
>
> --
> Martin K. Petersen

Hi Martin,

As far as I looked, I could only find the following 4 instances of
strncpy() for the file target_core_transport.c:

target_core_transport.c:1115:           strncpy(p_buf, buf, p_buf_len);
target_core_transport.c:1165:           strncpy(p_buf, buf, p_buf_len);
target_core_transport.c:1225:           strncpy(p_buf, buf, p_buf_len);
target_core_transport.c:1279:           strncpy(p_buf, buf, p_buf_len);

And I have changed all of them in my patch. Kindly point me out to
other instances, if I am missing any.

Also, I intended this to be a cleanup patch for the deprecated
strncpy() function and wanted to replace it with strscpy()
which is encouraged. No functional changes were intended.

Regards
Pranav Tyagi
