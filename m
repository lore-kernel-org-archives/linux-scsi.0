Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020139.outbound.protection.outlook.com [52.101.196.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD6B39D6C3;
	Wed,  1 Apr 2026 22:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.196.139
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775082251; cv=fail; b=MjIDsjX64wYY4xA7kW9wl7g6T6ohS+COnQje52WuuqmZvOtzmrfoQLMF/9bL8qXJou8s6hNCKNezSZS1GdirlQztzyZYPxGFMCYS1T5yiTIzfIhu25+nTZWjN/Lb0SAP/hvsHU1oQOjU0E4lgySy1gIQ5nL7uhFq83DyCA683Pc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775082251; c=relaxed/simple;
	bh=Ocfz3QWh53aSW58jo4FdFAyN3l/bZ0RDahDBiSlVUNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ca9kH2ekPcQt8H9vIZogiuJYq1TD5kTeKrjxThjjZHQEq5Ueuc6EhnmFAX7OrH6jczGUjERVr+IReExc+sO78jCUJFO99ELahdRcCm3cnDdnzU83TJ2PAw3C1Hf9o7m+kSR9zHNMyKhcd59neg3A8K4ObGmkz5vQ5YGI2+0nPA8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.196.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R+AAFP9AaRPtIZhQARyOIxyGcZ94AGsY3TcSHpVerRegWLAWVSyG+49vcc8xoOfy/HIkbeYEkzOWg6qhPg/gxKl4UfCVvAnhA2awlIx28bFaKbkvxzINHRJD4sqrkGsSiWluoj3QzWOpiS804uaTHJzVinOlfhzSuuMFFfNMQVlB7B7SflESrVGN5O72xCIc9OwHqvJViDGnFQtpgHhMltT+BW4Ff6fz3NXnsLCi/MhA2s67oiMdHQ8dbp8icXwPbWll2w4E3evnsz5eeezQz/phz9ufb9PMJnnJSdmf6uF4Ks1BTpEkPVRhN/D5QVQ1wuaNrGf2cTvwr1JS1/I6HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i2JdaUkdYqJZv+sWSdGzZFDC8CSZMUcYmPlzykcGGng=;
 b=stThIkB4wV3mHSpcUCfp1q6FlwHDo854w3f68s0qVVTQX24gbBZdg+yyPvVwrghGNKTpxEvJfxq/PA62wfHQJDrbicCUrIbWGsuXCX7hts400CrI3KLphcZDWUiBeIUI7EndQJl97+R4KExanMzOHqVqXc05ncz2kg3Vgwgel9QSTHRhI6CFkmYPNyU4LDLht5CPp3Xmhh8KkPcfNbVYlAPjijflCpogJsD9M9Oj5DhURkWRnNngKhXsfu01z+wIN9HA0OIYlzgxUhYPFPt2C0keCmZDwfJsveD15/8gRHbwSkMPotu3RwoUERHcOW5EtqzcoyLd953L3WsBhB7vbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWLP123MB2964.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:58::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.24; Wed, 1 Apr
 2026 22:23:47 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.016; Wed, 1 Apr 2026
 22:23:47 +0000
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
	steve@abita.co,
	sean@ashe.io,
	chjohnst@gmail.com,
	neelx@suse.com,
	mproche@gmail.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v10 09/13] isolation: Introduce io_queue isolcpus type
Date: Wed,  1 Apr 2026 18:23:08 -0400
Message-ID: <20260401222312.772334-10-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260401222312.772334-1-atomlin@atomlin.com>
References: <20260401222312.772334-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0557.namprd03.prod.outlook.com
 (2603:10b6:408:138::22) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWLP123MB2964:EE_
