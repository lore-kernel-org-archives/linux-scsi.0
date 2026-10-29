Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793233544;
	b=drA+afvwcUdewtEmScEH7bGeqkj1LzDfVYG3bODphb5iSSYOw5e6ssseq0IBZCW2+tTQ
	 vICJ8KXOAjrNgpobUTekcJuq+o2jZc5qfxAmVMm6EwsLO/9J1I5Y0+GczjCY/NQjvBLTl
	 V+qWoCy7XrmMWR98sr5vU1y4V07uM+yKh7ypY5VANG8kgmaqrMdcoNJHJPvG7jiL6lXVs
	 4urQMy0BatEPzMfEjkYodLxdUGjY3AakvsjzsNPBY/g0d1nfLXd8A0vDFsYj2L9xX9khF
	 pUSWasExQ5O5d/wcwITeCgN8mK1UUdcK1VCDp97UFMlHFYa3zHBd15r7U8A+9x3h9mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793233544;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=J8aoBH6mRlcl+9seTx28oQLyEYfZFS6tzcA9q1jraRg=;
	b=CzjmvBY5ptpyp8TdH6Co9S6DaVSZLGUwOQk1YBujlKC+kW/XXpaPEA4k8rS+S7P4TY+c
	 qydQn3rJ7mWSJsIF4fUxAfSGkNxI31BG1a7bUFzZzjR3lMvB3ZojoTOP4Fin+jV4gdUdy
	 Ee6ezV7x8oYHVcGMpsSwqtb9r3hSd+u+ICDk5wbEy5gbDpSCvy6mJO9PhP2YTn6k+uDQP
	 mWDPlVdpW8ugg+CHQMVd4Ya9tmMvxZt7TmHd2od82wbJito7O/wVL+5Top9XGdzuSFV3o
	 ySzvf6qXOFEbM4+pxnz/ILCRzfcrfePhBmMaLXQCyEkPSX3woIFjEEf+rsaMIl0Lx5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=MqWlfqG4;
	arc=none smtp.remote-ip=74.125.82.182
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF05606A31A
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 00:25:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6FF05606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=MqWlfqG4
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-3550c917fd3so2254755eec.0
        for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 17:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1793233542; x=1793838342; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=J8aoBH6mRlcl+9seTx28oQLyEYfZFS6tzcA9q1jraRg=;
        b=MqWlfqG4TL8G85iQPmd7tMVR+2RnOk9O3sZLD0kQM9ONIjI0RAqjZBExO/vWHKfK47
         rw6o8dYHJMZKK2NL+VoP5nOFTKCZPQYNfE5G8oZ8Y2qvS07Ch/JF0miQloGu3PWsdJLg
         aah/MuWFnL4tYnpL4HIc5UwX2LdW0MgG+nu39RSbj81cY28zai1SLszdQdozaK3S03+Z
         t/H40ywudeVhWnPVW/xsZ36JfPrT/JZiCcs9mu2Ec4PJWYauOXeTe0NXIQmR9MFADtcL
         fkOfAcdzj6w2cifQoR1tKexNQQITDqcK0YgtImO9UxkC/yCO/t7O56ixvQK9pVZF0QO1
         aVfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793233542; x=1793838342;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J8aoBH6mRlcl+9seTx28oQLyEYfZFS6tzcA9q1jraRg=;
        b=xmCvXKT0QdXAUrNffWHeGeXC6VCRdK1tfHgQSlQ21wQ459XXOSjyg7BNVyoi7Yq3xR
         oD4XmXMDtHrZwoUldvdexV6K2vzC0v97Lp3b5z5d9rH2p9/FLDrERNfj6a9GTbX0MlP4
         L+YRnZmHNqqC4wYXUr8Za+f3aDJKHRMylTg8h8ar6TXBBHk9p4N696XgwfLKBe1DBCWV
         3I0iUC4+i92GAhSpj+dcP2BnC29XEMkrpehCiqk29bDe/JZ0xzKAIpVzlp+Di/S2f4JQ
         Is9vMekHJ1DbVR5oLM+BpIr0LMmUcYkkFn4vzHt916fi3+WyhxQW5pKRWwYZTNQWFtOe
         fY4w==
X-Gm-Message-State: AFq9FYKs8IeHQGL33WM+YUdGVjwir/ryKFAr50BkD1XK91Y4J3W5lcEN
	5J75KOI/M6tLvHLh4tLYRbxQZyZg7ie//km8vlU7f3/7qxzkPTrjdIOsQ1hBd6W+lJqpPGx9Lsh
	bi0lJZ3Y+sqxkOGf3axpJOYRCzxHOmABLXU+a2knshedhKnt/HR5dnVfV6y6GfYD96c+kH9NnOu
	Idb2C5WmDO0h3osYlAiinCKMdcu46mPYJgpOA7eJ7hKiXlaXM7+w==
