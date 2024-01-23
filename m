Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C754623D6
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2024 00:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969523; cv=fail; b=J6sjCFky6ZPS1oQMc13pZqZss+AiVR//t306yh31Rf5MEy65Y4J1kvQLSytc1Xzdb6vBHSbZt8/HPqbUeb+fap4UzKXG+d+RRMxVFVtr6uVjCGtAbcBfP0y87naygk9oy8BI4KsEI7lDmiyWhee3QuVtb5n2pFT2vAZJ8cCRF4w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969523; c=relaxed/simple;
	bh=2tI3D8gWPJ0MfGl2ewjkX6WMxNJ+mr818WC2v6BTFvk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kqfVH7gP2f0i9r5LxOljA+WbVaJ1IytAxextG5Bo/VVyfOQIYkG7Db1J/r4E+lve1Q28uLHADPuz4MwMG7qtXoFdDtd+OufGxz8iO7VPNtCmNqWv5UJwGbEX8UmpyWy+KdJWAugpIAXH3reuBUdlBUZAeBUooTqfcmGj8qEBV+Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CX7eBeVv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=V51w8YfP; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CX7eBeVv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="V51w8YfP"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40MMooNE019256;
	Tue, 23 Jan 2024 00:23:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=VWU7vDDLwtHRmdi2crHRMzwlX1f1ImS3irU6Db1lEmk=;
 b=CX7eBeVv1oQA+1iwJ9qZ1orrATtiH5hBaP/T7gnDkwMnZqlZ8ecBalnsNDrPm979KdOm
 zCL3CsznRD81fSgUplnqXjmtNZrv0iF8oe4fm+elVQ9oGl6fdoihdQiw0OR1WqnIxcHN
 Pp1bJl6U7id7RIGNp+e1PAaL0EP9UXOIRR+RGjbQ/NFYz5WoXWbZQYgaCEGXR7N9k3ND
 S1mdK1BK6fWOzh8hpqrIWhd5+WrvT4T/4D9ncv04ao0Op1J8ejf5jc+qf0oS+CWmFeXs
 OMCJ+EcP8pvAnPIHGjCq7B9hq8xClXZ2uN2WtVXgDsDLTnKlcpxD2d5bCs2i8EMOflNq 4w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vr7cun2kw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:23:15 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40N0DTm1025310;
	Tue, 23 Jan 2024 00:23:15 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vs33s34s1-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:23:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a0uxdVEy0/JH6IY87UyvFvQGzZf5xeAOj4rZxoWYYVMaeXPzt7rwEJe1Y+Y0Vcjd/3SO9KcdqZ5hZMf2VrK34XIn/dbaKnK9NQYM2g+RZcTXwfeaSBdSYc7e5ZQ+kd35dWtPIJqCY6uEvmGZnS0L/vWG+W2v+iJZCPIk2+kvng8ggNrkUl90XRlVEc5XVJEbsjlJqZyAR7Mez+CFLKB6c+15k2Sl9Qal6OANawuML4vcLJuUFbx06p+lQVFffu7ww5oY9zXNwbTbvvpaPXsqRqzCvazACNMdwX1Yil3CHqnk/L3GA4f4StQMAZ24O8geKQ0/ZQqVJK0Jl56SPMbSwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VWU7vDDLwtHRmdi2crHRMzwlX1f1ImS3irU6Db1lEmk=;
 b=Qvy5aggRl/7rVjo/L0jN5RGwCJtJNhssR8TtagvUU2dNB6Ypc6FoM7At9PuOa5BmG2Ny8tkdr69Zh71oripsDVMr1VP0SaNjTamGQYUW5LaVSC9pOVZ1GhIXlxUNlipGz8E3t1fiI7qK1iO2ThnKAklpmF7tiZrAD6aBpq9i+yyLYZLBN/jCL4ZJloA1g/wiugEC89ayLD1vZ6EkyetXSl5Rbk4JmWgkDIC5lL2cLzqIvAJeArMGlv6PRZPgobhDQ3nnONsz91Z5XUKneeYcuzTs8j1FpPcHmJdZ2fsw0XwLfTg9qU5tH6vtX2YuIMPTM/I5OaDu2YXbOhIUdGiskQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VWU7vDDLwtHRmdi2crHRMzwlX1f1ImS3irU6Db1lEmk=;
 b=V51w8YfPd2cB0v5mgoAn8HlvEtLIpMitf57nV6NN7Fk4KphXmeOrdQPyG5ojJ6OKEMmOOC7a2+TcePCZVTbC+B2p+ZS26UnrNtTARj3gA9O5E5NisQcTzsWgla55538CL3vNP2krFnaAoRqQ/+/VHD+gawwqcOCHoAiN3bYTABw=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB5340.namprd10.prod.outlook.com (2603:10b6:610:c1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.34; Tue, 23 Jan
 2024 00:22:49 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac%7]) with mapi id 15.20.7202.024; Tue, 23 Jan 2024
 00:22:49 +0000
