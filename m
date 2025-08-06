Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A061805A;
	Wed,  6 Aug 2025 02:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754446289; cv=fail; b=H9sAfINED481xWviFmv5Ms6+FikY279Ywsag8wRwO0ouExa3+tBGcOEBr5fC6jvF1ZlD10fXV2QQgN0PKdEg5YQC3XCYnPa4V1r1FlyB7plXyOX3VztAkLtToY3h5IOnyoyFNxdv56jKGkX8yzybjRdldpAWAK+ZYX8qw89Biqs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754446289; c=relaxed/simple;
	bh=MH0eY/H+SkOeeels1Ev3leC+ZOQxSwkNT+4YxJcsZpU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Ns1nVO04u2EGNGmgRicU2sxbFs86iD0Ds/W77YIJFgCnfT+xGpMau3uqSIltRUTpS2nyMXMEvEofIsW4o7uC9r+PbHaxRz0nG6pX1FbHlg2kGTlPjXh3nPFF8YWHaX5BuWdKAiB1gFR0LoTMV09pvxpJOYCUHjEw+ng9ycF7DyM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=f3CC2Glm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DnZNEmtM; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f3CC2Glm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DnZNEmtM"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5761uQmI028342;
	Wed, 6 Aug 2025 02:11:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Xkul8P5CqNlM7zkb2d
	bP44XSTuSbg23NFLUh3imafdc=; b=f3CC2GlmbrBIHpEvZ6qfoojo1LCIm8+z0V
	1/6+hFllqC+hMDsJADBtxcHKrvtXilWS8rVsu64o85cbPOh6erh4cES7o8Xv/9rd
	Zb7YkXjcwUMdtLFjf1pnS3zXS817TQVaxLbYKkY6tHmA5ocJFxeya4zRUTrBPN5N
	2qgI/G4YABrdZuY3gsU9NGMfLr4eGN/C1DPWEV9mJV5/a4K5e6JL85cOSTagB8v5
	xAJWtZDVx+HwM570EqGp29boyafA7+x1V5SLvZi/KAUx8sYjNXOwRMMmza4YBUpk
	5dPDnywo6N0IIspGtT3nxJYm/vuLHDkeHbm6RtdMK1ORZtU7I+NQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvg0kxg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 02:11:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 575NTXJH005646;
	Wed, 6 Aug 2025 02:11:02 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2085.outbound.protection.outlook.com [40.107.244.85])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwwd8pj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 02:11:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wHuOffdhzFTdLNoH+jtgV68Pr8qGUitkSWSAVq5PGYLlsJRowxybCqL8iXZF0+kpPekt3wPekEGhlcdGEQ9GU1im4YkFf+ON0H7IkgeJs1MiEUzc6I0aeAJYFMoqwwaAoH9+wWbdWugYfJOCKU5DQp6/mIt8AqudzHwdOHFegV7xbnNC0tsgxTuGLR3cmDhb28X9a0c9fTbG8OoPnR2WwRbB7Qjc8ZCWasALZtdGO0FGldlVvd3pzd1GFA91OYVCnCsGQBRxRcHqdfVOhflyYL1lT2qWYwrhCe+rBEOxOtY2LXJBzDN60p7nba5sgaIKW1WAQA9rpAUdaVfeJ4wRQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xkul8P5CqNlM7zkb2dbP44XSTuSbg23NFLUh3imafdc=;
 b=RcK6LT2fOkpuBgd9S/Y6QVPh/PppB3JhCuPPU0cX/cdbcWrfbaMXSUEAGk4zFY+tPHp0kD9Lk7C3fokNJ586UvpUFwdzEcIMEkk6pvkIizdBlac4QXfVafED3wjkP4osDw/ypfB9HUaWoxszXwF4XUAfdMrs4Lve0X0hXQBQVpZ0W4NUvI0nCJPMH13LKmdcr7VOVyATb3wPFYVmT1fTB4j8noaWPdaIp5m7VtKY5iqbTD5dFHYeF14osxbn4GBV46xC/vVl5qrMZMG4thj17kkz3rXbwK4ffKsMAgFW/Icr6UQZ+JiNuQXgOAFzekJcudyMwJBiiS0h85QpzWFtBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xkul8P5CqNlM7zkb2dbP44XSTuSbg23NFLUh3imafdc=;
 b=DnZNEmtM1GrlgPBdWNf9ImVoK6LvmmN/STCIWFMhq4l0FD6w1hAs3X7KZphNOKyubBrONJzc+eWJBbA+xuwPFqNaP18zrH8PNi5VMbVMEWK2wkOakhMlCJOcUtJrp7ykN/g+7PKBSulqqszycvAt8o9yzREnXyJ8pyDNcRWh5dQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH4PR10MB8100.namprd10.prod.outlook.com (2603:10b6:610:23b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.18; Wed, 6 Aug
 2025 02:10:59 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8989.018; Wed, 6 Aug 2025
 02:10:59 +0000
To: <peter.wang@mediatek.com>
Cc: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <yi-fan.peng@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
        <tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
        <naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>,
        <dan.carpenter@linaro.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH v1] ufs: host: mediatek: Fix out-of-bounds access in MCQ
 IRQ mapping
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250804060249.1387057-1-peter.wang@mediatek.com> (peter wang's
	message of "Mon, 4 Aug 2025 14:01:54 +0800")
