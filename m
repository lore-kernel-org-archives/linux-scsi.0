Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FE6BC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 03:20:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbiF1DUx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jun 2022 23:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbiF1DUx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jun 2022 23:20:53 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDDF8201BC
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jun 2022 20:20:51 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25S1KIrI001813;
        Tue, 28 Jun 2022 03:20:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ozaRGHOvntumjBKkMV4IBcWYwi+f7gO5sgTSzDCniFs=;
 b=AyYshzUdxpvoRJkBnnkzVgqkQ7Bg69rYnYXwNk3MBG4dgAoYjIPJlesLYYNpTFfRligm
 FdHq7KGnHRq6QFdskjNFLCCeTkSgIsTpoxPtGGcEKtKPrFwHgI+18J/DcubKvAGZ0tWg
 M/lGniDQQFRnMO6ZQT9baKvsG6Iu6E2A3XUa4qVBYwCxr+u0acBNC7WPWrPSHyCcbWl6
 gYLkB4YhG4w+5fu94o4vEVsOjp5E5cNO6NGwIZNLrsclm//VOfuY7wTEnhAfNEdDN4Kb
 DF3Xl3ztYMZ6zLLIY5mf3T8aNoMJubvpFv+gIrqfLy+X63AJUlPhRt+vmIjC6fy2KohL ig== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gwry0cw76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 03:20:43 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25S3F1FJ002389;
        Tue, 28 Jun 2022 03:20:41 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gwrt7jh7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 03:20:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pymg48HSxfu1gjEc2dUi6b642J4xuQq0J3AuzQmuGP4orZTMk8nzJHqX9aWNl6ObaHuk3w71oJls8CqeLytmGmPYSeXXoNmtjpalYOwedBKSqSW+nqCAjO7dDnV4u6fOwJb42ThaA5LQMVFDUPtJkogjm0YCfo5mGsUmXeLj02N1q9ua2eotuUU7k5w2/zmmF84toyJHX7Xp1Rd6z8/HmE9VDrCLC2PCH4E8sEVHBEV1I4AHvdOT+8NJc9iGqj2VoKJeg3fpmHUqJLpVwaLWS6GIJlvXB74wRuj3Zp6s7NQdHLzWK1px7bKr9K0W6obAEXn5D7eOB6e8GXUqlxOuTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ozaRGHOvntumjBKkMV4IBcWYwi+f7gO5sgTSzDCniFs=;
 b=lmzMcnkxPJ1oehA0IBr8eTdw474mNXwkmMKW+wD3vchap6Z9H6l8TUhXUhm2Pv9XWLKbJ6LElS9TT+Zp43KU0MCoP1oQkkcfZ+86SyjM9ii84zFkrDF7yQknOYxbVCw/izl4ja2C+pW9tQO9RmuXdM9b0IUt7SfHLD4NBokOHXH44zWyNR+MjBu2GP+ofMuakzc2weIOjttKMyUbZmIJU6mA6UgI8/ixseLWzR7z/JS3dVoVb7GXSJiq5LfEcvqX7I/qYwezWo02Qm1vfbFNIg9ixnhezMQ/U8gp1txaPd7sDD3NxHP2KTOIM63wKFdR2/vAtEx5SkzkZNxvsWyzqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ozaRGHOvntumjBKkMV4IBcWYwi+f7gO5sgTSzDCniFs=;
 b=aRLgz1LW/7s5w2U2HgsJ80PWo2lULqjALvl8Oz/6lJnrS2crPNm6KCZrEiDnOiQcYclEMqlw2WAfZs3LDgXbBPJoAZbOdaQlmyv56GEgIQVkAuqdIZw8DQW6oLXqLNQBrcYTCxGinHY1jbNbleUbv9WjxfzovzMHVQYhurq38EY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN0PR10MB5047.namprd10.prod.outlook.com (2603:10b6:408:12a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Tue, 28 Jun
 2022 03:20:40 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%5]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 03:20:40 +0000
To:     Chanwoo Lee <cw9316.lee@samsung.com>
Cc:     agross@kernel.org, bjorn.andersson@linaro.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        grant.jung@samsung.com, jt77.jang@samsung.com,
        dh0421.hwang@samsung.com, sh043.lee@samsung.com
