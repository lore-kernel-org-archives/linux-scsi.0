Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C5556B78
	for <linux-scsi@vger.kernel.org>; Fri, 22 Mar 2024 20:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711139684; cv=none; b=k3qefm0087fGenr2yjiqr//fBZMfw8JOgitUhEKr8r7tuMY+wjKMSr+uLj2LtLYegBiQ/ycoU7k+xXO7aeTfJsMlglaYmiEnx4v1R/cJT8tEUqRY+kkyvYmsppFCsGcJ7iodClHzskX//BFdCYwJlLSgrqDpjPpltxSqED/6QpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711139684; c=relaxed/simple;
	bh=XjWgDhwAnyLOFEQHOgQQXXRRn46n/ix293GOySxitgs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Yo7Ef0GAjIoRwkAihRQDkbaDLrcZhaywJ/FUqCHoy4KLHQtOuA1YUV68+IU6m2JptMeqImPrjQVH7GaBZt3Ti/XQdmqzu6JaxW/HQ0AGzr11HoXCOyVlZeOSR877BYt0bhfFdqvNaEGP8ETQN4WMK4rbKpU2bwIMZiLP3uhQcDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DJIxiwk3; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DJIxiwk3"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-55a179f5fa1so3545361a12.0
        for <linux-scsi@vger.kernel.org>; Fri, 22 Mar 2024 13:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1711139681; x=1711744481; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=60APz7zYnkhGexsbPEuUDopr5dRjcEm9AN80VhOLeZA=;
        b=DJIxiwk3pgLdaMx6qqvI7vzMHugQ9GuzIhT2PZj6kRzCIYUHXMnzW3T2vszEruH3wT
         WBOZswtLtpk4pROjNi5qzCaTUiRMU2PFKQ0lQPOgF7RBFQSY6ylnY0FlKUhjhBYY0qN3
         5lobyXHBYXU5w2VyVzLFN343bYYmFmPm7h/lM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711139681; x=1711744481;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=60APz7zYnkhGexsbPEuUDopr5dRjcEm9AN80VhOLeZA=;
        b=Q+nSomQcsxRGdxT7iNN5ytijjwAEz9CASdpsGp7wgvL+/SV7ru2c4D9FPiq7LzrFTS
         LxqTSaeG05ke1OCRbTcDaRdpZq/rBMgOglTyHlcjQOlORpfYP4Cbjsda6iNp0Exn2e2B
         XS9FZBPFaEPdWw+HTHi0LHkZHUIs750hHhMVtxwggCcpaxjd/Xag7amSPuMt5jCIhYJ6
         THg21xM3zUPGB0IxZlfVJGJAaRx+ViOVuSLQs2wQwfK5CSc6Xp0tmM0mABB8XmCcjJFY
         nzdTLC/hFvbAQgkLXZ05F4a271Pbt+vcOFk8zYQZ+UGUNOfyBcG9nay7SOcPWPahNkL3
         UyRA==
X-Forwarded-Encrypted: i=1; AJvYcCXpgkgkmp1N+JbRXCSHDBfT2wGhg63B2IuqyeyrcsjkWwvZJH9Y1U50rLt7jkHenczoHmA8eKACF2m8IL8UveeGrIrEFXCFtaIN8Q==
X-Gm-Message-State: AOJu0YzvSCo4V/ReddSiC+yff0uPD1PCRbeRNpEEPi0VjSYMelPE/K8n
	pSk1Zyh4FlxewU9eYiqeGBO5MH/IdSOCA9SZVKJPMZwqwiW3MTfoBaSJfXosazaYFppqZwr4dG1
	iUrQ=
X-Google-Smtp-Source: AGHT+IFPD8exVz/a0HTyu2ktc0NeO6do/qu0Ulgda5h7tkaUP+fhQ+CWWmT4jsRh3TGlWQY/RT8iXg==
X-Received: by 2002:a50:9f44:0:b0:568:d55c:1bb3 with SMTP id b62-20020a509f44000000b00568d55c1bb3mr490635edf.31.1711139680652;
        Fri, 22 Mar 2024 13:34:40 -0700 (PDT)
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com. [209.85.218.48])
        by smtp.gmail.com with ESMTPSA id d12-20020a50fe8c000000b0056a033fa007sm177414edt.64.2024.03.22.13.34.40
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Mar 2024 13:34:40 -0700 (PDT)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a45f257b81fso314487466b.0
        for <linux-scsi@vger.kernel.org>; Fri, 22 Mar 2024 13:34:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVdPPQjOiW+TqezzB60n14OhcQ8mmdD8a1FoWkYcNx2A36mB9WCuS3MWyXfrPPAFSZgV0BYR2RfNgygo67rjFLWdfX9ViIjJ0zSVQ==
X-Received: by 2002:a17:906:5288:b0:a46:13d5:46fe with SMTP id
 c8-20020a170906528800b00a4613d546femr621763ejm.11.1711139679859; Fri, 22 Mar
 2024 13:34:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <3b789eacddd6265921be9da6e15257908f29b186.camel@HansenPartnership.com>
 <CAHk-=wg9pvT5YEo_kGo2QGjbC-eRaaQNOZuJYCsM1zaxj+rnug@mail.gmail.com> <3b5f3404bc63d59f4093e02c2cbb426a88d0bc70.camel@HansenPartnership.com>
In-Reply-To: <3b5f3404bc63d59f4093e02c2cbb426a88d0bc70.camel@HansenPartnership.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 22 Mar 2024 13:34:23 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj-d9pPn00m0v3K3rHD+O=oZV-JvX-Y4aZ9jKMdEq2Rtg@mail.gmail.com>
Message-ID: <CAHk-=wj-d9pPn00m0v3K3rHD+O=oZV-JvX-Y4aZ9jKMdEq2Rtg@mail.gmail.com>
Subject: Re: [GIT PULL] SCSI postmerge updates for the 6.8+ merge window
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 22 Mar 2024 at 13:24, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> OK, try this (I've updated the scsi-misc tag with it as well)

Well there we go. I really had no idea what the pull was supposed to do.

And while I end up looking at individual commits for random smaller
subsystems when it's unclear (sometimes just for language barrier
issues), for long-time maintainers of bigger stuff I kind of expect
better.

           Linus
