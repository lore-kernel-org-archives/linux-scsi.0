Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1163EBF17
	for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 18:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770921945; cv=pass; b=iZl8vta+MAXWkZqGMd8uNMskfUOqY3xJe4aD8n3JfflP25wNbN9QW+0ts3nC8JOV87auHucVeJfpGap8F1YbOQfZBn3tIegZtdm7SMVgmst4QHvLGD2qjTrj2NuceolLg51VHY2I38T4/GtQ5q0QfF7RiKGEtHlonBpVawswYRU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770921945; c=relaxed/simple;
	bh=yFS++ftok6M9tXG12+87yB0equ26GfTdDPXIVw/W/M0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eZuzwq61aZWMI1uOrzb6sVNts76u72G7S+Xk7hbTt8GajB5kZHd9sbqXNAGCCtOcIRA9k3NSswkQMvUoUFOtrAtsB9AGt4FICZhEcRtNRWZOUreKSuGnCJYYFvaGmJV0k5/MeIewc8LgrKM5MZIPFgTqVj0gDwCm2c8UW8Ly0JE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mWxuX7Y9; arc=pass smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mWxuX7Y9"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-896f5af3d8aso2342266d6.1
        for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 10:45:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770921944; cv=none;
        d=google.com; s=arc-20240605;
        b=k5l9S3ZUbIKQ0y32wpSYfvmBaQgegaVgASF8Lf2XDqoeqxicKxfoUvwQzz9o7BRCAf
         57fOzPQJSlqgwaLvuc2ie0vY6sjwq/O1ZgmIFae3x+olJoumTaRYJH0AFSk6tFPZ46Uo
         nRu9SwWUEiQYZeT9LTXvJxd9O63H1GoxJwHCycjHYCK04u1DKJrfU5DFqBnwf4Ycf8V9
         hFQkY/UxBo34StMZ4L3iDPyFvbKpGPjn62zkq71RffxadhUR1aCqmM9Yi9txpZ2cvl0P
         7Ipa9JLCvwy8KnusACNshkoA1Oh2a+CsR4wq0ZT53PpSthvYBN+UP42WL60Q7wQ0rT4m
         pdxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jHSb6BJBJAQRFKyEGB4IK69TYuErn9iUUNhnftIJhnA=;
        fh=Nak65M3TgXsV2RJjpzsyXrEs4yGJuMYX+MS5JFmKL1E=;
        b=U5lPhEIDB3Vk4WxTVE/LpT8IhHNqakY9uF6JE3VJfbnHFydn+YPlWnWePICY1On1TZ
         qqvavDW1t4JiuJoWN2kS0HmhgMjujRPlYYeufzY0mx2jbDFwSTAcW4jMVpYtBSK2qw9z
         2nmMq5ohVDWhDOXNG7NAyw7r+DR0IV/Qd1FpJSeCpTC/vOtOec5RKnTwPkSPcHv6m2x4
         EdhJhKnpWixApxSTOfs0/dhdNSpoR686O6UMIUwNWMObz8pKaOQzuAgijk8MQ/4ow9G7
         hdfRPwqLZZe0mav/ciUWAooDA0aMpFCA1ZB/tuH4+pQll0n5o6aNLPyGrprd3aSuBpCy
         CH7w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770921944; x=1771526744; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jHSb6BJBJAQRFKyEGB4IK69TYuErn9iUUNhnftIJhnA=;
        b=mWxuX7Y9mXKAbo5lMcYrdlanTDCmeOuv5rn6sWJs3GE+SFxB9MrDs/wDlLCnzq9PAW
         a+Qmf8kEhZ0Enck/BstxBvzwoiHxhesjXdI1mVsXrZpCA4M0Omy5geac8K90cxkJDz4w
         19PNj9ztcVb5yEIufFnk4XeDDqykm5JJIP+zuSlRYyNiG8pCPbI6cTW8pzIWSOK54wdB
         9fSY45bJUTtitfnV6G/Hsg4SJ6SlY6D+WJy4lUWGQjc795jwrlmhXOZFV/egvod3cWnG
         SYwcs2bz1UuXUJKftUacziiInGJl4zJy+tZS1rhc0K+sfZUZFsTTsFzuaJWw45kJd63f
         YuVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770921944; x=1771526744;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jHSb6BJBJAQRFKyEGB4IK69TYuErn9iUUNhnftIJhnA=;
        b=mE0Yxy+CIroXsXoskUGe7roURwmCSgykBnnOvQFDuog5f58+fv2yRZgK2LP9srtJeB
         Toe33Jdf7zhsST7Nf0/vokGm5lGFqEGglAuvMbKIUbmKdH7z0fxI4+JfUr2LM1f4upDj
         MTwaGieZndDZ7jWw2xV8YFoOlex/nJkCN+EZPMBWpWmLVelT4Kc7CbDt5rnwlW437a15
         Exm/oFl1gGALH2M/dHsxRmRT5YDxI1LdRt5EZB5KouTtclVYoJIcRZz1w1w8EdQ9g9Ej
         Wi6cixJKw2swBed3Vbu7D1XjHbbb9WKiuEX9afjxMrDhCv/YFbDRhafiXrdTAMXMR68o
         En1Q==
