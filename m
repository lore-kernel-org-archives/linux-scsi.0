Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC2B146A68
	for <linux-scsi@vger.kernel.org>; Fri,  1 Nov 2024 07:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730445403; cv=none; b=FlMrQ7HFP4yOIBLHKiNpTAwN5qek+tGgHOBkUMuj4uBYn+oQrdMKSw6esErlk7fc8LMwT+k3paitWkjK2P+5BlK11I/XNCWZ6SEGu0t3O5bEu4zjKF54JGZEuuDVyDl7E3HWu+nOJ4gs/T4+PBv/DoU6OaV8vLyYKG7hdhZjzX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730445403; c=relaxed/simple;
	bh=waUbj49118u4i7q+4ovU4pXPxCZS6UmbTpIEMIVVinY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KV4IZ2EG7RPOiy4nCRNrz3Ca80TaAnMEIYIWd9n0Fo3n7gBpdDxyapW4i5iTAyXno2uu7oTo2Si0JpPs0h0HzYrDuInQTRlx4T9+yZko108MNIZeVGZElwPLp3eXfY9IBVFegeXa/h6vm4iu+EwSEq8lTZ6hFHusZc+/ezPIGSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=owltronix.com; spf=none smtp.mailfrom=owltronix.com; dkim=pass (2048-bit key) header.d=owltronix-com.20230601.gappssmtp.com header.i=@owltronix-com.20230601.gappssmtp.com header.b=NZ5YhjI/; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=owltronix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=owltronix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=owltronix-com.20230601.gappssmtp.com header.i=@owltronix-com.20230601.gappssmtp.com header.b="NZ5YhjI/"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5c94c4ad9d8so2279281a12.2
        for <linux-scsi@vger.kernel.org>; Fri, 01 Nov 2024 00:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=owltronix-com.20230601.gappssmtp.com; s=20230601; t=1730445400; x=1731050200; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=waUbj49118u4i7q+4ovU4pXPxCZS6UmbTpIEMIVVinY=;
        b=NZ5YhjI/QzbKbot9LZj/s/PnuoSwE7SDMqcPCeQYuJ+7n6IOBNv31yBBmLvlxktdGZ
         qoIpyid9UUQAzj8HeAF+8TlnFPDDktY5LB165duPAA6hBrruOiSpUKatt4X643kgmito
         HaY3ZSia8eZUDg0fmUMxZvay+k0NUx/S6n1p64fnyA+yW8K4MCtIZSunqrecam4i4keN
         JptqsQK8zGvTOuWP8crEqnp6J4py8WNVVYN6mGLi2FQKkulx7YLI9cBybST+Wa1IKRmN
         whtzItZno0fzo9tPiwsZkJOIZ2Orpt5yt6Dgw79bOo5KKZN3ShH5c8Kd+Fcq0g2qSh85
         AR/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730445400; x=1731050200;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=waUbj49118u4i7q+4ovU4pXPxCZS6UmbTpIEMIVVinY=;
        b=ubUK+H+hGtF6PTJ9CDYifELrYtWmzU3TnAEKw7ThkqQc53hspCn7C/bMyI6Byegu/a
         5brTIA3ko0CP0ED/SJCRy8NzNXJbuhjJMg3uAZXcXdpH/npVorDSs2+41uapkrKNbhVl
         cmzhgZ3T0qOuhI6QunO7L5fa5pmQsJr6gjwWtPm0T7yIEhweeu2VEfpAhHssuKXpm1rJ
         NjDA6jFLAMt6nc3MykCHvYh52n+F1ekbqIfglIGzcqm90TrGt97bSPe5Ob9zUPNjJyMT
         uLIiaGcH2K6Hu5A44SA2l80GdjninFPaZE8QYfNBkL5hKN7srlqSzh7dKtt/593ROZPi
         WNoA==
X-Forwarded-Encrypted: i=1; AJvYcCWVSIhGmQ3YNYn1IWYj2R8LYCug3FDVErS6uLqHjopcnFA3B9FSMgSEB0Pdj/QyGf0Rd81cXwEEbKKt@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1svasXbujunYk878IGVpcBUHGJIdgj3EmHAdhaPFEIG1ej67W
	pd1CMMt1/+C2loXc71g5/sPFShiMqfdSH2+oFtBrL7Pi38RazRO3S5Gfm7s2ymhe7dHYEB1s5km
	y0PahRTdWRb/A/0748ymyp8bINAeczte86zVXiuMeXcSL/PUCchw=
