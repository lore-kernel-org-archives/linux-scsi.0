Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020139.outbound.protection.outlook.com [52.101.196.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA3A3C1402;
	Wed,  1 Apr 2026 22:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.196.139
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775082309; cv=fail; b=IcusJ2Y78xVoe0RnkjzZZAQdTNznHxOM26GZG8ccCU+YbsUi5uXQ4BavFXopjW+M50WWQDM3U74Fl7LwR7D6ukZYHdyIWGuPDMSzmt4dgrL+FBVegCzQOAXvxKFSfQGfoQORQc+afAVSbdr8BGYVppfpK/Cve/t4yziXaQ83kD8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775082309; c=relaxed/simple;
	bh=bYLvWjAfnilKYg3FMVEzPcdzlVT0TDhHJFmz2hWymZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=m3v594CkmsXvaJGvX10KTRP/vID1Lz92Qb6FEDTTIxtAfpgPgoVZd5UcYg5FxSlkJUKtkPLplxKhfAPgSuTSUWYj6Lz97PLwBKOFrY+sfkqcJU1tUBm/B22nWNdSJPw7mBCfvVjQXVzVSWicghjwuSyXHfTaUcaO3dmN7mhJ6/8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.196.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DNsjQ/06P6jCkHutOv4UuLDuM4LOxtZsM5Zf85BlB3MDDytV4hjG1M6BlxusTYu44f+zwljMlAxv5EavAg6Kwz6ZEnGmlp3cwiWxQTOCxtTrXoEDn6qvT1YzC1ni2gStF+KVQrQWbyWyi7y0IZhvg21jeloB9j5oDkrnaUfmRfrwBu55UVKaB+0suG7vuN1qLTPzHQIBTyzRwnRS6lin0XIjF82qFyH0AyTmYfZBu/kuGsGLN7LIUyNWUl63OgT2QQJFiJdaYCTi5gZPYmMPCxcTHhBD+V6MQ2CKV+x+G1aKIArrwhKwyKykAmFwNb7KcZL+cjArF4GTAETwF6ffdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=az4WgduGThZvY6Um24xQWuxzlC406KXWRiasoJJPX+I=;
 b=LqGAEGMr+lUpQ16hemsMaWGz3hketx4yy+JbJ6I63dpC5V+H/JV1ZFyHGSCdnsxj3F6OzIp/8QNeHniM50EqZhnYuIyalGMOHzJa1z5asAdfeFeIC3MXlvmwJOawqyaDOH+Ey8q0wZfVcYJI6+SnQa1HXAQL9OO85gYXri0W5891zXQEL6FJc6KeCo8hss3CS39U8gtoNuY9AK5anKsRzrodatv/8UqqXkF0mPMDLB5eNeQeLFsZrjAMJ/swRoiP6+taU8UZqPyujHzyV1eyBV79Q3BeT+XX04MuAfT3DNuFLgutJR+UkZopKqcWmFUU/yjG84rmR5Su2bqLI/K+IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWLP123MB2964.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:58::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.24; Wed, 1 Apr
 2026 22:23:58 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.016; Wed, 1 Apr 2026
 22:23:58 +0000
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
Subject: [PATCH v10 12/13] genirq/affinity: Restrict managed IRQ affinity to housekeeping CPUs
Date: Wed,  1 Apr 2026 18:23:11 -0400
Message-ID: <20260401222312.772334-13-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260401222312.772334-1-atomlin@atomlin.com>
References: <20260401222312.772334-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0097.namprd04.prod.outlook.com
 (2603:10b6:408:ec::12) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWLP123MB2964:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f70d4f7-67a4-4363-952c-08de903d5e2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	qEmt9hPR4RienPNLGy8NVhRIeIWzeHtFhukMsdPxfxCSz5tmDmc92gg20ISe/8v+8x3qkDSB3WhBF2Y/4RSgXoR8LEw9eFysIIFddZR7IK6kAvEdjuIIr1JfrCxLveFuPWR3mf3xSdU2UjtcZ8wbk1VvWRU9kQfr30nJW+mvwtaUMFsr7prvqzKAi6zx2i0sYWB+4fLtKvgqfScRFz5GuEsy6ZlBPRJpsW5XVGYbLwJRuCEVotR9ApA3PCjpc6RhPtJ+Oz05nF/owvEisSVvz5KbVWaZxeqRBUcb7UUn6y4qHVlp2p2237VohJWOauCOg5ZW3cqVPthRqf/5+fgnpOIfltZCC19pMkK5IUKtHuwO4zrezPLpyWmMgM2PynSm98QSiDeOw7KV0CkOVbXK8jVgSw1Lf1TWA/G2/OS5hFSwPK3dB0HuFeP2uzomP7PEGja8QIWkBOxIoBfBKycOPTZMlw64KJTtLPqaPAPEchWatCKpeZ4LGtjgOTN0bvtLduks0VUde3GwNfcN4pDiTlnocVe93hAxwClOTXtVL1aAbz0iTjKq57RrKXewFZpb7FKLve8fcXNqRaiSBKrRAr5YYy3uOpIyYIKUD8M6PMWy0hDzRnqKK/ok/kluJj0x+8lJhshZK6Gdskax5RP3TkWGkF+z/KIh7CQYJaSAMUHkDTthCIvsMlcoP3WM0MrHWUUiRZ8JhFt+IlS4Gc7NU7wGgHCfIEWx6Q3fqHwTYTc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?B4Fu5YZEy7fPr7y8DSjBuKq/Gt5Nw92uGwiZnyRq1/ELnetJvfiMuK8Oc7YY?=
 =?us-ascii?Q?Jyx8XvdQjoqtTTCkIGooL6eGlLABvIzQcxalhBs88LmZTtZNZQDUKXUWVItq?=
 =?us-ascii?Q?9DIDNE/ZMrXyB5ayesuIbnyHJAcJ5XlZwi3is2vMW2GUgcYBAo9WWI5uHM0Y?=
 =?us-ascii?Q?o++UMg57UIsm/duR2XdbxeE1vKuN3Cy6QKpRg4tcDk2UK+Q20wsUGm3anDVL?=
 =?us-ascii?Q?6buLamk/THHSbaiDIrfSnkpPA4f3vCMKNtI8ixKVo8BJ9P+mjO+OpcEGVaKC?=
 =?us-ascii?Q?infkvjmPIZt1OT5evRWrYE6LcrP2hx4l90HuVFI8fOz/KgYm/NxtsEv5weod?=
 =?us-ascii?Q?3MGMrOTi1RMJIsDlA40Iljt5YWJwXIvMggKW8Nj0mZeeDRog5GqJKZ7ZGNnk?=
 =?us-ascii?Q?cUM/O0suH6byACEqyC0w9T29+8TaA21jdDv9orF7VGLS4cFiEYyKhc6Ab5wS?=
 =?us-ascii?Q?yBdSPFKr0Y+psvQ8v+BMfiI1RL93eXpS1ktj0anP01C7hCNypmhYq/yJyYkp?=
 =?us-ascii?Q?zjfAFxjsSdx9u5iKxT87AGzLt/oJYY3WEK2wb4qv0j8Gq302VnbwTP7fW165?=
 =?us-ascii?Q?5cVh28LBz9u5rtl5M6kktmqD+FahGtBdG8wWBOffv/9v6CtmFE3blN/nb4sV?=
 =?us-ascii?Q?J03mxprI99YeNYVoEaBi4fUOvNg7+21apRE9clQOpD3uKb3K1dwbqqAao91Y?=
 =?us-ascii?Q?KpsG9NQrI/ViN+Sq+eM5a9vhNK5AnIP4IZ5XXtOaP38ONq+1nGVx50D3B7F9?=
 =?us-ascii?Q?U3HmRtjTVlTb87GPJJRJkDS1MgqmAYqmTfPFXajjfKeiTGJV//2hA4XxJG9C?=
 =?us-ascii?Q?G4S7p0yG+vUvCW3VB3tc1miVUNkD3ydIAl//Mr3A7rdpad7bqRz3com5VWhC?=
 =?us-ascii?Q?f2uAgWyaILT/Oezl2qwUIdBchrir0Vm8dWo0qyZSVOOA6dqTsVZxRAhQ6X1n?=
 =?us-ascii?Q?ZEqadHyiz4BuapaGGIgOi+GtWJ+YvEjEG/hew9gNKpdc6m2+IdXX9XKxTgEM?=
 =?us-ascii?Q?RxqloGpDFOrZCiWZ7ytDMuWdsMAP+Gj01LxsOoItVxr8/hc1U3zaMT0QHyb4?=
 =?us-ascii?Q?fqkMrTUWVIc4cHtuYFx8DjTZh3w+j4X9+A/vyMeCUS2x3CHeSxvg+0WHmcKa?=
 =?us-ascii?Q?MuP9HBPIuhbDBu+qv9wfw29zX6Lq6OqqZq4DKD5Npn/O3tHNbVIFU6ERQW4x?=
 =?us-ascii?Q?ItoC43RJnfaQu4aJPThivgY26bHciRupY0JErdgj9T/j4LHiZcvxXhlH3N5v?=
 =?us-ascii?Q?v61fbR7BhdhUcdX5PnCEt+kJaDY9gPRNPOottGtZtEF38xOalUt56Wt7qd45?=
 =?us-ascii?Q?au0bLf9tjNXb0rOjr+sEBfRI37nd303cA9rTWQlmx4xzGrLgXnoRE9jhljeq?=
 =?us-ascii?Q?Rd1/8MetiIRNBvLIaU/bzcz3lWdagbbSqIbUJ4yUGZVQIek/5tWcqPiS+iP4?=
 =?us-ascii?Q?kHMgi35LXkyw5OkYSTOu7KZJgKDJkkROI6mfkX7rmK/ah3nz7a8HOVm4Mr9b?=
 =?us-ascii?Q?XQJ74cg/AKpXSjA8O4U068a3Nn6AaQk0aT7S6so86cM9BsMsgfkhgFwqDPoR?=
 =?us-ascii?Q?X+ZBzQW3MUP/+Ty929YiNNosdBS0ZVYqpBSvAnvjZqBgWMh49gaJjK3ISorI?=
 =?us-ascii?Q?Z3R1cRCQ1yD1FN1SVR6nEZEPSF2WhGH7nzap+MLfzP0isqPLgn3zT9PcfRh0?=
 =?us-ascii?Q?IDGcj9mXSJvTq4vJhvNn0k75bSf7mF4bz7nukcuT5LXddXAC2FgeQ5kH6r/b?=
 =?us-ascii?Q?+zpGxRzYfg=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f70d4f7-67a4-4363-952c-08de903d5e2f
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 22:23:58.2498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /EJdS0cLE1B95k2n+CFl+oks4oGHlnLb8GwjxzWuPCaYfDUEjfhVTlCGPAG9xh2nuIfFYXcovoxMU7N+ah4cDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB2964

At present, the managed interrupt spreading algorithm distributes vectors
across all available CPUs within a given node or system. On systems
employing CPU isolation (e.g., "isolcpus=io_queue"), this behaviour
defeats the primary purpose of isolation by routing hardware interrupts
(such as NVMe completion queues) directly to isolated cores.

Update irq_create_affinity_masks() to respect the housekeeping CPU mask.
Introduce irq_spread_hk_filter() to intersect the natively calculated
affinity mask with the HK_TYPE_IO_QUEUE mask, thereby keeping managed
interrupts off isolated CPUs.

To ensure strict isolation whilst guaranteeing a valid routing destination:

    1.  Fallback mechanism: Should the initial spreading logic assign a
        vector exclusively to isolated CPUs (resulting in an empty
        intersection), the filter safely falls back to the system's
        online housekeeping CPUs.

    2.  Hotplug safety: The fallback utilises data_race(cpu_online_mask)
        instead of allocating a local cpumask snapshot. This circumvents
        CONFIG_CPUMASK_OFFSTACK stack bloat hazards on high-core-count
        systems. Furthermore, it prevents deadlocks with concurrent CPU
        hotplug operations (e.g., during storage driver error recovery)
        by eliminating the need to hold the CPU hotplug read lock.

    3.  Fast-path optimisation: The filtering logic is conditionally
        executed only if housekeeping is enabled, thereby ensuring zero
        overhead for standard configurations.

Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 kernel/irq/affinity.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/kernel/irq/affinity.c b/kernel/irq/affinity.c
index 076a5ef1e306..dd9e7f5fbdec 100644
--- a/kernel/irq/affinity.c
+++ b/kernel/irq/affinity.c
@@ -8,6 +8,24 @@
 #include <linux/slab.h>
 #include <linux/cpu.h>
 #include <linux/group_cpus.h>
+#include <linux/sched/isolation.h>
+
+/**
+ * irq_spread_hk_filter - Restrict an interrupt affinity mask to housekeeping CPUs
+ * @mask:            The interrupt affinity mask to filter (in/out)
+ * @hk_mask:         The system's housekeeping CPU mask
+ *
+ * Intersects @mask with @hk_mask to keep interrupts off isolated CPUs.
+ * If this intersection is empty (meaning all targeted CPUs were isolated),
+ * it falls back to the online housekeeping CPUs to guarantee a valid
+ * routing destination.
+ */
+static void irq_spread_hk_filter(struct cpumask *mask,
+				 const struct cpumask *hk_mask)
+{
+	if (!cpumask_and(mask, mask, hk_mask))
+		cpumask_and(mask, hk_mask, data_race(cpu_online_mask));
+}
 
 static void default_calc_sets(struct irq_affinity *affd, unsigned int affvecs)
 {
@@ -27,6 +45,8 @@ irq_create_affinity_masks(unsigned int nvecs, struct irq_affinity *affd)
 {
 	unsigned int affvecs, curvec, usedvecs, i;
 	struct irq_affinity_desc *masks = NULL;
+	const struct cpumask *hk_mask = housekeeping_cpumask(HK_TYPE_IO_QUEUE);
+	bool hk_enabled = housekeeping_enabled(HK_TYPE_IO_QUEUE);
 
 	/*
 	 * Determine the number of vectors which need interrupt affinities
@@ -83,8 +103,12 @@ irq_create_affinity_masks(unsigned int nvecs, struct irq_affinity *affd)
 			return NULL;
 		}
 
-		for (int j = 0; j < nr_masks; j++)
+		for (int j = 0; j < nr_masks; j++) {
 			cpumask_copy(&masks[curvec + j].mask, &result[j]);
+			if (hk_enabled)
+				irq_spread_hk_filter(&masks[curvec + j].mask,
+						     hk_mask);
+		}
 		kfree(result);
 
 		curvec += nr_masks;
-- 
2.51.0

