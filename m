Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94D77F8
	for <linux-scsi@vger.kernel.org>; Sun, 10 Mar 2024 22:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710110930; cv=fail; b=V6bC14XvsURV3+ll4zUwrbYcJBLDU5YitbZ0P/LHZivjYusg73npEaJxLpApPTwnmDctZmB9CH+VdOtI/Q83Hzju3P5lIU21bzmVaJH+OXhotuLAwaUDXvJhSieuG9svIVV5sYuJUQu1TV4HZTh2Yx90W/HoaVpf8JzYTNohMDM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710110930; c=relaxed/simple;
	bh=oplMkYT7WibW99HLuXUPlJwGNDEU6IESEGm5et6xlG8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=pxUGobIrh/I3oT4H2cnLlsVPG/Yxxqprf7OfG/XpQhxTn6ZBUvgZ0m4p7ttcVtLN0PPW5IqfuFFRRtkhpTxwL1eb9x0olThBM6jwlPNtCI2iU6JoBK1sYO4+S5eJOUD3dkJj0n9IKinx4DkY4gYbGldreqoLd+Jbwyh18cdiKn4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nQNiRfop; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nY723A3i; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nQNiRfop";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nY723A3i"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42AKf2n6003951;
	Sun, 10 Mar 2024 22:48:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=Zp2TGw7tARvJLmB8lEruU2/eu92O6akykNCDtrQQY0o=;
 b=nQNiRfopXfx2D8Krsi82Fk7Mh/LcjBRRIgGjgWgBS3N6O+naEKbHK0Mrq7aAyPnNJp0r
 OzzbLC+pFrxpYIfdKw0aHDH4jK82YNz1TeIYPweYFffcSaNUY5URA3oy/pt8M3XFSnnP
 nGMoyWUOJ0KQYU/7s5KIrsjV4r77OTI5AmrT3iAr6cum4OK7Z3yPdUYzc/y8W29RRFU0
 tspfPB81dszf3XLrjezqmzHgGONJQFFn3gTYeV0A76RmEm/xgualmiypVOVoupUU+iYV
 IBajTbOOxqpWq0YP68pOFwGh13nzL1ND3tGaw16yILChgsPdCj3sprhwUjvVL2ljb7Bl ew== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wrftd9smj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 10 Mar 2024 22:48:44 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42AI4EBH004841;
	Sun, 10 Mar 2024 22:48:43 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wre750bx1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 10 Mar 2024 22:48:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CEpmUrYSpuCrYJp7IzyLl5pKiaKn7y/rY2MIrOfynl8qZ+QtWjOcKbPAK7Tb/GsKHfW4Y/wT2WPJk0LI/pQNtfHNFnPfoXLzUUBW2RlEx1PPRcLH8JTYemKpervHRaGVsAdd+Xsad+CT+94CwJjQTbRqGYnEoqkNkZqCEaOngB15eRNhAmjNpQrMr1L+ljMgNCPp5D30pG0qMdsQ18KAPCvHVCiFnk/fA1xaZ8+d9UMAnBvKqYIHrbM0jy/EhgpsjseGnqESYS2jfYY47KdqSfvECfp5GPS4ZlAaBcA8IpmsnpAqkabfYf11JPsj+Z9EFIofN/Prr9SRjzmLDa4pAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zp2TGw7tARvJLmB8lEruU2/eu92O6akykNCDtrQQY0o=;
 b=BKQpozWn7vJuTmW1GqzLsHNxeGSI8yfxN9A6eFjvaVCuOXY4iYQVFZ5VYgbmEVu7h+ijWRyfIYEPUe/cmDlBfk+LXIqnRN5YRYvghtMOSSvo2c1Z6bdgTgqKV1Z67PEakoIy/NI0E9wRsDAw1mjWc55bOSyJnNDOZcKLkp5Ea4Qmv4TY1OUSRoA5tt1KXCIh+7S2h56Jsu+3ai8lZYT5ZHyjZc7IXhKxkDdhZzc5AxGVL3GNTyemMEax64YkEbVd0pMvOtsjUcCemTwmCTqmTflfXQkbgaaEfYLH50jZDiHBoKTfTAC8aT8PENtyaIhARqLubMOqAYsZEVAXxjW4UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zp2TGw7tARvJLmB8lEruU2/eu92O6akykNCDtrQQY0o=;
 b=nY723A3inSCV5rpmuW7cIaGkCR7Cbfad8Th/7vhkUGzcYrV7DgQ3dvnDwCn+7BUrjEJ00CVglSNRu9qP22BTyPr+3AgdpB3XhCw2SNigw0jAaZj5VLSCEH37Jd/lMirO2FhrywSFOFcqCGTVW8CAMT97FMvrFbNCCrkUiUK4vu4=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS7PR10MB5199.namprd10.prod.outlook.com (2603:10b6:5:3aa::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.35; Sun, 10 Mar
 2024 22:48:42 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59%4]) with mapi id 15.20.7362.031; Sun, 10 Mar 2024
 22:48:41 +0000
