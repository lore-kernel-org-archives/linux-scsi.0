Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C5C51589D
	for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2026 12:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790165924; cv=none; b=AE4UyObIxTqGUesF7y0ZT79FUFfGYFsbrvO4q4Y5sgB65AKhbe5hyExtLefszCNNHM+7wFBcM3ernB3Hi2mUQJrJLnCGgY9Aw9KDlNdhyAZ7Aks++/f6Uuvqv09bw3IgSzdr9skTvj9ZI4F2m2RpID9cScUavi2YPEjwlTJXrv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790165924; c=relaxed/simple;
	bh=nycHpeqG+1oIMvtY0hvmEQQEnmXB7wjz8VXdVUhTNtA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V+t0Xolxdm5M53oG9rDew7ivd06kkwhSae72E/UNgsK/bP6HSQ6EkW7IAGQ69d/WN4S+wwfmgU9+rHVtuZUWeIvc9oe8pZ5HQIJZXwGkm3Sb9PUfRee9NGrkoym36lbgieDHnwTtr2sq+dfLi9NRRLAAXsOQgVZ9UCmX4XRuNhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K1e7QXa/; arc=none smtp.client-ip=74.125.227.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K1e7QXa/"
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-396ccd5cef0so491302a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2026 05:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790165922; x=1790770722; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=prVpAsjmMpwAYd/WbDTNxRVVPniTFSqmZS7Z70kOMCc=;
        b=K1e7QXa/QBF/QyewaN9uw5WVa86Pv7SkKvHjUGtdpIzeWBlxlaTJM/18DHjB/0dM58
         ZCje/cCQRnSmXPe3mDZE3/rCf5zgDWEz6vjJFAxvbPi9kUsibFTLoTA6fluyp/QhQ0EU
         6uxcMi+AMe5pivd36LssW7m6eVyevTFV8t9wH0hCC47gO6wlIV/QNpoqqZFaMDo1FV7b
         L4ABEs6fQYarXreG+k32+aKphsT5mgOl1pM34CApC632iMtwwiDMW7iN5mIxAeQA50mz
         daE0lp80u+8JX7krQvfJBHNlG7qYSyPRTxECGVCcSE0IJF8USFX4I12XZArYctjlX+1J
         PoVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790165922; x=1790770722;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=prVpAsjmMpwAYd/WbDTNxRVVPniTFSqmZS7Z70kOMCc=;
        b=Tl0XqanK7fdRMz8+IosVKC5ACoeQ3nBaIJVh0GssnnJT7DrR+1K7yAhI8Ivgqg2TRV
         GuZkwwcmkTC8h+j7uRJ2vVGHd8Olrb9AzhGjdO/nIBfCCe557g/oPpCnthTt+k9pduYq
         3iY+moi0C4kJm/Q8RBm1KhlzTcdOYQA6eIm0NF2VgboeeAapX5m3NKSjEAhpxvEEcYUj
         mlv8kaiW8koLnJOBwUwuwJm3QLY7pzWkFlWqmkYcnFGUOd1H+QVvj1Us22/3paNhO9bB
         UezGH2DYajfrVKey7VA0Azus9CUq2lCQcxOv+p6ojLZ8AeQ2gMG0WX0jnlICFy+hZ9ii
         y2Ag==
X-Forwarded-Encrypted: i=1; AKwUvBxse8JxHvYHAmpcOxPIixM49O6HXSLgz6wwHjf1kMumf3AweEoL6oglDWeZWLQhkVOQ8UQO0NQsR8ih@vger.kernel.org
X-Gm-Message-State: AFuF++kEFyw2F+xzeEx5icmK+JhgJkTNMtxYJQDlJGw7tmGDH/+VHE0j
	EUGNdYlURTOE4rNDFgO4dqa925107YShpRPhHzFSrlH6cThGduT07bUg
X-Gm-Gg: AYBFou2UUV4QivYX9/h4qxTsYSJrKHQER4v7F5jnT6IuYRq1E0O212aq/xZZaAyGC5t
	p6wntvlvp3o4fRfIX7+vJheVP95W1jnuh7GFCYyRG8DosuwpPmZFqzT1xfJSS1vxUnPBet3QKJF
	8uh7gQVp+pawQgdSrTOcoEH9O6QWahIbDTIbFpRLQ7x1XPMd0XisSlfgVbDd++G1BMf3aOW/pVc
	dpINIwIhK9YxKoEzcVpuT9VonYN5EncMm27KR7gTRqqljKOefvlErmc+5uGsI1AC0NXidgqN5Gw
	ZoQkj2u7hnlRI/aZ2pjsevD82LQmTpj1F1diR7CdZlIV7+37pbJy1S9cpX/9cmepxFX6E4BPEIt
	olBnEBO+aBUtBBQ9zIyqTROiASx02oVnF0mZfRH4w7F+qpFergBpcZkvXsFpnIydJyuuYSd6LI7
	pXCcRdUxAi/VQNaxj6EpEDlMCv9uOt1ciRdZl28pANq9OAFe8HTNjtFjcigDHmfqz2N7WZDlIr2
	zkCPQ==
