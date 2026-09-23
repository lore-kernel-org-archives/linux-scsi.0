Received: from mail-pj2-f42.google.com (mail-pj2-f42.google.com [74.125.227.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC6C40DFDE
	for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2026 10:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790158713; cv=none; b=ZF0N4O3fdbhLXrvBIdN7EombcK4MLEzteZjdREqqEZ7bQhCh257c2iCCyjPQywiiQO7NE17yc7H6fh5RXuFUxngcJi8VrS5txqYgNSU7PqChJlx4uj4qzxBaFxIU2SEeqTagMdUZGJclxDK1rRc3UjAeeODoWq+GDS0GeZhlp4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790158713; c=relaxed/simple;
	bh=Cw4qUCgB4oS+hGjTirBsh6bImAzBppTQD9nONJcjvhw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=f7a6AG593TlxsEXqrxNQ8rusn1SB8oCE1nkHpSDHt7xx89syhOviTXWzOCUwcRx2P96gYd10BFchRq2sDGE3KKj6pntrfMwk1lWxIOzsivctdnhVT2m5xYto7JOqsKAw/WG0jZdABrEFj/X8IZcuZcstC8/zZfKY0zx88iFRiV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H5qJf8Jb; arc=none smtp.client-ip=74.125.227.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H5qJf8Jb"
Received: by mail-pj2-f42.google.com with SMTP id d9443c01a7336-2ddaa08c890so3663615ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2026 03:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790158705; x=1790763505; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=UkEzU1TrVb7LM2qKIN2UAZBeduPofA0aR00sq50xecU=;
        b=H5qJf8JbkJ/nhyNJNcLdTVmxNLPYoWTEqoJU4zyD4QX8sfFxheMAm9UcVHlEhblCkq
         X9zaF52OfHfKAqwvMB6xOo9U+w3lupkAZt8FOxdy7uZ9MDgCSonjgMq04Ozx8rZcJbSg
         A0AO01J+tjA1o5y/ngMyGo4JQt0e9hYfxh9vSWKdSbHJrfQ95UDpKwjrXu+46xiF3CHO
         pCo9UrsHJU5gKVko0Q7+fkvHZUD+AANrxDh2W7HaoFzuzx4FSOqplBqLkh4fyKudx4kF
         3KJiAcPkGd1r7PFpQWal/Sb4raJJU8QVvxOWW87JiC+F16KPY7FtdNAGEOJqbPVVzPHm
         gB+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790158705; x=1790763505;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UkEzU1TrVb7LM2qKIN2UAZBeduPofA0aR00sq50xecU=;
        b=oU9lAaieffoubrSY5pgMnHb0yZlwxYjTrCm40Ji1vGgcEEeYHOZGz3zOCflST2k6oc
         VAKgI7kvoqZsBipDlg+HUAWqxFPXgBqFWFL23r6RtVPOL6DpL4ArK1yC3yQO5J7xeH9D
         QzkuKcJD/w9rt+KpaBbJJcTFVUInNtGPDWdWCeNIlLdT3b7CkDza5NJu18aKCxkRdG4Z
         5fmU3kiTAxjspQ4JherckYVzUBvcYVdPBiQ4W1TPTE+PYfbrkbUuQ+AYYkT9jGlSgNwH
         xLlRODCuQWCzrGEBmZCz3YqF6G3SW+fd6gnSMYv1eTFMRgLNZCMB0yr+fY3bSsMZo+Uf
         3++w==
X-Forwarded-Encrypted: i=1; AKwUvBzpD3uci5bfaNO7rTq81kN+WNLRNtVdrj3XSACDaObgHPao2JOy/SGVt+2GRQXqy2KhCzmqrDLTrjCB@vger.kernel.org
X-Gm-Message-State: AFuF++kWq4+d8oQ40rsTWW5YSFWkI2K66sa4KHwtAUb5gCmzLhnuAXjT
	0xfjxdXeSl3kElOx5vHCTKfUc4OirlxU4vKWjyZyW/0x0ezqO0w5F3Fk
X-Gm-Gg: AYBFou1fRCTePQmsigomJk/oDNaMHbq+dOBjaHwh56vlzKVrpe/Z4hvGEFyGs17x3bq
	gKIT95c30H2DNUGkC5JqvAVP5XwX6/Ny7+F/UmZVKU8TD4HgDnHPStMYOLWLtHw+EP/tPEod7MJ
	wIR+Mez1lvLJF/vgPcT9CY6kQ+qHM/JnYwnOtjkpmrH8Md5pCIHOfweY0u+8/1fFiI63S9oyoq6
	k5f6EPzFKryOuW/9Bbrd4aajZMKqodq9vpmg/42s92Q4uuw6xjRAwdnBn9vLlDD5rUFqzeHxFTd
	sghRXgKzuBhCvCSm9pJPFDnlDKbFjcJr9ALc97XZy2G//7tI/tdPPKmDhOcd4gBWc0DF08s2rHN
	iKufTjRfFk9t+lpwt0c1k/GX0Nm/AycMf2zETVZVwtJyrN6KTLSf4tGDHaOY09HzAXCKEntQigb
	jxEAhTsIBBQMou6MnJeB7Hc5uef79Pf9R60gMqa7nDA0fuCz236VszfTZEYMgZni2HKc2KBbL3W
	gmc0ZUirlWvPwLbPro=
X-Received: by 2002:a17:902:f686:b0:2df:69e3:7395 with SMTP id d9443c01a7336-2df69e374admr18597665ad.18.1790158704340;
        Wed, 23 Sep 2026 03:18:24 -0700 (PDT)
Received: from [127.0.1.1] ([240e:b8f:977f:f400:ec2a:b15e:fef8:70a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df6a5a9516sm8289255ad.29.2026.09.23.03.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 03:18:23 -0700 (PDT)
From: Liang Haowen <nbg2974@gmail.com>
To: Lee Jones <lee@kernel.org>
Cc: linux-leds@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, sashiko-reviews@lists.linux.dev
Subject: Re: [PATCH RFC v6 1/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED
 driver for ROG NVMe enclosures
Date: Wed, 23 Sep 2026 10:18:18 -0000
Message-Id: <202609232015.ReplyLeeR7.lhw@gmail.com>
In-Reply-To: <20260923094539.GA3864833@google.com>
References: <202609012200.RFC0.lhw@gmail.com>
 <202609012200.RFC1.lhw@gmail.com>
 <20260901145204.2BF551F000E9@smtp.kernel.org>
 <202609032000.RFCv2-0.lhw@gmail.com> <202609032000.RFCv2-1.lhw@gmail.com>
 <20260903122408.3CA6B1F00A3A@smtp.kernel.org>
 <20260903161357.GX2133376@google.com> <202609042000.RFCv3-0.lhw@gmail.com>
 <202609042030.RFCv3-1.lhw@gmail.com>
 <20260904131503.355C41F00A3E@smtp.kernel.org>
 <20260910093232.GO2133376@google.com> <202609152112.RFCv4-0.lhw@gmail.com>
 <202609152112.RFCv4-1.lhw@gmail.com>
 <20260915130050.E8CDB1F000FF@smtp.kernel.org>
 <20260916104305.GM11487@google.com> <202609162015.RFCv5-0.lhw@gmail.com>
 <202609162015.RFCv5-1.lhw@gmail.com>
 <20260916122740.921E51F000FF@smtp.kernel.org>
 <20260916130602.GS11487@google.com> <202609162200.RFCv6-0.lhw@gmail.com>
 <202609162200.RFCv6-1.lhw@gmail.com>
 <20260916143832.520721F000FF@smtp.kernel.org>
 <20260917112840.GJ1605367@google.com> <202609172115.ReplyLeeR6.lhw@gmail.com>
 <20260923094539.GA3864833@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Answers inline; v7 follows as its own thread.

> What patch format is this?  How did you submit it?

A hand-rolled Python SMTP script, which is as ill-advised as it
sounds. v7 goes out with git send-email, so the format is the
standard one from here on.

> If the SCSI DH the right approach here?

It is unusual, and it was a pragmatic out-of-tree choice rather than
a design statement. The enclosure exposes a single mass-storage
interface that usb-storage owns, so a USB interface driver cannot
claim it without taking the disk down with it, and hooking the SCSI
bus from a module is not possible without the unexported
scsi_bus_type. The device handler was the one hook that observes the
sdev without claiming it, which keeps the enclosure a normal block
device. For in-tree the plan is the split mentioned in the v6 cover
letter: the SCSI attachment moves under drivers/scsi (notifier or an
exported attach helper, whichever the SCSI side prefers) and the LED
part stays in drivers/leds. Happy to rework the attachment in
whichever form you and the SCSI folks prefer.

> Shouldn't this live in drivers/leds/rgb ?

Yes. v7 moves it to drivers/leds/rgb/leds-asus-aura-scsi.c. It still
has no Kconfig wiring; it is the verified out-of-tree module posted
for the API discussion, as the commit message notes.
