Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478FA47010E
	for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2026 12:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788526705; cv=none; b=hWhg13ahQafCbq5iM9xZMI9zH74W3BesdYl86mWSBluyPx3EQVSBarE9NMlw4HMOSUCdcGoBOlbrNuOl09c+0e56gVTwmZ0DlTuuFK68KzszXcoLYmnS6U6sOl2JRWV/sSOTCVlqwO8vuZzI2CnRodrKD+6YgwHKdR/IkBvoqj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788526705; c=relaxed/simple;
	bh=cCuX7FMkuujlh8KTWY7B8123d39B4VIE+RHbUgsJPSk=;
	h=Subject:Date:Message-ID:In-Reply-To:References:From:To:Cc:
	 Content-Type:MIME-Version; b=EVzCyGZ3/ZzhO4OyI+wxWCHudb2zbR8SqphUHdEwv2dP2DuwNDudAfmHoOoXGAAkAX6gUf2EFB8acmeyTCVyfz/yA1PxrmoDz8P+DpTcI+YWt/2z6sJBx3OWdAAQNyuWIszVeF4tBFSnk8TqlH4lnM4k2K86i+qYpEdHIisyyc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gxiV/j5T; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gxiV/j5T"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-398c1101c1bso904918a91.1
        for <linux-scsi@vger.kernel.org>; Fri, 04 Sep 2026 05:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788526704; x=1789131504; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:cc:to:from
         :references:in-reply-to:message-id:date:subject:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9bWaEpbYczqmpAF8FqbPFC0CpOYdx3s0fK3rkQDcOds=;
        b=gxiV/j5TlcPks4e1At/lTl2RklYTEzP+JGSiFj81rrO1vwpIwV4Ki05PUiD21jnIyh
         JVu7+cQhbldqyDmIVADOxF2J81VcUPcayOAFaqimVjh1KKtXki2v2lpKtuUN9zgSQRfg
         ZeTz42KgLYwfHuzITDkLUSzz3b+Ow1EDeR5PHauqMNbgeOqswDNTNNf3unbxZU8Po7c4
         pylZha6Y+JmtWEY5w4RM3UdOseXtNX03wzICvTA+GLUurYo87kV44lUEJAu4HUX5qhgj
         KeYtwB2D4W46j+VTMKFZyNEfO08sXOUoApMLbfRnK0x6mJNRV+RDgmNs0DqAS8xlOfny
         slhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788526704; x=1789131504;
        h=mime-version:content-transfer-encoding:content-type:cc:to:from
         :references:in-reply-to:message-id:date:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9bWaEpbYczqmpAF8FqbPFC0CpOYdx3s0fK3rkQDcOds=;
        b=TM3rMqj95guUOPZVQiZ7HEnTlFb+uFiE5QA8on/ziTKU6sXyPHE5jXS4OFSh/ZqxTz
         H/2PHKgdW58vIQp7N9cjZWNdXJNoiTFP22FGKZ4TGjZHrPFf9qDqJvdF2tf9dnySkG1h
         a10D/sOEoXu90DFfR0kHawzufdKqx/R38OlmmuFASJAqCpzJ8AFpTzBkCvemejx88K7K
         yWZgR8SC6LTVLK0uToSBHGPP7Ksm2M29GWVPsLarQgWaJiV5ltmrbPaRtj5jz7GqlD7D
         pzdwsYaW/fgo84cYVqHcqVm6SNXF6bq0u0aKYNVp8inSWJ6o3dqt+EGtJNYsNSWvNdK5
         mUUg==
X-Forwarded-Encrypted: i=1; AKwUvBx5l3LfUgkV6bvJHcU4KWFypoZzBmvegHKgXyGIo7xHOstloi/i961u60rslx7W0UOrN9MmcEpls24C@vger.kernel.org
X-Gm-Message-State: AFuF++nUiOYMxf0i/6ZYV3sk4nHpJ1DLw3WxvcNSF9aY4+H4Qhq3BbAE
	0wZx1DsJ9sXpfFuxi9BeqlY/YQrmmmKqV1cHcadf7Y6DELyaNByiM9m7EOw/Ed64VRM=
X-Gm-Gg: AYBFou3WTto/eUHf9LOVWchLZeAmBWatXkibbIQgtGR+ot0IbNerkGifqrN3h57nyS1
	vT2yaCtRhkKMR61myMDiwC1dyymMksPDGJTqzMwLVVHLseLb8Ejug6rTw6iWKozdUzyUj/d7741
	8hBOtGzxrXmexzXcbFiTycd16DIY/6NrxIgBhKDHphlhKnld9yWHcaRL7Ell6Bvndtzvsy0owI2
	oczQRYzF2feGZlX/zqItuuuMgNWe00MpVQa4J+h1+pGaOESAQt3AePHPByFLVh5SAWS8l/FhMKc
	qgCmfx5T7A4hOk1dW2et6trvqulKKEyPmeVe/Za5cnpoWoIK/MfThz5wFCOp5mES5HDg74M1uWn
	kc55LmoaFLjFHhVm0OB/fTLbUqqgQgbE/tFM4siTXRmDAo2XYw4KvzxfXugqjLCOr5paEnadjCy
	D8rZ/8h+0aJCJCJEi/yyQsNWFK/AKR/IziL2w0PeLbwBjBZEybdWDe+JtrtcByzmuY6w==
