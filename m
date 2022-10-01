Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39DE7C433FE
	for <linux-scsi@archiver.kernel.org>; Sat,  1 Oct 2022 09:39:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbiJAJjp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 1 Oct 2022 05:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiJAJj0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Oct 2022 05:39:26 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97C26E2C7
        for <linux-scsi@vger.kernel.org>; Sat,  1 Oct 2022 02:38:13 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2913Bt3Z006784;
        Sat, 1 Oct 2022 09:33:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=kMgst72l5AoDubHffcIJx6iWBh167njPkOiJIYYolLQ=;
 b=xqxP8Nbm8uaaHIoRF5bdu+Htvguy0s5egYBEu0S0mNYyrBrcX8eSTifT8aTjyN0qZQTf
 0lBQqUDf6QzHEK31JvQNk6BH9T3k6Uu+SV6HCu2ociYZRdqsYxnyxXhMuaFHcGC525/n
 6mG0ul1ASGwUhrcmm3MpWZCg9/5nHWHxlTr1Yjftaxddw6joNZeI5nTzEUtmp7IpvUwe
 kTl1nj89x5iRLrQcjNbT7uaiHnoH25fXRufFsZbpBJdqmhxvA4QyabY0uxMBgtnEKpxC
 bEKLdfP76yjRQF7GSgIym/At522VH7cXLNBQg+kqR0SO0akdNWDEUxHtgXnQIMxM7z16 HA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxdea0d9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 01 Oct 2022 09:33:02 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2919BK3R033796;
        Sat, 1 Oct 2022 09:33:01 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc07xcku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 01 Oct 2022 09:33:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FGf/IIh6s2eBwgBltps9bc50bbkX9XMfdGgHm6Wr50/K9DZAFRkgwT3LewEeZUc03wXf/VUTMqnCf6zfoF52lQTHZYWHmyPt6ptWQEBgBOD2tvds0WXJs4prRrUOz12k2O4ykk5iAYrs2khErCfUule90M6PvMeffV2jLUozM9aHgeULmVm8RYjDQZegrBzWxRwdhT5fOxGGjao5waqvnCbHnzmwZEP73jOHX9uf+2lLABjVliJBK3yP+nbIbcRyN9kKf0pkKxIZYzlCiK16SSECg2OVoDJCuosToqLGTSvV/aET5bpS2wio8/vsxt4oizkiI+ahELM7uFBxnDQaAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kMgst72l5AoDubHffcIJx6iWBh167njPkOiJIYYolLQ=;
 b=hJzdpJbYNsDAr0JtlLLnXy8NqL6C6map9HCB7CbsQKuJS20EfAFwyPhMiZGohYJg/vMvOYQS/5n5nT4MddSgCXhFnb0pgbhHrOj1EovPDi/iiwDBgDg14KQHlfSPfsJhkj7evNpm8d3Gj6YaYoCEKqutPqRLsciD9N0s59zeeqrnfa54ixCBMl0jy8+BFQ7UedeLmDMa6Zp7RjAdXoA+ecQuOwRu6nnYQnH8eEZK7ZWkN/78gI+xX5eQNyUteS+eBen7UMdJny/8B9TTMIjGp8vtzzDJhXrWgZ1D5AB0JVsn2mD9PBG1tm8jSrvDnvCoNyuOnPYmj9g4yVcKgRL9hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kMgst72l5AoDubHffcIJx6iWBh167njPkOiJIYYolLQ=;
 b=dwK3GISX3nREV9K5fl+0DxZbNoMXjIuA39thWpC/okgA9MS5BPhmKpjDgA9N09tLe+opVFJZCWaQ5tIAohUFuh1Qy8fqeoacHkaZpIWoD0zkUn36Ubunu6VsUZ1cduAwZAfkqsLmtz3cEMwDiIxYYCrSnM/Ey5BgBysdOrnOp9M=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY5PR10MB6119.namprd10.prod.outlook.com (2603:10b6:930:35::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.19; Sat, 1 Oct
 2022 09:32:59 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a497:8929:2c6f:7351]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a497:8929:2c6f:7351%6]) with mapi id 15.20.5676.023; Sat, 1 Oct 2022
 09:32:59 +0000
