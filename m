Received: from CWXP265CU010.outbound.protection.outlook.com (mail-ukwestazon11022129.outbound.protection.outlook.com [52.101.101.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2395D3E1D15;
	Thu, 16 Apr 2026 19:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.101.129
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776367820; cv=fail; b=VUx9mVYB1PrLMLPZ4rpmvzuP3fw/auSHluruNS0f8wpjfxUpAaafjwQh7ESgrsOYQpSQZK3SUAEU7RNqtZq88yk2icuBHgvf7iyFNeLsJi7bIEhjcCopPlCDzDA4PLIc53otvXGEJ0zlGlbi6JKUDybZnSOB8xMLr09WPOQtE9w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776367820; c=relaxed/simple;
	bh=oxbsR5R8tYQy3vf2d+Vifp3R6D6zdLlLHhXbPrxNwsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=h70uqtJGeC28krHlDWDL8UvDAcAS3bT72af4sXuZ+v3BpClZpQ184dsCocylCooBgZz/prTfMiTmMi8s/1B+PZkin66M1dDx0OnfaJiTS8Q6NK/kokVN6LBPb8w+BB24C2Ol6ELDMtsbjKRtJ/++L8b3Gl7qXgnoiDCP6axTpxg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.101.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sr07im3o4BUSVaK+CfH8k03Ff99161mVPeEFOmSPoExO5vZJtqbtVTRJAVeHaSSibFRBu0B8bw3NVho+2tByXBC9sUf6XCYF7QBKbRJrcKRWb703U0pw4dvXN7yP/r1Mjl67+LTky863FSg4DQTCH+P+fQ/AP5NxhkAY8z5wxJPK7OGum4iy9NzRSQbokJNe33uJm8l9dBO2XuJ6nUfT1PErMcQGDkDEjzkbE7a0kGyhrmNagkPr8xMv3Vayt+kLYbaaatp2PmQq+MmFbTvxCJlCfVMpe5AXAwgi0BMXSEB2g6RJAjATWQbZUGTa8L0O4lbvG+ie25exAwftOurZdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qqSF314polVFAIPTU2KDWDbVzzJqEQuz17txnEwwgb8=;
 b=FnYQ2CH5K+NU31a4qch0eQuaEhHwAKIeiZ7UuOjwKYbG1zAptOw41NSalJ66FssC9CRLw7VNZSsqCFm+gtr02hdz91Nrz2Grqzd/0YjtokYXo5TQomchGg3u/8afS/MGM9XeLJrHEBnNMsmGHT3bsxXAZLR/GGdWKSf+ERtRSTudGglWQRBI1fjIGLyteAZK7bsmjzxj/1ZrpjcwtMr8BqFgJjhr+HQ31lkliHfoNao2mbMtwTG2jA7aQIf+gn6Lzl1aTnrU5BRQQnutDOmfNWfIDNCmxdmPpiZK4bqhotXaAv6S8OWge0+7f96ry6LUDpK0zxt5XLqWHQMS/HhoAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWXP123MB4039.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:c5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Thu, 16 Apr
 2026 19:30:14 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.046; Thu, 16 Apr 2026
 19:30:14 +0000
From: Aaron Tomlin <atomlin@atomlin.com>
To: axboe@kernel.dk,
	kbusch@kernel.org,
	hch@lst.de,
	sagi@grimberg.me,
	mst@redhat.com
Cc: atomlin@atomlin.com,
	aacraid@microsemi.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	liyihang9@h-partners.com,
	kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	shivasharan.srikanteshwara@broadcom.com,
	chandrakanth.patil@broadcom.com,
	sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	suganath-prabu.subramani@broadcom.com,
	ranjan.kumar@broadcom.com,
	jinpu.wang@cloud.ionos.com,
	tglx@kernel.org,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	akpm@linux-foundation.org,
	maz@kernel.org,
	ruanjinjie@huawei.com,
	bigeasy@linutronix.de,
	yphbchou0911@gmail.com,
	wagi@kernel.org,
	frederic@kernel.org,
	longman@redhat.com,
	chenridong@huawei.com,
	hare@suse.de,
	kch@nvidia.com,
	ming.lei@redhat.com,
	tom.leiming@gmail.com,
	steve@abita.co,
	sean@ashe.io,
	chjohnst@gmail.com,
	neelx@suse.com,
	mproche@gmail.com,
	nick.lange@gmail.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v11 07/13] scsi: Use block layer helpers to constrain queue affinity
Date: Thu, 16 Apr 2026 15:29:36 -0400
Message-ID: <20260416192942.1243421-8-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260416192942.1243421-1-atomlin@atomlin.com>
References: <20260416192942.1243421-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P221CA0036.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:5b5::6) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWXP123MB4039:EE_
X-MS-Office365-Filtering-Correlation-Id: 631203ea-a459-48ad-daac-08de9bee952b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	kZzgDzqmpNoVLcvWRTqOtSJ8+8NbmTmhzwAhtx0Ji6cqPKqTYYKan37CwvQO8jYHzs18zRE2HsfXKjdKCnHK7jyI1lcgBPV1PQmGzQpAl4Lnh2rBUUvqIEv3SuocCBj0/PhAXTpnsJxxmzh5evz83WL8gcV3zKKLc1VpfsogWHwhgu57dugGSqNXkH6/Bi1hMZnMJHOCgkkJLcyM7sAYJMRw6brXkvwqzTlxxgblAXfQtv0MkFcCT8DccVCi2vifzwIIQXbD5K53md2laoro2dQ0ilLDkN2c5t5KpE4dXEhxPZ73toOmvuOCV3yu0btDFdVv2V0N+feeE7Of0jceGmEePCs/pF+kRMU9WsBq5xFse9ae9DwIIW2Tl7J1QFJe3dGjMCeKwukGuM01htVhaSNw2C09N+/qTvHYC7q1uEpsoGmmyWqSei7Wme63oWcCwd/bSH7L9lDzUwVfOa75x2M5IZwwPKghx3+n5CLrG//g5dchU7jDBM+nIBUDY881JOjhcGBi66HwzIx8gCb5HlB6C1qGrCe2rGGZq1GILXEyiyRKpTjPi6nIlNSs/OQPbRpgaLcYcJ7hdY0EKbcrwQ/+lEkgq0f1YxcwxFhzvYYbBg95oSbf7xqoEfqfnjI5NW//G72cuv+KWjT/FZx2YajY/bceHYZikdckIqOLvwQdaM+K9tAbNO3yD2jAWEfI9kPkBmXvYxSKAilRcj9pywKn/5c1zHrQ0sIGKsTwU2Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?d2Ms0R3IDYufVExt/miocAab6CFznf/W/n7JHBg0Sq7au0zyOYe2QLh7GTwo?=
 =?us-ascii?Q?uK4Uqi4XPB5c2ZhbUGlqgk8LrZQppSBxeyOKZ8Nq91aaG7yKB02fhZFbBKdb?=
 =?us-ascii?Q?lVf4xMZhZfrp3qhC1bTziBkwykTYf5O7AxAHJ3wRPqZxTCNnOQXwPLPm1siF?=
 =?us-ascii?Q?5N2+oZuP9Tqgh1cDF1+emykAyO8WYtQ8aF8i44tGzscfN8LeeUkA70ugPqYH?=
 =?us-ascii?Q?nSAnOU6Ghgp38JSyi2MXlhId4B21x+dF8+UFSV9AX8B8UCM/g3zen5gqk+Ut?=
 =?us-ascii?Q?APVG3BUrsaMWSPZjeuLEm434pvrbc4bLZTQx4jsRp8UcIzLp5aIcUZKSjLDp?=
 =?us-ascii?Q?wKydzmHc3zmjXngo5nzqiNjWYU7wK7m2L43vMzG6QLGsqDmY3RzQyCV7WIqy?=
 =?us-ascii?Q?CvEVrHwNMnkNxemeeqaroNwcAehbr9o0REtiWCe6i0cyQwh0o6ykLEpB5929?=
 =?us-ascii?Q?Vj04PHsKwuUEXcfIjuPdSWZt+N2mw4BxlbttS24MWwZA+ZVCaMF1bZiO47kU?=
 =?us-ascii?Q?8QiXlmKcZSERQe6MMleofWb79RiZwYWcAg4B2+Nn8nVKWdaNIkA9j/nJcYT7?=
 =?us-ascii?Q?808uwiYBNy5MvH2z3YtsHAvVviGd05wg74qJG0Hft8ET4TDnLQJT6bwoN/Ww?=
 =?us-ascii?Q?etZHITmYJ7tKrXxT42iXDxepvotGxJ8NJVVpum8fNtBhXf3ycZD8czVvVSOk?=
 =?us-ascii?Q?pPcVuS4NMqKemqzlBgKTCOcBmOXo/XpqZ9lFnvOrlygh9UUN/Mlj4PuLvJOn?=
 =?us-ascii?Q?G7xMuC7oMwNA0gyDVwRf85+Vj99KWbSuaVEE75qJl+Meg9xUfMkSxhrdcrlE?=
 =?us-ascii?Q?BdRl1vv7Oukv5odjAHDilf4uPwjy9VzLlIIpRViah+aid8wOLeWHCPzjfXCw?=
 =?us-ascii?Q?FxbkRMAPwjku/4T7TkfM9ZlVnLrPma2ufc1TPxfSczPWZ6/a/Qi4vP8Rs8XT?=
 =?us-ascii?Q?G3oYIuKIYSFis+BI9qdRm2uQAz/GwtdfcCqWfS1LB9htggaJmxUJmAuxx42w?=
 =?us-ascii?Q?2uhexwjllzUfp3tZcRitfuX0u2l+q40gF3Ez+qqn3uRybdOl/Wytq/gf0iF2?=
 =?us-ascii?Q?nsoXGhfK8lPxNzNyRZzR6h/0fdCY1hDS3+20GsuCziIWV4pbJgAEzMoNQgWx?=
 =?us-ascii?Q?XpZLQjxFg/ugf1FpWXOBKgNL99HAfEpggdeyr0ntKNV2hbNQDhejK8KxAQvV?=
 =?us-ascii?Q?Kst7T5CcBqVuc/w21+KTYU+Nrw4dMzPl9Ute0BC2gr2qIzfXIw6CqhFmPyPx?=
 =?us-ascii?Q?PegROzyPYPzjsaEuISuQ0Bo3dYiXqKroZc9foV81t5Vc3h0LiWObRqFz2HUW?=
 =?us-ascii?Q?abss73qr/yCj8WFum/8nqhcQiQmHz81MdXSQwchV3UFAK380lJS8dRo0OlP4?=
 =?us-ascii?Q?0tBoj2mHdrc44H9BeteGxzNW+APtKBbvPGowXhiCLKVe1ov7kmcGVLtxfPgZ?=
 =?us-ascii?Q?9c8eJOk5lrgKsFi/Pk5pM0UWf/20RGVeMt4A2gcAhNchu81KPSe8Q5sTPk2X?=
 =?us-ascii?Q?x9+xJsSUqcFWpfc3JgCWAhjO05utxhJv1cCORRVvyXq9J8dBipp7RsKCt/9O?=
 =?us-ascii?Q?Cpv5Hsed98mkgpk4TKbq7GraB+wbAd2TiRpDrkPj8y6CydcffwJVhUv0M12l?=
 =?us-ascii?Q?Jy9su4TLGRNvunkF7r66jQ1XQMQ+FWoza2boNKzblOxLcucotOHohCK01ab5?=
 =?us-ascii?Q?F+nc/xbrBTZXUlDu+6m/EWJIY0OPrBAa5PTlasv0BK1MJ7wWzeUye4Z8kEhp?=
 =?us-ascii?Q?dKUSeewkRg=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 631203ea-a459-48ad-daac-08de9bee952b
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2026 19:30:14.2021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ma5v6yX4k6vAmdLggyU/T0ILSj9D350NW1vdQajv/wjv6+U3e4Gjb3McqpeffPgB5Vef4ggM146pZX2hZXPk/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP123MB4039

