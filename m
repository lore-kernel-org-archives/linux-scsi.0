Received: from CWXP265CU008.outbound.protection.outlook.com (mail-ukwestazon11020117.outbound.protection.outlook.com [52.101.195.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206C63976A1;
	Thu, 16 Apr 2026 19:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.195.117
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776367834; cv=fail; b=gaGqVEgUuvouhir8C1WkQq8CFJ1nH/wxcDgI0q6BI3xvO2Sf/RTH///bZcjRCUt3ojseI9Trnow52RADqWpQ2TfqA6BWVqEJZPkgYG+Rm1gBdGB+BkozrShvIITct3UkT471qHzaOOul/EihkrV6sZhS5OU+cu52nUg8FmmpHkM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776367834; c=relaxed/simple;
	bh=BbcA0NMwKLLRwpfrWSfbTBNx4JJZLTZIW2PVdByU5uI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OX5e0FZQdypn+n3YHdaaHQI4tw7U4lNQXMM57SCRM8/XWZGGqpHyvgSUyL5xv7uFed4t/IxHpBQgJp7gqHCC305Dh+jko+9tR6pLL+h/8NTdxSFmJQz3pWWzC4bcSCkxNkjA5ar39Ijpng4EOhnOMVbDYsOpj2KRP+jgIWJXOds=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.195.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lkWvkR7uBkbuSwvUht8cedsLIhPjc/XIbDnxFI4/fWQYmxVrDgaQjBPQ/sgUd96h0d9MrN1PexfLlVsSaEZQWhAt7jaO3JKeLBk5PDq3UxkPQCJe9ibXthooxf4/aZEBgoGa/3STzMhYtpLhRKcEVM0jwiJhqyDE5qY3A2pSBE+6p3ZyKWcDJtsgqiy6Ddu0EmB8HN1dQyMUCvQx7amKZORBODafkwOUQrJH2g4MVSH841ucKKYoevfDBGuD3ge9u8WZFalMMOHGfgW91N23/yCfQcTw1Xgy2ZOi+VqwAbV7gIVfgGBaXDzRo4YXweXnUt8Uy2qfyOnNQaJViJtcmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VEbXocv90EEQQkMDABahd6vYZwcvOoK0laAAb5WiV4I=;
 b=wDm6cnv3L189AqpmhnHZblmEOnG32g7ygDqWfKjeRPJnvHzUQb0gcOzvIvRigB7biMbvjqOCvTId19mL7JQJT1g78hYGQF1cYcmd6meJyaXcSmdeg0preBiClGyavqmcrkefrHD/00vN78F32nl97Sp/f6h29dEJdyLop+ZsgR+615F6K9Giq/UuvAhlI8y1zTFG6+x7j4nKXnJNlReiF2kj/EImyIdg4EAkjfYbe3vPsJlUozXwZIEoEhuElL5o3TrT1YDkprP5dF3zGTPCNpG65Yu8ZZbC4zJjK0/+c3br+b7NE5a3DPl4DXuIsNR5YPF4R81n0zkOQUvtUi7a4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWXP123MB4039.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:c5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Thu, 16 Apr
 2026 19:30:26 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.046; Thu, 16 Apr 2026
 19:30:26 +0000
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
Subject: [PATCH v11 10/13] blk-mq: use hk cpus only when isolcpus=io_queue is enabled
Date: Thu, 16 Apr 2026 15:29:39 -0400
Message-ID: <20260416192942.1243421-11-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260416192942.1243421-1-atomlin@atomlin.com>
References: <20260416192942.1243421-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0186.namprd13.prod.outlook.com
 (2603:10b6:208:2be::11) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWXP123MB4039:EE_
X-MS-Office365-Filtering-Correlation-Id: c7c9f814-9b80-49bc-c44a-08de9bee9c15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	01xA/uLM6HqHYPLcQtj/hUTurQXKl3T3ltj7OoB9kXh04IxeQarZvMbZjrLWwPuADRVUnLxK5j1RzivxjJsJR+n789wyQlQOOIBX6HcupYUc3ZJ/Fq0fnWvk7wkoHLCuhl92Gwu1/BJkAVv/Nk9lWucR/uLDliumtdq47v9bk/eQzGm72V4HgzU5JW/YHfmbBRm5sNppBGgJks+FmdImYgyN+qu/+TRC8bE6sGiBaCOOfk4V18fYrbpo9XPX0CIulUsTRxneAWa4Y2uO5FPp7z3+gtp84NG0jxhgovQeliYr0uqoL14f4Bk4jQfD5uejRi4yK9iO1LiYesZw6AMOTwi4yILAresF0VkNHLwIwGhNleO16YK07EwZ36E9A7d+jlD8obj/70yWJW8W9mrFko2UA5V98UyXhILs9oecqhN4hJo1XgO3PkBDRqov8Yc2+cCwnvcUMSN7OWydwQEelZgDz63fyWBBkkaUrK4o4K7ue4tK4D5gvlS6y9IXZ4/gRmglXV1tp3pcwWydAx4lT2NZ2eijFsxVQIb5rKqb8eHXBCWPS3QJIbSG93sDuee1EVZtva2QbaUc9xYbP0N0J0cRJ7ogq0heSB5DD+gKGHTcri/dlfSisJsE95FomfvhhIeEqfqbNGonOnsZdItVxNbp99Z9g9ayFZMP5a1+F4sDLvqvMIQdbzz36aNsrzFj1bZ6WKtaobmZIyNva1HeJFd3eUhfVTzal9jFYzWWASU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T+NURHIF0HhLKgcqQ75KIJlPDAidb0ihLqDRQCO4YYhRqzlQzUBlRib9pXEF?=
 =?us-ascii?Q?V8zC7VrbLEJg1Y78SsNHBtczyV7id27oyD60iezt0f4hqbiIwkRlE2CxStba?=
 =?us-ascii?Q?QqTU2MnZM6+C9v97IplVgKQS6MVaVI3r+Y5g51UpaxuOfsddvW7tuCFlcyMb?=
 =?us-ascii?Q?/p/qgIYGbB67oBVe0BZk7/wocdmoi79UjpHD6XRbiYJ86p+W1nfNJAetWC2i?=
 =?us-ascii?Q?Coa992lgwPOQK70WSSmuvTheb9Kk0TAu5JKA4nvqRRyOz2IMeazizhQ6CNXM?=
 =?us-ascii?Q?w2yS6Mg9EL6E8dLl6V1pGsHAwj5LrNQP+BhcKamPW5h81IfI9njFehaCSWxU?=
 =?us-ascii?Q?S+RPamVnyszYEIyQ1qgB1wSrZyv6nM/hQKJZlw1ApEUHki/OaCzuY9at9+du?=
 =?us-ascii?Q?ykQHCvTnpqAwXj3ej3b+vPrSlmbT2UrF3ZcKuStdMVnLVkl4d5khIAcGeB+I?=
 =?us-ascii?Q?rUhkiwDSUIJHXb4SEu0qbbXWVjZVFV4sLOfObTlnEfEh9klIePgIEDHtaooT?=
 =?us-ascii?Q?HmcabmWzjbw1OSpj3uAvrvCp5YChCX6hexnVhiYP0k8+otEHawc1HDVTylMg?=
 =?us-ascii?Q?4mR41TzQ75dzn9iTz7v2CjlcjGIhNN4w334skyaSxRolyZhwIohF38x+cgpT?=
 =?us-ascii?Q?gucUmjFpm2PuXhMcQX/tjOVuwmLWZZ6olMjSkXvXPRfJ1dyFACAHGBfMe73K?=
 =?us-ascii?Q?ZRm6JuqO3nvxGTCJacChWlLDimEPZ2Ru/kJDvMJt3G1XdVXi0MrpAcHqKlA2?=
 =?us-ascii?Q?j0fv/uHDOMqJyfHN174zD47cEQiNasmWP9i6ZErhwq6dr1IffmI/IG3mIxi+?=
 =?us-ascii?Q?Ed12KnYITMpH5j0615p5ojE4TjXUuLbfT2FZGVS4coJYFduhz8oZLA2akskO?=
 =?us-ascii?Q?0IzsNT2+QQyPETVEDPQbC9+BKaq32Thp1rQxOW8bMVFhIvjZgJqaCQhQQFh6?=
 =?us-ascii?Q?n97rfuF35Lx4cixUbUj0esMsPQh6DOw7GBWQ+aQq8I/knxEj3WZDJBgyvqB7?=
 =?us-ascii?Q?zNn6i8dpY0q9GmUpX3BdgU6kF3Naw2yWS26IcHFhBSD9qAWIkbZL4KuQMaOl?=
 =?us-ascii?Q?NpJ7pPfafHWBNAwgnF0evQED9k/ySo2XBLgZYesCy/k6ewrd4bBAtg6zcxSe?=
 =?us-ascii?Q?Ff9OKopMUJ+VD3JSD69S0DEykItf0VEdIUpnecke2+Q6sIx0rtWn1/w1gzL/?=
 =?us-ascii?Q?NCrqx2uGQyt+CmIdbIrdhl2CV/lG0jaqSTo/FWFfN63/SYYir4WOx2iOo2hU?=
 =?us-ascii?Q?J9fzHpZnFUMB+Ng3hMrJ+uP7QzgwuE33kqtxUmYF1K3JDuf6vU1cAuNc8I2H?=
 =?us-ascii?Q?HFW6/ixhcaC1wfronssvNjRB/npt4b63wwAA0ut5B+Q27s1qxbuNd+nNrzcG?=
 =?us-ascii?Q?rOM1LeCf3LsSUBCdjD68eb2hagiqhuPVKpu40CF3cUWNKs7ApyNC3UQyi7Qh?=
 =?us-ascii?Q?QGm5J06CcYoewgw4gT+U9pMmkGjY4iceBEj1YZ/Cv2mMLt6VYx1uO1BENLPV?=
 =?us-ascii?Q?5iBuDYxWX1CBeqY3IDc7LyQrxttWdZbAv1zl4DA/tjEMAkELiVJfeLobz/dM?=
 =?us-ascii?Q?N68QymmDvkYgW4MwozW0QmvIxu5+i9vvCFmFt69Ketd5/eWX+CyFbPx1O2ib?=
 =?us-ascii?Q?9lCYpGzYGOPcV9qCYS0ErHZHIr/Bo6Ya5t/o0saaC1LgA1ygsQrBgiWJJyHb?=
 =?us-ascii?Q?5woBtBZ1B0BAzK9sZXm3HNp4ilNGKxk5hmf8KwYPLfkWU5HU4RT2yy/HmdkE?=
 =?us-ascii?Q?7sNx4Rqs9Q=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7c9f814-9b80-49bc-c44a-08de9bee9c15
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2026 19:30:25.8951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VEcb8ML4Gx61rimEzRjj3Smkz2/rLyXfvBdfKuJEG2czKqEtRzLqoIOR0dIfRden1ShPmht7+QvJNgsWRM6Tpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP123MB4039

From: Daniel Wagner <wagi@kernel.org>

Extend the capabilities of the generic CPU to hardware queue (hctx)
mapping code, so it maps houskeeping CPUs and isolated CPUs to the
hardware queues evenly.

A hctx is only operational when there is at least one online
housekeeping CPU assigned (aka active_hctx). Thus, check the final
mapping that there is no hctx which has only offline housekeeing CPU and
online isolated CPUs.

Example mapping result:

  16 online CPUs

  isolcpus=io_queue,2-3,6-7,12-13

Queue mapping:
        hctx0: default 0 2
        hctx1: default 1 3
        hctx2: default 4 6
        hctx3: default 5 7
        hctx4: default 8 12
        hctx5: default 9 13
        hctx6: default 10
        hctx7: default 11
        hctx8: default 14
        hctx9: default 15

IRQ mapping:
        irq 42 affinity 0 effective 0  nvme0q0
        irq 43 affinity 0 effective 0  nvme0q1
        irq 44 affinity 1 effective 1  nvme0q2
        irq 45 affinity 4 effective 4  nvme0q3
        irq 46 affinity 5 effective 5  nvme0q4
        irq 47 affinity 8 effective 8  nvme0q5
        irq 48 affinity 9 effective 9  nvme0q6
        irq 49 affinity 10 effective 10  nvme0q7
        irq 50 affinity 11 effective 11  nvme0q8
        irq 51 affinity 14 effective 14  nvme0q9
        irq 52 affinity 15 effective 15  nvme0q10

A corner case is when the number of online CPUs and present CPUs
differ and the driver asks for less queues than online CPUs, e.g.

  8 online CPUs, 16 possible CPUs

  isolcpus=io_queue,2-3,6-7,12-13
  virtio_blk.num_request_queues=2

Queue mapping:
        hctx0: default 0 1 2 3 4 5 6 7 8 12 13
        hctx1: default 9 10 11 14 15

IRQ mapping
        irq 27 affinity 0 effective 0 virtio0-config
        irq 28 affinity 0-1,4-5,8 effective 5 virtio0-req.0
        irq 29 affinity 9-11,14-15 effective 0 virtio0-req.1

Noteworthy is that for the normal/default configuration (!isoclpus) the
mapping will change for systems which have non hyperthreading CPUs. The
main assignment loop will completely rely that group_mask_cpus_evenly to
do the right thing. The old code would distribute the CPUs linearly over
the hardware context:

queue mapping for /dev/nvme0n1
        hctx0: default 0 8
        hctx1: default 1 9
        hctx2: default 2 10
        hctx3: default 3 11
        hctx4: default 4 12
        hctx5: default 5 13
        hctx6: default 6 14
        hctx7: default 7 15

The assign each hardware context the map generated by the
group_mask_cpus_evenly function:

queue mapping for /dev/nvme0n1
        hctx0: default 0 1
        hctx1: default 2 3
        hctx2: default 4 5
        hctx3: default 6 7
        hctx4: default 8 9
        hctx5: default 10 11
        hctx6: default 12 13
        hctx7: default 14 15

In case of hyperthreading CPUs, the resulting map stays the same.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
[atomlin:
    - Fixed absolute vs. relative hardware queue index mix-up in
      blk_mq_map_queues and validation checks; fixed typographical
      errors
    - Reduced stack frame size of blk_mq_num_queues()]
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 block/blk-mq-cpumap.c | 168 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 150 insertions(+), 18 deletions(-)

diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
index 8244ecf87835..f7c5f52f3b35 100644
--- a/block/blk-mq-cpumap.c
+++ b/block/blk-mq-cpumap.c
@@ -22,7 +22,11 @@ static unsigned int blk_mq_num_queues(const struct cpumask *mask,
 {
 	unsigned int num;
 
-	num = cpumask_weight(mask);
+	if (housekeeping_enabled(HK_TYPE_IO_QUEUE))
+		num = cpumask_weight_and(mask, housekeeping_cpumask(HK_TYPE_IO_QUEUE));
+	else
+		num = cpumask_weight(mask);
+
 	return min_not_zero(num, max_queues);
 }
 
@@ -31,9 +35,13 @@ static unsigned int blk_mq_num_queues(const struct cpumask *mask,
  *
  * Returns an affinity mask that represents the queue-to-CPU mapping
  * requested by the block layer based on possible CPUs.
+ * This helper takes isolcpus settings into account.
  */
 const struct cpumask *blk_mq_possible_queue_affinity(void)
 {
+	if (housekeeping_enabled(HK_TYPE_IO_QUEUE))
+		return housekeeping_cpumask(HK_TYPE_IO_QUEUE);
+
 	return cpu_possible_mask;
 }
 EXPORT_SYMBOL_GPL(blk_mq_possible_queue_affinity);
@@ -46,6 +54,14 @@ EXPORT_SYMBOL_GPL(blk_mq_possible_queue_affinity);
  */
 const struct cpumask *blk_mq_online_queue_affinity(void)
 {
+	/*
+	 * Return the stable housekeeping mask if enabled. Callers (e.g.,
+	 * the IRQ affinity core) are responsible for safely intersecting
+	 * this with a local snapshot of the online mask.
+	 */
+	if (housekeeping_enabled(HK_TYPE_IO_QUEUE))
+		return housekeeping_cpumask(HK_TYPE_IO_QUEUE);
+
 	return cpu_online_mask;
 }
 EXPORT_SYMBOL_GPL(blk_mq_online_queue_affinity);
@@ -57,7 +73,8 @@ EXPORT_SYMBOL_GPL(blk_mq_online_queue_affinity);
  *		ignored.
  *
  * Calculates the number of queues to be used for a multiqueue
- * device based on the number of possible CPUs.
+ * device based on the number of possible CPUs. This helper
+ * takes isolcpus settings into account.
  */
 unsigned int blk_mq_num_possible_queues(unsigned int max_queues)
 {
@@ -72,7 +89,8 @@ EXPORT_SYMBOL_GPL(blk_mq_num_possible_queues);
  *		ignored.
  *
  * Calculates the number of queues to be used for a multiqueue
- * device based on the number of online CPUs.
+ * device based on the number of online CPUs. This helper
+ * takes isolcpus settings into account.
  */
 unsigned int blk_mq_num_online_queues(unsigned int max_queues)
 {
@@ -80,23 +98,104 @@ unsigned int blk_mq_num_online_queues(unsigned int max_queues)
 }
 EXPORT_SYMBOL_GPL(blk_mq_num_online_queues);
 
+static bool blk_mq_validate(struct blk_mq_queue_map *qmap,
+			    const struct cpumask *active_hctx)
+{
+	/*
+	 * Verify if the mapping is usable when housekeeping
+	 * configuration is enabled
+	 */
+
+	for (int queue = 0; queue < qmap->nr_queues; queue++) {
+		int cpu;
+
+		if (cpumask_test_cpu(queue, active_hctx)) {
+			/*
+			 * This hctx has at least one online CPU thus it
+			 * is able to serve any assigned isolated CPU.
+			 */
+			continue;
+		}
+
+		/*
+		 * There is no housekeeping online CPU for this hctx, all
+		 * good as long as all non-housekeeping CPUs are also
+		 * offline.
+		 */
+		for_each_online_cpu(cpu) {
+			if (qmap->mq_map[cpu] != qmap->queue_offset + queue)
+				continue;
+
+			pr_warn("Unable to create a usable CPU-to-queue mapping with the given constraints\n");
+			return false;
+		}
+	}
+
+	return true;
+}
+
+static void blk_mq_map_fallback(struct blk_mq_queue_map *qmap)
+{
+	unsigned int cpu;
+
+	/*
+	 * Map all CPUs to the first hctx to ensure at least one online
+	 * CPU is serving it.
+	 */
+	for_each_possible_cpu(cpu)
+		qmap->mq_map[cpu] = 0;
+}
+
 void blk_mq_map_queues(struct blk_mq_queue_map *qmap)
 {
-	const struct cpumask *masks;
+	struct cpumask *masks __free(kfree) = NULL;
+	const struct cpumask *constraint;
 	unsigned int queue, cpu, nr_masks;
+	cpumask_var_t active_hctx;
 
-	masks = group_cpus_evenly(qmap->nr_queues, &nr_masks);
-	if (!masks) {
-		for_each_possible_cpu(cpu)
-			qmap->mq_map[cpu] = qmap->queue_offset;
-		return;
-	}
+	if (!zalloc_cpumask_var(&active_hctx, GFP_KERNEL))
+		goto fallback;
+
+	if (housekeeping_enabled(HK_TYPE_IO_QUEUE))
+		constraint = housekeeping_cpumask(HK_TYPE_IO_QUEUE);
+	else
+		constraint = cpu_possible_mask;
+
+	/* Map CPUs to the hardware contexts (hctx) */
+	masks = group_mask_cpus_evenly(qmap->nr_queues, constraint, &nr_masks);
+	if (!masks)
+		goto free_fallback;
 
 	for (queue = 0; queue < qmap->nr_queues; queue++) {
-		for_each_cpu(cpu, &masks[queue % nr_masks])
+		unsigned int idx = (qmap->queue_offset + queue) % nr_masks;
+
+		for_each_cpu(cpu, &masks[idx]) {
 			qmap->mq_map[cpu] = qmap->queue_offset + queue;
+
+			if (cpu_online(cpu))
+				cpumask_set_cpu(queue, active_hctx);
+		}
 	}
-	kfree(masks);
+
+	/* Map any unassigned CPU evenly to the hardware contexts (hctx) */
+	queue = cpumask_first(active_hctx);
+	for_each_cpu_andnot(cpu, cpu_possible_mask, constraint) {
+		qmap->mq_map[cpu] = qmap->queue_offset + queue;
+		queue = cpumask_next_wrap(queue, active_hctx);
+	}
+
+	if (!blk_mq_validate(qmap, active_hctx))
+		goto free_fallback;
+
+	free_cpumask_var(active_hctx);
+
+	return;
+
+free_fallback:
+	free_cpumask_var(active_hctx);
+
+fallback:
+	blk_mq_map_fallback(qmap);
 }
 EXPORT_SYMBOL_GPL(blk_mq_map_queues);
 
@@ -133,24 +232,57 @@ void blk_mq_map_hw_queues(struct blk_mq_queue_map *qmap,
 			  struct device *dev, unsigned int offset)
 
 {
-	const struct cpumask *mask;
+	cpumask_var_t active_hctx, mask;
 	unsigned int queue, cpu;
 
 	if (!dev->bus->irq_get_affinity)
 		goto fallback;
 
+	if (!zalloc_cpumask_var(&active_hctx, GFP_KERNEL))
+		goto fallback;
+
+	if (!zalloc_cpumask_var(&mask, GFP_KERNEL)) {
+		free_cpumask_var(active_hctx);
+		goto fallback;
+	}
+
+	/* Map CPUs to the hardware contexts (hctx) */
 	for (queue = 0; queue < qmap->nr_queues; queue++) {
-		mask = dev->bus->irq_get_affinity(dev, queue + offset);
-		if (!mask)
-			goto fallback;
+		const struct cpumask *affinity_mask;
 
-		for_each_cpu(cpu, mask)
+		affinity_mask = dev->bus->irq_get_affinity(dev, offset + queue);
+		if (!affinity_mask)
+			goto free_fallback;
+
+		for_each_cpu(cpu, affinity_mask) {
 			qmap->mq_map[cpu] = qmap->queue_offset + queue;
+
+			cpumask_set_cpu(cpu, mask);
+			if (cpu_online(cpu))
+				cpumask_set_cpu(queue, active_hctx);
+		}
 	}
 
+	/* Map any unassigned CPU evenly to the hardware contexts (hctx) */
+	queue = cpumask_first(active_hctx);
+	for_each_cpu_andnot(cpu, cpu_possible_mask, mask) {
+		qmap->mq_map[cpu] = qmap->queue_offset + queue;
+		queue = cpumask_next_wrap(queue, active_hctx);
+	}
+
+	if (!blk_mq_validate(qmap, active_hctx))
+		goto free_fallback;
+
+	free_cpumask_var(active_hctx);
+	free_cpumask_var(mask);
+
 	return;
 
+free_fallback:
+	free_cpumask_var(active_hctx);
+	free_cpumask_var(mask);
+
 fallback:
-	blk_mq_map_queues(qmap);
+	blk_mq_map_fallback(qmap);
 }
 EXPORT_SYMBOL_GPL(blk_mq_map_hw_queues);
-- 
2.51.0

