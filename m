Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4C55C603;
	Tue, 15 Apr 2025 00:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744676895; cv=none; b=b2gbpU/FAjy6i+qr2tS9iEa/Iq88KcINRfEswB1y2FcH2Ouy6HLuzZMOsma7B44ldpIT7XZjv2IEchgCKItgL4/D5io9ruyo1iKWU8E1Ll88g8RtXvX2JVx8z7JDAxbRYw36s4Pvf3pfQJEpjB7zf81oKxygvxDMUv1VmOdeWUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744676895; c=relaxed/simple;
	bh=a7dJNOH+4tJR5SrQCOkwdoMtUN60GnmTg0hlc1xgULw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gPMAuz9/kVCBg6Oj5/O03xdBsQ+TwCpep85ZfZutcCT0oBmqUb8WVS3WkC3Ek2VrR/9K59Q94mXU2KX7fI45W8wz6zyWRyFksCzkvzBIuMzdp6DFQbQDJfrtqsnGKAj6wg2EUWsvktdlosLbGEXtrYiAtbi6q9z9K4yxFq9sVmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=Ya0Jo6rx; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="Ya0Jo6rx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=aswSlc62fjsfBj4P+yx2x3RHzmY1+XO60LudTf6Mqe0=; b=Ya0Jo6rxJrg0mhqE
	BDCggEwyHNtcRbDVCRi0eot/PLBBJ59sDaE4aKVKl8WynTQ7T9UQFn73h84mm+LXayj04R09YVNNO
	3o37B2gBHOMTHSf3hvLjQFHusHJqpLGu2e/4dEoT2ogIAnRWCY9iomGQBqMItjxrl9n9CMJknLNrB
	2kXSETqUByOFNjcLyxO1hb7bFq/dcDG/xTpauvqG/OVKHBbUV44nC9t12xF+S2JiW8Qh7kMcMyM+m
	8Osr9uQAQ1ubMOIHSp29XfzY5IDyHh6lYy7rxkq1rmzd3/J4foVzz9jIgMepJBdahgRGRG+SuvWhT
	9w/CuIlMWscv1g2ppA==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1u4U9k-00BSPG-2i;
	Tue, 15 Apr 2025 00:28:04 +0000
From: linux@treblig.org
To: njavali@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 0/8] scsi: qla2xxx deadcoding
Date: Tue, 15 Apr 2025 01:27:55 +0100
Message-ID: <20250415002803.135909-1-linux@treblig.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

Hi,
  This is a batch of deadcoding on the qla2xxx driver.
Note the last patch removes two unused module
parameters, so I guess if anyone has that in some configs
somewhere that might surprise them.

Other than that, it's all simple function deletion.

Build tested only.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>


Dr. David Alan Gilbert (8):
  scsi: qla2xxx: Remove unused qlt_free_qfull_cmds
  scsi: qla2xxx: Remove unused qlt_fc_port_deleted
  scsi: qla2xxx: Remove unused qlt_83xx_iospace_config
  scsi: qla2xxx: Remove unused qla82xx_pci_region_offset
  scsi: qla2xxx: Remove unused qla82xx_wait_for_state_change
  scsi: qla2xxx: Remove unused ql_log_qp
  scsi: qla2xxx: Remove unused qla2x00_gpsc
  scsi: qla2xxx: Remove unused module parameters

 drivers/scsi/qla2xxx/qla_dbg.c    |  53 ------------
 drivers/scsi/qla2xxx/qla_dbg.h    |   3 -
 drivers/scsi/qla2xxx/qla_gbl.h    |   5 --
 drivers/scsi/qla2xxx/qla_gs.c     |  90 ---------------------
 drivers/scsi/qla2xxx/qla_nx.c     |  45 -----------
 drivers/scsi/qla2xxx/qla_os.c     |  12 ---
 drivers/scsi/qla2xxx/qla_target.c | 129 ------------------------------
 drivers/scsi/qla2xxx/qla_target.h |   3 -
 8 files changed, 340 deletions(-)

-- 
2.49.0

