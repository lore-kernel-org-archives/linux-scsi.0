Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23064457C6
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 22:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792015232; cv=none; b=kOwQQNbDkg/Fd7Dl1Ah5JY1R8D73cjHUI8KB4cjQVM04ZAD4t93q4yUkq3JyqEZgZ35PCPH4leSQkZ/OSdzN7yDKuE19b6tcyAFdEJ2uQwwpkog6SuEniMU5SN4CuIPqgeknLLPJR4pW28OdeiKYPm/RbJnHfCAdSsYGDDPA4K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792015232; c=relaxed/simple;
	bh=BLZQOSYibwhfzt6l9poBjwrEcrA9JttRxudL7LQEggM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RRSkjdqBFuokbaeDM+keoaHmZXLu3GfNXsVIX5lReZ3kZ/ZhyBhcCBGLJQIzL4A9k5WpiLSEYm+luTIwZP6Xlbn4+h1YAwWeSel/xwHBjNNA4jegAInsdx7feMiM03QbBPn/kxObPVsslvVSnHVNShR5cwSf7BRMYi68PHXxkR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=XsFBqPgX; arc=none smtp.client-ip=74.125.82.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="XsFBqPgX"
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-35c76e9614aso2788933eec.0
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 15:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1792015230; x=1792620030; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ax2g8uufqOaIKgsATKaZd6NmJCsf+WOoNHoXDhnIUxA=;
        b=XsFBqPgXppUpq2tbRxyjNPWY4ZWEom74yEeXSERODZ/gCqodM9QGfuxf/f9NXAZIgB
         7PP5YhODPNEJL48oxkk3/DXy8mGI9kfXVWUS779yjeuptzxWxitQjIs3C2af88aLk30x
         gfeYGJ8rfpgxHccID/hiDrsLvqbgHJW7hChOkJYHRB7UnvFHFhJcP/BeDZX37ZYbC9IJ
         YlmPw2IEWboQJPWSy9cG8hLidwPftHIuabAPGSiA+Rojvs2GnGn1VLZketxRd30fUqMV
         p8j+mg6DVpZ7mBux07vZMdM+uAFVraMOPzPmiJ84Jy+mD1WdZzbLovzBh0mPiZFKwqjm
         VaTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792015230; x=1792620030;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ax2g8uufqOaIKgsATKaZd6NmJCsf+WOoNHoXDhnIUxA=;
        b=eY/a7k/bF/fEtbpF3DdBajoX7DTVz/PQZJhLPTI5jcUG8oAP+0fVkPmkXKgfwOwsET
         2kvdTWrcFNianxmCCSD11ZfdhSMnFZoCF97wVsxX4KeSYvZa+EuY6wBhX0WPrWunz8Je
         an201wznIXCukAcNpI4Oz4XTuknoClgr351wdr3sxcSSOrC27tGX1TRf/QMoBu7PXK+W
         /lPYbqyE2BNJ6KRJWtpY7fPTuIP6V1+0NPtqljuziIwL7gvZsKymWtTFMLKhSOlSx+pP
         FfsicAYbGhfV7rkjkN4HuuLE6H+7+21vr8DpuY+8vefKczVglwXRF0pom4rl/86jCEg9
         w4+w==
X-Gm-Message-State: AFq9FYJVnFDpDg5ZJEA7ztCATATBffkj4O5YHqbuzPs/vB7YfTnmjrxR
	pvHOJpFWV/6awRicsuk8paOLIkfHq11cnh78wbgeNONjMAl0O/4oWwMVA2rAYn+JsDPXVphNDGn
	k3CAMJHN+jlVZLPmnzF4pzPz4ja83PCZR3ay8OHJ286HIqC2EluFYhyMP69xHSjf5uhPbYNzjEs
	0rGTClY9lPYjt61OzbKCuthLeE+ObOQ20oJJbpMcS5hYeh/jJm3g==
X-Gm-Gg: AYBFou0cltj6rhQpYjQJHtdK+r/LgzvCaiSLDcHlCYH7q0HMwZafo3gzYNikjq9r2Pn
	DHjT3k/KzMkxVY/j+GLGhlrp6Qb8Ug6GdWNYaa4OBDHWCKTDOuMYGBHrxov3XFIV/GnWERiLBUg
	2jUemWRNG6uQjNFImPFJCqDaGCWg2CdJe8/bn8nnd4Pvyu7FN8R87jhTCB6y8UzbkR2W/NmDmrv
	/IWFBVR9l5A0S9EnVb8VcBjtb44kQZQ6jxYi27neE1vJJ/tB2scRsOQF+wKvMJL3rQWff5qf/Zf
	p9KYba/i1BZY3FJxMkx4kja2w+Y50U6N9oE8lB4sPSNMhzNc0Xh/HNTbG+I3h7Aa044+wCWyPd7
	U18iDrEo+EU5bGU0wKEb4/Ch1ne2XoiAvWhEwO1xK3XMUTauKzcqahxy5Hb9IK+23upybMpl7HM
	zD8oDZlVsjrNbp8t0Te0+kJ0Fug5VSeCcqNwT1wDPGNF1L3hI+n2C0tImemNZPx+RkbTWtRm3Sb
	+ZvPKG7Mv/zIoP6ZVHgo1hUpmvapw2bHoxboqwP/2LyaZsqSCDkM1WogDDAM3KJyI4O8LmQUl6o
	zdiK6KFYz4h7U0Tqx8H2BcJbUIEDSVkzgAOK1ihNT7TK0KEVdCG1jA+cmjkpQ+CvfvkejfM=
