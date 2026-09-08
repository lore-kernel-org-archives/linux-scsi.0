Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CA23126B2
	for <linux-scsi@vger.kernel.org>; Tue,  8 Sep 2026 01:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788831294; cv=pass; b=TTP++nk80hqxB6Gp6LSMoi8fKh1rQZDV9z7i5L4aygF/3AKIXV5ppH4fF2cGj+Ezi6FAsx0N+n8wB4yP+Rz6BmQky97SrLzZ0Ln8VJcXZ/fqhUtIoY9upQcmc/4MF0xAc2QIqeg3xoYWieGS3IzsAPrO6HiD7yEEvQdiS6YA340=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788831294; c=relaxed/simple;
	bh=C8sk1qEEBHqvgTdmahyfxl6izzwTI6I+XEK6unrL7yQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZhOWyW104TlKJcDdrR71l5ZO2+jBvCtWVBNz161J4QwNdXDI+f/BW8HdwzUPHIWkGpcnOl1rqyMhIonyUDuJd6hQSMPfIiZvwqExyn+DECJ7zV54lXgs8zT5L9tugtt92FoBD7xNWudl6B42zbOEMlP56rHhja95X2MWdaTXfWI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DymFgwAO; arc=pass smtp.client-ip=74.125.230.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DymFgwAO"
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-530411c7ee1so422811cf.0
        for <linux-scsi@vger.kernel.org>; Mon, 07 Sep 2026 18:34:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788831290; cv=none;
        d=google.com; s=arc-20260327;
        b=IIrC8TNh5EzEN7Swj6OKYXZRTU/4uaFNMlh/H0LLLDYRRi2J6dyACd7TqH/Rq8KwPK
         zoVAQo1kmTNT6xrxEBYzXtM4moyRK4UMruSTquI4Wx88x5ikblKzqQrGsXgLJMvLNFDQ
         eZ2wUrjJwaolfReNoLVG7M3Df/7ohGPrOFXmJy+syqRsmzJBzG5/M47/Oj3sE3xxDdLQ
         F5Ij4J2X0/ElhaJpseBlcmuXyI1EXqEEMWVs4nJe8Nqut0gkWDAvWXsxbLwVB/Nxjro3
         X14bZ25GEh7R7YCt+q2WZNsDHijf/BqAj95KE1D23DnE9GIAj+xbuz/zuoNmcBBWKPhK
         XBGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=YQzs+TvnkG8jX4qlU9/TEe5EeymKa8IftTGzTEUV4Yk=;
        fh=hJ24zjeHQqN8qsLrhEHmcXNpAGpYwss3a0dyAQzAwMU=;
        b=lyBbDSwVr6JR21+XqdgQsUMeor/0xumzp4gELdmSRn8+/iuOnRiI4WW0gzXaR5PIEt
         giZqPqHoCkJ6hl6FGbfBRgvgCaHEvdVgnZ1wKXZYruPlFdbXmB0IVRIuPIEc4/f+c/JF
         LfubKierH4adCw9VixWmZ2uqAOzLW51tRT4oi22IbrBj29QWUZopr2Xvufhgyjk7S/Ig
         yUVQQD4UgQQ46O84a6aCd6A4STJqhC3+FIXwrUYQho6e8r08wOXUp/GRB2w91wPOwpfY
         hw/Swlp1KBVHAkgKYCmflAjF83SrDZeVOgmPgZpcV4758SJmxO1Hu4VI6O9wa4+tjb6l
         HN6g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788831290; x=1789436090; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YQzs+TvnkG8jX4qlU9/TEe5EeymKa8IftTGzTEUV4Yk=;
        b=DymFgwAOtJUFGZt5lu1Tshdi/d8zDIHmuinpeTQTNgWV0ex6voSVJR9OID1gJb8Y7m
         pcMFQ2d6JRyJJ/jIKuxmiT6A5x4sJpz0/1DDroDqCROFVYLApkyutPOJzm0AbECRKQ3e
         TgSdtFxORfU3kSpIn7tMFqtP4puzKQUM3Mk8cCYHa9dhvQ8FTKbyo9q1euOqd3UFlfL6
         83F3tGuaE/trAXkb5dSe7fQySehyEFGoTgFJD6V9sSTQZf9+yDuR3pGjbIOxf9Js87K/
         lP3NpB1LimQgUQBFafZSEOky2bs67jzN9b/dSlChv/3QLQJo4rf4/CW/b4tkg2V9uscP
         rVkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788831290; x=1789436090;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=YQzs+TvnkG8jX4qlU9/TEe5EeymKa8IftTGzTEUV4Yk=;
        b=OUeZlRitpxojS2VuWL0BamT2BffyYYyIGnbgpDAn2CAaDxHQxPQUHTSed93feXvECs
         HajmqsS8JLQad3HaEdv4iWqmjpYZaMAn5MGWdUWNQqS0XaLC7HepmMD4EWXTJi0IW/xl
         yFjvmXg+P29JlqpRH41M09fEn1k81veLFcM/TLIx7dc0i4Zm0Ekq/99glGB698THA4+D
         5kYwP2TYupWU15/5fuLNY7Ss0GGHlfDOnXWd/2epa1ikXDHgHL1IGJF0fcz/I0yFthDK
         nyc2I1ZbVNnIzqkpnlOVFYN6wFYDo87rlY4sasZ9caC0tuMba23z6pETKUeurM7gQRnK
         eQEA==
