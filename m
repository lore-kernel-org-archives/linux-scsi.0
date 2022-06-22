Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D55BCCA473
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jun 2022 01:28:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbiFVB2r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jun 2022 21:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbiFVB2q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jun 2022 21:28:46 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE6D326D4;
        Tue, 21 Jun 2022 18:28:46 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25M0IiEN002242;
        Wed, 22 Jun 2022 01:28:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=E63qyNsPhM6lmQsB1kt/1+Vn7DbwIVaqiUamsdiRoTs=;
 b=ieK/H2Za/oCZAcPYvqThYfwnVWW44XfI2nQhb+MxdnSCnNrCY2gdBWjzsjqBglE4AzSM
 CjdVqUQQEaSOos8Qvl7H91ng2H/Ws7N42XV2hnBf6QM+ITeZXMGGEf83Azv+Ri1VtCGv
 nRDfKJH6S8qbzllWLh2oXKpP0cyR9b9ugPUKkcORRawJ6QnTeQBgFLdBvGSDzC23gPwW
 VHQvDEhNw6wz0A3a6oFMpSnSGyLoVYVMc/Uu7yZpuhqYUGbQjtdK1CS1IYgTGndYlARb
 YYTMVjdQ0WUC2P6Ns/CQb+wg06kjHoOAkId9RpM/9jR58rovBUjTWW5YgvHBfu1Ll/SH nA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gs5a0f4qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jun 2022 01:28:42 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25M1Gjr2022665;
        Wed, 22 Jun 2022 01:28:42 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gtf5d1p0t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jun 2022 01:28:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jmhDtswAVFk5djgv6pc1Zbkwx1UY9EFMi1grUuWUOCEhC1MKhSyH5ngse7n1/3l+AX3nYdtPnSuyKBN7lex9VdJXDgR2Hx84vClcKrbQ4dsiG8Sm8ZH3SxwMHlxDXyfS3uDwceVI9r3YuXJGrK6f40Swzbp4Q4sPNhStPqygPAef+7a7mXPuzjjEMMz3MhLeu2DuCNlbM9o5V1oBU3osffFylEnC0jrGwLmwui5fOWMRplmleUD1gWxnnJ+SbxNcYQXHNKdYizBBuVYX6A0VwhK9i63JuSJ6/c16DWJzhNmRvLEX0TwRkfdKHYJWiyJh3NaHeeecgupPpnsK1RYYhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E63qyNsPhM6lmQsB1kt/1+Vn7DbwIVaqiUamsdiRoTs=;
 b=mKnweQprKqzHMg6e0XVhlxrCi4uLP5xdXk9V07UPAfp0jUywZ/q8SEOd/0EmLWH3VGuuuFtep1RmXN0Rh28vA+DHFWKqW3JLKEuTG3M/fzMgKXnzLZhHSi+D/ob9gTj+DKH3yJ6omSgJDShP3kcAScXW6Mg0+Qs6Ym7ixT8w2pXYnuSjE7pFOxLYmt2wZC5WIwYLxlElsNH00FsxknnscgwR9b8vkGWWd53J6U5r31gWxa216rNB7ALF03Csw4slCxNfQUdmmklnVMLN45rbSi/RQmD/e/tUmhJXJ2WVuTZHEqzIXrh0P7g4u8eDLwpaecKJUwX/zL++g9QrlUIM7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E63qyNsPhM6lmQsB1kt/1+Vn7DbwIVaqiUamsdiRoTs=;
 b=rZI8+Vh+2z6Q3XSMCjw0CeG2UUNGCVYpZPBAzwq8KHdXCCAF/eM8mPxpPfgbsUMiT8EVTK6Ze0eRzcRuoU2l8+QnlnnuT7De8+5HHruq2EDrotLACDfNhFCxvRzdb/FJ5tlkMnh8zESv6oAO71f+1xJC8H+CH2e32NOXZ6vnysg=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MW5PR10MB5665.namprd10.prod.outlook.com (2603:10b6:303:19a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Wed, 22 Jun
 2022 01:28:40 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%5]) with mapi id 15.20.5353.022; Wed, 22 Jun 2022
 01:28:40 +0000
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: check correct variable in
 qla24xx_async_gffid()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h74djxoj.fsf@ca-mkp.ca.oracle.com>
