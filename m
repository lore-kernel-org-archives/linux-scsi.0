Received: from CWXP265CU009.outbound.protection.outlook.com (mail-ukwestazon11021116.outbound.protection.outlook.com [52.101.100.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046393195F0;
	Wed, 22 Apr 2026 18:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.100.116
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776883990; cv=fail; b=CXexIJBuINztCtwbttDURmMuS/yPrdflDd8S/0ejlY/EBkwCeWZZH0FUjlEIIaAOlQ6+wHW5+BgaZFRGC7/M8r5yjLNWgSDA/g3Tu2TT/AW7XfEm5FATifKbmhJhzcTxaMP6w7od5gcbgOwgewQOSg0BySx5f9iWcdXveEenfGE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776883990; c=relaxed/simple;
	bh=w3OjNju72jedlA+4pgoJjoX4ALU4LW/9c6an7MEBSSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hZ9t5fxE7NhY9T/ezXStGZ2t7UWBSxF4ohn2mBzQIWAUb0PxfViLueifDoVfxpySX/XB5JL8raxSXPZTBx2OfGuQhHwvQ/h3eHgAvHic5hhgO4qGuCtv3QTfdKbnO0bXU6CyZ2nQGw1tKnxkgcvuf/AkES05AFZdNjatwo7ZNoM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.100.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CczlerTllDpvnYcNFqrc9cMLxLGJWCjxipJtJgCjvrcqkoNSAgQcxHeGTyvhHiDFq4XtdZsGeAqyekas0LGHN41X5vy6hLlMEeDjj+kLmYmVVGg8bRJrbehi2ZVJCPEoW+tTJ6BwD5LWJbaUsoOCPuflzVEe7GDhD6ivGifIfcxEm42FmIzL1kcA8HPbmAEIGzKUle4h3GmUrZV6byfId2Jx+k+KIkI0kjaLdLFy48SSzJxZtfjCvKO0Ggmy/fv2qz6EfteE5RbqmZl0RsfSalPJ3wDCJ9CCsNf9EZ54m5O52rR7zqcCqomzz1iG2cllQjzA2u33tHyHDzIBrndxDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s/5U9kdGiRdLmIQ+/h/F2PaoPIeiZa2T1q64QSW3PZg=;
 b=iKSrISz0RKya8OLrWwHHGSaGM5hFDlnWgTSdMlrNMB30tXmUToVsSs/3Wai9ajH01h0uhbRSsKvVPep967YlIDls5EdkWTu9pATT+kBwLPv1ewV5dkBDuPzdd8j5PB5d5lfza7fhypx+jlO8NOiUxqDNTF9LXhcpneOtof26qT+AG5uYeIAa35pxXiwFDlSGeyF0nyoynxGLtDi7xL51JnEErekZbkObmz/wd0AWMNyh3/hxJMt/ynjcM0UyiHavXymu4tZVOVKzZbYP9s+tmJ513mSG5SaevGLgSlrZNBHFk2YfdCZLIZO/Iq5GO+m3sTKF8s8kNpzwMEsLEAgMow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by LO0P123MB7717.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:407::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.19; Wed, 22 Apr
 2026 18:53:06 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9846.019; Wed, 22 Apr 2026
 18:53:06 +0000
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
	marco.crivellari@suse.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v12 11/13] blk-mq: prevent offlining hk CPUs with associated online isolated CPUs
Date: Wed, 22 Apr 2026 14:52:13 -0400
Message-ID: <20260422185215.100929-12-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260422185215.100929-1-atomlin@atomlin.com>
References: <20260422185215.100929-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P302CA0005.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c2::13) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|LO0P123MB7717:EE_
X-MS-Office365-Filtering-Correlation-Id: ceca2829-f61f-4adb-ff00-08dea0a06403
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	JKKKY/G4rNKqIfBAqao5HilYjLaCAuxmiyhYUBYtD3SKEjSuMKNlWup6ARDkKibLRk2M9yg2+oI/Gzd9TNEjc3H0MOF9n0Nha2ee21gtN+I/ONGOEoCt3WhVNR4eAOcEyvYaREwNE8KrY3iHxID5lv4IGmjigWRc1zBBlOmoX1pBtdzoQ4xHeNJ+Z8pS5XcyMzRUUkfbk25oKF8CLTVFuDUpwB3kfDm7PkwgP8mvoHHRiVgjD+pu10r1ReaG1yZ02j2Gsvwp4bDqPDmcNNICDJo2MyNg5tkPfMMfUhowFgdSbaSBWkuv+dfwAGacvrH6BsrIoVORqWbBrkujNnbxXlpnDGVYH469oCn9JtmYBS/QZzxG0J1FPnkY/60oofjg5IKQ49yavHEpc/dnxMg7YYsT1I3E8Xsm1b5PNlqS3poNTD4hcumg9x7FRs3TcgiCgCacio4q9g9/YyrdDONdO4k02KTp2cqR7AGVABN3UP7NVZVYlnEydhQ0lK/2DfYqq/nW00QtRzYASAk48Y2Xv5wQglru+pA1YZQ27rZIYVWkyr+WBb3EB1JzuJNGFkVjEOOuxCTKjRXS2KTpqlBDmTuXyKp+JwRzpq4r+/8nw7R9A36mTAj/03j1GPzYleqJhjkeqB0CpQF77bqlWqnu65+yTXS1pG4xnxsDZAAhRIUHVIza86d9RrCap4lQZ15U6SDTUFLoUngMDfXmNQWtQ0Issyf2L9BPIUTvnx/2Xc4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fSXucySRDFn3fB1VWHN5b0bdpqBoxLfLR5Bih0fU5MnfroxjXHgfKopSuOyS?=
 =?us-ascii?Q?oFXePqIb3OoSxinDjeCCoQBef3A1uSAttVYnc2CHVp9kiQE6xJB93GnSrr38?=
 =?us-ascii?Q?lE36S1z3pYsOy9XTDc8dpbGLv++wpHMKWa5Y28Pzk/7C1KvQnOzql5Wlj3yH?=
 =?us-ascii?Q?T0s06K2gjcR+85fG22xdptgR8c5Eu6o6TJcHavGtyGpD9ydueZqvfkv6cxH0?=
 =?us-ascii?Q?HAxuO2G2CGqep2g5tUEenWX+hfs7UuNPLiPHiiWpBfbIoTP8bpe/bur1h0tn?=
 =?us-ascii?Q?oZBfCJMlqUIhycC/N2KQG6ctFidYUb99m7t8YostTkMZ3RlT5J24jT4SJYmY?=
 =?us-ascii?Q?eqhH0pbVY2T1B1EAhuN+9PsxfUGswl4gGoLcTn+wcOeQBRn6bbUGCFNecPFA?=
 =?us-ascii?Q?W+IJidgXQGkzQREL3jUH5gxY3uz4BaA/xcOtyTdX8+VAUfpYxrFa08+4nh4t?=
 =?us-ascii?Q?PIO+XVqurDsJEFVlKEg0pWHa6Nx7YZOP6xq41Q4xMVFqh3TAbVDWyDUPSegx?=
 =?us-ascii?Q?EAM8NXRkJQ8mpNQKv5TmgoAgwl7hafkF5kP9bfVFSemQhaEovMUpADwQ5Hju?=
 =?us-ascii?Q?b3RxcT0gF8rfgKWTCGnHZlOz7Vj07yEXRCc9ATAJR6Vu5xPPv6NVcGJwKXY1?=
 =?us-ascii?Q?ECSZjXUQC7BGxOqa9CvtPPPC20SlcHRnoy+Xt0GXhS52ISUwe3ilRrtXBONr?=
 =?us-ascii?Q?7XjD0S0Oc3PW7I1FWNKaeTYPPjmqO4UfrV/rp9YIvDNQGJVHR+SyIr2INnMX?=
 =?us-ascii?Q?DUt7OaNhOMze+NjeKjXRcccvX96VLUDD1tpobTcGigIEHK9HdPYcWTvqSteK?=
 =?us-ascii?Q?hHOIXO+z/WTeu5fOADdhsvLaompcda/h9gzXPOlqmkkCcgyZLtEMzOHU1VXV?=
 =?us-ascii?Q?zUNZWibGIY1ksiuJ9R/0AGK/cirfejWrV3oEzw+ashCRV5/Grmc7OBUsY9P7?=
 =?us-ascii?Q?6bxfevNBehDQE4AM1UFiflCiuhqGcLYzb7x++Rvhpp36/lPjt1qThLXksumL?=
 =?us-ascii?Q?rCxDEZkcTnjZvx39f+b7B9XPejuQOvSzaGdruZIl0Fp+MWswlGd2laldKIfp?=
 =?us-ascii?Q?qpQY/sP9B8zo99FdOZ0L21YWWVTtJUxVAYeDp172pzF0Em87QPCoTPv18/Jp?=
 =?us-ascii?Q?s5/8djaltN6rQXJY4K0YsN5iwm8bnSeB8a8/OiFnoOD9VZGFPzS7HSxFU5Hr?=
 =?us-ascii?Q?OnWCQoPDsc3uukSTqNR7uAfczPkZBtAblmbKqm0wS8L1V7yAY8wxnP3JoP8S?=
 =?us-ascii?Q?RKLpYcq7eBIR1ltv4jSpB9OQjzeUr2iN2Rl2Vrtx8M/XkbdeUScb0TrZHDkN?=
 =?us-ascii?Q?4rDSaABHyRFRO9gIOsfHrVf7Km5GdiPzqAJLG38AWBR+BOCwWIDxPAsQSwlf?=
 =?us-ascii?Q?jDbipuQtotW2fhRe8otE/leKlNX7WI9RuerQL3DK6XM0LKlvKOIWb3Y/MZ50?=
 =?us-ascii?Q?k7y1Nv3imAwUADJGHkSd9ecvh5rND8caOgK0UN/TI63Kf7Qqa8FBZCJpssDU?=
 =?us-ascii?Q?6vxrpLcT/FpUa6X+eAP17yV3yQYV50VwM0938+fxbY8KiYxfXrU68RIT3LHp?=
 =?us-ascii?Q?+DYwsnt8XmXa8dU6RTHTLaEV0pviTxQyU7tGqiIYSFSchPFBOr+sMoZT9TNk?=
 =?us-ascii?Q?kNRgtO9+YXznMD6ML+SII1Xc0uIFm10pQ9Wini4suk/Chy0z+PsxIUD9aceJ?=
 =?us-ascii?Q?aA4hM4OjXyzoaOvJzsTfZkMwu7kfA/dzfnxJNzVNPFs81BkfqGM5HvmHJXXA?=
 =?us-ascii?Q?wATyHCXH8A=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ceca2829-f61f-4adb-ff00-08dea0a06403
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 18:53:06.7308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0JySSHBbOPaK0lU047A2nl9VrwPGHxAiWhvjuE3o7LGkQJI+/BpB7LJYxG9LYBs7JgJtLekByJFa02eAsx4qTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P123MB7717

