Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792448060;
	b=SWuEmHlPW2nGcmZAyEibMZJcJ9QWxtQLkdVVfu9tsJ1RyKclPQ9OMpnbPDcDVjJMwlpO
	 q3K5uPLB239eLOrXs/Un0tteVOthKK9j+xOmVvigZ49RHaiqdWA+2WGd1zNoF9VNOxv50
	 QQQ0UuP17qGVf+Zs9TYCPJN1zzcuFnk0FYpCnUyG1z1Re06Es88xwtbWEWAeFIh+uy5Wc
	 QNZvLJDpGkbKwGE9M/tqUc3fFmYUMA6FE2k1Wtob8x5YZa/HdDIqTldK+W1x4UopLYl4T
	 htH4VktFHmu5nuB4XmEWkdBYppnAyh8rnlzYSTWGYkvAAFREqOYrdW6tij6t+g07DwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792448060;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=wkNbRl/7TwYw/HQgEne8qirhtmVnJcJ6ErCB9oK6HGA=;
	b=Gekfplt3rLjiycGdo4awiiky86wFKqhcGqZcGH9blWsicxmPxJNpQPWk6x9zLid4IiCr
	 L7M82sBvW1qiBqunjrPVdB8bVKg/fySk4SNXdKVQdDVrJDYb/1Hu5p5anklPtV8UYKwK/
	 wWS+eOXmpe5CRYVJ4f6GTlP24DMSdCafhGjthzSfHffL6ppHUc7mzg8ntTmgH9BB1tie3
	 fq5DxzHGcIOevIXtU8QU1ui+ub6iiQM2lGtqnwJyOm+O/i2IpQNlR+nUL/BwpQVZg+1Wo
	 SgOejeECvcF1KDCukchTqshMP5l45FjjHLqECxfU4ypYzeS6o3C+alOzwvEF8zz/0nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=NQV9W1OD;
	arc=none smtp.remote-ip=74.125.82.179
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E49C606A31A
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 22:14:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E49C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=NQV9W1OD
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso1332711eec.0
        for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 15:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1792448059; x=1793052859; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wkNbRl/7TwYw/HQgEne8qirhtmVnJcJ6ErCB9oK6HGA=;
        b=NQV9W1OD5l7yy8euWX7WDslapwGiKkabLao0NrOU5aaM1TE68m3YX6SYPKOzbEuWIj
         SYl51oDwy7I+pclwP1iYyBRNcW18OVsMqVDRDodHLMnDwOOs9MZwSrXFqfKF6yQYJuBO
         StJqMMEI0caWOYIHjYHhgq6dMy4vWGZoyILMgxVPqcpRYcBX2OCuZ31vgYqagAeLJ2Tt
         nNSydNxuswIY7lemXO3ctJNvAMkKPqwMxtZLqUYeYJgFfc+3YiTG2aFfAmNb3JLLAq44
         3f+qMsdfyrCQPSdx/zdW8r52eNVgA7zDy56WkvVrTZfMn54exZ+8+ss8KN9ASjYu2Px+
         RonA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792448059; x=1793052859;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wkNbRl/7TwYw/HQgEne8qirhtmVnJcJ6ErCB9oK6HGA=;
        b=QdqpdPGrRCVBYbQd2B+oyuly4TDprXhhj0p5uowyFWZoN16by8vogI+LdhbGnus7WE
         ly7/IlXXyLRYuWCz2lRT3lmJ6l/Uic+mdta2P1JoZz5IrFvhtdglEpdZYB8x/QeN8oos
         dr96BsLhYp2+HbvT5M5eg6CWG8FCe1dpXbHOnuBmfhlklIyS9OmdkevthYE4TDYTwzMf
         k08lQg991mdLglKK+sKRpLarixkgIdZjlPWQnfVNC+X4dsfqF5j70qSzp5+M7JVIBNHB
         V85+mziiN+7HG0h9mKBTBmozqlF/4oVtwZ4S/+aUW+5KIVHSQ4ZmfLzsiE8Ryj4Ky+9/
         wNSw==
X-Gm-Message-State: AFq9FYKF4+hZNUL2hV4CDhzUh2sJnm5CdYBEmVTEg0WgI4SGhytoM76Z
	GJhEbS9wZHfhKG8mp4HSeb31hYawlrtXdxce8y7hz/zYGYtphE3/Hdvc14UcQmguLPz+RqztsdV
	O9w8lqaWRB8NejkrvuxWGndl38hWPtzH3leNUVsYI5oPac9zLI9He35ks4bE73MquTyT9ASiJlQ
	Ld+wvMXzn0LDgk/BWf8CcYRALkdTu9WnQpYginp75Dj1wVvNhYrw==
