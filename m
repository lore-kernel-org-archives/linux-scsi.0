Received: from CWXP265CU009.outbound.protection.outlook.com (mail-ukwestazon11021083.outbound.protection.outlook.com [52.101.100.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD993D75A9;
	Mon, 30 Mar 2026 22:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.100.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774908694; cv=fail; b=hzelalBGW+te8JtoU0MpbO6A3Z3AsUlB2TMrhbE03p+db/cswDhyYWW28SwYZPZG3fHxFzM2NrmfCfYhKqp/X9QXqsa/SAI+GRWDe8H6eOKPp/mW3YN7b9R1C922k8HD/YuauWnmh9tY8zYy0A8+0wjHaDsmk/MmZW3ocKdI9TY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774908694; c=relaxed/simple;
	bh=U3W79bi5dYsroDS3Fs8GXUtdvZCER8T6HS2U+x+MDbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Y6mGl3FdB2nBUjmDSq6WsBJiSIyw90VjzJU4+mIL+pPDz++T8lKoDXhEBcitxEOWdUpmeGrNLqOaUXeeMW/+NdNpKKGAplVVJi6FYNVzqeNYrj6UcWI4c48JV8asvYocLELmDepq+rluStD5P273A0O+GP+DRI8/NgYE/6kS83Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.100.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GLjNOLm59P7PPPGiJUOFLxxeeZXcQ6ViqbFwLmNgGvhuvZwin4YSid4fMsYXjH2S5rsgCVE5lFWFlK1LAv99bHygjo0KWfe8gBKC6nYOHLW5Zze9B8ir8N6ZMPCArXxew66g7Rfzl7f4oVwIfQSu13MT+diIMBjDMAUmxSe5UGyraeG6gd7qLoJnyizJTwhZZtjhhjTRqs0MPeV9lPr4WWgeJ+/AymHNb3CC90DkgmoT0f5cuZkejp7MFc3hLrY9SPmkkB2IljrzMgBBghfNgMR8ikNShaswTZ922I4CIn2UMBX5d31dhO6IPe1jkN3ta9GednK5KhgoA0YkcpiubQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fk8sHS9gyZc49MOAiv7NA/AEJUmj+UIECf/52br9crs=;
 b=g/YWqxXryrDwHlBjTFT4bAqhDdup3i6eQmm4v0P0uKnuX/I4YbYd0Yukz0EW5lKLBUpL+L1NRa481TouBneOwRDSKBQEmZ4vlUe+H2oTw/0ztqthgYJVrkZ9/L0MpyzSIPNcYq5pwpARybhjEe6nI/SPO6VkTUFhlrlbNJR+ICDKPQgqQPMm9Kgqi0nVP/hhBI/m0OiNI87Oyl6ua2G2BTclJBAQDhr24Wp2cS8DWKCbtKve9KSLs3JPCLYY1wK3dvQ7DFfyJAm8nbjVYeSc3seGfcIQ2TI353D98eWfmP9gYv7Ce9KP6WrxJJoFqIft1jzPMZJKA7SmHGEmNe4y3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWLP123MB3841.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:a9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Mon, 30 Mar
 2026 22:11:31 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9745.022; Mon, 30 Mar 2026
 22:11:31 +0000
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
Subject: [PATCH v9 11/13] blk-mq: prevent offlining hk CPUs with associated online isolated CPUs
Date: Mon, 30 Mar 2026 18:10:45 -0400
Message-ID: <20260330221047.630206-12-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260330221047.630206-1-atomlin@atomlin.com>
References: <20260330221047.630206-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN1PR12CA0023.namprd12.prod.outlook.com
 (2603:10b6:408:e1::28) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWLP123MB3841:EE_
X-MS-Office365-Filtering-Correlation-Id: 944e7599-648b-451b-f31c-08de8ea94c01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	vmZZ9CzPU3U9dFEwvx4lIaXSc/mx76H0MYUOwXZjA0GLxG1WiGhvjSiWovLKlmCQobIOop1xwYtUEKrUtCkoIA5ioiQVs/a3TZCjdHftKrOLWqG7SNb+5CMCFdCxfDbj8xEDlIhfO6xpQOjZSCvDo3aR1NsvIEYtPFX2sdioSElRAze8VCbFfNRH6W3ncwscXFT/ND/01aAmhcbFxi9jKXOBXASSGOczL9jPYP7uhxQV3muEULW4KUta4CREJqksmo/kX7PmCjlMyX6bxuGg2Ze1J25Kl06lLB3F6+UU1hP0FnHMX9RmWkqZxxlqvGs6f4hDqF4zqP0PeWASM+p1Nrouoa/3R9qANFBA2j2mIkivz79FadQlL7fpZYb/eJktBzmaTrzzir/y0E/N2lvTHmvsqsXOVpJJSCFf2weaDO2PG4dzU4GJji5v3+NYAAlpcjGhOPsP9C8hAIxgYH+Nj6zucraxhRzDXliytM/UJBGnL4M8EkiEV/FOqkbkZCeKDX7tqzKM8xQ1fVVEDtJckRXOXymDtM8C/nFn1+zpH/ZRX0wSpjFKuPDnpBlKP4w7DelyldcoIXkWbz0pHrtdW+5ANMrBgqiDpZnkKkWu3DtrEdKWO8XvQ9sZQbh2lrsalszA52Rm0fwlNBP9n1DfG2oaMlkBKoPzXW/6zUH4J90hNx1Rriz/4rZ+u87xSzYztHSy4FRzkgGwoJsLh4uqFB8e3+hALLGQHxAyPmwQQ9o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QImR91OvfeTKfacL14YPWUJSVPHil/Nf8RM6cp3PpD1fYoBSSwibIr2iRUWn?=
 =?us-ascii?Q?B+RwhjLViL2TFTNFbfuigi/BHQsDbGUMlwWVhrT3POr0I1opzD2lxPzb3YY5?=
 =?us-ascii?Q?maLWEM2psjbCCcWgzv81JG979wvuxkBTs5I/Os6rjvKx4pC6ZDtgcWVnX7y8?=
 =?us-ascii?Q?npI6BLp7KS9otGduDp+nPKr4fgpCII8RJWc5P90revZMV+syZ+rDl8TWKiK/?=
 =?us-ascii?Q?ek25Xp1Llm2/EpUBugbQwfqQyN0UI61idVLBbbrn4oXqaZ6uSkt/xcyDOtm6?=
 =?us-ascii?Q?vYvY2LizD4WbOccxyrU4LREWqxnhCPT6HHlWco0hHHsTHiDeu0WfunKwh34W?=
 =?us-ascii?Q?SVrj0NsIcdrQoKcClNhOoOd80NrrG+i4wzhsQM1eA8uc+5JsqrczBWC/jPqc?=
 =?us-ascii?Q?ncMq3Bk7bQHFGkJFTBoe/LMGLV2/9Q98yTYpdCXRuNcC1i68Gtk5WOhpOHOu?=
 =?us-ascii?Q?dlI7qjxT8s35FtupNVKxfZ3iUl4KQot5N4rBrzfQx8TukESz+j4LxO3/a8vk?=
 =?us-ascii?Q?vzErZnz7a1K9Qyc9VtlD0+TvNqa1t5q5Me8Liopz1Knc9mZFd4g6ZE9P+RFQ?=
 =?us-ascii?Q?HVvyIktlrdEaFHHZo3mn3GrJpkxcanMNdaTdGpUEME5Blw9ayntoCJJ0eMO6?=
 =?us-ascii?Q?jw9X+6PeKOdRKHXH8Zt9/Hfgh8870mAOzjYXHijJPuvRDjMltvMf855T4LIt?=
 =?us-ascii?Q?gr8lsPia5TrXH+V7NJstx+1bEvpyOfYTuETuaLpDZrLLFIC6mdu6knUgJWsP?=
 =?us-ascii?Q?wS4RcPmUsgmEkJ0YFIxd1It76NN8/pN4r9rKGgc5/wsm8KSJ8TMnjbpiJ95b?=
 =?us-ascii?Q?LdLy6MrUr8oeHPKsi5LZh9UOkyZUVPv5sP8w3rQFZXnCIPA7qWiC76jmbpWb?=
 =?us-ascii?Q?Dgu6BgM5iCdHg8u3soI9nQsSC63jfrD5Q3gMs9BN6hj/c6DjvGKYRY0QJcEA?=
 =?us-ascii?Q?lp4ec8zZ+goAxxQaSE1NLqVxvUkYdnUPD8Q9551dp5buU8JBvbEf871RMU30?=
 =?us-ascii?Q?0ZALYSZ4JIpMoa8XYDI5CJwcFC00G0TVy4/BXg3pcKZ5QrfZkpJszZJyKy5m?=
 =?us-ascii?Q?Vi8grnnC9oD7cROipEfddLP/dBDzjLmiGStEowUTUAjZcpmSP5CXsKiigftS?=
 =?us-ascii?Q?iK5naMossBGiA8kDFgxwdyVBG4GREwZ1/ectFJrZsDZeeqytOCL9I9s/eJlZ?=
 =?us-ascii?Q?I6MJ23d9WqgsiIdnt9I5F4Dk2GEVlo7+BDsp/8aOn6RTnbPcoTd3gf1Xu7Ea?=
 =?us-ascii?Q?PvoZ27kUdvoeQFkmU0iVYZUhh5+VMspDq4IQWUzFvGvcIKnb/efMMUNYi7wm?=
 =?us-ascii?Q?Cutw/XVSDvir4FZ2mHfDw6cl4fJNSnuV7Pl0htRfj1AecNi2UqehbNDTUjfi?=
 =?us-ascii?Q?jD6DxeErKycANGZiebnqT+QI9nriaD2nyXZWhNCd7ZRqygYI3Zwj0S9Gk9Cu?=
 =?us-ascii?Q?DdroW4MkRoEVeZhfsrR1cbx0Gax/54nhA0ZqjThSh4CLEjcMQx25h2Q88Nd5?=
 =?us-ascii?Q?+WXfPqYZZ7XUsshjBZ7abLNDGS+88eUrizg44Lds3bSjoqTbofTBza5xeM4V?=
 =?us-ascii?Q?xJtCV5x0MNgyc3iBtTUDGsov29cf39jWYWN6j3cQ4KlNWOXTVFNitgzl4SIT?=
 =?us-ascii?Q?rp9Um3MJWeYKfiGepO+8p7z//S9TjJR3au2Cc+WzenSKQWIvxbi8Ufw33nFk?=
 =?us-ascii?Q?85Boa6d/FCeGRtH5kaD6wUPWQjvB2jmZau9+z/3PUKeYRx9xA2oAKz43yJQc?=
 =?us-ascii?Q?OkRNZW4ktA=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 944e7599-648b-451b-f31c-08de8ea94c01
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 22:11:31.0722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VUha+2Tk0lruzh1sfvTpDFujVOS3xowAZz6qT9y3LUIsa+wevTFNDJipEzlutQai/c6tRChKGIpm6X0yPt1+uA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB3841

From: Daniel Wagner <wagi@kernel.org>

When isolcpus=io_queue is enabled, and the last housekeeping CPU for a
given hctx goes offline, there would be no CPU left to handle I/O. To
prevent I/O stalls, prevent offlining housekeeping CPUs that are still
serving isolated CPUs.

When isolcpus=io_queue is enabled and the last housekeeping CPU
for a given hctx goes offline, no CPU would be left to handle I/O.
To prevent I/O stalls, disallow offlining housekeeping CPUs that are
still serving isolated CPUs.

Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 block/blk-mq.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 3da2215b2912..8671f2170880 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3699,6 +3699,43 @@ static bool blk_mq_hctx_has_requests(struct blk_mq_hw_ctx *hctx)
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
@@ -3731,6 +3768,11 @@ static int blk_mq_hctx_notify_offline(unsigned int cpu, struct hlist_node *node)
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

