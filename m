Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB781494B2
	for <linux-scsi@vger.kernel.org>; Thu, 18 Apr 2024 16:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713458772; cv=none; b=d4cfkZzmppVj1EQvjEJZChw8hsoykUUjW3zri54lNEwRkFnJ5SVYMuWRKl7XOTORIJjLTgYD1C7AWRYnIRtxwD4q0njguw7EX1gvtPVuJJ2SKe3BdXNx3n41obaruc2O0gH+qjd4WmDxbfMZgKYLyjNrqgI1li0jhYk5iw9n5Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713458772; c=relaxed/simple;
	bh=mnbNI4A8omhTtUuBrbKbgm+6VGX+vavsdpzywW1eV9I=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=o7rgAHJjPXxNMVqkZX54s6Fdu3HQA99Jml2+PZbfCadMWOYC581HRJOQgq6T2IFAUTzKWOEgUN4uH2MuqmLAw8SvNHVUPWd4XSAE4VoBcDcLBADFKsS5yHxqxeaJ+8evBQKSQgzXi8gC4xiv+PJcjqKauVTWPw2YQdnlAl1OAHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WnzrtFpJ; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WnzrtFpJ"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2da08b06e0dso13062481fa.2
        for <linux-scsi@vger.kernel.org>; Thu, 18 Apr 2024 09:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1713458768; x=1714063568; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mnbNI4A8omhTtUuBrbKbgm+6VGX+vavsdpzywW1eV9I=;
        b=WnzrtFpJktIyW2uIwaiALcVMnDuqusC7L1u2slomk+ATjWupTE0oap0HnXy6P9/pjA
         MwPuijfQbkl9I9/zYetX73njEN1K+wicDAZFEQ06T4cR38hvk79uo3NLSYikxodZYcI5
         fCzPgnK6mxfWCqaQsIdTRfpwFkvNxLg+lSOulK9j33p0zdG5k61FgUUWBa+CWgM6Mvit
         XBGeiax9OuDvGT2d6q/OQdlHWTl4JnqE1he8nAYZ1olT3ixt/7TJf6BNbBNVwfW/EFsJ
         GP9A3AUtOuMEIGsO8gfIt0GEh71Umm6kgVeGq2DrgmdVZnvKwSoHRhwzmPrLWywMoIyy
         uqwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713458768; x=1714063568;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mnbNI4A8omhTtUuBrbKbgm+6VGX+vavsdpzywW1eV9I=;
        b=e40VLx3XOkWETgeE/hWomHcwYSMhpmELrv+d23QgtrUeWxLYiYwyiIaZGalrq1kgf2
         uWN8OSYdp4ygquPp+oeCHW2sK19DLqMlTpsgsN+XYd1IJSVtg5/PKPOSHb0qdC3dGhJ3
         ObGeRFsxTDwy9bon9LVMPkVuA+ToQF40pHNes0pHffwF/tiy0Kztw2IcDAAQLfny9qeu
         pQ8Vjf+pr7ontpYMuNQd259V7QlRnRoa9oaGL3f2o2gpOtWWPAnEGJpoOkvCnTA51BgS
         R6rteMaw/4blsEgB/ik5bTEq1//AvaLel0Ah6Xve85PaS7S0aJFAiE9XM4bKzwRlqOq5
         NXBQ==
X-Forwarded-Encrypted: i=1; AJvYcCXTC5Pv0H1xttPTbPt5BZ30sB5lVCVkc7bnUGxA22CU2bYnM9EqHlFHSsY4GQc2hnFCK0mCiju+NYOAqbqNP5423U1TdjHX0UOenQ==
X-Gm-Message-State: AOJu0YxehQITeyvXXHKbV09gm7HsMjr1xi3IrFRrHoqVhjzwDKoYFLMd
	rlAPMqmqskGM9pKUTNx6g82igdq9qg5l/QM0+wPxxPG11/8Ncum2F2LqyPjcam9pEQBV2hVMW+l
	d
X-Google-Smtp-Source: AGHT+IEYRazztb0arGNpRpIkgyoS8pt84EcM69XofgCehtuPMUucx3REFI5xuxFRTserFMH3rBXNow==
X-Received: by 2002:a2e:9582:0:b0:2d9:fb60:2332 with SMTP id w2-20020a2e9582000000b002d9fb602332mr1721087ljh.45.1713458768208;
        Thu, 18 Apr 2024 09:46:08 -0700 (PDT)
Received: from apollon.wilcks.net (dslb-090-186-231-154.090.186.pools.vodafone-ip.de. [90.186.231.154])
        by smtp.gmail.com with ESMTPSA id w12-20020a056402128c00b005701550ddc5sm1070304edv.90.2024.04.18.09.46.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Apr 2024 09:46:07 -0700 (PDT)
Message-ID: <410750a52af76fdc3bcf6265c9036037cb8141da.camel@suse.com>
Subject: Re: [PATCH] scsi_lib: Align max_sectors to kb
From: Martin Wilck <martin.wilck@suse.com>
To: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Cc: Hannes Reinecke <hare@kernel.org>, "Martin K. Petersen"
	 <martin.petersen@oracle.com>, James Bottomley
	 <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org
Date: Thu, 18 Apr 2024 18:46:06 +0200
In-Reply-To: <20240418145129.GA32025@lst.de>
References: <20240418070015.27781-1-hare@kernel.org>
	 <20240418070304.GA26607@lst.de>
	 <5707dfc3-f8e2-4050-9bba-029facc32ca9@suse.de>
	 <20240418145129.GA32025@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.0 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2024-04-18 at 16:51 +0200, Christoph Hellwig wrote:
>=20
> > > Note that we really should not stack max_sectors anyway, as it's
> > > only
> > > used for splitting in the lower device to start with.
> >=20
> > If that's the case, why don't we inhibit the modification for
> > max_sectors=20
> > on the lower devices?
>=20
> Why would we?=C2=A0 It makes absolutly no sense to inherit these limits,
> the lower device will split anyway which is very much the point of
> the immutable bio_vec work.
>=20

Sorry, I don't follow. With (request-based) dm-multipath on top of
SCSI, we hit the "over max size limit" condition in
blk_insert_cloned_request() [1], which will cause IO to fail at the dm
level. So at least in this configuration, it's crucial that the upper
device inherit the lower device's limits.

Regards,
Martin

[1] https://elixir.bootlin.com/linux/latest/source/block/blk-mq.c#L3048

