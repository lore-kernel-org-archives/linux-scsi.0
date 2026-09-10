Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020093.outbound.protection.outlook.com [52.101.196.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CACC4CCDDD;
	Thu, 10 Sep 2026 16:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.196.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789058576; cv=fail; b=Fxz39YgwJrrBzZOEgmA7eEWI5BjNvCsFSauzT+IF5h5rd+d/76VGw9cQfrYL9voX62v0NXn4LeAawK6hdUnNRr2O4Daq45SeO1Slim5PTXVP7KFjcEN6zXyUiC4ayTJMHmIb0EKa+3mCau729R3mvEtJbdn/xv9y1nS+Pwywxx8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789058576; c=relaxed/simple;
	bh=pR1e0XJepJKIdPGrAUFyV92MseH2QfLbwCrCjMqSsXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OkRnfg/tuorSbNV+0Hfo3NUImjx93DxmKu22c2KQRldPyfwZOq4sHWNBoEzk9hMQW3U3txzf64n+KQNoZVvMYrMNVGFEOQu5Hxk09Eg7EOqoM0tCZ25+9cHz/dKKAGXhzwJTMobQ2B27+g6TZW76Ow3g3ily8NL77BPyQHgaqBY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.196.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ERkaE6gwb3iB+hX3EJsvbexwD5Rumqv7W3iaYB9JWx1HK1uYSZvnjJzHJQez2IXzvkjOF4F8ozZKaTMSuBBj/0S40icBp8D8ckr09ZTLg3nJ5aqlOQjQ4+Ujy9qvoa04R0YJ481rniTjNz18IVmh2BcFf9ulxKnp9430nXtNaBHvh9myiciAiixw71lDFn/QUsiWNrBeyihSxpj9OP2sy0jjwu6AimQumHKFdrf56pH2wQoXl88N6ie+fDUPk01yPSMP1nOB2RCcrCPJaJE080Pw7Iy9j3Rctx1JIo13w/yDeqxjWP4SRZ3z/n/xgP/ANVxHUXRMgDOWvcaGOJLruw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=AjMF/BrmrrD8TzN/g2vl8e8YGAoAAfdD0hJIw3I2x5A=;
 b=uKhX5Xmmp+y9rOrPdMLucickLo9jKZoWM+CH/h7WFaAB/jEr+TmZeMVupSqV2l35t2H2y+eJNopv2dvX0Muxr0P8+VrwPz/j8W3MHexyIJB+ujpW7t6XWLLNN1gCs87M0J1kXrzFYeFLcKwa1YXVT60FVT7ebmQM4sl7t1sjExWnDwn/0LNmTGR7q0ykDxbpokH5ilDNQxHBqU4gXxlo5/NO8VB3F9Zyq/TJQiTIeLzWz8Vd8L+rzrcJ3UYt1Ekml24l6GJ9Y1emrEPBOtcDM2/QLkoI2FcdxjePIu9ySoTf1xkI3wImeqWAQVem9QJEW5VRnQz5g3tB5mcRgVvYOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:183::5)
 by CW1P123MB096022.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:2a3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 16:42:49 +0000
