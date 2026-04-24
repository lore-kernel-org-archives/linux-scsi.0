Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155E1336884
	for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2026 21:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777067624; cv=none; b=MXAxzKSU825vjyitX2CCVRfMUxK6oEEurmWq553O9CENAlQIkmaA/r7zFJfRztDk3L77gWzOO0wJkB+ZNu/IB4TI0Djyu3WTiUNrwc9QUMjptf45etnGpkEn01+eO2H11XCaBYMMa8Ltj6oYoqOuVmaM0y42H2vNBOUhFKNT2bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777067624; c=relaxed/simple;
	bh=e04WGEWOU4b2v3Rt/DuUtxxQeTmRyYUwSTpsVi8j0aY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UX4TD5xkVkKPC3xsEMowU+MdVNKczk9Vc+8o90hIGoPlcbJp5jqPJ5t4xpHq1NcodV/IPRCMiquh0nli+4Hs5TlwvPls05GlBTsxHha4n+GdFaehw21gPR9b5SIAEtvAo4bOHx+JvT/sCkVWjgKggqg3Hs7/HwOqaW5RTPP+hfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=PqFPTelV; arc=none smtp.client-ip=74.125.82.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="PqFPTelV"
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-12c19d23b19so10922643c88.0
        for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2026 14:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1777067622; x=1777672422; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PryUNRKYpQO5iXIG9zdDnPyBT3iUePBeBzJjBgA0FHI=;
        b=PqFPTelVGPrzFlwIDa0uw8lWKJAbo3vGiz9Lmxg8uI4t3UXztCoVwJMUZ5NPKP8HV+
         JX/yOvB6hbvTdX4ds30q3LG1ZU9Hl39xWqapyty5y+kft/OuikXzz9UuPMuZ7c+URIBZ
         vruZcypKkIeVCuVkGwFm8zPbI6ib1boqZin5/bmibGiSe8xIhqMReufmO63BFhUqj/iE
         Mm3XDyqBsqUyBWcSsYjg74l/pDlc1zTXDvV4bty+AbKlORraIjcjwuOOa2JHqaNPFtV1
         z0rfSm7xyfjMRoALGySthdNQoZ8nN0xhzdstbrC0w11GLQ8ubATMg2iCRHKo+9pvpkJC
         6GoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777067622; x=1777672422;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PryUNRKYpQO5iXIG9zdDnPyBT3iUePBeBzJjBgA0FHI=;
        b=VsuTzV5RY5f+8bXF7S5EtW3U0z0wle7WVAzDC3GOSyBBLDOfH3qI6IpTGXLH4UIhG4
         jAKpnZPXoZU3+Ag7XnXRKpGQSbPp+xuuDdaWuZauol8jAxv+Reu7TqrbCJOMBvLNU9xY
         fZNJWB9AjKYLr2FspAJTW4kHsvcKC/f1Ty3ZGNW1LDr/ySrt2Yb796Ne2Baxs+3fRuCV
         8VoSIlani9veOlgu/fhQskaxTN5eDSmLT+oKkpRVD0LVu0Ti0QfZASXYKw/vHHSy4+BU
         C23oCyPugij02Z/mqcEvNpJYk6mUGAIoRPvqVS0rGytsnIPAgKwBnVCGviZOe7wnvMdm
         xDzQ==
X-Forwarded-Encrypted: i=1; AFNElJ/1W9TygYoqZbB9tz4vGEsJSiJ6q1izB7r9xPRIPKwobhu7PEXbP+fBd/p0+T4M61EYyGFI1w2dHXfJ@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/g+GsyfkKDZ0KCYbN9/SAZE+WEvkp7VAYri0NQ5jOrvx8gGvk
	A1cpXfxzGCy+SXZynekgngKN6E+118Zz85EAbNx1bQOrqic+5N3E7MAK6JebotE4USKDGuBg/o2
	6f04tsv8=
