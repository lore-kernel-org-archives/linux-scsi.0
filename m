Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF8025745;
	Mon,  8 Jul 2024 14:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720448318; cv=none; b=sg89ityHvfEK9hcBTpu7cJcrFZsv7DuQ0rECfR5hkJ8wL4pvzn7MkzXMoW34zwwabDSKwkezp/2LenMjqtdJfnYkojr3ZnzlMa0fF1OzOaMy/cd18y/igVCW+hTWsdUPVnR6pWChh6TPFPc3wLf3mzHnfjtTYfom9tAZ7NziFs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720448318; c=relaxed/simple;
	bh=GmM0j3P51qYNYcB9FB5GbSrbtyWecjbiPcPIsW4vHQc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GmvWZ9j6CFqAv3wUlpqvB630CyxAldJMomGFiaXokMxZpjwf0DdP/rmj7qFfJHz4/nANQ31BQ9fCnObpsj57IJTSrzARFtBvQu4W/f+HIYZOHlEAxcG3aytkvJrEekleDyxIu5jE9Df85ShTkU7guJ5N+HfdZPoOZQ1uLM19s0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SuD/cDXB; arc=none smtp.client-ip=209.85.217.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SuD/cDXB"
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-48ff8aa6081so1032274137.1;
        Mon, 08 Jul 2024 07:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720448315; x=1721053115; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vzZ0t+6EA44YYeZ1nSKnkOHgB4WgwxxqFBIuc3oST+w=;
        b=SuD/cDXBzSAqnuSZNQLSbGCQcMQzMboMEJNUAzwYTgTOTuH647gBXxzuJv8n0jw4LM
         W+1UjBVVOa4grTFgn0EtJ6d+dVhdYoJYP1NsPt1qdrAuyciCdZ35+lSQ9012wkL+A/sq
         SqzVGkJpQHdpMXNflUWHi0P7LlFJ+vEgs/JZnhcype3NxPX8hkcisdwQwSyZHW+fQF7C
         X3WSs1tuEooShKh4PCJLt2mmvQCBKthmwYHRJag7yIMr0BaRdb4BLcHeJWcDFU8gU+i7
         2W+KMDZqi+WWIBV7B5PtK2HO+xG5OAMcooPS42wTZFLcYEuuFLPa8dIE8RAX+ICCadp9
         OGOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720448315; x=1721053115;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vzZ0t+6EA44YYeZ1nSKnkOHgB4WgwxxqFBIuc3oST+w=;
        b=NYGmwRr8te/qNXv8oowdfQQCEK6AcOqupzI2kNlAtmWuZSNuW5rfoxCfFERF88LY7D
         X8WYj9nS7AqrvOk10mN8QFVsrPeHUcbgCJbyh3odKTmhuc6WfyDoFRA31NEnYr40cJ5L
         9FHNybqW9mzsQY4SBUmYnANvNveRWSGzwL+UpvR8l3EWGHjxeGe8NkAiNQ+mFdWE8SjE
         ANKsvHQxEqbQSfhG/oDTARfOz1fvMCQ1q1QEmfZ6kyfmEkGmPMPoVk1pnTktMKAmypzS
         KKEbfkor/P4S1jlJu87z35HfPRYgpLMzxCQZftXcoeF9+Fuq0pqtSj8df4xskY7dp1KC
         FBRA==
X-Forwarded-Encrypted: i=1; AJvYcCUQqyFa/1mYZI86/NxEwTE6Jn15d30EQb7uZJTGhZ9B4zjd0E3uvJpabXRgNDJlZ7aWEczSaaQY6wO8tgVsEW2t0QPs1TWubfwK2IN4abCwzfJLRyO8q/TX5ejmTNwyw+/UvCOrO4fM
X-Gm-Message-State: AOJu0YzTRmXS7JU7tKXC5XiKKf0bbjgDMk9UFtTrhuap8TVrPsv8m12d
	VBXOw0xMFyFChaFJ8+iE9alzQbuHGtGf6pSaBYLNOvZpDVlwGLPN6ttbpdQNI6gDuoIMpLet0nG
	bdeFCUbp3pgPEOF6I+8JMirMyqQ==
X-Google-Smtp-Source: AGHT+IGBZ+nfOhagN9EruogOZmg7A5VWL+nHpS7DVh+j85DRP1XireqJnFUSTtEzQm9VwJ5uppvB8QfKb3CsC3X5BvU=
X-Received: by 2002:a05:6122:d1a:b0:4ec:f9ad:d21a with SMTP id
 71dfb90a1353d-4f2f3fd1102mr14678174e0c.10.1720448315692; Mon, 08 Jul 2024
 07:18:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240705083205.2111277-1-hch@lst.de>
In-Reply-To: <20240705083205.2111277-1-hch@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Mon, 8 Jul 2024 19:47:59 +0530
Message-ID: <CACzX3AvXAhcjE0PEB_PO7B2e0pRB7mj2QMdw5Gj_sNH-acTfYg@mail.gmail.com>
Subject: Re: fine-grained PI control
To: Christoph Hellwig <hch@lst.de>
Cc: Kanchan Joshi <joshi.k@samsung.com>, Anuj Gupta <anuj20.g@samsung.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 5, 2024 at 2:02=E2=80=AFPM Christoph Hellwig <hch@lst.de> wrote=
:
>
> Hi all,
>
> Martin also mentioned he wanted to see the BIP_CTRL_NOCHECK,
> BIP_DISK_NOCHECK and BIP_IP_CHECKSUM checksum flags exposed.  Can you
> explain how you want them to fit into the API?  Especially as AFAIK
> they can't work generically, e.g. NVMe never has an IP checksum and
> SCSI controllers might not offer them either.  NVMe doesn't have a way
> to distinguish between disk and controller.
Yes, these flags are only valid in the context of SCSI. One possible
scheme can be that the API still has the ability to pass these flags
and the NVMe driver fails if the user specifies these flags.

>
> Last but not least the fact that all reads and writes on PI enabled
> devices by default check the guard (and reference if available for the
> PI type) tags leads to a lot of annoying warnings when the kernel or
> userspace does speculative reads.
In the current series the application can choose not to specify the
GUARD check flag, which would disable the guard checking even for PI
enabled devices. Did you still encounter errors or am I missing
something here?

--
Anuj Gupta
