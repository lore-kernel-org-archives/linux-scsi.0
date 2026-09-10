Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020093.outbound.protection.outlook.com [52.101.196.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF214E56F9;
	Thu, 10 Sep 2026 16:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.196.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789058579; cv=fail; b=qLJh4B5vh+aFMjNBUtT85EdFJdJbBQX6MyO7nJWgYFRDfVIIfyLNnD5EOmFkF6le1/sorE9rWM0zO0uXua/HzZqTik3l3LR/TN1gtgN2u/N8Rq2A55vLoVQhpgnvXIoJ4BmveS1ztQrYcFOgv/hf8jFRCnD6Jz8nPcJSl1m6/vY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789058579; c=relaxed/simple;
	bh=xjG2tRYYuK4uJZa+4H0bkRa05Z9bU0kwKYSIakGM6x0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=N831EZnXGZPuhFchyqRMAp7qy4nPsLXBB1ecAMHHPTPgkhly7eIYVrflvLjvYaFU5aAx7sWFk3CEThpmNSibuVZp8Lw4w5j/ZUi7HGPYgQ6wydEuBUouOp1o8rOceA1fpmNlhgh4wTJwJmCYO9LfRrTfXO3E3b4Ttu4ObuomOtM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.196.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oNUeA1+N9BHMWrbwVk0hm1GL2/+OGqB7JHyxcQFL3sxrrEL3AqXl9aq5Be54jAucEbS3uwM1i9zY90wugvuBFevE/pK1ZqLLpH5IUn6N5KkCKCwSfMF88cPHkepPXknnfBeF0bK4XNXWz3gOjWVkTSfHPc6wtQZdpLawdsr9veBfBBMLoAWsb+0JfLS63kK48YSSujLRt9+QyfMDoIZ2yi/XKDGarMMH7og5sMQOvAx2FnLfzAn0g3/2cfKHWuTQbQmcRRF5VAdtQng0tFMSWoLdFh231Wa45/2WCLu5oLzSr1Ssiaqxiv7BANwKHuOgY4j7MgdATJVABjssydhSPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=4WO0GAEqxTGLmUFitmgR1ZTPbYpelVRt5xRMxd/yFqs=;
 b=tF96mFSt8STaBRBHQh//frQg6gosj1bai7icRfdBgkv6ad97wjaqh3jSkyXcjVRghF9FqInq5vRdmCuqroCXNU+SUgYaHR9jjfRgVmc8OFV15GeWqXTjvUueSlx4UKvRU+TWOd2amF2nzU0Ki9AwAdY4GyA3w1S4bKoqdi5FAQx3OmIwT3tHsDUV17VGwr/dOFr2jzFgLdFkERxycluw0YtCrJa4XsA68TLxKPPBB1AHNSIo9Qfq1V+WadDA54LAj8qvd9z8ucnuD9yl1pIS2o6Ti7P1iU7hBWqhmt3DaG7fVRauYiJ4qJ9hODDqGBMcyvaiP0BSz8loZqYp9uaRJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:183::5)
 by CW1P123MB096022.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:2a3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 16:42:55 +0000
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230]) by CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230%4]) with mapi id 15.21.0406.007; Thu, 10 Sep 2026
 16:42:55 +0000
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
Subject: [PATCH v16 2/9] lib/group_cpus: remove dead !SMP code
Date: Thu, 10 Sep 2026 12:42:30 -0400
Message-ID: <20260910164237.500196-3-atomlin@atomlin.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910164237.500196-1-atomlin@atomlin.com>
References: <20260910164237.500196-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0004.namprd03.prod.outlook.com
 (2603:10b6:5:3b8::9) To CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:183::5)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB6607:EE_|CW1P123MB096022:EE_
