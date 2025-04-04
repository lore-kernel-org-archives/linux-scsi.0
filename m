Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40F31917D0;
	Fri,  4 Apr 2025 21:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743802516; cv=none; b=qPlblEvk0O5qEcUcNFRqaMhpGD9FgjTex9J+GjYK5uJ73CSeznKE4Csv1ZMcteYPAoYfX7NLHPC0Ar98A6fwxoBEtWMWhraMhaRXezs/TCygPiYLEv9Ybn2HPiuzqIwHXLne1Yy/gxQJmzZDKPQgnElTKr9cMTDX8jvK+GKK3pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743802516; c=relaxed/simple;
	bh=7aAsYXJn76BOH5AizQYQy2rtX193wdJ2VfE0aGa8tlY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ba16IUdbkhshxGn9PgbM/k27RQsR3pnoG4OyuPiPMgz93UftehW2lFTu45g09VFHC5hTQ1oETg0+u9HwA1VzirPlIba54vVcIxwtZw5wChpCyFzOQxkuFxo0BfD1je7B7bBvTVWBEH5uxEvGEi6HVwZgIoh7/JOUuF+Ql24ZBfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l6VClVHr; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l6VClVHr"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5efe8d9eb1eso4360458a12.0;
        Fri, 04 Apr 2025 14:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743802513; x=1744407313; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CKFyjkTSCgU7gYrqc5tPBVD9dvVp2tHpU5G+1BA5V3s=;
        b=l6VClVHrl1Nj6ChTh2Gu3UnpdF6h1TSNUf/Grr/yhRumM7hUx8ZAxB6HccfkDj9nh0
         +OirLUWH79IdQtU9yfm3HNQzhMF/IeA7Rw9sQnrbjuSRGrkvd3zRYmBoaW0b927gsiJe
         ROdWaqqGCKwFWUrALXv744irwxYZs1GCOi/bKj5fljTNxu7PaZCWEgQgZ2h3TCm3xkLv
         ZlcSfzc61l0JFvwJNrHP6JmYvhlXZu2KRbxOprefO+K+5rwa6CY50+JrdMOD+jzT+tg8
         JjIJaRUq6RpFv19YNcuTMqJj6PD4sMKXPw3d2gy/JuNJvCUYRZuyk/cvc8INKPoIT0Mw
         d3TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743802513; x=1744407313;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CKFyjkTSCgU7gYrqc5tPBVD9dvVp2tHpU5G+1BA5V3s=;
        b=Rhlk9pKIG1xfRLCG2zaA/yxu81817oHTX2FEck8Q/vJjXjNfybPqGk5/FuPzUTQ+Fa
         T9QBD52WhDfhIoVOubHCYM3PH5AvvOwpNQgedRweBQwl2GbaM5ASjyeJMkGyHpSaeb58
         sY+gFcSF36CmPt6Txbg5lo8fqjYjinqzNR1AbIzkJwV8ONG16+txfzKkHTwO/cumDzd+
         pwprpMsjK6u/zTPy8G4j6Vh0f2q9wAmqqwT6nDrapG0H+4K5C9dbQ4exYs+37HLqmXVW
         IhEQqVE7VlQbzdgZICBHteVcUpUvJPpiX6+p2kIBFQyjQyrB1tvLZIaGKRuZ3wmpaCKi
         cH7w==
X-Forwarded-Encrypted: i=1; AJvYcCWc3zuVTZaAY1l7pE1I2AR6Y4jXtuDxZIASvvrmu3Enh10pEjVT2jmhrDSW4zqaU5yZLEY3QL8NBFo/@vger.kernel.org
X-Gm-Message-State: AOJu0YwImaZRhZC1vBXJQnIP4Mx+j4CASMVHiW2HQInLmF3yMoBeHaIS
	U8+fkdU0DmsUeBAlm7i4JZDWe93BtF8lRZg+I8iVs2ZkPV4EThDnaXRLtjJprkZB+npgKYfXfgA
	TWQ5zTSrkv5CWlToug1/CUtyyDlGvyw==
