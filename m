Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D570E191
	for <linux-scsi@vger.kernel.org>; Thu, 24 Oct 2024 00:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729728633; cv=none; b=cgxXPYNvF5XOlhuU+hPNwVhSUa3pPeG+HDe7+Cwg8Wf7NDrAPJ8hPoGqLyOj8zj1ZHJExNEBT8qpsANhiRVuQAvbMleDKFn4iYM4KhPrC/xhqtVM+P/cPM/cmYfJMWlnfbF2S64CJsxfIXqazguKbvo1iggJKkfMomINwNJddpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729728633; c=relaxed/simple;
	bh=pO8jRUQKiiRSyULkcGNzFxzb0R9zsBiicDm7NGwGtMI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=bYBDrWpPG94CrjR2AAe3e1SFn7Y2AQtMTCwHPEBW4Fl0QTljDjvQybmjRMxVsgCG8w/R/1cqlqN/V54MZGYmnFNQ0m8OD/rsKSINo8zQhjgwtnGbre3Na842mIcvPmNzme+eNfZ4+rdkT6Ee8ubBlSmirL3igASSWTIUh961AAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Nw7UpTS4; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Nw7UpTS4"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7ea7e2910c9so232312a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2024 17:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729728631; x=1730333431; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/0+RA+gT9wgHz1ORAVPSn3bBMedEidFe8UN+huLuIj8=;
        b=Nw7UpTS4+4OIh2h4akIl/nxMnNbnIb1e/EmIBZrfYu8GEPitxZVmdustcNPBMEXGEr
         aULM8Y9u5PNlmaOAVjHHiwCGvGgH98RmKoe4/NnSa1OJZNjEyd1S1gvDZWAy+xssz7tk
         EibnT3qGljU+vxPtbDh+CCMUuTsoWxHMH3aqXBUyXREszPgEueywU8DkEx3CMAMjkn/H
         h/QSePVMi161O2KkTDFL327u0SMBIRoM03BymjlRfWCzC/I66+t+/Ir7/zXmNouHD0E7
         Mt2DPvV0u4xXj9w+h3v+PkO8yqKjt1srO5cWz1wiLIN4cKUurzqieLhyN585D8saAznV
         t5+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729728631; x=1730333431;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/0+RA+gT9wgHz1ORAVPSn3bBMedEidFe8UN+huLuIj8=;
        b=VLEKueHR4UEqhZeHYpOpCd0y9M+78zK542UHpfpd83jUMSDOOmepQs3V+qBJgRuER8
         JI3f5IrnVytYBBihH4+AXl+Z7kV4/VFtiuTBDfI77RIknKCOeisducCDTkNgDYL/F4RV
         4uQHTe2umqOVbP09QylAuRVTnUjf+KPju5ZEpee4Oe7f5xdzj4KXozbF+HkKeiCKCdK5
         Zc6MpcAC+DKK2Ky1QqYNo97vE4GPxnfsbfskvhRFiw5AaiwBfRfswbgi6jMrD9VyJYrF
         s6+zU8zhghfqCzCNXbAnoVpSUJ8kvws6LAYFdxJqS8q29eO0NYGmBpX9Cg4colG5JVby
         MfTw==
X-Gm-Message-State: AOJu0Yw4cjZKRvbFRFKgmJdtHZ9nVAYJqGr7YRb0y4axEVuwhTDOxnxq
	3QhLu6eZC9EJW57vV9u7Rlj1z8Rp124je1nL0rB1lyiX34Gxo57mzrerPhcAgpMGHRto5Wdg9KX
	yiChA9zFvgw==
X-Google-Smtp-Source: AGHT+IHWiAPQ6dcAX3OI2ZAYiVWyHhqCivttd+HaZ0em72JPxSkhLuY2mR07AiySdAHahdhGtlSuBQ5RyCXMOA==
X-Received: from ip.c.googlers.com ([fda3:e722:ac3:cc00:ef:85c8:ac13:4138])
 (user=ipylypiv job=sendgmr) by 2002:a63:501f:0:b0:7e9:ff16:975e with SMTP id
 41be03b00d2f7-7edb373278emr10a12.6.1729728631055; Wed, 23 Oct 2024 17:10:31
 -0700 (PDT)
Date: Thu, 24 Oct 2024 00:10:26 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.105.g07ac214952-goog
Message-ID: <20241024001026.1842458-1-ipylypiv@google.com>
Subject: [PATCH] scsi: pm8001: Increase request sg length to support 4MiB requests
From: Igor Pylypiv <ipylypiv@google.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"

Increasing the per-request size maximum (max_sectors_kb) to 4096 KiB
runs into the per-device DMA scatter gather list limit (max_segments)
for users of the io vector system calls (e.g. readv and writev).

This change increases the max scatter gather list length to 1024 to
enable kernel to send 4MiB (1024 * 4KiB page size) requests.

Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/scsi/pm8001/pm8001_defs.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_defs.h b/drivers/scsi/pm8001/pm8001_defs.h
index 501b574239e8..f6e6fe3f4cd6 100644
--- a/drivers/scsi/pm8001/pm8001_defs.h
+++ b/drivers/scsi/pm8001/pm8001_defs.h
@@ -92,8 +92,7 @@ enum port_type {
 #define	PM8001_MAX_MSIX_VEC	 64	/* max msi-x int for spcv/ve */
 #define	PM8001_RESERVE_SLOT	 8
 
-#define	CONFIG_SCSI_PM8001_MAX_DMA_SG	528
-#define PM8001_MAX_DMA_SG	CONFIG_SCSI_PM8001_MAX_DMA_SG
+#define PM8001_MAX_DMA_SG	1024
 
 enum memory_region_num {
 	AAP1 = 0x0, /* application acceleration processor */
-- 
2.47.0.105.g07ac214952-goog