To: Nilesh Javali <njavali@marvell.com>
Cc: <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <agurumurthy@marvell.com>,
        <sdeodhar@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>
Subject: Re: [PATCH v2 00/11] qla2xxx misc. bug fixes
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240227164127.36465-1-njavali@marvell.com> (Nilesh Javali's
	message of "Tue, 27 Feb 2024 22:11:16 +0530")
Organization: Oracle Corporation
Message-ID: <yq18r2pd7pb.fsf@ca-mkp.ca.oracle.com>
References: <20240227164127.36465-1-njavali@marvell.com>
Date: Sun, 10 Mar 2024 18:48:39 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0363.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::8) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS7PR10MB5199:EE_
X-MS-Office365-Filtering-Correlation-Id: b190d560-4fa0-4b86-3834-08dc41543bda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	vmNjdxq06zOFfN0Eg9dKOzw+VzYWOwcE/9ZqRl9vaUwuNUD39WfUYGHg8VPukEpm22bb92p1X2Ft9dQCWMAgtz2wtLFH/29pBg2L5GGox7O22Z5V/GqS0oLTJQcF5LhEaDTikUq26v+aXo7LaQKFsC9D5CkNKlkJg7vqQyMQLZwZhC/QY3ZFeIlZiuyOy2yVLGXpNuk8/sbUD85qpYilizhFOl6lWMrczF5TB+77aoVv7guFjKdEWwuCzddWR9rSVypCNqjd9uIwqpaBhEOHyPsq5DnipaENF48c3uxbyv5a+2LtEFb2JtITLf3QQmYEgsxR1XNyWaVIyOsDrfAf/XoJ7xbAn9Q8FXpP5CHFT9rNukKt2t4rcvZdcc7vw5H15DSXCVg6xO600HGp8M5T0XvlA+Iw7Y5XBnqcTllaIURuqZCM8jCpPK0KQg2lQc/YJine3UNcOtiPGopgpLn4JXAfdILMqaabPgp6bjISS6lj7MHmqAekMHE0uie3pkz9gbRfTIFE19xiWF9gy/d6V1+YfV7aJjKN/oz2sPFavHSiugiSkCX1outROVhnX987k41E2p3hH/ARlRiChcU94bpnNdzhimbWQ9u/r902ZFA5t0SqQ3UGxuY+ds4loRUkp0KFMCs5hrlYigqAx5gXiiN05sV7/6MjCn32ocPAg4Y=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?hZ4gAVutDeDqIfBs3pkhdY88CzGZEOQlbsqWY+jzDe7qvpPpp/kKtvNBgN9Y?=
 =?us-ascii?Q?qqm/jZssRjv2JV4WYKOXkB853+h98CvTDRy2yaqlabC5sHj3QyCcp/u4usf9?=
 =?us-ascii?Q?+F++qCGmgzHjy2Hg9guvnYPFBxYA6x/I/EsKrWW/XycPxycEAylnCLq0vUTe?=
 =?us-ascii?Q?Ee7rhlMnO/IQKadFm1L2GAkIpK8gxbFWJAVADX1l0cNXZgN8Z7hh1bhI/2V+?=
 =?us-ascii?Q?WHtrmByC5E12g4elAw04V2Wh8rFv4TBQvRMT7y3zqcoe1VBAjwE+olg6VWkv?=
 =?us-ascii?Q?/CmAb3HA8Sndul8b9Kyq9hF/0exg3sRLeT2DOGReWq/s8GZHwDwbw0Z9QjTY?=
 =?us-ascii?Q?K67YyAfIEgcv5LW1yOlEUTbSz2PyDIPvord3of/2ON2txHqQ6zO2/f/LiaEa?=
 =?us-ascii?Q?IKjzcuT8+C0F73D+fSpFbz5Qf9Q1ObMFHTI7304FU+2kbJRZdDEyEPRJqZaU?=
 =?us-ascii?Q?N9PVb+Dl6nGfG9SKlJcSAdUwbpOy7HAaS6l1WIE22T5Tt0el0vEAufbfR+bs?=
 =?us-ascii?Q?PDS7tpVGvToLHKlAoP+45okc5o4CmvHA24h/onV207U9qEprBkGyWCky60/b?=
 =?us-ascii?Q?c2N9+JCU26w6slgoraw1pMs/RoCmV2PDPTz6Pdt9wnn2RBMmYcgGrTvUbDqL?=
 =?us-ascii?Q?OOcaezIg+7jhrEw4bbhwnms5LsdS4Eg6KF1KURhE20HLQ1Xt4JXAwhFpReYp?=
 =?us-ascii?Q?dXPUXEY8Dp5v1Fe9eWk1Drx9mnFittNrupTOuk0+9ImUBn3Zljm5EYYbMgbC?=
 =?us-ascii?Q?T/FJ10vdpIiNSK+NMpvmqomHgLsiEx1mrYx8mHP4d9SvqeV20RXPtY710ZCj?=
 =?us-ascii?Q?HCmDeZtrzh3sh1nHg2Kh80HFKVOlASeh6SogiQrgwbLkv1km5RMN9Z6os9DL?=
 =?us-ascii?Q?+MO6RS2Ascb0sMOvJ+jVo8XgZg3PczltemjVWovBX+FKrZc/qJQEfGtGPq48?=
 =?us-ascii?Q?u5OTJys8rVCjoQiCGn0xBNYzE9/tD2hBgMJ7niyAexu4TMFEAfFnelNAaNoY?=
 =?us-ascii?Q?NJOKFgx/eBahljMExGl43MP39t/ILFM3d4yU26zV5I1CxnQsVOSRqhUAZOJD?=
 =?us-ascii?Q?/14LIaIkZxK9tfe1HGFEHlBNynT1IsgiTGv4907+3ty3UpExHsGh5uQw/oLe?=
 =?us-ascii?Q?IfwMpHqM56Rlsyzy3Vm9zTy2NCR2ZGdQVX2CD5ASm68rEV9ROf4GyE9QVI5Q?=
 =?us-ascii?Q?dx/KEtiFqI9wqSOEl6Bn3S25KEq1T9Y2Bx52v5WcOldOHeGHAAA14It8Dp/p?=
 =?us-ascii?Q?rWEWfnv4EysPcRGq7eN+Q/msYxF0uuTeGOIdthRXDNCsqQJaNq9A2SnqTl1i?=
 =?us-ascii?Q?BB74UIRmtYrGd8TvdTlgr1emYiC8AYcDDwMmuNOHOPAPufGZjzWh+IXrjqtW?=
 =?us-ascii?Q?AOBMAuzSEz7dsND/q/ZrPDmwzbkeMcvtEsP1bykNvK9T/ZYr90HGANf45Zfp?=
 =?us-ascii?Q?0Z1j/z5+sC+UCN9pMG5xkbkmi8hSAm2LsP1upk2O3DTNUHcVoN9yqeH4ptbk?=
 =?us-ascii?Q?Co1FiXcZSwl4FuCUx3TtU9XxP4o9kOwK9K/Hm4fuCmsGleg74Xn37QHzIvsD?=
 =?us-ascii?Q?FykSF+7obs5tVLFidg5BM9fBIdD5jmbzld550dzmCqVkuYMKHFyXDt3Z+3IR?=
 =?us-ascii?Q?kw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	xRAso8blu7IOmGtjTnwXG6ejychLS1xv4ff5rtCXJn2ZcaY/MhK56ROqwdlaENmchLozDZe3A0mpgoi2sgEkVPyLt7G5ufmerH3ivT6ojf09G7b3kRm9txSUL/ovF92NTHsQOQKtmOia8AqpONYMXVCJD5M/ESAJEspVIy1t/AS8M/+BYCFFzQ61cJ4lhai9e2DpXUiqy/GYu2dJXbX/S8aMpCD51Pxe4EtPx62nVzsubjHu3usS2ba2mX/rQhph+U0DQaTUK2ES6q/KSyK5zvJp0+spd6f6ZarEQFpEsA/zyHsWirnSmG3LcXSz7UJ2Qv8ALfBJCdV3gCX29llbek+iI66TS4iIJUjU4of69R8M3+Ha3Fdf1D/DNBmgGUyVMMxr+eIe51f55NJStw7Mhdprx8iZPw41HpZk2BXISesPlWABgROPIB/l1esGHat5kEx78DNcl9Qn1EyfM/lzoHuXyad+Tm+njetfpBx+nJaC9HtyG+82CElveiGbSyvYHUpz4FzTVeQzJbd2/XsbIdGJUHp3WO/hhfx2nScYt48uzAxXis8ztWeYI7oXJ2dq+SIe7KMXVbHuc5ajf1dG7bnoTFhAJx93MnzB/Z66/yA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b190d560-4fa0-4b86-3834-08dc41543bda
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2024 22:48:41.9117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z85PYyjG23W0YKwujpfiqK751rlbVnccP0nvHjOQ+eo+fXo6IRI1As6hx7Zk2TgFRbzmhWscgS5qJ1EZHMnILYXmLLGktxgjEtD5f2oQpaU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5199
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-10_14,2024-03-06_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxscore=0 phishscore=0 spamscore=0 suspectscore=0 mlxlogscore=922
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2403100185
X-Proofpoint-ORIG-GUID: ZUQOvK1B5iJ5R5ENYSlbsQu19NVzEPQZ
X-Proofpoint-GUID: ZUQOvK1B5iJ5R5ENYSlbsQu19NVzEPQZ


Nilesh,

> Please apply the qla2xxx driver miscellaneous bug fixes to the scsi
> tree at your earliest convenience.

Applied to 6.9/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
