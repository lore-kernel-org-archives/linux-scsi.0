Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243A8320E
	for <linux-scsi@vger.kernel.org>; Tue, 26 Mar 2024 01:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711415852; cv=fail; b=NacRCP5ItKkbntZ1RJTUXOa7D7sDs1KjyNWgg31jbJpprwd8c/58avedQwK5EGE7GiUDaaU1AChniYoq0NUh1uzZ61aaZElMLic+f93puuzTTxsk2RFJsyEBPwRoZU6a5ZkfUVv4qpL6aBiUVEjSjO9xLLq79RWp5m+mVI1PJlc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711415852; c=relaxed/simple;
	bh=W2NRUJrcIS037np+YkD4dQ9G3rT0tCYXW7/2+7ORyGU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=L8jNW5t1i8I2KaE/Ur0/ADygpUpF13TeRmcSX3X0kTCDsGhuDJIkTNxagm9ez1Pgmev/IFUTwk7B6Gka9lXEHeOE7odecBdqXafjzAKkwQLJcTnZfOq0GkZMwAEbE4+2bav1mlyT5l6/L+2aTBLNx970w/sb57e4c9t+OEq9WBw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EgrpU5Ui; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VJLVZFRt; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EgrpU5Ui";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VJLVZFRt"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42PLG7Wl019745;
	Tue, 26 Mar 2024 01:17:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=LlLSN4NE4zCVe6WEk0BhD2c0Xh3JYm51vanMN9ipDvo=;
 b=EgrpU5UiKggjceDIier6By3kBqkpWXRofrojztm0sqPJ4G9VpOzjASzFn2LkYiorGM5B
 XuPo5biEkMY+NQ7kQgPUidVxIjeqQ0FL9+Ooc7rwB/3WJJwQhi+kNT03ZSOv4o3Kn+xA
 wX1DYthNxObRKtz9GAKWn0pU1I6MhU3IM+HJhAj0P/T778CDuDvFkclxvsNWi3Cm/vnj
 C1Q/TdJ5ZADcGhYMDyz87Rby77cCucbnAIeyerB3cGrcJzOLxthwWxjKahmQg01/gTjj
 gKhVgsLIacM8gBdfk+Mb6I8IIp4cJTE4qdGKOzDQ1nZx7IDTneIHPaUwAy2sClE3LpMI hA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1ppukx6c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 01:17:17 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42Q0hcd3024466;
	Tue, 26 Mar 2024 01:17:16 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhchtb1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 01:17:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CFqK9ExZUeW7NhGwf5EOW4CaIkJs97iMcUWm8trvlYmT4s3Eh/00KKzSryT3US5JpgjH4B205URR+ZpOtpWPh8PK6uIhJLV9WC8wcpoRceriO+dvzDNqQoBmwLYqqrcRTizxVDf7N9P7LOFuTZaFDyt+B/hXGT0BB8qLMUFk8avEpky22ENYHxmCg4hKDiAgmjQDDLIt6pH9G3uqvAPQzSefI/P2jVeY3lDpkzBYr3gB1oQsXI9IIwhJ1IhftUGI0jU5MszlnH1tDWYHX8ywwd/FWdWFFewFLphQofDa1zEye80Qcraug7zK2CSZV2/2aNxnL/0dj8WafzDJrp9oMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LlLSN4NE4zCVe6WEk0BhD2c0Xh3JYm51vanMN9ipDvo=;
 b=OkwaXzU0LGF82zw64mjbUzQYHXXDgxNTTfgSKtFIohzo+sBf0xNUmmaiXF4XRaW4VN8yV/WdhDE87RW1dXEB3gdjhM7FT/FJ9UHqEwMn3B1Q2mGKI0YDkNWoG7ggXps9t4WiPAhbm+muPBKGUGyqefeim9ySdEf+zrh4zdtZOh+fT/1NLJRDNT4JptTzb2y5atgkNV3u4YJDkI83/zs68fG1xqqT17KAPx6nvPA7xJ8o/bt0ZZZ3nLttXaAkTSjPsgrpfioiuQDCtpmnhIdnXQhI66Hnxp/DSwuI66w6KFmbO/u6upEfJoBAIdez4bQQ73QUhGG7V1dA97xKH3r+GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LlLSN4NE4zCVe6WEk0BhD2c0Xh3JYm51vanMN9ipDvo=;
 b=VJLVZFRtcfDvxUpOmdlmVe5vZ3pYHGFIXYNojQ6jyz9fAOG+61P8Co/Z841b/1UZYpD07JwzIDQq8dPtR26vu6aOVqvPf+VG2QSXmOBMQLy9WQ9AFBDGMqrL80Q0qtcDNUSpZ3T5sF4m1hids/8Wl2DzYz5gDtSdO7h5+BzSX9E=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ2PR10MB7828.namprd10.prod.outlook.com (2603:10b6:a03:56c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.34; Tue, 26 Mar
 2024 01:17:13 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59%4]) with mapi id 15.20.7409.031; Tue, 26 Mar 2024
 01:17:13 +0000
