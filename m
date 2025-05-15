Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595AA1F2C56
	for <linux-scsi@vger.kernel.org>; Thu, 15 May 2025 20:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747339415; cv=none; b=f0xvS/ZbgMZ3bKQVLox53CQ897qbRiANSpNx3ic485CjuFUMyjQJkoQ/FzBWkq0OILy7QwMAfKnqNbBqre+kxVTZEEcUxjh03bJ92wL15x1Fe+uzsgyaMWj7rkg/OE13fM4uMf0xOJwXiFHHq2ErHoAkzviw0kEaOHdoAu3yA20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747339415; c=relaxed/simple;
	bh=sCWBCil7pb7kxTCcpgTJG5V5Xzq7C7Xue3LLDzZUlhQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lDqmprrq7sVWq4LPJVzxRR8ZO6zOjIl922eIT8+n82hVg+DarSFLniquolcf7bChnh29qtljbkr6hv+C4TNA1hqfPhBQB4AGDbGX/6MY2O+ou7bo7PqJAuEJTrrlOWGDx542HuJp3NVxpJ1Q5cGEl2ichkSwoWYqdB4t5jTxJ10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EupDt8b+; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EupDt8b+"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-47e9fea29easo11791cf.1
        for <linux-scsi@vger.kernel.org>; Thu, 15 May 2025 13:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747339413; x=1747944213; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sCWBCil7pb7kxTCcpgTJG5V5Xzq7C7Xue3LLDzZUlhQ=;
        b=EupDt8b+8EhCuuCJHf3v9NzWC/r6/x5Bv20CX/UVoggqgmAd59lGNkNtlcDD1evkAZ
         X8R7pQ4qWzKH9bDUkezAZ9pskVLHs8s8q6qA39UrQ8bQgyQhAlDbkrtP9I85bHOX/YGo
         WiEnCk8UPm+7YuEQCF+9gGNND5lvFKCTASNFVZtmmm+YEECekJ8aiWBREsAlms1XG39k
         /RfXxWaER/KN5ERBWt+EQ+QD7sHc47AxwIFk00zq2lC68esKWXojw9EdLe5xgFZxEu66
         0ym1ypwZV6v4mkYzaQWeeF5bqHzIlUTAvFy0ite+tOjK9T6HXRZVSN2JL/hzVMHmlGfQ
         2Arg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747339413; x=1747944213;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sCWBCil7pb7kxTCcpgTJG5V5Xzq7C7Xue3LLDzZUlhQ=;
        b=LWGm1yZ+1Y1KKSCJvm9NVTM95tkXTo48ynh503/6snf/bRRixk/BswynJ43Dg7jY1v
         buf4C0cbIngrDU5mtAEU3sq0ndha1lxbGLLP5IUEIEv2hT8A2jDkGwzI5fdSk57zHEED
         E7QOrphJlHlsKfG3NocRLalK2wNn18Q4MNvYlN86BHf6vet2YbcNJ0NV4VQ7MUO9RRP8
         WfD8d6erhLhM0L2v5u4co/94sz/ineCmHY22IZFYWuZoYkopnD0hatARpTVrbOCHIvpg
         SBYGaLxL6u/XQiGDfsdG73l7j4xgxdjbB3wPdddZOcvNrE9HFYNWi2fFpdhZEINzCzIj
         z++Q==
X-Forwarded-Encrypted: i=1; AJvYcCXSA/3FhMCnXzEv6Y1q0ersGfYXij0ReOkgu61TI5StWNwpQokJt3/nidCyi8vkCthTxL7r2BlQbhZZ@vger.kernel.org
X-Gm-Message-State: AOJu0YwvyKBKl++4N/QRSzH4OzvRjOUz3NhIUiu9n6vM3pTh5n3o+tfj
	KpQljusgwaakLaeySHoa81lS/44HHtuA+Zp3ITd21md1CpnkqyejiWKRLpugg4EFreq+E6ifssH
	WeghMeQF/8EXivF83iIJqA6xoTDWp6JKmgs3+rHJ6
X-Gm-Gg: ASbGncsUSDp0W07lDuh98yyYWD+PyOll8t8BlnolE+3BlKL3TUOq0VI/ipv3D/NTUWH
	HFhI6H2h0DMcPJBjrHiQ3GTQKx61oaaykoVyscguzC3rxXTixsMNX7wsVThQ0Z0rtL412mc+tgp
	QNN0W2FNmEJhGuQMSVOIOG51rhMDfehslLajloZ4DfV2Fim4xsjN4njLn8wCgZ
X-Google-Smtp-Source: AGHT+IFx+em8XfEeGLyD7f/98BnU3d6CKECWGW3OqkghqanJcCJmF9byttNgyRFlCJsaVOHAdBjfs+z3bGSZBoxwJn8=
X-Received: by 2002:ac8:7c4c:0:b0:486:a185:2b8f with SMTP id
 d75a77b69052e-494a1cff1afmr6072521cf.8.1747339412843; Thu, 15 May 2025
 13:03:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250422181729.2792081-1-salomondush@google.com>
 <CAPE3x14-Tsm-2ThihT3a=h9a0L9Vi8J4BbiZiTV6=6Ctc1xryg@mail.gmail.com> <18aa42a73584fcf50b07d7a43073e55fb4c3159b.camel@HansenPartnership.com>
In-Reply-To: <18aa42a73584fcf50b07d7a43073e55fb4c3159b.camel@HansenPartnership.com>
From: Salomon Dushimirimana <salomondush@google.com>
Date: Thu, 15 May 2025 13:03:22 -0700
X-Gm-Features: AX0GCFsCV1sb00fFgZAMaeeyCnu0EqKHlroVAnK-IBJHOTTo1bvieTMgGMV1pvU
Message-ID: <CAPE3x16MrkQXFasVaaHBxhH2QvQ4H5cDiE3ae=-nYjuEKV-NBw@mail.gmail.com>
Subject: Re: [PATCH] scsi: Add SCSI error events, sent as kobject uevents by mid-layer
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I agree with the recommended use of ftrace or blktrace for tracing.
However, our primary goal for using uevents was not merely for
collecting trace information. We are using uevents as a notification
mechanism for userspace workflows to determine repair workflows (swap
/ remove a failing device).

We are open to any feedback on other notification recommendations for
such use cases.




Salomon Dushimirimana

On Tue, May 13, 2025 at 1:27=E2=80=AFPM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> On Tue, 2025-05-13 at 12:00 -0700, Salomon Dushimirimana wrote:
> > Hi James and Martin
> >
> > I wanted to follow up on this patch! It's a decently sized patch, so
> > it might take some time, but I'd love to hear your thoughts and
> > address any feedback!!
>
> I think the first fundamental question should be why is this a uevent?
> It looks like what you're obtaining is really tracing information on
> the retry and we could simply add it as another tracepoint in the
> existing blktrace infrastructure SCSI already has.
>
> Regards,
>
> James
>
