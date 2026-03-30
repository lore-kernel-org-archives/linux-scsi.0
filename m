Received: from CWXP265CU008.outbound.protection.outlook.com (mail-ukwestazon11020084.outbound.protection.outlook.com [52.101.195.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B60C3A9018;
	Mon, 30 Mar 2026 22:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.195.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774908688; cv=fail; b=fZlqOwrIrLfizP1KYIKkv3EkWN/kqDdjpoEatC5LXc47oYK0ChfJASxma5wwRKAYboONfa10KoHscFplSx/AKqT8qe2vskXBy4FbhTO07ERqXgqq4lRGuj2UbORvG7K8hG/9yZ/Ezf/leHP7+GCvhjVGUsDIpGXjDXsAjr8I+zM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774908688; c=relaxed/simple;
	bh=lLevRQEArZXmbuY7Nc5r+Co0TZfifSsSOKkVBpaOkqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QdAafbmiWEl46WFDn7uR/6P+VkqwVbdOmvD4NdzREAXSKgCv7yYRpxcLb4LPPNdJP8OSCDxeA2TrGFLyt8jcf7wurGSh25Wr2vB+rKgZIKW3ubvnKaQGbc2KxF9vCBBrpmJ0hszqYMtInZkH7m0VG/Xir2mNkp511+cz5Kreqvs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.195.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gu8QtHUlRmuU66jmLKEfiJHB/ZdgeL+gTNtpeWwpDtvkOZbJZkqMkyo5eYsxmIjqc6FWu6N61YOvJsFkhug9eVhT8Aq7qHd1f62Ey7PLbz97NeRhdu3exOguzKduTwNS5OXDe5/b0x8rjBW95zbj0ofJ48vuFxbNTnXnME97q+2RRy5y4sj6h18ia/gdWzuxvq0PlZiV8Wj9ju/s5/bUACg7sXgKC/QqJiuzfh4A+lzVIBJTBoagbR08Y8qGImrey+Jmur/b8pPHAEwOsEoSZJSg0gY8cWGUyNBBBiD4Vbnft22huG5YnzcL5s9urefAe7jz5x3sQhQgHdDPZ886vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G9IKzeaSAuxyJT/WzibXroDWpuaOj0lyTepP0F6uDcs=;
 b=rlMi4z/K2MCFURoMJk2wMLiMJgrdlEceHoVyzORCsuq9OL7pBsVtpZQRxSDtxh/RyUZOcZWsbsLKNYeeV2IlMxbkhMj0tosfhMg/rxq5ewSNp/6e5x+p4rNMP10JQCTjsL91XXZa6MlccMKRiQ6vZPJozK4rg4fBiMtBlsYC7rIdu51tOcmCh4CR6rfSZ9nFYnTFoUno7NmgWA9dqr+KQDfI7fzd50M9cVv62wgri+iPKrF/Mo1n0RDstyLs0WNUYZ2qfwUDtf7Us8ZTx91r3wIzqQuoDEczNS873LFi4v0rSzBR1hiMn126xVl/dd9zwwnh4B1kuX04Qosm9XXdQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWLP123MB3841.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:a9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Mon, 30 Mar
 2026 22:11:24 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9745.022; Mon, 30 Mar 2026
 22:11:23 +0000
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
Subject: [PATCH v9 09/13] isolation: Introduce io_queue isolcpus type
Date: Mon, 30 Mar 2026 18:10:43 -0400
Message-ID: <20260330221047.630206-10-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260330221047.630206-1-atomlin@atomlin.com>
References: <20260330221047.630206-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0957.namprd03.prod.outlook.com
 (2603:10b6:408:108::32) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWLP123MB3841:EE_
X-MS-Office365-Filtering-Correlation-Id: 740c172f-de8f-4b31-5dc2-08de8ea947bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	OatHIHss0l8fILI8X4WrvvhsnqVd4eyhTbf+p4/eNyTMtOItwdfbSH3nFrgahgGGA6093dx/TOfG73QH23ov8B2c/4CguhUIzmxAs620Q2nHgvx+uEk9FE1Ggvz4DMQFyjH1POp2nN6L1eHUWQrg3k5p9kOKUrnp59qLdrrhEUXFUEgDBVm8+u677+U+K63OhTySjQoKwTW5+KvJ0mLsBaenlHzSXwH6UbFFx/++7N/Cj9TFijT5crba//yErg7aEczW+Q1XIXTImQ3NeAcDofF2Uw0fGDXbLozKMZOam0hCKQp+9gqED7IGGi0OPNfwMYanVQil2WaK89DVa2Xf1vVKfMifOQiZIBr5cUjIAaOaQm73ZUzLjYmF7CjPkZau5gLDNJlZZNnEHk+oHW7nMHSFEJQMPED6YOL3N5NU2/jUET/U/i7NF/k22adVqd4uhGrDcSE+szNdDTX7GTQR7NgwEMnUlSj8Xr6JPqfnhFz+ekIXgACvTBkTDF3Bk0WcRUAowbJ7U1MKlNyjwHmt7vtgYEhg6cUlX7gLy0hy3snzbd+vtuzp0O8DY3sOC2pCN/KxVbvXP6bCLCUC4an+H2NVjrOeqpBCILHviO66LaM2yvFViGd7zo4MR81NqgP7xSHgI9Lh9B88wDmbsrAQ5aAmFo8OV2hUzaHeLYFNfikBA/sVCnPi/Lpt/qo8cK/GfqU+uVlF3skrgIM4SoCAYEDgxpkZ95LdaXI8ez+Z7l0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bmWcpKSpo71wOYvK782WizJObiRZDTdypJZx3Hp9Lvcvflbs5heuXtaqZ23A?=
 =?us-ascii?Q?EXa3qqvIXamvosjjzMsu1CdXX1ntpasWxTpIlwUBTDZHoLr505IT0xw0YdJi?=
 =?us-ascii?Q?BL7oZRoMoB2YhU9AjoK6Gl1SPHbnxpQd0yTC8zhq2zE34MONOWpA7/iJojJF?=
 =?us-ascii?Q?ZdJfZ54+SOfXpNpNbs1/IMmWDFIWcTs+w1/9ogJ1E1VNg+hErI54mx2NWjxF?=
 =?us-ascii?Q?nvBGb6Tnkme3cHCv0pHFzFox5dJYRzlI6DpJbMI3LCQRnWi+ed+GkVycPZMg?=
 =?us-ascii?Q?/f9H0jJ/OEnMJG6xgHFBesON5CXmqpAPcOPmlZ/sQUmD387t9pOJVF/VKvcR?=
 =?us-ascii?Q?K+jODPk6efF+qn0DFJAScBYym7r/wb9gQUxccpxHDSle8ucSUseWdoeSQwpK?=
 =?us-ascii?Q?IOxm+e4ljKZVbY0JIJs/YPfOG/vYnrmR+XwEKIyj7hKEmfTypG4TWOcVqiel?=
 =?us-ascii?Q?OtgRFJXV2xovShykXGId6uB+1j9eQt9yn1IgCdhAnVn0SXVFmlNmbyvIRyu6?=
 =?us-ascii?Q?ccS0yjMijcy4i3cxhplhiasMmL+80Hw/lXya1hfHMUhkxYVFOfSfK3K9T5RD?=
 =?us-ascii?Q?Jg58D+jUwILpZAXZT8TsTgv4M3iLnFfcC5SO3u9NNbfYm5nAcvZDgkP8qWPy?=
 =?us-ascii?Q?VbzzIArd4WSTDxFWfYpucwFDGe8ksg4v0oiuOQyv+l+vdby14voXenN2neIn?=
 =?us-ascii?Q?/kxhVKMlwJfeAZIoBfufIwVZ+hiPybRp61WakE1UaqGssFUk37jQK+Ya14OT?=
 =?us-ascii?Q?hqQw0Lr8ujP+i7yiZfwadfZBLi7xjAsuHQ3On7xDIbBR5y7BIuK6MPfofSk8?=
 =?us-ascii?Q?WjvjgTxDWkqJFrh/WVtozFSU8hRJE+sjgGh3GKkSNXsVxgeQVxDmqDghzNYW?=
 =?us-ascii?Q?ssujQzUoy3XNeNxQe3RNMiaN6vfuEA/B6hgGnCedc1sVMKQlIJjknib7ThmX?=
 =?us-ascii?Q?dfjO7hDoMG3U1YyzWZz7dQky/dJDC1DK0oghPf0knjFzQDVeNKhGDaiTXsag?=
 =?us-ascii?Q?0MgzlQetCbIlJTD03oqm1vdytPC5tCjrJ63wGo8esAijrjoFHj+IekxF0eLg?=
 =?us-ascii?Q?wKiXFTbq8s2fodDdVpFc4lwvsDkOk0Lmgqs3UoZd1/7W9lMxfDb7sx79m5mv?=
 =?us-ascii?Q?I3kKpzoL8T114+ww0dM3Asgh3dKH1HjXroVFUnB7WH2Ptjt94bfM0AxgPcJ0?=
 =?us-ascii?Q?OcbXI+Usi49y4xXM/dboAwpKn91v7WcsRZzAwbtiy7ZYQed3lySnM9HYQS1H?=
 =?us-ascii?Q?A8BMABlYxlMF5XXSjDPYFlif4afjttvAesbhOSmBwRsUG4V4TA4z/SXFbd07?=
 =?us-ascii?Q?bwOthfkec+ozoC0aHYdJowWquVDqF/A45sAu0YZ9z+RK6IVs41YMnOzjVtOf?=
 =?us-ascii?Q?xhX0GLBgMpxdPUTkuSDeud13uTdW0ODdvVk2BRJCJx8VdPtr3GeCBOpmZbbH?=
 =?us-ascii?Q?ySX0m0LECPPJ6G9QAC7UCduSxMb4bsktXIwfUhGs9BKfNWHT6w9mC4fDn6B8?=
 =?us-ascii?Q?wkaySMyYiW/YHTXhz2MArxRj9/Lsx2CRIc5tE5U5hylDG7a4QyaeDmZkylxR?=
 =?us-ascii?Q?15ECC1cuZIJVo3VKSmRZJp686uHjbMbxHr419PLGftbrl0Hh+mbc+k1a1Egh?=
 =?us-ascii?Q?05ckPW0Or2RSmH3D7YH6hUNSsru4ewNJuGc0Eijful5TK3gcMtei2h/wjhwe?=
 =?us-ascii?Q?FILWYSjPiE7slVpBpngQXygWx6JCTKSLSBTp5h2rxZu/wTnKAB0QzeC7SPqS?=
 =?us-ascii?Q?H/TUFK1wpg=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 740c172f-de8f-4b31-5dc2-08de8ea947bf
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 22:11:23.8834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OLXxBOi6DQbF7tiW+a0vlorvkl1GSG0v+3aLrKy51Zqla+NAqxtKTi7pTCP/GADt+xW50j02j/0qb9yZ5XQ/hA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB3841

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

