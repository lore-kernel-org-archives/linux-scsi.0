Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E2F1F91D6
	for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 13:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776778242; cv=pass; b=E7iKDfrqi27WMxSkchs4NNIaBuX0Sj3P0snDRq9OTCnmI5KfLe10n5lQHa4DhTG7IwYBWPpaRVJNQXaE5zUe+S3szJNSxpUOYiUCWxg5yadpl4OIsETRiY1eV2/WlMmBM4JKcGfYUa0X21OmnDe1e2hr5cVzv6Hr7Cv0VkoaFSY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776778242; c=relaxed/simple;
	bh=FFUNLVgGj6TBwQDXczffhQbCSgIoRnXbz8CETIMk0U0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SagwsXAsd7sKTCP++olAJazFlQVk2F2azCC4I0aFipqaWKfwhKYotZXTxEwOmrUJ8J7HeUQlLkJKmsCLcKD6rJ77z3h1Vf3dMA1wwHBYa7zPsixdLn7eCpmPrreiVh9GQOi716J4XeOFFmRzvo/ama2N5kXKt+sVI2hjlBm77B0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fpeYJxEd; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bmyj6oCq; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fpeYJxEd";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bmyj6oCq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776778240;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FFUNLVgGj6TBwQDXczffhQbCSgIoRnXbz8CETIMk0U0=;
	b=fpeYJxEdH9NpwWDbUF87zD0f1MupRdmHo/djHi1xTqTFQ/PzRbjYWn8kNMets3EDRWD50o
	EpQGUGHFnz+B9TxhgJsytc+BWvvyLYQuhB1L5fuE8aGCpFBBBdhy+SYWMXab5tfbMFTg6b
	GxVTnx/cAh9r/y4Jbv07yZWy2zWhKW4=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-171-4Lo-TKGnOn-VNbpXI4-nJA-1; Tue, 21 Apr 2026 09:30:36 -0400
X-MC-Unique: 4Lo-TKGnOn-VNbpXI4-nJA-1
X-Mimecast-MFC-AGG-ID: 4Lo-TKGnOn-VNbpXI4-nJA_1776778235
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-38a247e261dso38721141fa.3
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 06:30:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776778235; cv=none;
        d=google.com; s=arc-20240605;
        b=e/p34MEyuxaIILRdKuiYZasOizHG7UOOQFzsYXoZC2FPGjR+blzHCKpcHcEouBTf5G
         uh5G+hRVsEFzzUHqgB8O4N0/Tm+GBgQOrWtJdyagjTLCJRMbdPBZ5094CGXCD/0VIbJS
         jqMfWFs4rxUgJOTbLd565BGKyny/19m2uk4T4rUt29Qp1+6641Q62ksLTtBTAbX1yTMD
         B+aXOWBpOTOH7GfLoSYaPenbdDgLfav8GeildoflTkIAlGk09VU1fakDyQ7090HUVI1P
         JFa7Ct35qurbfqIog2p4xturEFbAYeg3FjHJzE7WU/FM54vQB7c7ebTsw1rlsqoxdZhD
         wY0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FFUNLVgGj6TBwQDXczffhQbCSgIoRnXbz8CETIMk0U0=;
        fh=XFhTFQpm846APmq/iNc3oS6BoYQyoeF6zNOAQR+gYDQ=;
        b=McqYHglf3wrl/XMsHFQ8MtKIIWnjqaaZJ15u5qQrHMjtnQI1KxZqXqfGqB57l1wHnn
         bij/7E2+E5mUUsINJ66AbfvAi/Z/JUvxGlwKGZ8qYWQiUJtAHL5gIB4FTVnnovgfaVuO
         kps9TLeGK3ZITTOw66LUWv6R12YnuN1vsdXcgFn+JicaNth72TEnUc0mZmWb89EWreQu
         eujjNmTVP+M7E0SpNtXC61Khknf1GTE+9KoY5HQgmJYO4/V9dTGN+fFSulwLOiaJ0G3g
         s/TZ0MvPaB1Nmn6dqFb8/JfX8tVJpmK9M0HJ322BYWVVin/feIfcG8QnDH/kJmX2VsdM
         t/zw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1776778235; x=1777383035; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FFUNLVgGj6TBwQDXczffhQbCSgIoRnXbz8CETIMk0U0=;
        b=Bmyj6oCqW7YhECm3oxNrO3KIRTjLt0SGJo7PxX0vLOEOB+QSfnFjYaCVafSC6nr1XG
         kj0fkywg0zcgU0MAeAv0hMedinu6uh+fK5Gtu+K5uqLYwze6v6W/WlqAjZ50oALtUn5B
         Nnh1V6ypD3vTFuuZejO1u1ZhhwAlT+6ww3s0tU3YntkjRuyId1kELW1qDlCxrP64u1Ih
         oh9+GT3/GIfiWD8tBBzwMHlwQaWNHNEbqlSeOlJANGoKzo0CHFwUIMe3UyMIeJZwZGAg
         JU/klh9ZRkRl6Ap6HaXSigvUNsAYFbrVhXjtqTEDIuLDZdeEnZa/jSZE5uBUTgwexjg4
         MR8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776778235; x=1777383035;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FFUNLVgGj6TBwQDXczffhQbCSgIoRnXbz8CETIMk0U0=;
        b=E8wAMZ7MSkkUYae+t+tKHfM2MdZvGsIlSJU0r2dLhJdUTaYS2j+zjVDP35vY5bsbF+
         4iHC1ufWm74SwMIVDDxXNASZdO6tHrSmFkLHiXaccE0sNQkVVd2irbf+2Blh5vFlyTAS
         Hrel7UU0W97ZJsPPzBqPnAe3aLWhu0prVijb+7A/eAT6eFx2ANwFPOyEhD5AzA3ehw9v
         s/fgv9GE+whsAQ5Pozh+tVeJYbksKO0+nOwDOZvCHl83obE3PAJyDabHmJ19UakXENsr
         5qp4S4W/XILkYiJXRPE8nUrctp+BLbliB7BHvWvl/UiswKr9FVqtB3bHS3H3vFCGE4PY
         EUYQ==
