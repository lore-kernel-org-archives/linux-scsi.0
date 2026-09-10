Received: from CWXP265CU009.outbound.protection.outlook.com (mail-ukwestazon11021091.outbound.protection.outlook.com [52.101.100.91])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583D24CCDE7;
	Thu, 10 Sep 2026 16:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.100.91
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789058588; cv=fail; b=saGSMqxqns6eWVmvItCqqehq6aNpxer7fl1/hWolfNYdLMMVJJXaeNmqxvUjEE9DVMStD6x3L9egmN/gZdljJT8gC4uU+ZwEmEsqVzwzIT804gtE2Iu0KyMQF8sbqyzwYDweE0Py9VwpCGupyyof0Eu74mPOShOGW8nTuLvxzfw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789058588; c=relaxed/simple;
	bh=yMtqPbEnMSrWImKlq6ti5AEzALQj2ttavMc++D9wzUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=A8nJMsdm9s633AsgycJ40FHX2uDxOPYo/tCUQcbN4cgmMoitEFcUbc78egEVTHvHI1c2GVOpL1yDs2BCh/maP4DXGcsFXy3ZU5qAxi0135HsUmq306YTiuOhBudpUlqKI/O6ad55fnv2umHNTwj7e9ML9yHsEcTXkFwxyaV3Ra0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.100.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hlqGJktpcFxRDxpDr0hoai7jWvU2S5uz4AOd3/qh/u2QQe/lOMo0RB6k8GFvHFZrLfTzW87oroEzU3cyMk904zYBGEta94QAxhikcd0mZAjcllmlTFQQFjR5FspTENk8UswLmF0ZgWDJaa1JOw7J4Wept07pKUvsampzF1ApScJ8REqauVmGGYJ8MRFmbgk6rFO8yXLOqEnK9pF4Bn37U3/N3liJv9rT0fChdaQ1yyXOXx9/wc0ydJQ1vNJtYi7W3fR0//8nsSKrcCYTmOZtehGjjuhtSb/h2LplqasmuRnWf+jig0c3FmZk3IWs8WF9DO0gzXxfst9uF14RJHTZzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=WkADtvp2firF7V+BRYmlbIpZTRVIYGoiQPIJZZZgxqw=;
 b=gfAVpi9qyWjBSvO046UUZM2RNVK7/trm/80wpjQekeZdNHuB48y6emcw3Q7uB5MEiaV9/X4A5KnHClBy8nxA5qh5rCw9UNhq9dGIxVver7RUxlRwyIrna7Y8MIiHIi6JOujoWicQK9sOQUecapS4srVv0MBqqC/X2mRBMCMn99a7/5gwVpTbOnp9x4viSUnvTsR5OyFToDZdiGpB2fK9uOD/pKwCL4B+ZoUGp3ZMTEFkzxfQl6hWgmN8b0DYZXMbCWN55JSHnKmYHbDH2OaVTobxhdcnLy2K8gunKgwNYGXXVc3G+hR/SvZL92e1Nq5c8IIl33vUga5Y1cmvN1v0yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:183::5)
 by CW1P123MB096022.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:2a3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 16:43:00 +0000
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230]) by CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230%4]) with mapi id 15.21.0406.007; Thu, 10 Sep 2026
 16:43:00 +0000
From: Aaron Tomlin <atomlin@atomlin.com>
To: axboe@kernel.dk,
	tglx@kernel.org,
	aacraid@microsemi.com,
	James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	frederic@kernel.org,
	bigeasy@linutronix.de
Cc: atomlin@atomlin.com,
	ionut.nechita@windriver.com,
	corbet@lwn.net,
	vincent.guittot@linaro.org,
	mingo@redhat.com,
	peterz@infradead.org,
	radu@rendec.net,
	akpm@linux-foundation.org,
	steve@abita.co,
	sean@ashe.io,
	chjohnst@gmail.com,
	neelx@suse.com,
	mproche@gmail.com,
	nick.lange@gmail.com,
	marco.crivellari@suse.com,
	rishil1999@outlook.com,
	linux-doc@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v16 3/9] lib/group_cpus: Add group_mask_cpus_evenly()
