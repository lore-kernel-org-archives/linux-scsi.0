Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775FD22FE18;
	Mon,  1 Sep 2025 21:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756762916; cv=none; b=Bfmlw8JcAaSskThMql2YXLx+DM1KTFmXwWQbtFtOqDzDTiQx66RJ+1MvDl8RTjfNnZ4J9THKyX9OVw4UBz4XPgqaglp9N0WfzFXF8TOWWZBd//M/NAugfWGOk6Gr7YZl6pct1h6lTQqsuPaKgbMD9HYnbY0rGy4yTEU01rDoWPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756762916; c=relaxed/simple;
	bh=lqAsxVN8esNlj7zuyk9BoJWQsdCAllz+VcYWaymWJpQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Naxwj5czsQURfNI49YiCYpp8bBjVJJkd3pITwqU+lZxZTd1aObyAthc27YmU5TGwRyKqGKI4UC5FT9i6z4R14Wy1P7h2+1PJ0gjDj4XJ4ql5ks8ArXTy69N8Re7GmlRGEg6NU3shU+OWUFvLf9a5hGnXGjTfyH573zYCOw7WtdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FfS3Ejv/; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FfS3Ejv/"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-61cf8280f02so5096474a12.0;
        Mon, 01 Sep 2025 14:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756762913; x=1757367713; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bObIG6hbz8i815o0CAvkZBfrxIXvHs9F3PjwpTRGK7o=;
        b=FfS3Ejv/OFXnsEJyg7+Wmr1SU1egd0Csku55p7D/Pdhebt/ai4HE1iFwSne8t3tPt4
         2aCGInJZmhftCplPmzdBNNP3IKuLnwKQl3jF4YB6GkaIAFO69mMgWUBn6wX6fy0K0iid
         r5NeoaMPGApectiCb7VRZ7Ry/GI2SwFyBWKGXn48/lGBUVK6G4UhC0yEuHymovaTK1eL
         OymW44BgXlzxapq6N37KaQ7BmHncv87MgsA1L+JEZxlPXDO65NoPRtXV6XI1jcDXptZV
         SqVrxyNESvl9vkA1nAFB5eqVqUQyi5MQYQpEh2/wKubsZbO9Fm+n+GZpsw4onj1nMI22
         fhrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756762913; x=1757367713;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bObIG6hbz8i815o0CAvkZBfrxIXvHs9F3PjwpTRGK7o=;
        b=ICifNQSv+ZIZ95TH/ptNCUUQV5CM/n1RR+DH/1BGfB71e79KLBqSnGfrKAPC6ieTQy
         ar+08ZluI7VU82O1DNSBL+iXsufUn32EXGac/ITR7TLY2U5denqvWaTotI7CFft1sfKv
         k5bMH+WCRsbsIXdpkEvHTqtIYWg3U+slVzLzH3wxyyI2jdNpTpjBqIw+tTCgtKj/+OZg
         UCN6bveYkSBgxF0229Lr6S0hgKfIeTAvpu0Jfo6EJEEw/aekUnMQePcRbxK4eOz38v0q
         sGXXWGCUlShBlD6rqb/jlSHkmW14xkfSGW1uKAiTH+BSaXZNnYtqURLSS6b+dMETRD4T
         6PHQ==
X-Forwarded-Encrypted: i=1; AJvYcCUs7JoieQDn42ojmJ46hbNK406CfIFNCjawrocMe2ZP0pj6OaJOmqYgxSIxDmduYv0LFOIM73EXMacz+A==@vger.kernel.org, AJvYcCWF2Ryl8rDxvVMhJxhfebFH0ie8Tdu30pG/4C2NeYaqpLUVWoyEf5mLrbmGURuEXg+SnA8LB5fkccqfrg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7x8w3MBnwqMghJ6VbseT6z6f20FnPGDBLFK6VdZxAGqDoen19
	rCDp6HzDjUSnuaXkw8CFjevPoSxfaYbOZTzAYwxQki7oE0nP1+0lvlHU76TX6UgrDofRsNXEZMs
	go5KXvBELoH0cbmhjHbnhWN1jRoCRDvQ=
X-Gm-Gg: ASbGncu4qDaeWfpUjZuT7rY0i9jTzuDHD5xOQ53Nn7fgD3kkiDm+pdC3XA9UQ/ERZ8v
	VIM9Ekg/NTDQJ9CPWtK7l/UW95TNU5iCRe8QLJH2nbENcSlK1nPz3fsGhVoYZoaqB779I2PN7TC
	PoNOFYA9qvMHLXtWZSCxxEfF6qGU3zToCczPxg8ySAlgIF4kbHCPKedvBFk2o+mYSinMZyZmts1
	WglUBVesc6sS3XxAa4=
X-Google-Smtp-Source: AGHT+IFjZmaPKoPQcXDGfF/kV1IP9uFU1Wv2mkfLSbSa6IhmowhwufpcDeP30Fu2i1LBz23Ff2FFDH8N8TzSkKHWIco=
X-Received: by 2002:a05:6402:3508:b0:61c:30cf:885a with SMTP id
 4fb4d7f45d1cf-61d2686a2b1mr9013843a12.7.1756762912523; Mon, 01 Sep 2025
 14:41:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250728163752.9778-1-linmag7@gmail.com> <alpine.DEB.2.21.2507291750390.5060@angie.orcam.me.uk>
 <CA+=Fv5TJRpFJ=p1MLcORDaqnSG-0AUEtSUw3Kek0vPGKbQZT9g@mail.gmail.com>
In-Reply-To: <CA+=Fv5TJRpFJ=p1MLcORDaqnSG-0AUEtSUw3Kek0vPGKbQZT9g@mail.gmail.com>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Mon, 1 Sep 2025 23:41:41 +0200
X-Gm-Features: Ac12FXwEn4h8KFioy4gm04oCGmHsT0V4q3Qz4SLvH-ToJAxH82DDnje25_EBIdc
Message-ID: <CA+=Fv5QmqAFLyToOsCKzgWSdnMXGr7FjeW_fO5reTUgJJP27Sg@mail.gmail.com>
Subject: Re: [PATCH 0/1] scsi: qla1280: Make 64-bit DMA addressing a Kconfig option
To: "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-alpha@vger.kernel.org, martin.petersen@oracle.com, 
	James.Bottomley@hansenpartnership.com, hch@infradead.org
Content-Type: text/plain; charset="UTF-8"

Hi,

> >  If it turns out a generic issue with DAC handling in the Tsunami chipset,
> > then a better approach would be a generic workaround for all potentially
> > affected devices, but it does not appear we have existing infrastructure
> > for that.  Just setting the global DMA mask would unnecessarily cripple
> > 64-bit option cards as well, but it seems to me there might be something
> > relevant in arch/mips/pci/fixup-sb1250.c; see `quirk_sb1250_pci_dac' and
> > the comments above it.

I've been taking a closer look at the quirk_sb1250_pci_dac. It should indeed
be possible to implement a similar workaround on Alpha. I believe that would
require some fixes to the Alpha specific implementations in pci_iommu.c. For
one thing, the implementation does not respect 'dev->bus_dma_limit' which
is used in  the quirk_sb1250_pci_dac implementation.

I've put together a patch, and I'm testing it right now, that implements a quirk
similar to quirk_sb1250_pci_dac as well as makes stuff in pci_iommu.c take
'dev->bus_dma_limit' into consideration on Alpha. If this approach makes
sense I'll put out a new patch for review. Since this approach does not
touch the qla1280 SCSI driver, I won't send it to the linux-scsi list.

Regards

Magnus
