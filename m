Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3BE33E1
	for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 07:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730274780; cv=none; b=iqm96FokhZUu4HBKbboZrememnHq9LcDYFV4af4ffyGx6ddNI7PQT5R18iSlslw7/VJ1UvrrsRFIM/nDIQJ2+kf3e53QBssb07Ge/YS1uEFZciOH0dQtmVc4XVXjPFTpECW7rnpp91lN1Y5mvk3BMCuLce38EH6jskHiuMVi7i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730274780; c=relaxed/simple;
	bh=cr7d20QYe8la2UHE20ib6wDq2yGhVwJZGPeZyarbfzw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p9qnX7McXnkF95pH5feT8v2box9MrEe8gQ7K4MnbFiQ8CXEOUbogA97l/UeZzordR+ZUhPyTiC01xCcpRuZKMYnoY0dFQGMyJDotbzTUjYRvPrRk/BYUpLD9I/2/qcFwDmr2EopJ/3w6PT/UNuUIcPNPSosvfA6uYB68DRATvTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MeeQMQ1J; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MeeQMQ1J"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2fb5a9c7420so59838131fa.3
        for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 00:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730274776; x=1730879576; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cr7d20QYe8la2UHE20ib6wDq2yGhVwJZGPeZyarbfzw=;
        b=MeeQMQ1JNM/w0g9kOQQZ/+NkD66EVPAGE6g5FJGeC9qmfJ6PfDRe44iDIjNtcc5kE9
         idXVQ4HFRSJ+WuuhoVGjXQGYsldr6ZySX7rh8qJVnl8L7sAhAg031zU61j8VtcqsJJyx
         ONx6dPZuB0/8Vib1Tzw5nwiKuh/fhfDKzTSBUW98IF1LMAb26emhImlj91kQ/yg+tX25
         YEfv4j7GSaTzUy/y+5cakvH+iBxIz+tLoABMb0baqqP66llm2CHSNbXnwLg6eznaBy3y
         DRegIJW/bbY7yL0Ss1aypse7iaQrGQxX2VdXKcqbVQykqVgCpcZwB/QrRqA6Fu/FlqCv
         VHqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730274776; x=1730879576;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cr7d20QYe8la2UHE20ib6wDq2yGhVwJZGPeZyarbfzw=;
        b=ik8U/Q53HHlCCx+e1Qq0UX2bAfs2Dhp64wBHeNQ+dhCZNw3VKcJr67ZlBdmXNXSGld
         p00t0/Lmp9QRSQarY4nqKFLYUHWsw4sTQlscOsGysU53CMbgim0XTUhHGOLX3hKfpES0
         +Nah/V+BEQRmM/DYXrhg1ZQ2JXid5fTNVlDF85/30EhgifMPXPKbhrRpcgq+NQrSNqjc
         4AtcV6w10veNM+Ht+lvsBsvT7yh8Klz2umYzsXObSLDfkom8sqp8qUilJbwGHUujsHaK
         1a2zt7N3XbfshdqWxrYHOj5pS1FrqX8QP4EJdazlO+x6yuc12B+2EmLDfrshBbjovFu9
         laVg==
X-Forwarded-Encrypted: i=1; AJvYcCVf6eHNlK58K5LU5B1UdN+lElCWI6B9SoDiLzSszIPXzDDo7vnZRoFrSCmR34fIa3Woj4u60BzvhAxa@vger.kernel.org
X-Gm-Message-State: AOJu0YzR+zS8JLrVer9zxsuk/XRlYwlz+YxxBa5gSOFxXiZ8c6JvBF7G
	SfuFUw25sE1WfCdDSGpocAxvhuRB4+fiYOd6ZH7MP+dVmd3+PPyWOBa3cAWmnqQaEhigf+3aOrV
	Y3QDf3faIUxzdrttr90b3Au+I8xM=
X-Google-Smtp-Source: AGHT+IFRz2opSU+RfzOAvFN2pLI7mbnnWn3yrgVwoeKYt3TlbNyXmWNfEMbSmXRvAXOV4NDN6IVu/R53FkHO/61Id5g=
X-Received: by 2002:a2e:a552:0:b0:2fb:34dc:7beb with SMTP id
 38308e7fff4ca-2fcbdf8e049mr75006251fa.12.1730274776071; Wed, 30 Oct 2024
 00:52:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+=Fv5QXiwWd+v9vHo89X_H94+P5OsT_0MEs_8dRAYJawWpy1w@mail.gmail.com>
 <yq15xpgdl6j.fsf@ca-mkp.ca.oracle.com> <CA+=Fv5TdeQhdrf_L0D89f6+Q0y8TT3NZy0eQzPPjJfj6fqO=oQ@mail.gmail.com>
 <CA+=Fv5R1c+JCkFFUvY-9=x61FZnks9GOteKETpo2FJV5u3kFzg@mail.gmail.com>
 <yq18qu7d5jy.fsf@ca-mkp.ca.oracle.com> <alpine.DEB.2.21.2410300046400.40463@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2410300046400.40463@angie.orcam.me.uk>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Wed, 30 Oct 2024 08:52:44 +0100
Message-ID: <CA+=Fv5SXrc+esaKmJOC9+vtoxfEo1vOhgfQ739CBzmVcArWT8g@mail.gmail.com>
Subject: Re: qla1280 driver for qlogic-1040 on alpha
To: "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

I've found a few datasheets from qlogic, on ISP1040x, ISP1080 and
ISP10160. The ISP1040 doesn't mention any 64-bit capabilities in the
chip.
This first appears on the ISP1080 and higher. This information is
consistent with what I find in trial and error tests on my ES40.
Once bus addresses go beyond 32-bits in allocating space for
S/G-buffers, I start seeing file system corruption with the
ISP1040-cards.
Thats said, according to the datasheet for the ISP1040 the chip
conforms to the PCI 2.1 specifications, which has "64-Bit Bus
Extension Pins" as optional
for DAC commands and REQ64# and ACK64#. This capability is never
mentioned in the datasheet and there are no pins for REQ64 or ACK64 on
the chip,
they appear in later ships (1080 and onwards). In the qla1280.c driver
there is an enable_64_bit_addressing in NVRAM for 1040 cards, but when
I look at
the NetBSD driver for the same card, this feature is only available in
ISP1080 cards and higher. So there seems to be some inconsistency
here.

Magnus