X-MS-Office365-Filtering-Correlation-Id: aafac445-66a8-46da-01fa-08de903d57e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Mqeuvgp7rOYrbQKQGwCeu22guAcv0deGDEXsNh4QGpBDd/A7eraGFnhg0gHcoGMZy1t35NK5JcuwUXvcHQlFpPsRxV+U7RsetrlkbRYlt70YaGVKqJyYseksTUHiKxpNwA+bSx9SFFFuvGskUOimABYNozzyqQWKuFFocJbz/mi9JqGSrE9yw/YJ65a4lVQ4lC+7uQLNlAOc5Cv6sp4Kvoz2SIcpl3aMbVwFwAjENcbBqBV3CcgMK29buW5azwPHm4Ul84QzfLmSyHr4zWpiVATk6isbgKLs5Z9fIKBhZIvVizfI6qwbBh2FKtCG720eKgBymjUu7nAN9LtCpW46Y04dPasxascvJdz5aqEWIcDKGPNLaPVEVqPkB+v7teHK0ZYKCNGrsiszQMDYc4WAaDmSB0jE3HyR+/V+rOyFDyufVYgjEAlg40uWlF2Aw6uskcaT6sR0SbYHEV7XLT8mNV/eGG8zTKPz7pikO0w488LU+QrFOwONHVMkjMEjGoEQoEIr7LF4iu0E7lC+fo7Avvo2AduCD0gv3zXRgZampRa0KLf4mGDsPQdvUTxwlDXgtWSXE6qWPwIfDb7nCakWSU9RqkZLrW57os7mJwcFNGflbueVr/tm2hbcuJsddZQ8QgjEEXQZfE+7hqleXbzo1qH3chBsR1uZs3V839Pc4w05H/iJAr2C9U0fGGlystc8NCQvSBMlOOHJyNRN9quc7a5qw+C0OKQtki9+TBKEG1Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UmyLSqP3MhMI/WgvhOh0wOp6DmVfifGSedX37piHChswRridYT+P3JI5Jwu+?=
 =?us-ascii?Q?QercyGpqn36NskHsTqhV/3T67pu/z7wMc312KeksRe3YSzwf1654VVXl8AOZ?=
 =?us-ascii?Q?AaVeXwIegdlYjjhreH26VymqlJ/UAYakkaLBwpDe01G9A4r6CSMdUScqZBLm?=
 =?us-ascii?Q?qnxF66fluw86ImSFkHd/eRNfp/HF9PobUPW/Wf6sND8RzzMXc8D0loAiPR6k?=
 =?us-ascii?Q?rff0S2m4qIdGrQbbprCL0KYhS/twKfNDZlxzKZN1bWnsBjtQ7CHE9XXHevzv?=
 =?us-ascii?Q?U/YymSzmMLJTjIsZ330vKLBe84XYlltOzUEdrEpRQEzxDTgwH/g8BmJI1a6l?=
 =?us-ascii?Q?S9HCFZXEjllJw3eFqNpbLCOolocLAfq8YW8C2cACVwCLdXBD6IryDdoF0g5r?=
 =?us-ascii?Q?XqcxAA38sl4dIAc118rFkU9eGYBAnsEmyjUj+/Yot/pN4tl5B0ZR6t3rpfcW?=
 =?us-ascii?Q?gdT1wG3jG3rN2zyIL+SRuikCRqW4xLlpLKr11c2OwzdREN30z5HBtK9i+AgC?=
 =?us-ascii?Q?wufv0GB4/Qq7CScnZuhzuGbaby58p6Qwy8hP92Hf9Ul/SfG2nd5QG/G6snRp?=
 =?us-ascii?Q?UDidyrGtvAtjsmZRxcAh7DyH5YesViEFIRWgYeMXmY+yBFcp/rZPgtOHq2FA?=
 =?us-ascii?Q?wply87Q85o6iTnNV0we7JxT7NvcPWFoDWW8iErL0iy66kFHNILelSsj2UUme?=
 =?us-ascii?Q?KHofWVUumFt2KhOVjDU8iFyw7qtFwRgSbWhlFlamNqYiE+LU/Of5/fseyNbL?=
 =?us-ascii?Q?joYJJ+6aSq4fPkfooo4j9dMMwCp7lQKVaGK2pYrDqfgwKFgZSI/PKaLIMJPG?=
 =?us-ascii?Q?rurbrHly3Xs/CRX6mlSsC3B7chW0npcdwxwUOQcEmIicBrluNq7GH+u/MVq4?=
 =?us-ascii?Q?EOALAe/O18YcEyBB91jeWdysY/hgzSPTBy0zPc/EhA3yWT/sbMVZ8ie7UFHV?=
 =?us-ascii?Q?VxbLTRl7IWwlc1xr5tVdh9ggJhrMHvPD8XcduoTMF663avGRsi6JsxnRSekP?=
 =?us-ascii?Q?xghvk/BiBgPnXSbIsIqaN4gmHMC1cCmukueO4yTHeGrfd+fzov+jvMQaLsOC?=
 =?us-ascii?Q?w0PUfFSwmh50ssLVJInocuEZD2xKTdfumDK1ZNCUEYKiIEkgCAlwXFq25RZW?=
 =?us-ascii?Q?X3aQWopcUd5uiZdFGYvBIeAMhEStFC1DRu/ECcKW8mY9Km6si8Foj9cpaxNv?=
 =?us-ascii?Q?0BN1adqfARZSzJXHr5qVvkiqmrYY35dA0xAHEJNw7MR9tY8Xii9GgXgpWkfn?=
 =?us-ascii?Q?AHOgBkwBSAuhMcNy5/4gRBz2feBbG+0jBAv9vax3vE+dGZ8uKDeFURkgZ+3I?=
 =?us-ascii?Q?FINL2LEbwhfXeVDKlYxlKOhBxTUZnhja0iozdUmGj9i4OyRFZSSUJhpJze9C?=
 =?us-ascii?Q?uK/XaNlScD9bGdKQ61r1U2N9pv85Hj5k1tnYV12QNv7V0/dK4CacFUszlQ6I?=
 =?us-ascii?Q?Ix5ZQ3HkBcOTzyOrCBrrN6+83xxR/pA/04Ckbcwpm/+15YfFSY9QzhLyXO2n?=
 =?us-ascii?Q?uTTLy0ecsJd2whw52vgvLeTM1CqHw1YPUUrLMI2eMsUxtIc3+CylchnV7FAk?=
 =?us-ascii?Q?HZ7uBghovZ5zA1fo5DHgMBFD/fi77kCO8jnkCFqx3kzvLWgVBx4m9myitgYP?=
 =?us-ascii?Q?ncFqBb9ZEJroUlXXZJZXzvGkqsbcWO6aVZ4IiwCPBMePuoLFUIdL4m4CXTjy?=
 =?us-ascii?Q?silF6MTIhquj2Cd9/ID3M3FRpbgXUqBpah9i24hKM8iBszVZifZtIW04MEzP?=
 =?us-ascii?Q?63CDCYKPRQ=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aafac445-66a8-46da-01fa-08de903d57e0
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 22:23:47.5862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7wWlBsHLA7Varpq2n3FWpDu30yRCV8CxOabWCDJ4epj/AnA/RT8j3auczMa8YqFTsrjTAyX8ywxmFH98C15csA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB2964

