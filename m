Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128CF1DDC1B
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 23:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781825726; cv=none; b=ld3WrRHs3sz2/VXsDy1GQ3DI9IYmIlDtakUY4PpKpnJWQj/2RteDujhL9/fuJbq5wJG7IWLV7UrxbGJJFzNosVXkMJsVF+tDB+K8N75xV36hbwD9d4Ocf3jjsDFquAx3ZZQtyM9wRdKU2JOZxRaQ/WziB2rIGriXqwQpAKRsXgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781825726; c=relaxed/simple;
	bh=qoEvpduEh47V1xBC4e6EJdkuU+W07DgwydpFtaOUDdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SuZJ4+K1oFEZy4ifrLJeRHJ056fM+d3HOV7r6bflrKIkI02oB2ZaaVd7uLZdKEtBV5HUtem2edNKmhLSm+BVM/37prOCaBNxAHctF8CUfB6MdCLtevEDFJ369P3gyGIDoGMEV+4Suw9NZuMg8RIjTIyAUXnxKkk1TrGYUQF91fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=GEoopQiW; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="GEoopQiW"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-45f3cf907ceso787281f8f.2
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 16:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1781825722; x=1782430522; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SFO7jMFR6Y54fe2quMN9RTrhHTgJyAYWifEG8JEUK54=;
        b=GEoopQiWP7Smz3CXyLOlGsKudtW1Kqo5CFSWqTJfkf7hUCNwGfX4w3bya1AhWtCfrF
         WHURFlW4xZvk6z+ubu81t4Z56l7itPDXiOSP1lOWXN2/QFqL9kpsNSwN7Wc5wBdnp2RX
         RWuaUuUXJyK7TyvLcZLrKMgsYOTM4KLcGlB75bkESfFCFJA0weA2+4tp491heEhirkLr
         SYeHm2YsRMUDSOhE6D9aDr8vy0T1QkXzxK+xaeLyCitmyMSrqr4fc2oQYgRhIP0bBYWQ
         PqZYMEf0jeOuMhCcoXkEtzOTU6+P+kDSMsW/XyW44LWdH/ytVxP2VNv1w2juzndV5BgB
         YH/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781825722; x=1782430522;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SFO7jMFR6Y54fe2quMN9RTrhHTgJyAYWifEG8JEUK54=;
        b=AFFgtXnXdEmIV78sI6H0KeHMr8UrDTS/ZCyUn2zylXJIREFdmtG0alqbLLuWdx375D
         q3G65kx50FUY76uMT5JbduXnoRKWw0s00EzVgDFauxfKZlnibudBAF6GoNaRcxKBAqh9
         z2KV1qTwpFHlN8q44ovjvLWwWp7hoU2IWuuReodtqq/QvaBfdTyz2TDWrBDCY1YyiT32
         va01KbbrY7MFzIUEMzZdUSzWMKKPUh/57CuR3yaXGuiqK3Qb+NUMIvbsUezTEJ/8SNln
         NzCs80NRutRudmm0jdOPCxQtT51seK6685RfdDCK9BQ5DUN2RiRtEKzxatZoFqC6R7bD
         kyPw==
X-Gm-Message-State: AOJu0YwdFwr5p9XNEzYsRqMgYYwF52/1CdVz43fTXfN2pldW/4+jYZbW
	IiSv4kdpPhOua0zEZCSIYLcu0ans4/34runNrUelTbXcNQh7wXMX+d8TjYpa+b/5EMiMyOH2fyM
	NBCqJiSHklqOD3hWqGL7SYHKYs5m7+gfPI1yerTnib8nJvXr1vpreWHTtYSCRekymq73SW9vObw
	KhXNhgzZxqoz0LurwhpuJ9be54BKOxjXH6TrUKwLif8LmQt2Sydw==