X-Gm-Gg: AYBFou0e0Fdd7frAM6bjb/BrhNY5xwhv12KMa1kXKV6rkm5+1JpOR1VQXhAYS/l0h8n
	bUlPnShBqsp8hnUlFsSeEyNTz56CSwjzZFMzSeK97RbJk4DwBaemI4QR8nHQLMBxegtHgRVG4mo
	TRVno1ZV4M+xgaqtsoop2C82TrU8CQKcJiWjgIlOfXgkDXwkR2xhrx+C74rlB3KZ2bq6lXaiAyq
	OeCqojooYTJOeRcafJK+ZLUGUHHNXm7VT9n7NDeC9JTFq/aGIkhn1V0h99EvEVdFqk3tLjDZPvN
	NdDTIUrN6UUDeg2C3Wu/HUH3wKL4bt8mSiX1phGqdViGOXdZ6lGXRba+wleSnRX32kSzOaDeOBy
	HlLFHKnBuCscgyzhQmqMfns9IBuWV0w0jCd/85J8wxyg7fIDGqR+4RfakVqvedWjVrRLjpNKQDI
	wvMWpnFBbns9QeOrnDlWAJbVyaymf3u2oapgzNcx2jL+JHnwgPkXDhGOAXn6yxjL4o5s0tTDR8f
	D7ZG21Bkf7gutqZpedtE9uavvMQguOnGl4I3JabFq9moiot8/nAMMVhx151NQ5HKCkfTT9waxUN
	l++YrJc7exZol9sUV1uTvx1C5M0yxm5TN7O0nOa04sfUphKWUe7bykvxxyvHH5aSGU7P4mpjkwr
	nm1n4VUxyG9FMwraAkjkrDsBnEiOxjJe23yql2OpJrxSZ01zQAtgHSYIL8+3nxBPatdD0zYcyxi
	Eg1Lr+T5Sm+mt9bxpm2kZtMNsZng==
X-Received: by 2002:a05:7301:700a:b0:368:2548:c081 with SMTP id 5a478bee46e88-36a203d4194mr4476581eec.25.1793233541885;
        Wed, 28 Oct 2026 17:25:41 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a239a2e29sm11294226eec.26.2026.10.28.17.25.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 17:25:41 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Hannes Reinecke <hare@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: [PATCH v3 0/3] scsi: Bind sd to LUs in the ALUA unavailable state
Date: Wed, 28 Oct 2026 17:25:28 -0700
Message-ID: <20261029002531.82824-1-brian@purestorage.com>
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

A LU that is in the ALUA unavailable state on a target port reports
peripheral qualifier 001b in its INQUIRY data. scsi_bus_match() only
matches devices with peripheral qualifier 000b, so if a host scans such
a path, no upper-level driver is ever bound to it. When the target port
later becomes available, nothing binds sd and the path stays unusable
until the device is deleted and rescanned. A host that was already
running when the path became unavailable keeps sd bound, so the result
depends on when the host scanned.

This series fixes that at scan time. The SCSI core reads the ALUA access
state of a device with REPORT TARGET PORT GROUPS before the device is
registered, and matches sd to PQ 001b devices whose access state could
be read. SPC-4 requires PQ 001b in the unavailable state, and the
command fails for an unmapped LUN, so these are taken to be mapped LUs
that are unavailable. This is the same situation as a path in the
standby state, to which sd already binds. The path then stays in the
multipath map as a failed path, and the existing UNIT ATTENTION handling
brings it back when the target port becomes available.

PQ 001b cannot be matched on its own: an unmapped LUN reports it as
well, and some targets report every possible LUN in REPORT LUNS. Binding
sd to all of those would create disks with no backing LU. An unmapped
LUN fails REPORT TARGET PORT GROUPS, so the access state is what tells
the two cases apart.

  1/3 moves submit_rtpg() out of scsi_dh_alua into the SCSI core as
      scsi_report_tpgs(), so the core can read the ALUA state of a
      device itself. No functional change.
  2/3 sends REPORT TARGET PORT GROUPS from scsi_add_lun() for a device
      that reports TPGS support and sets sdev->access_state from the
      descriptor of the target port group of this path.
  3/3 matches PQ 001b devices whose access state could be read, which
      are taken to be mapped LUs in the unavailable state.