To: <peter.wang@mediatek.com>
Cc: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
        <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
        <tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
        <naomi.chu@mediatek.com>, <chu.stanley@gmail.com>
Subject: Re: [PATCH v2 0/7] ufs: host: mediatek: Provide features and fixes
 in MediaTek platforms
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240315083448.7185-1-peter.wang@mediatek.com> (peter wang's
	message of "Fri, 15 Mar 2024 16:34:41 +0800")
Organization: Oracle Corporation
Message-ID: <yq1msql94hh.fsf@ca-mkp.ca.oracle.com>
References: <20240315083448.7185-1-peter.wang@mediatek.com>
Date: Mon, 25 Mar 2024 21:17:08 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0662.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:316::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ2PR10MB7828:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	ZmELy8tk7jTDPnqIfKnttuwpcn2nOkDE1l/vUerSKT9zcEjxQFe/xKs4+QxJpFRYfNRjs1miB2+AL/dRm1VuLIlpUvaZ3Hhl2Bsa5Eav6GKZvOCZaTVTE7nVHji++0MQSEbOeKMHZjWhRdaeVea9rzVbmFC1p/LC/O2zMGiqc94vF9XRJQGBDm2GPUjFHRjt3w2vbrP68izdnRPL+d2QwT3CCiPI2bBc7Ta9/1BXOmtIWos2FO6QuHyThB5BGhc5D3VlTCZrsDEuGwr9kBvYJJBnwJAO6CDBjLbv0Lpej9iVcxRKSFMscc5VlkbNf8NYusSApnD+EbZC8CZhXRO+hWfy/MfttAuyyXB1TWg5wM95Lcmp0xZBe9oCyYXlkMralfAoFk6/NGpTxE6mpYkcMhVB33FBv1k0cutxAmokWYdJwlkC++2CgA1V4EZvs8Z1nraLe5ZOhOWGL7nJKEhFJg6soQE1/oBHacFZ38tuaDqfPCFj7lKNVUWJ7TkBiqgiOygFtckirnsnwhS4aYwnkP7MkWbeojxAKjARNYU3NXEb2c4mJHQE/jHVgOOfrISuh5ZfWLQSHeN7zz+kzgHRTRX/iCsfDSrD70Yhja+R/QJWyfe9Of7HWm3+bKlb08Zy9gscYjTTwJkJxZJtKhVt3cfTH2yE+PQNmoW1dpKmHFE=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(366007)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?WVO6re7r19+wesZckoFQfy+H1A2UwZaThfsuPSKyTAN9T1AL8Ivuwjr5Bk6Z?=
 =?us-ascii?Q?DY7raDX8o7bytx3xgEe/PQfglTqU5mHXXd09q5WsXvNoPbjJCL4L/qlu5spV?=
 =?us-ascii?Q?tLCCOXwpSHLUaz+gGwJe/HhJGPW++6zhLfuyYX1S5sFKBW4EnKPcfDN3C7qu?=
 =?us-ascii?Q?+WeZcUg8pOXyA9a0ivJHfMquTUgG2DkL5Rhe68J+FMic92xY9E922v1UY5Lz?=
 =?us-ascii?Q?gZTsB8LhzIZhlXofsykKOBJL0sMZ+jexOpZUepOi7C5cKSTwOa/g9DTv6i71?=
 =?us-ascii?Q?2GkVqBYMzUP0iZI1ETmykM43C7w8TxT3le458lmi4plqk6CmPDUygKixKvvS?=
 =?us-ascii?Q?x9WVEuLzfLmp5k/HGIpmjyNWYq9OcJMak3pSZU3/7tvm7HkwkIuM3ntThiSw?=
 =?us-ascii?Q?yT5lUVfs3/ukyJgduAbAX+DOSONnVg9MNRTetgB/Lbdr60TwHFLUD9iKEKFc?=
 =?us-ascii?Q?zfd+7XZlN8lKyK9u6DAsYZU4b14utpC8tU3uEW4guIZIUTUcOBeQlFBldO6H?=
 =?us-ascii?Q?adHXdKHhovaYR2L0IWWio7SjE5rulZV2CyoPtIVyDst96PznMFd3PXasscib?=
 =?us-ascii?Q?A8D8EQeMYg7ZlHbQIDjEPKXdcKr3HUmdOd/6sWNZ20RJYXmCTs5ebvK4ifVo?=
 =?us-ascii?Q?vdiCPWixbaqOLHpWivyQ9MTGNE8OHzcvJKZdip7pU4QmBHfnqZxYWUSTKEBe?=
 =?us-ascii?Q?9lc3uxilgEZb7aKSRqwswQv3fIzLOZ682ADw8mtZNwkyRuT01xaAhgjI6Wgt?=
 =?us-ascii?Q?Jn2y720KKsZzuI2Pn5hb6Wj2ViL6W56ubKLlbjMBMq/FUNHz64vduzYmEUbQ?=
 =?us-ascii?Q?51esxgGbyR8sGOmBDQ5Whp5yFWrSsOKY7pNjQdEsTMaH7RRtBz0Ksded8p2a?=
 =?us-ascii?Q?D85/GAZR4A2KDGxRKIRD8lus272pA9KkUx8WKCw7Tdmuy1aVJ5m24L5fbo53?=
 =?us-ascii?Q?XRPtZPuatxxiRXdHqSWFDnuoIEH8x8e0AF4LiUucS7OfbPtePa7kVqEfBpNH?=
 =?us-ascii?Q?WmcQn15chI0BSH0dzZzu7HU7C/xfBe4f8gG5sEoNCJaR/iz4tk5hqOcrngp4?=
 =?us-ascii?Q?J2RcbAvsPNzdurUrvM9+dqdzrm/8LJW2if1UmsqIpNFU8Ms5JUTPx52osxso?=
 =?us-ascii?Q?M7RbBMfg0hKpfHj3pXdywgFoc6jcXFC2pn9jHa+TkZLXtVKljwSt846TGldO?=
 =?us-ascii?Q?Uqy0tapIDrfEnBQc23zN6NRiceiaH5+GLISlbhXtX3cIsTazm7BNky4gtV+m?=
 =?us-ascii?Q?DBhQuLqHXQZztYxDbQgmjsNUDKyPpe2I0DyF4ACjzPV/hTIwG90uet1zao5L?=
 =?us-ascii?Q?tL/rq3/GZcJxqyTwrDLpSJgo2cIiwzOAcGgZ6TfnqHPWLu21T5O1M9v4zD3O?=
 =?us-ascii?Q?cxW3Yx2hvNlqT68ei8vWGdPSqsuTFm0x2K6r8o3STuYYTNPq+uDmOU7Lr0z8?=
 =?us-ascii?Q?EX8qc2X/MZGQm12jwSrLbvXXez1RUxvzH8sR+i0YE8bAPaVj6hblrWhfrVcY?=
 =?us-ascii?Q?6Z2KXngit0scTjholPcCU5ZKWSpmS9/pHzxM8oYEWiwJqZ4Uv6JAxG78fxHy?=
 =?us-ascii?Q?3YiDTTyGiMGjdSFdNQGhIwegf1t7cpuIZ9znHSJSIz/8yj2OG3DXFc1r2Oi3?=
 =?us-ascii?Q?Yw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	4RwG/UGw3a0wnoZxHlbTOz/a0QTYqkWSe2rDsWuL3p84skcXKz8wUmeSTM0rgzFEpBtJ2vnHq5xHLfPf5B2ImMLLDc9Kem7pRpEvWWWn3p1yrWNc8MhAiuaAouiDFhrUJuVPmlU8GvTjXKIvIIOlxXQ9LYWq4/UJXxA/ezsAQUvsz3jUoss8Z6bOGPgqozXrYAdON3kfWHBFmk8CDWjztV2L1j5nIhi2bHr+3k9/1zJ3GcMtGSqqiAPXVEXyQ42XeNfjR20I3KYUafbYuMT6c8eo/4Lo3Dwb+qHjbQrJtCxk8ApOHCEUFJLX1x561CDvVF+Xv4ODx4tYUuw+lnvs+yxk4C0+QX2D696g0pCTZOV5K/dk+hnrvM9yoURu7F6mCYrp+zzBeU2bjr4wKBUueTExYD9H4NjM3AfuP6xUrFNs6V3hOMTfukeww8iN672WoUK7oe0/PN7GNDQgP5o8fVlKG8eJBwMc91yYAf3VsmU3ZY6/5hN33FeshEDdWmexsrZHC1Tz3TbzaXV/JV98VPPbxeysaytpzg2GEm5ulig2rEqqJJlqAV3Qupf+v9ZT5m1zsNTJlWd/2FHVYkbhdXbEUCl2laYezbsrN2Agyeo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e740097-a478-4e83-56e5-08dc4d327780
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 01:17:12.9379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 19zpnHqSf1w1ieCUUQS3pHd+fyy3O8OGVBp/uoKSte0YGYyFo9J2kQHIQ5Jmlc/ZCwvYywBv2j524TbOqVQIGfYIwQ/mN+m+zlmQajWXGd0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7828
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-25_26,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 mlxlogscore=861 bulkscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2403210000
 definitions=main-2403260007
X-Proofpoint-ORIG-GUID: GzOBn0va8DsP-7qccF-gh3CvBzCCzODl
X-Proofpoint-GUID: GzOBn0va8DsP-7qccF-gh3CvBzCCzODl


> This series fixes some defects and provide features in MediaTek UFS
> drivers.

Applied to 6.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