Subject: Re: [PATCH] scsi: ufs-qcom: Remove unneeded code
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1tu85fp8n.fsf@ca-mkp.ca.oracle.com>
References: <CGME20220627235926epcas1p22a6327d6c47f48012e853aec3c8b2fe3@epcas1p2.samsung.com>
        <20220627235545.16943-1-cw9316.lee@samsung.com>
Date:   Mon, 27 Jun 2022 23:20:35 -0400
In-Reply-To: <20220627235545.16943-1-cw9316.lee@samsung.com> (Chanwoo Lee's
        message of "Tue, 28 Jun 2022 08:55:45 +0900")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0130.namprd11.prod.outlook.com
 (2603:10b6:806:131::15) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d98bb8ea-5c65-4548-256e-08da58b52d77
X-MS-TrafficTypeDiagnostic: BN0PR10MB5047:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fmVRrj35tsawfw9LxcfSL42tPxleRb92gh47r6XBgna9opZLyk70t5CwSnCS0sK+YIEJL0pLwNuBInvAudyhZbDQa2o0Q11U703g9njRHuJVaopMItG7R2tqelvwB9yog6HEktljNJPpjm74kurd/+VGr6it7inZF07R7X4szzONyl9E1fXgrmDyfOrl9I0GNEmwP0zd4cXQJcKLcMTjYdAQs/KKYqrcdtz7J98S7rcMDzkESxelyMSLZe+8rCOCfH6qlb5nSDJ47Vi6Y96z1DyejwsTMruh+qdjT+kE1xC7NwDp2Ct5Xy/EYfY3mU7YMQSH6eJX+5B/XulVptFQ3aTBlh5c0mm7JQkQ7cbaxQ/qLMjAS3hP7T5wcVnR0v3v/PHhI/r+sA+v16LWl7KuqpU8EdYWgkBFJDArs7o38tV16rjtPbALRK2MTDUsQh1jl5A9gQyQPh7FQZ21IWbI+KGadyW88DdlbHWRKBoNZGxOZyK0TA1daLHKPglnUA5qWYEqSrQX8+4BER8CmaXRL5N4dXKfZ5YsHu7umMSe7O3/PVVmP11P/FlCc1NvbmyV4X4Sq9f27lNzBArFIir1PTkgVfyyfGWKFdx6Tqj1qnlglXF+0borjFz+sW3Ei7cPwNx7jD2BNfmn31JSxYUXaRGNWavcEj+JPVWP6OR1b3vEzG232e65hyGKpvDqPtERLSz99p1s0cb09Xh0QPL3uq48LAmn+75iP5jeKx6iXaWoQtM2EaVpvLFAusblu3xI47WO2Qe9KYh/mLhKS4j6cXp5oUlNsMZEP0IdKBrVqNY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(39860400002)(366004)(346002)(136003)(38100700002)(38350700002)(52116002)(66476007)(2906002)(316002)(8936002)(186003)(5660300002)(66946007)(66556008)(6916009)(6506007)(558084003)(6666004)(4326008)(8676002)(478600001)(6486002)(26005)(6512007)(36916002)(41300700001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KCK+qNuYRc/CeI1W3cV8DXh+dHbin45CEXUu9Bqu7zhpR6KosoFE/nEAPDKZ?=
 =?us-ascii?Q?6411dEPxJ/rqCpJ8eCZKc2ojKlsKggNk3win00KPrrGETxuw+/lM0kKwirgk?=
 =?us-ascii?Q?0rv/43byROe2KgiL5aJ0e75A9ehA3rGobeel94b4WYHhzCAMBnuOlVcags7U?=
 =?us-ascii?Q?mWOfLsSOtNl+SE1/LR1Ero/Ox5p5gyWMDLe5Yf/cQu06MGV8+S+uplALT+hC?=
 =?us-ascii?Q?+sONzyWAabVzq3fdBSfytpm6LRXxF+ap9kuBce0neqwqwSpq0Tj2ov/jjvE3?=
 =?us-ascii?Q?LrBaiirsU92esCA3Ko8eBr5wf6m1TKrc3tDe/f8zakes6fZBedHr9RA1vO4L?=
 =?us-ascii?Q?SPuiqW2E+f78RqwG4J43f2UiqM4uUmE/lUN26PpuSAYizMH35lUGNXChozwF?=
 =?us-ascii?Q?kWDX2CHzxQvMbMvz7zq3kuVdwinxVgZetoLEvAmzb7100AFY28FO4Z40NbHh?=
 =?us-ascii?Q?mdECn6SiDS3F67YOEeFR5YTpiVg81kHQctc2IglhCd3NwiLkQibWGE+5GRWl?=
 =?us-ascii?Q?qhGjVedq2m1AAchi4k0WuIMreDwgY6LPLW5kswOlAlPY6wzdxFZNjDmsYwiE?=
 =?us-ascii?Q?QycNRTvK1e1ytiM6fiEV7LBsmFnfQc9e9ZvNmS83WmaaH9GD5TEDxK+VlzyH?=
 =?us-ascii?Q?52koDzWnTuwMqxPTQDNSnzurXK+kRfxw+IKOAyYRs/EAIHGRXghgFiKZL8bz?=
 =?us-ascii?Q?iA7N9YU2PD7qqifx3yUt0TRtCMzYnIYvFgodFcUXlD7SYRcnmVXwXScqK9NE?=
 =?us-ascii?Q?W940kDl6BO8TVMMvNg2MdCDnNEP8vGi3XzdBsRDgVvUhfs5N72s61j0stwsM?=
 =?us-ascii?Q?c9v+t89wSSeSJ3nYKaj47u+iHLTbTRyO+BzXp//ygJaeH96RJmpmKTcXhZzk?=
 =?us-ascii?Q?4+EpXgS2/a92huRbKVWNbmKeP18otUp+wtUXmqHMyIfN+w3e3H7o5fnzZgnJ?=
 =?us-ascii?Q?ktK6dz4479LwYdTt6Ofm1GBN06aJmqjeNmBQstBczWUDw+kGQvyA10OCaT8F?=
 =?us-ascii?Q?jkljMJN1N24q8pkXrQA96Vr7QFTfb67SmCLQcdxPIG79ZAlcAXMTrwMg0hKC?=
 =?us-ascii?Q?ZFBZnMQwfMKPg/uieSVvlM8WNE/jfYvunMp+eYBB9lTBlPF2fBvR5rNc2zMP?=
 =?us-ascii?Q?tVifb1Eb/kIUBDBGagDTjNuVMfvaX7Fw7Ido+iIOxs1Kr+0n44RjgocszKtN?=
 =?us-ascii?Q?LhCNj01hoG1cwr4b2TYbg1uneaGsi4GOer3/h5uNQNAWudwnGni3/Ziw7heI?=
 =?us-ascii?Q?uoco/D+5ei26LEgAETq6Rxi9E+5Fa6KNThwPJTYhfCxaIvWew1CDl1jhKcvJ?=
 =?us-ascii?Q?+MbgZWWRN2amol1YcNuoIfZg3D75IgAJcqdlFQasP5lspRdK+7X5ZFaITpA4?=
 =?us-ascii?Q?y/5AysdDL/UvizRfixSrZakWPB18RF5+naBjpxkBYBxIcHYw7BpFtEf+1qpq?=
 =?us-ascii?Q?o+dKsnhsABVrG7r+WNVGBEjcNenHxlIleVPr5ti0fxNBWFTeYX4Fcv++Axwx?=
 =?us-ascii?Q?9l91Jp9iTgOz1bhtcqtJrVKsX8sigLU4SCAWqShA7zzpNkZ20hQKwSXuaO2J?=
 =?us-ascii?Q?Mw2rJS3ipMu2tUKwOdfGZzgtLa4AURc1+hiXdg1YfJ4QPo3n1/SltfsALyJo?=
 =?us-ascii?Q?5A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d98bb8ea-5c65-4548-256e-08da58b52d77
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 03:20:40.3016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eOZiSqcsG7jstR7PMpWeBQQIMjr3IQKRyOA4AFie01EhSdOwL5yP5yjOyh4Vptf5vkIIeXqDZ4B3Z02Ig9/zFOdsEdfgWl3HyZp1ljNGP8I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5047
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-27_06:2022-06-24,2022-06-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=711 suspectscore=0
 mlxscore=0 phishscore=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206280013
X-Proofpoint-GUID: 0vvXarPn8papFRLsNa_7GZWn429btlt3
X-Proofpoint-ORIG-GUID: 0vvXarPn8papFRLsNa_7GZWn429btlt3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Chanwoo,

> Checks information about tx_lanes, but is not used.

Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
