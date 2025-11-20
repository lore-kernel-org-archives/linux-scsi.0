Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C89726F443
	for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2025 09:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763629711; cv=none; b=AfrER+eU0bpuQHyVUOaW9Vc+mmu+Ej9ybEPJq5DbOKssBrveah2huMrXWk3XjojA7aqqkFWbz8Mhm+3Xelg74R6IHV3biZ4EJ8w2xN+kgAVwAayHYK34cIbLjWsPcsiz1PPOS/c8/jl8HSBnaSZdv/D/EyBXtWt+Tcs8O1FI8oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763629711; c=relaxed/simple;
	bh=eyQb0OQx4Jq7025hJfTWI+V7tM5jYI/LFg1BSsjGUp8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=juuyMIjuZsKPquCp8ZKr4peruCqu+RbL+8QVS7kROaaqTpUujHJxuq2xm76YLcZ+73NyZhgpqFod3NNaXqJp71ILUgLvMcuYFcdGr+e2uEH93cOI3Oa3Cn9cmr3aCYlhdoxm2pUP2m43emDY+kXMKKpgQ+jUDAyLmrVLS2MI03Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MsSViTvi; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MsSViTvi"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-378e8d10494so7346811fa.2
        for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2025 01:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763629708; x=1764234508; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1SZCTZl4MLLKslzoxHMxHg9b0MyJf+eMQyq3HbJr2Ps=;
        b=MsSViTvi/iFrdqZ7Z/J5tqfJNpAuNUvhSuvCf8RAKZfeM7CNOVvMmu1PKJL6unzt2V
         1AaGQv6wrNmDJenlEv3KCmt5A9xIqpq1Vh0IkR+x7gGhIi6MIsFN4hMlSVj7OMfSS6NI
         /TM1sPIcGDbUQ5Y3ynLOhVR3PRsZ66GsILfo2JCB4ki5H4pJr35DCArXbvjDWpFarEGC
         M3uJipuyvzF06HULiA2DYSVrQFfGoQcgMMRRvTKnbFFWEpz4o56Mk8hVcFK/g6bZLji2
         GEcXxYrcSNufvdexfm/2llm0VYf/OVDn1PgZfUaEBOPHIXH5xFo2t2XK6uYjHUbGUcn8
         z7+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763629708; x=1764234508;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1SZCTZl4MLLKslzoxHMxHg9b0MyJf+eMQyq3HbJr2Ps=;
        b=EtN1oDL8kddQthBYD6KAL0obIEC7590ukvjDCgDmDTGb4lz5m+TU6KcPHLPL4PRKE1
         q0xIIC1axZRwHQCf2SnT5o7mpxIzZ+oZJnCRzp/cefai3wgTx7tLpLhfOGYkEwJ1Fhqi
         +PNsAIJL2ymmfj9WQQAZ36dqWY9KK7rYV/TXE148GfY29KGOjvZ3rQWQY+pKURYxIrew
         IusOsc9bSePmwdQaUxqqDLKlWQ9AaA3/7PSgrak7qbPH7lJWKWSzT6gNVwjKvpLhFvB8
         /cBa3R46EzV19BNdJrRo8rRKfzJM8FOlJIrZgMI7pypJONSq7pHcyglcdSSopf2HBEm1
         DU9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUtA7yF5Fci0chwTlRj9Uqd/UcLxOQYHFKvxpZbvdx2GzC/G0Iv/M94tUhzimZ5sZqD+nRO4fFsBOZh@vger.kernel.org
X-Gm-Message-State: AOJu0YyxDn5qtHoMeHGM1VQRIFcPA7fuRou7yio9mnB3vXBPzuRlYZvX
	OIx4+Be2TFXmJlHg4mrmciRtJmC1odvNN64vmpA2DUoOv9pctN6yW1WaQH4K3zMPkKNzXiDQYlu
	4JJb8YxlVfWCi7UjP9Timcw7CIZwZX3ejWslp4PAGOQ==
X-Gm-Gg: ASbGncvhZ9TFvCwgEPdIBGLXRGSrM2ahqvZ0Kg5UyfzpbV7pkMvgNcmpuDT425ff7BR
	VL36Nz57+17dpBauF4Lam6nCdU17+R/8mLJRnEZS4LyU0qFHQXYONH9t/VD0NLRiBdYSgcrp+U7
	Ll9W69Nn6VNSF8mLpBNsyt7MY9qQFn+KHypfLRGwvHYIMplZPN8ZnGZP2/bgXPKwqCxv3WCO1XY
	M0AsUmwDakNU2SD2zUO7o4OCFSnpKtz7Bjb1LhaxejXIpSl4LynYsrVVfqBmN1+kj31Z3cgdDfV
	Kj2rUkuBJ+5V/TpsyOxRZg5XCajh
X-Google-Smtp-Source: AGHT+IFaVyEZSaGIDLvq9kPBBSG6dx+e6XQmLPE9j6kNQcCnLWCb5LZQlhbxnXaZdk6upXDCpZhweL6cx7N3/g3fbRk=
X-Received: by 2002:a05:6512:3a95:b0:578:75b3:4326 with SMTP id
 2adb3069b0e04-5969e2fca36mr772108e87.29.1763629708216; Thu, 20 Nov 2025
 01:08:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251107141458.225119-1-marco.crivellari@suse.com> <176357169048.3229299.14597102223382788221.b4-ty@oracle.com>
In-Reply-To: <176357169048.3229299.14597102223382788221.b4-ty@oracle.com>
From: Marco Crivellari <marco.crivellari@suse.com>
Date: Thu, 20 Nov 2025 10:08:17 +0100
X-Gm-Features: AWmQ_bmkYHDieZCdzlSPGC40OaxxL210AU24gkKtOEO2cwcB3qj3J27J4Mg7nt4
Message-ID: <CAAofZF7G1A2d5ShUSQbu9rn-L3XKNveULojhpyuFMnqY4=oR8w@mail.gmail.com>
Subject: Re: [PATCH] scsi: message: fusion: add WQ_PERCPU to alloc_workqueue users
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, 
	linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Michal Hocko <mhocko@suse.com>, 
	Sathya Prakash <sathya.prakash@broadcom.com>, 
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 20, 2025 at 5:16=E2=80=AFAM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> On Fri, 07 Nov 2025 15:14:58 +0100, Marco Crivellari wrote:
>
> > Currently if a user enqueues a work item using schedule_delayed_work() =
the
> > used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
> > WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies t=
o
> > schedule_work() that is using system_wq and queue_work(), that makes us=
e
> > again of WORK_CPU_UNBOUND.
> > This lack of consistency cannot be addressed without refactoring the AP=
I.
> >
> > [...]
>
> Applied to 6.19/scsi-queue, thanks!
>
> [1/1] scsi: message: fusion: add WQ_PERCPU to alloc_workqueue users
>       https://git.kernel.org/mkp/scsi/c/f0dc44177ac0
>
> --
> Martin K. Petersen

Many thanks also for all the other patches / series, Martin!

--=20

Marco Crivellari

L3 Support Engineer, Technology & Product
