Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31EFE4C8B
	for <linux-scsi@vger.kernel.org>; Tue, 27 Feb 2024 02:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709001729; cv=fail; b=lmXrp0BfLPlzlyJr+/6hWLygB+y13dwVAW8Q+D85AHmnE4qfJlTc9wMuYFFr2L6jPmX/yID6f/JZ/ofetMQwtkY49n0gsK5Ae4cAwoXoFIvL5yEAtsuVvh6moEJwvbukgdaNDqIL2XzeHo0bLZ3wpPAG7jh6GOcEIayZuAqPHb4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709001729; c=relaxed/simple;
	bh=cYoni8GhSVNgxABbuXdzYK5uSVYPrv5HaOA/ZbNeQQo=;
	h=To:Cc:Subject:From:Message-ID:References:Date:In-Reply-To:
	 Content-Type:MIME-Version; b=JkDWHyWz/wPoA1ZUvuTC3CxWYZLGqNTImrGSrMrdTMB5X7F2aklwYD/Ci8m8c9X8iXaDqETIYvKB2dMx4HUAaSZCOJ70in887hyISW9sjNHMdv+2tvjVxumgoqZyTP32I2pI2si6EPKU70J7jdZ27LoaTst2Vlot+293m5yb3gU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=J8n/99j9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=z8aRUcK+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J8n/99j9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="z8aRUcK+"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41R1EC1P015669;
	Tue, 27 Feb 2024 02:41:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=dNJLNf62uogezQviLC3hI28Ka8RFhxffJ8o10ZiWJ2k=;
 b=J8n/99j9h5TfC36a4I0LlirxdBhTAaK7GZgZrgqmyuPjiqEedkG3jcc5InF+zo3vk4MY
 HE1pMixc1X07Artx/4l+re536ZTfNoVXgboqmoU7+h6mBYmLNr6tthKtn+qO1sMPOQp7
 gaT9s9QhJyfZgbP2HIZYbCAqpUbaUvhu6JNNXAE9bbHZIub8qSwWAkK2ZRkZF9KAzZei
 PzUK4uHhj85ycZKssu82JCjScDBPY0Rab+FXXE5UhDsnNqvyvThNTcNq2yM5LmZ0KCJf
 P55U5AXyGsy/SHZZ9nN4xIgrSWvY+xaRwej/mPqYhAMy/zL2vedaBx/+IvBhhWFmPm6I Cw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf722e17x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Feb 2024 02:41:59 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41R0FbFw019191;
	Tue, 27 Feb 2024 02:41:58 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wgbdjbpjj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Feb 2024 02:41:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kkuZwrd9Yk+BAVTSj4bnIgEyExuWDWg3/XXDbNatJHRAH14bQ4KppsXUvKNjbhQwE9IrgRmEpHZ/IS+9QKAxHLYfFi4eI1rpCruMQlP3ithdC7h/Zvd41LZqjSWPZ2Y9qV9FTdY0mvRVrKeXI+1sbJtl/JhBvlJgvs/grpZVHgGNK0x9MBYyi+DZAPjLZj6codpKPBPCztQZI1MngYYC7QmqWB4Qem2Y7ehRuCLa89JHT++de58GIQqyxrDZHq3UdeFFwXB9VRyQFTzxgTW5I2gRxFApvpZY0nXkI8W+8SsfSbr59rCcLRCC09dcdg11lyiZDAc5Ih0r3pjutJgv5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dNJLNf62uogezQviLC3hI28Ka8RFhxffJ8o10ZiWJ2k=;
 b=nAbLfH3B7bTqLpqBqpIRwWC0Sc6EiiUCNFV2CBoo/2iNhH8nkr9CK8S3WWDcbwL+HmWdKjzdJRQIaaElabAnOtryBOPDH2tHBVgTt1srZsupJUO2ytKPunep0JTABcYwDyVkmoR1FwCDTMOFpQj5ooc/MdO/kQ4iQ4uUG3TbLxtCr1LvcONfZb+IrJkAdDLUh0l59ItXISrOmwv2kMcoUZO12EzB1N1US1vudtlo5tkjJ4g1vlmeiOhxxZMuKMhAIV5eNXmLD/R3skqQZ2ypnfUy/3axU8PowXp1IM4aRdZ3v8eBIu3OPfvKPShGQsQ0Pp2ze91jh+UDviOeZ+I++w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dNJLNf62uogezQviLC3hI28Ka8RFhxffJ8o10ZiWJ2k=;
 b=z8aRUcK+A+nmb5cheEZlZkrlRR59hGXhQSIrE0umiQAv+ggolB0S+7KBmB5PAgD1iJo3qH0lI476QEIx9Ds9HDK5RsY9gnn7O+zbbzQUpyv2pahvdoNHc7uJ0LvE34lWB7fjY0Hckf9oU39qMZGEiAlBQvxpOQTScWNP1nf38xk=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by CY8PR10MB7314.namprd10.prod.outlook.com (2603:10b6:930:7b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.34; Tue, 27 Feb
 2024 02:41:56 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::e542:e35:9ec8:7640]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::e542:e35:9ec8:7640%4]) with mapi id 15.20.7316.035; Tue, 27 Feb 2024
 02:41:56 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v10 00/11] Pass data lifetime information to SCSI disk
 devices
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1il2a4ojt.fsf@ca-mkp.ca.oracle.com>
References: <20240222214508.1630719-1-bvanassche@acm.org>
Date: Mon, 26 Feb 2024 21:41:54 -0500
In-Reply-To: <20240222214508.1630719-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Thu, 22 Feb 2024 13:44:48 -0800")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0107.namprd03.prod.outlook.com
 (2603:10b6:a03:333::22) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR10MB4754:EE_|CY8PR10MB7314:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a02ac26-52f3-49ca-6737-08dc373da9e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	N3VOYPoPjS4GDtNFf+qm+lRjXesWy/pEkzqkb8nNtb3k+ybI05XXEOuarM1N46I9VVkvtzL08upeef1oQIu/Gi28bDvV6Vi2NFQOwaGHXx4G6XtSQeybPIdUyRlDlBFWaKRLJOXD2NbgoPWbrK1ddQSXQgOciQgZWC0pEH578ZwUlcxibrQeG2szMMaM4771f5hKnMdKYNaHwHs5JiYEDYhriBB5V4FGkQR0AFGDWKivdNqWrY9bI1pHdeWjVKjAuHARpK8p1AafVuyC9Upvpls/5ybCiVspjy+CVMtx5uAp+NJVDMCVfvV6Na5Ra1HfSW/zsCLkSf+OCm+qKRLyMzs5pxr6b8om2o4Ed3pQNeHohW9doSps03IXQ60f4cxo1fGTPxsD0YRZN9yYM5cAQi0clrEo8tkHqfbbsgkpEoDxwvPGGyrX7IfUnrznukYNX2aEQl63ATwTGNr/vR/8/N/nq8JfiPW6ZKwXVEc827I5aVacrbR3jCm/B0GQD8BTVkgBWw2hx5oA9fEUS/iMrW5Fldkc1f9KZLXeKpUg2fcq11WlCXMfLax7tSowzVVWPUNMuei7bQc6wy4SwTWqKbGhaG2DbXcXg3pv8Uhtw5j5cdR55tsAiTNZmt58wID4hsVF/DPsDQ4a4yzamjti+A==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?kzvshjaZt1bFo0aKhTqg+NBh8hhCnTpf4kt115QXEr15a70/QT7VirtuoHL/?=
 =?us-ascii?Q?bOAnFEy/AaYlAq2JvtGsXCUsYcaoDyH1at06IqbBgzQi6zWf6IcUXl9pn/8K?=
 =?us-ascii?Q?/oC5Si+u/VrBuVFQklSVkv2M4a/JARnJWzgfXLlizjWwE+vUKWR5q3aqWVU/?=
 =?us-ascii?Q?eqHxu7S66nE16h7xOurrNgX4y6Sa/yqi1luNa7BLzLUPxVYKWS0zAkSTP1H3?=
 =?us-ascii?Q?77B7ahljys0U0KSLNGjFeMnDX/6HaoCogwcU9bHxrqOEv2Kg0lOtZKf5+0+R?=
 =?us-ascii?Q?iLXI3qnE9MlMoY6TWyvQxDZYk1CvZKtWG5bibwJ7BhVwohDOwuJ2iclQiym0?=
 =?us-ascii?Q?Gty4HJzizp07Mieydh97kpEEyX7TbK8yQltvapNnsoSsf1heAM7VT8IHq/M6?=
 =?us-ascii?Q?BXDnhwRgkIXjXWVzTg+fqtwksdh/TQI25ZOHwcZVqhORxl5oMRe9/VWN/Lai?=
 =?us-ascii?Q?dEeUXcJ+ynfAEhMhdHhQN4jSmOuQe3jj92RXt29IehBcOhpUhOFoXlYha5+D?=
 =?us-ascii?Q?bKpYkrWucDAp7LpvAB0/UazjGfKuE/6RiSLaEvx6fdpYn9a0uZ2Yz/jj323w?=
 =?us-ascii?Q?WXj1K5jKfIEkuSzGsBaXa2i1ZWTcZJHjpmP2P6E6mWPN+v1e9SWW0GKegIUp?=
 =?us-ascii?Q?TU3ed+wQM2h7ZaKoI8EF+rGleo1grgjmyBlcylvubmg0ZiZSuK2JErkWBbr1?=
 =?us-ascii?Q?vVTYO5NBDR4VVDgH4qOSVItd+zEx8aeWUMnP+yk0TqZtvwoH6lDsywtM7kK2?=
 =?us-ascii?Q?2XiqrxOOdmidMev0z7neaT2uBk7Oy3QkBIjoUcm5AEaoC7ov4p/W/kH1K5bn?=
 =?us-ascii?Q?blvWxdo587PVSWVHGwmBxGspd7Z2mKhNFXfiYgiJMT92B85cBVd0PuIWjApp?=
 =?us-ascii?Q?Ik3ntS22PjvNE86pxcFIVD+Llcbeay6LGq7GOVilgMAjXYOrirm1vv/ijV6T?=
 =?us-ascii?Q?TcMGe6GAhAHNIMGh4WSR92syYKyrF0YFLxCgmc7K5aHIImCK3kwk0futU/06?=
 =?us-ascii?Q?apag059ezsYRqq9nOSTUawkt3cqVbk6YX5xWKSIOInOzw3hk3rl3dvCh29R2?=
 =?us-ascii?Q?norhHcDFEM5C7czfJwiZ3tPMzkNrwH6KWLBAqAQ7n8vin9TvF9Nauoad1bJa?=
 =?us-ascii?Q?1p3cPkrstv46WL0gZWrBjIcRvPBPS0jeMh1/TPVQ7CVEg9EU1vPayXJDYUX8?=
 =?us-ascii?Q?nzARgezAaph1ppQ4ijYJTWO/XTPeaE1VVrkCxP8RDOmuuWn3XnxfTpXlQr37?=
 =?us-ascii?Q?PAN96IXsWoFswpzbFJgVkkiTAqe7DgtCl3KfBwzxKm8c/LBaw0KXjQ0Us5rG?=
 =?us-ascii?Q?XtNuMnaDa89rIOnb0Qm37c1fw6ll+qPR7aQqDgxqKA3fq6lvUItqHmL2QBu0?=
 =?us-ascii?Q?HF44eo2DGzsASt6+3GZ/VqPWbZnCJrsIY9i5wvn23a8VApDea1yNMTYJMt5X?=
 =?us-ascii?Q?10gfGtl7veHNsiJKrKOK9n4Cny9RoaNlDkuEnhtGCWq/A4KwI8rQtWi/4JxZ?=
 =?us-ascii?Q?ufG/r7rtBhUdxmYEvUd7UC53dZHq8897Ce397K8sxQ9JFk7vI5uA0FnEh0wj?=
 =?us-ascii?Q?T055CbRP0LCgx+DbvgJUimY97KjJj3ExaGTHy+4Vyy+YkmA6jmnx8EchCwc2?=
 =?us-ascii?Q?lg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	jqYEBlESfHif1c3b6LBJLancydKo5Ojgvel+2Y1dhzL64UH0FTsTuic2WXiUs3+nALht3fRwhVzTd4qTfbRhO4FwveJobv1EcEhAyHfk/pth0m7KlkDTCHvL/gRN7ufvT5WnKO1GBwWRNiW+5YTAOOq6rp3UWzPwxsFZvnb3pv03rBxke9qlzlIes0FHk87VmkwSoaLPqAVzB3TOHEf4gAYIGqgCK+GUq1czBuX34zbH7RTKTQQMgN8m3wREANyDATNHbMfFw7DSFqg+524vIAjsuvO54yJBFVeYeMDgv7rGk82TIjtLlIahaYdtlaKmjjjkcxFCF/VqEDx5Jb2vkT+42OwObFcC/QNJhCc1r1ayE48E/8Gl1Y04A2rP9xHLSraxeIC/hvJBfhqnbRSfn+JhLedL4/QceiKxa2/hvAbVRiBg0LI3MwqaWS0cGw+cWFHLtTwAqCZSiKakXOHiOuR6q51JxDBPRtb/B4hhj1/W2NpKzTxhPAbBRocfZe6QYB6/WWKJ24LWeT7vG/6qXgiSjv5CsyPtCWlWpuSqKbL2WNoBgJcx6VGH6RpcVRZWhdMy7Mhs7pd6H9nSdEqIw9aN+7w/pAldeEgGNgZFIcA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a02ac26-52f3-49ca-6737-08dc373da9e9
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2024 02:41:56.3530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SjWuPGaCj6xcQgh6WPncHmwYSqIFIC1WwhSdVE05c5gMvdG4TYGdq4yZqHtnx3mEqz80Le/F7emqKmQNrkQNVGi920WPhTlJ29rKoWmovpQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7314
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-26_11,2024-02-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=828 malwarescore=0 phishscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402270020
X-Proofpoint-ORIG-GUID: aWEzTFe_WFzwGg8Id3v_8LD2TQW7AllF
X-Proofpoint-GUID: aWEzTFe_WFzwGg8Id3v_8LD2TQW7AllF


Bart,

> UFS vendors need the data lifetime information to achieve good
> performance. Providing data lifetime information to UFS devices can
> result in up to 40% lower write amplification. Hence this patch series
> that adds support in F2FS and also in the block layer for data
> lifetime information. The SCSI disk (sd) driver is modified such that
> it passes write hint information to SCSI devices via the GROUP NUMBER
> field.

Applied to 6.9/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
