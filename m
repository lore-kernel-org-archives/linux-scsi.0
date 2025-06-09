Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577C5221554
	for <linux-scsi@vger.kernel.org>; Mon,  9 Jun 2025 19:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749495735; cv=none; b=AsSAjjiwIVKPvH+UJbj9lCB/83IsXV9pUzZAfB1juA23U8vzkSnQiTITgraiXD2YbxzqnL5j+5wRGVNsFUGDlFGpu7qnnf+RDUVaWuH031weYwK0vNnZ5/w1HqL5EdqHXXBemtPBRLQxyTQ3h+YJygheLLwEzacWvVaCTgwe0oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749495735; c=relaxed/simple;
	bh=OZTfqoL2OcDtWlZ3pnF9M6AJVam8XHJEZjA+dcwD7is=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i7TLzJ4DSF7VVjHNbspH/Etg9s6pY+H0VVapb9BvX7kvyo47XKX/b4HUIa5Jomnj4HtEi3R9NF6NIiOYSNb0niVq67vOv+QsRDvx7EjqKVTKURbIEZkZg6Inoeqqwjn6kHPzZna5JBkKyrB3ZuxrARpMe47Mm7z17zWf4sjKdB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X7oBkT1W; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X7oBkT1W"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4a58ef58a38so34721cf.0
        for <linux-scsi@vger.kernel.org>; Mon, 09 Jun 2025 12:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749495732; x=1750100532; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GyTDJzBzlJRnsZyjzOICzR9Mkv2ePG1yNOP4xbIItDs=;
        b=X7oBkT1WAZ6t5q/4NJWCQvuODImPuLGYh//v+/sR4QzfqpA6A5HKNiSnv9vOmDmsAT
         mbB86uBB5X+edeantLfcpYbrCNeOjoPoYYwa+PzpQrxiF76b5zuDQbbB/aBIY4oxHUvn
         NONEpNzTFbDpeSSZ4J+TOKuvOoFhxCWTS+MXNFcTwEy7Q2KHSivZZnQ5srqrd8u1CFQ0
         YkCUwlQANi3PmsOq7UgbosM8TAp36lv0XGGRWrZhHEsfEu6o2BFcGqLTSgS1RuyHKP/E
         QfpVXxp3t+VLmtyzcVzE+D9j3ifQZHH6PL5oyoWQJ0wh2+ZLObsaUnhQ9A3E5R6QvtKi
         u+WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749495732; x=1750100532;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GyTDJzBzlJRnsZyjzOICzR9Mkv2ePG1yNOP4xbIItDs=;
        b=TNxLxLARTWVbUFLT+1lrgEaU1AXthffUfIoQOrbL8w8CCsaF0p5FOsxnmiczatkpuL
         B4cGARvrn2ZFQhrIY5xglP3q43SroYfQHnd/TUIDzHy4tlXYKZvlmoCFdGEhluGcZEF5
         WWBMPV9spqPv4BjBhb+3ZDx8Z0uVbIDRf+lzjuMvA88sida2tVFvpcFOnoMnYmLl9YEw
         iVo5837UzbtqwGvxuHG2vWu/wUJeFf+FqpA7nBuaIVY1LRXUyXavOZcpnF+lW9JOMDXb
         iEWqQg9BXX7juOFF4vuPLhU8fCe5y97Y7XxbCYD2voYx10DgeXbaG/G13pd3Nr9VNDMC
         XWAA==
X-Forwarded-Encrypted: i=1; AJvYcCU3XPN/Mn96K+ZiGWY+TtL/EhsUMR6jdo5mB3h4FdlvOKuZVUjun8DIhZlp8zRp/WVrPTTXaKZbgFH+@vger.kernel.org
X-Gm-Message-State: AOJu0YwS+jhG0tohlOfIjRxhkfHeld7n0GTpmcHQfvv/bRiUBzskfY4K
	dVXT1ix0I1JvhcxZ6XRPaegk51LRvcah/8vrtICHN8F16fvCetB1qsNwSMO04TCu0e69bhjdYva
	weYcRpdapPy60HbDOdkhruGeCaKsCmX9peDamvqxz1koT4+tpp4KEdL99+i+UgQ==
X-Gm-Gg: ASbGnctt0QkUMgMhaL3ZjC0l71p45AOnPn81neuTQbziXSHbLlBl9uDDRQwHNNV+Nb4
	X0BW7MyNTXXbJDx1xBC0QuYpRL4W97qVyaM+Ihsu+zB2FmLialmyRZn2WfPrbWYg72vmBe7VE9x
	7ZhbLr6QTvp0kIH7Iig8C3NQiheACE/aSbufPJpogpi2xD39liOaK9ts3iIDJBSeIiFFIhs2Y=
X-Google-Smtp-Source: AGHT+IHozTXc/tPXsLEr/JHPv0DSquqgQ1lZmBviZQOZhRZVJltPN1/2qyx5gpZIHGjNVpXQyp9x5xXjp/TbbVd7mgI=
X-Received: by 2002:a05:622a:11c1:b0:494:b4dd:befd with SMTP id
 d75a77b69052e-4a6ef9d2c13mr8141361cf.8.1749495731878; Mon, 09 Jun 2025
 12:02:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250422181729.2792081-1-salomondush@google.com>
 <CAPE3x14-Tsm-2ThihT3a=h9a0L9Vi8J4BbiZiTV6=6Ctc1xryg@mail.gmail.com>
 <18aa42a73584fcf50b07d7a43073e55fb4c3159b.camel@HansenPartnership.com>
 <CAPE3x16MrkQXFasVaaHBxhH2QvQ4H5cDiE3ae=-nYjuEKV-NBw@mail.gmail.com> <727641384722bbdbbf96176210a7899f1b9795eb.camel@HansenPartnership.com>
In-Reply-To: <727641384722bbdbbf96176210a7899f1b9795eb.camel@HansenPartnership.com>
From: Salomon Dushimirimana <salomondush@google.com>
Date: Mon, 9 Jun 2025 12:02:00 -0700
X-Gm-Features: AX0GCFuPOmyIxQJPp_J0pnfo1NGjd8wYt6a7sUe9NuQixSiRnlMp6XuzWTCV86o
Message-ID: <CAPE3x1735+kU2yRb18OroQoaXQddZTx6XjT+0pghBNYcO3h+zw@mail.gmail.com>
Subject: Re: [PATCH] scsi: Add SCSI error events, sent as kobject uevents by mid-layer
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The team considered the use of SMART tools. While hdd smart data
has info on data command errors, they are not suitable for non data
commands that we use internally. We are unable to use tracing due to
overflow / overrun issues. However we are exploring some other
alternatives like eBPF that can fit well in our infrastructure.

Thanks,
Salomon Dushimirimana


On Thu, May 15, 2025 at 1:11=E2=80=AFPM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> On Thu, 2025-05-15 at 13:03 -0700, Salomon Dushimirimana wrote:
> > Hi,
> >
> > I agree with the recommended use of ftrace or blktrace for tracing.
>
> Great; what made me think of tracing is that your event emits for every
> error or retry which seemed like quite an overhead.  Conditioning it on
> a config parameter really isn't useful to distributions, so using the
> tracepoint system would solve both the quantity and the activation
> problem.
>
> > However, our primary goal for using uevents was not merely for
> > collecting trace information. We are using uevents as a notification
> > mechanism for userspace workflows to determine repair workflows (swap
> > / remove a failing device).
>
> If you're collecting stats for predictive failure, how is this proposed
> active mechanism more effective than the passive one of simply using
> the existing SMART monitor tools?
>
> Regards,
>
> James
>
