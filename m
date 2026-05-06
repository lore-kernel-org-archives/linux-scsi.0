Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5334C307494
	for <linux-scsi@vger.kernel.org>; Wed,  6 May 2026 21:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778101838; cv=pass; b=gCRvt/pCzLWgWuzY9tiLo4etgF4cLsnhO91cVNgY+VtMHZh+dIqjC5Tv+mAirPLcBRZya6vjIn7s7vUZNsHIufBsAaMIdpADPDz/ECWPTvQO+2w6PNOtHSggng99bQoV2sXgAB1A0EYujLbkbNI0nCMKkF9aZiyBBgtiu2Qu27Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778101838; c=relaxed/simple;
	bh=QqaD8UmQ8Z3VOreDAgWf/h1HMc4iYrLZBevxSmnzqSE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PXzlz0BlR4CQcoZ8G8oDY6ALaHjiEzSdhmZ2Ky1vAGNBSHrX55KI6syYMsoOnMk1JvJkjSPp/ndKBGcQCffr6eo4SjX2rjh/JYdLeNfZvHUCLPXS3za2cKchyVJQGvgNPFl9N0b0i75kTANAY+IEq7RscIGINvHDWjI78tD2CwI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Aq2VgTG8; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=msuteScu; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Aq2VgTG8";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="msuteScu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778101834;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wxnLsY+y7KxAKQJwPXt/psWoOCQobXjWIWQgMudLMZw=;
	b=Aq2VgTG87Mq6nNdZ1rGTHn1KEX5KL7ujxRNFCKJgPaoIWzd9TbiFQiBAGN9hTVVPE6R9Pv
	9TQ018o+XIjEibL30mZOWreEkj1IfBMKz9S3ZVEVV2uGwZxbewd9xl9OYeLSxYyxmgnCeL
	AFGVb2A4hi4fQmExW9Pf90Cv72/woxg=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-435-KeaiLhDnO3GAO-c7we0q-w-1; Wed, 06 May 2026 17:10:33 -0400
X-MC-Unique: KeaiLhDnO3GAO-c7we0q-w-1
X-Mimecast-MFC-AGG-ID: KeaiLhDnO3GAO-c7we0q-w_1778101832
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-62f471aa288so479927137.2
        for <linux-scsi@vger.kernel.org>; Wed, 06 May 2026 14:10:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778101832; cv=none;
        d=google.com; s=arc-20240605;
        b=Ba+Zcca690et5XX4PAszO5jtpmvrxGIGzQaIngaShAoLQ8MEwgBvBcCknDmvHSgns1
         l/5Tizi7LosjUwRY0lPLfEszI/+lr41fVs7IyuMeX5mSksKzKwrPSA65iyB2rp3QW0ZQ
         g/EDto+aZ8836zaMLjmxy4UgrXCT2G70cHgzMaoBx4vcuEXIYV5E5xAL2ReLqShhBzdq
         +iqnXwDRVxtw0Ewj7oCYmGcuZwmAmcEA7dIr43gcyUfudzhxxp3FZRCdkzqgeRkNtn+L
         d6qiOCRZIkk1LCd2AU3RgFMKLgZhVIAgfNQH5GDb/SH2Zoy/L6cGKKxxwki0oTzTDwbX
         dkYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wxnLsY+y7KxAKQJwPXt/psWoOCQobXjWIWQgMudLMZw=;
        fh=Tq8KksEp2ov+BrGQgPEJpM8dZOG+PtkUuMOWXtjz6r4=;
        b=gt3mmvJIcP7S52JBR0zAyJPt7Va5k2RiOKZ8GazGNGZ0ba6/2EkXVMusn0G9JdBv7F
         UpbJTk5QXl5p5x2EmbqTpYmlM7mscXSVq5KSuLAErs507b21QcDQzS99aigFwaUTeuV1
         7IeiHvd4xIt1ICBBMGrarHokE4TyXKfbWf2bSF/0quZkhmULig21MUMtYTbEqEJZLry+
         TyfatKwHf6KHLXbKFVLk6WiMtCjeIFpsvJ2lxpAFqpfDcEMl8vhz6qmP3y+z+g9tWms+
         1jhGlK5X16bp0HYLmzCRWV+4m/Bg437MZBmlHA9w/AaXKVLAOpCCJo2qE1ovfXHWbnTw
         8l4g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1778101832; x=1778706632; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wxnLsY+y7KxAKQJwPXt/psWoOCQobXjWIWQgMudLMZw=;
        b=msuteScuOr/Qjs0YezycrjkPQXqABbCAXTpi++g9FWNtxr972fDX1GuQN8mCht3DtI
         gZYo0yKrU7hRsYcs39AL2nHCTSG9UrX/Jt88wMnQbErINBEuvtQR6bTS10b0qxRyQGcR
         CHKf1tBWK6FOQH9WBvYBGWhVUfWX9HE/MEwoFjRowSPeyQgKVwtzXusYtqEGeDkB4UgS
         qTnYf/YP9oejSbHjM+6jaaybQ4SJ1rFnPE7Z01E4HQ+YsDha1z8NaUPKWd18NJRPVP1d
         hvugMDxkUSv27P2xbt7Eo3zD2Eosnu0vMNvVrMIxUoNDgm0hTwL2J/OoUKXES+UftcCX
         /sLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778101832; x=1778706632;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wxnLsY+y7KxAKQJwPXt/psWoOCQobXjWIWQgMudLMZw=;
        b=QRj2gxKiGHxSvUQLo2nLthO1BLclimztpUOFYqI95A8lbzFPNH8O7l4TnGOLknwUXx
         j5+Al6b05ItcNgO1+BSLBMnxTSIgSwtcWPgiuEDQBenRKc5rvMKWZOZfbDLu2jc44s6u
         ZJxZxnV1zokSzJ+KEtSCejsT1X5JkVAUB73MTwjz5/Fto3+jHFVsG3Wjs7vjCWDf0Zrw
         uGWjmznlsP450bbwSB/mHUi6BBsTD4N2fyWfb6aL0E3egDHTkVodSdvecfARTvRS5JEz
         fPjrPVSknrfRbXT5L6oeUTFTRQiebMXuEg7Ww12+t6wS+GUvC3ccMA1Pfncnic4ytRQG
         aJuw==
