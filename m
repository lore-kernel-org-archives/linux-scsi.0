Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDEA3C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 02:50:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236716AbiDSCxc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Apr 2022 22:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiDSCxb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Apr 2022 22:53:31 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 342B424BD1
        for <linux-scsi@vger.kernel.org>; Mon, 18 Apr 2022 19:50:50 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23ILv8Wa020622;
        Tue, 19 Apr 2022 02:50:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=i7etUEXcuKYZqI1lH3w0fjjdcsuh5l2MxbTfMvY1z2Q=;
 b=Ake/esocqfdmCdaSUwnQ5ehPROMQ/2thlCtVJUnz7nyUU2xfJ7ACF5N6KtTDCMrTuwQP
 Q3TYEeMOaMRCzAgCXI+vQtY9ZSiBGEnryDhtl5D5TAeoGVL+FiKmzQmEYkFT3bTIVGrQ
 hiUOMGbrBuLmta3lrXWHRrtyvQnP0cNzQp8fu4CFkgJ+yHzXVtQ++hSbCpW8UmxXC33g
 zOjiCc3D4XTivur8zbMAE20XIZbJx3kfI1pyoeGAwKK/exPtMqAAcHTAAYijNr2FcbK2
 X9KVBa4ru7JRoYtZUGydE1ZydyjiJdTUiSdXSJyj05gQ+tK4Qctr6P6dn27gUCUxWL6h jQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffmd14uk5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 02:50:48 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23J2kZsK032420;
        Tue, 19 Apr 2022 02:50:47 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ffm8204q0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 02:50:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nHZhp7ArLToJex/HkhSzAjqfhG3Foe8bOAZNzwDBZPycaO4/2XzNq0s0/j/0QUIneHRQtad+1u810WNG2P/laFX+stLJF5Cuuld4q4YFKN5AmB5Rh4Nd9RUehENfB55UA4ryaQxC0nDxptObjmFhskNnB/mMXWOt+D4mc+upCa6vRe3Z6AzK9myh+LEqyEh/azcFBUik7vlYwCblKN702v1je3Mg3uf2S1LTkfHUvDOjPoMCQsNjvUUyatF9foJAMdoae+IpS/niQaxK+1XCl5pf5etywdr9GYf6f2ZX8xvHSDDBBwkrK5mijhPVOcmaC3d7Bk808bHRCPc3G3gCpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i7etUEXcuKYZqI1lH3w0fjjdcsuh5l2MxbTfMvY1z2Q=;
 b=ACKFrX6p74XZq8d6XXZAsCC7Av68NZqF9weu4j7MGKm4BTvBKx49CW4iPPXz7JJYxQYdHOVdN5pn1H23YU9wOwtQORCutknj/n6S7JdeiHl4FJ8tpnMM7KCpBk1IANrXBJbiNcGzUtMtn25+7Nrx8c+sKXO+H6d1tk5iIZhA+vFTPPQma1l5vhT925Xi5wt0ydaQgRZdbs+u8K1C6Be5qFMwKifh/UPUzcXCiBG+4XrTCLBjdC6qjcExMSY1V4OUG+zUkdlF9Ik9xS8IRRTIqEh5fQ5kiJ5Ft7DgMa3CEH/dnMKXkTuOd/bm51dxwn4m4T9S8eVUYi+Dfm53hyu02A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i7etUEXcuKYZqI1lH3w0fjjdcsuh5l2MxbTfMvY1z2Q=;
 b=J7FXIeHRPLgKDCpy72ZIOeZQA05yDfCcENSPHrbkFi2MdaO4Avq+w0i0yi/rBlShKS6jQEDA/TRQfdIZ805OIdwJbPW/Fcs23BjXZuoVg/oZC82RuznarinM2w81cHRftf7JugjYj2pNIQkFe7ajef798A8JKN4HazX+eLAiGh8=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SN6PR10MB2541.namprd10.prod.outlook.com (2603:10b6:805:44::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.25; Tue, 19 Apr
 2022 02:50:45 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%7]) with mapi id 15.20.5164.018; Tue, 19 Apr 2022
 02:50:45 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH 00/26] lpfc: Update lpfc to revision 14.2.0.2
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ee1tairw.fsf@ca-mkp.ca.oracle.com>
References: <20220412222008.126521-1-jsmart2021@gmail.com>
Date:   Mon, 18 Apr 2022 22:50:41 -0400
In-Reply-To: <20220412222008.126521-1-jsmart2021@gmail.com> (James Smart's
        message of "Tue, 12 Apr 2022 15:19:42 -0700")
