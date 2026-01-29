Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BCA634F490
	for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2026 17:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769708407; cv=pass; b=Yg0+1vaxJuzVJ2IW+90h2AmjfeZ9Xt4m///R5xXzulfFS98i3iM9VLTGYwVOtmjmEZOodaI0Y+XgqdVZGmCmtyoOqTTD8AOb8miptfz/LOBMEc9+VWENg/Gurw4UySLF62Zp1to77A0v42smHGaSS19brPYQ3+PFAmOEL0z83hA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769708407; c=relaxed/simple;
	bh=WoM64yTCNB7JYnEmUR+2RQGgCYwp8/a1dcVHbRqdJek=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AHLikUzDwYRW/qgB024C7arqoqXvXzgyvQCRz1o6zXfTzzfXqFL1r/rj0QZzPwEDkKzRLSG3fBwTjyYBEVskfnieKvUw6KkbwGpudNWocJMDAGa19MgM6GaDdVG20EeIwWrrFHpkGAPACgk29XqPZrZ/+2YqUyw/yITrYMgk2ZA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=soyRwUac; arc=pass smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="soyRwUac"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-59b6935a784so8531e87.1
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2026 09:40:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769708404; cv=none;
        d=google.com; s=arc-20240605;
        b=Nk3XXDdqHCAwyKR/IfuEnvmMjmLt4Y+mbFwdZ8fWNsGmvqcVCv7jXv2imvEcqOaoRQ
         RNk8Kh3tq0e+qG00nkkfejzZYeidBh1xXbRw1WwfprNmmSYFIH8/nsxicapEkXKLspCB
         HyVgDl0iWpeDEAgFMUqKf5vxqK/p8xz1dOOVpSFK46HMOjbt9tfgJe+MqCC10ITlJnhs
         uy0Y+69EE9pF0aAhGA6ecobqQ5Q5ola9S/JSjyKYDuxUu/gSbY+8PoSeJlmHX/V03E8O
         6s/xTBRzHqG68YtNNLyv3aOdPiCyu+LJe/5BN4sgiyC2S9sslDkQNIqCtBXubMnvN7Cz
         orSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WoM64yTCNB7JYnEmUR+2RQGgCYwp8/a1dcVHbRqdJek=;
        fh=4XBG1NPHlbNoHJsoK2ipLzfTvDqAAu8lxIbB+8mkCgs=;
        b=NOmUucIP2J0VPptAG/SKCwIvZ80q+ihJYY1fCiesP2NAqjRqXspYqzfuW8GovHKLrX
         nyrdXLQbgmqN4BGHFB9PxXoEIqVG1z73UAgikq/Xogu5hgHzkJ2ntlEXUyQLOgPn9GfO
         YkDZx96XFu7adeidCJ45+zAeMGejdXhleo9ipnBxXF6v/LY4oRP+PfpLa67CEnHL1kf+
         5Nlt111nuCSy1arZRWMGWUT1U5vmIZW/Jc5XrIvalDTE6TJhqh/mriL7u9ufamTrKp3x
         iEyfMcF4sog8S2kL2+KX1ghYwCORhM/h+ehh6ae1elS3uxCUzRhD2Pw9HV/yzmZ3pT45
         Rj8A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769708404; x=1770313204; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WoM64yTCNB7JYnEmUR+2RQGgCYwp8/a1dcVHbRqdJek=;
        b=soyRwUacE5+/d0e1xEvLV3CzQwvRklUgZu+07GCR5r6HWPCEcGPgNAwsyje7XAM642
         9WUS3lZda5f3vTrH01PbicEy0xRYVAVabN63Nks1UQ0sDagNFW3YaIEubznbwPJrgoSP
         3Pc2ExKHKNIwplB5vwCN0citQkrpJutv8v7RSLL97RVIFuFGZaacTrKRG9BGlz2V3gLs
         5OzAFINrUM7vvNS0CutWlx6ATilTDDr1Q98bwtWkjIFk750tNQNVONDMm+fjB5iy+gFM
         n/KBsc0bPGAssm48so91Lihz/DNXIeDtVVRpHpGHQDI3aRYVTn70fpoq1gpD+FECxVF3
         KVLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769708404; x=1770313204;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WoM64yTCNB7JYnEmUR+2RQGgCYwp8/a1dcVHbRqdJek=;
        b=dUi4XZ+la0YELvlgKiySS6yAzRx9gqusBfwM4w4FpDbFUgQNTufogdMD2a0Yd7TlOu
         7mpmCAXMg0XhnJMM53GmQhVs98SuHr/0qSIMb4lrn1WvzbMRnppVA2Hxny0hfarh7MW7
         s1utA0erOeEzktom82D4+cAnaNRCWKSP3ATfe6loilvtBD8Gra/MKnhY1xeuUJxlnrPz
         Wa/Nvk0dS7jVp4iNj06IiB1k+w/h6GLkgyFUwt5L8WGe2Vzj6+xV1J8LiQOOvVraQGyK
         /liOVxL/EWrh/0G/lf1gh5UE8RzjBBz81CV3q0rPC+9iy8mejmxi332GW+NxrOmPmwL0
         6DGQ==
