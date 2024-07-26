Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A3B42AAA
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jul 2024 22:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722034797; cv=none; b=cw/YqsFLil7YSUvqJE4pqM22IS66/bT099EF7/kcZrQh6QYw6ouxLbfJgLnZNfAXq3cWKKJg48iPZgFcx2kNVK6/ypi+A4mI3zGoJdZA5ImCipQswxCGgzcJAEkUGViw6WEVyS8ehLP9km1hdLPn1EmG4O8/EHEyFFg+lILLNHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722034797; c=relaxed/simple;
	bh=49nsACGGl6ZFR/KpOPx/QqjWBGn5p3/yxytVMcoH+i4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jNbXLVv/bfrUQviCTAS7mQUUWQnYvlNfBP64SM0AKXEordohoQfbDKkcfLln53jbDrXRUGgEn8wILTuhUkcM2/i/drMONOycNwbqrkgb6lD4xn1Cd/AmmmvXxaiFgJF5PU4/DY/c75MR0n05YLuIcWBDEdEunHeTXjinQH8asqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TkACjVY8; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TkACjVY8"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-6e3341c8767so29779a12.0
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jul 2024 15:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722034796; x=1722639596; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aKGXTX9eM6hy6hjOfxi7j6CdpMpwaTLK8iNy8+LrLKo=;
        b=TkACjVY8isqNs4N7YNNChVYjDIZo2h6Ry0MwbnL7bEyKV7KUOtb62METv6xCmxi6xx
         Hh3fxIb9CIXM0C0RVgRFHnNrq8UeB4WKpeEPVftmuaF/zt9Bk+9oTZquPP5U7zvaDdG4
         oLK1SyGxU1fjx5PygZdUTrgTs3XXZa0OCwPt2T06gAQsz1nEbsLHBnm7KnoTzI3pe6k5
         He7vKMknRagTfiX8nrBuP+fCznvE7snMAGGgm2yRuMPFKz63EC0MLqbUlYoORugogR10
         E5jj9HSvu8zJuyGuNKxQI2ukbJcsoAB5JnFC+3c2rePK7nahCgdNQFMQhM+tTkzKioY3
         R+AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722034796; x=1722639596;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aKGXTX9eM6hy6hjOfxi7j6CdpMpwaTLK8iNy8+LrLKo=;
        b=X9IejBiBzNUfSJG9jjGHYOYE02FJMl6wI3QXfaeplR6yntqMzGggkQeeoohz2FVtx/
         bKEZGoMtEgKEEfdWsNNE9DIYouKxfw+vg0Idh1CzI0L0PafGtsIT5Ty/sdFa213J7gU7
         gt5Ehqio7MeOunfQEpPotbwAIc9vE2u0cjI64qTfhpPyFL+vTuHqKrBsRcTYT8yhB7hz
         BEDBh+KT2DSXNL82hsz1J2QqLHtyxvHuDr5DZSv0tkUe2ekyXjqcm+O7jYZp6ZrzqN+L
         CQvOqhoQ+NIjY0jbgBiTMQSZG8v6+IUHMtAgjXswYjKd9QCOIGQa+sjhlehFoG1k8mTI
         kdag==
X-Gm-Message-State: AOJu0YwZXKBim6RmfeAOLGTkcWoBMHvHZPlJdwt6DqOgT0nmx2Dn9N6g
	FwVc80H1CeWAX2hL+dgQW2EH5J4OjaU437ONLEcLg764RPluqIkFB6abVg==
X-Google-Smtp-Source: AGHT+IFbEkSFVKmKx8tBkk4MQxT+sYPo9fOl4Uyh+Z67oopPn9fuVnqRy7VeQYypFL2OIbQcfrVlvQ==
X-Received: by 2002:a05:6a00:8596:b0:70e:a06f:7057 with SMTP id d2e1a72fcca58-70eaca93f4amr4854755b3a.4.1722034795543;
        Fri, 26 Jul 2024 15:59:55 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70ead8834b1sm3308540b3a.178.2024.07.26.15.59.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2024 15:59:55 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 0/8] Update lpfc to revision 14.4.0.4
Date: Fri, 26 Jul 2024 16:15:04 -0700
Message-Id: <20240726231512.92867-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc to revision 14.4.0.4

This patch set contains diagnostic logging improvements, a minor clean up
when submitting abort requests, a bug fix related to reset and errata
paths, and modifications to FLOGI and PRLO ELS command handling.

The patches were cut against Martin's 6.11/scsi-queue tree.

Justin Tee (8):
  lpfc: Change diagnostic log flag during receipt of unknown ELS cmds
  lpfc: Remove redundant vport assignment when building an abort request
  lpfc: Validate hdwq pointers before dereferencing in reset/errata
    paths
  lpfc: Fix unintentional double clearing of vmid_flag
  lpfc: Fix unsolicited FLOGI kref imbalance when in direct attached
    topology
  lpfc: Update PRLO handling in direct attached topology
  lpfc: Update lpfc version to 14.4.0.4
  lpfc: Copyright updates for 14.4.0.4 patches

 drivers/scsi/lpfc/lpfc.h           | 12 +++--
 drivers/scsi/lpfc/lpfc_els.c       | 79 ++++++++++++++++++------------
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 14 ++++--
 drivers/scsi/lpfc/lpfc_nportdisc.c | 22 ++++++++-
 drivers/scsi/lpfc/lpfc_scsi.c      | 13 ++++-
 drivers/scsi/lpfc/lpfc_sli.c       | 13 ++++-
 drivers/scsi/lpfc/lpfc_version.h   |  2 +-
 drivers/scsi/lpfc/lpfc_vmid.c      |  3 +-
 8 files changed, 112 insertions(+), 46 deletions(-)

-- 
2.38.0

