Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B98B175548
	for <linux-scsi@vger.kernel.org>; Thu, 26 Sep 2024 01:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727315025; cv=none; b=ssUbOboujg7rvyeHYDwaxAjStFnh2gJeUCsrfXDuJXTfnm2oFdmbw23ILr0NKBO/ASaLvLsK+gDUXHPJ+87JjsD9aSmRQOH0lf7q1QsZi3bwRho0KVmFAS2mBjmKjUXfhFx35h1pfzQ9QE1N2HtvnJRLRkX4oJk4pcDjdKkVfgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727315025; c=relaxed/simple;
	bh=IHxNe1/41c7IgS/541Yw90TfVcryoq3NCOxf8MO0htU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ep5q1PleajpV1NuNn/MtrqqO6k4q9eZ5syHOEbV62Dl7mAjNaS0ZcuH7XEM7ymjuoCcf0Fjsw/WkNjnmmAOX6cUcBOFPMasvpT1v2BUB9jMcTDm+YHT6PZWv/9senbIKnH7NIcRv8b2ucZrzJghT2VChCcoHLL4+gxewFzErtRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4XDbw02q0jzFqsK;
	Thu, 26 Sep 2024 09:43:12 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 9709F18005F;
	Thu, 26 Sep 2024 09:43:34 +0800 (CST)
Received: from localhost.huawei.com (10.50.165.33) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 26 Sep 2024 09:43:34 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
	<liyihang9@huawei.com>
Subject: [PATCH 10/13] scsi: hisi_sas: Add time interval between two H2D FIS following soft reset spec
Date: Thu, 26 Sep 2024 09:43:29 +0800
Message-ID: <20240926014332.3905399-11-liyihang9@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20240926014332.3905399-1-liyihang9@huawei.com>
References: <20240926014332.3905399-1-liyihang9@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemf100013.china.huawei.com (7.185.36.179)

From: Xingui Yang <yangxingui@huawei.com>

Spec says at least 5us between two H2D FIS when do soft reset, but be
generous and sleep for about 1ms.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Reviewed-by: Yihang Li <liyihang9@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 452baf9d5a26..246712cace28 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1321,6 +1321,7 @@ static int hisi_sas_softreset_ata_disk(struct domain_device *device)
 	}
 
 	if (rc == TMF_RESP_FUNC_COMPLETE) {
+		usleep_range(900, 1000);
 		ata_for_each_link(link, ap, EDGE) {
 			int pmp = sata_srst_pmp(link);
 
-- 
2.33.0