From: Daniel Wagner <wagi@kernel.org>

Ensure that IRQ affinity setup also respects the queue-to-CPU mapping
constraints provided by the block layer. This allows the SCSI drivers
to avoid assigning interrupts to CPUs that the block layer has excluded
(e.g., isolated CPUs).

Only convert drivers which are already using the
pci_alloc_irq_vectors_affinity with the PCI_IRQ_AFFINITY flag set.
Because these drivers are enabled to let the IRQ core code to
set the affinity. Also don't update qla2xxx because the nvme-fabrics
code is not ready yet.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c    | 1 +
 drivers/scsi/megaraid/megaraid_sas_base.c | 5 ++++-
 drivers/scsi/mpi3mr/mpi3mr_fw.c           | 6 +++++-
 drivers/scsi/mpt3sas/mpt3sas_base.c       | 5 ++++-
 drivers/scsi/pm8001/pm8001_init.c         | 1 +
 5 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index f69efc6494b8..d1f689224e7b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2605,6 +2605,7 @@ static int interrupt_preinit_v3_hw(struct hisi_hba *hisi_hba)
 	struct pci_dev *pdev = hisi_hba->pci_dev;
 	struct irq_affinity desc = {
 		.pre_vectors = BASE_VECTORS_V3_HW,
+		.mask = blk_mq_online_queue_affinity(),
 	};
 
 	min_msi = MIN_AFFINE_VECTORS_V3_HW;
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index ac71ea4898b2..7e2a3c187ee0 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5925,7 +5925,10 @@ static int
 __megasas_alloc_irq_vectors(struct megasas_instance *instance)
 {
 	int i, irq_flags;
-	struct irq_affinity desc = { .pre_vectors = instance->low_latency_index_start };
+	struct irq_affinity desc = {
+		.pre_vectors = instance->low_latency_index_start,
+		.mask = blk_mq_online_queue_affinity(),
+	};
 	struct irq_affinity *descp = &desc;
 
 	irq_flags = PCI_IRQ_MSIX;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index c744210cc901..f9b8b3639c64 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -830,7 +830,11 @@ static int mpi3mr_setup_isr(struct mpi3mr_ioc *mrioc, u8 setup_one)
 	int max_vectors, min_vec;
 	int retval;
 	int i;
-	struct irq_affinity desc = { .pre_vectors =  1, .post_vectors = 1 };
+	struct irq_affinity desc = {
+		.pre_vectors =  1,
+		.post_vectors = 1,
+		.mask = blk_mq_online_queue_affinity(),
+	};
 
 	if (mrioc->is_intr_info_set)
 		return 0;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 79052f2accbd..91e1622b5b77 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3370,7 +3370,10 @@ static int
 _base_alloc_irq_vectors(struct MPT3SAS_ADAPTER *ioc)
 {
 	int i, irq_flags = PCI_IRQ_MSIX;
-	struct irq_affinity desc = { .pre_vectors = ioc->high_iops_queues };
+	struct irq_affinity desc = {
+		.pre_vectors = ioc->high_iops_queues,
+		.mask = blk_mq_online_queue_affinity(),
+	};
 	struct irq_affinity *descp = &desc;
 	/*
 	 * Don't allocate msix vectors for poll_queues.
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index e93ea76b565e..6360fa95bcf4 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -978,6 +978,7 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
 		 */
 		struct irq_affinity desc = {
 			.pre_vectors = 1,
+			.mask = blk_mq_online_queue_affinity(),
 		};
 		rc = pci_alloc_irq_vectors_affinity(
 				pm8001_ha->pdev, 2, PM8001_MAX_MSIX_VEC,
-- 
2.51.0