X-MS-Office365-Filtering-Correlation-Id: 30ef03d7-1460-46d8-0aea-08df0f5a9035
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|6133799003|18002099003|22082099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	DUnbbSYmwBkRmk06ZP6hZZt77itE0RbTU43ziUztlKR7Rezcim5GdtOu9vqLMe+xO6ilJEjbg6X2ZBytBXAOang1YC72ZjEUEbFBtQgJHc9Mu73RXZFc3aoVGpSi9ENbq4LARzmYCyPexn+1boAcmcNFU7ySbkepQqCjLkx6uHQ23eWKSyfVm2wWM0srU7cKDy3yw6dR0j9NefD8oMWOvjE846+8+w70E+ZoIE5hnJUNh2Q6og7rOdKYuWR/Ck/G6IiCvkk/OSpNCrQtmFilnMEQQWwCpMeYSuMbC6E67JNMeZki/1ZPSbQ/UH/8lWX4/ZqkAUS7ZngjJxT0KXgi8/LXKVk/1Ve0gKnBPpDJwCEO3CspJ6S4HT8buog12Pl5mMmQ9paXCytW2LFssDT/YTRut5EvY+XYK3/zIRXOty+MB0FbiHRBbEpjfXAtH1EUhNsIbDS+ngwwkGouVA/yrEhPEbxXf8ZaU/Oy7umwnEIF3jx4rbyCx7KZIOtb3k0haFHRnRon/4FhVAHeOyWUKkrDOF4VKYWc8IjEkhcWaFO/RsLNFjhPLPaiNC3/eXhuN5LyaBMHY6Z9Ag6J2oKOYiZzF6kchcHWSk0Joky9oh1rVLceAxaxQnqGXi2PVFeFFa4dvtXJF0Y1TwvUL1Q6Ff3v0YN8ajBhToDZYkgiIZ4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(6133799003)(18002099003)(22082099003)(56012099006)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ff29oOyxn62t71PH3deYJgDGEKi5HQ1pADSvmyMuExYnz1jm9oZgLDXvWdCb?=
 =?us-ascii?Q?Vffp7TMEdThQT3N+vUAEyCM8+ObBhrjxH/bxyHXBpuRd3ZnyHM7ApBwQ0T9v?=
 =?us-ascii?Q?9inC9nvM6TWscdvwJ6riKPU+go8++gFTI45evnEnac9olixsstQ7TF/MEliH?=
 =?us-ascii?Q?CR/ldeV2E0IxBQjURQ8BvM7ppWW+iY6nl4QRX0DN5mxdEWAnQ/HNMa+liwfA?=
 =?us-ascii?Q?A26pYgGTPrB/I6iFCqcyGeIgm68dgH4SfiVIuWCx6n3sT3KS+LuN3xJLSfv6?=
 =?us-ascii?Q?fwZPW41s+E79H7BkyhH989sugCFZKuBFXikInzhPPVnFtNS3YiJhLeDS2DiS?=
 =?us-ascii?Q?MMvNlpMnSX7tkyCgMfZFpVLqsiI7otCtztEXIeaalqOyV9T5FnjLP1aFu6eV?=
 =?us-ascii?Q?Bz0M5HsYRIIHUgnu4jHBwUsKFhdeaA4vlBSmE/FXm1JAcJDV16l8XQEcai3u?=
 =?us-ascii?Q?2vFNKukKx9bUSQlji5MBaFVvMhL1LpzJwR0WH+4+Tb/xaY7IQfJcNo/7QdME?=
 =?us-ascii?Q?F/q3D8EJNkDFHwPPcVoNWuRm9iqajxThFTUmeUgbZI/EICiZxc4KdhsgB9Ta?=
 =?us-ascii?Q?jVa1BJBuTZUllJjA5FtTLicRa3e/4SfO71gP4NLvxW0g/6zclJXOcjM6rF5Z?=
 =?us-ascii?Q?InCA56kEDF0yUDsKilWXlTW0E37+772cIuZzKFWkgboNNbjRSPsUFj+PrYOu?=
 =?us-ascii?Q?pXqhTuZJ13RvuEvZSCZqL5Yv+qjkZRULRv1uGZc71Icd22i54eHsbfqbIjhT?=
 =?us-ascii?Q?530MR0i5TqokJtONR4oSM5ubZgceVE9f5WjpxyT0Jc+/0uB1ophTYIMJ+axr?=
 =?us-ascii?Q?s4i+WVZiSeApQYEJh9hJEuAAkA0ff20zTq4JiNnrERcC+oPPgbWtZHvp4nrW?=
 =?us-ascii?Q?OO2KWd5DIdDcBQg1TkytGMiEXKnhhbI8A3l9jdUgYIzOi7hd0Vr+i/18D1tw?=
 =?us-ascii?Q?hUVqJbRMNI1NXHyZqizSYj7BXwi5q1qYqQeUq1rW7VAdtXSu4J/NrWAU3g4X?=
 =?us-ascii?Q?xlRZhoQ39XLMabMUNmXgcVEJV9k2Bj96GOYwc+4sTUMFZT/jQmk3NIAicrkq?=
 =?us-ascii?Q?tLbWzzdZVf6EmeS7Qgd+UUUFfRdLGFlDzY1c/irDqIMG5U1DWVkCGwPCLaUI?=
 =?us-ascii?Q?5z3A0HvolrgSmzpqhgpqSGxNHVY7jM4Olou4iNXxsp9XcgCeKcNceOGcMfjf?=
 =?us-ascii?Q?O4HwSD0eUDDAnZ3Zux+b2CG52vedpsJdfVBP8r0b2naHgBMNY1XQpDqyXFSM?=
 =?us-ascii?Q?sZrUSrZNVUOeRHSpImQhPqQyOkmLIXTC3B0XkRKSU2Hucnq+Nfi5U8mBkseh?=
 =?us-ascii?Q?YzDIRovoSHgk3RIgszfBtkxc7Xf3VjaSZMoagdpMUnzhkf9xLVf81zUe2ugN?=
 =?us-ascii?Q?OeipojMJQlz2u+I7Kku5giWxhMiN3ZjxXC3M9V1ImxxSYbV3LpP1xOHF4GKx?=
 =?us-ascii?Q?PVSLZtizW5c4U42+15A2i+loB4azrv54KUDCf5HjNi12oUPS4Dqf4yNrLade?=
 =?us-ascii?Q?tqluz4XVijrwOZndkg5rjlD3GEsoozmRN1hyULiW6uKDEUIhpYUE1BKsxYMP?=
 =?us-ascii?Q?c6z0xexUT54bJ5SMIJVf+EECD5XlZVi6itUKFDCxICMy0Jn81ktuHiZ60YXB?=
 =?us-ascii?Q?2qDyiE3qZzS4k1pVW12RjLtjKT1/S0Vhb3Rr2YZZcTR8acoszwKaPYYaVe+i?=
 =?us-ascii?Q?/cOrDafQtrEC7Ck2OtWtK0E0F74hewcaZWWzTq7Zw/JE1rQyC20tJu4rr+Kt?=
 =?us-ascii?Q?5A66hxqrmw=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30ef03d7-1460-46d8-0aea-08df0f5a9035
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 16:42:55.3062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q+NngaWDOVta5BUERIzpDCs1DJ0Dh0eEVHM7JFCIgRHviXgfDZfIfUqyEEoPd3d+cSAT6ujeHOO+OGHG89fkzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CW1P123MB096022

