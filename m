Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022078.outbound.protection.outlook.com [52.101.96.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729CB3A9610;
	Mon, 30 Mar 2026 22:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.96.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774908669; cv=fail; b=Ww1OuDExbSrMjkR62KToDkfgbCPhnUQqgyCpIIHs6ly/N7AtJ/7eOoiSBBZaB8nUpmdUR7ui9H7Y42wq354COI7s76eNaoBrokPLgHWq9BRhtZZvuDmxGCIAzENiDmRW1fRXwCqnAylVfEp3+02Z8Uy5J/fVe4twuHIK0Grt3x0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774908669; c=relaxed/simple;
	bh=gEli3h7xLwBYK4BV605YLRgFHp68wbwvowO0lcUTbzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=t3Y1jUW9wtOF0Q9Dd3kyB0WyfqJ4NL3rC0FupguH4pal4c44TkWOvFeUtPwfzPglsdGhOybbpcS2/L4iNlkNI832o2+cPpuo7X01rov9Hw/Qv40yPMBwXfkzYn05w593qz2jhvDIS9QvNHoLneF+tgCfUMdb6x363mmyEM+6AUQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.96.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PD+Irqay+zsmp46T/2xyClahNwnohhIcK0cEK7Wq9wHApE3pPdBrjlnsau3RViR6Zc/G0zRjCewsXRic0XHvXZS26/Gdx4D6JiXBpCeVNLhg69wcePwAPndML95Mn+GcDlAuu6hIwqzk6EUlf+EAau1QYgf5GR/A5Q6CnBM2ZfMbP7L042XdaLibKq6Vi6mMDiXCSAzWyL08dflcHN6+CG9vH2DqfMaBGLHWhHUnefIevbGBdxKOsXZRv4AAuIGHJJfm4E33wSl7MpJWF7fMzhd3Buse7sa/EFPeagFu02nd4Rt/nlIGaK+6TY/oJhKzP2cfSL457ZmUVk+aTZCb6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7yf0o5+RBpJGxLIuK8K3JE5n1bV+f6SGDbZC2gVdk9c=;
 b=eSOZlz5b6ZsCPZ0u25AyByOJaLAY0hJckf2xzB//Mbslz529IVASxgbZ0mFaoochwKB4XdlBqZxEesYXoRj7O951AyWXIOgQRD8mUbl2FLT07w2iiezx9BFNBwnnHqs3dF6smFH4tiogqef7iYetiEW38n3k4PE7t/jcbPcQaR+iAeDpXAMTb2OoHElkobm2e+Mf+kMlCqx3F3Mmx0C931s4i2ELJm6uonWYbAbcyD7rSL5iJa0xqKQgCMjgLvDzV30nNIas78bsPKePLuy4VUqzNabv0M/6C6xwn+iM5HK5i4AIaqTYKn0XMz9XdQX0KHepPXKoRtKd89miTtl7FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWLP123MB6512.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:186::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Mon, 30 Mar
 2026 22:11:04 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9745.022; Mon, 30 Mar 2026
 22:11:04 +0000
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
Subject: [PATCH v9 03/13] lib/group_cpus: Add group_mask_cpus_evenly()
Date: Mon, 30 Mar 2026 18:10:37 -0400
Message-ID: <20260330221047.630206-4-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260330221047.630206-1-atomlin@atomlin.com>
References: <20260330221047.630206-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0577.namprd03.prod.outlook.com
 (2603:10b6:408:10d::12) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWLP123MB6512:EE_
X-MS-Office365-Filtering-Correlation-Id: 531327da-880c-4388-3936-08de8ea93ac4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	lfECL8cnOV3MCVPvP2CdesQziLTdairCRfQvoYMf2mGKXqIY04tiXcMBL9OjXxzvZRAH3Qq8c+4meENbTINkgfY9+52mYrjjW0btOpQLx3h8li7Xwxu7sFsVkrQCumacW9p7qTAmenmTzWa4wZENw1RF0JAoNznF0ooige5P8XwIxWaNTybfAyO5ynfTRhp2zXB8/NHPcaPDyn9nHFtuQ23OoxOId3sfgWYBmCS4HZdSyFqpU2Q+OZU/5UR1l9wydiUv22b/4dPs2AxMaRezv+X95+LUlqV4W66gImUC2dQB+Q203rCKHwVLxZgDU2T32bhfQaXnU4jYGTjNFW1bN8Eio/+IciOQFoV5UYI+QaJ70Fe1coAhYgvXmed42Ll2ZofKUVXTqa8cK26Fwyk9Ok/oh5sOG2RWs/pt8AfShMbKCwWFJklhD5he1jhLnY2uCUwCwNV690Te88SnHbP83JKzDQDSGxk71oW3fJ/AhCjoIHenpcfTorW1wsnkYcMUzZtjJUBqfPhtXuVaaI38G5yj7W4lA0iS1WbgSA/8BpPNkAnk/4xFdeorKZC7M+W3341bxj7AEjL/2FDlP6Flcg8F/rGL1nG5GpL+OeCSvt9a6GlXmEqre5QuuFoFHPRZgmjOmNVqwx+/0brz4RUZbtT5zVeGOGY6O++c0et4A4uSwRwcGV5GHT0rwMfO4ydIn0okTJrC5tSAmyBG2XIE13JQPoKsXOcA0GD4JXuAsww=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BFYVV8dZ3rYzSRomiGRrdqsZv6PBKFgiC9FFpAEtGWG5BBgkS1cAwyhTxgLY?=
 =?us-ascii?Q?DoySTa2S/dVsQhi0JmB4OAFquL5FiZfFZsEmGNHI0hBHNVw2Cxv+Q4ZnzY0m?=
 =?us-ascii?Q?dHCefOwj7upjikD7Zt/iZ0tbFDur4SQFHAq3faDIOTCAsQgjNBW7C693XNmt?=
 =?us-ascii?Q?w1tgpnDh+lYkRt2atSvQET1lbN/Vy+YTQ63vblQt4jJiPDNxK5HhBDLO8qJq?=
 =?us-ascii?Q?BPGg1GmDj/nSxIjAmLklxVfIyhfXc7sP+M92LjNmq3nctItlMznLBMHoaFLp?=
 =?us-ascii?Q?XwzfUd1/2sZdDPIGc5kaX2qNFxu9eX8cnMvI4MLFgTrjHLqueJybsOJjuKZa?=
 =?us-ascii?Q?Ll928WGvGDKfb0FwAJhmfOkVemWPFSXiWXLPHOVahxMjJthe6U5NqBWv+GiV?=
 =?us-ascii?Q?KQojX8jAC2jVuLkb0w+AZs8bldtAlFmk3QQinKDqddbN2RiqXH+HBeYDwSzt?=
 =?us-ascii?Q?t9xr88HYqCZQWvllBWzJm5rkRZpMIDonDI1DGBNVQVARIm+5LOL7ERztFJdz?=
 =?us-ascii?Q?V3h+VdcGHph/M6hX9PmrUBnplyBA+1UWXbpzDUx9ofh/Rk41HD5IhkPizwjt?=
 =?us-ascii?Q?ozc92bOqkU+6kD3WBaxrQS/39A0I6GkD7bduVl/fBZ1FtuijKZGg31KFQPJI?=
 =?us-ascii?Q?jSybiuRhQrMqlDiZUXSjMien7qseUF5IrM8g+Ky1rP9fTvNIe6Dps6KGEw6h?=
 =?us-ascii?Q?zc8yEiX0ITIOB/Gdg1jdBaafIxBr4oTkHnnbBoaANVGPesELzT73vmsf5I7t?=
 =?us-ascii?Q?TZQ8Oy4HNR1G+z2UXK2W/5pWusnkguw86bXgRbxOuakq033IPOIJ6feY2M4U?=
 =?us-ascii?Q?hGKW29i9bKwY+AvBRer+1Ldokrwzx6iYPjCiM1hfZd50WnHbltjjgwPGZ+0z?=
 =?us-ascii?Q?SJSdCNWarrrxHXeHF/jxGne7m4a7zuVklSTirMtN+bzDUbzYWbqAxzdRZRX8?=
 =?us-ascii?Q?Pw0vTsmhQR7bxen5SsQYRIWKAdn7H8u6taBKIdQkxorhsOUOKjoyZF7peBi/?=
 =?us-ascii?Q?ag1xO3sR7tib3TE2fzoKBje9whDOjNGN4RnYfzbEyXz5jdXzlB9FUE0U5USk?=
 =?us-ascii?Q?n+z0GjaaQQl7vJWLF4ROuY5OolbzMekYswEnnB+HwZnU7aeV/Bn/+2FeXVFI?=
 =?us-ascii?Q?E/mkUW3vMnZFyXIQ7duQMlqaMLCZhv6xrVGHaQ42cnf6Ac67J04IVshnsw7f?=
 =?us-ascii?Q?QxsF6TWiwf0perLQLFIFSGzKMHptbbFlRAha4516nAWQMPIqSib55XwbIqRQ?=
 =?us-ascii?Q?H57FOSk9ercisxlpCRzCErD8qJtWVi5sqtG10BpySDWWsk/6r02t7UEbMIKS?=
 =?us-ascii?Q?SLbYcquwDLmW3LFwEi3PGRax8erTJKe4ZY1o1qAoSGdzAb94UJnPxpjy8bbV?=
 =?us-ascii?Q?3FGCyP3a1PpbbT9BtlHrhd7x0ZVGsABAX8uYoHkXZZfyu0WIVGx/2AJZMhPq?=
 =?us-ascii?Q?Hf/iDNesHl5cXfqLPNEbPPVqMUa2VeWylvTwXQhXue5dd5bXve341F/7Aj5J?=
 =?us-ascii?Q?RPC2AYTotdgMLujFdqGWJkopQK5oPmuFzEEDqFFrAf60m3cJRNetOBvlEwTc?=
 =?us-ascii?Q?l9/xWywzmzvDZbTdIXQqMH2VXYxLLpglM/dddM4wddgn+CTs4cmgzU7zDW2T?=
 =?us-ascii?Q?X3d7MmqbB+RmFGM/DTmuVryjrLdTkhOl9C6rkH1GAFDcLAhb2LHaNmdA1pQx?=
 =?us-ascii?Q?XB658I3/w3/7VrFhprnohwD9pRHYi8hlX/Zlzp1udxvU79zmXgcKHyQCVv2d?=
 =?us-ascii?Q?9fU+NwNFXg=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 531327da-880c-4388-3936-08de8ea93ac4
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 22:11:02.1598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N3JnrM+YqQuo2rW8gYjgTLF4ZhhCIsFQoH2vurRq8LdR/imposRfv5zoXCLNSPHoQRob1movUUvJqjANEam3RQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB6512

From: Daniel Wagner <wagi@kernel.org>

group_mask_cpu_evenly() allows the caller to pass in a CPU mask that
should be evenly distributed. This new function is a more generic
version of the existing group_cpus_evenly(), which always distributes
all present CPUs into groups.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 include/linux/group_cpus.h |  3 ++
 lib/group_cpus.c           | 59 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+)

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
index b8d54398f88a..d3e9a20250ff 100644
--- a/lib/group_cpus.c
+++ b/lib/group_cpus.c
@@ -8,6 +8,7 @@
 #include <linux/cpu.h>
 #include <linux/sort.h>
 #include <linux/group_cpus.h>