Date: Thu, 10 Sep 2026 12:42:31 -0400
Message-ID: <20260910164237.500196-4-atomlin@atomlin.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910164237.500196-1-atomlin@atomlin.com>
References: <20260910164237.500196-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0006.namprd05.prod.outlook.com
 (2603:10b6:5:3b9::11) To CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:183::5)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB6607:EE_|CW1P123MB096022:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cb095c5-58f1-4c65-41dc-08df0f5a9311
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|6133799003|18002099003|22082099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	nS46v/5IwyMYAhQ7vO1XhyjJND6aUGUsvnsZN1Rks+w4lEv/vc5rXus0qsbcEGkxNDv//g2GKW/Q/Ejbg2d5OaJ7kXE+z1x1EJ2OZJj6SYoIRiNR64RILd0yTBciJXs+gXFB7d4E9M5Q52B58yJjPWk/9n6xUrlAJ+Dve1sKcQIP6wdZr0hCl7fU23tHfRb3uOyearSDkpkMlHHinTjPImA2yLDkypeO70X9Xv4bw99LIg7MdWGxU/gmccoHnD5mwnXXS0Mrw+zrvyTlHbbjk0jURUb3lv+zr+kBsO545PBfk0JN4Cx5sqd5Hcy56/EmMGo6mMwi4PqEx7GW57++WfuzOGT5yfBSEU49FRwBJiERY7nNPN4qn6PFaHrwPNxc7ivWnlqZtZMxXVDfFhRKm6DcKuQMZXczQH6UxUpRfWR4UaufwTTLjZWDlw0ZXmExKqccBIhP8IJXoWb7cUeURIP9PQwXPALcFpyiIERwzJJGM/F4Ut/3cQBj35tuVa9qO9pDn6yWBS3AEDiXZA546ZYZGIOtsWD0gu8vn3NOZXkP9flVGu+LmQmLhWW1UhlU7FZZae3qLU779kgkhz+GTIwal++qbRXdf/BKH1TUkz2+Iq5+MQLCLIGZ7Ar9WJzXmn9RxDf+2+SjtDMnXX0RRJlIB/VMALtrTMWSlP0SZ80=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(6133799003)(18002099003)(22082099003)(56012099006)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?g/l8N4M5AK81EKKR7KgqKXN70f/z5jXAT1nB4oB5UT5ErVLJwoIspVFKGznw?=
 =?us-ascii?Q?1ZSdXu10xovjbz19hxsI1nOQcYRaIaMRUwSxHrr+wjoiSV1XFaoCA1cFHphN?=
 =?us-ascii?Q?49M4eRy9FOKUHVjwL+Us66hQ7iGzy7bKC1X/egFIz8Dc/zdYaykhnrRnvJmY?=
 =?us-ascii?Q?QK3HPj/EFTiqn/koZw3mXG5VzSayaYurKTO8TsndQB1xB7gq5SkaL7VkKtGR?=
 =?us-ascii?Q?41yfivn6q4ty2mALDmD7SSF3M+2PU8ckmYlXtUa071NxTbMjDZzaIBN8EeAw?=
 =?us-ascii?Q?NzryyJEeqSsRAmIFOF+QixZN634fynHx/DOC6bHOHypne2w+rYnyFypzTqWT?=
 =?us-ascii?Q?ivPhggdOjkJMNz2y2QbLkaM3nflOzkuiXk9gdcJtxKuoEzJX+nHlei6fnQvC?=
 =?us-ascii?Q?waD81SrkcuhPrKLru3v249QnBumkE6N3KmjTAVjIhR7MNs8Qe9nkJUXMuXR0?=
 =?us-ascii?Q?Mthw4cObxRlgtCf30AC0cKDU5ZM+GpWdXN5NrXy8IV69iutHzmIr3QZmEfPk?=
 =?us-ascii?Q?KOT5X3v/M6YsZQBgg4/3lPcZ9FfQIu2CqkqYchCcA73t4bjDLq2MzI37YY2i?=
 =?us-ascii?Q?ZmYSA+sAxvUfexy0rMVbCA+eb9Ad3Li5ta1LFn4WBjxgcVLUpXe8RdNitKya?=
 =?us-ascii?Q?H9lLVZgHKsYiJLBqJlQi9zPVko/egHwo5+oC8yZuO9y5og88mzmpe+C/NcZP?=
 =?us-ascii?Q?Fgj+b0vnkGLvMo5g+DlpHfpinu2UCd1y33wlFBdD6N2paO5750QHRkc5+hmF?=
 =?us-ascii?Q?Eanx1YpDA794HzwPZFTNpSzC04xBythOICPkfXV5LCYLcQWwBzUJys5Gds+O?=
 =?us-ascii?Q?uNnNsdeobID3BXiVQP+KPxSaOKftw2C8QOz/CCyEv45BSBhK7wJ9BGjdzlAr?=
 =?us-ascii?Q?h6wDO22lzXeAZCLm8X8VxWUMJvl5RWl1XLrXGQtzdPevxobtCx0Tr0WBWOxT?=
 =?us-ascii?Q?EfNvBv3vueP6+Lt7pmE8Fu3Sd1wDzgAYsvRYXG3GF1ilMcA73RoSkqBYNQRQ?=
 =?us-ascii?Q?TqKkNh4RUvTE+hGcG0BhgXJzLmUKaeMKL/+7Yxw3EnFjZBz4govX6FlFsnCc?=
 =?us-ascii?Q?CMOLKVQmVqQxd36YqZ59oWeuVCe/yhiLBwGaqQd9Tm+UxQdA9/4WdsuPfPqm?=
 =?us-ascii?Q?VP0of9bWojHs+oZJXZzH0Xp04IamJe3SCMTSiAVXIf9dyDdpbmrW5XQy32k9?=
 =?us-ascii?Q?A3ka8rJcmp1BjmbxsKRJym+VLmk8QSJElR93pFI6cm95h4A/9ZVXIcPvVjWK?=
 =?us-ascii?Q?RZeih2TuuOZzd9ikoc1U68hIE16G2eMx9Cp9EydMzrB3+5Pl3Je2qgbb7T65?=
 =?us-ascii?Q?9DYsNdDmL+geFQEH0Lui2Nq2gQYO4cCwd9rPwBbVvahslXWvWTUukuYJwwak?=
 =?us-ascii?Q?kGmP0MdOfSF3N1nuBNZME/Uj92E5CZpl7w+/hVPdKsUVzECj3JkKe9gAZPlX?=
 =?us-ascii?Q?U/GRrK2lA+Zk8VzLqRJ9/Z4L3hGUk28B/CkNDPIYWaAEM/hIeBHG/3ad67A5?=
 =?us-ascii?Q?qnafFgZhmMHY1N34UJr6ekXoDCtdaYEOetbrkz7Rb5PXjWbCVJa3SzFbQ25X?=
 =?us-ascii?Q?QRCbu9th6K7tOHXH+No9ie8sFw4DtZj4fIstvml2YwNWshfPbp9YwnYO7d3T?=
 =?us-ascii?Q?Yzv+GIvG/9nvcwWQa+puY/rgtVDF4dkhXLiiZy/fAuh18uSyCpSgvwAK4gK5?=
 =?us-ascii?Q?vgSyNmrTvl4KbIl2xwPwMvKhEuBnWm8okBzi0GGTyixIxNK9wttKWjbPhvdq?=
 =?us-ascii?Q?Ji07ssGKfw=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cb095c5-58f1-4c65-41dc-08df0f5a9311
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 16:43:00.1648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a/QbKFSSCiGElG5nFqESLXDnxBxkHAzYFOgF3wMty6J7hi8Wyp7WcFfG4hg05Xtq13s9S35HUTNHYRF5RCyfdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CW1P123MB096022