This is an alternative to the series that refreshes the INQUIRY data
and reprobes the device on rescan ("scsi: Refresh INQUIRY data and
reprobe on rescan", v8 last posted). That series needs a way to update
the INQUIRY data of a live device and to reprobe it. This one does not
change the INQUIRY data after the device is discovered, and has no
reprobe, so none of the locking and ordering issues that came with
refreshing it.

The INQUIRY data in sysfs is unchanged by this series. It is read and
created once, when the device is discovered, and keeps the peripheral
qualifier reported at that time like the rest of the INQUIRY data. At
any given time that cached peripheral qualifier can be out of sync with
the device, for example after the target port moves between available
and unavailable. An INQUIRY sent to the device returns the current
value, and the access_state attribute shows the current ALUA state.

This does not make every target work. Today none does: a host that scans
a path while it is unavailable never binds sd to it. With this series a
target that answers sd's probe commands in that state is handled
correctly, and the others are no worse off. What it relies on, and the
known limits:
  - SPC-4 requires PQ 001b in the unavailable state and requires REPORT
    TARGET PORT GROUPS there. It does not say that PQ 001b is reported
    only in that state, so a PQ 001b device whose access state could be
    read is taken to be a mapped LU that is unavailable: an unmapped
    LUN fails the command.
  - The decision is made once, at scan, like the peripheral qualifier
    itself. If REPORT TARGET PORT GROUPS fails (other than with UNIT
    ATTENTION, which is retried), or the INQUIRY data and VPD page 0x83
    do not allow it to be sent, nothing is matched, as before.
  - SPC-4 requires neither READ CAPACITY nor, in the unavailable state,
    MODE SENSE. sd's probe commands are sent to the target. If a target
    rejects them, sd keeps default values, such as a capacity of 0,
    until a later revalidate, as it does for a standby path today. If
    the path changes state while sd probes, it can also end up with a
    mix.
  - The ALUA device handler is unchanged and treats a new port group as
    active/optimized until it learns the state, so the first regular
    I/O to an unavailable path, e.g. the partition table read, can fail
    with LOGICAL UNIT NOT ACCESSIBLE, TARGET PORT IN UNAVAILABLE STATE.
    A path in the standby state already does the same with TARGET PORT
    IN STANDBY STATE.
  - The standard INQUIRY data, including the peripheral qualifier and
    what sd uses from it, is only read when the device is discovered;
    the kernel has no mechanism to refresh it. A rescan, e.g. on the
    INQUIRY DATA HAS CHANGED UNIT ATTENTION, reads the VPD pages again
    and revalidates sd, but does not read the INQUIRY data again.

Changes since v2 (prompted by the Sashiko review of 3/4):
  - Dropped 3/4, which started a new port group in scsi_dh_alua in the
    access state read at scan. alua_bus_attach() calls alua_initialize()
    before it sets sdev->handler_data, so the initial RTPG that
    alua_check_vpd() queues is not scheduled, and alua_prep_fn() would
    keep failing I/O to a path that had since recovered until something
    else queued an RTPG. scsi_dh_alua is no longer changed apart from
    calling scsi_report_tpgs().
  - 2/3: The commit message no longer says that the handler queues an
    RTPG when it attaches.
  - 1/3, 3/3: No changes.

Changes since v1 (prompted by the Sashiko review of 4/4):
  - 4/4: scsi_bus_match() no longer tests sdev->access_state. The
    peripheral qualifier is read once when the device is scanned, but
    access_state follows the ALUA state, so a device scanned in the
    unavailable state stopped matching as soon as its path became
    available: when an upper-level driver module is loaded later, when
    a driver is rebound through sysfs, or when the ALUA device handler
    updated access_state before sd was probed. scsi_add_lun() now
    records in a new sdev->match_unavailable flag whether the device
    reported PQ 001b and its access state could be read, and
    scsi_bus_match() uses that. SPC-4 requires PQ 001b in the
    unavailable state and an unmapped LUN fails the command, so this
    does not depend on the state the command returns, which can already
    be available if the path recovered between the INQUIRY and the
    command.
  - 1/4 to 3/4: No changes.

v2 cover-letter Message-ID: <20261028230807.61578-1-brian@purestorage.com>
v1 cover-letter Message-ID: <20261028184216.25453-1-brian@purestorage.com>

Brian Bunker (3):
  scsi: core: Move REPORT TARGET PORT GROUPS into the SCSI core
  scsi: core: Read the ALUA access state when a device is scanned
  scsi: core: Match ULDs to logical units in the ALUA unavailable state

 drivers/scsi/device_handler/scsi_dh_alua.c |  63 +++---------
 drivers/scsi/scsi_lib.c                    |  52 ++++++++++
 drivers/scsi/scsi_scan.c                   | 110 +++++++++++++++++++++
 drivers/scsi/scsi_sysfs.c                  |  14 ++-
 include/scsi/scsi_device.h                 |   9 ++
 include/scsi/scsi_proto.h                  |   3 +
 6 files changed, 202 insertions(+), 49 deletions(-)

-- 
2.56.0