Content-Type: text/plain
X-ClientProxiedBy: BL0PR01CA0007.prod.exchangelabs.com (2603:10b6:208:71::20)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 040521f3-ba85-4f32-6dc4-08da21af66bb
X-MS-TrafficTypeDiagnostic: SN6PR10MB2541:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB2541CDFEF8331B5FE5231DA98EF29@SN6PR10MB2541.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p2Z7jOm1aoUXKvJRV/eb3gM8XEG4AvbVgbqmp7XD7DYTctfRC8VDLQEoLMELYffhRrxkb8vEnXdZP/Zj+tPfotKMsn3IU9tXD5Via69k9tmR2L/ePapck3WM2ySc2HKhbOE/tohRjdxldzO+6S83x/ysQPW8Q24T0uAYO+EzP7S+ZBSjK7q2t1Yu5urzRFIC32GVQmsabv8/xRFOOOMl4KsKL5vhNN5x2PyzmoRUZzHq4XGfL2lChgp676IpmL/k5No15fHC5BSphD+0Vf+01JPjoK8TDoRwGAIRCKt2fABO6pjc0QIk1A9qcMyBgq1zjavrCpy1jX5CHeBz4dLNPVQVW0iXZvG6ERIVgngy3ZbrqkGwgE1UkI03pLslPw8LRHPcWk+S+x0nfxtXFpAZkfxirrbY3aHFTSeQHAYc19b1naZBcyD8H3h70KcqDsw2XyzbtG3U+WjpEpyCi1SUp3DB6zwbj06Eaq0Zrb0SI06Oq7zLpBoTzkJ71qvS7k6bU5X+FerSy+mC6O0eYSv9VI5Owa74GsKK1Z79WCcG8yXAbg9BufOgCZDOgtM+9fS7pIm9d/paGrd3/NBCsziHnp9KkfnyqE05Hh9g34wd01GR0mBu6PtE8GmNixq/T8w4gztlsI/mYJnAq6kgCf3LskBrWUU8MIt8UKimcUznuUjPU+YBjIcWvd52uhfhkKixFMzwbbU+uWzLdkmitv7ELA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(6506007)(558084003)(83380400001)(38350700002)(52116002)(508600001)(316002)(86362001)(6666004)(5660300002)(6512007)(36916002)(66946007)(6916009)(66476007)(8936002)(66556008)(38100700002)(6486002)(26005)(186003)(15650500001)(4326008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uqn4RJeSfOUlry/iptUU0WcBrEEo9sMsCI05G2C4tDk4qrd9FqsDf9N2mwg4?=
 =?us-ascii?Q?go7qBmoqWzUDUtduzlqfRm58y6YDNQbNpIEFEKeJEfQsFp+XdE5LSqpc28rF?=
 =?us-ascii?Q?0erbxKt9WLJZ3ABXCkPLKmE0eFxWFw9N7nXhfu7i6AR07+tTkTdpEDToznJI?=
 =?us-ascii?Q?PicdfEcXqlYBxkIi+h432Q8KuA0d64fZrCspV0bgv7IGkNsD41PN4pMuc+wM?=
 =?us-ascii?Q?fztJ8go+l1hx+GOivjNCNK3wVDvlvgqObdb7mgUvbmd7GB/v5weZoiTvrtNb?=
 =?us-ascii?Q?a0gxUdWe0hrrh9lnJz1bwQs53w70vJIEtKsXli1AASSAgc/IuoRjhJBb27IZ?=
 =?us-ascii?Q?Mi39/WjsV2a3HvGlQkRLoKwuF+uuMFvADTJJnp0O1hdjoPUgbEB+bsVnui5X?=
 =?us-ascii?Q?p9Eff8rDXO4SBpQZBoRaSBKOcspt2iABFLMOAUk5M6ZQyhFVo1i5Up3KeqCn?=
 =?us-ascii?Q?pFk1XmuLImg59T7AsTz9YwWOnWf72Y3CKfeKb8O/N9WIz8e0r4BdvnuDbu6F?=
 =?us-ascii?Q?eiusPqWyfUOq9yO39AV0D6kpkSsRijUs4mK8zIwNGs1qZTDfF1EU4S6p9ewo?=
 =?us-ascii?Q?oqc3SR89RJvrIpjLcWJ63Hebt0ALVw4JaS3es2dDnVjYcLBEDHdjgCGFU4CN?=
 =?us-ascii?Q?N+KmBJfbUX60y4oZWGNz55hnpCwaBlkS6hvb56vRhjQCNSx1I+fAdouaHZmz?=
 =?us-ascii?Q?LIyzaaLZjYUZwDwXkxsxR3aJzB8K/pVXeBeq2DPbq4yVqqslWxH/PuRhU+Z2?=
 =?us-ascii?Q?WRiUV95ilkGd32A77cRCouj6nIWENYmY0jQ7suAY9Mvbdx1O+eq/xQTSh4Cd?=
 =?us-ascii?Q?d+w+TsypWt4lvEyF8sxDZ1kre4+RYCb9xLFwfTqKNQt/NxJ54ik0dL1MTa6s?=
 =?us-ascii?Q?Mji+WGdAOX7qUMILzFXkmz2DMdQd09kkLTlRgiOwBVKjZZmYYK8AHWoQBSYN?=
 =?us-ascii?Q?u4QDckqcD5v5dwtsyIgb5ahdmTJDgDmqGuS9yfhyp182M0toFxJPCEHLrgKl?=
 =?us-ascii?Q?VGI/4mkJSeZmt9O0Xek9GoStvLqv7h9/Fyh56Ak76lSrwbythl8AKLL2WB+x?=
 =?us-ascii?Q?AvZV81mufJsI2zg3bDlTU8uA/CHf6oAKWkBY8+5b21cFW0UX8kj7wJ2Ialtz?=
 =?us-ascii?Q?Khmon6+baEnLtvdxKt8CPfsOVwO0KJ6SbgvWYm6+2K5SnvsFjo6jMWwi5dCA?=
 =?us-ascii?Q?OlilQcaoHJAgWjsWO6R+2lKRYuK2J7auNBW5EpaAvhZAMsk88muTcgT5TgDr?=
 =?us-ascii?Q?S2kgNHakprWq3krhfzG7EqDH5azgkEpbqE3L0jodRKywozHrFbdrUeOJXDAY?=
 =?us-ascii?Q?vb7YtY/utEAit2toxfiCCQe39tTpQQ2ACMoTPvqDU0OyGUT9QyOAg5J+gdiU?=
 =?us-ascii?Q?5Cjo2XdEhnmfYF5qWIRG+ClbzOnLVpdy81AbCeJGlxKmCv0CalnB2NXEQdXJ?=
 =?us-ascii?Q?+ONEoiQjm/Ue5KyamZeeTv+KasJCBzwMx0/bvGq1eF1k7bxixQJT8QLV5Mb0?=
 =?us-ascii?Q?7qh+OoOH7uXjlf5FXXoDe8pPMMOsaTy4O0I4i+sX1zpv/X6fjLDCO/BP9clf?=
 =?us-ascii?Q?sl72EYGkmZLPBhrDVGf8aCu1F6CSTWxlq9SJ5FW1yAJbwXzIljptICcXgfoK?=
 =?us-ascii?Q?jjMageGcNEzXtADcSG3rbR2b8Stn6eXBEWxhawqVEK3N7rA3MVxWmLw50Gm0?=
 =?us-ascii?Q?GtlfglubDvnSAegQi6Pia0y3d2vtlgGoWJMsIJ/D+iRv+KVtUchMG2qXGuo1?=
 =?us-ascii?Q?G8kg3LLgg66Rg3YFRqHD8DkiPm3fOto=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 040521f3-ba85-4f32-6dc4-08da21af66bb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 02:50:45.3998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H2S9GyiggeoChvy+whLSqjJBTEG3u6d0Yeft4eAYmBE2d29Wmk/1A7ddMAD346AH3as5sm+2H8KwRTlkgL7CynCBb5CbaT5OrHwVAbX3uQA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2541
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-18_10:2022-04-15,2022-04-18 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=519 adultscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204190011
X-Proofpoint-ORIG-GUID: G0KXxaVSwNUV7hDLz8MfziwawBYTVMYw
X-Proofpoint-GUID: G0KXxaVSwNUV7hDLz8MfziwawBYTVMYw
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> Update lpfc to revision 14.2.0.2
>
> This patch set a bunch of small fixes, several discovery fixes, a few
> logging enhancements, and a rework patch to get rid of overloaded
> structure fields.

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
