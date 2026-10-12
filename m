Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854AF4BEE3B
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 21:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791839147; cv=none; b=d4g94BS6rPE/iW4ThsR0RF1tA/yz1KB2BirOSk9aVWrSb4/+AeGFEL0+BBWzT56nWQ85akMzr4LJe1+EOrtLF4n0XiMlVUm6+84hnq5Qp9S1jCCsK9Flev7tWLKlz1JxuwcdrF44wgOrFSSPs3pnPq9LwYToOyukZkCCuWKRTIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791839147; c=relaxed/simple;
	bh=RvT/V1TZAaRQLqpYVenswOILIYCMdr/ePY4KFkeJE1w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kgyoRUmVK0VdJrqBIO1hylVUfu+cLjgJvtZclGu4AbuCnQUklH5cnifv2ZLgsADaBAXhIgNimb7lk2OnAm5JdGozaU+j0p9lGv7+l6jKnCD02wIwy6S04O7Bt4Cpqg5MaoGHiEpxO91GkVE8Yd9ve2wAZ1B70axXhGcxFeoYhKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=YR2zTM/j; arc=none smtp.client-ip=74.125.82.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="YR2zTM/j"
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-3282db206d3so4079333eec.0
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 14:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1791839144; x=1792443944; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AMX9zjzCDrVeJQDs4KetznunpZvuWVM0X3xpjtftzqU=;
        b=YR2zTM/j9gIMX4nCyF0f8xM1eXoMABvNIOBxKSDNBsowv/u3OUvw5UEhg1GiYvLI+h
         IQiU+JTNu+ebQwe9wlHLxdQcQBWGo1P1ka6vAQeX5QMw0fA+KZMBCI0mrLZ70l58zcvB
         gWSYKGCZg6mK77FvEOaKgIPDqBCB1Hh+gYDgUqxGSyslsgckbi6gjfG2QuV/+EastP4t
         fm1B73wRwTpKu8drUk47LkUId35TVS5xB78Jv6i6mtOULFp6qqdC/18STc81zULpoiUx
         rwf9NP62abRdN08CRcMWF04/SOPj8fPnMY12+s4DOXTuBZ+nu+KmQjPDibWuCQ/7fzER
         p0CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791839144; x=1792443944;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AMX9zjzCDrVeJQDs4KetznunpZvuWVM0X3xpjtftzqU=;
        b=zH9g2g5KNISSZ1iHslMHe0/Z8vKmW8s3p9hWxpG9UHJHGi8C/Mgg8K/OI4sfSLXkLj
         4gxs6EMHwPKffrgln5AdVdHFJ6IQlGoVXwy+d9Ttjr0QHu0QlFuz/5R9G32GEg4FP0jF
         nQ7LlVU+zk7Z+rKTFQ/Dwk+ND1239VwLJu32U58FpaxL3XwFM556DmgpaUaOuE85aySw
         y5eCGwPgJZi3gpTZx6GTHxUpW1Tq8DnC1E8eBfX0aNsPek3rR+ch/pLT6g2V16JxwH95
         uS1dmXJ1OAvctbM0tCvt06Eay91ULeTSf+ZPwYhOFRsGUgFKXoMkRqeLfl+vbtcUPa5A
         x7rg==
X-Gm-Message-State: AFq9FYLqYVM7bR6rCmN8eStAcheiieyRBDI9dRmKa8I0HNSvDMtmOw/t
	aE8iGFGB1LnssGJAGDge1yE2t9gpmmlgK2G0VXAyGaXCZDbWFmcWb9zW6cOCzHrAaMNYcO97LzG
	bBZ3MWpdIYyrePV4dsvo5cWXnqFXkzf+f0cT0+ZfNTOlb6Ky7AyfeTnGLrcGjrenNBTJg5fAz24
	P7aFUfy9FyPo///D0YgKLqdyvYftT674xDxCgvX1Jkd+9d4C3n1g==
X-Gm-Gg: AYBFou1kl+4mROcq4dQORgsDllbdj1QCgitxCKvjaJJsYEVyoeB3SLiAQiYuIkAnNfX
	LH1su/i9qHovXTWZhL1fysVbs/4e3r8L1J8jCcqB8mnRnpVEKb3GAIf/jAHdbX1fD3XMwZTPcRM
	9ss626ews4IHz5P5WJFi4CsByiN+VsFCMr6omGAyWSP1dsK9oJXJ/DDkjbzhgssz/EG46QIh4Io
	EeO+lAEd9tuxD/1651Vebe6wU3sM7yPUqNOkDLr7eaUdghKWrMN3DveFNShrWe7zl9wp1ocnGOn
	RxZzP1FcmGZ6PLDlfcADEZlbU5N4LDw9CNmcc5gdFER+bPnXPqzpPs3mdKurioeCfiyCLoEIFUo
	cJLLNMiYJtT7s9MgcKR04PiQUg+TPAp6dpRpnpVXqfRIH5n9eT/v2jJAIB+8zV4xgv5MYh1zpbp
	R1c7bj5tf9UyY+QFq21aCbKs5B+/r+DL/1JFDOiRxWoT+TFl3qmevJOHcZG/ihaXUgu92h9y3px
	N1NT9H9yrkM+INEPIB9dTMH0hcdyczKnuLKxZOTuKG6bDVMVe9RCndcfMknywC5+AZdY+2jd68P
	VkW/FithZmPD1eG+nQoUP9lUbmS5BGH7RtzZsULwkFoo8JfSVo93TE4bhsmUG4FL0l3Ysg==
X-Received: by 2002:a05:7300:8420:b0:351:7f5c:dbe1 with SMTP id 5a478bee46e88-3537e02318amr16688478eec.28.1791839144147;
        Mon, 12 Oct 2026 14:05:44 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.201.68])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537cb2fd33sm35528777eec.28.2026.10.12.14.05.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 12 Oct 2026 14:05:43 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	James.Bottomley@HansenPartnership.com,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	krishna.kant@purestorage.com,
	Brian Bunker <brian@purestorage.com>
Subject: [PATCH v6 0/5] scsi: Refresh INQUIRY data and reprobe on rescan
Date: Mon, 12 Oct 2026 14:05:01 -0700
Message-ID: <20261012210511.16061-1-brian@purestorage.com>
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

Changes since v5:
  - v5 was applied to 7.3/scsi-staging but did not make it into
    7.3/scsi-queue. This version is a rebase onto 7.4/scsi-staging
    with no functional changes.
  - 2/5: Resolved a context conflict in include/scsi/scsi_device.h
    with the removal of the scsi_device_from_queue() export.
  - 5/5: Resolved a context conflict in scsi_probe_and_add_lun() with
    "scsi: core: Pass the SCSI host pointer directly to scanning
    functions"; shost is now a function parameter, so the local
    shost declaration is dropped.
  - Build-tested with gcc W=1 and with clang 23 with
    CONFIG_WARN_CONTEXT_ANALYSIS=y; no new warnings.
  - All patches carry Reviewed-by: Hannes Reinecke from v5.

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

 drivers/scsi/scsi.c        | 178 +++++++++++++++++++
 drivers/scsi/scsi_scan.c   | 353 +++++++++++++++++++++++++------------
 drivers/scsi/scsi_sysfs.c  |  28 ++-
 include/scsi/scsi_device.h |  13 ++
 4 files changed, 447 insertions(+), 125 deletions(-)


base-commit: 2f4880c22e838d54eae9ab153b0f8dce60531bf1
-- 
2.55.0

