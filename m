Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220441A239E;
	Fri,  7 Mar 2025 10:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741343937; cv=none; b=AIB56nXcLBKSAkOjaTRHGKFvo0pF71R5kub6wkL35p17GbNZIqKoW5p2yzRC9xcSmErUmj3mrxix+SDuEWjaVZOuZnSacg8swmvE0Hio91Leti0XxVDL3WD+JGMJvjadEK4YqVjb4CRzBtPlRp2Jpm3wVIRPT/Y6CgVIj0QDxB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741343937; c=relaxed/simple;
	bh=KBjfkwRvGCUyvFil1J8pzURsrNfhG9wF/ffzDqhupJA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=i4BrrGamlHs1a4v1xxdafwgIpsQmEEs0MvCmDpa00JNPLu1h1VogIAcUv0cM29hMXIGLWTt6dXPjmXJCAYmymgzCvQd1xxjWV+HMd4g+dtR1j24TgomI96++/M8akgPuZ6ZR9VXCiLABW4MAtZJDKsp8MUudM+4SFuBvJN4dDAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Iq+fSDAs; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Iq+fSDAs"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43bc6a6aaf7so13054565e9.2;
        Fri, 07 Mar 2025 02:38:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741343934; x=1741948734; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KBjfkwRvGCUyvFil1J8pzURsrNfhG9wF/ffzDqhupJA=;
        b=Iq+fSDAs6F0LtZnFNme30f+57EjZXJRwxOrjGWyWbTpkzw2ysl4G5IR8mWyvSnJZQe
         TDHfGhj7Bj5Asttf87cWLzE8CXEP4/KzJiu9B2j7pAWpMzyjUS03n+dZTjtEsszIMPTB
         IecUHqZnrdl9DuARvhErSRtIlFz/KKMaP1LIM1Aiba1JUTfyWvhQEU5EiWq5BYc6YfRR
         9CHBoCFFSPmS+eADmaUkkSM/8Gjkc7KPvmG7GoJonOm85Del5/fWW1Sf8xnW9KjVSOWs
         UtIrr7k5nbnJlcleksuMUAhMw6vM8kO+R58K+eia4LM6szJSNZD29kDCc0SGwVl5RZM3
         QV5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741343934; x=1741948734;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KBjfkwRvGCUyvFil1J8pzURsrNfhG9wF/ffzDqhupJA=;
        b=YdjyfgZWy2V10uQGwXti58psKF1ArR2IH117sWffFk8aGTtU0geo5/vGXgbhtQ/il9
         a4uWEB8zgHjS7x0QPkebja+vceKjMyEsgo3AIetXVUTj9K2cpp5RU4YER7z4DLSNf/gr
         9yLpRZp4Azd4OqcvO4vEnTTDtXsU3q9V+ontU7LO5BkdgDNElKG9mJBS/DTKjJ+kEtGp
         gd5qq0HLr/lFPl7G/3y4d0AwiTqqndL+/TF1K95Bmbg1Ph37qqqEUsMffUiju5mdEiCP
         hyBEHe4AW86Zn0VRYMMRk5z1Mb+dG8fHE3vYGH2wpVwUt+GtlwhDi9E3FFcA0IOh0CGU
         C+WQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0zdTw7Pk4PHiRBu1JwIobk/mLD9/A+Gdxpw/EfaALSiCE6wgIZGz+aDllRuOGFbH4v254n8ktmsJP0A==@vger.kernel.org, AJvYcCWoKNkxtbVdX4Ejv5Fqr+k06XxJrT/cUfR6xhzyAzC06ehJiPboh4zztqNZvOf+/N1lRbax0EDZb/09ZL0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyra+Fppc3bbUMPtbyEyHINh/rJE+6x5zgwtIPiySSJ79gPeDSy
	ElsGAQzPVcv2/YhKeJrxeYrY78+TG0LpCT65M5Wr8QaQeLp/Ke8J