Organization: Oracle Corporation
Message-ID: <yq1a54db3op.fsf@ca-mkp.ca.oracle.com>
References: <20250804060249.1387057-1-peter.wang@mediatek.com>
Date: Tue, 05 Aug 2025 22:10:57 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH8P221CA0025.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:2d8::21) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH4PR10MB8100:EE_
X-MS-Office365-Filtering-Correlation-Id: fca6135f-3153-439b-413b-08ddd48e7c68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mXRmdhrlH2kNvmfvhVM5coXWrNGOoSXfZTUxWbQS8Kd60YmYA1VSL3T65/D+?=
 =?us-ascii?Q?fpv9qasN/PdAqBZXmAimN4Ud2dIJlLbyIFmqN6OfNRh9as8cAt5P1ZiXdKMF?=
 =?us-ascii?Q?PuQmEwe/8iJR3IVRxTWg1YKfGBgPqzDraZW5vpIpLIKDIRFNW3zDmBR+QqGh?=
 =?us-ascii?Q?IoFjo8dwND/CyrHNcTcMrvUy+DyMxOGPXO63XgU3h67dqPN0xIBA8f4e7q6A?=
 =?us-ascii?Q?TsxSW+YgvwZXBPj6pnW9X62JM8LoXGCAt85VFMMlF7R8mUzw0JWdzG2rJAbI?=
 =?us-ascii?Q?CKznSwFZflrng8bEyGhjQ0oDV+ode5INmqK5V6ZHAsenRiLGf8PhXGhIt/ZM?=
 =?us-ascii?Q?LqQFzKsqSTV220T0BoJQ2EQpcO1YT74n2bKKs9U+wah3w92zfFbugmhQF7jI?=
 =?us-ascii?Q?ckywbufJY3x5y2wzY1FdtjH0LFsY9fpIAeT5MPY9TYqCdNoQj2QPx3JK2tme?=
 =?us-ascii?Q?0QBGt6Kk7h5dopU815wUJbXW3foJDKBOBw+Vhtku0+PDQ/hRko2y/7Y3wvIY?=
 =?us-ascii?Q?ekxAr2jk6c97tJAAdX3vTIyaMEIXJ0NQQJNrW99JNjT3y7oBtxj7Df0pRrw6?=
 =?us-ascii?Q?nkIwLWCyNjk7ZcHF6JEaT5y1li0BPxD8ld/bxmz+Wpt+Xw1PgvRfgw65vjNy?=
 =?us-ascii?Q?icSdlXz00zZnzyuXIunnvhM3ojX7Bu+rtAOfk1D8kMKlKvxOYGHRBjFRysA/?=
 =?us-ascii?Q?HtGamgD07r1z86fJ0CcSAvOLRzlFDqCnAOhbGGEUKrja9N4eMJrB0mP0COHE?=
 =?us-ascii?Q?54DabA/lTVdxivKgEKPQlhRM+2tnBXZ9mAR1zrW6vH+wTEox84LK/xqvW++B?=
 =?us-ascii?Q?Nkx+/r2y4C2M5ewmsQVD0F4ZT4rvsgTJJttq5rzP83jklpmGW7/AoJgGTApM?=
 =?us-ascii?Q?SEu6AVUp+DSW8JwW3jjUkifbD6b5VOAAqH2NjOnG/DQ6VKDKyj5sC9cg1JSH?=
 =?us-ascii?Q?KlZF0LF/5Vfbgysi+K8mgsgSYMs8niBx48J3BddlZofKOxbv7+1NMnrKRnV2?=
 =?us-ascii?Q?ZpjYB6JtedkM9FObKaE+5S+dHlhMdxFdvioYBSrUaNbIkkb/GXCSijbZGc6g?=
 =?us-ascii?Q?TosSikMQFSVi/p4r7uiRsEWn9dSTHUPYE6I9FuxVSyTCAoGx11lXl6yqTgpj?=
 =?us-ascii?Q?X9dTNIHwcjBaI1WZwCIqxzb6EFBso/FLuO7Qr0xFkSeXx8B9s9tIKq9ZkICK?=
 =?us-ascii?Q?xDkkKoymC8P59dLMDWVZCNg6hB43KnS6VXrrUlcA8qaqfw8z37p4GSe4bq4Y?=
 =?us-ascii?Q?H6U1fQhFl/kUY+xccfecvYM45dGiNeCtY84N3F/pZWPgv0Vs1FgayUQeT5uR?=
 =?us-ascii?Q?VvkWum357stKtdcjgKyPJWbsrpaelv3rbWDyqp4ZvIFmbYkcQTNz2/RHpTkS?=
 =?us-ascii?Q?FkMGghIfCRznhs9EOqQdRIUQffhFgDOkSUZgC22JUSMAJFVfN+hRzPBz4OdC?=
 =?us-ascii?Q?htVqj640TB4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qdfvjGRtriQO6GZdeQMjW4C99QUnZ1kvqbtx0jgilNT9kjoLFr5+8i9FWykr?=
 =?us-ascii?Q?0y0YFfylsGg7Dnvtcy3RwHYduXjl26UCW7U3V1uzl3DCpGCizRtbBytLM/zx?=
 =?us-ascii?Q?/ZB01bMmoNn2fnl6TqqXEOh2ImsnnOcU95pjUrRlOtN8N7BF1eZYOnFkgSWI?=
 =?us-ascii?Q?WGJwhOj4IbkGhNK5tJTtm0YbGlLxA9WgUFv7n0jmFDIdZ++ICDOV3nlC2NzQ?=
 =?us-ascii?Q?VR6SdfwsjwFV0uv0qvqjMmTbEVZrsjbbNvY+imepTF0oWYEhmPlbQXC+7H0q?=
 =?us-ascii?Q?XSy0s8qYZm8vQqOZQOHlTlaVJWbF2OyANSNg7npJLfkziwgkKGXM+YC7sUoJ?=
 =?us-ascii?Q?Y6Vi3cpaQnNPQxxfpEOHDEChRjWtHZaSCHY4/nb1GCHkk9jY8AAfAEqnFfLv?=
 =?us-ascii?Q?7VlI+wZX3ou8U9gP/x5xYa3g+aEHYFNff/CWRMN/8k8aHdrlLcwiKB0nnLEX?=
 =?us-ascii?Q?Out7LMXP0Xan+uV8zktfpqfQUBHvTKmOlvR707hOfquQzeVs7OmwAklYJO/g?=
 =?us-ascii?Q?49sFLcT7UH5M1hxaWeb/UUHjkfb5+IRE7e/amUiJiI4IbkAxRPwGlXjGj86d?=
 =?us-ascii?Q?GrrKh0khlD1kMXRE1bDzCcGNeTBowo2zk0qSgEd/A8k5JKSJ9DtxK4SP33Mi?=
 =?us-ascii?Q?sU92MkKowpVurPs6fLSBbmJvAH7EC6O9XAfy24pm9cnQb9hj/Fz34OBvJulw?=
 =?us-ascii?Q?np8W52qsEMfSHjqvjgg2UpSP79f/d0wBwewGtOTqOCAwarLUdJJgB/qyy0ue?=
 =?us-ascii?Q?ZuBU6P7qDAB9HGmblVNGFxeJe+vEOf6AMrkf7ksvZJlz9t+6nEEDKMXcQxLD?=
 =?us-ascii?Q?taMHzXd8EQ2c+Dn148eCc9Q1Ip7sbCErFCJd90ZCnYJ+TOq64pMqcECrP1v+?=
 =?us-ascii?Q?d/QuhgDpNhPf5F5t4uq6gy13C07CzEepGD9EcqoYuA1oQ5cmjBYd65GnmQPm?=
 =?us-ascii?Q?QrcyH5lE2HiXqm6QkTcmew0jqaq09VpLDfBNZTEfO1R5je9CmYG11QFzLcVo?=
 =?us-ascii?Q?8SNAdsnEorGZGt3EeNXLDC46ap4UDC3w6wLMcObd9itn5vdEpLC7sBvQ0BRk?=
 =?us-ascii?Q?1NzGF7jCX68P/9Z//vl4y2TJdqynQ/4nlVYHpoFJPxXo9Z2mdMS8aXyiYloA?=
 =?us-ascii?Q?XwrE7esGFGKY7bbwox1KsaS2x1ga6aHvFv1Jk09w9Ak4ymxTk22ts/Ph5jk7?=
 =?us-ascii?Q?/lABz+VxhltMKIIYcorGu6PH60Bs/QvDtIy0Zcba4mTeAB5pdf4TbVzeZM8P?=
 =?us-ascii?Q?5e3XWAxYHOPj3gum2wDQpiM2sW6G92QJHa0H4YNQHMLNtyPkMpCU3l1PoVxn?=
 =?us-ascii?Q?14DSqLXXEKQeGPIUj0NM/D6O4xrkARmfat4BgE6Xn55jQ7bf5mZZJcOIx9ih?=
 =?us-ascii?Q?byQ9YeUQOBi5hXSrwmstZEL7j+HReAvrtPOadtBAtqR88XAVe4UERlWn/xuC?=
 =?us-ascii?Q?zGtb8MRH7viQee+5y9TmSzF+FBVTdaR7uk9haFhDV2W//0V/5nrA5N6HcC9b?=
 =?us-ascii?Q?N0wQOgdQ4D+K79k94HCAeAopBqztRmxvlkOs7H4lcBZBdDt86fv9od2HHToG?=
 =?us-ascii?Q?ufMgj12MYcP1899CVStySjpbRpsA715m/lwxzGA7G5g9wCoBTZhNXgOsBtnV?=
 =?us-ascii?Q?gg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mE+8jBcH+QS1BIRd2fHegeXTE/MeDh+iAl4ZNb6pSMPnISke2UvP4XAf6smZHQfIO717tPWNIiEoNrTa+5a3pgH7vKY1ILtNiCthtAZuQBlvO2X/iKIjcwtC7FWZuBvcOU57TcN+HPmt4FoquCvUnz7UGtRf6ck5EaWwh58ajBqQzD+Bs9vjjzO6TfDBd8ZGBbzsNe9BKWpm4XA4SiH9rL24LU1CSOpMW6vApTPqrwO8wnog31L7GlsW2j5Jn6wgxF0yHfgJCgJNuBFc68Da6zfmNukV9er0zlVc15hOGtdPiEMZD55rnaJVrlmvImhBw4h3mS7bpk0To8p6X53v6+g42i0eH16XIfGc1F2dNwI+HJiTYGKnlqAEGFpPTzmlA2hB1rj+M9Krfoy1iz+Cb6XHzBlV1unDAC2bS4QbPIQulB3nmlGRSkm8nE39G8a3t2/r5yiRc0h19f1khGDseg367q6kP+wwkum2tRxG7aaRUxzRfkeda8ooVuuI68L3v5IRt4e8r8ZzGXVhFPNLeGzDpjjDy8K3SG8AuSG1L/fghqdommSKWz8SdB3uSgQY0UdOqwZcxy/NM7pSc5grHoH53BwcjMjO/69t8KiDemI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fca6135f-3153-439b-413b-08ddd48e7c68
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 02:10:59.5458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UFPDNE8z/5eOyy3UQYSSHPF6d2WLiKvPmxZ+Lmh8Rpzm0DG5fNkJHbEza/5KKpm8i3+8XN9LkhAjwdxgCP/n39hL6KnyB3e8WquyPxSvTao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8100
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-05_05,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=804 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508060013
X-Proofpoint-ORIG-GUID: XdW1qaVCjVjF-sKFCIkBklOaUo6WTfXg
X-Proofpoint-GUID: XdW1qaVCjVjF-sKFCIkBklOaUo6WTfXg
X-Authority-Analysis: v=2.4 cv=QORoRhLL c=1 sm=1 tr=0 ts=6892b9ba b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=cewXuGIsSzsw8c2jRYwA:9 a=zZCYzV9kfG8A:10 cc=ntf
 awl=host:12065
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA2MDAxNCBTYWx0ZWRfX51fONMmoUO26
 x3bcBnl/oxyUaaXoGxL3kp9lbm9DWI2kOY29gwGNfElMl74WmznLBpJH0c/IwXe8ZMQzuSmpO1/
 7o07A9Jz9Tvg5Rq/SX4wJD4XvI5PgywQbnAQrkA7NBpwgm7t3iw046ZGHTdWVWrxvszveFWG+3W
 uB7rGIFl1WwDG30knASDf/F5FsCOC95DdgECzx41dl67hJupNuwIPhLlm7WSTHONNy6vN9GykFY
 lWxbHjzh0gm9kdua6a4dDcY+jB7iqxv9JFSukMPg56Y83MQz6KNrUGPI4MlTBfnq7YT6MU0XDEj
 +IKtjSUvQlFhJpvw+PdVZEuForJFfUNUocM3zAWSKH7Umza/hq4GK2I/S6mKqjThWezRX2J+xQf
 gLX2TCMypzgBBlGlXNrm9tVUa5Z4vXHSrjfFrcwnq8Fa+PN4TTwK6iGKmf56d3mwWwoNbvFE


Peter,
>
> This patch addresses a potential out-of-bounds access issue when
> accessing 'host->mcq_intr_info[q_index]'. The value of 'q_index' might
> exceed the valid array bounds if 'q_index == nr'. The condition is
> corrected to 'q_index >= nr' to prevent accessing invalid memory.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
