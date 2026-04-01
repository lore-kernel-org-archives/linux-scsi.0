Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020088.outbound.protection.outlook.com [52.101.196.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7423E39C015;
	Wed,  1 Apr 2026 22:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.196.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775082210; cv=fail; b=G6bKmgl7Y/bVQ+hrukreJ58aMQXiAqPGeKaE0CST0ZBDouDIDbK88qaAy+4gcN8T6bgf9HFSA4tPQbUmpHzRXOduos92SvypMNNVwupSMgTGEam0/cZBokAnQoaoTfj32jBlLcmzS6o47h+OhPx+P3RXoojln72IV81xGjgp/NI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775082210; c=relaxed/simple;
	bh=M7mV8dZGTmbcpdj79XaW/GOyzerlyQ0v8JT4bqIrzWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bsiCe4rg0k9ZdwfC8iMZcF19rKfPm+lTDxru7oFj6KoLLM5+4JdCTWjtr8KD2jNChMx7X6T0GzYttADxLQzoBYCzkQ4ajRkwOkt5Eg9cQXF/KLGZ/TmSNkh2oJYy/RlxHEi8L1fPlliS37Y7jFftvm/nynsKa6gTYSy2a2S6OnM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.196.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sV9xAI9eyKGuRa4o++BHhMFAVVNuqpP4bxPQvvIYRLjcszKM6S0sGQBBKrnQKC5XjwhkUgFBd0DSvGem2W/ZU7wEZmc9ozox4KtfVD7NDdSKfpbN4de01fE6TtbFppcrSA+1huAgccrVC9JPIShsXhl2nMOQilh8Kvef8hOeGjzf8hof0ZjRE6dKU8kemksboexGCOyKr9N8hsnbSjTMVypd5vWGn6qDbzcyZFGhIjPMsFoh6yGkVbTWB7LHtPUyRxzQmQhYc0KROdil5jwP4qU9+98slRHsAaVXVR6kJWBqz4A/iL4cKnMjx2wacu9xKC6VAr89/pTStLkoRKZqYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nC8FIfm6JDyJ4Odp5vXIliuFQ2shiQemxPMfxaxFsTM=;
 b=zLeNOUWvdDHQ/qswHgs8t7q8/R2SQoOJlZKaSjiidSDpwZ+wIimhddGkulVFtryM2pbi857+dfQyeEX+gFElNaidJzkm26XQ58X+ndb+QfLnnX3Mer/n3k7dZ1y+Z1bXkDcGZfHosBRfHz/9hpZToIR2/VYyzrT3WO6Opw/RLKPhzXBMJt8le07CV2al97yl6X22djfKdG38d6VdY0RRKlAMv2iRik/8+O0dkAgmZNqt4WReeJywy/KR302ns64drtggAO92D4Zyk+q8cxM0RZDZQpVWMOfPcYQmDj3FA4z0T6yrVUKTDJN6AAwVXIRpAEQ/xoO+nSe2A/GdzeXVRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CW1P123MB7844.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:212::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Wed, 1 Apr
 2026 22:23:25 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.016; Wed, 1 Apr 2026
 22:23:25 +0000
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
Subject: [PATCH v10 03/13] lib/group_cpus: Add group_mask_cpus_evenly()
Date: Wed,  1 Apr 2026 18:23:02 -0400
Message-ID: <20260401222312.772334-4-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260401222312.772334-1-atomlin@atomlin.com>
References: <20260401222312.772334-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0459.namprd03.prod.outlook.com
 (2603:10b6:408:139::14) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CW1P123MB7844:EE_
X-MS-Office365-Filtering-Correlation-Id: d0a63d0d-4fbf-4e9a-f71c-08de903d4ae8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	UfK4wEPnkuYkJ4QVUC+yvQCPosm16lPa0MJ3tgXg3GadGd2jmw36aIWKG9nAlsMVBPYf+QTTEGi7mMPGF4iMZurGxEmUJbAE5+awfh7BfF+gKmNFf1zVpwcBoa3XrVHb8OUmm5DS//jAG7pSNTFadZqDZIE0smDv5bfrrhKOaahIoGLiLyFiOxJgL8yRQkNsjgftn8O6PqO3uFTa2L5t6FH/RkGltQPB0iKKvJW8Za9HPDVoQ7wxp6A/XK4/0XUDXvktKGNyijokuxRHysrW8rR2glSBDhAw0rcNcsNnt8m8woCvTozpEFwoehw4Bty+nVlV8jpnmvTJlHrJC+R5xwuIDh2YHGgpZ0yOb1CiZcdBvOIsGplguxjVdCMjpbd3ge2sdefWle1uhnp1b6B5JvskPb8SccyPgOcc1F9SI44vntOVaa+AdbuI1bouDLpnPRgrcUphaCLgtxs+mxaUoZpdzdiZkFTtXFAyCk71uNf2QP+vh+El8DQ+9iriM+1SDiHiB6u+sPdQWGKV6utUMe7CzPu5JpyCrEbvFhqYcEPM4x+VCuUhB1hM/StGIyxo/NO29da68xGnIqURAyf5RTVUjjsNDKdKUrZBaDTGZw+iu+Rpq6/cY8Y5MdZWrHyDyWK8tpRiGVnItIO7yd5kgRjfAfcCmW7s2ArrwD64RTZoG4+p08u8Aqh4gfUwpU/gLuEgwh+tNhXerZpcew5qgzLuh0DZilfNRP72xao3y2s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?j4JMhhaB3EzAlyZ+HDqw5R2ElJSre2h5BvoLbViCh1H8tW4G+kymvOK6suar?=
 =?us-ascii?Q?yMkHtrLg3L19HIToDFYN98pCv4d6exiVqVSLquHktAaLnJiyk4B04Z/aOQGr?=
 =?us-ascii?Q?ofFTCT5I3myMT6e36KA6Ao+5gVi9ag/aQxkaDtXDOegwizbH5OdkIRV/xGdv?=
 =?us-ascii?Q?sRWQ6FPPLUjslAYulwAgxgpQrMBbFv1EjctA5FqVtYdZctbGK/pTJhvaK/7L?=
 =?us-ascii?Q?87Xd6PM5VyUWQq1XnJPM364AUs3ZRccDr+xzhTqxtlF4w3WrccObc1If8mQK?=
 =?us-ascii?Q?W04kHKzz9LvfO2BrhGCk9EHMGckMmfQD4YrY1fn4GG03q5JV+oz9qpb4Ut4a?=
 =?us-ascii?Q?qAjmgvO1dC/J/aeTuemnmq8+1xWnOnlHbJVimGxEie/y9wY2vpcDQhrMTprz?=
 =?us-ascii?Q?ZXBSK86AKzku1XFIpsrwi6GhuHQggm5wwY2ZNLIsudzcy+9ABkcQ4bVLgA0e?=
 =?us-ascii?Q?oISmShPc29dhgXxOytREYDz21AuqEQj1ZLzoG9+ULGwUMCM/H80OFejLZMZw?=
 =?us-ascii?Q?cYkTvMzcrIQ/wMVVxeK1tNd3hJKh3A5TuCVj4UXDF2ZM6sOuQ1bcqOdl6aE8?=
 =?us-ascii?Q?Z7rHMsmrPaNakrJJGlJ0y5nLJyx5EdEEDF7LLLMoBicRxmJ0D+24L7weHa1W?=
 =?us-ascii?Q?Ei/9lVNmCVslY37WBbBz8hPa2vDhrGDadWRGfVFmfTxrRdyRtVC7gMUwiiXo?=
 =?us-ascii?Q?508/2K/zfK9BWys7qxKtmBr1hyXOQ18SwgCelhDh8MwLx35CCLN44NYhSXpI?=
 =?us-ascii?Q?TYC6uV50hHLDs/jLgOVNXpD275WdcH9Z+UvmrpSnwe0MmiL3DFXDMq+LKp68?=
 =?us-ascii?Q?iTMRBIrVgyUckM8r01LAkJbZkySDKrSEYPR2OO6uKzB+txxKXS/FnpjoH5JD?=
 =?us-ascii?Q?DOQHDjvVueSl+5M+eIGGTDYNTPtcEOyb453G0NguCgm+OLanMsyCkv8SYciP?=
 =?us-ascii?Q?EMNrnZBj2UptwwrH711Yy4812ifcjW5a4RfUtGt84iL0eE/jZvFhVTP4jDN/?=
 =?us-ascii?Q?tlQcrGs4iQ2V48Pa4si+0tt60mvVN8KoRJTJqNor0DFhhUBbv9hnpUJf3iFl?=
 =?us-ascii?Q?Nm/tj8z5nRk7YOfD169+fxydQJ5S/yj2Ev6/h/b4crRoXX2e46J7Nh0yxi7s?=
 =?us-ascii?Q?Yjp2NV9LKHZiiCM226WpoHoF+DiFVRfSf2eDPJ3SJ7LDXBK3h5ck8RM1qpYV?=
 =?us-ascii?Q?WQ/ZkV52lnR/SVekpIHXSOKePiQyqX4n2BSeEhG0eOvqYkG2QMEmVlnVni8z?=
 =?us-ascii?Q?4JwRJvX2VulnKyabRp4htVXSI3sEgzKGaZHalpaFR+eyT+CS0hSN1MBBjDld?=
 =?us-ascii?Q?VivC5LYaeePj79Tg1j0OpFe14earN98TCSkIP3g6f//VpJzTzXj8K9owOWF+?=
 =?us-ascii?Q?1NYdiZRJa1NRk8bch744n/4hlBOBBVW5f4JQ5r0W3FXD+UeRtEDElewRh7Na?=
 =?us-ascii?Q?a8ugQIpw59MQeEGV2ZCyNXHFqLm6P+WRHGe1AwBNZJfYtRDcD8FjUcmwt/m/?=
 =?us-ascii?Q?foJVhJ6Xy1UpibRYnLdqGTgo7x3pYDKTI/szqHacA5rSRkNQNYALwcbppqJD?=
 =?us-ascii?Q?8uogPz0jsAwsdkclZaXemlKaKNer5GAnur1DRI4AwMqkapVyu4nAwkpLnE4q?=
 =?us-ascii?Q?Zv/wKIo25F/32lxgvIJ7wj6aUfO5zdNClKmxndZALp7WoYyITZMjys0V4SyO?=
 =?us-ascii?Q?Le9+xkIkvYfGSn7EHgCBU9BAs2IbCTuuuGlNSI0kq3GbQatUKyK/r/nGppoV?=
 =?us-ascii?Q?rCGcVxp0QA=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0a63d0d-4fbf-4e9a-f71c-08de903d4ae8
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 22:23:25.8313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gPkTbl5RY1NXbDTTgKykyWq0VJ1NW31+bvN9hXlgJLWctEks4bPR6GbIQQ4wfZaEC4xYcIgL3WApZjV6gWCojg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CW1P123MB7844

From: Daniel Wagner <wagi@kernel.org>

group_mask_cpu_evenly() allows the caller to pass in a CPU mask that
should be evenly distributed. This new function is a more generic
version of the existing group_cpus_evenly(), which always distributes
all present CPUs into groups.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
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