X-Forwarded-Encrypted: i=1; AJvYcCWtd3gHPvetWH3xacHLrFbuCjaswa7h9Y29KNQAIu8AnkDv8TgQwG1Y7KobhG10TJaJRem7myaZx3qB@vger.kernel.org
X-Gm-Message-State: AOJu0YwUlcyvp5/3HWL/3SMp+SKSnYAVLmVMv+GwHZ51SBXMLSIwGiw9
	ZiRh4HvMZ1mVnVeWgt4Cdo+mPnIK8q1V5bQAvaN7oksK1gUB8YVXFd3lV7JLbkhayA3PulVnlVr
	bMdEYt+C4Dsg5dsXBDxvORbT1qn7FyJU=
X-Gm-Gg: AZuq6aJUF7gMbaf+IxCTfv53Fcg0KZ8sEIINqgh9ZUwWHdJRs8ht8QLbbDW2i4RpdVR
	JetI3J1//T3DsR3V4ztDwCjjCBm4xASoXs3wS8BhO5pgVe3Xrjo7htXxcYmeDQndG+wcwede5mS
	/JfVXc/s/c52lQjo6Z9U212/TfD4XjvoIHMQkI5mZ5eHiQ4yj+ZEtTsig3f7egBOvFXwTIgqZI7
	LX1XtHnAYne7FlziIFkVPCBUrv4WKc+tPPGsSG7ApxmQZCDm7tKBopcCGNF8Xwb11R15SHsxEAz
	qSEvfIWABd3A9t8KKpQ=
X-Received: by 2002:a05:6214:e4f:b0:896:fc9f:3744 with SMTP id
 6a1803df08f44-8973480ede5mr1004506d6.64.1770921943698; Thu, 12 Feb 2026
 10:45:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260113222716.2454544-1-minipli@grsecurity.net>
 <CABPRKS89zwXdUT1Bhj37cQDyOHNupOJ-Ez6kS7Dp_pu06X9Myw@mail.gmail.com>
 <CABPRKS-ongXPqWVpNYiKvy_afVKn999bxtSEfsBVQ7z5JVCgeQ@mail.gmail.com>
 <59933d92-eefe-49f6-ad70-79fe7aef0f3c@grsecurity.net> <CABPRKS8C4WmEYX+jtAOTS_jeFYt_GeTp9uBoWzCMF8cUZxxzUA@mail.gmail.com>
 <CABPRKS_cT5f21A-Jkx_uhA+SF4THpPSaqKtk8mWk9nN4Gh9LFQ@mail.gmail.com>
 <82f38f49-2f50-4c8b-9482-e446e61d5006@grsecurity.net> <CABPRKS8yunk2P9vH0qr0Z-FS3Og17btQDa6dxYDs_2G-1QXkjg@mail.gmail.com>
 <f231ed5f-6c0c-4b20-8bf5-cafbaca26255@grsecurity.net>
In-Reply-To: <f231ed5f-6c0c-4b20-8bf5-cafbaca26255@grsecurity.net>
From: Justin Tee <justintee8345@gmail.com>
Date: Thu, 12 Feb 2026 10:43:43 -0800
X-Gm-Features: AZwV_Qh7MN6xCgdPogSOkQgL3VL5wG0Wo8kXkYksLTl2rJrH9wu0nGInneNkIEY
Message-ID: <CABPRKS96_+rKWLWgDKjGEgpy-p7sirYuuOK2HeFay+_N_F0-FA@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: Properly set WC for DPP mapping
To: Mathias Krause <minipli@grsecurity.net>
Cc: Justin Tee <justin.tee@broadcom.com>, Paul Ely <paul.ely@broadcom.com>, 
	linux-scsi@vger.kernel.org, James Smart <jsmart2021@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> To address my propably just paranoia concerns, can you pass 'dpp_barset'
> as an argument to lpfc_dpp_wc_map() and add the following at the begin
> of the function?:
>
>         /* DPP region is supposed to cover 64-bit BAR2 */
>         if (WARN_ON(dpp_barset !=3D WQ_PCI_BAR_4_AND_5))
>                 return NULL;
>
> That would make me more comfortable with hardcoding BAR.

Sure thing, I=E2=80=99ll post a v2 of this patch with my Signed-off-by and =
you
still as the original author.

Thanks,
Justin
