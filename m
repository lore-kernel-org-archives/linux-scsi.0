Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0FB48382E
	for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2026 12:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788526682; cv=none; b=C8hhRmAoKOMI6mSaEpFA1gBxHXTtshj5stgxmnuWvFw5tjhV1up8B1gfpJBPT9CMcyh5w7hQVvSrViTSHOUBiNnpFHdC21LlwBLMh5MGbG+mdMHS2Dza2BevIUHRbm4U/ENjgkm041bX7MIRRw35RBqbdoAI1ki2iQ3lgFaEnRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788526682; c=relaxed/simple;
	bh=/u7yvYvbT44iz4P3NSPmATvikZpCTdXLDwh+z6TVtbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZyHAHWeiZe4YvP+IG1+xnClb4CHAtqRmB86vbbpYohannieB+3tcKOciWrmjB7WknxIA7eLVKiZPP6vd5NISz/3h7lMCU28EzCRrGKX5iJRVnPs4UWrFNhhyJwUi0gLYzCRg+Tn3+Z2Xh+wQQEgd3mJEFEnZ5W6Ee4aMgz2Q6dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=p86rS7zq; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p86rS7zq"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38511175ad3so804906a91.2
        for <linux-scsi@vger.kernel.org>; Fri, 04 Sep 2026 05:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788526680; x=1789131480; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=a8cAPX0qoNPrh55TaKC4p5HikxGn38nOetRwDMVXORs=;
        b=p86rS7zqLzrv9BiVCxVoSnJGYC/TJIshaInxtGY7lICrD40aOG4C5JVdCMrxWZ9vXN
         QE+jG7RvA4wqNjnDVIdJ4r5020JQNR+QZJ35K5WUWKaNHd4CZ4d5YzaSMfPT2Tsxww/x
         6pp+C+BgYRd/1qjNJh0UQQYzNrMFRtuO+s53AF1WUM5Rqs7kEfums9bJpbHvyp4Jd3DQ
         Xn7WGl99Qn8qkWsvoLsXgkHr+J8NEnqCIs99IsIBwgHADZcko+Z9tpk6JNU+gkBiGx5F
         4KWqQQLsUmFMaRDck2DI9fqInOqEiDCMNbEOoy9kpQuGMHLTGYLx2SioWHuaUALIu0Z1
         ZU/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788526680; x=1789131480;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a8cAPX0qoNPrh55TaKC4p5HikxGn38nOetRwDMVXORs=;
        b=rwFyl+O24+DWFAUpmEMHM/IOor1bdp4IBYhoGJrygNi+05igEcoX7PH7Wgg0oWFNbW
         HCcBTC5BGGA2UXiN6/JyzAEcKyCyWwMAwabmjuhiKAprQBYkhWFSe8ysYc3BEVC2R4W3
         a+KbmLXktIIH3p5l2JeYx8YsDg4Krzhs4bvGqZ/bGOZI7tqhoc1ldjyihGnO7O35zXJU
         r9Cs+6vPAOTGKb9MwvnG/bmVbwCTF08HXUyl9NgIqoUgPZ6m+KZKmFbLFo+JyoH6YeqJ
         0i32cnkG7VRlEgMIkeXm8UsIXEX7+Rk3es9pbBfQlKTQ2GJ9iUArX5dEwnq43o99YGcH
         +V7Q==
X-Forwarded-Encrypted: i=1; AKwUvBysFEbx7Mr2/HQWifEunhLmk8mgWFTzjdQrB3gv2SbeCb1BaZukxuSweBl96StfR8epKy7YDJrwwO8f@vger.kernel.org
X-Gm-Message-State: AFuF++lh/kwtOnMH2ebzBWii73RyDFM57IZFqoKXnAQ+QxyFLkR+j964
	MUs4+H/bQCKrUj2DkDCuukpJ5FH6IwJY3AoL9s0quYqc/1CpPZ4/Jkhbn2X25j8LyJU=
