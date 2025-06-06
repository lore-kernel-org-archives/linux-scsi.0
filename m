Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC3E2B9A5
	for <linux-scsi@vger.kernel.org>; Fri,  6 Jun 2025 14:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749219946; cv=none; b=lYHAtvURpG7OoR4LPey0f9zfgn2qS6NImXkNT6hez1mo06JeILtI7s1hBMtYCXWONVwv0BlBR7E3nwQ1jjQbmnQ3Z3qHFX1ykzAVJW1+DEvAxl0NbUboEAEXg19a8W/NkdO6XzOpfTBETv1nIh/C1jHFL2YWaXBT0kCJcsCr/oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749219946; c=relaxed/simple;
	bh=3qDXXSo9V97Ln9bq/SaJnvqAfowOQYvP+bIcxRBosxc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WTn0fU5udkDDZpog3VnOvl6ILz9R5qcp9YMqYs4Va7kidAK+VeOWgQo5Qm7v8AHEahkhoXANi6/GmQcUqio+qpBphOpSLtwDcceje68iRRXnl+4GXNswDsz+75yg2O1BQ1YculUmeslwteEx+gRlu7cmDpe9w1HKyQ5r4EjSDnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G5vBLj9Z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G5vBLj9Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749219943;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nbe1K1n6EnoNpJDeM1+H0VVygYl65ltcXFDiurkXp0I=;
	b=G5vBLj9ZUhOQEOIiPreCIfVvKdZO0T+Oh06rfVsBDuTEKyQenJtsbE+7LPQTCi2PJYwFkG
	rX8pXY6T27C8uv1OpoQ0rEpcKbd2eNtWv+eW28hypTNGh4QrjRA8Z+4hk/r8bQpYgfvOVr
	lY649rCVun53DY4eO4gm5fps5DPJ9t4=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-39-A0rKrqUXO9GA4DvXqNsiVQ-1; Fri, 06 Jun 2025 10:25:39 -0400
X-MC-Unique: A0rKrqUXO9GA4DvXqNsiVQ-1
X-Mimecast-MFC-AGG-ID: A0rKrqUXO9GA4DvXqNsiVQ_1749219938
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-32add2506abso8302021fa.0
        for <linux-scsi@vger.kernel.org>; Fri, 06 Jun 2025 07:25:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749219938; x=1749824738;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nbe1K1n6EnoNpJDeM1+H0VVygYl65ltcXFDiurkXp0I=;
        b=w8jIRhnS6RyHCZ6607G6o5dvJKPnsX814FSOGJ68thYwFOswBwOAXRBPGHk7IG+LNZ
         3EdRtTKQXLcz5ohB/uY04BP4zd0urd27Si8wIRkH10P0dCpc52LoAq9MmrppZkX6H5Hl
         9CcQKx9q6JuaRFJ4e6XHXgNIOO9jF1p/4ejaQ6aLP5g7Q9tSptx+hC23AaqHKOgwYHQV
         ZMqbWO+VBLzq6+TkzK42LsoCGpq7+7M+M1Mx3qUKeJVykqX/ercMaI9k+8eVN4Ycyi6O
         kS4C0CJ7X0tSt2/sSWyvJ1SjPoIPNolMC9Xc5SXpQBCFe4qR8dSSk1EL8EcSq/3Ofn9a
         WViQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3HI0gvvIboGvdEsSIdxCxiGbYFNJZ3pnRxnkFqz08PoG4azRPiyK2bWOqwZXI6uB5+9a0HL8XRhCD@vger.kernel.org
X-Gm-Message-State: AOJu0Yzze38ON3D746veyjVKHlcpBOstETss683QZW2xg9R0OUmQ5H0A
	+LlZmfkNHmlnvJH7+YRvtQrxSs94J/hd9Zgn08xrSLgsT+8gNCEBZdAzjSAaaA6/8cEM8YtRcw3
	62rtp77+YCSDuPEdb5qQkTUI2a3JdjR5uyOyW/hZoqdcir+M2A+mxnX5Lzj9KnZfVJ0xalxzhOA
	30XL5HqcOvc46AGvtiEGz3xVjHSjhdEEAXMciLfg==