From: Daniel Wagner <wagi@kernel.org>

This commit introduces group_mask_cpus_evenly(), which allows callers to
distribute a specific CPU mask evenly across groups. It serves as a bounded
version of group_cpus_evenly().

While group_cpus_evenly() operates on the global cpu_possible_mask,
group_mask_cpus_evenly() confines the distribution strictly within the
boundaries of the caller-provided mask. It preserves the kernel's native
two-stage spreading logic-first prioritising CPUs that are physically
present (cpu_present_mask) to prevent I/O starvation, and then distributing
any remaining vectors to non-present CPUs to maintain hotplug safety.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Co-developed-by: Aaron Tomlin <atomlin@atomlin.com>
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 include/linux/group_cpus.h |   3 +
 lib/group_cpus.c           | 110 +++++++++++++++++++++++++++++++++++++
 2 files changed, 113 insertions(+)

diff --git a/include/linux/group_cpus.h b/include/linux/group_cpus.h
index 9d4e5ab6c314..defab4123a82 100644
--- a/include/linux/group_cpus.h
+++ b/include/linux/group_cpus.h
@@ -10,5 +10,8 @@
 #include <linux/cpu.h>
 
 struct cpumask *group_cpus_evenly(unsigned int numgrps, unsigned int *nummasks);
+struct cpumask *group_mask_cpus_evenly(unsigned int numgrps,
+				       const struct cpumask *mask,
+				       unsigned int *nummasks);
 
 #endif
