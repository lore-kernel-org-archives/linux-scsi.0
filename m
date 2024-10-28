Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45EBB1F754F
	for <linux-scsi@vger.kernel.org>; Mon, 28 Oct 2024 23:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730159862; cv=none; b=fLazrVmY4ppNzGKFo9WRbLyjcdzynLKjF75H5WSX5wTRUt6WZYjbtvl8Syg7ZmMSvNK3w3qcxsBnXkSKGGrWkLX9c07FiZTwGJRvseHs3JBxgFlVum/VH/4KtSaDvHe6gRq7mvWCuCthmrDJKJCuus5ZlHdM0e+EY8zy0BQIZtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730159862; c=relaxed/simple;
	bh=6Aoxbp0kWpazqGFiXPzU6HehV04uEOAUZ0Pe1G18BRo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S7S7L1ASru3k6sqf2sU2NJV1kZLeMc4WJyf1xy7YnepxFZs8FUQQ+vg2I+z3Di364ygJlZnzw3EKxEKtKVAKuK+5PVtsuLHnvOrE9bdwavHa70ecLx3/6SJnhrArqBbVK5MncexfoBaRUcIUN6mxE+9sgl0KokuGKXB8fs6I6R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M+xNnfzf; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M+xNnfzf"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4608dddaa35so79141cf.0
        for <linux-scsi@vger.kernel.org>; Mon, 28 Oct 2024 16:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730159859; x=1730764659; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ydE9Zx48AhjgMSLpCZz5nUZF4H+ev27/Zss2ccR8j5g=;
        b=M+xNnfzfOpMOoxvdWN4vElG7qISEMAvG6TFGMPDW9qgxaJzKIZhbavhe0erKp5SH/F
         TJHM0eNV7vGgh9N9qJNxNTiUPmwPJK1S4nKQuJIAusN3zordEfeXVF/j9ekNbAo3pim7
         YoUY/og46jjB4A8MKMB+O0dfOdV2mgOPq0diKl1Rr+RTGcw47gtWRIPsnZOzsHc3njIh
         aVyLDtS/fQwrNQVZruQ5r63ItPXpb/5vJiPTCfcDo5eaWrMRUBw9iop7ehmxGRFrEmP4
         eh20wbGl8Qi1Qggi+vSG73H5skzZuEUwgXRC5ZKtI9piD4nmAwwVWF9Dqok1mdnp+kZi
         mGDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730159859; x=1730764659;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ydE9Zx48AhjgMSLpCZz5nUZF4H+ev27/Zss2ccR8j5g=;
        b=BrGA2dSlmEwayWMfA98HrtJUIqgPX5Swi4jmxM76YWzIZhOS5qg+dSm1lxCCkTDsOz
         uVWa95vJWEf4Reww6HvkcNtN3xU8txHWjunC+rulhfA0d3HWvbNURnaYrQBpMvXYDGpf
         3J9ca5xeTZEsYDALMJ14LBhJcYAjhFvpnrIVN9Np5rBeusojMHhss608iwXcPSakq17e
         eaNF2FiOOASWbMpSC6QYgs/KKj9sUZwN9ceSayeFmHtJoUj9MSKU6frFSxU4sKlYjDw6
         q+y6J1Wi1nLeZWDBSXeHKNvL2bfwy9+ZR5+Ap+t2LslgTmCAG2Vh7t4VhOtHwM8KoaHk
         A0kg==
X-Forwarded-Encrypted: i=1; AJvYcCWQvzMdlYrkmlIM1qOhlbBY1gbY/vSmaaKZTNpG0Xn3Dk/aGikCRcInC3lDQlfL8WUYXs7IesGO3EkM@vger.kernel.org
X-Gm-Message-State: AOJu0YxxliXANoQyKpYH15x/WTbfFYMusaptxFTO6C5IC1Zj+ZM1jjOi
	CLTIwJYdaTmnmorBh1f/Tk1QoRQdxcg+c+yuFcy2LNGUX0xvczI/FkuLP71ExoEzwVtbnxBnP5I
	avm9XfFwGmYZzgLKGb9EDx2BR+bVKJCMpcqjK
X-Gm-Gg: ASbGncubqyVJZMIol3zS9JqT55j3TWDMBTj+6XXbii41uuaDD+KmXeof6uu6H/XtIUQ
	3OB6HjSozxfWS8p5xLSAYmT+C6kTwO549azRty72+PtGCXDKFRAMjShH+0kud
X-Google-Smtp-Source: AGHT+IEPgv7Vt8d6wl8U8U8BGXQBUGrd/LAaapOLRCni+GXeXpNm8YpivIZUTmdppX3eVCcTRknbKICnmERI1hZbOfs=
X-Received: by 2002:a05:622a:47c4:b0:460:4734:c487 with SMTP id
 d75a77b69052e-46166e41539mr658121cf.29.1730159858954; Mon, 28 Oct 2024
 16:57:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241016220944.370539-1-salomondush@google.com>
 <CAMGffEmEJp_oVAsbCVV9PKs7vOKWLrUhRGcBGoUSx7+t4ZtsQA@mail.gmail.com>
 <CAPE3x15ryZw4s=qA=7HSDyZZXf3FUz2Ms7cxXHjc_R+UbPZTwA@mail.gmail.com> <yq1frokf2ii.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1frokf2ii.fsf@ca-mkp.ca.oracle.com>
From: Salomon Dushimirimana <salomondush@google.com>
Date: Mon, 28 Oct 2024 16:57:28 -0700
Message-ID: <CAPE3x14n16PX=pkLVJ2x2T3VZYKfbLUk94wd5_5S9WDCSpmQ3Q@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm80xx: Use module param to set pcs event log severity
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jinpu Wang <jinpu.wang@ionos.com>, Jack Wang <jinpu.wang@cloud.ionos.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Bhavesh Jashnani <bjashnani@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

These are the log levels and their descriptions for the pm80xx controllers =
-
0 - Disable logging
1 - Critical error
2 - Warning
3 - Notice
4 - Information
5 - Debugging
6 - Reserved

Loglevel 3 helps capture messages of severity level 3 and above. It is
not expected to be verbose and helps avoid the log overflow problem.

For debugging, there may be a need to change the loglevel, hence
making it configurable.

Thanks,
Salomon Dushimirimana

Salomon Dushimirimana


On Fri, Oct 25, 2024 at 11:45=E2=80=AFAM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Salomon,
>
> > 3 works well for Google, but a different value might be better for
> > others. Having a module parameter would allow users to customize the
> > level of logging based on their specific needs. If that is not a
> > concern, I can change the default to just 3.
>
> How verbose will a value of 3 be during normal operation? I don't object
> to capturing more information during failure scenarios as long as we're
> not flooding the logs with noise when things are nominal.
>
> --
> Martin K. Petersen      Oracle Linux Engineering