X-Received: by 2002:a17:90b:2b45:b0:39d:f189:48d6 with SMTP id 98e67ed59e1d1-3a07e5690efmr2138760a91.4.1790165922326;
        Wed, 23 Sep 2026 05:18:42 -0700 (PDT)
Received: from ROGZephyrusG16Air ([240e:b8f:977f:f400:ec2a:b15e:fef8:70a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a07dbc013fsm5867255a91.5.2026.09.23.05.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 05:18:40 -0700 (PDT)
From: Liang Haowen <nbg2974@gmail.com>
To: linux-leds@vger.kernel.org
Cc: Lee Jones <lee@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	"Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Denis Benato <denis.benato@linux.dev>,
	Armin Wolf <W_Armin@gmx.de>,
	Hans de Goede <hansg@kernel.org>,
	Ilpo Jarvinen <ilpo.jarvinen@linux.intel.com>
Subject: [RFC v8 0/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED driver for ROG NVMe enclosures
Date: Wed, 23 Sep 2026 20:18:31 +0800
Message-ID: <20260923121832.2613187-1-nbg2974@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

v8, as its own thread. It addresses every comment from Lee's v6
review and Ilpo's line review; the notes below say what was done per
comment and where I think a comment rests on a misunderstanding, I
say so instead of silently keeping the code.

The submission format is git send-email from v7 on, the driver lives
in drivers/leds/rgb/, and it still has no Kconfig wiring: it is the
verified out-of-tree module, the wiring lands with the agreed SCSI
split. On the SCSI device handler itself: it is an out-of-tree
expedient, not a design statement. The enclosure exposes a single
mass-storage interface that usb-storage owns, so a USB interface
driver cannot claim it without taking the disk down, and hooking the
SCSI bus from a module needs the unexported scsi_bus_type. The
device handler is the one hook that observes the sdev without
claiming it. For in-tree, the attachment should move under
drivers/scsi in whichever form the SCSI side prefers, notifier or an
exported attach helper, and I will rework it accordingly.

Changes against the review comments:

- Includes sorted alphabetically, linux/err.h added (Ilpo).

- The vendor CDB is now struct ene_cdb, __packed, with named fields
  and a __be16 register set with cpu_to_be16() (Lee, Ilpo), plus a
  static_assert on the 16-byte size.

- The ENE register defines carry plain comments; the R,B,G wire
  order has named indices (ENE_WIRE_R/B/G) so the reordering against
  the R,G,B subleds no longer relies on magic numbers (Lee, Ilpo).

- struct asus_aura_zone became struct asus_aura, the per-enclosure
  context; the dirty bitmask is gone, each LED carries its own
  pending flag (Lee: LED-level attribute, faux indexing removed).

- The work item returns before touching the device when nothing is
  pending: an unlocked scan first, since a colour arriving after the
  scan re-queues the work (Lee). The locked snapshot follows.

- The write payload is copied into a DMA-safe per-device buffer
  before blk_rq_map_kern(); no stack memory is ever mapped for DMA
  (Lee, VMAP_STACK).

- ene_write() became ene_write_reg() with a tx buffer argument, the
  arg_count branch is gone (never false), and it returns 0/-EIO
  instead of the raw SAM status; the rationale for not using
  scsi_execute_cmd() moved to the commit message (Lee).

- The 10 s timeout dropped to 5 s, the development-history comments
  are gone, declarations are unwrapped, loop variables are declared
  in the loop, lines are reflowed to 100 columns, the code is grouped
  with blank lines, and
  asus_aura_register_led() frees its own name on failure (Lee).

- dev_err_ratelimited() instead of dev_err() on the work error path
  (Ilpo); _once() would hide a persistently failing device, and
  there is no caller to report to, the work runs detached from the
  LED core (Lee).

- strscpy() uses the 2-arg form (Ilpo).

Two comments I did not act on:

- .module = THIS_MODULE in the device handler: the in-tree handlers
  (scsi_dh_alua, scsi_dh_emc) set it explicitly as well, so I kept
  it, but I am happy to drop it if the subsystem prefers.

- kzalloc_obj() stays: checkpatch on 7.2 prefers it over kzalloc()
  with sizeof, and the sashiko report against it is based on an
  older tree (it has been in include/linux/slab.h since v7.0).

v8 was verified on hardware again: the four LEDs, per-LED colours,
60 sequential updates, unplug under load (zero splats, zero leaked
nodes, clean rmmod).

Comments on the interface shape and on folding this into the shared
Aura work with Denis remain very welcome.

Liang Haowen (1):
  leds: asus-aura-scsi: Add ASUS Aura RGB LED driver for ROG NVMe
    enclosures

-- 
2.55.0

