Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83A136A023
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 22:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780351910; cv=pass; b=UGMWneRjNPrkactY3EiizMxUChe5z0RrZMVFkfLlCjJqCieMjvrfWW2181XFq0kr8jc5Q8lHJ2i7u7vNLWIEI5AymljmoOb7gxnv7BMxBlDcqStc0AxBCxZZzCD3bVD4WPV12+SAyfTXVyJvDlrovsh9bDKdbUAfcxhooutMN+M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780351910; c=relaxed/simple;
	bh=K9jyVC4q6rfeGBNW4vL70B43GvimX3ma8xIn4q5MSlM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OLe6v+bHR6p3Dc7BuPs/QXQ1bVMX1JdJy4xBXqI4Ic42iC52HdA5JuY0KupnX8GQ2GD9GoqoQcaykwZmvtm/DJe6iNG3x/QZa2KcY44qIWbFtdPhvR1562G7ZDafNKGXE73YEwOKGsPY0NcE44n7pv7CTfw+jzz5dfCmPevzeSc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AF1l/mA9; arc=pass smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AF1l/mA9"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8ccf7b7d188so27746346d6.1
        for <linux-scsi@vger.kernel.org>; Mon, 01 Jun 2026 15:11:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780351908; cv=none;
        d=google.com; s=arc-20240605;
        b=Zw8+wUHN8ARomxfYLW5gH2jzvOiMT0WtxUQJNgxUpBEajR+tH3eV0sqdVkpIWf3W0u
         6gpDcP1F5Ky40FrrDpnFPE7wHVQOl9+Fvs1lcMq1HKo46m4s587demwEE0UIDRFeMxKt
         XI02bmWIX9wGoETn7YCe4eFvoeT8YY+lv3gaTR7XAp+ZB593lOaJyPcm4nP2rSew4cvv
         7mA2e3w3mb02975Qfr8fs8TpqjpCVkPkRSzs0kxCtbKILGTvQWwOOeGzJ4qrIoqUu/iU
         nHqWo0RNLTkTj0kho3mx2TSManBNKcZoYqhk9xBT74F4rPKIWPeWOk1vo9bNo/kMuXqx
         kVZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YxFz5E1m/4EIoETmYAZx8+C73aLd4z34WyNWgD17X5w=;
        fh=ULMhEbVLB+vQFDJC/EAZ6FHpYhBFee/1nBqUi89S2OU=;
        b=C5QImphtai4xi2lSxLcDccJjZgq4+0yM9ek04Ubaxc9ZwmtPoKO2cTpE+Ku/QSVRQg
         mheYI4oCh2bUqV3zSjJhTPx+oBWZSc6kyfscPg9ycBmfe8OL7wOo1XU3oevwyxxtpwuf
         6wjaLtEvNnom3huquX0qMZKIMyhXrff8C476DQel3k72/5RqS/GVOsrxwl1oKZJqDVWY
         SrvHSapH/eldZCYv6bPs/fcW9Glc7je/Hiy8el/+Cs7wV4cG7dDHv3oEhBTTbOeiiSSB
         rd86xEwFYjcXLG76dCh63wL2UPPybNME6plqE20K7AMbiHPBYQCpDOXGmgF+7EQvZjJS
         Yscw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780351908; x=1780956708; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YxFz5E1m/4EIoETmYAZx8+C73aLd4z34WyNWgD17X5w=;
        b=AF1l/mA9weTK8YoZ0JGR4flhoBSLCE154/ZtTDx3ZXhQChJXSvOv0o6wZCfGTCM7tm
         Fvplofk+A/dEpU+Lt29Kza0p+6DuWk2WM0I6TDcTgb51128AjgKcmptd7WiY6ivsbX+o
         pzJlwALAkaMASTPMX4EVhJfgCVvsztl+4WD7bfBXyt+ceBhDpsQ9mkUChPx1utN45DNC
         ta0uNsC1AMzdYFk59IWtVUqdy4xOvUmomDvjnSk22mrozkv3UTpmfsrZtm0QBbTeouwB
         954ahbriOnonK87l9J6WICzlpNj3Bm4Nf0XUQVMH1tOtyRAvvsXBOX7jeZipFCnznkTh
         ceVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780351908; x=1780956708;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YxFz5E1m/4EIoETmYAZx8+C73aLd4z34WyNWgD17X5w=;
        b=AVjLpdLhyfhBXpjJa76JQbVcIS7bY3LnSWy7DvCwSCBI7wVbL58/WKIZfx50n8U8lW
         6U7ByG4ZpYG0t3US/X101hiB9Ss6QTTAzKWEwOj1Znas5y+MXU378+bnOypDBtMks2Us
         npw02CJndzQe0C6uyrxeec94HAoIWztE6M/ZEP6RE8HPMICeXoO8fw4Y6HAcCjICNEhV
         toTpG3/ngrGI6JD6dYqAsGURAWJXUMC4RSOCbv795fSadx5/JbhLawzq4dq13dFMJpXj
         7qK/mPUzBmDNpERD1JBdCfZeBHvHYT/vT1QOdJYUAM1UnqfQsHlmm9qBeJJSHIeAJNDZ
         UiUw==
