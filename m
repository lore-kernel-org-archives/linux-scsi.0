Received: from mx6.ucr.edu (mx.ucr.edu [138.23.62.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DF81B78F6
	for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2024 20:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=138.23.62.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724963351; cv=none; b=E6YRPqOxMr8hoL75zsy4Rjqm9U6F/T6WjQMc1Lc27Tq6l/U32GnGMnHj0llxkdxWrGJ6PkXXU94Phk4NzKcgqF5olpVCPVlnYfghTfa7PhZT1x4f5PcbnfqrQMFQIYrRClOq7MdigXj9uU2D1G7MzQf3VOcQwZwEvRdCzBYsg/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724963351; c=relaxed/simple;
	bh=849volckYMWkz8XfZeWLz51T1AB/VyL8ul5AhPBn++k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nSfqZx2Xo0jyyjzs6rUUcfIkst+oK8FqV8cMxujRIXHYtwig4j33vVyY8eIh2QHZQ5U5G/kD7qv7EHFPat7YzdAK5jeV1RjSSsG7pkqBp3ClXK/gXXgRXUWjnGQWA0/rCM70AZqWzCjOr+YVNChMuuUI5wCKweDgAis3oG13l8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=email.ucr.edu; spf=pass smtp.mailfrom=ucr.edu; dkim=pass (2048-bit key) header.d=ucr.edu header.i=@ucr.edu header.b=EOv/L1pE; dkim=pass (1024-bit key) header.d=ucr.edu header.i=@ucr.edu header.b=KvZwoxBm; arc=none smtp.client-ip=138.23.62.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=email.ucr.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ucr.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ucr.edu header.i=@ucr.edu header.b="EOv/L1pE";
	dkim=pass (1024-bit key) header.d=ucr.edu header.i=@ucr.edu header.b="KvZwoxBm"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1724963349; x=1756499349;
  h=dkim-signature:x-google-dkim-signature:
   x-forwarded-encrypted:x-gm-message-state:
   x-google-smtp-source:mime-version:references:in-reply-to:
   from:date:message-id:subject:to:cc:content-type:
   content-transfer-encoding:x-cse-connectionguid:
   x-cse-msgguid;
  bh=849volckYMWkz8XfZeWLz51T1AB/VyL8ul5AhPBn++k=;
  b=EOv/L1pEPvLvoEByQK2bJRoPJkfc9xvYLz4FHRAKdx79TfPHVWLPQFwF
   yHW1XfYYG6uzzVjho/k0+Gi7jeovsuslXUypi7HIRflQGmCpQkXPKAEZc
   CnfE97f99kPQ5aSqH4xNMzWgIaK+pIBth9tIgjTVIh18uF5yUdNY7LLT2
   r18L6PNmcPjKRIf5wqeT+XbD3jOgzTdt62kNyNZvd7Qlv2tdPW29gCJrl
   ZjRoKh3jH+uSnEdyGmUQyke62/6bEh1rgvE77tMryDDrUU7MQGg+GdEq8
   RuxqVQlkGCY5JKxyOUAE+Xgg9TUY7eDO4coFxF4FjcK2S8EJaiEelfRXx
   w==;
X-CSE-ConnectionGUID: vnvHJH61Szu2Mu3ztskBWA==
X-CSE-MsgGUID: sfgb8puoSkO2wDi3Gh51Bw==
Received: from mail-io1-f71.google.com ([209.85.166.71])
  by smtpmx6.ucr.edu with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 29 Aug 2024 13:29:08 -0700
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-8278114d3a5so129680439f.1
        for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2024 13:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ucr.edu; s=rmail; t=1724963347; x=1725568147; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=849volckYMWkz8XfZeWLz51T1AB/VyL8ul5AhPBn++k=;
        b=KvZwoxBmvT5XXJHfGY3dY6uENEmxpL6qscG7/gmbdNEGL/Ul8PnYN+9h2hQmioIaZ0
         0bbWWuPECVfPbthIFbwaff9cDSfTE7QZiiqZgIgSrdKbTJKYNa5BqGY9/N5j+fWOGppM
         SuzNM25u1Bhe70nK5bq9eOkmfJ8LbnGwUX888=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724963347; x=1725568147;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=849volckYMWkz8XfZeWLz51T1AB/VyL8ul5AhPBn++k=;
        b=cZoG/LE3a4zCVoZBxLjpGmgWKPwxiowu+OsoJAOysJuEQsfUGmarXPc3mBmpXkRk21
         dAMLr0zLLQn/PFeWlfCG8BKiu5JwZ49og4APJNVoKPDmnoNC3+AoP+KAoB333FkpVl9V
         plIMZ0+8vGUTlH8j/igHX6OSe4yeOomWVY/VSBG7+/MPAmmfwRMwT/nYtFkgVOCeDh7R
         mtH1uOR3Kb4Zo6ASw0Ea/rs4dE5iPiqU90JvgGOqykEz+NiOZnEjzz2dKpI6qA502DsH
         8Uu3Is+UTbFIi1f9LDZUVxhGK5/NtCxezGpBnh4zpMLuXt8Jzarzx1CEYpZ+YUQacji4
         K3Kg==
X-Forwarded-Encrypted: i=1; AJvYcCVHPA0uNulMOSV3lDuWgzA6ZkFLkNRvcL78VQKzNcRY1aWY1CHXv9XbygmJAtuKr5/h0ODwwcFOewLO@vger.kernel.org
X-Gm-Message-State: AOJu0YyRJwjvaL9cQCwBCZ/uH4eP2SMhOqm78x2agsCun5how5+dx8ml
	mb1JY2qn8zGHurfD+PwYpyd8wJFgZzpvFkrUDNVa8FvRNGB+J6UquJr4PAain+T2bh1KYwWugIW
	3k45zlSTFd59ZlwTdZi0Bfw12RkMebYcZx7b2t06p1LuHqCokUbB3zUzpu5aTNkYQAKcPn6b4Mn
	vN3BweRlSFAtp5nu4iSXvyF1zWDUyG1GnpebPB/8SPVk2P9xJv
X-Received: by 2002:a05:6602:619a:b0:804:1579:182c with SMTP id ca18e2360f4ac-82a11011423mr490623339f.5.1724963347542;
        Thu, 29 Aug 2024 13:29:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE83jaTbymcBM8pIekmJUAAq30TW8KLn0Sslp6myqI8EisD5YCEbb4Xmx1iGNWzKslrwL+WV+35ICmn7wQKwDc=
X-Received: by 2002:a05:6602:619a:b0:804:1579:182c with SMTP id
 ca18e2360f4ac-82a11011423mr490621539f.5.1724963347200; Thu, 29 Aug 2024
 13:29:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANikGpf0OmGMSkksH_ihW9_yXVAL25xKD4CBy8d1gpKj0inPjQ@mail.gmail.com>
 <CAG48ez3b-FCz7+4MH=CmhbhmSfTT4FTrDAJfbL5UvufRut7ixg@mail.gmail.com>
In-Reply-To: <CAG48ez3b-FCz7+4MH=CmhbhmSfTT4FTrDAJfbL5UvufRut7ixg@mail.gmail.com>
From: Juefei Pu <juefei.pu@email.ucr.edu>
Date: Thu, 29 Aug 2024 13:28:55 -0700
Message-ID: <CANikGpcNj6P1jH8v0NjZJeQdn2=FbPr71CJ8W8GE+OeiCMgucA@mail.gmail.com>
Subject: Re: BUG: kernel panic: corrupted stack end in worker_thread
To: Jann Horn <jannh@google.com>
Cc: Juefei Pu <juefei.pu@email.ucr.edu>, James.Bottomley@hansenpartnership.com, 
	martin.petersen@oracle.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Yu Hao <yhao016@ucr.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jann,

I checked the kernel configuration we used and I found that we did
enable CONFIG_KASAN_VMALLOC and CONFIG_VMAP_STACK during fuzzing.
I've uploaded the full configuration to
https://gist.github.com/TomAPU/64f5db0fe976a3e94a6dd2b621887cdd

On Thu, Aug 29, 2024 at 1:23=E2=80=AFPM Jann Horn <jannh@google.com> wrote:
>
> On Wed, Aug 28, 2024 at 1:49=E2=80=AFAM Juefei Pu <juefei.pu@email.ucr.ed=
u> wrote:
> > Hello,
> > We found the following issue using syzkaller on Linux v6.10.
> > The PoC generated by Syzkaller can have the kernel panic.
> > The full report including the Syzkaller reproducer:
> > https://gist.github.com/TomAPU/a96f6ccff8be688eb2870a71ef4d035d
> >
> > The brief report is below:
> >
> > Syzkaller hit 'kernel panic: corrupted stack end in worker_thread' bug.
> >
> > Kernel panic - not syncing: corrupted stack end detected inside schedul=
er
>
> I assume you're fuzzing without CONFIG_VMAP_STACK? Please make sure to
> set CONFIG_VMAP_STACK=3Dy in your kernel config, that will give much
> better diagnostics when you hit a stack overrun like this, instead of
> causing random corruption and running into the corrupted stack end
> detection.
>
> (Note that if you're using KASAN, you have to enable
> CONFIG_KASAN_VMALLOC in order for CONFIG_VMAP_STACK to work.)
