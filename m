Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE82B1DC07D;
	Mon, 14 Jul 2025 17:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752515072; cv=fail; b=DLTsTSiMHiZjbYUT23c3b+rOqPFPwW8x3Gn61OWrqIwMWAOSG6b/wCtEY8hQmC05KqvK3h3dvAWWscx3dMtLzmxBM9383uMk1ygGKiZLQPhtbJ/Wx4p6EvzFf8BpqN812i1c/B7MUymiEl1/2kQ3N60uwWYVGXK5YFeFu3ozT5c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752515072; c=relaxed/simple;
	bh=/EioSfzLJVttYX49C4e0AaXbKmnatArGJnuClU9oi18=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ZZVccuPl2dNAGExyWV49IhoOuT7pax9UGsj8CrbDvduMgyU0LkK4df6DCuLo4VkO+z+Hu5pKtmWPl7e9auhO7PuKjnmggW60zttasyvEmFSBXsAn/R5J8G6V0YRPfBVaujrzbZZZVeOZXLLPvErOJN6m9UqA2phnZvFmOq9LyZI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CMO2J+FA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=n+5rHip6; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CMO2J+FA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="n+5rHip6"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56EGxj5B018795;
	Mon, 14 Jul 2025 17:44:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=TRsAtIvnB2uuEeFWZ2
	uuWpx9rWmImqhJJbLsIrSoQa8=; b=CMO2J+FAESztP/t8NC9dYHuBzi/h14huQ4
	ArsBeIKSIo33EdkEN0zyRaw5HunDFxe/RENACnYDWqFFghfUmEcMEYb93TtjllOJ
	IzJdF0pvxbiSF5alNAtn9jTWB1u1/pvR8wevFQUXnIH5IKwYLNJkTkPrFSSMbtD1
	2MJeWNMLRIM7bMzy/OjjbWoWp6iBx84PWSrTgFPibYzhBlayeMT3C2DZySDT5cCy
	L45dVlQYyosss3F0IFooRX9n/iJoRbIC+oWSL1GCiciTpJGxGUkQLcvMohI+PZbS
	ljd93hQ48MFLDVUYQreT+o9fURkLEatJORbwHYoUuVABHNDps2FQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ufnqnjq9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jul 2025 17:44:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56EGh4U7023940;
	Mon, 14 Jul 2025 17:44:09 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2041.outbound.protection.outlook.com [40.107.94.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ue58v3n3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jul 2025 17:44:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rI69q3Htbcw8YQaCUaw+9gyCXUgK1ckmU8jOxv+KaEPtK4doNz2ZN6Mm0d3kBFTqp4n9tdKgdj6CRv47e26CR0PDF4BybGw24EnWbcZG1kZ6QKN1oJnDW9W7ua5jKe9PpsWwitQ4KuUDv6jEUPXRbX4ZHUvyeO0FafOOIbZIVPTVKGo1eF7UXYQrpTgvswsaYrQ0O9KNVLnurttovXzHOjwypHxza5D4uvR+JeJz4zRAx2kBPfoYka84rNoXEkMBmuUSSR7gc7n8n9tYb3Idl0drIjUaNbDgsq1XzYrduJEaHNnirvFFQGmrrCO/EZiZR5nQDcn8uxWC+rHPuMJVyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TRsAtIvnB2uuEeFWZ2uuWpx9rWmImqhJJbLsIrSoQa8=;
 b=uwTDAzFRPrXdua1Wyk4zpoXA/vZP902gZDlrQsZCxjaaZBITgJDhQTb5MwDT0ys9P8MrIGV+bnRCMxWEpg8Wv29UG61zvJ10IJ/Fb/vyqCTBxPW7LvBlWX/oJZDLiGPj6nW9zSELFW544mTboTZMpfpP3mZtO67RzMRZOh4zLNfM9cfHLioHPze8LKLmta8UBUwQdJ7cvuOaMs31MK9ECg+JFyoc59IQ+kPrj1uOm1n43SvZONO/s6Ky4yZX3SxgNgzUB1PWNH30XSZV/c5UowmGYBvI0G+l/eY8w4F46P3kcsx0zI07jQlMHjZ0Y4WIgMCgAVessFBTMu8KYXO2xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TRsAtIvnB2uuEeFWZ2uuWpx9rWmImqhJJbLsIrSoQa8=;
 b=n+5rHip6AR8P11LC0hJhf58H9lK8N+vT2iOGsdzM4HTP2qFY/pkcjE/lh/ze1lvUYkJY50t6yzpu1sX6amhJwaT6rhQOJHMfK50UQOBh8tmKTJGIntBN792zXg3FG58ycsnhEQZg3U51jFw+CDM7QVD+7lQsx4XlwZp0vBHBUDU=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MN2PR10MB4302.namprd10.prod.outlook.com (2603:10b6:208:199::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.32; Mon, 14 Jul
 2025 17:43:53 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8922.028; Mon, 14 Jul 2025
 17:43:53 +0000
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "Dr. David Alan
 Gilbert" <linux@treblig.org>,
        Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: mvsas: Fix dma_unmap_sg() nents value
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250627134822.234813-2-fourier.thomas@gmail.com> (Thomas
	Fourier's message of "Fri, 27 Jun 2025 15:48:18 +0200")
Organization: Oracle Corporation
Message-ID: <yq1y0sq7jnq.fsf@ca-mkp.ca.oracle.com>
References: <20250627134822.234813-2-fourier.thomas@gmail.com>
Date: Mon, 14 Jul 2025 13:43:51 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH7P221CA0023.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:32a::34) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MN2PR10MB4302:EE_
X-MS-Office365-Filtering-Correlation-Id: a689b576-d2c4-44f8-8506-08ddc2fe0015
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QKFbR8dQ670ajgHNaSuextb17ZQBnEyxTdkI+IViVES/4KhIvwO4IxBSinsQ?=
 =?us-ascii?Q?7n3BtOZT7CfW5kVvuDkfODO4/BTY8xk/98mUHXfRRDkXelp0qW4nrMpPrk9X?=
 =?us-ascii?Q?JmDon9+47Kd3TQH3pEZq1J4yKVbmdIFZtsGAJAPnLSBeZIdc8udBoxRlMVfC?=
 =?us-ascii?Q?lxPgPvS5hXbFKb5HlQgBm4TLl8ElF/DH7gj0kvAztc3h0v86sk3Q1c7gmyla?=
 =?us-ascii?Q?Mxl4uccqiCDFgckyZL6ECLSYEoyZxR3It/HZkvEmzY/ulWq7jqpQ0DzOsyhZ?=
 =?us-ascii?Q?BkFbJAY3lmrJWJ9fX9YHmXm9WZqklJKXlkJdrdd4N9+EFsQP0fYn0rYvzYse?=
 =?us-ascii?Q?+u4hgIpRXNaq7emf2rmr2mJbSPpu70o0bklw1rv8+yfl6Cu0pQ6TVj7jCYC9?=
 =?us-ascii?Q?AMv007A0lQWvxr/pQbn6cNBk6yVzxgMOGxuUSSzJvnnKoB/0bVyuHMeVLaNH?=
 =?us-ascii?Q?W3P+wWaOMVe/HAdJL33OXcoHKiPtFx7NuH6+G9AEFPlFaiOuaKoabhsYfHmX?=
 =?us-ascii?Q?ltWhlHWhvRvtcvqhNVHC6tJUokQr7LAGp1AJbutvyvuNxjI/l55ZHDNJiKWD?=
 =?us-ascii?Q?DNWhQvDYtijMj2i6PwJTgqRC2AS0AzcJgeBScaKbSixTJkrep6xuQekV9WDo?=
 =?us-ascii?Q?TmwtYJ1dMdxdPUY7EY0Atc+d7nmMDSzO8yWBhahJgKuD36KEM0rd+a8NTMcc?=
 =?us-ascii?Q?v3wO7qkUM/8z98E+Udo5IErRQL9weDeKGWh0YOtIdcBbcd8K1sSHntydPTxE?=
 =?us-ascii?Q?cjdYN3zHWWDBn6gvYA2yJkb1tc92UQM4Mv8LIVtv84nER8t4CppeNLcKERWK?=
 =?us-ascii?Q?jwRSI7GI8r9K02HCH9vd/ih60XL5TFNEAPemEzBQGR5V0/kTN0rXO4W88+LN?=
 =?us-ascii?Q?YOfQl9oAyOBugpbyPWjm1ougkbsw1a5lWBzlB3kkwkVc1zb0mhjFrz+XY39m?=
 =?us-ascii?Q?sUJlRbKB8fZeMtIQVYTHgArrfm6lc180qVoahhy/UGlxluF1lznRHXWHqt66?=
 =?us-ascii?Q?yer59iTxbrdK+oFAJLDezEVPh8oddHf+rGwKwJF6bxeoqgw+69Wkt+f7Q9Ab?=
 =?us-ascii?Q?CD6quUMrTViKYktaA0RYvp4etACTwl9rgGV+cUZT5KYatzKYkfR1wdakjyPB?=
 =?us-ascii?Q?MDq+ct7JXMhscmarRf/1dBKTaHV4xrt9J7IJcs6QTvIn6KhhqsBXLCJHPzkU?=
 =?us-ascii?Q?Hzp7p4nx8LPZivo6Adt+bcH+d//u9DZdTdmjJMaBwgd4eG54L7poZ7Rcf59D?=
 =?us-ascii?Q?J83kWi2MQdMOluxuGaRx6haYhZhKCvxUR+HTZj/vSiUZux3cwHTq7d5/GPNy?=
 =?us-ascii?Q?j+lN+PKuYlvl4Uv1UeVTS91xNTTv0/a6LV9W4tDqNZswqIOOYDzRpG/Vilu8?=
 =?us-ascii?Q?ewNXOQdeg45yf6ufxK1Fpk5xYVkL3iJvE8euWIWMj8X7KiDoYQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UeQ86kYQgoJobAOLy1cdawHO3AbaNIX6436ULp7TcdcCX3eeYfrsO5IBEqMA?=
 =?us-ascii?Q?zxRtxXenXD/3ZjKLUHWmPOxCZnmSejFS8N8zBJlM1WuaYeEs/RwTT+VDyQjq?=
 =?us-ascii?Q?kzzRVr/2KLpIZ25Peu9qSZZfZFaXzRr78IjkNJxacnIA5aLO0TOfN6fx+YQI?=
 =?us-ascii?Q?CqLeLnsUj+Q0g3Qq1Lnbqzwi6cwrRC7qQvVhw8PMU9vMe8dgJMzoNQQpouCn?=
 =?us-ascii?Q?OxhguBcR89RVRBTJlXlrqkEsEs2RW05Ckitpsd4E6xc33MHYtLRpVA9jI1VE?=
 =?us-ascii?Q?6tbgARN8ClAa0+DaVbMmph8H+UAGd9d/99M60dP8f/Y01kIVG30cpOgKPLe5?=
 =?us-ascii?Q?7/J+DdOwblB/EU8gYq46F3XEffHZKWja74tIZjF6UzjpDBONmLyWzz0yiqAn?=
 =?us-ascii?Q?pieba3dcuH3Vh3Qe283X1PQsak1jWinxGmVLG7uhTztxP1GYDgXkApoMMLMJ?=
 =?us-ascii?Q?gGQs9CJdE6gm8XyewgPOe4JCuYZBLYXchQtg6viuuX9SHrb4jil+Rt8xFks2?=
 =?us-ascii?Q?jG03Re7eVTlzRmEUj5JGBFQDTXSJL8OtO188avlUIpMegby97NvD7zpIc4sK?=
 =?us-ascii?Q?u/JaHYiXh5oe1mdsNFurU7B/xDkSE2yjVQI/+lxe94rhIA/eEDIma4oAOtSF?=
 =?us-ascii?Q?pf094kf9IqyM61/35JMvAiaKUNv9rXzzcuHQP8a0RkwQOe2W4ZIIYIG35psc?=
 =?us-ascii?Q?RoEMWnUEcDekhJRmsnqRmgbhuM1eKtPB/D79iPxVRFRQQ7BE9xSScgXmqX7m?=
 =?us-ascii?Q?HL/ATlj2dquxUIkmO+/1XupCx6Mbw+WcOBMX5E03o16sewpxZYgzZR5FqfmO?=
 =?us-ascii?Q?mkzEk5h9t3vy7qfMB3V+G7zA7lUXxVfhxdjuQKVn4XUM2VD6XZSBK9duvKmX?=
 =?us-ascii?Q?nPJYIBnK1MaRYYQTuTxvHD5xAIOEi0wB8HHoicqZSv0k+3kTxkhw9ZuVJ1uk?=
 =?us-ascii?Q?iTonxh5BzRIAWF1AGqHfaJzSo7yAhVTINmpoWNMr/69psAcui3h107mEM9sA?=
 =?us-ascii?Q?ZEnVIRsZeo2C8vTFCaEYwq7lrjmg+Hj+XG6EulYNOpjweC9WtPv/cnuN9akr?=
 =?us-ascii?Q?dVhg+jD+4DxsRK11fttENyEjgBl0n3m3wAu6Nzf6NRZ0p6KW6Xeap+0SUp3J?=
 =?us-ascii?Q?sFAPrEMtjN8jxM9SfHDhxHlpew/6TLR3uSRoPYbv1HtZbKsTWjlpNc4hpCSJ?=
 =?us-ascii?Q?H+CBJzqX0Aj/9uIlfAGRQYOA186ZgHIQjWTGnFJpkkflzOj71JP209Roozc4?=
 =?us-ascii?Q?+qeNZk4AeHvJ6qPevSVmDK7KrwN963AtGCWWHv7oF2wAF0iPNzJTBSASWRpU?=
 =?us-ascii?Q?X/zhwteI4IT9GEfH0xrNEGHgReZP0UC26kQhWUBGjfHpT/JCW7jLpEhb/cOQ?=
 =?us-ascii?Q?Z2vJKCc2Fqp95csLLdeAPAUvRdgwGj90yNgfmi31BBRBAB5Jz5GA5jqwsfU4?=
 =?us-ascii?Q?WaHlrM5H8ICMrvLEocM4DRG4mB8ze7habr/7fI3H71FjJPd8RyrJ5t175bje?=
 =?us-ascii?Q?G1kg0cqtCxDk5sLVhFQvBvb7KhpbcEWbNuHaiSjcj7mTA4Ee9NV0Ka5YVmWE?=
 =?us-ascii?Q?iq/9FnRjVmEwqWsfJwXjqvoyL+7EtEwnAJltM0l1t8AASRqCKMK3zz2BmDBD?=
 =?us-ascii?Q?Cg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pcDaz5wuP120e8Hv9B8OYqXHwg3dfca6qhHLa05vr7dQhbmqS4admyxY58pj+Q2qZWJeR2GgftsBVuan3XmKutfv0ePT78/VOZuydS/3JuEDksBPvxg/l20nqEK8watK/hHOCKGzfOap/UGOftoZn4t7foAwMO01b4LIlxFPu21hXzR8p5Y0PimuxIk7LLTyp86nqtxXdwkYxSE3LwAI7o/wT09DUZVlXH1Q56M6xi+eFjVrnB7RHvVT5P8LndNL65wI0R8akrWqqYFgDCFgA/TqT2iikAO5kIp3FG7sYnsYhH4olURS1tlSziOeNlB8nAnPQ8b0r7R3R0JGoT1MkbbgOweJyZiDoXRb+HcXDaTCenIkTNP9JONmA9yDYdCnXHsoH1S+MeRIKWckpPQzofnNza2kgiS9Oveebx+e37ovC6jPkkfuRWWdC345e/0lPHQ0HWqR6MLqUTGv+h1kAHurwOdauv8n3b1ae0rE+3lwMiGuawA1xApUsfswxL8+2kJMoSWhKcP/Jg83FfmhYO3bp+3huPSKJo1h9NHEG3BMptOnpswzh+bMuxiG/Z2zCUBZmkjlJQdph8fKvVLXKA/LyIF90bTpAHuohlKvUo8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a689b576-d2c4-44f8-8506-08ddc2fe0015
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 17:43:53.6777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mjE3DCN57IyHBcBb/4Bb3Ae8BejTZpq81yTLlV0kECG1L/+5JcpXQOfK0pV5rqncDg1kSTsGqT+63IKUnarLmRGfJKOQNascNnABWCBKj3c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4302
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-14_02,2025-07-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 mlxlogscore=602 malwarescore=0 mlxscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507140112
X-Proofpoint-GUID: fRGy7Hb8ag6sgGD5Tzk5X2yiWjBHpFYc
X-Proofpoint-ORIG-GUID: fRGy7Hb8ag6sgGD5Tzk5X2yiWjBHpFYc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE0MDExMiBTYWx0ZWRfX+NeWU0w3akE1 epQZ6cx/JKE2mUd/eODUD2ajiuWcSYknAYE4gUG3PITN5WEZMaP6Ufx70W6syOL2XfFeC7wz2Ew 3USYR+3B6VdaTtcUhPSFkpNqNDs0qBaR0txMaTKYAsKTjFsBNd5pG7mtlB+Hj2H1BRJQ9EreUvw
 V390mHNgdZ1eS2rwuoXg3YxQaVUj19LNB9hppl0jtKVHf7mDzC1tYf7w3ahcXXNXsb5ihgK6Tem LMDyXf0YeV9isXIVQTRHTAVnylbN+JUO1aZ4Sv5pIkQFQzbCgALATW+DezAP15hXVeT9cPF2COf g3ivv46FeobWMPKSMquduBIyI4JCqabEmf8fo2ZqdXzC0nq+L+Dk+t+Mld5jaUVlGCaqTvYj2s6
 z2iGL9CMK8I89f+Q2uzBg+mTP6Q9cFwS5XOLluIpGM6ZqglH29NS47gBq/zAcjPMAgs19QUA
X-Authority-Analysis: v=2.4 cv=U9ySDfru c=1 sm=1 tr=0 ts=687541ea b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=cm9y5QnUeDfAKpJ_UQ8A:9


Thomas,

> The dma_unmap_sg() functions should be called with the same nents as
> the dma_map_sg(), not the value the map function returned.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