X-Gm-Gg: AfdE7clYZaaYbuk8659l6xqEUnG0QDkkKbhTuwieO3InBG/1m78umIEOxKkp4MFLy6X
	tTaNrDstMSr8XlvMiy7PZ0vjDRxXdyCp7Cn4wsoN1P3JeRLs0Cls6alrWw2tbRwqmt92eoVHGK1
	BRo68iWYgECSrLUhHbJGybT4WPMTGAHJW3vfSG0b3QEyRb+61oEwZTHydhzO8BAM/mm+g12gb78
	Ca6jLrKiykRoNSraQTRGzeadwh17yT86jnIQAc/oyvUxNBcqbN/A8JjE4w63ni/CcovelE38GXH
	gC45cLrpamjNjX/vVBKe0SKP2XCwaHPlvtDGKWfJEnWCr4wm9TNA77IM62lQDARkoJsZK0iIfHP
	QiblJ3u4uYJhfSrhwvkekTata/loWx/Uw/BRXn8ZW5kbEJXqczaJh3uB3cydwWqcJltauAkfGL5
	2OE8RQbpSser+eLQH3eb8zdTwOfmMZoHlDTvMr4KT/EGM28KIB2WcE+Utv5yMPr5AuKfUA7bYMi
	edcQZUFwlMqgzRnxlxYrOnqGPLu1hni2gNIs2UftEZfla9Y3iaU79xL+i5UDcj1/6NP+hA8cStW
	9GWBsvAKmMow
X-Received: by 2002:a5d:5249:0:b0:45e:f5b6:7bf9 with SMTP id ffacd0b85a97d-465024021d2mr2003855f8f.31.1781825722385;
        Thu, 18 Jun 2026 16:35:22 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.79])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4650b67a34asm3492468f8f.22.2026.06.18.16.35.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Jun 2026 16:35:21 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	hare@suse.de,
	bvanassche@acm.org,
	krishna.kant@purestorage.com
Subject: [PATCH v5 0/5] scsi: Refresh INQUIRY data and reprobe on rescan
Date: Thu, 18 Jun 2026 16:34:59 -0700
Message-ID: <20260618233508.97960-1-brian@purestorage.com>
X-Mailer: git-send-email 2.54.0
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
  2/5 adds scsi_update_inquiry_data() as the single point that copies a
      freshly-fetched INQUIRY buffer into sdev and updates derived fields.
      Returns SCSI_INQ_REPROBE_NEEDED only when peripheral qualifier or
      device type changes, as these are the only fields that determine
      driver binding.
  3/5 refactors scsi_add_lun() to use scsi_update_inquiry_data(), sharing
      one implementation between initial-probe and reprobe paths.
  4/5 teaches scsi_rescan_device() to refetch INQUIRY and reprobe the
      device when scsi_update_inquiry_data() reports a change.
  5/5 wires the same path into scsi_probe_and_add_lun() so existing
      devices encountered during a SCAN_LUNS pass get refreshed.

Changes since v4:
  - 1/5: No code changes. Added Reviewed-by: Hannes Reinecke.
  - 2/5: No code changes. The per-field reprobe detection (old_type,
    old_periph_qual) is retained: device_reprobe() should only be
    triggered by changes to type or peripheral qualifier, as these are
    the only fields that affect driver binding. All other fields are
    refreshed unconditionally regardless of the reprobe decision.
    Added Reviewed-by: Hannes Reinecke.
  - 3/5: Added a comment documenting that scsi_probe_lun() already
    enforces sdev->inquiry_len >= 36, so no max_t() guard is needed
    at the scsi_update_inquiry_data() call site.
  - 4/5: Rework of the reprobe path in scsi_rescan_device():
    - Added max_t(size_t, sdev->inquiry_len, 36) at the call site.
    - Hold get_device()/put_device() across the device_unlock() /
      device_reprobe() / device_lock() sequence so sdev cannot be
      freed while the lock is dropped.
    - After dropping device_lock for device_reprobe(), re-check
      sdev_state for SDEV_CANCEL/SDEV_DEL on re-acquire; drop the
      device reference and return -ENODEV if so.
    - Mark device offline on device_reprobe() failure; failure indicates
      either a bad target (-EINVAL) or OOM (-ENOMEM), both of which leave
      the device unusable.
  - 5/5: No code changes from v4.

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

 drivers/scsi/scsi.c        | 178 +++++++++++++++++++
 drivers/scsi/scsi_scan.c   | 353 +++++++++++++++++++++++++------------
 drivers/scsi/scsi_sysfs.c  |  28 ++-
 include/scsi/scsi_device.h |  13 ++
 4 files changed, 447 insertions(+), 125 deletions(-)

--
2.54.0

