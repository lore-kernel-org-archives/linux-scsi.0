Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6931C5D77
	for <linux-scsi@vger.kernel.org>; Mon,  3 Nov 2025 02:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762138117; cv=fail; b=ZO4sqelbioi/gW8kldLL7hgbRfv8PKVPXCkgxg7kje8NxSCmyS4OYCHXgBN3Rw2cfGzZFy0efG1PtChOFoMWAohHDLoK5shZ8VDixSC6AzZoRt9voE3GkMtCPtbypri7+mwFpBGXxbHhyu1tS4358PubsmK5YdcNEl91pn+QMn0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762138117; c=relaxed/simple;
	bh=TRL0TpEvDfq7wBjC1zNjPPWVtXdOOjJJD1lv6BSvisM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=bbv1gOkGJ1p5fQbFV5SaJUwY7M6DaVl9os+dG6Mx9y406EK3uGM6v8A0dMmTuMzSjG4FctiaPT1AGKmOPFKVhrhWFsjykeVjSeyANDAOl08vfxENl0NAvXrsNAxp5voCmCiB8bDvborEPiIdT5M3DnJwiqSRBB8/kEQ7mDGIB2E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UYfeG64+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aQAxo+Vt; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UYfeG64+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aQAxo+Vt"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A32U2JT030138;
	Mon, 3 Nov 2025 02:48:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ifKTTuDMO8/emtTYMK
	of6+iCVpl/t5n81N87HXOnHFg=; b=UYfeG64+mT7MBSp2uRNMPD2m1XyCbtZdrW
	idDVOCO3VrVXtVa3c94HFdW9WjbQCSGMkas5wWUx+oBOxeByBV83vULVL5Nf+u1E
	AxP/gBl6VmkSVS3D4JztGYmrCMhoEm6TZy9LyKlaqlo/roZ1JCpj/rMQ2KrB/MIp
	+gyPvVG6qEwgp1Mo1iR9uahRA0KxrhikTwbdCuWWATjVqwubN8hsPqq4NzoqKmxy
	jZF8okKhtc+gxDZg1EdKNfuyaWrte8LOfS17QmEiQ8aWZtaL3URPRu/w1uffgwkS
	jf0bbLTAVWBKFxzfCv1xFPf8s4UbMF9HltcID5a243agP9Xo4H2w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a6kncg0tr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 02:48:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A32is3f016655;
	Mon, 3 Nov 2025 02:48:19 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010000.outbound.protection.outlook.com [52.101.56.0])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58n7a79q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 02:48:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W0wkgacx1dD7n6/7Pb+imdBZ7FzLn+xcoj4SVNGrGmSD0dwlX1PRZ/WQOuUGXfff4zbASCrC3KzfB9mBG04zUhya85xLjqPaT26TqezLaiie65E61bp9nHn1qmD0zZm4fYi7N45buE4LSNZVL0wz1yGgO3oHKlmXYZOKDYnAytooGfqlKHQQQuLVEWhG9tervf6zrdNVty0U4vKpLAx+seO9m3H0J4LCXsb6dMMWEux3Z163Ihz7WszMOSHJPKX7xa6RaVz8elTV24VHjD9jn+8peA1EdZekrnpKwHezMv6Uam8mpSPT6d6SYDVQR1YInalusiUYod+veyDA9fHZlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ifKTTuDMO8/emtTYMKof6+iCVpl/t5n81N87HXOnHFg=;
 b=XSYLdI3zee0EhS7RSqb505oksT5YsciF+vL35So0Oz/mIHP84NcxPqltCMgKtjZth124Grf3UgzXTRwQUHVxg5P+q3B0l85RQGqKTLmmgdfX2dxWIgY5ieHyRbWkR7pDLPM8hI0e45+U0VVsmwk7nsCfPoY8P9o1XQbLMviTStdGQmIpVE/HdaeHpLi2VPNV4zHaxcwLv/Dy9M2/sbCYU7TslETlfNH0207luqm8TcSbWpc1AIESMcjXAj7I6v0LAONxKrtNpRoIqlyNxPeac8M4havEhzL+lpPWCrOpOHJhXbH8AXH73pMGlElTdfVbkVLgmOpVc6uFObbGfgNJnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ifKTTuDMO8/emtTYMKof6+iCVpl/t5n81N87HXOnHFg=;
 b=aQAxo+VtDPAHBL00sQ+nP9RZTSbbzcIKTZPn1Zm7oDCWpidaaRjIwgIQrkHqqr9wAYTSp27pZ4fUW618EmTTBo3QGTqN9cA5ZtUn2uQDbRcJpLoQBZ9AYXDXMDHZzPmE3TJelnEMRCjNE0GzTyIBKPqWRH9eG86Prqv9/lXDHKA=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BLAPR10MB5027.namprd10.prod.outlook.com (2603:10b6:208:333::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Mon, 3 Nov
 2025 02:48:16 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9275.015; Mon, 3 Nov 2025
 02:48:16 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 0/2] Improve a SCSI target configfs show function
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251027184639.3501254-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Mon, 27 Oct 2025 11:46:37 -0700")
Organization: Oracle Corporation
Message-ID: <yq1qzufsufx.fsf@ca-mkp.ca.oracle.com>
References: <20251027184639.3501254-1-bvanassche@acm.org>
Date: Sun, 02 Nov 2025 21:48:14 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0075.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:84::10) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BLAPR10MB5027:EE_
X-MS-Office365-Filtering-Correlation-Id: 48b27064-6116-4592-9322-08de1a8370a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?duU/UNSqxBoyunfsAEtcCdBWkK1nXxt3C6j+wLDM5vrKXVGWNvcmU7l0ihag?=
 =?us-ascii?Q?YJ15dxIRJw6ngHT2Uw7QJhdpPpqCqEkJK3E+GgfKBIx8c9fm3aDUfFlik+l7?=
 =?us-ascii?Q?KToioxstcPwN0fYyQG2YbG1ncyLunmS+MtRlJhixyaSL65aWJ84F1dvrgNWs?=
 =?us-ascii?Q?BZM8ysJ24rZhYBTTB96p3LH7ekabxIuJz7IzwfARWyJSF12Am4IVvI/vx/2a?=
 =?us-ascii?Q?hFLuMXvzhtvjvwQO58AzDGar0Y9kffNQu1MmQmpt0udPYfbKERXgtmXYGg/D?=
 =?us-ascii?Q?UuYtQJL1fleoKxpHzygVDvP1vCLADyCAnG92Op89mdDQNQGY/jWOhPopRKlZ?=
 =?us-ascii?Q?Lod4mSgQaXzJNt4GMa4tl+S50sVsVggjRI+c77AFUFpFCng+q+R0hkxnVLvf?=
 =?us-ascii?Q?q7RoSydGsPJR7Rv1IvkwInBigXN6YLY6WEhfG7AyDdOi+L5QF62+q/GQxTX3?=
 =?us-ascii?Q?/wA0sXc0INxbL3BqWO8iUI1ueWXNc6P/Ro6JVBL81qhyNqycKrB4BqeEz/Yi?=
 =?us-ascii?Q?Y2siRCWPbGDkH49nw4EFIWEp3PF7wc1/VWDU7DoH67We06QFe2ApkGTybgBy?=
 =?us-ascii?Q?tprzvVrPiiJgiF6ZyBxfepF0SjWkDwhL2Gw7Xt3k94QjSIjDhqp0PlWO6wv8?=
 =?us-ascii?Q?pE6WIUHS47pf5hEyOsteLV7o0qBzylu4s9IJtTVEDidhP3pX1/fc+N4yaihh?=
 =?us-ascii?Q?0qd0oD5Gkulk5rB8uSjHy5Y4RBEUVbt9DZs+SEBj8h6D30v9Q4ZROgFPLwxe?=
 =?us-ascii?Q?TEUOsm6pG6NTYrCiYeWofLHCo4mR2fhQ1hPMlkljczDV0OmDT5lwZ2HHui7w?=
 =?us-ascii?Q?e3hGzaGTFfWTGHT58CeYFAcfFvspMLSfmLwGU4t3qaozCVorMS2L47DnmnxC?=
 =?us-ascii?Q?y/EtcSo82sUNekd735KGK3rd69sYGyBjphBWEj5xctTuW8unwwKR3w3vSmuH?=
 =?us-ascii?Q?7urrgcj4kkp2wvSwSZB9vOus9dDy3XKaUE15M630ff2IiOcTlysn9WwfCLST?=
 =?us-ascii?Q?7axIWxWKu+xfEsYBv+IlzjCPXShUlkTCNIP/GQpOq+hRqTQL9dgwmlGdyWb3?=
 =?us-ascii?Q?02hdDCpuOUONnP1S/v3Rz00zbtGxpdR8jsDsTK1eUk4CIUnVD6sqVfm3Pmi8?=
 =?us-ascii?Q?L/I9AIEY8TPVFCcH7iKpZLccgQAyBQqy/ErDMQIdwlgVVN7tczVM8KR3uuFd?=
 =?us-ascii?Q?hExmhOcbmsg44lNeT18AGmjbmO0Crj9C3StX+gtAuGSRxh/a0OTYmXr6S019?=
 =?us-ascii?Q?8B3oVs6b0UZrEuJIGMQO37dsMGjnwjFIHEXXP1/nOxF0aYrofRtwX+eg9oUr?=
 =?us-ascii?Q?W2MbZeFKraFK4cbPxViIxyO9vQHlge8G5EbyIp6Lm7Rc+dUXmTtXdVrVLGxH?=
 =?us-ascii?Q?W2Bz7Y6MBaSeqP/BGqW2KGkIKU5DFWRiga6IXKvw9+fSGTa2bjSkgq2HuBFI?=
 =?us-ascii?Q?4cAheGjWpeAKx4NSKtHn7g9hJXsjiZxc?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?b3HZHYha90v4jF15zt0NjfF6RqueAoqRzFFG7XOICf9PP3oxt6uxqI+BE+j5?=
 =?us-ascii?Q?G3mYua9mY2KLQMZ2wr1Dwn9PuiW+Ms9kx3/6AdTWWRIQRm06sTap9EiBD0AY?=
 =?us-ascii?Q?1DvVU/zvXEVhlc/K6C7HlmI47aXTaSyBCgZhiMbP4XpU8uF22p4VQ1UX6ZhB?=
 =?us-ascii?Q?GIP+dO8WBXGJeJhZB9CY5CRJk0xFKFpUaEj5imwVLI0jNQS2kPzlxmkO4CJH?=
 =?us-ascii?Q?bVBedHEdAghya2MHTDO9l+bD3RqbEyDQWedW/OMEkLVVjBmSuTvoOA0HSNgN?=
 =?us-ascii?Q?0enFeEaiyfCyrqJ/WnwRSeIDf/EduCSNNkxyaj0d1JBl2Im/lb9ceUSGZumB?=
 =?us-ascii?Q?FAJB9zQ3qqtysrc+RktiCWJM0xCFSI41CBMJzO474HcAsqz7UTbKYs0fq6UK?=
 =?us-ascii?Q?i9aqAJ/xYSvQqbWAJA68/1iZIZK3CQjDinh/GtRGToErVWVc+jVsiUQ6B5u9?=
 =?us-ascii?Q?PuyymRXfO7imbTrjFeXGH0W8R1huX61+cP+RbyaU1zSXTmGLfPr0UJP/3EF8?=
 =?us-ascii?Q?cPO+B+CO8r6tweD3jdRFToQp214sOI4jjqOWLLPkWCZz1foasPUlhst0DPJE?=
 =?us-ascii?Q?zIIh0OFfF4f5myjh2dssRCcAiNoSG3bWnrhngi3YuhDuJ8bBT0EkzTnYHGoI?=
 =?us-ascii?Q?CeeTs1srJvdghm9hoy4y2mE+UGEQxEdphWECSX1yw7wyZvm41JRmeOVfXGvK?=
 =?us-ascii?Q?s6rRmLC0t/kmsp2REbS/GAgHZS4b/PKqk74PKULRnYXXwVwtWdnEjGSPEKsB?=
 =?us-ascii?Q?2FA+wDubPlLhYaLDVgA4fxLIg67AJuAY3j/Q2t0G/jIEcMAaLwgKy29eJ3Y8?=
 =?us-ascii?Q?Wq3R3YFT40/jqSj1vgJYn3gMgWiNtbqHarf0SQPkDRTIwDxzhjahW11lxQTx?=
 =?us-ascii?Q?hEcvkuBZKuNLWHsDgcx3iuOnnvTlxSb79DX2nysqEc3Lql0DVHdNSze38Mu4?=
 =?us-ascii?Q?x19H02EfbzTWWsSXwOVKYE5iWXQHzjZEKHb8Nh5H/fnuKUtO7KnfVvWDGwNA?=
 =?us-ascii?Q?7k2PSZlLtXbff7G6HoG4Mkr+qxp1NAHaX2ePKyXzaMcJCnmucT4kLVhMHIkd?=
 =?us-ascii?Q?713uBzkWTH3hWZSPafmoy5PJCHtGQEZcykC6tkeXUN3SUI8M7KnXew0qlLGR?=
 =?us-ascii?Q?x0qvqZA2HDcIPlSQW01I84wOrDYIeW5N16dXg6u1ZRko/W/NfhBCCgB9OsKL?=
 =?us-ascii?Q?2pnVrOvItu8hNch/mxRxEKR34oxjKkSNX4fxk5uo+hB4hQZdFfARSaHnpXtl?=
 =?us-ascii?Q?GxodUlHz7yLlTDpcltVPgjvf/Ktaf935HTQwV8MVnZWJo1ddZN06daGkPOf0?=
 =?us-ascii?Q?6GL12B/J9KDszpg4cVtwY63AMj9DkR05xgaGtPrnsLABe6QDM44lNWDtvuhQ?=
 =?us-ascii?Q?UG9YL6hvSQiVXoKi78RVCVsUu+KH2ZumGfPuROq3s5ZvKAK8RIOZNxok66Fz?=
 =?us-ascii?Q?C+f7UpS6vfw6RFB4+KaPFCbdA99I3VrNPbwTT6EjclkKFZ8nEEEqnGwhV/4X?=
 =?us-ascii?Q?fBmSz6CYHHGjQpuq0nShPcnrAHJEbEXgPmy/gLi3kopKAe+82tPFzC/NYzB9?=
 =?us-ascii?Q?C2YcCUlwZSmYz46BBvnwDQAYdNXmLPBihZoyP3LMz8Spxrfss0BUsLpdEYZe?=
 =?us-ascii?Q?Rg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4Zue2wF0zth0VrTU4/FndVJrfMNqOvjGrDd9zH8Ziql1nzd0wVeOu74UsLepLq33RINcWlI2i55jFssEn4WurOQiCP9ID7A/DYASIxUa3Gzbg13dD7yjaLqjoRgcmWX/WAWEZiDVL7eiZpHR2bRca72zYGy1R3H7ZwmpOX0iHj1R2MmD9cYqEikvwx6l7p90tDL+aqO79jreehzzoxTkjSKexkAzeyLOvXV+NPrxK0O7q786kO1c3QZQUrTkReYQ+adEGkgfH3ngXBhH8PMiaWaV5K12FKk/Zs+uRg42LVDTKmmAeznPZUP+z/gHkqllCDowwL7sGyc2yR5h/JJCDqc+oIzipO8bu0vnO+tl4Kc2a6/3Zs84QIax8gaty1YI+EKxGHgZhyZdmMghzsdhUvkqNIda6OXeAQbG8wkGUzv5R7sZtw61Ls1EPfLgIUCsxrrbd5NnRo5x3umdOvsIGzwsrJGUT9R4ncZO/grexG+PZAz04fkeHBXGGkjzI7GZhduGHJxdhd9S3JwdcebLuQ0xv+EdU3Lc/PS46/ftdCOxG3TUJhsilWBUW/2N7KRAGANyg3NSFnJR/8RJPrfnG0AvGgYdkJoh10iFtDFt6gg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48b27064-6116-4592-9322-08de1a8370a5
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2025 02:48:16.7743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wh5JP53ITg9ltpV2rUe2cETI2QCawh1OoJLTpq5CuHyQ+RYDvaQ3f0lRAdVX6nMmH2Zr755cLrcOnEslw744Cnu47EuOoxAcmUAuwcTyT5I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5027
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-02_02,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=535 malwarescore=0 spamscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511030023
X-Authority-Analysis: v=2.4 cv=bNob4f+Z c=1 sm=1 tr=0 ts=690817f9 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=zkHuBhgLLGOvn8AJyKAA:9
 a=ZXulRonScM0A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAzMDAyMSBTYWx0ZWRfX1TuxIT0n6WZI
 MOHVWUHGYWUy3NGcP75EVog2DIZJpY8hFJHU1dNx10+xCsZdl5biqHLrCIXzrssvTf3D2jdKKbr
 4Nf7UzjWC6A509CxbpM320P4VLoCiHBuP6wjylNU5S4aGrcdRRl3xJUj5O1E8F+WDgzOckgiqLp
 fOcW0hyfY9FesAee8TETvVJjwvGKRqOWlzX82Gnq2E6dNOb9TJ2wXrVsmOcbboGcvZaokM5zZIM
 1aGp5NrkF8BtA56eJ1WBvBpEa6Qp5N8sdw7Gfah+UQBFlw0VG2QalEiup8dgiPwW/hy63yzilYF
 RiccanfkLe0R+YFnZdv3bkB/scgSqUetbHVA2gP3+PXmTg2U3jLWfSLYjANSSzCaCAwAfaOha0f
 TjpvngKGC/bJFXk1V4whMEnJI3vlNg==
X-Proofpoint-GUID: rYXwmlfNUZfMt6WCGTExRKDvEzDMgluU
X-Proofpoint-ORIG-GUID: rYXwmlfNUZfMt6WCGTExRKDvEzDMgluU


Bart,

> A recent security fix made me take a closer look at
> target_lu_gp_members_show(). I found one bug and also noticed that
> this function can be simplified. Please consider this patch series for
> the next merge window.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