Received: from CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230]) by CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 ([fe80::cec4:77ab:262e:d230%4]) with mapi id 15.21.0406.007; Thu, 10 Sep 2026
 16:42:49 +0000
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
Subject: [PATCH v16 1/9] scsi: aacraid: use block layer helpers to calculate num of queues
Date: Thu, 10 Sep 2026 12:42:29 -0400
Message-ID: <20260910164237.500196-2-atomlin@atomlin.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910164237.500196-1-atomlin@atomlin.com>
References: <20260910164237.500196-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR15CA0014.namprd15.prod.outlook.com
 (2603:10b6:510:2d2::17) To CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:183::5)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB6607:EE_|CW1P123MB096022:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c89eb65-d7d7-4db8-94b0-08df0f5a8cf5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|18002099003|22082099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	4LovMGdmvKHg/8FdYqTN/7VS34ESrcYG8XLznfZ3WE9aRw5oez3xTxloRvVXIaSlyY+mEVNTONTolb1Ei7LpsWZN1dHf3ObagS+3K94BaiG1Qino7sNVkh+VzkdkkpE8bV0tHiLjRNrscTNgAvOnGP2Ad2iXZV7J4k8Ef1m5/ZWevak1ZdZFAvpAmqgX4hhm6RqDx3XBSxOairas23TgkvmH/wq4t0xeT6je1Ms9ciCWAs/9s6UHNVm9CXeEL+CdXEkDzzNJwx//UyEBC+WCmxqZK4jpx7sQ1vJS/vQacDDS5d7LJk1BJewtyxiLkpeXYIyVKaM6e/w1As1q0C1fIAL9Pso4LhEgzKLoU18i3JrCyKwqdPwyAHAQAK77XpNkCp4lTZw1Z7pcupPy1Xs+L6b/KwHJ47gxGyThn7EFI/qTctkFPwQWfRxzY1R71jDW877/0T1o8uRDbM89BKJZx2GUfkcujuqTcSA18nbrviT8V748GzJLIM/gUlL/QTbzU5G2cS2eWtkB3DbyVGA20o9mbHbO5h6jBc+P1Rl0S0ua46/LHmNwphzdHAcYahn7GAtJD7+trf2CCKhT5ee8xFsvJ1qGGyTxJorveyehMAdIwM48uWFCDONpgWPp6Qtngu5KFGVQrbShzTmkllZsODMUIqwqDbGnpVNJ4osEss8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(18002099003)(22082099003)(56012099006)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sgvZm4xNiVX5aKJbgbWsRaD2CJ7t59vzc29zzIU6p7BNTHx28AJTuEVT6HTY?=
 =?us-ascii?Q?io207DT+O4MjEgO+4kfR2Ur+keyxiWmmXW4GR29Cir5Sp1dj3RBagdkn4wVY?=
 =?us-ascii?Q?eTuKB98U6XyLGpYeFqc6YqtbLEfLp/rHBTDEfL74023jztoS4bRtlJ7MyKMC?=
 =?us-ascii?Q?S8tWqri+yxqvPgohK99dUNy+hnffO3nJuQIcXaVrrJXoxpn6GtQgwyhBC1ZZ?=
 =?us-ascii?Q?6Wg2cWBc45Rm6GaQmm3k1d7Knf6LG+J5HFJHPGfKDO0/DEFWxP7w3HQXhTV0?=
 =?us-ascii?Q?FImytVq3ccq56ufFyF8vsKRsZbnfQQxM7BbAB+WG+u2A0J3CDgTn1v42fH1u?=
 =?us-ascii?Q?WJSJ4Ynfcig8tXRul6z2OfGoV/H+o3XyhaF04q05hh6HyW5BiPM8Yfd9jrdX?=
 =?us-ascii?Q?kLR7q7uOVG2oCe+n/pI8zF5xejUqLVFiCaW8oDdL6LagqkbrhgbKZaBLPjjW?=
 =?us-ascii?Q?YbGjNDQRgBUNC8xW+fLuUCZPJvGLUw29pDl+Z+WJY4cheyEby+KUE19Hkq2D?=
 =?us-ascii?Q?jA9IEmlnM19mRzNDNDGW5XKi0pVtfiA4f1WSJYJtzp3up46urpweC7g2qe1e?=
 =?us-ascii?Q?gW27tL2GAnyNHaEuOtfbVsPqItr3OIlfiedkd2qKKpmEVPy06Lsd6XCQ9l63?=
 =?us-ascii?Q?eT1ROD30fD63vsEc6i/6XE1NjQQYYN0nJTuuQ55zqd8RjXxHjSn3QiG7Mvpd?=
 =?us-ascii?Q?AhnoYxoVvtSmURVouP9TtQPMQg2oJlHa51wro7o0bqUPUzgFOfMQpnExPbfU?=
 =?us-ascii?Q?M1KY5926jj3Co20lK6/0+omiYEnonUmlUMbZQk3jql6MErnmidNx4yje3GIc?=
 =?us-ascii?Q?kCiKv5UA5PlthkDbJohgEstW+MyRPIr2icn09/2lg6IhCWZlnTAgskDf7rdV?=
 =?us-ascii?Q?X/8vFSE9Z1nisG4HEQphg9KsFOsIFI45b0tPevpoWoX/DBdjc3f6Ua53DAHm?=
 =?us-ascii?Q?ldDVjBYKleH8HZPbLDA2a0Wn80TJsjsIzy3O4KwRz8YNT4/5cfMNqdpljYBL?=
 =?us-ascii?Q?lkWHlP0PPggJ/Xy4KxV1AYJgvuQDxhfqUWO+c5zr4NQw3gK3CEuGmxvZxIy5?=
 =?us-ascii?Q?MMaxSuTvW6glT2sRQW3J876tzkT17mOe+U5LDsK9w9KHq5heA7yuL7UYHU1Z?=
 =?us-ascii?Q?QMKfK37dwaeYhE70uza6MCxCjyv3k0g/VvAmv0lE+8HN3avI/5+gC0r6eSSN?=
 =?us-ascii?Q?NgBYwEax9Nvtp7cFPThsxIe/WyWARaUTlTba/2g5uJyNZpBDcN8LoyJdeIGV?=
 =?us-ascii?Q?TKy9FJAytn9myVxCI8rsUL4K2YWMyL3z161yXHKM5QPKNpHBGgKGoYIwv4uI?=
 =?us-ascii?Q?E7aei1zJdYLKdoeL6RCqOQAMtraUc9OUuh7Mb9rUTvcxmrPJqyrpPP1wpbrR?=
 =?us-ascii?Q?gk99KRkYbmddlHsP0Npza5PRgG+Ocsh/J7wpbHC+/kQ+x9Dp4Y6Zrj7r7x3k?=
 =?us-ascii?Q?agYbZGvIc6B5KaSLsqkthCuEPj/myDXnv/3e4wH6TOfyTJ7lMZxsVvP4j9tz?=
 =?us-ascii?Q?s/u26YK3xyyLP0eOJOfIUfv9RncTXJe5KCkK9WpZ71pquQxCkIpSnk9p4Uat?=
 =?us-ascii?Q?dtO1ewie7sc4asE0CeRrppkQ4rxZp3Iw7kX1O8flMJHSnF2YGEDIMhN8RN4v?=
 =?us-ascii?Q?qQC47QHcj2vhW3AK144DxxuY4PCyBV9D5O9rPzbd0PV7B72DFAzI6oKEZuVm?=
 =?us-ascii?Q?ARgqqZkyxW7OnejSZ2aES8UFHjT6s6lxxFZ/vzEzMkR5lIHLFBCRvWQc6UH7?=
 =?us-ascii?Q?deY2QJ3TUw=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c89eb65-d7d7-4db8-94b0-08df0f5a8cf5
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB6607.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 16:42:49.7570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AcTGTmrIgDc4X0a5ubqja8FsNtyUyaVUYT+aM1pv+FqiqxtvnEyqXqpiJTkediGIz/14eb06NirowquckhiRoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CW1P123MB096022

From: Daniel Wagner <wagi@kernel.org>

The calculation of the upper limit for queues does not depend solely on
the number of online CPUs; for example, the isolcpus kernel
command-line option must also be considered.

To account for this, the block layer provides a helper function to
retrieve the maximum number of queues. Use it to set an appropriate
upper queue number limit.

This patch brings aacraid in line with the API migration initiated for
other SCSI drivers in commit 94970cfb5f10 ("scsi: use block layer
helpers to calculate num of queues").

Signed-off-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 drivers/scsi/aacraid/comminit.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 9bd3f5b868bc..ec165b57182d 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -469,8 +469,7 @@ void aac_define_int_mode(struct aac_dev *dev)
 	}
 
 	/* Don't bother allocating more MSI-X vectors than cpus */
-	msi_count = min(dev->max_msix,
-		(unsigned int)num_online_cpus());
+	msi_count = blk_mq_num_online_queues(dev->max_msix);
 
 	dev->max_msix = msi_count;
 
-- 
2.55.0