diff --git a/lib/group_cpus.c b/lib/group_cpus.c
index b8d54398f88a..75bd082e00bf 100644
--- a/lib/group_cpus.c
+++ b/lib/group_cpus.c
@@ -563,3 +563,113 @@ struct cpumask *group_cpus_evenly(unsigned int numgrps, unsigned int *nummasks)
 	return masks;
 }
 EXPORT_SYMBOL_GPL(group_cpus_evenly);
+
+/**
+ * group_mask_cpus_evenly - Group all CPUs evenly per NUMA/CPU locality
+ * @numgrps: number of cpumasks to create
+ * @mask: CPUs to consider for the grouping
+ * @nummasks: number of initialized cpumasks
+ *
+ * Return: cpumask array if successful, NULL otherwise. Only the CPUs
+ * marked in the mask will be considered for the grouping. And each
+ * element includes CPUs assigned to this group. nummasks contains the
+ * number of initialized masks which can be less than numgrps.
+ *
+ * Try to put close CPUs from viewpoint of CPU and NUMA locality into
+ * the same group.
+ *
+ * We guarantee in the resulting grouping that all CPUs specified in the
+ * provided mask are covered, and no same CPU is assigned to multiple
+ * groups.
+ */
+struct cpumask *group_mask_cpus_evenly(unsigned int numgrps,
+				       const struct cpumask *mask,
+				       unsigned int *nummasks)
+{
+	unsigned int curgrp = 0, nr_present = 0, nr_others = 0;
+	cpumask_var_t *node_to_cpumask;
+	cpumask_var_t nmsk, local_mask, npresmsk;
+	int ret = -ENOMEM;
+	struct cpumask *masks = NULL;
+
+	if (numgrps == 0)
+		return NULL;
+
+	if (!zalloc_cpumask_var(&nmsk, GFP_KERNEL))
+		return NULL;
+
+	if (!zalloc_cpumask_var(&local_mask, GFP_KERNEL))
+		goto fail_nmsk;
+
+	if (!zalloc_cpumask_var(&npresmsk, GFP_KERNEL))
+		goto fail_local_mask;
+
+	node_to_cpumask = alloc_node_to_cpumask();
+	if (!node_to_cpumask)
+		goto fail_npresmsk;
+
+	masks = kzalloc_objs(*masks, numgrps);
+	if (!masks)
+		goto fail_node_to_cpumask;
+
+	build_node_to_cpumask(node_to_cpumask);
+
+	/*
+	 * Create a stable snapshot of the mask. The grouping algorithm
+	 * requires the CPU count to remain constant across its multiple
+	 * passes. This prevents allocation failures if the caller passes a
+	 * dynamic mask (e.g., cpu_online_mask) that changes concurrently.
+	 */
+	cpumask_copy(local_mask, mask);
+
+	/*
+	 * Grouping present CPUs first. We intersect the provided mask with
+	 * cpu_present_mask to ensure that we prioritise physically
+	 * available CPUs for the initial distribution.
+	 */
+	cpumask_and(npresmsk, local_mask, cpu_present_mask);
+	ret = __group_cpus_evenly(curgrp, numgrps, node_to_cpumask,
+				  npresmsk, nmsk, masks);
+	if (ret < 0)
+		goto fail_node_to_cpumask;
+	nr_present = ret;
+
+	/*
+	 * Allocate non-present CPUs starting from the next group to be
+	 * handled. If the grouping of present CPUs already exhausted the
+	 * group space, assign the non-present CPUs to the already
+	 * allocated out groups.
+	 */
+	if (nr_present >= numgrps)
+		curgrp = 0;
+	else
+		curgrp = nr_present;
+	cpumask_andnot(npresmsk, local_mask, npresmsk);
+	ret = __group_cpus_evenly(curgrp, numgrps, node_to_cpumask,
+				  npresmsk, nmsk, masks);
+	if (ret >= 0)
+		nr_others = ret;
+
+fail_node_to_cpumask:
+	free_node_to_cpumask(node_to_cpumask);
+
+fail_npresmsk:
+	free_cpumask_var(npresmsk);
+
+fail_local_mask:
+	free_cpumask_var(local_mask);
+
+fail_nmsk:
+	free_cpumask_var(nmsk);
+	if (ret < 0) {
+		kfree(masks);
+		return NULL;
+	}
+	*nummasks = min(nr_present + nr_others, numgrps);
+	if (*nummasks == 0) {
+		kfree(masks);
+		return NULL;
+	}
+	return masks;
+}
+EXPORT_SYMBOL_GPL(group_mask_cpus_evenly);
-- 
2.55.0

