Received: from CWXP265CU010.outbound.protection.outlook.com (mail-ukwestazon11022129.outbound.protection.outlook.com [52.101.101.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034403B3BE2;
	Thu, 16 Apr 2026 19:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.101.129
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776367812; cv=fail; b=Bcw+m9h/4r+zpYA54voHPTuggfyoijY37coro0jUCjYWJoi4o3wl4qu651XcwKGefUP0jvP5kVsBgUdvTXzVZiYA8jjw1iUo3KdEuS6N/WKDuzf4hDyq7WBSs/TqFCnXmcXaLyKmWXm9rygMOuoqA/XPGq74wtzj1N/RX75/Bng=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776367812; c=relaxed/simple;
	bh=2POLte3qby/sLmbIsBi3hjd2wRiNqfCvljEooOUDn+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=H+mYUD0AVkBzaPzAvmNVfHqKtVQE1wz4npFm7/Xi4t5JVv3K6o2Y+Gaxw26l4jh96UgokPAnOhk6ZAuc6qJa/FSdfm9PyhYoe78Hz7nvRwonRygveCyPRM/yJGt2uk0r8gPCskdkwg8TxWjoDH6JAHJXe6rC1OllxOW6qNDcU+I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.101.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UMBqNrDsHsCF4QXLFtnsuweYcP8mJWGvgNOoBbQgVDv2+A7VDHnwJXb2DT3Yj/M5h3y3yXTCnScjIJK55siQRACnrTBNfHY5GqkDTr1iEqH9YU+rNhuLdv8NOwRln11xr79CzufNpn6JqhPjIkeDE82h4TMzwj0XliWIqlxG2IyvqQrPio34Q3DaIZcyHIcC/oZ3lSnfYXarcaAvk/ipul9cJfzbIJAhRtih2Xh+kWPx+wZO4U6XAwn5uhoC9D9QEwVdrS9OC2s0cMpiiMA60Oej0Ijubh/PWtGd7Bq/De4J6bR8Ht/mdaRrWOsPhiEU6eSOlYid4bu9aBV1aHESTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SkpJV0Acr6ivunvsCeqjk4MU1/anTGgNIBbWs0F3/tY=;
 b=uJzNBsV+Z0pxkwvupQJK5tzdSRgQKQsJ+hnA9WkLkcOlyFMrQ/6uBsWg2hf2ne9l6a10+i7BQpXOrtHC2nCdMh2RFcXf/76fCyZsNcTFt3uXtIguXPgz2rOMQyIa0rxqBYauVs0jRv8PmfDKQuImUTrsFRzpkRLoFma6kiZLu4ViQDYH6eJ90ch8QxUw9um5HxGHcBXnuGaitjBV0L8SnHXhfPSo67ies62sdHdcn687zEOZyB6J9kgtg/URQqd+oiU+12R17iCfCthXRzIU+NQri93qY4QO6huNJW21I0MhT4GDX727Ln36GL4p4RuCBgN2WZg4Q8btdzzrzMHBQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWXP123MB4039.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:c5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Thu, 16 Apr
 2026 19:30:06 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.046; Thu, 16 Apr 2026
 19:30:06 +0000
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
Subject: [PATCH v11 05/13] blk-mq: add blk_mq_{online|possible}_queue_affinity
Date: Thu, 16 Apr 2026 15:29:34 -0400
Message-ID: <20260416192942.1243421-6-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260416192942.1243421-1-atomlin@atomlin.com>
References: <20260416192942.1243421-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0962.namprd03.prod.outlook.com
 (2603:10b6:408:109::7) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWXP123MB4039:EE_
X-MS-Office365-Filtering-Correlation-Id: 52c763e6-9d4c-420e-c2a5-08de9bee9095
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	j1yYIefOhY7JaTgfsYvHrdopEsaBmqDpsA2mbtxVuBeHdtM3CvFnmX61T1UEaWXUmeaXhmL58+mI3SsKUSKVDXJuRW56SspTNVL8WvK9fVEtZ4lfJ36RLMgKkE1WJclnb+3Wd2gCLP2wKXcebBbKzFxOjsrJx/xNLkbCpDKhb+J96VhEhm4olZsevtvaHWyaXRRUW9ad4iaxopOnHHXS6oM7efE95TISOz/okjJmEQ1bm5Rshitdw4+7gfIRHWocI8mmh+kaz+JDCyJ6inysaL9rnBNibP7fid0e+/ak9PmWtxJiHs/dE8buZE/3mFbDrzAOupJNWREBSAvp5BaiUSdEnwJSx8wjczWiiidui2gs7f8oZUCMA1mMSf/qAqPBdIbq/Oq6pe3rPmjpp1usvKReyfsrKaMQLUQAH+zUMJyKBPT8RNngIeap5mumBuGa/n39wZikvyo+9ODdtQ2YSY+3h5a7vv3vNlrgKEAEKo4yfa75SEa49GM7DlfCEmGfsvE3LXO4XzApDAkV+pR3lrCiCLpERHiub3K/KY7H2eV+XHz4bHl79xlJ14hPaPSZZZ4+7pPadZyjvsBvOw1LkgU1PnDQQLZGHbOcPGETD0WvIb15CvYcz6OVq5D2p7piks6AKfmsKzcQM0HgYapBSN3nxdn9Sqx1JS624Sl2h1xJujXARP4qcecH9KDXDx5JlUUM41Q6B/sYiquBhBPRzs7Nph3hPScCQGBfUBzK4Rs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?O0ZFKIHL9BLLY6q/2D8MycMbgkBecalMB1RvBFv4w4Dy5iu2DH5qbBqfpHxG?=
 =?us-ascii?Q?cJ4judIpnpBUYY1aPkwZaFYC9iU2lY6wY+eo62iMzLXj8lcSAQropNB9lueu?=
 =?us-ascii?Q?lUTbADAFHItVc5R8LbzpJUcpeIxdq61FZA0CQMEDZ2bqU8qi1T+qmRexSHuz?=
 =?us-ascii?Q?EhvjpeQTU1j3gZYdWurcgMhbHKEZG+afpek2Xd6Nrjwy9ZJKGW5piEFZ+gW0?=
 =?us-ascii?Q?dwXPc1+rq1X9K98zGQgBKwKb/JIhsaOI5az4X/FO7rb3OV8TFr4xL1U30GbY?=
 =?us-ascii?Q?QCDgY/v1cEiUt5aK0Ho4LcVlAuc/qRJfYzMBP0Rd1xWhil4STaADcdLa25fi?=
 =?us-ascii?Q?s9igeX+0+timk9BB2ZrvkI/fLxvlD3gkPDdJycgs4chLtWVoBoNwLhqhJm7I?=
 =?us-ascii?Q?CXx81aTSpGVND7EkDyL1CLMBAjRfAupBB1xE2VzoR06hTsukNf4wDRe+TCR0?=
 =?us-ascii?Q?mOtmbTMOGbBDdFX6Vk2cbNSRr5Yf0X3qiI5JrbMEPFALjvwULO9IfogyXGBQ?=
 =?us-ascii?Q?Zy3ammi51bY2whvcS5VTrhyDM+AJ4YDiIEBe1BBJo7EPfMdSEXIWEI2DctIH?=
 =?us-ascii?Q?IIJPlEESPxXFVBoxUyBZEZSfXnU3P/euODTe50Nv2PNt5kAlqm+eJ2TD/XBr?=
 =?us-ascii?Q?7YLqHg8pjI7UU3F1M2T/gHElhFYF2PE/yn1XG2vUTZZH4p1KxKlLEXpCGa/p?=
 =?us-ascii?Q?wjkkN1z5KpcY53zMsN2CEdpGwCwlYiUj23U21sYH5CXLuwPCeKUjqzt523WZ?=
 =?us-ascii?Q?XY8uLDG6TL/DBehkKs77q3sucJybY94cFz3f8HNY4PZRk4XDVsVdPqhB2xXF?=
 =?us-ascii?Q?Z7e3UQy2QuPqQ8ADD8qOEUQarFpro9Ax390WVwalfdA+IqZCZuhxYgy0noAU?=
 =?us-ascii?Q?2cyl6aIKp48kcRoCi5Oro6MQzmUQbo86dvonrgiJW2cuUL47/rI3cK/JB638?=
 =?us-ascii?Q?kbSjVfyvXRVX91ouaVyfJ+lo1kmPjnAJ5NgTbPu4a+FV0hmOg7QOhsEtZG2B?=
 =?us-ascii?Q?+VpviNTbMQ83LIU0YCemMlw/+vVS+XqY3m9U4IBYb/4D0rHhv+IypnCgtVBo?=
 =?us-ascii?Q?sK9v1KOsINapcF3wgDZp7iAV0uKCRxeqrf/MXrinRwajd22hXhiHTrJIyEbb?=
 =?us-ascii?Q?srRYu50BjGZHxB2dLO4ldWwnXLZdQvnyWAi8n+y7LnHTLhU0G6dqw+0GFy2Z?=
 =?us-ascii?Q?q5+TVGx5WaUoN14IlVIltXi9F/BZlsrQzDY89c8ZCLAmIuQP6rRfM16XW0GM?=
 =?us-ascii?Q?2ZidmbeNlY13IUQyJH/nYgRznI3MdjqoNzqRWue9z8W0Pithv5JaYkEuxG6k?=
 =?us-ascii?Q?MmxTiPEZFsMUdPewnbJOmsUkcy2yTTr1LRmYc3iC+XNArzkHkkSgKG0Mtwmo?=
 =?us-ascii?Q?qKpQVHR7vBmWzNqAGhULia4MflL9oeIAoDcmmPrUG9cG+tU1ST0eZcLm98Xt?=
 =?us-ascii?Q?/N3Icl5/ULOc7Ju3docM4/X1O2U+dizueeN6qI2EbQ2oTV9nWziIlHbhiMq6?=
 =?us-ascii?Q?eYU7tDZbCkSrDH0ve5NsHRfAgkLhP5Na4bNaUxYAANuF2wVZenm2R89g41uZ?=
 =?us-ascii?Q?UQSjTFt2k+WeeTfSJORFwj9pcVMk7b8OdXJEvmIzpjPrNH4wflhFVS0JchJt?=
 =?us-ascii?Q?OctAHgwX9ARNvEXvQTBS1zWBPShGD+xv1xzFqxOn5c5rannN8TSC1eK++UHC?=
 =?us-ascii?Q?3m4b5oZsikBL4YJmN+kngGbBm/hhJ11UBy/ZqkLEx9Z19ZqGcxoIRVgy7oj4?=
 =?us-ascii?Q?ShJa1TPgfA=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52c763e6-9d4c-420e-c2a5-08de9bee9095
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2026 19:30:06.5387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xKArR4pqecur346V7KOqFRQhccyAoBcvK7hQjjIWE0Ip7CXZvgCz5i1yRL9pp1SsZseJYCDDJTSGdVLF4/WAeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP123MB4039

From: Daniel Wagner <wagi@kernel.org>

Introduce blk_mq_{online|possible}_queue_affinity, which returns the
queue-to-CPU mapping constraints defined by the block layer. This allows
other subsystems (e.g., IRQ affinity setup) to respect block layer
requirements.

It is necessary to provide versions for both the online and possible CPU
masks because some drivers want to spread their I/O queues only across
online CPUs, while others prefer to use all possible CPUs. And the mask
used needs to match with the number of queues requested
(see blk_num_{online|possible}_queues).

Signed-off-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 block/blk-mq-cpumap.c  | 24 ++++++++++++++++++++++++
 include/linux/blk-mq.h |  2 ++
 2 files changed, 26 insertions(+)

diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
index 705da074ad6c..8244ecf87835 100644
--- a/block/blk-mq-cpumap.c
+++ b/block/blk-mq-cpumap.c
@@ -26,6 +26,30 @@ static unsigned int blk_mq_num_queues(const struct cpumask *mask,
 	return min_not_zero(num, max_queues);
 }
 
+/**
+ * blk_mq_possible_queue_affinity - Return block layer queue affinity
+ *
+ * Returns an affinity mask that represents the queue-to-CPU mapping
+ * requested by the block layer based on possible CPUs.
+ */
+const struct cpumask *blk_mq_possible_queue_affinity(void)
+{
+	return cpu_possible_mask;
+}
+EXPORT_SYMBOL_GPL(blk_mq_possible_queue_affinity);
+
+/**
+ * blk_mq_online_queue_affinity - Return block layer queue affinity
+ *
+ * Returns an affinity mask that represents the queue-to-CPU mapping
+ * requested by the block layer based on online CPUs.
+ */
+const struct cpumask *blk_mq_online_queue_affinity(void)
+{
+	return cpu_online_mask;
+}
+EXPORT_SYMBOL_GPL(blk_mq_online_queue_affinity);
+
 /**
  * blk_mq_num_possible_queues - Calc nr of queues for multiqueue devices
  * @max_queues:	The maximum number of queues the hardware/driver
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 18a2388ba581..ebc45557aee8 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -969,6 +969,8 @@ int blk_mq_freeze_queue_wait_timeout(struct request_queue *q,
 void blk_mq_unfreeze_queue_non_owner(struct request_queue *q);
 void blk_freeze_queue_start_non_owner(struct request_queue *q);
 
+const struct cpumask *blk_mq_possible_queue_affinity(void);
+const struct cpumask *blk_mq_online_queue_affinity(void);
 unsigned int blk_mq_num_possible_queues(unsigned int max_queues);
 unsigned int blk_mq_num_online_queues(unsigned int max_queues);
 void blk_mq_map_queues(struct blk_mq_queue_map *qmap);
-- 
2.51.0