X-Gm-Gg: ASbGncvqLsz+0ApdmeXHlx8cLYCkBhKQlsIlwEmdXB52rLKaRTjjeMpx5Wkg2yeYsGs
	ZnzV2c7L3FxcJ9Ll1WWPgYzgZWRUvYI2pnBlRnWWeYUtxm1tXN4kyc/v/VHY+Qyxd7fTezuWWmI
	Wui74pAwCAF39fqj3QFNJaiIMzFzk=
X-Google-Smtp-Source: AGHT+IEUiYXXXVz3M/wk2rF4Ak40nYDdgka6ADaYEMyFRRSMWvX01xeoA8ZynVIdzt1eYUjZzz1WfMkFkj5VAPEvfm0=
X-Received: by 2002:a05:6402:4021:b0:5ee:498:7898 with SMTP id
 4fb4d7f45d1cf-5f0b2b2b92dmr4555000a12.17.1743802512441; Fri, 04 Apr 2025
 14:35:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+=Fv5TdeQhdrf_L0D89f6+Q0y8TT3NZy0eQzPPjJfj6fqO=oQ@mail.gmail.com>
 <alpine.DEB.2.21.2410300046400.40463@angie.orcam.me.uk> <CA+=Fv5SXrc+esaKmJOC9+vtoxfEo1vOhgfQ739CBzmVcArWT8g@mail.gmail.com>
 <20241030102549.572751ec@samweis> <CA+=Fv5RX-u_X9UgpMg6xzwc_FwLZus7ddJJY8rHMMyUUGc3pxA@mail.gmail.com>
 <alpine.DEB.2.21.2410310517330.40463@angie.orcam.me.uk> <CA+=Fv5Q=eS1O4nwiHkJQRpvZ+JiDncnEZtqCUAyBPf1ZOtkzzA@mail.gmail.com>
 <alpine.DEB.2.21.2410311656400.40463@angie.orcam.me.uk> <Zyh6tP-eWlABiBG7@infradead.org>
 <CA+=Fv5Q_4GLdezetYYySVntE7KBB2d-zhNGR3rXawsvOh_PHAw@mail.gmail.com>
 <alpine.DEB.2.21.2411042136280.9262@angie.orcam.me.uk> <yq15xp25ulu.fsf@ca-mkp.ca.oracle.com>
 <20241105093416.773fb59e@samweis> <alpine.DEB.2.21.2411051226030.9262@angie.orcam.me.uk>
 <CA+=Fv5Q5Q1BUscm2Tua9y1b=2f33+3SkULNwe0gKQpJFL1PLig@mail.gmail.com>
 <20241112145253.7aa5c2ab@samweis> <CA+=Fv5QF7yUQd=CnrrDSwrFVbBC7wGdzXffJV__AjP9TDxqw=A@mail.gmail.com>
 <alpine.DEB.2.21.2411251925410.44939@angie.orcam.me.uk> <CA+=Fv5TVZ7v43EQ8jx7g4RV0n6F6Wb1N83oEbeWnMAQbNQvT5g@mail.gmail.com>
 <CA+=Fv5Sq89wYF3a16omtDUTnbjb23sUY-9ef8KjiEtNp4bv0Hg@mail.gmail.com>
In-Reply-To: <CA+=Fv5Sq89wYF3a16omtDUTnbjb23sUY-9ef8KjiEtNp4bv0Hg@mail.gmail.com>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Fri, 4 Apr 2025 23:35:00 +0200
X-Gm-Features: ATxdqUF5OcoxySdgKQB55QrWcbEkOCqDs4YKIJxOktbR7voQGgjIplmrIWbxQ7E
Message-ID: <CA+=Fv5SsnnZK2-CTXnjsn8b-Hk2_-H0+i3iPNixQhC-7MR1B-A@mail.gmail.com>
Subject: Re: qla1280 driver for qlogic-1040 on alpha
To: linux-alpha@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "Maciej W. Rozycki" <macro@orcam.me.uk>
Content-Type: text/plain; charset="UTF-8"