From: Daniel Wagner <wagi@kernel.org>

Multiqueue drivers spread I/O queues across all CPUs for optimal
performance. However, these drivers are not aware of CPU isolation
requirements and will distribute queues without considering the isolcpus
configuration.

Introduce a new isolcpus mask that allows users to define which CPUs
should have I/O queues assigned. This is similar to managed_irq, but
intended for drivers that do not use the managed IRQ infrastructure

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 include/linux/sched/isolation.h | 1 +
 kernel/sched/isolation.c        | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index dc3975ff1b2e..7b266fc2a405 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -18,6 +18,7 @@ enum hk_type {
 	HK_TYPE_MANAGED_IRQ,
 	/* Inverse of boot-time nohz_full= or isolcpus=nohz arguments */
 	HK_TYPE_KERNEL_NOISE,
+	HK_TYPE_IO_QUEUE,
 	HK_TYPE_MAX,
 
 	/*
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index ef152d401fe2..3406e3024fd4 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -16,6 +16,7 @@ enum hk_flags {
 	HK_FLAG_DOMAIN		= BIT(HK_TYPE_DOMAIN),
 	HK_FLAG_MANAGED_IRQ	= BIT(HK_TYPE_MANAGED_IRQ),
 	HK_FLAG_KERNEL_NOISE	= BIT(HK_TYPE_KERNEL_NOISE),
+	HK_FLAG_IO_QUEUE	= BIT(HK_TYPE_IO_QUEUE),
 };
 
 DEFINE_STATIC_KEY_FALSE(housekeeping_overridden);
@@ -340,6 +341,12 @@ static int __init housekeeping_isolcpus_setup(char *str)
 			continue;
 		}
 
+		if (!strncmp(str, "io_queue,", 9)) {
+			str += 9;
+			flags |= HK_FLAG_IO_QUEUE;
+			continue;
+		}
+
 		/*
 		 * Skip unknown sub-parameter and validate that it is not
 		 * containing an invalid character.
-- 
2.51.0