From: Daniel Wagner <wagi@kernel.org>

When isolcpus=io_queue is enabled and the last housekeeping CPU
for a given hctx goes offline, no CPU would be left to handle I/O.
To prevent I/O stalls, disallow offlining housekeeping CPUs that are
still serving isolated CPUs.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
[atomlin: Removed duplicate paragraph from commit message]
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 block/blk-mq.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 4c5c16cce4f8..4257d5b26641 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3720,6 +3720,43 @@ static bool blk_mq_hctx_has_requests(struct blk_mq_hw_ctx *hctx)
 	return data.has_rq;
 }
 
+static bool blk_mq_hctx_can_offline_hk_cpu(struct blk_mq_hw_ctx *hctx,
+					   unsigned int this_cpu)
+{
+	const struct cpumask *hk_mask = housekeeping_cpumask(HK_TYPE_IO_QUEUE);
+
+	for (int i = 0; i < hctx->nr_ctx; i++) {
+		struct blk_mq_ctx *ctx = hctx->ctxs[i];
+
+		if (ctx->cpu == this_cpu)
+			continue;
+
+		/*
+		 * Check if this context has at least one online
+		 * housekeeping CPU; in this case the hardware context is
+		 * usable.
+		 */
+		if (cpumask_test_cpu(ctx->cpu, hk_mask) &&
+		    cpu_online(ctx->cpu))
+			break;
+
+		/*
+		 * The context doesn't have any online housekeeping CPUs,
+		 * but there might be an online isolated CPU mapped to
+		 * it.
+		 */
+		if (cpu_is_offline(ctx->cpu))
+			continue;
+
+		pr_warn("%s: trying to offline hctx%d but there is still an online isolcpu CPU %d mapped to it\n",
+			hctx->queue->disk->disk_name,
+			hctx->queue_num, ctx->cpu);
+		return false;
+	}
+
+	return true;
+}
+
 static bool blk_mq_hctx_has_online_cpu(struct blk_mq_hw_ctx *hctx,
 		unsigned int this_cpu)
 {
@@ -3752,6 +3789,11 @@ static int blk_mq_hctx_notify_offline(unsigned int cpu, struct hlist_node *node)
 			struct blk_mq_hw_ctx, cpuhp_online);
 	int ret = 0;
 
+	if (housekeeping_enabled(HK_TYPE_IO_QUEUE)) {
+		if (!blk_mq_hctx_can_offline_hk_cpu(hctx, cpu))
+			return -EINVAL;
+	}
+
 	if (!hctx->nr_ctx || blk_mq_hctx_has_online_cpu(hctx, cpu))
 		return 0;
 
-- 
2.51.0