X-Forwarded-Encrypted: i=1; AFNElJ8FztDSWRfItq73TOQuouedUIXw4XWjmQBy1PpOc+fYwAzxe/M0G04ncJ2TP2nfxBORPkGjDsYArmRJ@vger.kernel.org
X-Gm-Message-State: AOJu0YyDvM17LTysa0Qhe/QTduRrCPbbqyClSpLALFBYDvK549uni/DD
	iJ3Ed54Zpx2Mnp8ZGj+ueXXSuy3d3bfKgy/tovknrfvi1/iUH7V9X7ldIJl8x38Zl5HQNzRPA0w
	zNtmFxvuUD/hGpcukiTmd59WG1BFWq88=
X-Gm-Gg: Acq92OH6ciVzEtB1Z4tUGCrAGJ6tKbNHn+SUUg4fimMF1QeRUrbNdxw2WR6b/6h+lj9
	Fzg+D3x1WuuXsnDq8+k5J0R25UrtuiM0imbiN6OvqcRcNR0DB2kzTFw6jgi1SxZVVN5znjtt/PV
	uNK0W/bnlclCHHKgqBhas7MbFTvi8iijdFYwx0iXM8JobZjIaPFTdrF9ASHDHlEa2an6ZbNIT+8
	i6AtH/wz1rl3TGnyazYiiy8MoRLgTG1UEHDNDEqy9j5h/E8yungtn27zz60/XIRNtYOIbdkkgFw
	x1XpnH3zvpSfsersZc64e5p/zA8SRf7Dt3TYzYdcUtblopTSLzs+qXQOf38jwA==
X-Received: by 2002:a05:6214:2b09:b0:8ac:a546:7753 with SMTP id
 6a1803df08f44-8ccefb1e984mr231913036d6.8.1780351908356; Mon, 01 Jun 2026
 15:11:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260601202001.651088-1-william@theesfeld.net>
In-Reply-To: <20260601202001.651088-1-william@theesfeld.net>
From: Justin Tee <justintee8345@gmail.com>
Date: Mon, 1 Jun 2026 15:10:07 -0700
X-Gm-Features: AVHnY4JYJI0yJAGWlZBdp-9VmeMj0jV2ZEyAsH6PanPmN2QR0Pvww0A4bJNdbQc
Message-ID: <CABPRKS8850t3Tv7_cYC5YDFq-xWm9K=q3fH9CPpDjW85zWa6Aw@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: fix spelling mistake in comment
To: William Theesfeld <william@theesfeld.net>
Cc: Justin Tee <justin.tee@broadcom.com>, Paul Ely <paul.ely@broadcom.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi William,

There are other comments in our code with misspelled words.  Is it
possible to help out with correcting =E2=80=9Cunsolicated=E2=80=9D in lpfc_=
hbadisc.c
and =E2=80=9CUnsolicated=E2=80=9D in lpfc_attr.c in a patch version 2?  The=
y should be
spelled =E2=80=9Cunsolicited=E2=80=9D and =E2=80=9CUnsolicited=E2=80=9D, re=
spectively.

Regards,
Justin