From: Daniel Wagner <wagi@kernel.org>

The core scheduler recently transitioned to compiling SMP data
structures unconditionally to reduce code complexity - see commit
cac5cefbade9 ("sched/smp: Make SMP unconditional").

In alignment with this philosophy of reducing dual-path maintenance,
this patch removes the #ifdef CONFIG_SMP guards and the dedicated !SMP
fallback logic here.

While the !SMP path provided a slightly simpler execution flow for
uniprocessor kernels (avoiding SMP-specific overhead), maintaining these
separate code paths adds unnecessary complexity and testing burden.
Removing these guards simplifies the codebase by standardizing entirely
on the SMP logic, which safely resolves to single-CPU operations on UP
configurations.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 lib/group_cpus.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/lib/group_cpus.c b/lib/group_cpus.c
index e6e18d7a49bb..b8d54398f88a 100644
--- a/lib/group_cpus.c
+++ b/lib/group_cpus.c
@@ -9,8 +9,6 @@
 #include <linux/sort.h>
 #include <linux/group_cpus.h>
 
-#ifdef CONFIG_SMP
-
 static void grp_spread_init_one(struct cpumask *irqmsk, struct cpumask *nmsk,
 				unsigned int cpus_per_grp)
 {
@@ -564,22 +562,4 @@ struct cpumask *group_cpus_evenly(unsigned int numgrps, unsigned int *nummasks)
 	*nummasks = min(nr_present + nr_others, numgrps);
 	return masks;
 }
-#else /* CONFIG_SMP */
-struct cpumask *group_cpus_evenly(unsigned int numgrps, unsigned int *nummasks)
-{
-	struct cpumask *masks;
-
-	if (numgrps == 0)
-		return NULL;
-
-	masks = kzalloc_objs(*masks, numgrps);
-	if (!masks)
-		return NULL;
-
-	/* assign all CPUs(cpu 0) to the 1st group only */
-	cpumask_copy(&masks[0], cpu_possible_mask);
-	*nummasks = 1;
-	return masks;
-}
-#endif /* CONFIG_SMP */
 EXPORT_SYMBOL_GPL(group_cpus_evenly);
-- 
2.55.0

