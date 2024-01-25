Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7868967C6D
	for <linux-scsi@vger.kernel.org>; Thu, 25 Jan 2024 02:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706150473; cv=fail; b=X/ccnSAxLMYt5JN6+hssxgznXy+2L+HmuMm71PNO246ktZW0YE/qz1W1eStVrzYYMG6lpa9NkRWKJ32x30qyr2NIXqpoO4byORR6Q89MumA3gjKPgkrwxG1CjvbwO0PibHMcyOiWXm778/2xJtyyoIaTztYkv2YJ+1f7nQS5/KQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706150473; c=relaxed/simple;
	bh=UzxTMaKCPpOdhsMV4r9LSwsoJoErmoJom3lIi0RWJRE=;
	h=To:Cc:Subject:From:Message-ID:References:Date:In-Reply-To:
	 Content-Type:MIME-Version; b=STFt4Esb9lDVrLl7BMOneAJkZT4Sdh3MvCVnj+p2kKF1OIla31jaRfkkaf/3MR/NtkMLQII3qG7pWImizxy8c1+HMMHbVMmx1/wPuHvRpBF34Xa2ytvF+1vhFin0iFdeC49Yu1XMdwm77id74AQ+FRCxcMjGqnShUslyt3sZR/4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SVtcxQxH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZuI9VQzZ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SVtcxQxH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZuI9VQzZ"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40OLc5oE008145;
	Thu, 25 Jan 2024 02:41:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=ANXftwDigaUS5IXP82efW9i7uZSR9jsF+bE4PPcakPA=;
 b=SVtcxQxHVxOz8eIun6uetBAATvK7y1zTDDG3+IsE6/lLjeN2m+vLICMLhPDB/dhz+2Za
 6cD6+Q3vqr/YTE3kXZnxEES+DTJkkTzxZj0lyjgsCoLkkufHdi9lLZecZ5MTcvL/74Sl
 MS822e/THpwKjB3wbTJTLTQQ/x+1PZ6b1WemIUfhuQhQjbv0w86rU7pCg4RdodvcqFQu
 FKwiNmGXOzmBsUVvIcT8j4kdMkBRV95LlW27wMOekFA4QRi2xatb8GIQyX0rpEQLJavC
 5kIWWa18Mon+tulRI+u1qYiLhf47TkeBEK7gGD9s5xcpndq0zrITEslemSs0ldNoLvHT LQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vr7cy5ee5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Jan 2024 02:41:09 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40P1ARAk011685;
	Thu, 25 Jan 2024 02:41:08 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vs32564rp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Jan 2024 02:41:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dqTugboeWMm8GOUyv9mk0uS3t8F4nEjo1zlyu4z3/+jv9L7Z7sBv7JUl3665n8vkGTKAiyqX4KstT14bv4Z5MYFDQvzi1jpSRbEMlefw4+pNOQL+8Uzor32NWzzwZmmMiFzvP9E7c0cdfxnyLZxEOFugylYAJ8kTtUGW2OXzI9C/gJ57IXadhX5a4lXJmBm1gZ6p1skKhARAelSdbxxtLsyoxNkkYZKO2KRvEhxeSGJJhcFprOQDC2BY8u9MW0LQk+04kn/9RTjNWV/jToWFUkQ14eF7pAr3kkbrGjNebQ77BDPpmeQePkLhSctb7p0UUe7YZi9EbXVUErNrP/+inw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ANXftwDigaUS5IXP82efW9i7uZSR9jsF+bE4PPcakPA=;
 b=oTAML2ACGY/8lJlzWwrzCYTr1VHOritDLfPnoaMNEV8IzyTQyLJWRUggeHTYAFcnB+TDT74KHtFdTVNwB3xeabf0aSnIkFC62gbO6ixelso8Dj9s8CrJg8A81AlZ2mAVkcmzFVuCQfqNiGOKW82YuC3bM+p7CTmecGVVPNvm5Tk1ZFKZo5BMXstnjyowOpB8oE0ySzXU1fgfh2pgrzxSI660r15+vP5u6sLpjfbI4bviL0igdwdj/htqKTHCIhcD4PxkBtyNtYBDZeFuReaI2AlYuAMDYpUuHSOjWPOFM5KFHGON4K46OqNxuBivSg4X2kURBrhANjVz7oKN0C9QIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ANXftwDigaUS5IXP82efW9i7uZSR9jsF+bE4PPcakPA=;
 b=ZuI9VQzZlGvk8tFjMDp6eAS5tSBctW+QXflhHTvxhHyk/7Ic++AKHdHplxDcqMLLPLwEnxUv4R14QuZDJyNfYEj5V2BUct6mSKyk5O36EPTqPpw7jWcm+kuBoR95BsF0a50E7GR4xsSmNDARaJi/UKlJetA3hJ70+7jcljaLG9g=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA1PR10MB7238.namprd10.prod.outlook.com (2603:10b6:208:3f6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.37; Thu, 25 Jan
 2024 02:41:06 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::3676:ea76:7966:1654]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::3676:ea76:7966:1654%4]) with mapi id 15.20.7228.023; Thu, 25 Jan 2024
 02:41:06 +0000