X-Gm-Gg: AeBDieuIZDaqEdxp8ogZ2mrUNevBuJZMYmnj0oyq0TO7M+Rpx5H3xCL79nnMy6KxNKw
	EXe1jZHrQPvcSuk6smwlJWjvWIOWMZ9Cxz/AQnZXwCsMxWyWMTzI3uWSLh7oZHK6AZwz5/3OT/a
	PpfMoiZFVflDEDgjySOpzHbaVbht9NsjzBk9O5V98A3SbsO0fSPFnEfPikZWhwyy+qVqmk7wpsm
	+NjLuzPDJWmpQ/RCQtNcargQ0nPC04yaZD+qnRA5xpAbkHm4sc/PHtUkoV+1CmZv9B/TtzGNbvL
	i3oPKdEoOap5wqmIZkavjLw7tetUBXyrfJwZh2U7YxI+VCRjflBdcE9sRfQ0+Mgc3pV3XSDk/ml
	xAptRt1y/G92bw4dYTarsG97vOYaEceoeUYPPgrFj+lfACjj3+1sejzmqLyxgUIiWz+RLtFGzzV
	EsYRrOTSNaY2hnhbDZESxIKDXgFBNKe8U4z4AK5za5ixKN+hP16otJ4JPJ6NSCYKR24jg8abZ7p
	QHOTi9UWJbwKlhHcpctWgJ8GJcwPCl2wKB/fAw14ao3wCrmt5zOpFfwmi5e5gWHob9E2KOKqoXB
	2HXvakvqjNJWttZctDGKbwiNsnckxXRmDGon7/RXo1F7YQ==
X-Received: by 2002:a05:7301:6402:b0:2e6:ff79:e356 with SMTP id 5a478bee46e88-2e6ff7a0423mr10574517eec.11.1777067621992;
        Fri, 24 Apr 2026 14:53:41 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.113])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2e539fa5c38sm33172246eec.5.2026.04.24.14.53.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 24 Apr 2026 14:53:41 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: hare@suse.de,
	linux-scsi@vger.kernel.org
Cc: Brian Bunker <brian@purestorage.com>
Subject: [PATCH 0/6] scsi: Support ALUA unavailable state and INQUIRY changes
Date: Fri, 24 Apr 2026 14:53:18 -0700
Message-ID: <20260424215324.99045-1-brian@purestorage.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The SCSI mid-layer fails to refresh standard INQUIRY data during
rescans. This prevents support for the ALUA "unavailable" state,
where the Peripheral Qualifier (PQ) toggles between 1 and 0.
When a device becomes available, the cached stale PQ prevents
upper-layer drivers from attaching.

Additionally, the Unit Attention for "INQUIRY DATA HAS CHANGED" is
effectively ignored for identification changes because the rescan
does not update standard INQUIRY fields.

Introduce scsi_update_inquiry_data() to refresh the PQ, device type,
and identification strings. Use a new inquiry_mutex to protect
concurrent sysfs access while the buffer is reallocated.

If a rescan detects a change in PQ or device type, trigger
device_reprobe() to automatically match and attach the correct
driver.

Fixes added:
- ALUA/UA Fix: Refreshes standard INQUIRY data on rescan.
- Safety: Uses kmemdup and a mutex to prevent Use-After-Free.
- Deadlock Avoidance: Drops device_lock before reprobing.

Brian Bunker (6):
  scsi: Add INQUIRY data field definitions and accessor helpers
  scsi: Protect INQUIRY sysfs attributes with mutex
  scsi: Add scsi_update_inquiry_data() for updating INQUIRY data
  scsi: Refactor scsi_add_lun() to use scsi_update_inquiry_data()
  scsi: Add device reprobe support to scsi_rescan_device()
  scsi: Handle reprobe for existing devices during SCSI scan

 drivers/scsi/scsi.c        | 164 +++++++++++++++++++
 drivers/scsi/scsi_scan.c   | 321 +++++++++++++++++++++++++------------
 drivers/scsi/scsi_sysfs.c  |  74 ++++++++-
 include/scsi/scsi.h        | 171 ++++++++++++++++++++
 include/scsi/scsi_device.h |  13 ++
 5 files changed, 635 insertions(+), 108 deletions(-)

-- 
2.50.1 (Apple Git-155)

