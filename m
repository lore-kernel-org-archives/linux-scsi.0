Received: from CWXP265CU008.outbound.protection.outlook.com (mail-ukwestazon11020085.outbound.protection.outlook.com [52.101.195.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078773CFF67;
	Wed, 22 Apr 2026 18:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.195.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776883982; cv=fail; b=ftg3Ugxrl3iq//l0ArKMxi+buPC05qk7uL0kDfGtYTX1mmGPkaLmGaVz7F32CcjTuUY5RnKDieBvtLGtVBt9Lf5EzsMalkQgQ1CxbkyQpUKMP82bdBJKY0VHKB2rt78kCQoHkqRDk9qY3R2WDhYS0j6vmkTDkaiS+apUtRNVKGM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776883982; c=relaxed/simple;
	bh=Wdm1AL7cAW2lOhZ1+PctyE5JizjY0tMfIY3BCgnyOnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ne19vk378VopjLPupp/RyCK4F/gbiemhx1GSlDu4fYhTwfQJpsW9PW0qZQBbL3l4b/jCdEibVRAytcKBLcLBAVjWMptP8ljreEl9GgLYHDYA6aZ8Gm9UvMDavRv+32xxvnW9bzrNqKsYZFfbVECE1CoQAYrSsQkGwdV/dBl/3e8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.195.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ejue18fsrFXZ6NDw/5zY+Mbhlcvlab7q8I/HoLc2QVS8Es4DhZW+pCfSZ53EUlCcXRTAnjpyqFN2QadyGM8IXc+l8HDsAtt62dlkh7q8QaTJfOY3h11ovBqQmpfJbh+N0KADDXgQY8YkH2HfApyGQLdw8oZHe1Jg2+8HL2WC97mzuG4EMXjyPuXDYtN9O+k/O8mbeCfCCpm0hhz9j97NVqBQLshHo8hYbH8n2A9GW9XzCw6bJsG8D3UUwCPWOuv9DDhATfSFEuG6sbuphmt+psaXKlv1YvP9ACcrJiM+1fF2ZiYPgMt3+gEWWNSA0iJ2s7CVbTb9w87Jm8zplH9GlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mT73pcMrZGWJw7/cyUyLQHWE8j9CEal7s6MBWwSPoAw=;
 b=F7V1w8mkhSAgj8iwBOoHPRpcOUS/fSC2R1KhQjZt1ZMYLjgwq2bHuZmYi5L/CZ5TxrQ5D5nJ1XAmJIKh/iP2y15mg71r1wMXImwkmFtyFYJhJBCvXCS2RlPETCplJllKGiuxItg0SfOaXFvKpht8Pe56QVrpQ+UL7wpHgP789hSSgtiCL3Qo5l68Yl0bilH6mX9gMvK9Y7AH9a+TVh+rlo5virWWCXPmYYBcytAoIOmJYN9/dkoma90bUDmkPZ5TpaJObQURQOrO/inzdjwC8cu4RBZ4vC42/vYx6GgnL8CaESCqQGCfzQKuO4m7qcaOXgKAmZQbEGJhF3RgfISydg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by LO0P123MB7717.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:407::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.19; Wed, 22 Apr
 2026 18:52:58 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9846.019; Wed, 22 Apr 2026
 18:52:58 +0000
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
Subject: [PATCH v12 09/13] isolation: Introduce io_queue isolcpus type
Date: Wed, 22 Apr 2026 14:52:11 -0400
Message-ID: <20260422185215.100929-10-atomlin@atomlin.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260422185215.100929-1-atomlin@atomlin.com>
References: <20260422185215.100929-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO3P265CA0016.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::21) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|LO0P123MB7717:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b21f884-3c10-4e64-573d-08dea0a05ed4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	NrxMgDI1WnG9laWUT8RpIoRH1kvi+zcP71fHThxnyPG4wgPUzjaDvzkKQYM5mk5XxKZkmtcqgO+Mg+DEcgX6uFwG1iLWo+g28ZkE9KnXrbEV6MhNG60Ms48vG+j3AezWKuhpjHGwYepKYiAQrfKxaV+M5X4E8tDLfZanfS9A8aIzhgzP0vA/Jtzl8XVDaKFRRqUF46vpDzxV+kJZz52UkjIlh0K0vmge4Pfeb6O5ugsy+WnF3oi9O+mURGeRY+H9rCK4DKREruxtVehpUwCz7OFcqwmVJ2ItJyPU0ok+QWZo3BKvYr/JN1Xr4FWUdDPfCeQEopnWsRn+vtrLTRj7lx5tlDHKP8RHpZMYmwWaoFZj5Xcdrdpmqor4zktPzO59S4JUI0q6Cn6BRZWSTJBs6hIb/sVvPYuY0CJA2dpqMEStCBUiFonBv7EzgfMOrQzakOzWqHzVYBREyRWm5TJl12rfVaJkcugMKwvkBDA/Xme2KK6u2SbG3ZXKiNmLPj1zb7QKMUIZuGwCFEa1/Tjbowe0QGCGG1zpHD/kp+gWEVlQBd08vIzflnqGyUeylTjenzAm4jjQgtRzooiDFJDKrr5sNPcBZaTCWD4N3QXgxHqFoPnLsRAfx1OfSEey13o2wl//I39pmZ1OarKIbQ+i2WIWFCtfMl+VeYw2UdApsQRATDc2b157VXwA8ZJHT6OxXyUZdmEcq6vuft4WlaVjAdGpEs9Q0MmqSmtgyivyqBw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?upktqvFtE6ydUR1aIUjWi3f51X/W0TtoE/94Hp/SwfV1BAq3aum48NRSzFg4?=
 =?us-ascii?Q?4KKH7cNYW8OyrsNEJJ+3NtzqsYGFFtBpHXU7bxSGFMYaUOnSn6aOVKwD/7Hk?=
 =?us-ascii?Q?XzXMCRJVwhGuZR6NA+HLN/LlJndaTnL+02pddw9izEm6jb36teTtCuoT4V+k?=
 =?us-ascii?Q?8AbtdDmwUlIYjirGt4IO/nRHDNmv/JDBEyRlCXXE8bp3gNvFBZHANPYkdtks?=
 =?us-ascii?Q?hWSQBhpYZAwxs9MgnH8CzPYX27vvcl47/qP58LINEP4yC/F+QGAY4i0c5NpT?=
 =?us-ascii?Q?j0S7W+cHW8efMHYHzwwGV5gaDwhXszdta0gGrRJvF/KV6uhME/LQfzQbP0mv?=
 =?us-ascii?Q?RVRG0uQVNXSJlQg0AQ3FcRtsglGTygNtDYjR5/aKidYEkAyrUwYEw8Dd8qBG?=
 =?us-ascii?Q?KMMG+5YAO2dcHbBsx81Qu+JCm6eD9hkRHNdcJZeh4gFx5NW2zTcZh/dI9esz?=
 =?us-ascii?Q?2OLPuhEEXvC4mX+sK0OkvJV6kWTMbz7awImqGTl/qf14a11S5dT7OWW26zcV?=
 =?us-ascii?Q?P8492+JLsiJSZ83vmzzT57GaTaH4C2RNJk8YSmCXTKYQU6A3gfTbwKzTVMkd?=
 =?us-ascii?Q?JzdGzQ4XZ6uoWkUxtGmzzsiT2kK22haZHgiKbw4E9+mypkKNQVvQNXmK6LLm?=
 =?us-ascii?Q?dpmzEfSlE0RqxOMRCdtsk8lWJvYg2UgsgaOPMYCDUuwZ8Weetql21buSiI0I?=
 =?us-ascii?Q?/ykeZoOcWG3Qz2zwvhQmFME+B+sPXqud55QEdiXFWorxCoEW8a/U01C9ZLK3?=
 =?us-ascii?Q?cxnADXNrXr2c98zhRW9TQ5Ffxl5JX/o3ZkaV12BzIZxz2F1jtiy2k6AMGFyw?=
 =?us-ascii?Q?kbvknzIEGNQzfUUR3urF67yA1uxhhB53iqMNv9+X+ff/2fpE0HdvbuYc0eV7?=
 =?us-ascii?Q?SqPbbfBXtlD32z6k606MfAkP53f0E61AL+txYjJp4RajG1lNoRSFJLnPQ7z1?=
 =?us-ascii?Q?JcAkPCIXCcRXcm/lPQgXOFh+Fd9itNX9lbW6x/r9Jn12mtXoHDbkWXQjPv9G?=
 =?us-ascii?Q?lBZhprcVC1IxVeJcjjrB20QBbGbK4RYfZIxbE6uy48uNzw3A9xiDchyiIKdU?=
 =?us-ascii?Q?s+LQezBI2SHHcV+XNza9Vvg60dPQTOXPmBO8IDOaOXD3uOvSTBRsKWw/x5f6?=
 =?us-ascii?Q?6DVG18KMvRLxRVZFIr2qrrZMKGLYy1x17xOmAUcPzGofc6pjIQXuMJOsRHKr?=
 =?us-ascii?Q?9YCkK3GNlvSeQNB6l4Doy5VZrnSiywYLdseSN1dnQjaIriv+z8zpdiOD1aUW?=
 =?us-ascii?Q?DzArF0rs2dnpWalODgAXYskzx76FcDj4pVRjGCJqS5gyVTa783ILrZWWmp3b?=
 =?us-ascii?Q?rH+YNfjDdsyfj7464KqqIdFfBRnR6bqpnc97uo2Vl1M9DHzo0N9ETMwAfvhT?=
 =?us-ascii?Q?5wwE8bYojP8PMq9dg6cZUY+SErqo6yT68gM5cAjKz23+bxcasqVvCbwmRtR+?=
 =?us-ascii?Q?rQ/MmTb7joOzmNWWCfzUQM841f1wBoZSUDj9j8RLIQ8OKb1fjmEUXCE+UC9a?=
 =?us-ascii?Q?RQ/NiGfFp8PCsnIkX8tiqBY8V8X1eDicK6x/K9Q3DSje9VIdyD87PFxsvpQJ?=
 =?us-ascii?Q?gFKuCqsyDKMA+2Um6kmXPzV4CLqZ5jHhDtZYYNyPuAOzrUNQO7jicS4KfHy8?=
 =?us-ascii?Q?8Cqa0q9gEpPuNFV0IphZ+93TInd78XuJee9PaAWfeTHTjvO0aZU0IYHMh1Tp?=
 =?us-ascii?Q?PpzdbdrY9Ql4JXcdlnaClJcwTfvkxRhz5vtpUF4zrmK+Q0tmB6Jrqi1al3Ri?=
 =?us-ascii?Q?gchGNYqi2w=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b21f884-3c10-4e64-573d-08dea0a05ed4
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 18:52:58.4049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dORWv30wSsHPGcvqrRzA1EHCAcYxiF8ZZBttCh1kqFlFCOxcxzPzzshQ72534kZT3PlNNj2GSTbYH8U7RJsm/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P123MB7717

From: Daniel Wagner <wagi@kernel.org>

Multiqueue drivers spread I/O queues across all CPUs for optimal
performance. However, these drivers are not aware of CPU isolation
requirements and will distribute queues without considering the isolcpus
configuration.

Introduce a new isolcpus mask that allows users to define which CPUs
should have I/O queues assigned. This is similar to managed_irq, but
intended for drivers that do not use the managed IRQ infrastructure

Signed-off-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
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

