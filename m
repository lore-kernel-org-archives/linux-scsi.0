Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A022E288D2
	for <linux-scsi@vger.kernel.org>; Wed, 22 Oct 2025 01:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761098241; cv=fail; b=M6Ue3wJdt+1bKS5nM5WPpqb4PJY47xtTcR8UHy/RTNJI62EscAz4mkJWw5t0fpGdu2vhA+hVCUTJgcdy0PmP7M92w3/QUwwZofDn7vOW++tgjqjVvZ+rDe0w2nEnL77+yA9bOWd9RGY4EZlPs+AhlQ7gEN6l4t/XFOFf+mKVI8Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761098241; c=relaxed/simple;
	bh=r1FcVIS1egK8gBlfshFGFtcR9E/NTfCf0mFyi4hVriM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=gH1BgwqsDFT3tcBMnUG9RD4YE0ChIyx221P6GL4G2uXMQUXJH/S2YBAMxp5SgZI/KDdXRF9QbI1hcQFzGBkvADVwgvg+um41cPNgUhNvOHxlC/y1a/Zl2V/VH5Yyo7PhVdaAQjOGF/KckEKV3EMUlGF35IYlFJ5DilYvIRjOcD0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dSYIBuub; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PqhWrwnA; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dSYIBuub";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PqhWrwnA"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59M1WdB0006741;
	Wed, 22 Oct 2025 01:57:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=j6ne0MSgPAxYUW0k0O
	ntoIFqka5+aiflFNANUQ9a2Po=; b=dSYIBuubSoMHKgZyWHry4z/ApvngKuEprI
	e+a1KT6T1LnG//ERP0yeXXS8WVd+wuDoGzMQew2TcD0Bn7410hlN7N4P5omfrJDo
	q5Hyi67huVQjgAniYl89H9V7iDk6uaRsX4YkS5T+wy98OT8GZ7a1hIyOoah5K0px
	Xl1RMcj52idCA7W6gVF+sLZUmE2l7htHWUqLVBY2F989P/PtpGuTzopZRxM2gjf5
	D7X/hOvv8/6IY3V+zWKArCu/taY1wkY/EeRne9OWQe2ukVSw9qfGfnu9wwcz9gh+
	+HpqBRTWTl+SyS9/da0NHddm87uVZ79Q6Z/D3qllcZniwSYMWbSA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v3076s1b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 01:57:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59M0q75Y013163;
	Wed, 22 Oct 2025 01:57:05 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012053.outbound.protection.outlook.com [52.101.53.53])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bchgyv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 01:57:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RE5blf9z/HszVIPbn87TUnpAdt6fD+19OEqJNllS4I1xbLF8ej2ywgToK0g9cPZnBZ51sUXNsBPJvZS/oouGDibdRuqnJtu5Q2Vr+0Ux5zCeBZtN1dKv7egwUyO+yHf7AxuFE8JdWR1Vo4djC+nkTs5UPgnFzVvm94qj8EXULyGkCAc0pYnsmfz3BOhBvvfRxfoUxIHZ0dmgSnLrjyvLhnaer74Jrnz9i3Vx6DsRG+wUCR/MxGmixHpngadU0BKwGiqRxNvWs2NCuY4jdarj8NX6nJ9gLm5pUwQI1e1yIa3lEe69q798itk359krnadhToEY9g0L4KmoEWx4bG8aaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j6ne0MSgPAxYUW0k0OntoIFqka5+aiflFNANUQ9a2Po=;
 b=hO6nBV+mVeMI5fb1nolOc5gojMUVR5K0N1vkBC+JNtqVqhlcqOHQK6TqxHTvhDbGBcPRuEmhmYFFLD7BqTjAL5C5QtYP7jn/dcfIQ0dmDguo9wrosS3HqY1BNCLjJhFHL4RWhBlJw1vV5P+TLqRsGnVvNidDC7PqDDqa50VgEX0s54GqQjrcV/42jFOqzlQKMatkbtWrqrQKancA6/Siv75Shu2uG6AVzFGAHB4TH4hWb1H30aP1Y2YLblSCaOej6dH6//TV303KpXLM2RJlI9lgRqAp1BhaXNXgkEd90bisdcW2BovR2bS8JCX/3u8LWQTwwJMbEsQAUX5wqS157w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j6ne0MSgPAxYUW0k0OntoIFqka5+aiflFNANUQ9a2Po=;
 b=PqhWrwnAJeb+bTNKEY+UzBF05pv7s0eirVvgGg9fBC1DKQAcTy9WkYncb66KeL9oRh1VnJNK/zeEaXqMcLZnL3QUmj7y07xAyw7JLpTgZhOAVFd2aK9T3elyEL7l050VCYJzapc5He22HX+evT6Pw5BHCTVBBxAycB1sJLT2cRo=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA0PR10MB6817.namprd10.prod.outlook.com (2603:10b6:208:43a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Wed, 22 Oct
 2025 01:57:02 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 01:57:02 +0000
To: <peter.wang@mediatek.com>
Cc: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <yi-fan.peng@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
        <tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
        <naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: Re: [PATCH v2 0/8] Enhance UFS Mediatek Driver
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250924094527.2992256-1-peter.wang@mediatek.com> (peter wang's
	message of "Wed, 24 Sep 2025 17:43:22 +0800")
Organization: Oracle Corporation
Message-ID: <yq1y0p34s2s.fsf@ca-mkp.ca.oracle.com>
References: <20250924094527.2992256-1-peter.wang@mediatek.com>
Date: Tue, 21 Oct 2025 21:56:59 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0050.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:1::27) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA0PR10MB6817:EE_
X-MS-Office365-Filtering-Correlation-Id: fb956eea-1ef3-4d54-0dc5-08de110e4aea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kCT85tsLdlf0jOGyneMjUSkBSq5o7Y5Y1zTcILK5D+EVXqzx8pqL5EbjiaJ1?=
 =?us-ascii?Q?JEfpE7mK4b2CN8D3jDMTTFoeeomSkd7e8ZteIhRuprxNMBmP1Clyw/ZMaPrO?=
 =?us-ascii?Q?+cYVGTcwhr0iVlsLFENwkcPUCRqtNkLrpVgAkgbCy7yGpOf32sKu9ZMBYepE?=
 =?us-ascii?Q?Q7wefzxPQxdYrHGBEovJyWGZvERyd3CEVAq7rU5DL++J4B9vCSt8wBSDHG1U?=
 =?us-ascii?Q?SnP9xoCDpFVWl+mjeKzdE2bnJHcqaoOhjAU/S5pVLJSOzWIXszSuJzCufASJ?=
 =?us-ascii?Q?J7g+u3uyuN5HPmqcXanOOLcuV8CpNIGP+nkIP+3WWIzDD4uA47KVEzayjYQy?=
 =?us-ascii?Q?3xpnH/iUwdlqZakDBFE7YaYFq8hKJaRh6pjjJZpPAF0L1ghrvSoGFjvBhmot?=
 =?us-ascii?Q?dx3mp4pi0Mep2rK383VaMInFAOVxFuw56CJBQmp1hODvdy9JOjbBcytaDa6P?=
 =?us-ascii?Q?Cnr5/JQoxyMkcglaNnM1h7Jr0thJWJSTnLxH1qEO1J6VC7fdgien0qDfZ/u8?=
 =?us-ascii?Q?D3NbWejSsDCHlYc72Ljb8225yc5vO7UkJB/K9LvKzv3Vk1PLVscDVPN77YY8?=
 =?us-ascii?Q?faQYw8Ctus1Zvuzhni4p8IMZrjTOdpTKjy+Ay1wmt1rMDq9NzoGWTMgPSpoO?=
 =?us-ascii?Q?Iot21jJlVE+UxgQPt0B+eFxH8ommM9aJMLmdtn79XD2pxHavKnzt2GfG9QTO?=
 =?us-ascii?Q?Aaw702WGhR3rVrJ9e3jm2mlUXiQbQDImtFykfVAuUyKUctFuZNPtQRQZYUFC?=
 =?us-ascii?Q?KgSOA/xvec49lNn8nI9XLUkzXUBSDk2jXshiLh/S5RcwP3wpHvf2u/h6HIVT?=
 =?us-ascii?Q?DTNMxg/vEZBJV/CmHYL4szsHgVYVoTH4RFBTA0azA7xgGzrqsOY7zBEKa0l/?=
 =?us-ascii?Q?Qosm3VjeN3IelZlFu9nXT/TmWvcsaJ1SPOoaMF1do1ai02XDFxW2wQEnMDeJ?=
 =?us-ascii?Q?5g/wJkLjNsagQp3Wp51mqfKJMbhBCdL3PUhL5jOmoHEplof85HvJRXqomzS0?=
 =?us-ascii?Q?IKBcw60wdJayuSRHbroYAi1jtsEavoZDV5cF2A9ObJmFkCfreH+9xQ0Ml8mc?=
 =?us-ascii?Q?jecOhZOd5NJEaf43dQJaTTFasKhj1sskHfNCizWPbS2fHwWULMd1Ac/E30Je?=
 =?us-ascii?Q?TToRj+qysweTEi30z1+oP/dOC8r1gj23/iMuud8dRqRve52BOVEz6db2TEog?=
 =?us-ascii?Q?HEz7Cuuoxzl12jo1FGWCpN1s4MZM7PbJiWOp4z00dgd2Moy9p8R24eNV7hud?=
 =?us-ascii?Q?U26J0hzlND6enMneAHVSCQP1qY4RcsQE/FhQRWG4ztrEKAWILWyda1AXKL0p?=
 =?us-ascii?Q?5Uojf//dbdJmw1Ikd28CJ/Bt2sNkPPesIr2CkP2SJkl6KYmUd8LpcNqmDZ6t?=
 =?us-ascii?Q?iVGlJHe8pIq95HGuACNd1lP4E4TBYo+XL8GeLR3Nm1pSOoV+FEBJcJ6vFTed?=
 =?us-ascii?Q?AVCAAVaT5wNnQuDTCttkwKrxr/Qi1s5a?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2cYiptcn86/VrwzjxaUbh7GYY0wcAf37W2VmpYwQW/v77qp19cVl8uefJ8AM?=
 =?us-ascii?Q?9Su/5071ji6FDR19HlzzDFE7/HF+gmq/GKCCHekAH8QUqSEHIPFIDStPzNKn?=
 =?us-ascii?Q?HZiJ6KrUgN/n3PP8S60Fba3JXeqC8WNXtpcjUw1z2Qh/c8sjaDU5BKC33cZF?=
 =?us-ascii?Q?kBhI7k9Gx/rGM1SpxbitlCdCTZMVBtYExRFUqAD/UGXqW/B+KkOFZh9l3+7v?=
 =?us-ascii?Q?EbAM7ZFV2f1J4V1N/SquHImdePdelaZmr8tiYDaSqmJOynURLcQJVFdhwg3I?=
 =?us-ascii?Q?/RK8LJG4nepD+zYa6KwnFa61ZpvyH5cCwxmoWuK0AzMuxCpypBZ0IDZtPX1Q?=
 =?us-ascii?Q?CPOunMiVacPhClwa2f5wCM3kXFnpcyURb9Q1ilbQmQ4lTlGlA8jTs/jYn/ps?=
 =?us-ascii?Q?P+9gx0WkNQUWFOD3uVsvBeG5bFuiANS2BB3NUmaDCqiVLFGw172Is80t//9J?=
 =?us-ascii?Q?IfCzXdUTU8sGpqSoMuiSlkPcbmvsL+P3xkYe2BQcrOMvPhlS+q4w9y0XXwI1?=
 =?us-ascii?Q?4A1bRtfkQLpDsvFwmkTazQFxZq17fxHPuFIlaLTHI2vXSKS9sya+4sQrCA2t?=
 =?us-ascii?Q?vzNVm1NjUOVSnvSqJgzoFWQAzAzsipsh3LZSl4JIigNUUh+C6mKI0+hvDgq9?=
 =?us-ascii?Q?EdukuXPqb9ZmXXQSRnRVmDoLHLMhpmmOHsRt4atLGAeNgdksoSl4xvj5I16J?=
 =?us-ascii?Q?aBN/FxdoAgM0mnFb5aPtP51GAkFZOHpO0CsBK1LU7wwSjDr2ao7bIZ2/NwYv?=
 =?us-ascii?Q?B1tUKxipo/wEDL4JHLSY+eaWx8TC9tU/fJLouZDK0xRfgutvCOyb2GbNdYXU?=
 =?us-ascii?Q?UDq2iQoTZDQ9uWh4wpN4m663D3EqMCH9qeowdye8lbn7IcZP15BmhLCu0ck1?=
 =?us-ascii?Q?fEnN+W4xoEaNE+lY9MZP8iUDzYiZORjAgR9bWAIu25b7in5zFwE3g2JJgome?=
 =?us-ascii?Q?Ni8526qICkWYDeY5xAbYWJvHJDpSPvlqnep/uAz4zi9RyeVHovS+xOOvO8o0?=
 =?us-ascii?Q?gborL/p/YIAMkWj/aDixyiKfem7/wZ9ZsUSGPkj4huFXvQjYpa9BfeaEXVGE?=
 =?us-ascii?Q?MteY9dBV6YgznKyeh4avzWL4rbEf17LikXxcxm8IhNdfyD4rPC/maIYkynJI?=
 =?us-ascii?Q?BJnobVP0VYG2nEStDyWNPHV5BTrZCjpaET3WovyBhkZsOpxEn+48fv2OtZbo?=
 =?us-ascii?Q?D3AugPTralHZxDob5XZ6Mj/GCIxHPZyFO7qjp91TvqDP+jSY4l+I+7jo7Xby?=
 =?us-ascii?Q?LzWlfZZbtWP0sEehauIP+stGG0t9k4QBXajvJuN8p85Pnw1xrnRsNzS5N3If?=
 =?us-ascii?Q?iSu8CGQxBTz46AWH9UwOCQv/n00Fq8OI3LDrA7RHjfbL3tFcRVgwzBVxk4jb?=
 =?us-ascii?Q?rSgV16vBNVquXcm0JZVa57EQGWo1Qize89bs2TLADSkv3oOLRADjWTuTb4w2?=
 =?us-ascii?Q?OjHNN5695y6nLQboRlBJdBJCqQDdSpgiE9+r5ZrYF/UzIvS95ybtBNttIM8F?=
 =?us-ascii?Q?e0b1ZvwfiMHlneKHehiqBz2gjRchVGL+aLO9e3IWQ3UvlpLoK8BgvwoZQEYH?=
 =?us-ascii?Q?9vhbSKEtbWt6PLk9zIgK5qoDOgE6kLl29dwf+ri9WcmmGS1XtI52ZoITOS9o?=
 =?us-ascii?Q?+g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	k2oiCw4hfVGU4wcTFghmifg+CncplorB9N8Ju7xEmU6KVZ3AES+vZEfs8bghkGr6VU6VyQVK83Vso+uQE5oSFPdFSSErxuDL40o8QrZOYcWTBjbMEPerD4utje2JebOe9HEw09MQ0oYrVGUFF/keFeSQ5FqhwKBp8yCe3W+y0Ky49SjUdKJWmGkF0O2XzTYU4tLBXxJstD31X5VqjjqXMdOvQaNF0dbtXjeXP4GQ/BEea2A3sfZTJ++WqKckxlqpuKjGSaU7pUnAWBVXnCNa2TMqWLTQN/uaW06dKZsM2ZWH1Qbd4lvj+8fLjSTciZSwc9NS0MYxScZpMPZWjc4H8rko2GwNVwWEo9O1J9fkYIkfTEHTY9qgf2ifzQiFL3W39uvYXcmyYnBi4t+njXUz0xGdn2nTecVjkabdt5cz4C9avB9iCB+TbKsYPwdODViVZaAvKI8MCZlxbUSDvB9apAB1dLD7YQJqy4Qlx5FB7vh011WjBR0Es1bTPSX3iR6F0vXjoziraOU05ZFNWCnpYXXK29uKJrGZw7voWQmp6JCLyiHqUIrMH59bU9hBmXK1wkc5R/0VRbMqqkNaSryHVodRs6pg5R2aSpwCmH1D1Cg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb956eea-1ef3-4d54-0dc5-08de110e4aea
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 01:57:01.9560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I7BLUhmfz9XrNJhcmg+7yNga8pYCfrbWP4zyo+8ECwm8aH/JUW9sYmYcqHPDKjJyC+KOwnN54mrFrNCBwKra9oWaEK5eDFmU5DuDa9B/YoI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6817
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_01,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=933 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510220014
X-Proofpoint-ORIG-GUID: 0D78ympwvH-aPmIp_o4cyjg683V86Lpe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfX/1ktUUDY+1UO
 hHbR+VPZcTrY01n0c5m8cC37M2dD0da9owqGAbNjQP6NbSZy9zxeD0hOm3KC7upYDxpKATZMcUP
 VSwOwZ8xKEdkFhg5KWPKz5NL/08SB8Jo3QVPP67M0FCjl21xHwLb39nuxXFuwVLM6zGoKriMbKq
 Lr4LbvpXZoS39ippBHR7Ghzerp8s6w0b+ALsJLsPXjEgY+kgqWkAfvPlsoC/NXiQP3YehgFbFFM
 ZrSR1n8mv4jeSO5J0tULWoEMgV9tqaKd6KmKTM7AEVn5YziJW2f1DRyy3Ik5ISsxFKId2nGaf/V
 RgYglP0LkoBLGT0XL4BDZgh3nJMIeb2vWgZmGqQkk9nCZGw1fHKajUk+Q4D2LB+j9L5PjLKGt0j
 oQOaFznxZk0irpdZ554OUZLPg92nxQ==
X-Proofpoint-GUID: 0D78ympwvH-aPmIp_o4cyjg683V86Lpe
X-Authority-Analysis: v=2.4 cv=csaWUl4i c=1 sm=1 tr=0 ts=68f839f2 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bGhcl90alOTlZ-wd0OoA:9


Peter,

> Improves the UFS Mediatek driver by correcting clock scaling with PM
> QoS, and adjusting power management flows. It addresses
> shutdown/suspend race conditions, and removes redundant functions.
> Support for new platforms is added with the MMIO_OTSD_CTRL register,
> and MT6991 performance is optimized with MRTT and random improvements.
> These changes collectively enhance driver performance, stability, and
> compatibility.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
