Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9727D3E3
	for <linux-scsi@vger.kernel.org>; Thu, 28 Mar 2024 11:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711624377; cv=none; b=Kz6Ft7fQcTgzXHjfrtFJnuPaFupadbSNSETKMYcbavEpTQCgMZ9KCbo+F/c4n9K1UwcoD9DrmCQrY7fOFs+46xlXzRZ+DfwKLv8Op7RgiWJU1MYzejLyC4tPmRwzoYKPOYvk4/ONpKNLW2xsFMBqFgJCPDhRSLo5lwWaxffQmjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711624377; c=relaxed/simple;
	bh=2x2qIbw6zQj4MvkULqgv0P6vJpBaLeyyrUxWql1Ngzg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aer3qJHGe52ekqxc1Ch2HrxzIJ6lx1VPy3HNuyARAOuMWYEg195YAp5Lv9WXSDVUHJ+NW1uAu6JVmBiQO6I4voFHqfFK8Aa/31kpiEjZZ98O+HyJdj/wQox/IkJOzuuLxUzDoTj3Donj+nH4VhIpMgiVxn4763sNMoa+Kf+x1WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=QPmQVKEz; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="QPmQVKEz"
X-UUID: 1c45a284ecf411ee935d6952f98a51a9-20240328
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=1+ipa3gYGdsi7GnjlrbioIQ8A1A8ugliu8amDLRxkgc=;
	b=QPmQVKEzJAeIQTAvKE2g3eSBPfNz7cbgQETwp8afk1QvqfwxIgMaXZFEaf8u9RWTH/o8/JbqI+dvel7vCtCqhi/NiKWNij0415BxYCyFs4cDct04yqCJFU1zPGgLN3CdFcofmH8QC051G9qNwlABCWX421Xj5koK7JywPKMIDKg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:595018d2-e1a8-488a-8255-fbaa4568aee6,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:6f543d0,CLOUDID:038d6f00-c26b-4159-a099-3b9d0558e447,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 1c45a284ecf411ee935d6952f98a51a9-20240328
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 769327657; Thu, 28 Mar 2024 19:12:48 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 28 Mar 2024 19:12:46 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Thu, 28 Mar 2024 19:12:46 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@wdc.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<powen.kao@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <chu.stanley@gmail.com>
Subject: [PATCH v1] ufs: core: fix mcq mode dev commad timeout
Date: Thu, 28 Mar 2024 19:12:44 +0800
Message-ID: <20240328111244.3599-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--3.713000-8.000000
X-TMASE-MatchedRID: n/G9Jfep/EYMQLXc2MGSbEKcYi5Qw/RVLoYOuiLW+uW7qpOHKudqcyvd
	+2hXReVzUKHb2fVYuJQZiQOLu5PhvLBAQLqGlKiv4pdq9sdj8LWz4D778GcgEUklF5L0lQHcKLW
	rCrDVHUni8zVgXoAltsYlDcGKIsCCC24oEZ6SpSk6XEE7Yhw4FgbXoidYSy4P3unOsFItkBB+mh
	WkR14Qms0MN25RQ6qSqHSgf2x6gMl1CdFT0X8D/24OrJLqXmZ9R4HKDZ8NHjGuxQRL3Ccs18GQY
	FMiVRG5ehcPPz6UzEWlb5ogMngNpHOTEn5IiRSOady5RJQR05c=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.713000-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: DB594D91E0DAB569C3A7D9A4665BB7B09F13F27FFC68A0935D26ED1A494258802000:8
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

When dev command timeout in mcq mode, clear success should return
retry, because return 0, caller consider success and have error log.
"Invalid offset 0x0 in descriptor IDN 0x9, length 0x0"

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e30fd125988d..5f8749ea347c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3217,7 +3217,9 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 
 		/* MCQ mode */
 		if (is_mcq_enabled(hba)) {
-			err = ufshcd_clear_cmd(hba, lrbp->task_tag);
+			/* successfully cleared the command, retry if needed */
+			if (ufshcd_clear_cmd(hba, lrbp->task_tag) == 0)
+				err = -EAGAIN;
 			hba->dev_cmd.complete = NULL;
 			return err;
 		}
-- 
2.18.0

