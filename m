Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD6F156CF
	for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2024 02:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724897912; cv=fail; b=BymAaDnSWpBrQAZpu2oEXbkZkmvMbZ0A+p2wRrdLYorMwJqzlu2QTHKe6FqOtWZC92gkJH2VamJmig2N0BtQrW1fNFWXf9NGpAieORZacuRTrQSTfDxz8bRCjqUKBi4UQdB2tSvYihfRZtrM5SzN57Ubt7lvIavSJr/TEYenTLY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724897912; c=relaxed/simple;
	bh=cQQcV11L03zkclTY2mcEpxsEHTCtgl2qXtUmtXDjUAI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=pg8Myhx5SGku8uVT+yMwLEDOJ89/4xoe3g1GCQHYyc+sewT40ccIesA88QJeM9kIsM3mnEQVpjIVS2dk1hC0l1s/jhSiev5owJmqPf0TD+Ques+4YwEACBsJG/dXJ+qEYyc0av3fkm3Bdk0y7XI0AMwl9B+YH+3Qxp6Fhb6bAjA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mmXeBJjg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lOfWGIz9; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mmXeBJjg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lOfWGIz9"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47T1fiDs013793;
	Thu, 29 Aug 2024 02:18:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=qLVLzMmsFKKhAC
	3hzDo3IbajM/8KG4iueIQ9ViiMnDg=; b=mmXeBJjgK+UxpsX3KmG8nNKG8f1dWd
	sss7r7Q3Jm04KGYGw7goaUnaunHj/k2XX/KGaK57/mK3jGnrZtdz0lW+3JDQ9TOs
	IevzbORd5+Vnjr7KOwdAfOqPqSkmsANiNVkIF0+HGko0MILiIF++gOzEUcXcSFGR
	MdHQsnrNRQ0e94JmuACQnkH8w8fsZN03OoP46ljnTmIQgxJjfDu9qwjobUSgrJ5z
	wkhjnp06GeKYH4bbiF/q6aHmUAOQecrQRBFi3nOBc+19TYQPqfZ9jLP051mwjmgh
	M5QGESLj0Wv5cOmIatNjSp8lBh50tUT8ezScZB3AlAn6cFRGCCqR969w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 419pus33wv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 02:18:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47SNFwKP010448;
	Thu, 29 Aug 2024 02:18:15 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41894q45p8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 02:18:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fR53SeEX/7llJoeiIUE+KqxFaiwGkL40KcjHFgjoE4zzmmcMwWTDFn9YDOG471+O4vWy8p0LkjQnPJeKzg894JjARSJVpSezk1LrNF4Veez2PTWaJ4JteQvsH7HypZFOB2hVPXQmMsxBUNew0Hdo1ip/On37Zw2O/FmFbOph63gvazluT2797hCP4T0viZdZZMwurjOUHgAd8FAmO0K/VtzRZOjF6/CmXFM1oU7lSL4Z+Xw7x8ME1jI8jLq23ugam8sZnHcXiWPNYeNcojfoLtdiSUP3hvxJG/PMLGoFoC0XY2xNsTuIZN0TsA1LygMEfitKcu9DzviRHnV1rKPJuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qLVLzMmsFKKhAC3hzDo3IbajM/8KG4iueIQ9ViiMnDg=;
 b=aN6SCdmUF6MovimJE5KBQNXDf0O8FQrspfcGVtK/conVm6HgYwOH3tkneUWCJ/o6dCR+cTO1zZaoJS1nImu3uwQN4KM1TMPO9OmIOvZovpf3GHazGUxKQ6Z9zjUaRjzSxXP5+dR4+Ng2VSPLvegSLqEIZPe56YHZYpIJ67QKI/0fLO0CuZzAktLfgqS4xZ+F7hyON7J2g96oiDYbL+tUPyf/CWwz3zpbo9lRqJNTNhme+1yoTUogB5TnXbfC6my2oQE3eurEKQXp/wyJXXQoxcCHtiZH2O5ccEGCucJNDpnFDVsDen2FRKXXvdgpYX4t6wjmR5u9b89YSVkwsCuv0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qLVLzMmsFKKhAC3hzDo3IbajM/8KG4iueIQ9ViiMnDg=;
 b=lOfWGIz93JR9+v7Dsl+NsFCjo7RkYiDMV7s0UsYcvhhNBJR+foNyLxjb6vokg2MWVpTkJ/ykpH9u+es0lw2rU62WJK7MI14d4LADI+ad8Retj5DaF0HWiXoLNWS+UXKsBT4imGEWzH7XK8jy2rq3Hd1xnDlgZ+hU3PTwtC0u/Lk=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN0PR10MB4904.namprd10.prod.outlook.com (2603:10b6:408:125::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.19; Thu, 29 Aug
 2024 02:18:12 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%6]) with mapi id 15.20.7918.017; Thu, 29 Aug 2024
 02:18:12 +0000
