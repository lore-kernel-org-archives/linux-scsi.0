Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3508356772
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 22:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784757870; cv=none; b=g4bMVqfsrAmQoKQAkL4/zG5A1cEyuU1zb/Cm/vjOs8QdzgqHn/TOIwYaSLPUnRgyp7tEFg+2njUoZG1F93F5lqdDp9PlXdIpxCFHiYvcK7QPHw98c2j6GB8f13gwH7Zdx2Pdsi1wN0WYL1OHCx98zXdPz5lEOGH/CA3xzTqXXi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784757870; c=relaxed/simple;
	bh=PbEnauf1mpilbPgMW1YMWBABRANAYVmWia6zPFam7tw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hHeXE1lDkrsK0p625MbciunHKH1NoBuqqQvjeFGVes7Rt5JPBHUGjqlJ3MHz1Syfblat6ioHM2Hcm9JQ/9rfVwmUWqJs6ewM3lZTzbHUCa/OOspsklzFqG+niZKWQ960j+BKzHy7N+BPv1t2RM4HHw98CXJSgJkdeoLL11MOzOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=SRuB7Q9K; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="SRuB7Q9K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1784757868; x=1816293868;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=PbEnauf1mpilbPgMW1YMWBABRANAYVmWia6zPFam7tw=;
  b=SRuB7Q9KF57uxBLc6eV4/+PsHlXqouSdl0KZQnWf+BQTS8Hd8lILVz4e
   QXElOZpJylSSZrNuqfRqKGLSQ7CLlV6FgYpy8CWi5XNzICYd0ccvqqdr4
   8Enpj5rGcfNB3zl2sUbf/mxo7SKTv6WjbimCqLxX+gUiVuaOm+aqWfJcK
   AIzNO6MhLZsZmL7lIgYEfnk9I2ix8qzBo60tTBMSyTKF15ETKpxKBDmwJ
   jdHkBs4lLvAIgCmaR1z86TWqLsik+4FXlguNTaUNiU7OFKFXgJ/llMxgu
   HtYXfHmHEs4MFSfIiCNghAhZQlG12qAAW8B4S038NDMP1sZU1qSiPYfr+
   A==;
X-CSE-ConnectionGUID: rldtCAE1Q6SETnRq9ZA8fw==
X-CSE-MsgGUID: 6AZGU1dxS1CV+WBQIvuxow==
X-IronPort-AV: E=Sophos;i="6.25,179,1779174000"; 
   d="scan'208";a="60164974"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Jul 2026 15:04:27 -0700
Received: from dks-rocky10u1-dev.pdev.net (10.10.85.11) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Wed, 22 Jul 2026 15:04:27 -0700
From: David Strahan <david.strahan@microchip.com>
To: <linux-scsi@vger.kernel.org>
CC: David Strahan <David.Strahan@microchip.com>
Subject: [PATCH v1 0/4] smartpqi: fixes and updates for 2.1.42-011
Date: Wed, 22 Jul 2026 17:03:57 -0500
Message-ID: <20260722220401.6357-1-david.strahan@microchip.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: chn-vm-ex03.mchp-main.com (10.10.85.151) To
 chn-vm-ex01.mchp-main.com (10.10.85.143)

From: David Strahan <David.Strahan@microchip.com>

These patches are based on Martin Petersen's 7.2/scsi-queue tree
https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
 7.2/scsi-queue

This patch series includes four patches, with two main functional changes:

1. smartpqi-Fix-AIO-retry-marker-cleared-by-SCSI-core-between-dispatches

   On recent Linux kernels the driver can enter a retry loop on the
   AIO fast path when a request is retried, looping until timeout, and
   a diagnostic path that takes a physical drive offline on AIO-bypass
   failure is never entered.

   Registers a per-command initialization callback with the SCSI core
   so its presence causes the core to skip the per-dispatch clear of
   the retry marker, letting it survive the requeue so the AIO-to-RAID
   fallback proceeds as intended.

2. smartpqi-add-support-for-CCISS_BIG_PASSTHRU-ioctl

   Adds pqi_big_passthru_ioctl() to handle CCISS_BIG_PASSTHRU ioctl
   requests. The existing passthru ioctl uses a 16-bit integer for the
   I/O buffer size, limiting transfers to 64KB. The big passthru ioctl
   uses BIG_IOCTL_Command_struct, which stores the buffer size as a
   32-bit integer, allowing the larger transfers required by some
   management utilities.

The other two patches:
3. smartpqi-add-new-pci-device-ids
   Adds PCI IDs for new Hurray Data, ZTE, and Ramaxel controllers.
   No functional changes.
4. smartpqi-update-driver-version-to-2.1.42-011
   Updates the driver version string.
   No functional changes.