References: <YqwYikYF4Ye6hpqy@kili>
Date:   Tue, 21 Jun 2022 21:28:35 -0400
In-Reply-To: <YqwYikYF4Ye6hpqy@kili> (Dan Carpenter's message of "Fri, 17 Jun
        2022 09:00:42 +0300")
Content-Type: text/plain
X-ClientProxiedBy: DM5PR13CA0056.namprd13.prod.outlook.com
 (2603:10b6:3:117::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d466224e-8b8b-4df2-ff74-08da53ee892a
X-MS-TrafficTypeDiagnostic: MW5PR10MB5665:EE_
X-Microsoft-Antispam-PRVS: <MW5PR10MB5665791566C5881C7A8DA7AC8EB29@MW5PR10MB5665.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o++fbdQvGsxAzjR6WM4hzfF8xzNX8gx3gf3y4JGbc9SZ/QYBSc2xNgHQjJxcoXlhcA8Rexh7KB4UZwyVBz/aHJM3/UF434y36IIeWYwNOoM1gsm1omLkb0iGI4AhN2l/CMJ4L/ilot+EbqZz5l0C2NJFvDddVcAmrLkvo5q+TFHtUJeslY/pIq6Z1zOiEKypq2lxJaqdI6lChEDFEfPqZmhB5RIRayzlmzcBg6wZw28DSsHhwUg2d+Kyq0P1/pF9vsQbLEstBRcWen2heFrpradEDbuPtYorEM8OvbKKDH26baLCXkCeLkiYh32MkkUwHjaYd8vXSh+cAv1LomhhRpnM8UUyACRTS4d8EeFffTDUEeC1mbLd409vER6NeSMWsnYaXPPh+MFjsVkP/ftyoEuzOf2Ua4PDcV5cKIvtRLLQB5TVZDC0vUJDThoLQlijMxurZJbiMBDuqt+9pGCk+O8GBHCafotkjpbMjaSdZLgr2T8TfUy7vIZP5jTAPtjA1YZG5BTcrbPZp2P5ExUaSh/QQsK/IMpnduD/nhDeCV8HhnfGam92Ra3/Zg7F8v4DcYputuL1e7Togd9Ex6JzjQ0U5jrhSp8X0PwblLTwJSHYb7cT61cdnZ8o0nRqAT0rf3H2M/6jw1nVNakoZFZxetrgjfnuQoIePHH0HPTfSvEhf0ks6ExyegSWIkVOVwHDawDKBUfyLWJNbKqXtfPbKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39860400002)(346002)(366004)(396003)(136003)(478600001)(86362001)(52116002)(8676002)(66476007)(6666004)(186003)(6486002)(6512007)(8936002)(83380400001)(38100700002)(5660300002)(26005)(2906002)(6862004)(6506007)(41300700001)(4744005)(54906003)(36916002)(38350700002)(66946007)(316002)(6636002)(66556008)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Yf+0EhhlyTLU83Xky/YoNgxF2TglZWfmcvZacKBrlRxzOdUoZPHpnMnwqfGy?=
 =?us-ascii?Q?zzEPH4Y3oEUjJlKR8qdMQVhEF3emIz8wj2kPCvIlu+i11BaGMxURBCvJnPtV?=
 =?us-ascii?Q?6thgMynuomvlajI/41cB9wETkIj3UXJKXOqNpOSDEsPMc7/XnblaR9jF56u1?=
 =?us-ascii?Q?Qw35vhyn91DIYUGmnuAzStTPhOIS4lJaPAcfkn7ZoHptWepEoLmoNDfCxSZe?=
 =?us-ascii?Q?ysRjt8ZGRVwX70Zg0oLKtFCn9mkZ2vRubuhAo/woMGeF7GuT0W3Ksp+UJ2v0?=
 =?us-ascii?Q?l3xTHVMUDDrAgxxptCx2MUojD8YMshFW0QOupZv2CaBftuwSy0Vl8DYAmY3N?=
 =?us-ascii?Q?2+8N1v1MgHSXyWUpK1pDD/4m2hxNK4gFqbeXjQmNH82HKQoB6N4nzFVgSIpK?=
 =?us-ascii?Q?UFoVlTojJRAGOa5Gx1qyZl37Uf3Boqkgcr6HBq44h95j3vVnHvQ4qDzwyOhT?=
 =?us-ascii?Q?j9mv/KsH7JWPpiQ4PLwpBLtQ08FJIKYij68sGY7H+tHfr7cM3qqB7hhX/RAo?=
 =?us-ascii?Q?QxOYNxHzPtb7VsSU0umx7auEV33O4QFBQhW+MA86iXbjE0FtKa6HRYMWHXFY?=
 =?us-ascii?Q?eBEyzAH0F3PFk6UyvsuBwGjlbEis5vq4jnED7vLLyYPNPuqq5Vs3Nd5mQ0sg?=
 =?us-ascii?Q?e/PB8xtQuSOcQsP2UAuWSWzucSrYzh341OHgRSvLZApy/yVGelqr0NonBqb0?=
 =?us-ascii?Q?nCJrUpDAaY/Ac+x/JtDy+rhwSMoVcJFBI7xypISEOHtp7M8xaGztW+XS29yz?=
 =?us-ascii?Q?0q4EomKC9bK7M0pVy2oB4Sao2JrhYziBJxvbHTAGsf8+J8MIq/pIRhbY4m06?=
 =?us-ascii?Q?JDkcyHQUYnw5i02+ah/eHprCRfiy+CG01MPE6uHFR9WuRT5Nwz8jdfUQ9f2W?=
 =?us-ascii?Q?GDSQLzBoJG9spPrrJWsljkzYJ0F/viBZr06dfiEweRqyiWBcGP8t8Qo6lfyq?=
 =?us-ascii?Q?GlXen3Jvt7196sv0hIjl8ZNRdBkyWODqa41bRm5nT2W+4qUGqjbCrZIrEBrx?=
 =?us-ascii?Q?KcrXfXtoHR7N/XPD4G1DLarmoCt1vf/mwhwptvJjDVbdhDijxR/PB17oPfXf?=
 =?us-ascii?Q?Y9VHs2pPr3Dvzy2V1Ahed9XpMM6RNEh6r0MTeCYrQYYSoTW08uRI3s8jHw9+?=
 =?us-ascii?Q?/yzqrT5U9AwG4nd8TtGYIlGWBzFaYlEOE3R/1pkxmX05OgMmaQJyQqBIs2pX?=
 =?us-ascii?Q?n2FyxSVwb8cZ5yxPfxVzJR6Ltnv764e3QTSP0t/p3jnNiHDKWmcE8HNVl65H?=
 =?us-ascii?Q?yOZymk/C6bWzkim7uPSH0l+9+SpB4HaqUE3Yzz/h+UXZ2nGKo/Iz010v43dS?=
 =?us-ascii?Q?76ZoukjXfPPjpNvD/6dz4IKoMFT7SVm91zOWvmHqqoMuLKdOCj61XeBz7weM?=
 =?us-ascii?Q?jEUEflJyk8/CiMcOFhlx/XzaVgVhF+Ce03HbauEitNsWXXGZAiHDuUINeN4d?=
 =?us-ascii?Q?ozG7MVN38pu2Bp04YNfubeInhtn5MAtwpskJ+XBUCBZjAYSqkaR6BNHgh0jf?=
 =?us-ascii?Q?xdppIPMvzX6/DeeIPquHgErF7LoNbmPpog45YDOB+lULNxzd1MZJADFQbbOk?=
 =?us-ascii?Q?4xUrAchXEkNnVquGXTCrsV8Jxh1WnxEYU4xL1/qH474sa9MKaw9ooM3P8QUF?=
 =?us-ascii?Q?GoNjaK18P9vcFMbmN2831UXsBRRQu0XzAnY3xHknphDkU8FwAv5km0E1Aw61?=
 =?us-ascii?Q?MJgjr9cJN0UttjhV2oWNw711y1/xdP6YmBPDejoYoPUfRhvXFFfrKJUfxqG4?=
 =?us-ascii?Q?Xu97FzMSVAvRCVzyzwWGHdrc6kISUio=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d466224e-8b8b-4df2-ff74-08da53ee892a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2022 01:28:40.2787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 47kWv5fkB9fm3ExTIFBjGU2ubU33itDxe4wxbVtyUGy1vUTCb7SU5T0F5FPVU9dsbiVT3/BDUOFVlwdGPP6v9gRyguvDZ0GlUWOnqEJ6Pu8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5665
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-21_11:2022-06-21,2022-06-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=831 mlxscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206220005
X-Proofpoint-ORIG-GUID: Igg5Oil3ArZ1SZkBeym6aSk6TRAvsNck
X-Proofpoint-GUID: Igg5Oil3ArZ1SZkBeym6aSk6TRAvsNck
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dan,

> There is a copy and paste bug here.  It should check ".rsp" instead of
> ".req".

> -	if (!sp->u.iocb_cmd.u.ctarg.req) {
> +	if (!sp->u.iocb_cmd.u.ctarg.rsp) {
>  		ql_log(ql_log_warn, vha, 0xd041,
>  		       "%s: Failed to allocate ct_sns request.\n",
>  		       __func__);

I wonder if the log message should be adjusted to say "ct_sns response"
or something to that effect?

-- 
Martin K. Petersen	Oracle Linux Engineering