X-Gm-Gg: ASbGncudqToUSbQQkZ5WrC5Oy0InGgqQVVl+4TI0Lzbp2xiJgurH0pw7MVDMzY1VjFw
	iAarJZJ4Wid/Pb3kd65LxP6wxKfjuimqGM6hlhBuih0ARRzr5QDJjyPumnVh9vJJBtz2fZswC4j
	L8X7n1rjMI7hukBKjjQ1lVaXnDodpu+lhuiE++l0aGsFlHsT7qcMSsfpmv3j+Nqx7qM3n577Jlq
	M3hGPeh0ZRg/TJmGiX2GC21Xc6y62SSeoTejf8wUexR54A4PhNQHgp4PBbRrJRPNn3TGuXQxPoh
	iZpmfQvCHGU1LV33d1zLK9cc7jtjCtQcRZRenUQ1uhjZ4lU=
X-Google-Smtp-Source: AGHT+IEorkdXayPImRPZQsK1R9xIBDq7GWAblWS2lMHO3O/4fE4WLPdorUwZSgvvZskGaZ02RyApBg==
X-Received: by 2002:a05:600c:3546:b0:43b:cc73:2528 with SMTP id 5b1f17b1804b1-43c5a62a5f8mr17687435e9.20.1741343933990;
        Fri, 07 Mar 2025 02:38:53 -0800 (PST)
Received: from [10.176.235.56] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bd4352e29sm76442125e9.32.2025.03.07.02.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 02:38:53 -0800 (PST)
Message-ID: <7c6042974071699f9e5a85a4592d75a6a8c5ce4f.camel@gmail.com>
Subject: Re: [PATCH] ufs: core: bsg: Add hibern8 enter/exit to
 ufshcd_send_bsg_uic_cmd
From: Bean Huo <huobean@gmail.com>
To: Arthur Simchaev <Arthur.Simchaev@sandisk.com>, 
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "quic_mapa@quicinc.com" <quic_mapa@quicinc.com>,  "quic_cang@quicinc.com"
 <quic_cang@quicinc.com>
Cc: Avri Altman <Avri.Altman@sandisk.com>, Avi Shchislowski
	 <Avi.Shchislowski@sandisk.com>, "linux-scsi@vger.kernel.org"
	 <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	 <linux-kernel@vger.kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>
Date: Fri, 07 Mar 2025 11:38:52 +0100
In-Reply-To: <SA2PR16MB42515681881747A6B5C83352F4D52@SA2PR16MB4251.namprd16.prod.outlook.com>
References: <20250304114652.210395-1-arthur.simchaev@sandisk.com>
	 <bd2e01d8b33413655a4215221c910eaf2cdf6461.camel@gmail.com>
	 <SA2PR16MB42515681881747A6B5C83352F4D52@SA2PR16MB4251.namprd16.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2025-03-07 at 09:18 +0000, Arthur Simchaev wrote:
>=20
>=20
> > -----Original Message-----
> > From: Bean Huo <huobean@gmail.com>
> > Sent: Thursday, March 6, 2025 2:50 PM
> > To: Arthur Simchaev <Arthur.Simchaev@sandisk.com>;
> > martin.petersen@oracle.com; quic_mapa@quicinc.com;
> > quic_cang@quicinc.com
> > Cc: Avri Altman <Avri.Altman@sandisk.com>; Avi Shchislowski
> > <Avi.Shchislowski@sandisk.com>; linux-scsi@vger.kernel.org; linux-
> > kernel@vger.kernel.org; bvanassche@acm.org
> > Subject: Re: [PATCH] ufs: core: bsg: Add hibern8 enter/exit to
> > ufshcd_send_bsg_uic_cmd
> >=20
> >=20
> > Arthur,
> >=20
> > At present, we lack a user-space tool to initiate eye monitor
> > measurements.
> > Additionally, opening a channel for users in user land to send MP
> > commands
> > seems unsafe.
> >=20
> >=20
> > Kind regards,
> > Bean
> >=20
>=20
> Hi Bean.
>=20
> Actually,=C2=A0 the EOM tool was published two months ago
> See the mail from Can Guo. The patch simply extends the UIC debugging
> functionality from user space.
> I think it is quite safe to use hibern8 functionality for debugging
> purposes.
>=20
> Regards
> Arthur

Great, we will work on that.

Kind regards,
Bean
