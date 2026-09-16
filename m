Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28584BD108
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 12:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789560937; cv=none; b=ne72K3Tf11CGjRDBG1dinYA1neXXwLVzD56nX8iTNmAgoZUssGXrBiWdgzYbbcHgHAOwIPckSNWG1KDLNoENFhsoinTNy4t5Kiwmz5EPvE2VuFS0dOCM4JRg6lox+a0dS0b0OGp7la0FBoGm4li6bXiuTTdU2HOfrKkT10I1YHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789560937; c=relaxed/simple;
	bh=mKSCs4efO4oPsuBT2TQVVQpT0G+dF938WzWWznsLPTg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=hi4voBA/QIall9FkaX/j7wWHWUGmaZ0zCJoclbWD5UqJ5GBfkh3yXA/BGZQDLzXUYsl3xV24xGpdRBQeArH5XNqLL7H0GpdYbzkSMOwzjeZyUeISpFSAN7Qe3QLA/kNpP7Xnr/Mh1oEiDWXo8R3lqLlf7TqAf1nsZxxE8WnuGQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mBxN7Q85; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mBxN7Q85"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cc147d86bebso2842672a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 05:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789560935; x=1790165735; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=mKSCs4efO4oPsuBT2TQVVQpT0G+dF938WzWWznsLPTg=;
        b=mBxN7Q856FQQK0Kas+Nkluy4tWlVrpKis1oDtUSwfx28Y8N6polsasRDb10/K/BL14
         skqkiO2MEHvXdz4/JRgRhu/QR1+dHfzns/QrLe/e0VVNJpCEX42F24m6ECJeVFYs67hT
         sg4RnF1UH91AvNWM3NuC0kxlX3cl50ElwC8SXIksV/pcdsfsWActIgn4+KbfDRkUtsHG
         mUIXcIIoE8HrNfnobSirKa25oM8D0OKakbW//5lSjP8/Z2GMyBjw2v7iCuXrhlEr4nMj
         K1iOjjFeJGvaciqwj0HCBhB+7FDhZ8YG9HP3wxzl2I+M0CxxBdcHSjjpXe8BBlMtgMgk
         tW+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789560935; x=1790165735;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mKSCs4efO4oPsuBT2TQVVQpT0G+dF938WzWWznsLPTg=;
        b=Slxi2YME7mGIpP6kkN5ACMEktU6VvWlpdMZDHUCT68LFIR2qsUCmAxbY9iTeiqSgWi
         sTzofhnGk0e4VgtEiM6f+OYnqaTI0QpBiGZQ+Yz4uGIxMUdkS8XEGQm/lYBYSAjMamw5
         4EijunccZolwVLzluRtJRVPFDPhRXXQ5Hf8QsgtDbLd3Bv1lpmD1Qmo0q02mhMKRIJcU
         WX9WAWO9vW5yFOshmf4uxLB0gLxmSoW8R1aILaKb3XKDso0iLJOPbD72+uVU95nQ/iOb
         v+FUCZENZCxckWwTIfJlXUU+mXoqBnWRb1zfh72dc9Sg4gioXuNZpdYQYFn9dWorR4ST
         vi8A==
X-Forwarded-Encrypted: i=1; AKwUvBy9N9IwKci95VBPK/fD54rgcCDNJS7x4iPCHCLFFO0nOyAr7TJ6Zias97upMuRigw1Cn63GZZ26XdYR@vger.kernel.org
X-Gm-Message-State: AFuF++ks5uplBJl8ZmVA03ZTiQ9ax7kdaEznPGpDkI8bh3253SKS+E78
	MgjdlmLfs+ZmC0mNK7NLqdiJQlvPKlF82c9XFhpem6kZNiiVC2kThyvq/I4aNd+PDhx1Tg==
X-Gm-Gg: AYBFou3MVRzvvroytoZVItzLObOEQc7A6hewunrvTyDjrYq1TmLeq4+s+bypaFgT8Hv
	FRjmnCiTgDP5yMMDldR73x7nn1hBjEkCPXEABCkXuYKynvWnrWnmJfh74XRvRJCJyufSIvnzT3Q
	WOlSLSQ099AGW33uDDIcNadNRZRn7SrfYlV9DLps+kCz+DKGBcOfW0HAUs7icF9zZEH9j+mnkTl
	6DZOo9pRKnXbxPofHjiSk9MNBoLIIZfHK/d0E6N1CMdwOIvSdMPFJi2SuxHwbqUAPrUtIvR6O/H
	WWICdWe8okdXPm5aatSK6fXzmruomwNSkVMmeNjHVwpyVkSErvbm4noW3Nmov9Ak2grRNpMl3gX
	cSFsc96AVp9W3nzPwSvQ0VToUUm1vE2jwV6sTghFQrP2RS1cxtYwDB31TnlQBAqNmmxm2un7lIT
	1hL+U9LnXhq1eabbE6nCpq25qiv7cu/SOlw48GoCqqYfZCmjF7nxSvCcEujXa/VZ9/CX3qNA==
X-Received: by 2002:a05:6a21:6da4:b0:3da:eff0:c162 with SMTP id adf61e73a8af0-3db4fa37105mr11544412637.6.1789560934398;
        Wed, 16 Sep 2026 05:15:34 -0700 (PDT)
Received: from [127.0.1.1] ([240e:b8f:977f:f400:ec2a:b15e:fef8:70a])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc50ab8ae01sm1512489a12.18.2026.09.16.05.15.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 05:15:33 -0700 (PDT)
From: Liang Haowen <nbg2974@gmail.com>
To: Lee Jones <lee@kernel.org>
Cc: linux-leds@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, sashiko-reviews@lists.linux.dev
Subject: Re: [PATCH RFC v4 1/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED
 driver for ROG NVMe enclosures
Date: Wed, 16 Sep 2026 12:15:31 -0000
Message-Id: <202609162015.ReplyLee0916.lhw@gmail.com>
In-Reply-To: <20260916104305.GM11487@google.com>
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
 <20260916104305.GM11487@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

On the three sashiko items: the Medium one was a real race.
led_mc_calc_color_components() writes the shared subled_info array
outside the zone lock, and concurrent brightness_set callbacks for
the same LED could cache a mix of each other's colours. v5 moves it
under the spinlock; v5 goes out as its own thread.

The two Low items are false positives, and the same two the bot has
now reported in all four rounds: kzalloc_obj() has been in
include/linux/slab.h since v7.0 (this driver builds against 7.2), and
blk_rq_map_kern() takes four arguments on current kernels, called
exactly this way from scsi_execute_cmd() in drivers/scsi/scsi_lib.c.
The five-argument form it keeps describing is from older trees. The
bot's reference tree looks outdated; can these two be retired from
further rounds?
