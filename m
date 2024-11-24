Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A773A847C;
	Sun, 24 Nov 2024 07:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732432230; cv=none; b=YP0ImvqsRjHG6L4DTUsThy9Qh/OAZ2dPFTi6wL9KUVXu8OCG2Ms300lG1gR6n4uJsPmSwdBkt2YfRWQLWqH7chh5qMq6voNCo92F7csiKEknLtJhVutzACMqz/ALzl3eFd6hstCF161OtGfmnhxJOcDXPK/kZ35sM++8DfP6uCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732432230; c=relaxed/simple;
	bh=8/v+dbQ2EPfQZqv+s72OvFy8zQgKe/TlqGjhzbVcaVs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hS+3YXe0Z++g5FveUEDMlm2YDIiquXSRHFtOGp0iummXY/LMhdchrreCoN+RTxRH799X+79UNQa0Fuw+qTkCjUuZJ9M9g7i1nocb8iboDOTQsh0W7FK5XveVzP7641oGSLdFqCIgKuDzI4bbdt5QHlxYcy2iHbJ6zNfpKM/TqVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=HrJ9BGOP; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="HrJ9BGOP"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1732432228; x=1763968228;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8/v+dbQ2EPfQZqv+s72OvFy8zQgKe/TlqGjhzbVcaVs=;
  b=HrJ9BGOPCux7nlT23OSwS3wIsMCJN/5WApLNtASdfamYdOdyCFvqXBVI
   jt/WSbjtK1vtq2NiLGUQPqqLLnQ4l2AT8G/f72IChaD8HfQhw/SySgph6
   lNq6eCPjbMPkP36JN924qeNcL3fHnLIy50xmte2WKQDTqEbNQodBLDkau
   F32YqcNG1q6OCrzQzKlrbGtqIZz8rhlJz5ZG87F1JsaXVAzXMZZdaVLjO
   hwtU26uq9QuXmVPx8mYNsXgP6o43L3MJhnZzwJ1ZAlG14r2+okqtRI2a1
   5iqViWiRy08ZjqhKBIWJp9wxiyrFS0IBqGbuJdDd59Ene2IjaqF6+niPL
   w==;
X-CSE-ConnectionGUID: koQibHCSTbW0q8rRukNpYQ==
X-CSE-MsgGUID: 93OWvHuoT0O8sPzABw2T0g==
X-IronPort-AV: E=Sophos;i="6.12,180,1728921600"; 
   d="scan'208";a="32127820"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 24 Nov 2024 15:10:21 +0800
IronPort-SDR: 6742c410_L3hOgITQWY/yy+L4tyw/l5y6IhacwlPDdhn46r32GKa/FPk
 oAEvAd242bwmkETVTTmPFm63gAXT/X+0vB9u1Tg==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Nov 2024 22:13:37 -0800
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Nov 2024 23:10:20 -0800
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v5 0/4] Untie the host lock entanglement - part 2
Date: Sun, 24 Nov 2024 09:08:04 +0200
Message-Id: <20241124070808.194860-1-avri.altman@wdc.com>
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

Changes compared to v4:
 - split patch 1 into 2 parts (Bart)
 - use scoped_guard() for the host_lock as well (Bart)
 - remove irrelevant comment and use lockdep_assert_held instead (Bart)
 - improve @lock documentation (Bart)

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

Avri Altman (4):
  scsi: ufs: core: Introduce ufshcd_has_pending_tasks
  scsi: ufs: core: Prepare to introduce a new clock_gating lock
  scsi: ufs: core: Introduce a new clock_gating lock
  scsi: ufs: core: Introduce a new clock_scaling lock

 drivers/ufs/core/ufshcd.c | 253 ++++++++++++++++++--------------------
 include/ufs/ufshcd.h      |  25 ++--
 2 files changed, 140 insertions(+), 138 deletions(-)

-- 
2.25.1

