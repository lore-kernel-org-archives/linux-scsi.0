Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EAC13173D
	for <linux-scsi@vger.kernel.org>; Thu, 25 Jan 2024 17:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706205430; cv=none; b=qKCIpERkQ1QIrQcCRkThvB2+s3TWQsV7K/Loh6YPzHt5MFD2DzUxAMHc8qyb2eWsJEmdXkYEPPeH+9GU5jkKmtPK1BPJTACADu7VeTFQ475vqrM6z/Md3a6u/jXwVRrqJVLUzIVRg6xmdlTSQ6LgaX0ZyL7ElW9FZxJwniOJoCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706205430; c=relaxed/simple;
	bh=x+h0NA5KQ56CuKCqcdtm3IG2B55TnTudmen4P3ZAVqE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dmJeYPKl9Wk6S9bszshyMQRr3D0TW6589r0Pt5f2ztkWjsqrGf42NH96Mwv+v8/weo2Sry2E65aGrEEn3fhiPICDQry7nk84oSjkQFwj8j+umnrRfIMubqxGkzAKjn7McYHnkXR4YU2hjGAMsLIwZckPV4z1sDnm22wn7fl+Yes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AKcQG18R; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AKcQG18R"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2cf328885b4so13584201fa.3
        for <linux-scsi@vger.kernel.org>; Thu, 25 Jan 2024 09:57:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1706205426; x=1706810226; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=a4MukQAgLIZe1lZaeonltfVtZCZSFGzNFrTBHeprDAs=;
        b=AKcQG18Ral8icAIng4Ahr+YagRQRtCJE5FiZimEVIM1WIYWjTqPH7Em6tJJDmqYj1Y
         /MD6j5uZ6S4GXNntMOR6UMXQxftVmD7KGlvcRRY5X3mC5vtNTta0jEo2Jvl1u5XbvvvB
         mjUKbfHi3p5hEd7fTUtz/kDL/jj8foFHQg4dI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706205426; x=1706810226;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a4MukQAgLIZe1lZaeonltfVtZCZSFGzNFrTBHeprDAs=;
        b=lPAHpYoBfTWTA4xYk/lasfZHK6uSFc7FuSI2LTU65YyvO19mjCcPH1UTzQHwr5PV/v
         1sKJadd4i9ccXwAuTGyqqah2yxsMdFBgr3f+KIkB83OIY9yAW3Ul67ff2LOhLyRU4Dx5
         UAL5geC/2oDNL2pRf7B0BDrGPOUsc74oDfs1Uap7GU10glYAGowSxqRcwU0eJOpxJc8A
         e2SMcfqvWPmLuKGEoTjfGnM2YQMDvmPdjxfJc1ueVEhMtPiEUUMjqLxSBkxQby44ppht
         cUgJU/WLBEzC7n9PYBoM/WG/qnXYDn1nBFZPL+w4p405wHITTH0dQkTglHYhuhc7PWPw
         t4ug==
X-Gm-Message-State: AOJu0YzgxP/FJOKJxK6FVrpYOk6l4tzNBRD4AufcAwTOjS47Y1xlL3mD
	5C6rLyhLENEiKXo17FzMMnUGLsnnvJy/isqFWGMoFhgXnPxUuMWUEt2XHEs66zJO4O1iDqggH9T
	vuembEQ==
X-Google-Smtp-Source: AGHT+IF39B5Q7q88ufoLpmTHGleprlAfHc+BrJxYvTt6sjCbpJD7v/jcJxVJjolwd5UoOXANgaaF1A==
X-Received: by 2002:a2e:948b:0:b0:2cd:7048:8852 with SMTP id c11-20020a2e948b000000b002cd70488852mr22590ljh.82.1706205426611;
        Thu, 25 Jan 2024 09:57:06 -0800 (PST)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id s13-20020a2e98cd000000b002cf20f5500dsm342727ljj.121.2024.01.25.09.57.06
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jan 2024 09:57:06 -0800 (PST)
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5101ae8ac40so1398256e87.3
        for <linux-scsi@vger.kernel.org>; Thu, 25 Jan 2024 09:57:06 -0800 (PST)
X-Received: by 2002:ac2:491d:0:b0:510:58:5954 with SMTP id n29-20020ac2491d000000b0051000585954mr91552lfi.80.1706205425541;
 Thu, 25 Jan 2024 09:57:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <d2ce7bc75cadd3d39858c02f7f6f0b4286e6319b.camel@HansenPartnership.com>
 <CAHk-=wi8-9BCn+KxwtwrZ0g=Xpjin_D3p8ZYoT+4n2hvNeCh+w@mail.gmail.com>
 <7b104abd42691c3e3720ca6667f5e52d75ab6a92.camel@HansenPartnership.com>
 <CAHk-=wi03SZ4Yn9FRRsxnMv1ED5Qw25Bk9-+ofZVMYEDarHtHQ@mail.gmail.com>
 <20240121063038.GA1452899@mit.edu> <CAHk-=whhvPKxpRrZPOnjiKPVqWYC3OVKdGy5Z3joEk4vjbTh6Q@mail.gmail.com>
 <20240124053634.GD1452899@mit.edu>
In-Reply-To: <20240124053634.GD1452899@mit.edu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 25 Jan 2024 09:56:49 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj3tK4ync2S2eBQagOYv06wU+e7jgmnWHk5ZQBbk0E2WA@mail.gmail.com>
Message-ID: <CAHk-=wj3tK4ync2S2eBQagOYv06wU+e7jgmnWHk5ZQBbk0E2WA@mail.gmail.com>
Subject: Re: [GIT PULL] final round of SCSI updates for the 6.7+ merge window
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>, G@mit.edu, 
	James Bottomley <James.Bottomley@hansenpartnership.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 23 Jan 2024 at 21:36, Theodore Ts'o <tytso@mit.edu> wrote:
>
> If we told those people who wantg to pursue key rotation to just
> always upload keys to the Kernel keyring [..]

As long as the keys exist in the kernel.org keyring, it's all good.

That said, I still claim that nobody has *ever* had a valid and
meaningful reason to have expiry dates, so I want to stop you right
there when you talk about "people who want to pursue key rotation".

The absolute *first* thing you should tell those people is "Why? Don't
bother, it's just added pain for no gain".

It's like revocation keys. To a very close approximation, never in the
history of the universe have they been useful and meaningful.

The fact that the keyservers don't even work any more have made them
even less so, since now the revocations will never really spread
anyway.

So no. Let's not encourage people to do this silly thing.

If you ABSOLUTELY HAVE TO have expiration dates and other silly games,
yes, I will complain if I can't then easily get your key from the
single reliably working remaining setup.

But if you cannot explain exactly why you absolutely need to do it and
have some external entity that forces you to do silly things ("Your
daughter has been kidnapped, and you're not Liam Neeson"), the answer
should not be "remember to update the key at kernel.org", but simply a
plain "DON'T".

               Linus
