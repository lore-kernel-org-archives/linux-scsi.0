Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793228901;
	b=AnVwNwDsXTHmrgwhpQasPAy2SJy77F3sRg+xsttxcbV6EMIY5Rec5u6q1Tb+1W9SjGMl
	 PZG01BEfQpnNNn8z3zN80t/7uU7H4OgpZPEybmN7R5L9hSEQp5pCaPAWLVtZKqplY4qK6
	 6mu+06Ko4yoBd3qakhoEoCRjl9FTAbcZZSpJBIRlHCJU58fJ1GaggnpY6WnUr9CaBC+H/
	 24CEUQJHpnTdj6ZRYuTECXeMpgt3nwhKxoLBv1QWBjJlBgYVR1aqxY5eMsiqTMTbvfee9
	 IzONonzSzOZTcyocT/G3almRioDDZShwh3i1+79xxkiWRlbhZ+ZpmgLeYr+6VsyK3dQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793228901;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=JFQqToevuvrxaPCjwwRoiY1XvwwgF01re/Bw95KJmeQ=;
	b=q2MvF6m6f7rE5KzgC85PTB1PYCkQ2EVH8ztmD/SQc13lgqGPRelKRi71ijN5rjJMi56n
	 Y0yEZLCW4WmMLiMDEc16CJAnsMkqjrIxcfSFD1VlawyvMWxAEK1znPtuT041EJilqQOx/
	 rC2KJvRn3fPxhBbsAdo1H1ecB2yTzy8qOr0sDvQ7T/uO0jDPrQhqfpKbUdI/M+3/x84uc
	 GNThFtgCVjKRxFq7+3rphMwmYhizj/LIOHIqMFcm6r6yWnm3KkkLaNyDAi0JlQYYVOXdQ
	 eE9d0oIbLpizDQeiX7gqrRK+IDjhzCr46wX9Z+3XrkEn+Lj0p0Tv1vLJDw6BJyGRItg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=TwYVqcTJ;
	arc=none smtp.remote-ip=74.125.82.169
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739A7606A31F
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 23:08:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 739A7606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=TwYVqcTJ
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-36a18fc7a38so3106957eec.1
        for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 16:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1793228899; x=1793833699; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JFQqToevuvrxaPCjwwRoiY1XvwwgF01re/Bw95KJmeQ=;
        b=TwYVqcTJwLKtsKWdIdnXnbUoptrwk+QuXbnyN2bFaFB4t1NzkncXa+5ogkPUH7CgF8
         8PIOsHaG5SPjOnYz6bSPBBS/rgZblk1Z1+Fw8j7SDZQqmwYBG8xZK3BQD/UPibsLllAo
         rfXmJ5d7rlR05rsbI2Wt3QBl7ePemmb4KkLYx24xQM7MtNYGo6bv5A1fHDfiNVP8qIfq
         xK9zzgXMoYQrVuTjhR1OFUZF25JzTMePNy8Uz/t1bO+nl8WUpKnUhTt/UvMeBNuhfwnV
         gqd97W7OSpHbh8XePqaH72KYBQFzxaC2hFkiM3tZZPIp/cZZePR3WgvKbnWHAde0Qm8D
         1GvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793228899; x=1793833699;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JFQqToevuvrxaPCjwwRoiY1XvwwgF01re/Bw95KJmeQ=;
        b=jfWxU1alZxYfJuTfaN5/Sh506ymJzI66b/lAnO5dTJqtM3XQFduswdbKoC/wSE/mVn
         tVm5pjdiuOJ2zIl2op4CB6VrXOMw1/Iin5kLpxD8RDbfCGOyYa6uY506sTUJIhHgTDK3
         aiSPX00tcBfZ5MeQBC3CpBnAm3Ps8phN8gA+UDU1/zh6daoE1j0ruxVFU3nfer/BuTtn
         dVXdIsN6bOfV43yPqOgvbk+Pbk+/WUoCobyarMdM8itOsfEOkTBTPlw13CH3NfHgqSEW
         BwrkulnBWhdQbmJHQFztOY+YJZKqbIFg9Z2dv5dv973lVAB4TTM0hvapgeXeA2rRe2n0
         UMhQ==
X-Gm-Message-State: AFq9FYKiqF9joavL6AKwGXbo+BRFdmu/eoAIvpLSDNHY9MUA7qlfqoCF
	4RZI+B9X9ZRHn3c76BM/VVYfLY8i77hnW8OFeTaEjoCf+ph9XKVsIeXLlje9RY619LCyL2JqjMD
	0UYXb+mk5/n8WVgdic4HjUHvGBavbYMptg0Z1wR/CfqxHmY/r4DAMMaK+Uf9ht8bVsA05+qIaVf
	SK+eK79M8nvv7f+NQF7bsuBi2bjM+d4jtjyqBo+LDoD6ZRsCfWzQ==