From: Mike Christie <michael.christie@oracle.com>
To: john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v13 18/19] scsi: ufs: Have scsi-ml retry start stop errors
Date: Mon, 22 Jan 2024 18:22:19 -0600
Message-Id: <20240123002220.129141-19-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240123002220.129141-1-michael.christie@oracle.com>
References: <20240123002220.129141-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0107.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::48) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB5340:EE_
X-MS-Office365-Filtering-Correlation-Id: 43a27865-823c-4080-e8fc-08dc1ba96e06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	BfAbdGJXGzQNY+RC+W8HmQqL8pNfOeUgnodNE2cXe6YbHAizt/+YiP/jPLy9F5yst0Cq9TSu5IA+UBSIuFQOQMrOL3sjBjE+F2aDb1w3bUhHQwHcIuxmEqDpgNdP4aGUgq0+UV1FU0ZAI7aXGWm3kfGo2GbQoJtD0e8jPJwBXwiO7pclUI/kd1azHYENtKekjD3DpKC5tHNIAQlsjy+IqmT2IRQVdJddfHiv9P/6d9AaETXfWDU0X4yKQO3JiUc5sBMpLRn6+JPKm4lOqVD2UzWmDNm2Q6YVaxmGSwhXKps/N8Ges8HOvZ94c7MWziPCXWYRSFokxeWVct2xGKPAoBLKVqI5WnJS20RfR93lYApQu6hPHvfobfqJTiihMDv3TYlsJAl1Z1bzRkYmw+9/rJpNzp8QmYyX88HI8ogjnd6XcC8gXcS8ByJVvMmOkZm/Y/eL144c2HCDg5g9eg+GXCxQ0adzP/AEzrNT9PiFDtySXUhELPQ6tEYeRy7kQP+3N6k0wOjqk7yOidf8DW8cWGwEjBWgs+rDxNw7Tdq9dH9NoX3fZo8jWwqRiIY6GJ//xFE3M+oZyMmsU7GIBegyc9vt6DjdSlsW27yQKwmtU2oBXgdp6CpfWvD5yfKn9UYr
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(366004)(39860400002)(346002)(376002)(230173577357003)(230922051799003)(230273577357003)(451199024)(186009)(64100799003)(1800799012)(2616005)(38100700002)(6512007)(5660300002)(6506007)(6666004)(83380400001)(1076003)(107886003)(26005)(478600001)(6486002)(66476007)(316002)(66946007)(66556008)(86362001)(8936002)(8676002)(4326008)(36756003)(2906002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?OpQPDiAf3sm1GpJlPE0DTB1rLfi0LLnkk0a3+Kjfoqk2Vzcz9wACZ8fJHQ2k?=
 =?us-ascii?Q?k9wIyNptzaxEnpf62cPgTITwW+YXZV9dWCd+hUydg5eIarSX5JTzDrxrIaBV?=
 =?us-ascii?Q?YN6DHFAsWpXrktAKI0MiS79H4YZfO4tNunYrP46zoED8Pq+RUYvDKeAtxPFF?=
 =?us-ascii?Q?gZawpGaTfQd4R/n14MeFST2RVkjWWQVyBycZq3HwdiYcUJf9+Ejzznh9tWLA?=
 =?us-ascii?Q?1rjIyVrtKH8wYVsquw5N1+Gevf//doXskS3IJWPVC1jc/FgaalYGjUPtWTR0?=
 =?us-ascii?Q?QS9gKE1w1GinPQenZPWpXaRCl1skpVJcKb+e9czmiWIOr1wmdr5BoYrDntuG?=
 =?us-ascii?Q?ca9ajNJKtEnuVTxQz9KHrJaI9hZEdmTAVs8iasBy2yhKQS1EEA5roCHdBBmv?=
 =?us-ascii?Q?tvOPmwsXfthS5UnvK0uvDibCVWWnUH+wT+zSv5sYnQWD34tVDwdUlF7WMxgh?=
 =?us-ascii?Q?V712co3Wk3k7FDcfvL2GuRr//kobWDRTdCd3/vcnY98CNMMXdcmi6/aR/p6R?=
 =?us-ascii?Q?8rQ1BbAYT4M4SDaQE1ClsXQKVojUh6+uYiRzv8WFfp9B3OSiCHmnYzn9Imy2?=
 =?us-ascii?Q?EWsa3CtWJAmrbbeirFk5i5+jLl7VDG5pBdHj0Yw4MTDv9o/9h2fOE8eKhpQW?=
 =?us-ascii?Q?FbOTuoEGemEsKDni9Mhh0/0JhDM+eio3MxS/QIIulwDipcrf1iox3P9KZ6Uo?=
 =?us-ascii?Q?nF00fqxpOFFuQNfNvwJH4fJU15GFzLnVI9p10plm/NiEsN3bz8kM4pKIZ9ur?=
 =?us-ascii?Q?2iijBrsdBIMigiUde+L1OxsXpa7F0YJgmNv5A6WD1xYdK6Oq01LHRBKlrYVe?=
 =?us-ascii?Q?ekeCkbbwGBEUVR2sy52D6p+SsVk9dyrN9+Hin/1jTVk+MpJ+mPaXIIqnYva2?=
 =?us-ascii?Q?aVl3IExMVWCCZ+NDROt9lCopaRMWwUyvUeOWwemmp0+dwpHJEeiPyBc2StCM?=
 =?us-ascii?Q?zE01uCA7LdhxKdOIbqnYcY6fjv4nNxwzU8pSzK2yMGW88JEiZFCNz5HRHtBA?=
 =?us-ascii?Q?ebHBG4i0Xc04sCYsrtxO3QVBqd5Ift990jsoaYfALQaH7bi7IF2OkqfWpLF+?=
 =?us-ascii?Q?gHB0Os2zf+sfVw31qPIZSXGreqgvcTG+OwPxxLowso6Dpu1OFe67E+PqNtoa?=
 =?us-ascii?Q?V+wEOYDwS6BoNy4Cq3DZOGo0NDf1MlkezG6gdillRkm9QCILX3MgSdsDO5dL?=
 =?us-ascii?Q?nxLzV4gi1VgGoETq3JJNPO0ZUKEtg9mKN8dPLJvXVaH7X1FZt7biZP03N4aJ?=
 =?us-ascii?Q?qnz0bPUYIwj4HLIQjU9wP15pUl0jqHi98o6sWnFDXHb5nlScfliq7vW9wCxT?=
 =?us-ascii?Q?lIYYDayuyT94AahknxiNLuVbwHIymFR1S5NXsUXTV5sA5eA1WbEtM/E+9N3i?=
 =?us-ascii?Q?6MMxce9uuUhwtMj9oyNOmvGWAbnxzLrQXQ8AxYzJld5N/9A9khAFDO5RFu4V?=
 =?us-ascii?Q?hMXDA45TIE7Tu5fIZ5UtEZfYryxPvCe12rjcN00OzD7T/GdV5YI/Zom7SzUS?=
 =?us-ascii?Q?Sh05xyqSnuKquXfhzY6SAEJ6uxCGNKW41Lf55dBhvV6Iql3NAlSnOqwFCuPw?=
 =?us-ascii?Q?QOGyxx9Id299U4iQvc29xH9AGJaXpFw6pZog65Kps+Xhq9wE3u8AlYU8J6CV?=
 =?us-ascii?Q?HQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	14OBLQ8pruiO+Ay9pXb9obX1ojMCvv0o/B54eU/7znEPj2/pQvgqRV3Sd1vssVzwOTT4pgashkPu9xTdAsRrU/t7vhVYxPI1JUkO39vgD53yzGLVIESndC/i/Sgv0hODTy6OrbTJ6XeD57Kf0FgwT/vZ/zfzDabFYmqUIU33Q1REFmYTjCauCqgsiIbK8HqgYM/UI1Y072mSfS6JrEZx/vEG2FVk8Pu7+dNnEfzu7jHaAt2+5X7DJbQYQXLOiWzM1d+Bv3TXdxCxi6/GHE4L2woKU4I7XhiUVqc6KUqfglQtai4TF9UU1TBlrDWxjjCuWIB0TweJ4uDx03NkFV250UD0xNNaVVlW69uwXrgUJYq3nif4lZcQaX7p5em5yWOP0mAN3O4qRDcpXJsAH0Zn4ry4LJ9PoCOzzVAzKBolDxf4Dqf+2nEJyr7ft8J1VGMA7pnOof6dqqg+ZLd4nuKclSOc+oRLmWfAM2uMowMBINcSLklj5M3gUjPx4oZVha/Psg67hbYpRLDO/CGqSBkDpsjYpcXB/PjbMqZF9oRbLMEhHBGPn3uV3cnFhQtt9RFBYIggJWBz1KfW86svPTswCsalXZEYAPCb2ckxkW3Umdc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43a27865-823c-4080-e8fc-08dc1ba96e06
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2024 00:22:49.0227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HiHtEsEbCFE0DHiABk8w0j2YY/kMEv4iiDd7TOh2hBbmbBMKpIkxyiNijqYYr7RCRhhJvdpFof8Wj8UnPewzANWs40LDjhjXkzmb0bC6BNI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5340
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-22_12,2024-01-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401230002
X-Proofpoint-ORIG-GUID: 9pYkUGSppgvyogalJw-ojxoJV2jdSa3L
X-Proofpoint-GUID: 9pYkUGSppgvyogalJw-ojxoJV2jdSa3L

This has scsi-ml retry errors instead of driving them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/ufs/core/ufshcd.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d1e33328ff3f..0e4d1ec46699 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9479,7 +9479,17 @@ static int ufshcd_execute_start_stop(struct scsi_device *sdev,
 				     struct scsi_sense_hdr *sshdr)
 {
 	const unsigned char cdb[6] = { START_STOP, 0, 0, 0, pwr_mode << 4, 0 };
+	struct scsi_failure failure_defs[] = {
+		{
+			.allowed = 2,
+			.result = SCMD_FAILURE_RESULT_ANY,
+		},
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = failure_defs,
+	};
 	const struct scsi_exec_args args = {
+		.failures = &failures,
 		.sshdr = sshdr,
 		.req_flags = BLK_MQ_REQ_PM,
 		.scmd_flags = SCMD_FAIL_IF_RECOVERING,
@@ -9505,7 +9515,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdp;
 	unsigned long flags;
-	int ret, retries;
+	int ret;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	sdp = hba->ufs_device_wlun;
@@ -9531,15 +9541,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	 * callbacks hence set the RQF_PM flag so that it doesn't resume the
 	 * already suspended childs.
 	 */
-	for (retries = 3; retries > 0; --retries) {
-		ret = ufshcd_execute_start_stop(sdp, pwr_mode, &sshdr);
-		/*
-		 * scsi_execute() only returns a negative value if the request
-		 * queue is dying.
-		 */
-		if (ret <= 0)
-			break;
-	}
+	ret = ufshcd_execute_start_stop(sdp, pwr_mode, &sshdr);
 	if (ret) {
 		sdev_printk(KERN_WARNING, sdp,
 			    "START_STOP failed for power mode: %d, result %x\n",
-- 
2.34.1

