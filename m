Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC99E186E2F;
	Mon, 18 Nov 2024 14:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731941020; cv=none; b=c+ZYEbM8SA52OBLBPpPmn45qBo7bI4FPwhL7xGNJ+ULKBveJxTwTAn9JgOFWr0EMXhj9Mq0zr7rJhbUKB1y1pm2F9M++3Tn6KtQf3LdtsI1D3AmgcbH/HgAMgcQ68qsKevGX1nAGYPZ22NR7wphWCEdkwJ/QxuqVwhZnJcrrFKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731941020; c=relaxed/simple;
	bh=Dkk0XeDnaFtE5cVUjuvg9bSVZiOP4HdJhrV5nNAMbN0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jDv4riCsMW83Y6oVHutvLO5jLzb2obtXmS1BHw888nJLwTqLI3uuDk/uz8r4dKnX91b5SflG79yrLUzaWMDRAGDjKb/ebQnJwyeDTBcaMB+gdWdoGn6lordF3BXZ0CfAWTg4nZgnmdCAfOlHX0IBAAhwAzje1R3HhqVuaWX9w18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=gA5cVfEi; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gA5cVfEi"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1731941018; x=1763477018;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Dkk0XeDnaFtE5cVUjuvg9bSVZiOP4HdJhrV5nNAMbN0=;
  b=gA5cVfEi16XxRZQUGM+gKb+Pj2glMQ6YW36fdMbOWM7mr29wihbQGYv1
   2FsWDEpO5xyTntf+r39LjGdQ/1WY922jpGq+Jru9wbj63AB1KMpHJ82Ki
   ftN5PE5MzhRh7h4up7lsg1kheYFj8bOd0tZ/30X2Xr4UpcBZh2LH+tnQy
   NYvp20tzLZlh/hFh8PNdSl60WKIl1plHWjfBFp3zXlbX0JAhAFL9KapZr
   TfaMrWRx5NZAjtrjW40ZbQ8ksk1uaXEndAMB/rwG5EBpv5bWogJskly0+
   fLiNwnEpEofdsk7QaYblriw1hSMqp7KZ81tUYpWeWhl7Ws1c9sP1Eu7Pz
   A==;
X-CSE-ConnectionGUID: A/ZXw9ADThyoBIRuy4Ozqg==
X-CSE-MsgGUID: /EFaHezzSwyULveKhUMHuA==
X-IronPort-AV: E=Sophos;i="6.12,164,1728921600"; 
   d="scan'208";a="32754292"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 Nov 2024 22:43:37 +0800
IronPort-SDR: 673b4553_IiYCXxX2kQtVsIh+bhvZ03ixmAb8YDtjpdD6nmlAa1r4Z8c
 1a7kBd3/tODgmo/claKdNvNh3g6Tzjfr3RRgMvw==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2024 05:46:59 -0800
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2024 06:43:35 -0800
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v4 0/3] Untie the host lock entanglement - part 2
Date: Mon, 18 Nov 2024 16:41:14 +0200
Message-Id: <20241118144117.88483-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Here is the 2nd part in the sequel, watering down the scsi host lock
usage in the ufs driver. This work is motivated by a comment made by
Bart [1], of the abuse of the scsi host lock in the ufs driver.  Its
Precursor [2] removed the host lock around some of the host register
accesses.

This part replaces the scsi host lock by dedicated locks serializing
access to the clock gating and clock scaling members.

Changes compared to v3:
 - Keep the host lock when checking ufshcd_state (Bean)

Changes compared to v2:
 - Use clang-format to fix formating (Bart)
 - Use guard() in ufshcd_clkgate_enable_store (Bart)
 - Elaborate commit log (Bart)

Changes compared to v1:
 - use the guard() & scoped_guard() macros (Bart)
 - re-order struct ufs_clk_scaling and struct ufs_clk_gating (Bart)

[1] https://lore.kernel.org/linux-scsi/0b031b8f-c07c-42ef-af93-7336439d3c37@acm.org/
[2] https://lore.kernel.org/linux-scsi/20241024075033.562562-1-avri.altman@wdc.com/

Avri Altman (3):
  scsi: ufs: core: Prepare to introduce a new clock_gating lock
  scsi: ufs: core: Introduce a new clock_gating lock
  scsi: ufs: core: Introduce a new clock_scaling lock

 drivers/ufs/core/ufshcd.c | 255 +++++++++++++++++++-------------------
 include/ufs/ufshcd.h      |  24 ++--
 2 files changed, 144 insertions(+), 135 deletions(-)

-- 
2.25.1

