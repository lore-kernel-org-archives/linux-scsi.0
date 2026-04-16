Received: from CWXP265CU010.outbound.protection.outlook.com (mail-ukwestazon11022129.outbound.protection.outlook.com [52.101.101.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7023E2747;
	Thu, 16 Apr 2026 19:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.101.129
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776367823; cv=fail; b=u71j73S98tzcww6Ap5QztEFRXyHOdwMQ2FgTKNTzXfXa3KVZAz7lLFNyIpHNy81vreDs9HooUUS52iNHd7WVvXaym/CiK25y3Oxsuey//HA7eT/5GXrnKfH+xfQxKFYeYvEWfK22dIT+bdeEtkk1daM3Fui9DsFlQv7S5bX/qBs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776367823; c=relaxed/simple;
	bh=pzE2Z6L1MBFtpRLE9VZ6LqAAUb3W7CKMErsGBy91VFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iMv2EYnpJK9eetBIPyjjROKyBdsJBCuBxVrvNFShjLzxpedOp2ZfCgJ09vMuY/J75Tf4gctRMB5ksiZ7uTmFpFe8leEQIg2evK57DdlqLxUulbDH/Bzgqskla351iyEf/oS7y5GqkYVSZ4+L0ITRMHehPy0TzItyyigLHW9Bx+M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.101.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lLaVFgDuBOIB1yA3wIBWk5f6rD/XotBwantqiKaDqNeVvXBmSveatuEe4gRg8wxW3Y/2oBSp5wLyPkNVVg02ndzx17RF2mST4P56DXCQmsIHf0XeZOQoWQz9xhEfI/1dzEZQs3E2jVcqEiay6CVWtUgCaTxE9LgbLYAtzMyhOFz61Me813jngXoSmehUNn3HHcGss6hq2aj4BqRkzPWPPoofymjdlREQ/tderT8V5ErTlXCFWplkDCqR6LyvpmTq0bW1H6XLVWKqJ3TgNmmyvBD5fRCMVHxmpSm5Gi7CIh/vNRD2YxIce0c9STlu9oV/lY6LZ1ubaxWuaDZLcz5bhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XS7RGzNyhIt/MCiSAVaJ0IefX4DimVsxTFLEWyGx0vM=;
 b=VqelagCOPQpFNviIWMBCliv5vQ+AahrZwWhH/yDNUdKJrcNNqspnNLp4dEjAEX+fJgdXEjQ3L/GuBpb4qEAe2bo4Ijw0L34jWU9dxxMdbae8OUVSRVN2rd2aIo3dnEzMJOxyVXXFTaXEOLdHvCwTgD3/VbG2TVEadi1C1ujucX/F2eCiwYCOBoyk7Abk2YUqjw73zskyJLN7MSAxjHAGYPzwCnP3pj2nAHsHq97ZScciQ2ytrEqXtHrXi/8GjVxbolP84GOzYgcRVK3ixNJpNgbdCrxfdjditoytCUaHNBAs7Awg8JL7NxmvCx3miRIyfBnj5HwqJS3u940p1F/Obg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWXP123MB4039.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:c5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Thu, 16 Apr
 2026 19:30:18 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.046; Thu, 16 Apr 2026
 19:30:18 +0000
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
Subject: [PATCH v11 08/13] virtio: blk/scsi: use block layer helpers to constrain queue affinity
Date: Thu, 16 Apr 2026 15:29:37 -0400
Message-ID: <20260416192942.1243421-9-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260416192942.1243421-1-atomlin@atomlin.com>
References: <20260416192942.1243421-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0290.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::25) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWXP123MB4039:EE_
X-MS-Office365-Filtering-Correlation-Id: 2441cf57-ff69-4970-9cd7-08de9bee9784
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	gBH6/ke8/ea2q6l1Sn9IbmvhYIV+kjv2cdBKqPVBeocsSmGs0dGkhq1ZPzcX1jnRNFuohBYNgJr5U2AsWNzseFHBNxnu+EHaXQsZN1o5E8yZ5vtc/tVNcuPS3Xe/vAxYH1ERRsMpNYkOg0eg1jWwUmjQ60/0JLdtbOnLnOlRScXcmz5jH8C3QHw2C+9TXkQ7cGxI/OpVIcm7iZdle2EoOLJr/VeSEXnCPwTD1DulCZF/tQwD/0JdOGfAGcFno8p8bhIIO0Z9HQfWPXfMwWtK88WIZZichd6ZccXb1fQDa7fzxJfIm4MwqS6dZuv/VQs7MZQw7E+RKe67i0bwomPL69h4uzDxLeF8f5vjXhgoAntHPJQbxeRXrNgZ6enwH5od+LA5MRpDqM8+vw6jw+jdLQlzsXf0DY4DBiSBP2w59AKay8oj/GMNGAjwoZACXPJLLXQav7s3NRJmBAVgQpjj7zKNrvrbXOsZeZDhGFC5+YcuF/T1TN7CIaDhsFcyW5uT4l/dNZKGUQp8hnrxO8nziiUUlDDe9InkGI8hs/CKKW5Du23ckIUJg6cg+jToaQkVKe2Z5o5FrPp2Orx6Ur1/5k8wRBXcGc1opxyUVzwAARBeOBhLKUmDteKoiHi5o73lRPjrsivrOhIYXaDuL7HSIB0mpaFJB+FQmQL6zylAlMPnxdQcqN98oGrX+RvwHPkG9esoHcHeDtl6QmzIaC80/TnRqdB/OFbMduuSayAzDq8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JqIV4I8T3nE6EIyFeTLBf35AYaeit/G++Q5+/w7REeUgTE4Xs/52hGQYLkSg?=
 =?us-ascii?Q?KXjRSB55RLFBKnfmbh8+e7McuL8V+gAbowY4AyZkhOeobN9Hs5Rsd+me0kPs?=
 =?us-ascii?Q?hrr4/NeitNV0UEe5y9dP3fPVkl8opEZ+jJNahD0Q4PM0rXR+/PiIt/Flu7YT?=
 =?us-ascii?Q?u9hfVSyaQ5MIIt6eHYjFI+NOdSPpM9vnG572VPezR2Kigkp06YSSN79dVNxu?=
 =?us-ascii?Q?ySynLBBvAOjc6N6pUmafjW6PcoalV734ILf9mz8m34NDyRzhUFbyt/02pr/d?=
 =?us-ascii?Q?bjw0Jh15n8QUd40S6tGaPKxM8phRwlGsIHe9p52KQhcuTi1lAaQSbmrqtT9n?=
 =?us-ascii?Q?hpTd8nWBu+mPYDbqJKj0mu6SCloaItLsfBiuKu6wv6kQkskA9kgs9y/hidfy?=
 =?us-ascii?Q?L3YwoQlNYtfThDMjVz2FzgoOw84iUu9wIQDnkr0OMpHFU1+rmnHOJbsmod2w?=
 =?us-ascii?Q?UzD5H6EAQZq2BxmVl7yiUihNtvYn+S7J0mTWkivK5fzRoszXPW1hGVqeaV7S?=
 =?us-ascii?Q?cFZDAP383ewCS+mYTY1k8T47fr0Z+XsZJddVG29hXUL0AyfVk74Kwag7kb0E?=
 =?us-ascii?Q?4VncjyLFTKp6AB6mz5eRMpMjBrfCYNAzXCjY7WTSMNFarinaH1fwIYK3lQH8?=
 =?us-ascii?Q?yGMw2RZuzVJXnozFWHYcAElJqT0nAPbwfkCvIrbjGsUDj3/PSV2fpUC04emp?=
 =?us-ascii?Q?AF2ByxWBBeHsRUYn9ZyURIP7LoYtCAK/q5+m4rXBLI9Z987/eZMTW2SUq3N8?=
 =?us-ascii?Q?qN9g8m21s/fuTxKxBOqN4XPTuiYGfQGTQfKwPE66N7NxEH7V0pLDcFdFxeQ6?=
 =?us-ascii?Q?W8puFn7Rlgiko46tnuSlzLO6sUlLoZq2mO+rHrA7LuGyzFazQhhFxn20NzAO?=
 =?us-ascii?Q?8SGwdMWo03igS0DtnNVcIe6Fr4uPlbtdpYpsdvBwEQyo/FRao9vZ5CDLw8np?=
 =?us-ascii?Q?3aczkeygzkv8SkGJKTzvvdjqGHK8Q8A2RFXY4ncaiO6EM7t6B8Iuiq2er0nP?=
 =?us-ascii?Q?0G0AhDDWHIsa1+3M0POMTmOkVOwnDbgnXsgjN1J2YAxCjA0g9KdBpjof7I7A?=
 =?us-ascii?Q?DaTAJry3KuxBakNdCqpVOR8ZQrbaAl5dN+Fne3Fmuy6cOIX7P0HSGEUkN54j?=
 =?us-ascii?Q?krWDZ1pU5DjAezXZchfQJkYSZcj63qy4O0r6VnrbW7dVmCI1n/rQAq/WIPa6?=
 =?us-ascii?Q?ymIJLW2++ITaBYWQTRWyeEA4+kLgdYH+bqG1cVXLqbQFpjfQy4l5hAGEcp12?=
 =?us-ascii?Q?eNsfrnjmtla9x8XQ+mFNeIqKjnkcVZSvqGhE6PoGM2Iv+CiDJPtzacpkz8Ut?=
 =?us-ascii?Q?QPcx1+cRj9sV7ZHH/gxq9c54gIMX1Liam/loSqK7ybTiqu2CRSutPj/pKv+5?=
 =?us-ascii?Q?umBHXZjGR1b6fU3b+t2QQNeoDCO/nxXh4Aolhqklxv5Z2faX5ikpplv1Rf3G?=
 =?us-ascii?Q?9t6kLhn1eTD11f2ZIlKaZL7oO67ZyIvZLv+CYm7mgJHs+nzue4EHGKfEkqPd?=
 =?us-ascii?Q?BDCdiUV/7Dd+UZz4xyHB9yBHRZjGoBaFFoLn+pVukiCF8emWmz2gcM3HAPDU?=
 =?us-ascii?Q?j7L2feB7+Y3R3VGbweSgNhzZppgrCwfK8TAd7j0YZ0CcIVFw9UYsuwTCz756?=
 =?us-ascii?Q?Eoi4SEPcWFThVUTSGz+/6tdREZkOrRdj3b+jV8dLReclGjbH1oDMfcOMTM/P?=
 =?us-ascii?Q?Ya3P78p6t55xyaX/MfxUhRCViASjqVulYecXFAnXbtlXMHaaESue6nzgl9Nh?=
 =?us-ascii?Q?fbN/Ybw2mw=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2441cf57-ff69-4970-9cd7-08de9bee9784
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2026 19:30:18.3121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dQd2Ks8OBxkMxOJLihdvs6Kb9mRNdScHd7bfUXYhctRO+ePc7uRh82JBDbPIdWaooSKoIksrVcsDmoWYL2fRLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP123MB4039

From: Daniel Wagner <wagi@kernel.org>

Ensure that IRQ affinity setup also respects the queue-to-CPU mapping
constraints provided by the block layer. This allows the virtio drivers
to avoid assigning interrupts to CPUs that the block layer has excluded
(e.g., isolated CPUs).

Signed-off-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 drivers/block/virtio_blk.c | 4 +++-
 drivers/scsi/virtio_scsi.c | 5 ++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index b1c9a27fe00f..9d737510454b 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -964,7 +964,9 @@ static int init_vq(struct virtio_blk *vblk)
 	unsigned short num_vqs;
 	unsigned short num_poll_vqs;
 	struct virtio_device *vdev = vblk->vdev;
-	struct irq_affinity desc = { 0, };
+	struct irq_affinity desc = {
+		.mask = blk_mq_possible_queue_affinity(),
+	};
 
 	err = virtio_cread_feature(vdev, VIRTIO_BLK_F_MQ,
 				   struct virtio_blk_config, num_queues,
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 0ed8558dad72..520a7da5386e 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -849,7 +849,10 @@ static int virtscsi_init(struct virtio_device *vdev,
 	u32 num_vqs, num_poll_vqs, num_req_vqs;
 	struct virtqueue_info *vqs_info;
 	struct virtqueue **vqs;
-	struct irq_affinity desc = { .pre_vectors = 2 };
+	struct irq_affinity desc = {
+		.pre_vectors = 2,
+		.mask = blk_mq_possible_queue_affinity(),
+	};
 
 	num_req_vqs = vscsi->num_queues;
 	num_vqs = num_req_vqs + VIRTIO_SCSI_VQ_BASE;
-- 
2.51.0

