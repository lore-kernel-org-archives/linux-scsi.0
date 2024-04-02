Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D55175BD
	for <linux-scsi@vger.kernel.org>; Tue,  2 Apr 2024 03:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712030390; cv=none; b=qCgWszXY6GX9NI5nspkXY1EvtQ5rMm0FbS0zQ7OgcCanp7CWgcEoMk83WgTHOHg59yoUIWLoA2pKA2wjBv65cuyOzmd2DB1qUgUWVXNxdssSyw3YF2R6+HyWk9E30LHgdUdZTSdTnCDfK4Tb6aibXgAuEWcHlVb+FAQAsXgqs4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712030390; c=relaxed/simple;
	bh=8kY2l7hMavLNlqteJsoZFGk2YRQcFT0dJeE7DQPi3JE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=r38iqqn69f515pIj1rcpS5QNjUnVFsXCoLG6z8AX0HwnnfXPdv/X9WrcNisWEEgaxV5gbpP3eqh4XS2h88SotixCP/Bon+8ahUfwF3AxNNtFOk8msGHlmLDMLjMC9XsZp19pHbhUIFuacfOxB10Wn/5yFjJ6RWcASI9MghDbgmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4V7vJ361Ybzbf3D;
	Tue,  2 Apr 2024 11:58:43 +0800 (CST)
Received: from kwepemd200015.china.huawei.com (unknown [7.221.188.21])
	by mail.maildlp.com (Postfix) with ESMTPS id 3F28718007D;
	Tue,  2 Apr 2024 11:59:38 +0800 (CST)
Received: from huawei.com (10.67.165.2) by kwepemd200015.china.huawei.com
 (7.221.188.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.28; Tue, 2 Apr
 2024 11:59:37 +0800
From: chenxiang <chenxiang66@hisilicon.com>
To: <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC: <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH v2 0/2] Some small fixes for hisi_sas
Date: Tue, 2 Apr 2024 11:55:11 +0800
Message-ID: <20240402035513.2024241-1-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.30.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemd200015.china.huawei.com (7.221.188.21)

From: Xiang Chen <chenxiang66@hisilicon.com>

This series contain two small fixes including:
- Handle the NCQ error returned by D2H frame;
- Correct the deadline value for ata_wait_after_reset() in
function hisi_sas_debug_I_T_nexus_reset();

Chang Log v1 -> v2:
- Add one blank line after declaration;
- Keep the line which fits in 80 chars in one line;
- Directly use jiffies + HISI_SAS_WAIT_PHYUP_TIMEOUT in stead
of using ata_deadline();

Xiang Chen (2):
  scsi: hisi_sas: Handle the NCQ error returned by D2H frame
  scsi: hisi_sas: Modify the deadline for ata_wait_after_reset()

 drivers/scsi/hisi_sas/hisi_sas_main.c  |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 10 +++++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

-- 
2.30.0

