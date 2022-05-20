Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3FEAC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 20 May 2022 01:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344173AbiETBBv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 May 2022 21:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbiETBBt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 May 2022 21:01:49 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2414A56F80
        for <linux-scsi@vger.kernel.org>; Thu, 19 May 2022 18:01:48 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24K0IsIc005482;
        Fri, 20 May 2022 01:01:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=4J9Cre7P11pJfYMXAJnWzMkGXO02OgV/VbRniDR5yDk=;
 b=g2anWA+xJzJc9G2vXb+M+TsY75g0NMDDQ0nD3a9JObAjyDDZzKDSK3ZUxgpAl0wi+MH+
 i/ngNE9mLRY6iGhdH25de7RBMKDNnN3Q846gg4NE5zX96aMCKYk445S7OnEShfUmuUu4
 /fNpwQvwLAE40wr38C/xuBKfiEp4cxGPTFzJpATz12skRjbTq9yWH8ypFvuoY+mAVcru
 SydW96MgL5Ivz4wmNhNqVGUqWQ5h8Dw+RpjHQZ0AF0xPOCV6SdDXhEor4UXc+S8ZwLaL
 R7igvXbGpLzRxRQKOByV5IPAT/7R5UnXNsxuApfY7VFyGW/2Tuwj55HJ9bv2R5aS9yUW bw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g22ucddap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 01:01:41 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24K0tnN1036210;
        Fri, 20 May 2022 01:01:39 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g37cryj3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 01:01:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gx61rwGpatDe9kVvrJP6+zkudNvIq9E7F2DESZepjdm/KH5vH+rqBv/IOlfoc6kBGOCj6ytJPcjEjD4C6U8pNcs3fd42iS+ea9NImGHQCdcjQodbtMzYucMceej9SYepi+ap4CknEeMKdGtF/ePzJ2fCZhcz5DzyISdkB4DKnjDT4X8thDZx4yTzLn94HzoN1/DRNneqaiVCg1J0K9HIUsFkbNPRJRm+3L6gvO5dWGQgNy4vtqnBYEkbU5ptRR6Jha8mc8Vfstmc89Mp5sdB+B42yFtK/eMsJHmy77Zw4Sd2Hf014ZMlaRPT/hnIjjoj9FaQAMFwNMAe8R/24RxjWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4J9Cre7P11pJfYMXAJnWzMkGXO02OgV/VbRniDR5yDk=;
 b=QVjeiSxif8V78T4EdwlSyiU6145N6/aK/EguGRg/NcFcxv6G4yj5ri2AphRubgM7HbHFVgILj8Yfb/CqfZyJjexkCaP/GtnmbkjfrcyLrH45KYUqSFBpxUlzfys3Q5VzG057b375mEj5b7wjKy8vGREOVOWKKRLFTam0XAXNg4O6zi8KJd5BiPuxhCDybQqBL/2UTAbQNWZvCOQvf+W4MERQHVFKSEUvlokk09HcBedD7sWUVQPrzHvaZAlmnTU9hYMj0YcYI1M8uOkOvQ8VDv8zIx08ohZK7e0tlBxQ4CO7YCH/d2c+XvdOPzaRz1wvVPfonpIFIXoMzdQhiCsmIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4J9Cre7P11pJfYMXAJnWzMkGXO02OgV/VbRniDR5yDk=;
 b=UULO5KTwlN6JhwH8kZORyJA0LTn5C4qgMT/LRbweWLlxYVo9HWM3ZPDkr2c/8xTrepVYlyPV/zgRpJ8v8GOOVv1NiBn9z30mkvtmmTmEuH1mX2Un/cEOVJ3XLHHCys42NIkU3tvc7/4PVWvalx3A4cqOAzeokYR8TDCIvFNLjFc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BYAPR10MB2806.namprd10.prod.outlook.com (2603:10b6:a03:88::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15; Fri, 20 May
 2022 01:01:37 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5273.017; Fri, 20 May 2022
 01:01:37 +0000
To:     Mike Christie <michael.christie@oracle.com>
Cc:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Subject: Re: [PATCH V2 00/13] scsi fixes, perf improvements and cleanups
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0ahkof1.fsf@ca-mkp.ca.oracle.com>
References: <20220519003518.34187-1-michael.christie@oracle.com>
Date:   Thu, 19 May 2022 21:01:35 -0400
In-Reply-To: <20220519003518.34187-1-michael.christie@oracle.com> (Mike
        Christie's message of "Wed, 18 May 2022 19:35:05 -0500")
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0056.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7195ec7-04c8-4509-917d-08da39fc4abe
X-MS-TrafficTypeDiagnostic: BYAPR10MB2806:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB280693C411C5963B3DD31DAF8ED39@BYAPR10MB2806.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: faaMUr5nLHUgQXlYwCuUFwb+Ql4VFRnEJbYXFKjM847s9Hf7v6ltTwIgy07BASS/ikW77iKm09XgFBbAc4j500NZJeX5cVoP/MeH5mJIiz4da8bPi8/R0JfRSYzTXQFj82KPSaVFDifsNfgWmaGtGGf55gDVqrRMesTU2dXbj6NenXRJyCfiLG8/er7whg9eEhhoYh2sDbrtoJ3xng6XLOuLUdK2Zr7bmMa0ImzZXNAxR406gy6TX+sNL3UwEoxtmVOuihedaakBxw+42XuaZRDZ5cSSAofmbAvBSwbcFrPoqzMKFfe/LXlpt5k66SfnrV/cCs3xicgLtjFOsDqPXjXXk1itYhfDyElCdhk4WiM7Hz2dglEILsb1Zk6O89ZxZ7LBWD4hrzsqxOTtyflaBm2xStAx53aAAsKE5vwXLeAKK+f52L+4Z98gPgAkYQ6W2v6LowsHOBk8li/f71wk1cd66XVhRJNioYL3EGETqzvowVnXld2/kmdbFqRmbFWGO4zDbSkwOz1ZPVFMXvZ5SayzHH9P6BEVr9KwmkLM3W8XsXvA32dyBCSf5jU2WIcsBZglpALmqFO0PJ4hNPyDh40v46gsE4J/CpKouaS3HiuhG6Rls2NCL0RxYN4X3E1RtdPVzOCbSwbHQxui27gWV+JxAqJ+VOmqcublxWnyqS00O8E4di6N/Ea30zvbMTxY0yIhTcWwkHeWHjF38lpEcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(52116002)(6486002)(38100700002)(36916002)(6512007)(6636002)(2906002)(38350700002)(558084003)(6506007)(5660300002)(26005)(508600001)(316002)(8936002)(86362001)(66556008)(66476007)(6862004)(8676002)(186003)(66946007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?37cKit0v2VqCd5F3eICnjZJUgP57v2IcHlrWjQy9MzDJJEMzuZ12boVcX8jB?=
 =?us-ascii?Q?sQ8ok5Huf+IW4EEM81KpOQmDzmNjmtKZj8aqD/v0wU2r7etITRXBX9D7DRiC?=
 =?us-ascii?Q?qA8Tv1HUqXLCgpILhAM+x2UroLbyFn/Z4Ns2xLH9WO2HQw4qqeLYZzPwBMmE?=
 =?us-ascii?Q?nXTNbAwIzk29yYvLlX28Komzcg7L47bGbgi0R6NJIn4MF13EJX9GuFIFduub?=
 =?us-ascii?Q?zcgX99+WTp68yaSXbYu+1HI5fs6MF4RJwJiOF3xKMrdD5TZhkKtFKVZhHKve?=
 =?us-ascii?Q?8H/xgYoXwlOdjsWkB6x7qjM1xl+4vZeJW3EtA8LN0EDZ4IQQzCbs3TIe+WJr?=
 =?us-ascii?Q?Akv1/JbyPXqfhPm54SKZaaPY0m3srWCmOgT+Kt81D7PyTFA7xrPEeQlmyLTZ?=
 =?us-ascii?Q?qhkjbDHjhcXtUISmSpy2xCHwQzJ3g6RGSJGPehQ/w8nZ5nhFz4N3JECCdVBt?=
 =?us-ascii?Q?Uq/Aa0812uqMClJKM+v9ZdGIB40qK3hRwkw/8LgkMLDiONu0IuoK2Xzli6oU?=
 =?us-ascii?Q?c6Ar0HbHPk1C7j7B1mKqxhmaKygK1SF6NidECNG7NetoePv1rBPwYIWtZmGD?=
 =?us-ascii?Q?YjuzVvn25SawFy1zCpTGWyF4oSbyUQ0852jXW4IdN7JkakWJ3FhsMvZRUDGS?=
 =?us-ascii?Q?VW2bcLlB+qZkBrpax40XXiKXtrxAUBg5Lxh5sgtFd1gdD34UJF+tF40/tQym?=
 =?us-ascii?Q?B7UcxaU7cLRgTHI4l38X35qM+rHkeKOqkT6m2phiU3ICDraX4k0v2MBtExVO?=
 =?us-ascii?Q?42WdIIcHPrSVCiIpXNGA61N/IRoglsGregemiLFO6RzURHw2+1hLt4AHWo0H?=
 =?us-ascii?Q?rP8jtBwe6FPBtFkVCdf5ArEFws9hNnpUEQ9X+OtI2VFtiI55lHVPNz+M95lg?=
 =?us-ascii?Q?tInscCKd5WPbgbxkXkVLg6gdh1RCwMj8BHFYInO7cU6GKVABKshl07zHuajT?=
 =?us-ascii?Q?V/xtG5ZBRYVJf6x5NdIUrcLPQqNDgucXb0uzUWP+0ahguDnnzt1Ju6q+f7ri?=
 =?us-ascii?Q?sM7pAPomyWtqRD5iv4v2yJfkZ0mFCPvyBDM/RRJ8w9epmvZLhvnwCnAZm1vj?=
 =?us-ascii?Q?7gt6WIxzSTk9WjaZ0ClYelGeVa32zOsaye+kOAJT382mj47GG6ZzL3rOIAEf?=
 =?us-ascii?Q?uUfCeoTo5kNsKap11rrseUweKEihnAbkUdSxvdt1CJyvkcDpOLIF9Ijd2Br7?=
 =?us-ascii?Q?IEY1EkqY1jQJ5daBEWBXtC4hLsc4fy0Op97keE4+2TyCSyeZBnIB5mUaNopB?=
 =?us-ascii?Q?tVK71Zr82e4/He0CBtiTe9E31RXxr5r9B4ZhjLvZ+gGYhQSUYmKzY0DlsSoh?=
 =?us-ascii?Q?KYYlbsBpBP389zyGv+vVTGIVNgD5C9Nyy0eWrIqTgSjjL8LLOnZFN6KngaDV?=
 =?us-ascii?Q?lJNFII6y8m6PLONpjS9Dv/11zMibA37lrKIZU/nWY+AqWonvpvrYmeySNRcZ?=
 =?us-ascii?Q?Bd1eLu8erwUrY29MseMrMITuxzWfFByVPTquiFDOjaxL/uKcXIVdVVD/aRAU?=
 =?us-ascii?Q?ypPlrEtqTVuAHQCRL6ZKnYgdm9vmb+YuysvUMtcP6XI/GvD+AZa8EkwS0oDk?=
 =?us-ascii?Q?EORYqmEpkRyd7DfbbH4CU2uwE0ddYQ2nA451MMwkXPepz1DCbBCTT3Lsx9q6?=
 =?us-ascii?Q?r4CUkmfo1jggg1NgxLJcv2TlhV3w1QJvC9BKPzwiBSEiVDFF7Lla6moVvJIe?=
 =?us-ascii?Q?2uCnMUQgpDdY3Z2f3F6LOfESEYSJ0hjb3mx22zx/lgtWLA0s8iBLM2w+HCct?=
 =?us-ascii?Q?C8EKL19pTJDoJUav+HN1HdJTmWTGEbU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7195ec7-04c8-4509-917d-08da39fc4abe
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 01:01:37.7234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qeNSG6b2d6aQ+Zo9tUNnwIx4gaMvPaMggmUPum9Na4Y3NFF0D+gEY1Hf5YAhOc1ZenzVy+DXwtMmbS/GD/xFgcym6SKekinveT9Lac5D8gM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2806
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-19_06:2022-05-19,2022-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=793 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205200005
X-Proofpoint-GUID: AjZUIMOAiBfGZpdeaKnE_azZP3QKWecl
X-Proofpoint-ORIG-GUID: AjZUIMOAiBfGZpdeaKnE_azZP3QKWecl
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Mike,

> The following patches made over Linus/Martin's tree fixes a qedi boot
> regression during shutdown, improve read performance when using
> multiple sessions, and do some cleanup.

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