X-Forwarded-Encrypted: i=1; AKwUvBwI4M1xy4ceKSogC75rryHMcuFmafrZpCuVXLN4ZHfxpKzqIo8o5fOIV8sa4n1tCfMdjUVRgM0TtotC@vger.kernel.org
X-Gm-Message-State: AFuF++mZpxYgqqFetrGkPqgVA+UQjMbyVt1sRd/pdBnoAaHCLmnrHXWn
	NB4QeyaavZ6GmvNO3quvjuPVn14hXWyt4/M61lPodEUlaRxmCtr+JIH4wA7s70pnogWp1WR8yG9
	oFkQ1LcknhZWRR4pB3CHxR04u1AbvKt4y9QHLzDNi
X-Gm-Gg: AYBFou1tWBDZTijgsL822F8TxAq7ksDrD+MVLYe3URdpntb23ZE+AMoF9pFxI3qMe3u
	rjcytCue5f1GVUqT1/P7X/26wZboOe5dpqFka60aOxE961B6SPSBwBL0G7Cg3zDoPYDcx0TsYkj
	aoP4ozSJINbPsZ1AWMld9SrduBMEeIs2BLqncw9vinUoVQvHfpNElu3dTtSgXWPBJgIKo1dqJdd
	6/hjUS++cGCfK8EdIOgLZn2XPR/vIfvM2fzfZTTunovBIl4wHiTlQUDa1oM/rt2B5T0A0ER8TBB
	hFuzdraUBPYuDWLN24txMycOaiR4SlDlWoSfHnFCyXixcYt/S63jls54hvGjxLe6+uTYvP6tXi8
	=
X-Received: by 2002:ac8:5752:0:b0:530:5120:19da with SMTP id
 d75a77b69052e-53065d62b52mr36529551cf.2.1788831289919; Mon, 07 Sep 2026
 18:34:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260907192140.2701755-1-beanhuo@iokpp.de>
In-Reply-To: <20260907192140.2701755-1-beanhuo@iokpp.de>
From: Stanley Jhu <stanleyjhu@google.com>
Date: Tue, 8 Sep 2026 09:34:12 +0800
X-Gm-Features: AcwNN1Xobqe2_angS2HD3JLnQDpNBy1jGEuPGetaKk41wua1zBXLIX34Pe_T310
Message-ID: <CAE14pddo4ecRZLZs7XmuHtUhhcPnPphbn_AgJ-yZyzMGq=QjRQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] devfreq: check the get_cur_freq() return value and
 use it in ufshcd
To: Bean Huo <beanhuo@iokpp.de>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>, 
	Kyungmin Park <kyungmin.park@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>, 
	"Martin K . Petersen" <mkp@kernel.org>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Stanley Jhu <stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 7 Sep 2026 21:21:36 +0200, Bean Huo wrote:
> Changes since v1:
> - New patch 3, so that target_freq and devfreq's previous_freq are not 0
>   at boot (suggested by Stanley Jhu).
> - Patch 4: drop the !cur_freq check, it cannot happen any more.

Thanks for addressing the initial frequency desync in v2.

For the series:
Reviewed-by: Stanley Jhu <stanleyjhu@google.com>