X-Gm-Gg: AYBFou0dLWF2Tl2K8gH7fCile3K5ismOjbCwp6DjszJkktHfrlLzUgbT88ulb2/qEcA
	nEQC1R+k9PKfieZBY+VjBpaBBfMhZl223JHxlxPuhCs7UVQMWCPVTHC97JmhChP+sE8P6pYWWnn
	02gT9c8Kg5fVUls+T7cUeIPjBf2R3f+47bpmN/DFfql+ak8YmbW2HFhpBjunA5Cj9LFtrnLchi8
	49jbWJtsDP8eayvo43EBRJ9dbRh/YPf8RZtTF1KmSzPyghkiHLDOnQngXAswhoW6LlbMmfEOqaz
	4jRNtO8dUPY53jlbwWZE8JgpXjqqLBym7+tLGNKTbWMmstfF7913LXrj5W3MIE8oniitFx32wiB
	hdr/Hl6zNdkZUP+idHMObCx1QMroxNH+VMXqiYy4xyuVFYafwHBwI7f75SF16RjZawZMW3HOkjP
	1vU1ET9jA4pef2zB6VFpgeyGF7S33ag958OOKy9N1I1tOsO2ksfxu0qbZKNijCrRb5v6OmShU2E
	0tlbK3+4QZ/yWjq80qEdv8z07Aaf1M72sLSdwVSy0u74cE4UhMc+iK5Ip+IinwFpoLMiBpS311o
	WTf3rBVu94LM1KmAz+sieEIpkGcmAZ2Y59WbVXZDpp2OPEd+v8x4XJa03xCkYGnLFQVcoi67Usk
	ozzm7yvDSNlhGccoEk1cIsBfcVy5/JLmqJ4ZyBO2rqjhP+d5OZrGtEZ6HyxQFXfcbvANBjOHocN
	oXKxoMEBM0Pj3G+qHzPwr+Ymad+VQQfDJ99q82g3sKaA==
X-Received: by 2002:a05:693c:8951:10b0:36a:1c75:8ca3 with SMTP id 5a478bee46e88-36a202e975cmr5325576eec.1.1793228898909;
        Wed, 28 Oct 2026 16:08:18 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a26d59f0fsm8156513eec.6.2026.10.28.16.08.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 16:08:18 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Hannes Reinecke <hare@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: [PATCH v2 0/4] scsi: Bind sd to LUs in the ALUA unavailable state
Date: Wed, 28 Oct 2026 16:08:03 -0700
Message-ID: <20261028230807.61578-1-brian@purestorage.com>
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
multipath map as a
failed path, and the existing UNIT ATTENTION handling brings it back
when the target port becomes available.

PQ 001b cannot be matched on its own: an unmapped LUN reports it as
well, and some targets report every possible LUN in REPORT LUNS. Binding
sd to all of those would create disks with no backing LU. An unmapped
LUN fails REPORT TARGET PORT GROUPS, so the access state is what tells
the two cases apart.

  1/4 moves submit_rtpg() out of scsi_dh_alua into the SCSI core as
      scsi_report_tpgs(), so the core can read the ALUA state of a
      device itself. No functional change.
  2/4 sends REPORT TARGET PORT GROUPS from scsi_add_lun() for a device
      that reports TPGS support and sets sdev->access_state from the
      descriptor of the target port group of this path.
  3/4 starts a new port group in scsi_dh_alua in the access state the
      core read, rather than active/optimized, so that no I/O is let
      through to an unavailable path before the handler's first RTPG
      completes.
  4/4 matches PQ 001b devices whose access state could be read, which
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
    MODE SENSE. alua_prep_fn() already fails normal I/O to such a path
    without sending it, but sd's probe commands are passthrough
    commands and are sent to the target. If a target rejects them, sd
    keeps default values, such as a capacity of 0, until a later
    revalidate, as it does for a standby path today. If the path
    changes state while sd probes, it can also end up with a mix.
  - The ALUA device handler starts a new port group in the state read at
    scan. If the path changed since, that is stale until the first RTPG
    of the handler completes.
  - The standard INQUIRY data, including the peripheral qualifier and
    what sd uses from it, is only read when the device is discovered;
    the kernel has no mechanism to refresh it. A rescan, e.g. on the
    INQUIRY DATA HAS CHANGED UNIT ATTENTION, reads the VPD pages again
    and revalidates sd, but does not read the INQUIRY data again.

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
    scsi_bus_match() uses that. SPC-4 requires PQ 001b in the unavailable
    state and an unmapped LUN fails the command, so this does not
    depend on the state the command returns, which can already be
    available if the path recovered between the INQUIRY and the
    command.
  - 1/4 to 3/4: No changes.

v1 cover-letter Message-ID: <20261028184216.25453-1-brian@purestorage.com>

Brian Bunker (4):
  scsi: core: Move REPORT TARGET PORT GROUPS into the SCSI core
  scsi: core: Read the ALUA access state when a device is scanned
  scsi: scsi_dh_alua: Start a port group in the scanned access state
  scsi: core: Match ULDs to logical units in the ALUA unavailable state

 drivers/scsi/device_handler/scsi_dh_alua.c |  72 +++++---------
 drivers/scsi/scsi_lib.c                    |  52 +++++++++++
 drivers/scsi/scsi_scan.c                   | 103 +++++++++++++++++++++
 drivers/scsi/scsi_sysfs.c                  |  14 ++-
 include/scsi/scsi_device.h                 |  10 ++
 include/scsi/scsi_proto.h                  |   3 +
 6 files changed, 204 insertions(+), 50 deletions(-)

-- 
2.56.0