X-Gm-Gg: AYBFou3fmmTy7Ce1yooUKm3P6MRn/yGo7I8bLpJl3t3y1JxyClndhLNix7c/sjUd13V
	BBfUZ1zwskq3UXPZWfFbuN0ZH8q0C/OQSrMwFabjZqshnV2+AmetuDp9xBsU7O0vzCXevk6DZkr
	e+rOG6qM8vxmOGjb+TLC+QMtiHU9Iwqc9cK5KUaKuZdVJGJ5lJRdPxHCcc7c2bM/JeHAeSwidXp
	eLPbkeI1jQfBRum6mZf5F8YwQ9dYlZONyCZ1wtWsCMAynokah4R3n+AvjNiCOGkWHbaVa39pYRZ
	6CwyqQybWnSZGioRDWL1rCnLkqp2WFD10sghZhBnR/IM/dkf31QRN++bTYvqHy+17S2BdKxYN7q
	ts2nZLrWY/LRm7KVfb/lzkSgcENsQ7N4je6/JlW79ZTfYUKOpqZpq3VDIZ0fAr/biI2kYZe0Vqv
	fJLmTV1maDZjbx1osvb4uf1tEXQhxW0hwRKCvH2QEHGEqAUupWBKV2GupvxZuvQlbTPRG4hyLiK
	CF7QkRj6zXC7gsqGTWWokSmSv2dQsYa28ezmfryekOSmbhTqSAjpvMriTclQruCny2OBxDHHfNU
	AIJz1/u6r+Zgv+fPsUDfpHJS8nwsLDVKtyi+FDbc7N73Wy0eS14LutJmeQNutH042z3pVOvadss
	eG4CRpA==
X-Received: by 2002:a05:701b:4586:20b0:152:91d0:dfc3 with SMTP id a92af1059eb24-18512f1b353mr12268284c88.23.1792448058347;
        Mon, 19 Oct 2026 15:14:18 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-18319d3b880sm29429839c88.10.2026.10.19.15.14.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 19 Oct 2026 15:14:17 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	James.Bottomley@HansenPartnership.com,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	krishna.kant@purestorage.com,
	Brian Bunker <brian@purestorage.com>
Subject: [PATCH v8 0/5] scsi: Refresh INQUIRY data and reprobe on rescan
Date: Mon, 19 Oct 2026 15:13:59 -0700
Message-ID: <20261019221405.40614-1-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
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

Changes since v7 (prompted by the Sashiko review of v7 unless noted):
  - 1/5: Also take inquiry_mutex in the modalias attribute, and read
    sdev->type with READ_ONCE() in scsi_bus_uevent(), which gets a const
    device. Dropped Hannes' Reviewed-by.
  - 2/5: Compute scsi_level and type in local variables and store each
    once with WRITE_ONCE(). Both are read without inquiry_mutex (the I/O
    path, upper-level drivers, scsi_bus_uevent()), and v7 stored an
    intermediate value first: the unincremented scsi_level, and the
    uncorrected type of a well-known LUN. Found while addressing the
    1/5 comment, not by Sashiko.
  - 4/5: Set the device offline after a failed device_reprobe() under
    state_mutex, so a concurrent __scsi_remove_device() cannot have
    SDEV_CANCEL or SDEV_DEL overwritten with SDEV_OFFLINE.
  - 4/5: scsi_probe_lun() takes a rescan argument and, on a rescan,
    no longer writes the host's short_inquiry flag, the target's
    scsi_level or lun_in_cdb. These share words with bitfields that are
    written at runtime without a common lock (tmf_in_progress,
    cdl_enable); they are only set when a device is first probed.
  - Rebased onto the current 7.4/scsi-staging; no conflicts.

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

v7 cover-letter Message-ID: <20261014220014.94330-1-brian@purestorage.com>
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

 drivers/scsi/scsi.c        | 215 +++++++++++++++++++++++++++++
 drivers/scsi/scsi_scan.c   | 271 +++++++++++++++++++++----------------
 drivers/scsi/scsi_sysfs.c  |  37 +++--
 include/scsi/scsi_device.h |  13 ++
 4 files changed, 410 insertions(+), 126 deletions(-)


base-commit: db8b4d2bf2d3e02b4ff78bbf69d00e11795840de
-- 
2.56.0