X-Forwarded-Encrypted: i=1; AFNElJ/rpubJEU3H7YwTsMAqwa5Ow8RG/sHmhiKEhq858ffQD8Rjt0LgUEru7I5aTLjAAusKo3xhxC02QJ5R@vger.kernel.org
X-Gm-Message-State: AOJu0Yzl7epF4fRCAMud0vyeNTY2BNpJrnpFa4HnW477jnKQDfk2csu5
	ic0C2l3TEmURkIIPbZQ/Z+xCKWVALnXnZYlL2NV/dsQen5B6gOgbp21TceFL8o5ItSN3/8jJRUn
	irHxEP7qV5Y59ZNHZPoxyP9+KdA5nAgCXUOjDQ9S8yYR2SifYbXISmxCWE27GnmoOiTsPyldn6d
	Pmjr9ilxJSsZ7BJzNk6ciiO8FpQLzRrTgGIJlu4Q==
X-Gm-Gg: AeBDieu59/cb/fvRRCiH8XxigqkbG3z1rV/FIirdNEDGu+jcB3lw6km+rt0YXd3q4Ay
	dT3Xyj3j2ZlziSI7ucjLy0soTHJKmVkOvqoEWZD7dnnCMqzwAfQiofOETdht5l+W66FmeBlb1li
	R40CNVq0E6iQBonatxzik0khAsRbf6TTmju1e5sR212o1x1v5DST/jb6BbW7o0zKZAzr1sk+zhm
	uhg2cZRJLqiyNt34zUB+Wq0ezY9r8lGXs5m0t0o3IhqFNFpN5Db7KOWjXLJw4OI53oXc1h4/Os9
	FWWzFw==
X-Received: by 2002:a05:6102:6a92:b0:605:8280:5e6b with SMTP id ada2fe7eead31-630f8fda840mr2980746137.16.1778101832540;
        Wed, 06 May 2026 14:10:32 -0700 (PDT)
X-Received: by 2002:a05:6102:6a92:b0:605:8280:5e6b with SMTP id
 ada2fe7eead31-630f8fda840mr2980722137.16.1778101832091; Wed, 06 May 2026
 14:10:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260429175016.7915-5-djeffery@redhat.com> <20260506182801.GA805231@bhelgaas>
In-Reply-To: <20260506182801.GA805231@bhelgaas>
From: David Jeffery <djeffery@redhat.com>
Date: Wed, 6 May 2026 17:10:19 -0400
X-Gm-Features: AVHnY4IXvba8Tz17dkRY5kRjhQZN70nrQGJ8xeOK7b1DB0TCF0AP8sKV7dUTWys
Message-ID: <CA+-xHTFj_J4r2oqG8cPOU_wx7pChjHt9SgyHzKbTD8+KgeSFXw@mail.gmail.com>
Subject: Re: [PATCH 4/5] PCI: Enable async shutdown support
To: Bjorn Helgaas <helgaas@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Tarun Sahu <tarunsahu@google.com>, 
	Pasha Tatashin <tatashin@google.com>, =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>, 
	Jordan Richards <jordanrichards@google.com>, Ewan Milne <emilne@redhat.com>, 
	John Meneghini <jmeneghi@redhat.com>, "Lombardi, Maurizio" <mlombard@redhat.com>, 
	Stuart Hayes <stuart.w.hayes@gmail.com>, Laurence Oberman <loberman@redhat.com>, 
	Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, 
	John Garry <john.g.garry@oracle.com>, kexec@lists.infradead.org, 
	Pasha Tatashin <pasha.tatashin@soleen.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 6, 2026 at 2:28=E2=80=AFPM Bjorn Helgaas <helgaas@kernel.org> w=
rote:
>
> On Wed, Apr 29, 2026 at 01:50:15PM -0400, David Jeffery wrote:
> > Like its async suspend support, allow PCI device shutdown to be perform=
ed
> > asynchronously to reduce shutdown time.
> >
> > Signed-off-by: David Jeffery <djeffery@redhat.com>
> > Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
> > Tested-by: Laurence Oberman <loberman@redhat.com>
> > Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> > Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>
> Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
>
> I'm concerned about tripping over driver issues, but it's a pretty big
> benefit.  I think it's worth mentioning the "async_shutdown" module
> parameter somewhere in the commit logs and putting an example in
> Documentation/admin-guide/kernel-parameters.txt.

Sure, I can see about adding a document patch to it.

> Might even consider keeping in -next for a cycle+ and targeting v7.3.

I would be happy for it to spend as much time in linux-next as needed
for people to be comfortable with the risk of odd interactions with
all the pci drivers it will indirectly impact.

But I must admit my ignorance with some of the details of linux-next.
Looking at the main code changes, the patchset would seem to want to
go through driver-core to get to linux-next. But as far as indirect
impact, it is the diverse collection of devices and drivers under PCI
which are most affected by the changes. Is there a consensus on how to
steward a patchset like this one into linux-next?

David Jeffery

