Received: from CWXP265CU008.outbound.protection.outlook.com (mail-ukwestazon11020078.outbound.protection.outlook.com [52.101.195.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588D8395272;
	Mon, 30 Mar 2026 22:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.195.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774908697; cv=fail; b=DmaTy1KGJpJgrhNEAxeBuxPNVQyFQ1NRx0JLxGCGfHHMbeKefTSJ/vCri/wI9EWngHmvJPoGPHGQWNWZJtG12sbxOoZ5RviJW9VlkGHjyDgAzvKR4LaSTC4iw7s/bMaFCz4Xt5oILoaXkyKPltjwmvxieuuvgO2fqBgLJCaYeOo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774908697; c=relaxed/simple;
	bh=bYLvWjAfnilKYg3FMVEzPcdzlVT0TDhHJFmz2hWymZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qw7oLzfoJVB7GEkXgiJhdWp2P3h/6ctyxmRRpVJnWDuea2RaNkQ+Nb14IkxZZkx94oWjDSuND0/ezhg3yyX4KqXAN3jGA/KrmDjkQU2XgiEN9bqH758BIINwxYQTRjSxP225FSq6UIYs8r9ZLRG9pgRf35zZ2T9MbgXqvgGdsHw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.195.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XxSVMCfG10EYuZlDgk4i5BFczGMFOC9gAxpoer9B064TdZxAs/QK+J/7UrE+Pxne/zm4z0p4lvJ2MFTh4KFF60eWMSY6V0L4x67oSKh+5ILpetsGTT6w+Zkp5RxCdwWijBLelEIjS8GSwVW/wvGOF7vsmS8MBr/nbYrBwAqCSZtdSmssWRtLgyFHlMHTk+QRp/i3bRg5fbRqTytHy4a4PpqBMfBBtOYjqmTHDEMzbZ1/e6vgMBvHP7RTFkNabn2+6PD4YPCGF7/kGzrmQvmqag+Ogx61uamv62jom37fOTOEz6vrt7o3LW0yILfNXvYHAYec1yHoBWWXBnG3PA1hlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=az4WgduGThZvY6Um24xQWuxzlC406KXWRiasoJJPX+I=;
 b=PFsPP89iuIeV4ciuhs8Ts5hC7C+z7q33bF7rqdj/+FyqQ4kxw9bpIu7p/bU5UWEd54RhlNT+dUhU16ojE84TCLMS0RwKEnIMPZr1R/Z9INROG8RjPXD7J5bk0OouqcHFQRoArwu7ziXR83MIzMVR8+iEWxkujyhdbAMOHIxSnMOJMv9WJ/txq7ox/GGxmy7IDNu4yaX/gBZKShDipzpvEOgaR8P3RSLyqiyRR5AtstnXxsVgp8va67fCB7SHq8Vs3i1G9qOGipMZ6c6yGV7Q0DjJNSfiGnjqAAh49S4IIBryrlE9sbLHxukbNCVNTPv0zO1PLhcH+IvfW3J3kaK/kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWLP123MB3841.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:a9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Mon, 30 Mar
 2026 22:11:34 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9745.022; Mon, 30 Mar 2026
 22:11:34 +0000
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
Subject: [PATCH v9 12/13] genirq/affinity: Restrict managed IRQ affinity to housekeeping CPUs
Date: Mon, 30 Mar 2026 18:10:46 -0400
Message-ID: <20260330221047.630206-13-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260330221047.630206-1-atomlin@atomlin.com>
References: <20260330221047.630206-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0877.namprd03.prod.outlook.com
 (2603:10b6:408:13c::12) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWLP123MB3841:EE_
X-MS-Office365-Filtering-Correlation-Id: fdbd9b2a-1f11-47dd-63dd-08de8ea94de9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	vap5EtSxdaDbd2QUZiGMqquDA3zdRQ7TQEZZZ1F1VoK6mgfGlrwzo3k6cPu2fmAM0u9PeSZQbe0eCORyKBe8Pyu0bhbI3waRipV59+TAcwFf4Po+3tAfgAMlVs69MFckddRp24kz3U2wg7wTpNK725AZpxYN3wTuiULTFE8nzNpSO/UEXRceouDlp97BVrDJVNIZaZSFgtc5p4833a9BqgWikz2N2r/o9nMa9+uyel4mP4ZHBfoCOIARUmJgZogkPb3w3RSbjrzWXQR370+RBg9rxW/kF5QvfM5eIak4DcpfCfQfatfgTlP/13r+KMv/i041Ke2RuXeQ/2lX34n69VwAubHChgWQT3295aiduswpCuVrtZgFCaf7xMMDV7qOBEI5EPU4lcizbA55IIqog7BkVp/YGcvMh0t/P4Y0+1cu7+vID09dxfLr/KTsyrQT0CddU1tsNOY5/5GAGk1AN6eqM0wWWKeL/C/1pAPX4SmkMk5+Tqb4H0/+sfXuGCYGBtyLEqrgoF1za2rEZq2kLEblghl/O9I9nS7pbkZJQCOy3NqQaFfYmpmnevtPZajkk90OhGt9giu0W7jnhrewaU9vdPRCt/f3G9XcbYq2HwuNfsOgnYhB/3YOC4FP8MYxUzcM3hVs/biSLeScQT3GjadkOpuyVBYtF7L7ytIg2aWn6+6bSrrY+Vhy20ftBPpTgWcAvgtYHEzRW2z176/6Peh26OrInXQST9dS/9ZLONk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aonJGPgcORwr6+DsdPYV8B8MJphkSN6LCUBH/RwzCaDDSGOdWUm9jBFU7V9s?=
 =?us-ascii?Q?OeMjal2swdU6x2nV3znFWcYNpylB74keobZhcmdz86fUf/s8LKSW+MLpZOoZ?=
 =?us-ascii?Q?AGLS7+oCHlMNHbV6FiNTrJPJSoXageIOTRLUdnyOGez9X9YYHAM5GlRg4PDY?=
 =?us-ascii?Q?47Riv+NWejJLBO4l7RwL6+MpyCZUhQ/5P3zr+NPZwNRyuSTXo19uuKW5f0PF?=
 =?us-ascii?Q?8iUAvOMRzRzrAT60JgNyKtMWPHhHqF2iTMfqrZm6WCqT2HNfyOSQxRrFzgmz?=
 =?us-ascii?Q?PEQEORhy1cfUPyHx4v97DBcxw39veR6os4lKbTLk1EMRLSdFskTajO1jK9+0?=
 =?us-ascii?Q?l61ZJBtZCbS60f8FjpyybtZxw0RH0CGZUHcXuwUJJa8jxx74ZxDlGh2ASlV6?=
 =?us-ascii?Q?iIdyphyeQJX7Ipr4z1figM6APyXFnd16AoVN3z5xYnugIk2HWDtzuPu2Qt5d?=
 =?us-ascii?Q?C9knUBK8VuNGAZ9xPr3XgnBmRRr/9ZD6fqXwWbVW5COdq/PZojP4ksG2tmYk?=
 =?us-ascii?Q?yhw7LzKJ+f/4jkcG97tagQZKfH1c0FJba5tkZy27QYRumazCYlRnX+nYOxmr?=
 =?us-ascii?Q?XhamJHsdQLHA5TrgRTLpZ4bLRTWseITrsRTsg+oflsuxVDIM9s9oEMNnhTTI?=
 =?us-ascii?Q?cPRSa1AuUBCsp+yccEjEA68tGTO2mbeqQ/wktkgIA4vyLbwAZGKPksg+hVjf?=
 =?us-ascii?Q?jNVC3zoQL4kY/r4+hrid0WvrdQNejCz1ojg/AstdTO6AA0wVt1vs/Q7t1dyz?=
 =?us-ascii?Q?Qt8DOHXi1aZwjAXg08gNl0+gLu37JRtJzQ4KRqqzBuNw+ZoQ3Wae1yl6iJ2+?=
 =?us-ascii?Q?jO24lFJmwO2WaF7b+xufO4zexK1ZiGyVqXqOmKNVvwaioeD+gPUu7yAvQbck?=
 =?us-ascii?Q?0fd+yVehigI9AbFoe+KD1XI6d1/2A0kYSx0QOF/3SAmG4Fimum6vSJnI/JOd?=
 =?us-ascii?Q?wOY7hNuqpLThDKfRWIteYMyI7uJV+PTd9LElbNie5wHgVd4uZY5dVf+m1Z+A?=
 =?us-ascii?Q?+iRXMD81wYyAVtxtTxmfc2EDlhmBTTRAe5W4hiEo4R11K1UrynJ3yWrFt9T9?=
 =?us-ascii?Q?S3UFPYn/LVLv3YMt2u6CJO01HCS4F9yzkoxawgZ8/LU9ADrZmdW0eQU/Ti0a?=
 =?us-ascii?Q?AotdzZ8Dd4BggqaWX8VCKpvmyH+bVvEhBMSDOxiLxXbcDC3JTrfDMQvijDu4?=
 =?us-ascii?Q?01MRUpTi3Jdef66kxYvHH+XXwpNQ+dmX1yQfoFFTxHBQI96wNVHC8+1uZ7eb?=
 =?us-ascii?Q?jTCbHnBgYAx28RpGgXlKtSTTpBPpe9ibDDk5nRtFwKCVfvP9QDVWTAWk9j5U?=
 =?us-ascii?Q?7I8yiyZbSF47tNQ1xikuk388O6aNGXY7TNsYw+yQ+kA8Z0Rx1Ae/tZufFBWM?=
 =?us-ascii?Q?sGJr+h1NMYkQ1LTv5p0BT8OFpNbcxIqixu1Dkew1KJtF0cB119aaPXFNa51l?=
 =?us-ascii?Q?DLX9Tl0isoWL2YZdFR0Bd+da8ILhazEqYnKw34BdUbdSwU3Yt5YYOJyfbg1g?=
 =?us-ascii?Q?a1dg4hYxl81XbFAvhVFu7N4iF19VtGx3l39NIvnwviM1de74NJwHFKJBIcij?=
 =?us-ascii?Q?of2mkb/S/pu8qDVdUINFux0poj+9v1sXZtcuIfUh7MhNnGiEK7I6ixhfhWQc?=
 =?us-ascii?Q?AAj00JPgsS1d7SxW7WvXrbr0c0tpS9CQ83xo0iTvGXLx+oioeAc9xluz4UWp?=
 =?us-ascii?Q?ELA/da2CfIkVALoAR90eqsdDDRDVFpb/gj/v5W4OlJg6pLxFa+WQGfHWMuVw?=
 =?us-ascii?Q?5YHtYZe9hw=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdbd9b2a-1f11-47dd-63dd-08de8ea94de9
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 22:11:34.2117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xqt6tdqpedFRwgmnzXRGCJgNAgtxV0/7P/of9kFqgpwxxHquR1iOgoU/aaI43/NozIsRcgHo0EOdqchJ6EwDcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB3841

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