X-Forwarded-Encrypted: i=1; AFNElJ/DZ0S+qao5jr+UdAGgPKs3aJ85CVTfC+Pug0suJ48R/SEPA37sfApi4tAucSJXvEk+lrsaXukbSq0k@vger.kernel.org
X-Gm-Message-State: AOJu0YyEGV+1ZzDP5x1vgryf7/RrQY0Loau3tL3H6y/8syHmD1l7L92h
	38tQEWS+mP4/XYUT62/v8Fak4tfuXMwHubLkrfQ6IElYKchTpGXYEJjILo5zMqrDNE62l32/ShS
	mgkPPjOXHMd1K63xwc0JSiciR0il+L4SFWF6FhfuE5FcW5AV/0/9GbAvLPkHoSinTftMRcC93Ra
	IgOlvJ+sCSgeZ1u+ADdrDyzP6Qwhg0+3Xu1GycoA==
X-Gm-Gg: AeBDietkC1amSeThLodUdNL7cw0MQbUPRWfLyIoqEDYmZuDJveoUUtuwe1obbqzHy36
	D3kdnBY+ez1m8pInAVNgTfcxjmcnqelZnwJSDNJ1ghEbReG8PoG8V7OKiY/vR0odlZ/hguarrbb
	F4ZwEn/17LgBqqrVmT5wx6zbuxH4+PY1eqbxL7aOXdFDfgd5inwEd6devG/rvQX3tJTjk7OHKw7
	ThEUIozyNFFBEU=
X-Received: by 2002:a05:651c:2120:b0:38e:a8ef:b61 with SMTP id 38308e7fff4ca-38ec7b479b6mr54497031fa.29.1776778235019;
        Tue, 21 Apr 2026 06:30:35 -0700 (PDT)
X-Received: by 2002:a05:651c:2120:b0:38e:a8ef:b61 with SMTP id
 38308e7fff4ca-38ec7b479b6mr54496791fa.29.1776778234483; Tue, 21 Apr 2026
 06:30:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260420152608.6244-1-djeffery@redhat.com> <ff05ee4a-1cd8-4750-bbd2-8a8cbab59390@oracle.com>
In-Reply-To: <ff05ee4a-1cd8-4750-bbd2-8a8cbab59390@oracle.com>
From: David Jeffery <djeffery@redhat.com>
Date: Tue, 21 Apr 2026 09:30:21 -0400
X-Gm-Features: AQROBzBtok6Yzg4ok696ORQ140C5T6p4P5qZncZ6-KrGBII8XAtSjGeJb6YcdEY
Message-ID: <CA+-xHTGSbbBYOLYgcD4_964dtuh0NzrnuBS5FT=+5+dPdV055A@mail.gmail.com>
Subject: Re: [PATCH v14 0/5] shut down devices asynchronously
To: John Garry <john.g.garry@oracle.com>
Cc: linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Tarun Sahu <tarunsahu@google.com>, 
	Pasha Tatashin <tatashin@google.com>, =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>, 
	Jordan Richards <jordanrichards@google.com>, Ewan Milne <emilne@redhat.com>, 
	John Meneghini <jmeneghi@redhat.com>, "Lombardi, Maurizio" <mlombard@redhat.com>, 
	Stuart Hayes <stuart.w.hayes@gmail.com>, Laurence Oberman <loberman@redhat.com>, 
	Bart Van Assche <bvanassche@acm.org>, Bjorn Helgaas <helgaas@kernel.org>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 21, 2026 at 4:02=E2=80=AFAM John Garry <john.g.garry@oracle.com=
> wrote:
>
> On 20/04/2026 16:26, David Jeffery wrote:
> > This patchset allows the kernel to shutdown devices asynchronously and
> > unrelated async devices to be shut down in parallel to each other.
> >
> > Only devices which explicitly enable it are shut down asynchronously. T=
he
> > default is for a device to be shut down from the synchronous shutdown l=
oop.
> >
> > This can dramatically reduce system shutdown/reboot time on systems tha=
t
> > have multiple devices that take many seconds to shut down (like certain
> > NVMe drives). On one system tested, the shutdown time went from 11 minu=
tes
> > without this patch to 55 seconds with the patch. And on another system =
from
> > 80 seconds to 11.
> >
> > Changes from V13:
> >
> > Remove duplicate flagging of async shutdown on scsi hosts/targets/devic=
es
>
> Please mention the baseline or branch that we can apply this. I tried
> Linus' tree, but it did not apply.
>

The patchset was against the Linus tree, but is no longer recent
enough as a driver-core merge conflicts with patch 3's header changes.
I'll post a rebased version of the patch.