X-Received: by 2002:a05:7300:4706:b0:34e:3ce1:39f8 with SMTP id 5a478bee46e88-3537e021d3cmr23884241eec.18.1792015228723;
        Wed, 14 Oct 2026 15:00:28 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-35b19c6c7b4sm30236633eec.24.2026.10.14.15.00.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 14 Oct 2026 15:00:27 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	James.Bottomley@HansenPartnership.com,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	krishna.kant@purestorage.com,
	Brian Bunker <brian@purestorage.com>
Subject: [PATCH v7 0/5] scsi: Refresh INQUIRY data and reprobe on rescan
Date: Wed, 14 Oct 2026 15:00:09 -0700
Message-ID: <20261014220014.94330-1-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series teaches the SCSI rescan path to refetch standard INQUIRY data
and reprobe the device when the peripheral qualifier or device type has
changed.  The motivating case is an ALUA target that transitions through
the "unavailable" state and afterwards reports a different peripheral
qualifier; today the kernel keeps the stale INQUIRY data and the device's
sysfs attributes diverge from what the target reports.

  1/5 serializes the INQUIRY-derived sysfs attributes under
      sdev->inquiry_mutex so a concurrent reprobe cannot tear the read.
  2/5 adds scsi_update_inquiry_data() as the single point that stores
      INQUIRY data in sdev and updates the fields derived from it.
      Returns SCSI_INQ_REPROBE_NEEDED only when peripheral qualifier or
      device type changes, as these are the only fields that determine
      driver binding.
  3/5 refactors scsi_add_lun() to use scsi_update_inquiry_data(), sharing
      one implementation between initial-probe and reprobe paths.
  4/5 teaches scsi_rescan_device() to refetch INQUIRY and reprobe the
      device when scsi_update_inquiry_data() reports a change.
  5/5 calls scsi_rescan_device() from the scan path for existing devices
      so that a SCAN_LUNS pass refreshes them as well.

Changes since v6 (all prompted by the Sashiko review of v6):
  - 2/5: sdev->inquiry is now allocated once at its maximum size
    (256 bytes) and later updates are copied into it in place. v6 freed
    and replaced the buffer, which is a use-after-free for the helpers
    in scsi_device.h that read sdev->inquiry without a lock
    (scsi_device_tpgs(), scsi_device_protection(), ...). The fixed size
    also means a growing inquiry_len can never run past the buffer, and
    inq_len is clamped to 255 to fit the unsigned char inquiry_len.
  - 2/5: Capability flags (removable, lockable, ppr, wdtr, sdtr,
    tagged_supported, simple_tags, soft_reset, is_ata, allow_restart)
    are now set only on the first call. Rewriting them on a live device
    undid adjustments made after probe (BLIST_NOT_LOCKABLE, usb-storage
    and scsi_ioctl clearing lockable, aacraid forcing tagged_supported,
    ...), and raced with runtime state bits in the same word. A rescan
    now updates the INQUIRY buffer, vendor/model/rev, PQ, type and
    scsi_level only. Dropped Hannes' Reviewed-by.
  - 3/5: No code changes.
  - 4/5: Rewritten. If the INQUIRY refresh fails, the rescan carries on
    with the existing data instead of skipping the VPD update and the
    driver rescan and returning success. The device handler rescan
    method is called in all cases again, as before this series. The
    get_device()/put_device() pair around device_reprobe() is removed:
    callers hold a reference, and dropping the last one from
    scsi_evt_thread() would have run the release function from the
    work it cancels. The reprobe failure path now checks whether the
    device could actually be set offline before saying so.
    scsi_probe_lun() is now called for live devices, so it returns the
    INQUIRY length instead of storing it in sdev (the length is updated
    with the data under inquiry_mutex), and only writes lun_in_cdb and
    the target's scsi_level when they change. Dropped Hannes'
    Reviewed-by.
  - 5/5: Rewritten. v6 allocated a second scsi_device when an initial
    scan found a device still in SDEV_CREATED, passed a length of 256
    that truncated inquiry_len to 0, leaked a reference for pseudo
    devices, and called the driver rescan method without the device
    lock. The scan path is now unchanged apart from calling
    scsi_rescan_device() for an existing, fully set up device. Dropped
    Hannes' Reviewed-by.
  - Build-tested every patch with gcc W=1, and the series with clang 23
    and CONFIG_WARN_CONTEXT_ANALYSIS=y; no new warnings.

v6 cover-letter Message-ID: <20261012210511.16061-1-brian@purestorage.com>
v5 cover-letter Message-ID: <20260618233508.97960-1-brian@purestorage.com>
v4 cover-letter Message-ID: <20260530002019.47109-1-brian@purestorage.com>
v3 cover-letter Message-ID: <20260429224939.77082-1-brian@purestorage.com>
v2 cover-letter Message-ID: <20260429012733.40855-1-brian@purestorage.com>
v1 cover-letter Message-ID: <20260424215324.99045-1-brian@purestorage.com>

Brian Bunker (5):
  scsi: core: Protect INQUIRY sysfs attributes with mutex
  scsi: core: Add scsi_update_inquiry_data() for updating INQUIRY data
  scsi: core: Refactor scsi_add_lun() to use scsi_update_inquiry_data()
  scsi: core: Add device reprobe support to scsi_rescan_device()
  scsi: core: Handle reprobe for existing devices during SCSI scan

 drivers/scsi/scsi.c        | 205 ++++++++++++++++++++++++++++++
 drivers/scsi/scsi_scan.c   | 250 +++++++++++++++++++++----------------
 drivers/scsi/scsi_sysfs.c  |  28 +++--
 include/scsi/scsi_device.h |  13 ++
 4 files changed, 377 insertions(+), 119 deletions(-)


base-commit: 2f4880c22e838d54eae9ab153b0f8dce60531bf1
-- 
2.56.0

