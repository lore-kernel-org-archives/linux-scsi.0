Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C805F57C9F;
	Tue, 17 Mar 2026 06:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773729113; cv=none; b=kkQe3FMNlaNLiK/dW0TqPClMFW+79trKt9Z3UIjHzBDPxklmqzH+8M1uT5MbpHkxmpuvyar7+1yeFcCH2VPLX1ma774/NOt9MZGYU85NtPswVVmp6HHd6tkndJnz38plxBS2AmGrtCYwv+uRZ6dKNhDoyy2MidDqgS2DzV4L6IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773729113; c=relaxed/simple;
	bh=xFpxtfQWsOl0eADu+u7R/CP5uFKMnuScRUkOaIVjXf4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pse245SXhCWAftkLsUy9ef3vKi3Ox8OxbxYHMO544uTwf4keU00u0IdSfeY8PGhZlCwpiBtvcChcLBqGdBPSZOfyx9g1IqBXkvZTiA0Hn+inmDmWlE8k8OdtPvz7BV5YVn5gyT2PMv1MVVph6Mvh5SpBveajdOB5TpS9rE4nr2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=N6hkBi5T; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="N6hkBi5T"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=iQyOCq8GwaOJiuW0nvRx/DrISeQSdWsR1+v0iNg4ULk=;
	b=N6hkBi5TQmUIZ8bzNxhDUaNITm0YtC0N88dMOivzWbcHMLTxIudE/UdeXZ464vQ32IbU4ASSk
	Yv8JdXvRAa6yR2aNkVcOPwV1LemoEmRektGThRFTRL1Ril+K10q9pBVZJTKQw2FWCwSai0sAwsd
	S3WCEwRQHshj43dX1ecOilE=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4fZhmg0C4dzcb4k;
	Tue, 17 Mar 2026 14:26:11 +0800 (CST)
Received: from kwepemh200005.china.huawei.com (unknown [7.202.181.112])
	by mail.maildlp.com (Postfix) with ESMTPS id 1381140538;
	Tue, 17 Mar 2026 14:31:48 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemh200005.china.huawei.com (7.202.181.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 17 Mar 2026 14:31:47 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>,
	<ranjan.kumar@broadcom.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liyihang9@huawei.com>, <liuyonglong@huawei.com>, <linuxarm@huawei.com>
Subject: [PATCH v2] scsi: scsi_transport_sas: Fix the maximum channel scanning issue
Date: Tue, 17 Mar 2026 14:31:47 +0800
Message-ID: <20260317063147.2182562-1-liyihang9@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemh200005.china.huawei.com (7.202.181.112)

After the commit 37c4e72b0651 ("scsi: Fix sas_user_scan() to handle
wildcard and multi-channel scans"), if the device supports multiple
channels (0 to shost->max_channel), user_scan() invokes updated
sas_user_scan() to perform the scan behavior for a specific transfer.
However, when the user specifies shost->max_channel, it will return
-EINVAL, which is not expected.

Fix and support specifying the scan shost->max_channel for scanning.

Changes since v1:
- Add the prefix "scsi_transport_sas".

Fixes: 37c4e72b0651 ("scsi: Fix sas_user_scan() to handle wildcard and multi-channel scans")
Signed-off-by: Yihang Li <liyihang9@huawei.com>
---
 drivers/scsi/scsi_transport_sas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 12124f9d5ccd..13412702188e 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1734,7 +1734,7 @@ static int sas_user_scan(struct Scsi_Host *shost, uint channel,
 		break;
 
 	default:
-		if (channel < shost->max_channel) {
+		if (channel <= shost->max_channel) {
 			res = scsi_scan_host_selected(shost, channel, id, lun,
 						      SCSI_SCAN_MANUAL);
 		} else {
-- 
2.33.0