+#include <linux/sched/isolation.h>
 
 static void grp_spread_init_one(struct cpumask *irqmsk, struct cpumask *nmsk,
 				unsigned int cpus_per_grp)
@@ -563,3 +564,61 @@ struct cpumask *group_cpus_evenly(unsigned int numgrps, unsigned int *nummasks)
 	return masks;
 }
 EXPORT_SYMBOL_GPL(group_cpus_evenly);
+
+/**
+ * group_mask_cpus_evenly - Group all CPUs evenly per NUMA/CPU locality
+ * @numgrps: number of cpumasks to create
+ * @mask: CPUs to consider for the grouping
+ * @nummasks: number of initialized cpusmasks
+ *
+ * Return: cpumask array if successful, NULL otherwise. Only the CPUs
+ * marked in the mask will be considered for the grouping. And each
+ * element includes CPUs assigned to this group. nummasks contains the
+ * number of initialized masks which can be less than numgrps. cpu_mask
+ *
+ * Try to put close CPUs from viewpoint of CPU and NUMA locality into
+ * same group, and run two-stage grouping:
+ *	1) allocate present CPUs on these groups evenly first
+ *	2) allocate other possible CPUs on these groups evenly
+ *
+ * We guarantee in the resulted grouping that all CPUs are covered, and
+ * no same CPU is assigned to multiple groups
+ */
+struct cpumask *group_mask_cpus_evenly(unsigned int numgrps,
+				       const struct cpumask *mask,
+				       unsigned int *nummasks)
+{
+	cpumask_var_t *node_to_cpumask;
+	cpumask_var_t nmsk;
+	int ret = -ENOMEM;
+	struct cpumask *masks = NULL;
+
+	if (!zalloc_cpumask_var(&nmsk, GFP_KERNEL))
+		return NULL;
+
+	node_to_cpumask = alloc_node_to_cpumask();
+	if (!node_to_cpumask)
+		goto fail_nmsk;
+
+	masks = kcalloc(numgrps, sizeof(*masks), GFP_KERNEL);
+	if (!masks)
+		goto fail_node_to_cpumask;
+
+	build_node_to_cpumask(node_to_cpumask);
+
+	ret = __group_cpus_evenly(0, numgrps, node_to_cpumask, mask, nmsk,
+				  masks);
+
+fail_node_to_cpumask:
+	free_node_to_cpumask(node_to_cpumask);
+
+fail_nmsk:
+	free_cpumask_var(nmsk);
+	if (ret < 0) {
+		kfree(masks);
+		return NULL;
+	}
+	*nummasks = ret;
+	return masks;
+}
+EXPORT_SYMBOL_GPL(group_mask_cpus_evenly);
-- 
2.51.0