X-Received: by 2002:a17:90b:4d87:b0:380:540:d499 with SMTP id 98e67ed59e1d1-39b26100bfdmr7942191a91.6.1788526703452;
        Fri, 04 Sep 2026 05:58:23 -0700 (PDT)
Received: from [192.168.71.146] ([240e:b8f:91e2:d400:ec2a:b15e:fef8:70a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b260cd2aasm4492886a91.3.2026.09.04.05.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 05:58:22 -0700 (PDT)
Subject: [PATCH RFC v3 0/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED driver
 for ROG NVMe enclosures
Date: Fri, 04 Sep 2026 20:30:00 +0800
Message-ID: <202609042000.RFCv3-0.lhw@gmail.com>
In-Reply-To: <20260903161357.GX2133376@google.com>
References: <202609012200.RFC0.lhw@gmail.com>
 <202609012200.RFC1.lhw@gmail.com> <202609032000.RFCv2-0.lhw@gmail.com>
 <202609032000.RFCv2-1.lhw@gmail.com> <20260903161357.GX2133376@google.com>
From: Liang Haowen <nbg2974@gmail.com>
To: linux-leds@vger.kernel.org
Cc: Lee Jones <lee@kernel.org>, Pavel Machek <pavel@kernel.org>,
 Martin K. Petersen <mkp@kernel.org>, linux-scsi@vger.kernel.org,
 platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
 Denis Benato <denis.benato@linux.dev>, Armin Wolf <W_Armin@gmx.de>,
 Hans de Goede <hansg@kernel.org>,
 Ilpo Jarvinen <ilpo.jarvinen@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hello,

v3, addressing the five points of the second sashiko review round,
the ones Lee asked to review, explain or fix.

Changes since v2:

- Empty work runs no longer touch the device. schedule_work() while
  the zone work is executing re-queues it, and a colour cached in the
  meantime may already have been consumed; the re-queued run then had
  an empty dirty set but still issued MODE, APPLY and SAVE, and SAVE
  writes the enclosure flash. The work now snapshots the dirty mask
  first and returns before any SCSI command when nothing is pending.

- The dirty mask and the cached colours are now protected by a
  per-zone spinlock, and the work writes from a snapshot taken under
  that lock. Previously the colour write and the (unlocked) bit set
  could be reordered on weakly ordered architectures, letting the work
  consume the dirty bit with a stale colour and lose the update.

- LED class device names now include the sdev's H:C:T:L
  (asus-arion-<H:C:T:L>:ledN). Every enclosure gets its own SCSI
  host, so the names stay unique when more than one is connected.
  With the static names the LED core would register a second
  enclosure's LEDs under renamed nodes (asus-arion:led0_1), which is
  the wrong device identity. Like sd letters, the names are
  per-attachment.

The two low-severity items are false positives:

- blk_rq_map_kern() takes four arguments on current kernels
  (rq, buf, len, gfp); drivers/scsi/scsi_lib.c calls it exactly this
  way from scsi_execute_cmd().

- kzalloc_obj() exists in include/linux/slab.h since v7.0.

v3 was re-verified on hardware: per-LED colours, repeated identical
writes, concurrent updates from four writers and unplug under load
are clean.

Everything else is unchanged: the hardware description, the
scsi_device_handler that does not claim the sdev, the multicolor LED
interface, the protocol handling and the known caveats (manual attach
until a notifier lands; SAVE on every update writes the enclosure
flash, wear uncharacterized; NULL-parent LED registration to avoid
the sdev reference cycle).

One open question for the RFC stage: the driver is deliberately not
wired into Kconfig/Makefile/MAINTAINERS yet, because the agreed
direction with the SCSI side is a split into a SCSI transport helper
and a shared ASUS Aura LED interface, and the wiring would follow
that shape. Is deferring the wiring to that split acceptable for an
RFC, or would you rather have the driver buildable in-tree from this
series already?

Comments on the interface shape and on folding this into the shared
Aura work with Denis remain very welcome.

Signed-off-by: Liang Haowen <nbg2974@gmail.com>

Liang Haowen (1):
  leds: asus-aura-scsi: Add ASUS Aura RGB LED driver for ROG NVMe enclosures

 drivers/leds/leds-asus-aura-scsi.c | 375 +++++++++++++++++++++++++++++
 1 file changed, 375 insertions(+)

--
2.55.0