X-Google-Smtp-Source: AGHT+IGPuhXjQfdSyl9CCnBDb8kfQdLr1OP5WRts8Y+TKi58ZMd9VxEJGiFKfBDiAyZu0iCHQTVa3iEX7i7W0CHxx4g=
X-Received: by 2002:a17:907:7e8f:b0:a99:dde6:9f42 with SMTP id
 a640c23a62f3a-a9e50b935bcmr454552666b.47.1730445399842; Fri, 01 Nov 2024
 00:16:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZyEL4FOBMr4H8DGM@kbusch-mbp> <20241030045526.GA32385@lst.de>
 <ZyJTsyDjn6ABVbV0@kbusch-mbp.dhcp.thefacebook.com> <20241030154556.GA4449@lst.de>
 <ZyJVV6R5Ei0UEiVJ@kbusch-mbp.dhcp.thefacebook.com> <20241030155052.GA4984@lst.de>
 <ZyJiEwZwjevelmW2@kbusch-mbp.dhcp.thefacebook.com> <20241030165708.GA11009@lst.de>
 <ZyK0GS33Qhkx3AW-@kbusch-mbp.dhcp.thefacebook.com> <CANr-nt35zoSijRXYr+ommmWGfq0+Ye0tf3SfHfwi0cfpvwB0pg@mail.gmail.com>
 <ZyOO4PojaVIdmlOA@kbusch-mbp.dhcp.thefacebook.com>
In-Reply-To: <ZyOO4PojaVIdmlOA@kbusch-mbp.dhcp.thefacebook.com>
From: Hans Holmberg <hans@owltronix.com>
Date: Fri, 1 Nov 2024 08:16:30 +0100
Message-ID: <CANr-nt30gQzFFsnJt9Tzs1kRDWSj=2w0iTC1qYfu+7JwpszwQQ@mail.gmail.com>
Subject: Re: [PATCHv10 9/9] scsi: set permanent stream count in block limits
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org, joshi.k@samsung.com, 
	javier.gonz@samsung.com, bvanassche@acm.org, Hannes Reinecke <hare@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 31, 2024 at 3:06=E2=80=AFPM Keith Busch <kbusch@kernel.org> wro=
te:
>
> On Thu, Oct 31, 2024 at 09:19:51AM +0100, Hans Holmberg wrote:
> > On Wed, Oct 30, 2024 at 11:33=E2=80=AFPM Keith Busch <kbusch@kernel.org=
> wrote:
> > > That is very much apples-to-oranges. The B+ isn't on the same device
> > > being evaluated for WAF, where this has all that mixed in. I think th=
e
> > > results are pretty good, all things considered.
> >
> > No. The meta data IO is just 0.1% of all writes, so that we use a
> > separate device for that in the benchmark really does not matter.
>
> It's very little spatially, but they overwrite differently than other
> data, creating many small holes in large erase blocks.

I don't really get how this could influence anything significantly.(If at a=
ll).

>
> > Since we can achieve a WAF of ~1 for RocksDB on flash, why should we
> > be content with another 67% of unwanted device side writes on top of
> > that?
> >
> > It's of course impossible to compare your benchmark figures and mine
> > directly since we are using different devices, but hey, we definitely
> > have an opportunity here to make significant gains for FDP if we just
> > provide the right kernel interfaces.
> >
> > Why shouldn't we expose the hardware in a way that enables the users
> > to make the most out of it?
>
> Because the people using this want this interface. Stalling for the last
> 6 months hasn't produced anything better, appealing to non-existent
> vaporware to block something ready-to-go that satisfies a need right
> now is just wasting everyone's time.
>
> Again, I absolutely disagree that this locks anyone in to anything.
> That's an overly dramatic excuse.

Locking in or not, to constructively move things forward (if we are
now stuck on how to wire up fs support) I believe it would be
worthwhile to prototype active fdp data placement in xfs and evaluate
it. Happy to help out with that.

Fdp and zns are different beasts, so I don't expect the results in the
presentation to be directly translatable but we can see what we can
do.

Is RocksDB the only file system user at the moment?
Is the benchmark setup/config something that could be shared?