To: Don Brace <don.brace@microchip.com>
Cc: <scott.teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <scott.benesh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <mike.mcgowen@microchip.com>,
        <murthy.bhat@microchip.com>, <kumar.meiyappan@microchip.com>,
        <jeremy.reeves@microchip.com>, <david.strahan@microchip.com>,
        <hch@infradead.org>,
        James Bottomley
 <James.Bottomley@HansenPartnership.com>,
        Martin Petersen
 <martin.petersen@oracle.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 0/7] smartpqi updates
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240827185501.692804-1-don.brace@microchip.com> (Don Brace's
	message of "Tue, 27 Aug 2024 13:54:54 -0500")
Organization: Oracle Corporation
Message-ID: <yq1plpscc43.fsf@ca-mkp.ca.oracle.com>
References: <20240827185501.692804-1-don.brace@microchip.com>
Date: Wed, 28 Aug 2024 22:18:10 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0112.namprd03.prod.outlook.com
 (2603:10b6:a03:333::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BN0PR10MB4904:EE_
X-MS-Office365-Filtering-Correlation-Id: 83aa082d-06cb-4602-d451-08dcc7d0d55b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oya/NxHeyZEQ8nz2la88V+9DUafDuHlbIOzG05a/9tCeuXkrpSrRNM4H32lW?=
 =?us-ascii?Q?ZJiTisdeOvIT4GLgFskd97ZMF873LkoUlDA/+KCK1PiKXmnuZcZmHdcsCzHy?=
 =?us-ascii?Q?JWReRSCLWPwMjJiiAhs9R5BHdDEC9jqEXU81fxwgLjcURHPr9SzR/7X7Fca1?=
 =?us-ascii?Q?PGqEUOyutCV1iBAGvC3dH86gLHkwps9ay8AxnfjvTj8QUArK6ytFaR+R84dN?=
 =?us-ascii?Q?KlqMYiDZNBdFk5c6fc0YMgePiSXs1Jq9oveLzXw0dvNmy7gXP4Ef97pUn8C3?=
 =?us-ascii?Q?kqVIpn3GA8FaR0QKq2o1zaylE+Kt0UevkMnxuyo7MsOd9NUXbBd3vkJv5a15?=
 =?us-ascii?Q?BlBZBO0cFeCCbxdsXpqi8gMKm396qWjLZnplb4XCMfFMDoBuEGbkDfBTn/v/?=
 =?us-ascii?Q?til2+1siEiWIxwSJBFCKsaaU6r1Eli1fPQsvzDMfagdBTqMw16aIaFpxRLEk?=
 =?us-ascii?Q?rvYpBKxY8CxiKWkHdkktzQrzcR63yQyKwNIADUS+cuZ+46PRlbukL/OYbcgQ?=
 =?us-ascii?Q?bzChUXRqs1Y6FIu8l7xLJrT950/O5g7cTlMPk2gnDU3pVxw2NlyL7Bniy01W?=
 =?us-ascii?Q?jspmY2078ZhT/nPPltLDNpIT0vBIoFQOJwWVLvApzzaIfZqfXgGi0WJL62Xo?=
 =?us-ascii?Q?OEA9xhr6v1LjBpdaRIK8cWbeuj4YlJflbpSl4VTbTmyRxwaJZuFp/cmgqxHZ?=
 =?us-ascii?Q?o+P6BdX3ZUPDqZUsMmmQ8Pth0VKb5gTDXmlsApb86WXAW9/eZhIbUGQJWReP?=
 =?us-ascii?Q?+0beVkMiimW3W7N9h0p+Zf6Sax6FYAmv6EWqg7OWfiROtSlzJQzOeHQbW8/R?=
 =?us-ascii?Q?cVftwscKg9S6ymJfeSqVtt0IEDZTXQAXQVsuGCMomneX4Xzbikim5GwrP9qr?=
 =?us-ascii?Q?eI23J1iTelBgXpjyuw+8/WrZNZTXrbe3Ivt8k9yxq1uvxjAvogw3n7j5jy+n?=
 =?us-ascii?Q?evAM9TcEDzkVPg1qvo7bvW90nBrLaT3Lv3NxTB7SEjq6ShYVLsc6jETXEplL?=
 =?us-ascii?Q?S8IIsOiDsBaYPS+GIzpT2JnTltpm0fHo6TfOcROIiEmBhYmT6aHFWKN8dlwl?=
 =?us-ascii?Q?caoDl+ABeKGE9iK6fiOsyqtht+D/JrUDa7atkyttLNtoJfuJ8pQUAW+ltn8M?=
 =?us-ascii?Q?NYmEqp0iHlR1JrbXgrTeg+Z09m4QpSMgRLffCEkZPge+xUg/5cRM3ZxWAoB7?=
 =?us-ascii?Q?zLidG7OZaM4BK+vwYu9n/eYs+54YbwHSj1w95lcj7MYw+Ax+AC55HdzWLpuZ?=
 =?us-ascii?Q?zqcWnxwBcS9bpVGCZb9IHS1dNLozACJT7lCl2KIBXbfWrQb5yzfNhKm0X2pG?=
 =?us-ascii?Q?mSwMrVQMjOitErAD5HgOV1dY+Cd4tVvCyEkF8OZzv6ZTfg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/SyINfunucPwx+xRi4zJj+YyqQ/uffC/0+GwLHulWBk8ophOpkgwft4uU/uX?=
 =?us-ascii?Q?Z0NAwqfbOaN0WPyzgr8JMIZeSDscuEBcrUqbJne8zChGgiN470GMP8nBF5Ca?=
 =?us-ascii?Q?B+ouMwR0Yhq0OW4AcM2luB17Sr9kUsHiAuBqqn/xvsdDc3NVcy9m5dmGjKdB?=
 =?us-ascii?Q?Iz4BEUfR0rfHsotSgSXiZ/R7UvfohvATtYvcCggx9ymG5EIaNeb381Hn4rSN?=
 =?us-ascii?Q?868CH3zQcxRvOn23BEITucBId/Lj8JprqVbvW2q9iUZKBkNn8RAUq7RNpOuN?=
 =?us-ascii?Q?NYn+qwaFzCKp+1u/GA6JPHQva8szfOdxbPCARljIJcxvictlZeYsfRgCO22s?=
 =?us-ascii?Q?tt9pzLt3sbEmeTA0wY2GrW6TlXX4PFhqFozfoe2Y6jPlx7K4DPjreCRlq/qN?=
 =?us-ascii?Q?Aag/xSJufDUZUbs8MAtp+6/9GBe65SbIUDImO2z3OydX9J0MnyArk09QfH+P?=
 =?us-ascii?Q?G53E/oC+pdLCRpkaGwflBX5vfKrzhpgMPl9rpm5WszysCworKI347PVZImrK?=
 =?us-ascii?Q?IGPRTe2jBKZYUw6u2uqTJeDTw1WkPkOBeyflcMX5UT37+ux5TxMdl2ygFb7I?=
 =?us-ascii?Q?68R+4N1EBPOTgidIQpeQCj/NfAxexc+hCFYJY+6KT76x43cLP+igjXpu3aju?=
 =?us-ascii?Q?7rEG6QpLiOVrSvtP/gOSv7sYa9sTvZ4lCbNCrTcbg0uMZ6sBSiUfBYDOFvGq?=
 =?us-ascii?Q?apB8sfL1Zmcfxl8wWvgLAcIAP9tgD9C6iAz4WgP4c6xejw59zGIbCyU1PoTk?=
 =?us-ascii?Q?TSYECRjPpd9hni/uQRMYhfh/zqmoIrabeHDDrJZ0kzs8zZd/8DaxyCA0pRLX?=
 =?us-ascii?Q?M7c+ifsEbhZry5TfTHASpUiOKPbF2IBrt1rOCY8cR05kvGaDONNqNKo/f5X/?=
 =?us-ascii?Q?O6w9z4RgTbkdrmIWb/vMBsONWGt7oy5LE4vvKDlpGxQ17UVcGTcTBW+W+8Bb?=
 =?us-ascii?Q?ANSESXZTzKtlXLPRTOCCcCjFjb3US1gJitFDFgvBt4KGHpgBTI7+yVb4lwb+?=
 =?us-ascii?Q?t0TYkj0/tDABPGbLIWkGbZz7Lxx5yihmlryDR9W8hrdsnUmJBu6QL35zw4hP?=
 =?us-ascii?Q?VVNVNrp6/6Yeo6WXCmtu0GYf+KJkF+Hq/WHFsDEm4IF9gahAsqubrHDe/i3I?=
 =?us-ascii?Q?+UZsNscpBT0ZmlIyja00NfUQHtchfwHEAPSbCQLp3/TpVbWNu8L0vd+5qIks?=
 =?us-ascii?Q?mVRGdjxMRwwOJDYl3J5r9JG06lR7+trt5cc+qqt0s3NZVtw8Qmgz/npyX22w?=
 =?us-ascii?Q?aL55pipNn+Gta1/bkFG0br4qZ8vf87GUNAXg6ws+E7rpRwPdwgilLVQBs6l1?=
 =?us-ascii?Q?vOmVvQ6/wNAs8AghDXbDynhrvcLgiGCw3NbauimDg8Fbhngvw2UUCgHPBxuW?=
 =?us-ascii?Q?iVF9rb6ogGtsbGpg0naG2AiluNrOZlI97s6F4o01ms9FJ0UDW0PyrXQH36rG?=
 =?us-ascii?Q?lMPQlQWT17bt4FvxeaCtF2U0x35WGdS4bmRjExqUkzwuHL6Mr0x9JFPe6Xi4?=
 =?us-ascii?Q?Wgqk5CqBdrf5/uxiFRh+Ti03BS7T8cA9CFj0+cwGjULo+Z5aAvN8RmpJewrk?=
 =?us-ascii?Q?bkzOP7+wuC5sZI4fO02/K+45mon3w5sv4TvAigjlCgRmBtwkfmyhXJ3jJhPc?=
 =?us-ascii?Q?TA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0WySzoQOJPvTGI6rSpJc4eajydPRJnN32mFwLCyqNRNJlJdCQ9ynZy3KhrzPR5jHiap6Bowmzhjw85jD6xZ9z/Frnk00y6tFF2wpQbYKV3O9lYLfbmsElXFM/R2PyHaIT/Y8HRY189jrOI06u95JWKEDFmDHUOQzunLO5CM+zxTjouEQZoYks8Yb1EbtpBv5ZrgsD1cuORl5qSnrKyFeyB6CWtv5yAvbJGY10sr4+oFBYhD2MOxoddnut6TQDsC+GTIIIx0UKn8wQxjHCbLOi8aV6o6fbxEp6jSdJXkXg89Z215iwmwlgMd/8JUkYcuJnQgD6rBXf/6hv7+75SG4119F/LzdTXBr9IK/6HF3q9Q92H1Me5zERTIk06j9+6rC/hytIQ03AYz1Q0FFGe0jD0TjgiMYB938gjQ3uljTiAt2+eyA2Cw59bdM6Itxp6I1c6tNMP0L9XiMoO7Y46a0p+ulxgd8E61D19T91RR6MFydMMTwFBlWTlkbFttnN27AJSm1JxwaACIreazrMKSlS50lJtpkega0VQuOw+2yiO/5o1N8fi33ospIZ5POdgpU0ol2UHJdrvPyOJkCktd32wX5dyVAYrkEexuc9nL2ipA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83aa082d-06cb-4602-d451-08dcc7d0d55b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 02:18:12.7378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A/oMfvl84JQlBI29qIw0/VxRMvhbgE+ovf9HNwA1bkrhb1biUQKwzLjVSWiVaCSSvNkACOeHJLe2U8utBDvyPmdUTi4qrEX/N37XsarGZFQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4904
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-29_01,2024-08-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 mlxlogscore=855 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408290015
X-Proofpoint-GUID: wSyMf-fDUspMPiXoDV0tu_BFQ8MTLVAw
X-Proofpoint-ORIG-GUID: wSyMf-fDUspMPiXoDV0tu_BFQ8MTLVAw


Don,

> These patches are based on Martin Petersen's 6.12/scsi-queue tree
>   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
>   6.12/scsi-queue

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