X-Gm-Gg: AYBFou3ZXWIuew/alElfE2oJiWtPiZhEHVrnh/ln0H6FzeCPui0/bvcBz2qRGSs0fPF
	ypANeJExLhZ8mRrfw/kRuD/kcSbs05GQ2EJou8ReHYUOLPGeucytxI9c8ZKdVauhIACbD3xIVhM
	jwh96DnhZn9cKELOtPsBypEDcD21xg7sF4/yapQ02Ap55Kf+j1iLmnFUNWoURZkcsE8VIE8TEFl
	5XPvtM96z29hGh2u8vpQ39zflJDsm5iOfuklqiampLMAW6q5Q6+Gd1GmWhVAnNMFKeJYwPw/Q0+
	Vv9ioMaMIiWI1T2iHRIfQDSL2Xb9pG7rgK3lFBEPzWH+D2L+MyBjd7agGBG5tAm1A/7xFb/kYdG
	tbc0UbTh73fk9Ap0QOOyVhwVMYp3sl0MnscHnYWv1qaXvAsLks08MnV+JGAfkQU506qn6kzl2CL
	VAeE7JQNzJEn9dU+9Jnokb4J21TFnbOpY4u/9dHof+JjK+/UNutghxyfN4Lprj3c6eCw==
X-Received: by 2002:a17:90b:5866:b0:398:e73e:5a13 with SMTP id 98e67ed59e1d1-39b2613272amr8567041a91.9.1788526680063;
        Fri, 04 Sep 2026 05:58:00 -0700 (PDT)
Received: from [192.168.71.146] ([240e:b8f:91e2:d400:ec2a:b15e:fef8:70a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08c39451sm10720102a91.7.2026.09.04.05.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 05:57:59 -0700 (PDT)
From: Liang Haowen <nbg2974@gmail.com>
To: Lee Jones <lee@kernel.org>
Cc: linux-leds@vger.kernel.org, linux-scsi@vger.kernel.org,
 sashiko-reviews@lists.linux.dev
Subject: Re: [PATCH RFC v2 1/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED
 driver for ROG NVMe enclosures
Date: Fri, 04 Sep 2026 20:45:00 +0800
Message-ID: <202609042045.ReplyLee.lhw@gmail.com>
In-Reply-To: <20260903161357.GX2133376@google.com>
References: <202609012200.RFC0.lhw@gmail.com>
 <202609012200.RFC1.lhw@gmail.com> <202609032000.RFCv2-0.lhw@gmail.com>
 <202609032000.RFCv2-1.lhw@gmail.com>
 <20260901145204.2BF551F000E9@smtp.kernel.org>
 <20260903161357.GX2133376@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 3 Sep 2026, Lee Jones wrote:
> Please review, explain or fix the Sashiko review(s).

Fixed, fixed, fixed, false positive, false positive:

- [High] empty work run writing flash: real. The work now snapshots
  the dirty mask up front and returns before issuing any SCSI command
  when nothing is pending.

- [Medium] name collision between enclosures: real. With the static
  name the LED core would register a second enclosure's LEDs under
  renamed nodes (led0_1) rather than fail, which is still the wrong
  device identity. Names now include the sdev's H:C:T:L, which is
  unique per enclosure.

- [Medium] colour write vs dirty bit ordering: real on weakly ordered
  architectures. A per-zone spinlock now covers the colour cache and
  the mask on both sides.

- [Low] blk_rq_map_kern() argument count: false positive. The current
  signature is (rq, buf, len, gfp); drivers/scsi/scsi_lib.c calls it
  exactly this way from scsi_execute_cmd().

- [Low] kzalloc_obj(): false positive. It is in include/linux/slab.h
  since v7.0.

v3 with the three fixes follows. One question in its cover letter:
whether deferring the Kconfig/Makefile/MAINTAINERS wiring to the
agreed SCSI split is acceptable for the RFC stage.