To: Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com
Subject: Re: [PATCH v3 0/2] mpt3sas: Update/reload SBR without rebooting HBA
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o7dauod0.fsf@ca-mkp.ca.oracle.com>
References: <20231228114810.11923-1-ranjan.kumar@broadcom.com>
Date: Wed, 24 Jan 2024 21:41:04 -0500
In-Reply-To: <20231228114810.11923-1-ranjan.kumar@broadcom.com> (Ranjan
	Kumar's message of "Thu, 28 Dec 2023 17:18:08 +0530")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0025.prod.exchangelabs.com (2603:10b6:a02:80::38)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA1PR10MB7238:EE_
X-MS-Office365-Filtering-Correlation-Id: 883bb5cd-013a-4098-2683-08dc1d4f148b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	KqLHeUgpQkl/Pg6F2QQMD+jBoANprjbByT6fnd+NC7SYG1FZow+r/b0EeytawWqCdIzKf4LF+XAe89KL3Kr2Rg9DRtkfb9+cs302yM0A8Anhr2/IrDT+9pv8QaWylXftwRiu0yt+XU4hCI+SDh2WSYjfL7fPRyua3pI7eU/hW/sgRUhUaUA/2K2HxI7OVaMqfId8byHDrZKZrtF2nw2GwhO52qpBFEp4+GPFpXWJnAkPq7aT/9gJaJKd9i15kUJI+m34Q8C3rHG0HNEbvgflAgL2sSnDujKBhfB3BoXStTHyiSUBmFanzRp7TnKXi6Q6iNtgih24HwK2XSd6/OBgHpT6oqGlzvH6/RYeeh1nrfw7zq//D5alOHCLDAau+uvQqcFzTsjGgs6kap2H9wPSZ1lT0pWkXkm0khf8u3N06bN8HEulgLxqB8pb4JFOBrQfr4+ZFp3y3/lAlBT7nJTFD3wqRQSbvc6iYj1C3z6tohKryByIxkDvTmFc0/0FzdiJapHspasN2yGjU5lrRomORHBhD1Yaa9F88mOK9/Hy2RISTh6kT3DAU4CBbVKHZkAVK8hwITAmFM0p/KiDPy4jEHQyL3gRw7OsD9+wC0Hjdiw=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(39860400002)(366004)(136003)(346002)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(6916009)(36916002)(66556008)(6506007)(316002)(66946007)(5660300002)(6512007)(66476007)(478600001)(26005)(8676002)(6486002)(38100700002)(8936002)(4326008)(2906002)(41300700001)(86362001)(558084003)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?XBDzjs0UfCV3O0RRdVJhlJd51hWKvnK2aNyjcEKlvJBzD9SHYUKGcZKR+XIX?=
 =?us-ascii?Q?9Gwf1fpy/nv9menKlSIdVOBFZYGzCxpk5xyVLOoPW+Unu0oKTUbkPxYXQymQ?=
 =?us-ascii?Q?jAaFulWZb/MUq85QT22C+umy4ww46jI9+y11EC7t+emhP6wpItonZUmMWZnX?=
 =?us-ascii?Q?Bd1Ehaeqfz59BH2MZoaNjpCbd8MPdIWMOucjCmAfBB/ku7lxu5UbrwrhmCKP?=
 =?us-ascii?Q?Plr5X0g/FzYEMjHnrCyKvmJXAo8IlBL45l4AmvMcA3G5JUNSVMIgU2/SMY6k?=
 =?us-ascii?Q?T6YXdvWQHGKYnNDgBZrxITSzXjHxCf+jvMccLP/YtsAsHVEGBxbqrNCVSrMo?=
 =?us-ascii?Q?aAP6fiDI+oLLjTXq3phNj8NEWY+C4QOmvdT7kzagaXxMnGdmDfs4xOT80fgX?=
 =?us-ascii?Q?SFEaoD0mxKBsDKyIOZYeoGItRy0Di4LnlAz709/3nKHhoXUUUlsWv8dyJwCK?=
 =?us-ascii?Q?Ei7G24I3gCsA19dPtoRSo4ZsTOD9v+cg/VlN6pZ1vf3UyjRSp6Co91lPP1jN?=
 =?us-ascii?Q?BG6APt3AcbGzoAGXFcrdez55Wx+/8fQWXL3UZN2tn20NV9DHQv58DRn+ke5W?=
 =?us-ascii?Q?Aqrno+R/DX//zPWG5L+7CD1pk0bUKfzixKuXyWGEXWQzPyvM0S4kH896ctci?=
 =?us-ascii?Q?NTJXjG6lP0yW3Bw24Klm2KB1mAisPOAXmazZjE09hEkFG0VsD2MmQ72064mw?=
 =?us-ascii?Q?j5EpEi0MNfg2+Nh5S87kEZV5ps3x6JVuji9rjb57tycF/xSA3mIBN3bZqOfm?=
 =?us-ascii?Q?xoKiJ5OiKMaTQ9mREx4AXxuS5GBK1ecx0bVhKSoYNgQInvAFAx6/jWgVH5RF?=
 =?us-ascii?Q?XepR714ewi+kToSYQ1UdIJGhUFYwnUnztXLvXIIUM3qITxmhrqAHokDVloiv?=
 =?us-ascii?Q?gxKAE9F+qsywOBwx+AHozCnpfNWNxLbIAHirXS/Qg+S4C78iH/J2rGw5m65K?=
 =?us-ascii?Q?sHt85kxdrUvNGp2vKulkcqhaHRPaccIR+ZDOgqR1rOM/WZnY+VqdrWpJhGyt?=
 =?us-ascii?Q?tlogXjBOrw9M5T6RcMGTTRFrPtT/Nq2ADzFt6VrEb2h2CzhBaULyqCEHI5x6?=
 =?us-ascii?Q?uTP96iSvDCYxAJZQrx12f9JgyNQsBPb8jh1Q8CS9sXFDqf8t8/9oubJLxBbQ?=
 =?us-ascii?Q?Xxd0Hvtr92zfg0m0/w4n19KDlgAV5aHJGswqe/MW1o1hTbiqiFX4O4TAnWZ+?=
 =?us-ascii?Q?/pErOCcvH4FWV2Z7SZBeJRRCrWB2Vl5g9d0s9AALjxJJXqNR9GN8jBO6EUuw?=
 =?us-ascii?Q?8itDTO670qHcptjMLUVevnwCPlrnzHqSKS2DB4ggbbestO8u7EccyCAKblXS?=
 =?us-ascii?Q?CqugpGVrcSGNvmzcbfqP3gi6Q5jwNE2RciqS7w1DjHlReqrIZ9oHo6Q+1Zkd?=
 =?us-ascii?Q?r4XmQWfZl0s6BZlBIDFQQOZc3hZY82h0I6II6qx5cEM89cQnk3NCERKAOIag?=
 =?us-ascii?Q?ug49d9FE/yCtTS/UWC363i+8f1/E02y07uDaJFGz8GMv9K+cKmVmuXjkYIb3?=
 =?us-ascii?Q?ky9TCnDEfb6Cc5Hlquu28MvsaZrIWodUK3f+FdjsM13QlKdRSnCOq+orzk1U?=
 =?us-ascii?Q?gRAjXNoCy4eP6Y1+bGC1ZLYn+rWvdwJTNVosC51cne1v46cENuunnWFSjZqb?=
 =?us-ascii?Q?gw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	9DKRObSPuT7DQE5sQc/WcFjKOcU1YcU5f+ZsxmBGVr6sut0mtISIe14P6yFSy932L18Ivnrqn/iKbQTs0ucKjtgx6np3wkzNbSGf7XPY2VL+Yx9YqgjqygOwVQxV8Nj1Foj8gCZ2bkZYhTdcznRRlAmMWZLxm/FrdRANzYB9n7tFLRpp6gOA9uGA39gewHNT+861LmEnWd+DSbLGUYNLk7it3QaVzNp0BVfgLeNEnZ2ZvO93UVX0BwdrwDvF/tfgMzkWP/ZrCwexypiFy5G8Or0xr5F2w7dLBJtQzjqsrrxeR2SQYIsUEqpylNOqSAcMNdZi1941315lDqFY5dm1X9KmMgHaWEWQX5kOL6ShKzPsD9d76joxl+tHAleFmLmT/ZD2eCl0UltXwrth4YUXPSHJo3ahQ3sDWoXiWXWDTeKVpngFA4tPpMrdPjR+yWND+PMweaL2oDyBywU9kxb4WjWO7GH7BIH5satUNcL82SeqHPXyQ2pPqzMz+bG7Y1ADHQKDbVF2mzjTpRFVVwmy6WcBAWU1W+86OjeWS3/LFKQxNEWA4nqUCSE39/D7h4okhZGvCtytlDWPOq2RTXQSDkACe5QVn35zzjmGEXgPN2M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 883bb5cd-013a-4098-2683-08dc1d4f148b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2024 02:41:06.5079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2kEOU3llyRHkLM1/kKYntqTAeWDYJrUUgbkbaiuU812fCSZ6KNH2PIJKO35CzsStA/EZ8QgfpXVgrIuFDaE0skcpprNaxhu9I7MBAm7EwJU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7238
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-24_12,2024-01-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=819 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401250018
X-Proofpoint-ORIG-GUID: 1g-p1XWdwE_POvcqZK9F-iV0JKdblmi0
X-Proofpoint-GUID: 1g-p1XWdwE_POvcqZK9F-iV0JKdblmi0


Ranjan,

> Support for additional IOCTL to set SBR
> Reload bit in the Host Diagnostic register.

Applied to 6.9/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