To:     Hao Peng <flyingpenghao@gmail.com>
Cc:     "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH ] scsi/ipr: keep the order of locks
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135c7lwlu.fsf@ca-mkp.ca.oracle.com>
References: <CAPm50aJ_aW4RmL3_n=5CpGL9D3dXENenFuo5QG0Q2DJO9Gv_1w@mail.gmail.com>
Date:   Sat, 01 Oct 2022 05:32:56 -0400
In-Reply-To: <CAPm50aJ_aW4RmL3_n=5CpGL9D3dXENenFuo5QG0Q2DJO9Gv_1w@mail.gmail.com>
        (Hao Peng's message of "Fri, 23 Sep 2022 22:51:07 +0800")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0010.namprd03.prod.outlook.com
 (2603:10b6:5:40::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CY5PR10MB6119:EE_
X-MS-Office365-Filtering-Correlation-Id: 0af1f661-5477-4634-3736-08daa38fedcd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v7wjVPzl0Syx3F04sRHheN+MB9V/s4S8tw7CyaKheJHN1vU438i3AJ8sL3xVjN9WVXt+csdEAFv39SCKKfp8UNcyUbJFaHIvpTd9XzV45vie19nGxNeiVlvYI9GTb9bzaZqlPCVCknM0K7Gg25zFdK3I91fTx/Aj7ggzbRhil1w8+zx4siKHLTwkYnk5U22aR3FbwKkt4aMRjDhXl6O68nIJkOCMbkye1U7w9AKWTOICngypSqV200lZhmQMFLOGt3oE1oGDJ0WAGIh7ejJQTMCMzC6CTvIdAZBybX1oopJdIA5RvTWUxz+itiRcqAgIbHLBAEzBSUWyKV2chJrQCkr+QkYACPyYHLDh/KfPOmLBOiiup3mh7k3WZhxGDz0t+xBnc0yQgpuubmyUinJBuQsRr2+Ivbd4Yd48ZrDy2F/Z2Si7c6o1DZ9znVYvce4OqiOdx/hDEfiVmYPW4y9gD9WORLNa0U9QOJB4chYE9ME8O/iXmYMJjFNqsvTOx/aTI5b2D5w6BKr019uOkTvjyTKMiQju9WFungAAEC8F2ivLUsmgcoEWTNn34EToH7haX0WoibhzjbM/E7xmiVDYn3Cgld9BHy1d0flm4+1vdJpzD1l22SZLJ130/v9//ZJvEzYnjQG5zb9syxSdq5eJ5ABDMVNw4SKZy1e3OPwSGkXwHFyebxl8gn6VFXLg0RW627kDxlZbxIKPhYoUiSl+2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(136003)(39860400002)(346002)(451199015)(6916009)(36916002)(86362001)(316002)(54906003)(8936002)(6666004)(41300700001)(186003)(4744005)(66476007)(66556008)(4326008)(66946007)(8676002)(6506007)(2906002)(83380400001)(5660300002)(6486002)(38100700002)(26005)(6512007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/U4/gNerCOQZ7FghpvwXT65gs7igS2+thIAPh9atxhY56dg61SyhkTLvZYns?=
 =?us-ascii?Q?fyRPxrqDfpSwmZ5MmUHdUk6YLyCRB3dDxaMMjEB8/1gxW8TQBNPae+aRsv9Q?=
 =?us-ascii?Q?NeWTGSqSs4X8VjyVi0QBeT/tV9/0Ekq9TfFiYBHHTQRZZsUYJDmCthsUv9Ja?=
 =?us-ascii?Q?06gRM2PWqhsNOozeIz50Cg0x1jXvNSSxsuGwxqsmhIHN4XY8K68qiD3UcqCw?=
 =?us-ascii?Q?NhvOzuEAfGyGkycSQnOxnAUHjr4GQou7etfRIT19HHA0R44/j1q8yoIndPIJ?=
 =?us-ascii?Q?i8eMMCKE6WFK1/Mqt/hGpHKhIJrrBPl3/gr15f1432PVSYcY3kScDn997Cru?=
 =?us-ascii?Q?bo4VTEQdAOuyBYt2HH+i+8tik79/wnIpbb/DdAZrfnFq+X3ZXomFlhZ13UAP?=
 =?us-ascii?Q?w8ilTu31T7zW8xSMhscPp5CalgO7Bcn5q4owzgTeMgSD7y4+QdtS0QzbBvE0?=
 =?us-ascii?Q?OZttwwTT392QE9wBbVkndujTkg8eVBVSOKaPCgkTWZjp8pWjg3KBPDfaOp/e?=
 =?us-ascii?Q?Yb1WVPW26HwkQx6SxDOqQB8afxNg6MYTYV+/fkD9Z3+eCi7PUkgkQH+Pjrc2?=
 =?us-ascii?Q?i3JIe7PzKJQnhiEPBiZ9rYXQrLOJEheqcWEBGS8OJLM2gJcA9788mw/rw6Ey?=
 =?us-ascii?Q?VCeN7I34dERuAr7zWmfYPc3WE0JLkFMljXkCCBaKaR0CwT5SbOQscowwm16N?=
 =?us-ascii?Q?BQG/08jUSEfS668QLDEJPWYQbOeRSXz5Fe38rfpUSj7WsPD3NKuSN9D+fPor?=
 =?us-ascii?Q?U+GwlH5XiucAWtU++8EYn+Tz33zRDRlqtKCH1CLlUPWLqms8tSCC6CXBRsmC?=
 =?us-ascii?Q?LVkNuQQ3WUlt8dWtyxNa0gx6WMuyPgUT/8LEEn+nB+mllbc3OsgA7cAL+5LX?=
 =?us-ascii?Q?+CTlNXgoyttEp75jobWFDbzvmT9GOwXqKDRlGH1F2h3bfraPaPTqqdj3MYzK?=
 =?us-ascii?Q?hLcN+jM3O3kB59V7JPkWrJv7wJkFYy6si1zBmImeqTwMY64TmnSTP5N5oUY0?=
 =?us-ascii?Q?k47ZPyfu+1utJi5u+WYa/2nfpLLVTjrtlVC6Ts0GnFlJ8HEMmfJuHoP6YYM/?=
 =?us-ascii?Q?4bCUDHsq4eOxnOrJz+GXuFTAzD7alWVu7BKN7tAXFb/6B99+AZUad9pyC5pk?=
 =?us-ascii?Q?6vxwZ3/0vFA537ChFA3Tw0D1uniiQbk4qDh0k8EVVMxzCLkntx11oglZ2oRL?=
 =?us-ascii?Q?B9qjiEpvvaB2Czpp79B43t5aNH/8QrybOn4Iy5EJOACtAkZasVWuxcBxRnZH?=
 =?us-ascii?Q?06kF9PVBg+ADsUqg3kfeS+FNGV9ngjw5VPL8Q2XiaVHQkrh2ZcZmT732os9G?=
 =?us-ascii?Q?CfjC/KoN0wWxyuPaCRCJDI1axbohgQzfh+EZn0C+/P3fjbLL5W2Pix2QPs2p?=
 =?us-ascii?Q?Tl441zyuGTJChgwu2pyjfAZqIclWhpTjF8kc2a29gFzAx1SpAuSQKDiOxAvC?=
 =?us-ascii?Q?3WHhrM71LpLDpOdtok0yKJ+Y6UcfLGwLOwy2Byuey3G/5IxJJv1hPD7A45Ol?=
 =?us-ascii?Q?K/w0gGTHolN3xjRwUnUBppjMT/4rlmVuNlboWhOWjDmkC/2ZPjbj12X58N/F?=
 =?us-ascii?Q?USmJNpkjbujLjh/UOgYLKzl4eOXzuNktgyMXqoDg2fR5EPxW/gnX6q23AMJC?=
 =?us-ascii?Q?7A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0af1f661-5477-4634-3736-08daa38fedcd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2022 09:32:59.3209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gmr5U7rXHMTOjLT47pxi8AF4qc7DSCHguhRRg53Cd4gg3JcLbwSwPAvIdRozfRSarhGHb+T+QcqHvKWI/BFj5ObtDZuzAo5/tdnoxCXwgr4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6119
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-01_06,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxlogscore=862 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210010059
X-Proofpoint-GUID: daq1IKuDL6bIrO2R4XZtTxVlTAAGSZTt
X-Proofpoint-ORIG-GUID: daq1IKuDL6bIrO2R4XZtTxVlTAAGSZTt
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> As shown above, there are two lock acquisition order changes.  At the
> same time, when ipr_device_reset is executed, the lock hrrq->_lock
> does not need to be held.

Please make sure to copy the driver maintainer when submitting patches:

$ ./scripts/get_maintainer.pl drivers/scsi/ipr.c | head -1
Brian King <brking@us.ibm.com> (supporter:IBM Power Linux RAID adapter)

-- 
Martin K. Petersen	Oracle Linux Engineering
