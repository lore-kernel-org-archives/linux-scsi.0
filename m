Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2108C1B8EAE
	for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2024 20:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724963009; cv=none; b=mXi+op/IoLmix931Z7Hae6ohxeAhYbRL4rVMhx+R9HS/XawrymyTQ75QEkEqxiq8ZurYluoIilvLSprf2IuErJHAHIOhfl3ig9BsfRxQT2IcCkjYNWIG/Ky6PE5ArugwfdjXLNR6lEsyVryhmyf0t2v0NhYvOBzj+7ntx07UJOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724963009; c=relaxed/simple;
	bh=Iv0nram+hMde9A6+V/Nhy4IAnUZ/iQZXPvpsf4ATybU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tigpnYquLaaOcsFNZZdgb3lbE0ceBNacjewosnT6vdwCaKD2jvZrzZSS5CCA/qBIGuclpnZC7MkVdXxVIGYSfZHwx0W3w5eDcqt8BUMa8gOPT1ehkrkis/PclgYUQ1mtwL7rP5YtKCRM+ghRwqJ+RaLQhYtMETsb7WKRFZ6UFwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xpK0YSf0; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xpK0YSf0"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-202018541afso13085ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2024 13:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724963007; x=1725567807; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Iv0nram+hMde9A6+V/Nhy4IAnUZ/iQZXPvpsf4ATybU=;
        b=xpK0YSf06ZDts+8Lvjrzs6kse2zAs1odgSbF9n0R7MMxVK5iXnQ/1fEQiX4WWrLrme
         keHJsRhLpXy8sBh2/0DtrYErfWSdFCZRERVpHYiQdKR1aHc+DTVnDVEahVDznJDJQUo6
         c2+FN1h1YXFHJHhtiC0NRoYlMmJUYtkcS9ZHP4Q4ZnJ72mF/3I8MfVHrW6IBe8UAJlkX
         t2RXSO3WAfb8X+dNnVImVk6HSMggS4+ZSpX4ryV93QIkVI0I2BW4CNl/jk1jkVVH6TgC
         hP2orxkg63XkbMhofs5hudJaITMi5K/KtucGRiWqzryOJl3jTXt/DR1SmkA61aam+hVa
         e4mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724963007; x=1725567807;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Iv0nram+hMde9A6+V/Nhy4IAnUZ/iQZXPvpsf4ATybU=;
        b=Ie6TXguGrEEv4ZmE3mJmDzW1+5B/UsiXWIEqRlbpoILTtV1ekvqgr2tY5X6iSgSym+
         DJ0WGl3YFNTG44IkArdm1/Nt7dyCkyJA2v5GdgucGJ2wbjK0nsbTwlWv5QbO26PmjsNC
         /c/VhwgGL4JfnAfPBfaCnDxU85Au4DF5/ucqUDWr26ceFCPSmGOeTqDqgEyBoJi1O0Ou
         KCEZZGClEa7y0+CP0Cu57nvLSZiyDZ9c1USVjY62S2nofVxuw+/5UrN35079i8LvOdM2
         JgKuzh+Mq14Ufov1U1CdnZgH2Jbv7tDzDjeeo6ekSPvcF5l1ZlqpYZmIOzxAyJLK131E
         QXyg==
X-Forwarded-Encrypted: i=1; AJvYcCUstFZG7Cp3QVdEaOVIKdaOejMdwGhWsgASvpyzwv9HO6lY9zd0p24KnLOYkzmXWjwHrIbx7r98x0/b@vger.kernel.org
X-Gm-Message-State: AOJu0YwsWBAN2f4AWgd01jZomj0Z4e9ZxWj1JZrkzFExmbDLg9h2bpFx
	bzsNZTaOswJXoqbh5PdpHwkCzouC71ok0jJoInAxeLrfJJ2xWDFthPfOzV0Pwy11GDnt6JiUBiX
	k6C3mPCbJY0oSa5jkZsjCWGPSqcBzrcWWnPKp
X-Google-Smtp-Source: AGHT+IGBH5Hs5IwU/+WhvREPe+6gjLlNZ0hPKyvj2VhSl+HfN9Vj0g5NCglCep91U8aw0jgzQy4XJ/V0IeT07QGzPvw=
X-Received: by 2002:a17:902:e892:b0:201:dc7b:a882 with SMTP id
 d9443c01a7336-20523b3ee98mr651105ad.26.1724963006843; Thu, 29 Aug 2024
 13:23:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANikGpf0OmGMSkksH_ihW9_yXVAL25xKD4CBy8d1gpKj0inPjQ@mail.gmail.com>
In-Reply-To: <CANikGpf0OmGMSkksH_ihW9_yXVAL25xKD4CBy8d1gpKj0inPjQ@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Thu, 29 Aug 2024 22:22:49 +0200
Message-ID: <CAG48ez3b-FCz7+4MH=CmhbhmSfTT4FTrDAJfbL5UvufRut7ixg@mail.gmail.com>
Subject: Re: BUG: kernel panic: corrupted stack end in worker_thread
To: Juefei Pu <juefei.pu@email.ucr.edu>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yu Hao <yhao016@ucr.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 28, 2024 at 1:49=E2=80=AFAM Juefei Pu <juefei.pu@email.ucr.edu>=
 wrote:
> Hello,
> We found the following issue using syzkaller on Linux v6.10.
> The PoC generated by Syzkaller can have the kernel panic.
> The full report including the Syzkaller reproducer:
> https://gist.github.com/TomAPU/a96f6ccff8be688eb2870a71ef4d035d
>
> The brief report is below:
>
> Syzkaller hit 'kernel panic: corrupted stack end in worker_thread' bug.
>
> Kernel panic - not syncing: corrupted stack end detected inside scheduler

I assume you're fuzzing without CONFIG_VMAP_STACK? Please make sure to
set CONFIG_VMAP_STACK=3Dy in your kernel config, that will give much
better diagnostics when you hit a stack overrun like this, instead of
causing random corruption and running into the corrupted stack end
detection.

(Note that if you're using KASAN, you have to enable
CONFIG_KASAN_VMALLOC in order for CONFIG_VMAP_STACK to work.)