X-Forwarded-Encrypted: i=1; AJvYcCXfygke036TAADcskOvOT02tmrgitASmziIgCg60uSJcXIjjvWi4GDpZsuP6K7QjJ2vLUPHkypquFNz@vger.kernel.org
X-Gm-Message-State: AOJu0YztHHy76lCXuOm9cgS+YC0RFpZSG0TL5mDk3OguXL6yEVll5nRz
	/7tK8L2h2gm56O8gEyU/2/B4KG6LPOEqsDPDJclXlKPRnWDYfOmfAslbzGvBEAQknMYYd43wypf
	WYmeWQlJcOrd35jvU1WfplNFR7oWkxmMohqlI+INH
X-Gm-Gg: AZuq6aINWqYKttTjTkifZILMJZ9OAhQeBCL/VEl70IAtRSxNp8jAN1XVjaRax6XPrjE
	2VPl39TxrTd00mtZk80RQgeSUkbEEdF4+be24aSAUst7TejbpL3adjquDrvsUmPlClwUsu/FySA
	Mxgi2wGlCXpQizd5bSOLt++D/nnfNIZFvxa2Hk+UK6s9MLL4mzl0NcjcSJNK2tGOdr0c3uCUmaS
	mbUjNevVlM9WCH4+EoI1Lq79XZdAl8Dun7blG3np5x/EdgTv6H0G5byAGfLgiT4f4PjAHraGr0+
	Yt8C2NwWr2V4OhyxSC1sci8=
X-Received: by 2002:a05:6512:67c8:b0:59d:d4b4:97c7 with SMTP id
 2adb3069b0e04-59e0e9eea13mr143439e87.10.1769708402489; Thu, 29 Jan 2026
 09:40:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129070657.678532-1-thomasyen@google.com> <491d53b9-a110-431b-9a5e-3b46d833fdbb@acm.org>
 <CALw5pqG735L-6-umZspQOKB9DfRHf7D0AfpkRD_=xwX0LtZ2Vg@mail.gmail.com> <076fe171-6fd3-4dbc-9876-242905379594@acm.org>
In-Reply-To: <076fe171-6fd3-4dbc-9876-242905379594@acm.org>
From: Thomas Yen <thomasyen@google.com>
Date: Fri, 30 Jan 2026 01:39:50 +0800
X-Gm-Features: AZwV_Qhggi4K8iOK9JRp7-P2bluiHLmE4haFJYoFWzKZ5xvP88OESko2o3VKUME
Message-ID: <CALw5pqH8LDxxHcpS=KGnLtdA0GG7sdd1y3Zz9hQLfcChgyH+GQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] scsi: ufs: core: Flush exception handling work
 when RPM level is zero
To: Bart Van Assche <bvanassche@acm.org>
Cc: Stable Tree <stable@vger.kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Peter Wang <peter.wang@mediatek.com>, 
	Bean Huo <beanhuo@micron.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>, 
	"open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Bart,

My apologies. I missed that Peter had already replied with his
Reviewed-by tag on this v3 thread before I sent v4.

Since v4 is currently bare of tags but the code is identical, would
you prefer I send a v5 to consolidate all the tags and fix the Cc-tag
ordering? Or should I wait for you and Peter to reply to the v4
thread?

Thanks,
Thomas

On Fri, Jan 30, 2026 at 1:23=E2=80=AFAM Bart Van Assche <bvanassche@acm.org=
> wrote:
>
> On 1/29/26 9:19 AM, Thomas Yen wrote:
> > I had just sent v4 (to add the missing Fixes tag) before seeing this
> > message. Since the code logic in v4 is identical to v3, I hope that is
> > acceptable.
> It seems like our emails crossed each other. This is something that can
> happen.
>
> When reposting a patch, Reviewed-by tags should be included. I don't see
> any Reviewed-by tags in v4 of this patch although Peter Wang had posted
> a Reviewed-by?
>
> Thanks,
>
> Bart.
