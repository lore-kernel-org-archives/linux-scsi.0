Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A423CDDDD
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2024 22:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DdCwfz0Q"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5534dcfdd61so10357160a12.0
        for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2024 14:36:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1705012583; x=1705617383; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cQ1SU/oJ/hqUhOTuKn5aAqtJtdnCvUaprAQhGYdhU7s=;
        b=DdCwfz0QS0shZ7H9tnILvIePlZTh1Rn3iWvVz8JB8O/yrQgsTpM0lYen4z0JL1HPdR
         9NzNVe18VfZwh06pCP13B4JjUdl8Daorv6QTXox0BEVKOi9QFRUwoN7UPn0QZhZNQxMR
         B/2VhrdxWe6eJubE/t1YKEV4IAAFkZLufe0Mw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705012583; x=1705617383;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cQ1SU/oJ/hqUhOTuKn5aAqtJtdnCvUaprAQhGYdhU7s=;
        b=j8dILodOBy8uoVsHRm0VZYy70u/OaqeYDpCpjT9Hgj2+tqTB2O4rVqWZNP0N35h+4g
         mrWN51VhHMrbGvGlJjB9/idraBHQQApP4ZZsJjBI7GZs/pTkopa0swv0Licc2A1KUVtK
         G88os7nRjwjspO/0vmo4PacyxMEL+O/LbbOwnDyQBlj6Mjcyt3IIT1B66Dh6MESIkhmV
         6LaIKtKIIoFlxTRSDnlFZozgg5keoRmv0SYgjS8Cz1HMnhcEJfIoaZB941bZksF9n9Qw
         YgDlLEONDph5CGjxSZmhYaG7CwyzlVSYlkVkF0YhgubUtVt6qh//55vI+Q82ppFHZ3mX
         fj+g==
X-Gm-Message-State: AOJu0YzZWsCZiXJTLgt7/QAnC98ybh0vtLhyXMojymC6o6ySNf3yMzTI
	phWLFWpmKMnxsKw0L96K8FjCT9/6I1FjGwsGOOd6/iPDisfFTcuj
X-Google-Smtp-Source: AGHT+IGESPHSYyHTp1FwlzQmE4m9OJsrOyZ/FytoNiA0b7nu/62+ne/XzLJW25ta+fcQtl8JatUPdA==
X-Received: by 2002:aa7:d80f:0:b0:558:b816:b6b2 with SMTP id v15-20020aa7d80f000000b00558b816b6b2mr785992edq.12.1705012583747;
        Thu, 11 Jan 2024 14:36:23 -0800 (PST)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com. [209.85.218.46])
        by smtp.gmail.com with ESMTPSA id j14-20020a50ed0e000000b005550192159bsm1077158eds.62.2024.01.11.14.36.23
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jan 2024 14:36:23 -0800 (PST)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a28ee72913aso1165493566b.1
        for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2024 14:36:23 -0800 (PST)
X-Received: by 2002:a17:906:504e:b0:a2b:2bdb:5a2a with SMTP id
 e14-20020a170906504e00b00a2b2bdb5a2amr549457ejk.49.1705012582592; Thu, 11 Jan
 2024 14:36:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c5ac3166f35bac3a618b126dabadaddc11c8512d.camel@HansenPartnership.com>
In-Reply-To: <c5ac3166f35bac3a618b126dabadaddc11c8512d.camel@HansenPartnership.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 11 Jan 2024 14:36:05 -0800
X-Gmail-Original-Message-ID: <CAHk-=whKVgb27o3+jhSRzuZdpjWJiAvxeO8faMjHpb-asONE1g@mail.gmail.com>
Message-ID: <CAHk-=whKVgb27o3+jhSRzuZdpjWJiAvxeO8faMjHpb-asONE1g@mail.gmail.com>
Subject: Re: [GIT PULL] first round of SCSI updates for the 6.7+ merge window
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 10 Jan 2024 at 12:48, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

Ok, I note that this has been signed with ECDSA key
E76040DB76CA3D176708F9AAE742C94CEE98AC85, and while it is currently
available and up-to-date at kernel.org, it shows as

  sub   nistp256 2018-01-23 [S] [expires: 2024-01-16]
        E76040DB76CA3D176708F9AAE742C94CEE98AC85

note that expiration date: it's three days in the future.

Can I please ask you for the umpteenth time to STOP DICKING AROUND
WITH SHORT EXPIRATION DATES!

The pgp keyservers work *so* badly these days that refreshing keys is
a joke. The whole expiration date thing has always been a bad joke,
and only makes pgp an even worse UX than it already is (and damn,
that's saying a lot - pgp is some nasty stuff).

When you make a new key, or when you extend the expiration date, do it
properly. Give ita lifetime that is a big fraction of a decade. Or
two.

Because your keys constantly end up being expired, and they are making
the experience of pulling from you a pain - because I actually *check*
the keys.

Stop making a bad pgp experience even worse - for no reason and
absolutely zero upside.

                Linus