X-Gm-Gg: ASbGncuxVe4fZ1ZExtfo79g9tMQZGc3WJGcC+F3po5eXEywgmAIVqQL/TE4r8l5xzdO
	LPsJyok2gHao6coUZVhWP8zXAW5UsN4w1sVG+cQ5EOSQ60cPrcNy/l+eL5ed0UmB2QMh6NmzolC
	YD5tU0
X-Received: by 2002:a05:651c:a0a:b0:32a:ec98:e144 with SMTP id 38308e7fff4ca-32aec98e7b9mr2665461fa.15.1749219938170;
        Fri, 06 Jun 2025 07:25:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHXglcxl80BE482xq4dx91qTebsclNfPlMg1sw20ymT3/ZEh0z8jxknKBzXzbqnEY78ZQMjNrsOPiXqzhYfTLw=
X-Received: by 2002:a05:651c:a0a:b0:32a:ec98:e144 with SMTP id
 38308e7fff4ca-32aec98e7b9mr2665271fa.15.1749219937714; Fri, 06 Jun 2025
 07:25:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <2xsfqvnntjx5iiir7wghhebmnugmpfluv6ef22mghojgk6gilr@mvjscqxroqqk>
 <7cdceac2-ef72-4917-83a2-703f8f93bd64@flourine.local> <rcirbjhpzv6ojqc5o33cl3r6l7x72adaqp7k2uf6llgvcg5pfh@qy5ii2yfi2b2>
In-Reply-To: <rcirbjhpzv6ojqc5o33cl3r6l7x72adaqp7k2uf6llgvcg5pfh@qy5ii2yfi2b2>
From: Yi Zhang <yi.zhang@redhat.com>
Date: Fri, 6 Jun 2025 22:25:25 +0800
X-Gm-Features: AX0GCFuL4XNUJVJ0lfr1A30P6N_O92q6LMT8TriVlRQc68jUCEDZAsCtx8zBrpc
Message-ID: <CAHj4cs8SqXUpbT49v29ugG1Q36g5KrGAHtHu6sSjiH19Ct_vJA@mail.gmail.com>
Subject: Re: blktests failures with v6.15 kernel
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Daniel Wagner <dwagner@suse.de>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, 
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, 
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "nbd@other.debian.org" <nbd@other.debian.org>, 
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Tomas Bzatek <tbzatek@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 6, 2025 at 3:55=E2=80=AFPM Shinichiro Kawasaki
<shinichiro.kawasaki@wdc.com> wrote:
>
> To+: Yi,
>
> On Jun 05, 2025 / 15:02, Daniel Wagner wrote:
> > Hi,
>
> Hi Daniel, thank you for the fix actions!
>
> >
> > On Thu, May 29, 2025 at 08:46:35AM +0000, Shinichiro Kawasaki wrote:
> > > #1: nvme/023
> > >
> > >     When libnvme has version 1.13 or later and built with liburing, n=
vme-cli
> > >     command "nvme smart-log" command fails for namespace block device=
s. This
> > >     makes the test case nvme/032 fail [2]. Fix in libnvme is expected=
.
> > >
> > >     [2]
> > >     https://lore.kernel.org/linux-nvme/32c3e9ef-ab3c-40b5-989a-7aa323=
f5d611@flourine.local/T/#m6519ce3e641e7011231d955d9002d1078510e3ee
> >
> > Should be fixed now. If you want, I can do another release soon, so the
> > fix get packaged up by the distros.
>
> As of today, CKI project keeps on reporting the failure:
>
>   https://datawarehouse.cki-project.org/kcidb/tests/redhat:1851238698-aar=
ch64-kernel_upt_7
>
> Yi, do you think the new libnvme release will help to silence the failure

I've created one CKI issue to track the nvme/023 failure, so the
failure will be waived in the future test.

> reports? I'm guessing the release will help RedHat to pick up and apply t=
o CKI

Yes, if we have the new release for libnvme, our Fedora libnvme
maintainer can build the new one for Fedora. I also created the Fedora
issue to track it on libnvme side.

https://bugzilla.redhat.com/show_bug.cgi?id=3D2370805

> blktests runs.
>


--
Best Regards,
  Yi Zhang