Hi again,

Here are some updates on my continued experiments with the qla1280 driver
This is what I've concluded so far:

*The ISP1040B 32-bitcard works with 64-bit DMA_MASK on a 21164 Rawhide
machine, hence the card supports DAC, even though the papers on the chip
don't officially claim support until rev C (just as Thomas Bogendoerfer
pointed out earlier).

*The ISP1080 (64-bit pci slot/card) works with 64-bit DMA_MASK  on a
21224 Tsunami machine, hence the monster window works fine on Tsunami.

I've made some tests my ES40 (Tsunami) by first filling the drive attached
to the IPS1040 with letter 'A' by just dd:ing a file containing about 40mb
data, that is "dd if=A.txt of=/dev/sdc bs=1M". Then rebooting and loading
the qla1280 driver with 64-bit DMA_MASK and reading back from 20mb from
/dev/sdc using "dd oflag=direct if=/dev/sdc of=dump.img bs=1M count=20"
I expect to get only the letter A in dump.img.

To put some load on the system I have two processes running in background,
unpacking some tar files. These files are unpacked on another drive
attached to a different controller.

When first running this test I just got some random data in one or more
corrupted blocks but after repeating this a few times I started to
recognize the data in the corrupt blocks. It is as if data from the disk
attached to the ISP1040 controller is interleaved with data coming from
another drive attached to another controller. In this case the text is
from stuff belonging to gcc (which was in the tar file being unpacked on
the other drive/controller at the same time).

Data from one test run:

A total of 57 hits on the monster window, 64kb each, during the test a total
of 20mb was transferred from the disk and a total of about 3600kb was
transferred using DAC/DMA mappings to the monster window. Only 64 bytes were
corrupted. This suggests that DAC works on tsunami with the ISP1040 card
but something else is going on that corrupts data along the way?

The text is part of gcc-stuff that was being written to another disk
on another controller simultaneously (that is, a tar.xz file was expanded)

diff between expected output (AAAA) and actual output:

< 012b4c80: 6325 3e00 253c 616e 6425 3e20 6f66 206d  c%>.%<and%> of m
< 012b4c90: 7574 7561 6c6c 7920 6578 636c 7573 6976  utually exclusiv
< 012b4ca0: 6520 6571 7561 6c2d 7465 7374 7320 6973  e equal-tests is
< 012b4cb0: 2061 6c77 6179 7320 3000 253c 6173 6d25   always 0.%<asm%
---
> 012b4c80: 4141 4141 4141 4141 4141 4141 4141 4141  AAAAAAAAAAAAAAAA
> 012b4c90: 4141 4141 4141 4141 4141 4141 4141 4141  AAAAAAAAAAAAAAAA
> 012b4ca0: 4141 4141 4141 4141 4141 4141 4141 4141  AAAAAAAAAAAAAAAA
> 012b4cb0: 4141 4141 4141 4141 4141 4141 4141 4141  AAAAAAAAAAAAAAAA

The amount of data being corrupted each run varies a lot, from no data
corruption at all to several kilobytes. When data is corrupted it is
always in chunks of 64-bytes, which coincides with the cache block size
on the 21264 processor. It's as if every now and then, there is a cache
block that holds stale data and the data written to memory by the dma
controller is not seen by the cpu? this only happens when DAC DMA is
done to 32-bit cards in a 64-bit slot and DMA_MASK is 64 bit.

I've noticed that most of the DAC DMA requests hitting the "monster window"
are allocated as entries in scatter/gather lists. I'm not sure if I
understand this correctly but according to the "Tsunami/Typhoon 21272
Chipset Hardware Reference Manual" the monster window only supports direct
mapping, and if DAC is to be used in S/G mappings, DMA window-3 should be
used instead. This is not the case in how this is implemented in linux for
the tsunami platform. (see section 10.1.2.1,  10.1.4 and table 10-6).


/Magnus
