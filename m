Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AEA8EE4996
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Aug 2023 20:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbjHUUvu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbjHUUvu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2023 16:51:50 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E884BC
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 13:51:48 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37LFxUq0003614;
        Mon, 21 Aug 2023 20:51:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=4hx1BdnIhhCSLkysys8IdBCAo/j8+0tR2tWWhLzvQyI=;
 b=Dom+riYorpzNjHlu+YacBo6MfMNS9YShhyordSp/avmXsR2QVhTpvSL9azYYeGXX9aND
 q4MBlc+S7BhseHfw7aMHSWaLq2VvWdHOh5FtXTPQTfoO4SE70PXawG4LIiT4HSscJ0R+
 Ieanapy4z385jhRKZxmD6vTgvDwqTBxc9t0kXGXMHci2hUDqFxqqk+oXQ77eZPMdW2ET
 fGj0BCixuWe+Iu9D24B2vQPAtlaI6snowAy3a9nZSvf8jYoc6+gD64T5E5Og1Q/WYncj
 yyr97jHc1Tu/fMJHgkjJsp/y51IHTDfF6DVHbgtFj1m2DUbhZcLESBiSMzXOusMSeus3 Bg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sjmnc3v44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Aug 2023 20:51:42 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37LJcxm1017499;
        Mon, 21 Aug 2023 20:51:40 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sjm6af6my-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Aug 2023 20:51:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MWQtSjQWqVRWl23cWVzE1sfYM7rDoLDPAtwBqhuM3rCzwagI38EF8/YtI0oj4KVXNGZeDfM6CPWrPMzyTmMzispp6C0nghp5D2LRH3IsLigJ0ZQArr03DQgfQ8AbgfHg03bOgVlndnHaDjdvNx+J7dxepZDMnlHwHKX32h0KjMMSiw81F1TlJjgHZNquqPqqf1t1k8WaRLgIx7mwaS0tmMIuM90JP2SGYwn+9Bz6orIMl7Ii/GNuvDdOwApfv/XEyiPOPTJU6NU5q7BxLphpqHp88MdPHBxBRoATZ0LBYnFguSDWKwCurWBD9yUNNNPuq6if/o3Dt+g4JagjntUpyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4hx1BdnIhhCSLkysys8IdBCAo/j8+0tR2tWWhLzvQyI=;
 b=FlU4DOAK89X1KbbhdNRCC+ofN6QnD+xeKFlZxgC6aSMQ+rTf+EH811f7RkShEGkZVnHrns0gbjkkp/BwfZxEM+A9wBo7u8Hk2NJ7h3aQhJAF9K1Hj+abF18GRE8/+84Y1v8maO6whMliLEaj0D2VYeSHkDWmidjVpKI6ybZf/EwmwSjnvVJGBOGXGLnJ3A3DAX1mIIVpaKL0l3sFzj3ULEqVo1+CGF62ZbMOzCohICIh+RvATcmFv+0eYH2rq00Rd1aaU4Ij9XTfnipd2CqHxJ2cOZkEIk4wsbEGrXidGNkiow++MzbP3kZrSmJlgRev5z6LBsZqYMbDBBr+bRZ8Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4hx1BdnIhhCSLkysys8IdBCAo/j8+0tR2tWWhLzvQyI=;
 b=qRJAKp/+fNj4X+t7dSXvNjULKtyFUMaA/BP+ei7oqQRQjJtFLjDEngGboHKJrz4C8FFV8vEDLy9HBssYAUZO96mH6XyeITEDaSNfaEiqjC4Y/fQS9ZNp4ZAExDd7RK6gmzeEE6ZOi7s9pKY6Sv6Sd9pEGhGXtUQouDZydQht2t4=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA2PR10MB4810.namprd10.prod.outlook.com (2603:10b6:806:11c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.24; Mon, 21 Aug
 2023 20:51:39 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6699.022; Mon, 21 Aug 2023
 20:51:39 +0000
To:     Yue Haibing <yuehaibing@huawei.com>
Cc:     <njavali@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <qutran@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH -next] scsi: qla2xxx: Remove unused declarations
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y1i46rww.fsf@ca-mkp.ca.oracle.com>
References: <20230816130842.16684-1-yuehaibing@huawei.com>
Date:   Mon, 21 Aug 2023 16:51:33 -0400
In-Reply-To: <20230816130842.16684-1-yuehaibing@huawei.com> (Yue Haibing's
        message of "Wed, 16 Aug 2023 21:08:42 +0800")
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0572.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA2PR10MB4810:EE_
X-MS-Office365-Filtering-Correlation-Id: 88b0cd38-5d04-4809-3030-08dba2886a88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MQit4tGyKqop/3oMbx/7W2BlPlga5ybYZIAPgWMSonD6U0zhX1jO+zkFd9mm2F3PP4998leHGpD80yXxOmwN+py/HYrLsUOpIE0URU3qkHz2NJxe8QIqQLydyQka05sQrwAeJe/MgMF60fcXXMcpOYQaU64AXEv8PPxvSQs0QfExMhviH8d6KGd9cWgIkgk6DZS2hJmMBwORuN9B7LBUrQk4MucaJ3tL9jLp5SOaeDkyYHX73eE+yqCjE+2eH6RAa4oWwav5ltUOog5cRLUTsAhUk3cuvL0M5H5Yz39glmxw7J/RHfSu+7y5lh9MpQq/wWWb1Ayqo9LdS8RTz+V0QZbw5evtE2CTtK3wA0hQzrDr2KpkVDvGJ4HHtTnzxbJ74N5zg9UO5l35NPza+Pdfbv9i0JkH1Qb/ard/e6DLLWKfpHp/QUjH0F1EBliYnzQQ0rUevfUEsmbVLEbYmcv7kd4iNiNqEvZHnpMWI5YazZh3y7Sg7Z9EUtw1M+GGTwen9jlYdi/7Ju3dkazM8MCSh/MHnCKvOJB/oAbUWP4twKgImN3uFqg6KrHzdGT8nkKQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(39860400002)(346002)(366004)(376002)(1800799009)(186009)(451199024)(6916009)(54906003)(66476007)(6512007)(66946007)(316002)(66556008)(8676002)(8936002)(4326008)(41300700001)(478600001)(6666004)(38100700002)(36916002)(6486002)(6506007)(558084003)(2906002)(86362001)(5660300002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?URHGfIto7DVZj4XeEqHiwfocHW8aBOr8FaK7tlxDecM9aAeTwNWte6y1hbKO?=
 =?us-ascii?Q?6rmjsxTZAAbb1yF0kQsobNz9XTCYRRtIfxMyNAzJB27D8Z07N/qP1toxNTXo?=
 =?us-ascii?Q?vRJQL9A9X/fB1K6EepG040p0sVsQmVEKVuopxnim09hyB+kC5YKwiVM+NrOC?=
 =?us-ascii?Q?U7nKJ4MST3M8xpBx6ejf7/vhmcqXVv5gqOrYw1WuIw4/9AxBkwJIzIyp6YnZ?=
 =?us-ascii?Q?//zXBRsE4/t+rBT3/Dl78IfYi0xLW7h6IEJ0aEizTGaiZrxFoItjWGx5a6Qg?=
 =?us-ascii?Q?WGzjiCgJ8h16DPpvrijR9WMQOjwtBqXG48fxViCftY6/WjkNA0Rcgk41x++T?=
 =?us-ascii?Q?fbi11roM7Vt9gJWjZQAlieAoAdbtGhMrPgc6XRc0pfI7TYmvE8K2qq7qEe9L?=
 =?us-ascii?Q?/nuZ1Gft5lOYrVUp/gvYJXYWff/4+iHRKaNS7unzylYSsnse1WjeV5cNFwAq?=
 =?us-ascii?Q?AJmqHDV4opZqJdVFXrUsoN5FE6CwHUbRVZaIuxleHlv9c/uX/f0TfB9cZuiu?=
 =?us-ascii?Q?yXamXX3znro/Z8YqFKH/EFXj+CpJ2Ngw5vd3PCbFb3w0l0rdeWUmZrQCoabm?=
 =?us-ascii?Q?ULzdBqZkdKJXqqx1DF+P66aJSpY5zS6eSnDF39wMtCvn/6BuItD9AahI8eO1?=
 =?us-ascii?Q?62OTVzKfBkSJkGRtCFFrN/4BKS/4xnftio9bJPIp4yOGZ8hOtrRIiwdagBbg?=
 =?us-ascii?Q?EGydkcx6OLeuHV+D9Z0ZWu6Kyhq1CAFCJvb9XLgy+cOGAsc5N3ds/wl2aXoB?=
 =?us-ascii?Q?t+iWaYIgd+uCTy+JSvG+4ADIk5XNMKA/L0Tgb4Ok8/2dGFBbl+8bLN4IcW9V?=
 =?us-ascii?Q?r/jVea74uVwGRXNt6RZ2c3XuKiPgHlN3xaakdAfEIdj48TeRTaYqxBfdpIRX?=
 =?us-ascii?Q?5CF9mHOU/HZckOKVyq/VsjsYV+63pq12DsYC4TPiBZnAXwDFfMI+kE2L7jlE?=
 =?us-ascii?Q?uZEbR2lNyEL39Mdtda5AdhkW8u8P/dJHPbfxNpJfK2LQLygD8ohkzAfnjJTo?=
 =?us-ascii?Q?dhMJy4cqV+4C2z2N1e3UDe+foM0NhjT4UknbPMKdDTQIDDvZzaxCtVJ4d4QX?=
 =?us-ascii?Q?omMYrqOYKHZ8FYDeKTK7S5TgIryQ6A5gqT3DxV5bY7Xk4LtjPyRvyMH7g6yF?=
 =?us-ascii?Q?EAX0pCRgpA+KOYbgYSHvwkc1imo1PKxbpZfnHsVKzpiStsdUOLKRjILMcCZo?=
 =?us-ascii?Q?OUgwdUh/FFt5ArYjNu9ZeGHdF2pBbwH8MNoXNk6+6kFGFmn+yJyN5pu042V+?=
 =?us-ascii?Q?wXsIvMgae6X8/+Ihvszp1KgmP7mQVemrF99CP7bwry32CkgrdBk0nD2ZjnQv?=
 =?us-ascii?Q?qHWGp30CjzIwXq5XObJzyas+8V7nGlbRt69RaLqAO7wZDLpSsZJ1v3tDx63P?=
 =?us-ascii?Q?Crfr/4B2m7tjP2kGuk0PNbGegkni05EFRjq36pxRNskriSXMoTITMFnEuzN7?=
 =?us-ascii?Q?5Z1P2oRtDm2Pb+4vqSAhIS3kn8e+H+R9V5Up77jxgGdanlykcv+1sRV1flCm?=
 =?us-ascii?Q?Tlel8tVhk6iFXVcmU0VwVpXvXPSskqN6CP3zixtgOpK3MneUg1ELHoFKO5eT?=
 =?us-ascii?Q?ZTGkEEX9Ew1IF2Ote6C79S1JNojSErlfC/Ol4lJ67LAuELsQdr5j+1HeFMZH?=
 =?us-ascii?Q?IA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: DsddHQSwJhlj8JkXq0MtZLFmPUldzmsEqnRNz5d/IZ0yMuujLdrGbVdx2nCylV0CgINaL8jSqFcNqgxL405m3BK0xkbVAckY+nJeakb1Wy7VgNbBu8gD9ZEmvOmAYD5zSzhD03/xbo9wjITxVIfRV41NWZkDa1KnkPgFZshyny+32oSKVv3fsOx8D8xvb+//qspG2T3G5d2G5bTl46TqgZqjS34n1b6+/WzwGzcpmUUtv2mUDTc4gDh1DQp800wexuTf+Tgq3DQm+lMIKhuv4opvcm/900wvLgRMOB+erSeTXlPtaCa8ts08c4xCwdkexVAwhgzJsfLdOl02x23bfcNIXqZ4yccQRsgr/SBDVvsWRv0XPb+Wjco3Obggczk14nRrQVoL6ShK4AKr9GIgsAjpZWXNGnKhgtyAtGD/O215Q1sXLgiB40rgPTP8w4116b0o5G83WWHzcXT6aSby6duguuWn7hl0q3xMLx13ngb+/Qz+mhVQj/tMl0cj8LdsfchPosrvSQPUJe2c3dnOxOv1JwWCNx2HOOKC0IR53+d1Y+XgjbfuVwHnYCt6y5I3wnsVh5RLKQk6DXuBVgrT6hhsCvxl2D9OuH6UFaD4hYsDzvqfw6WjN22mfKhs1kdKdBoXaPbsQgKY/dfVsHPD4WupVd0p6ssY7jNxKKMBbK//fn4hjOKeV+G8j9uvbYrHS8qf3qT6fVxE/vWsyKrTztxJz06XoO8OXn1UDsZNKKCRdreCDHvLuv/jW6WLGNHdYhVlC+56xQ+ekpkf9P4HagAl2XSuTyMMZrAoEX8vX8I9Rmm5/4v7rxBwAPGexcbD2IeOY2CRielrfwRQUAfp/o8p2hiLCFovmOCq7Zyfcdg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88b0cd38-5d04-4809-3030-08dba2886a88
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2023 20:51:39.0902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AVyrZbohvgVhBKHxVVMRQC4kBhJbKwdOQmMI6tQwXX9TUsIRVATfqrfqHEi4z8wumuqkbvDbQ/iR33IYPqBWR14pXGv3qlRazj6iwheRI+g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4810
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-21_10,2023-08-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=644 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308210193
X-Proofpoint-GUID: 8-WcLfNocf-KSeZ5UDly1xGMDZPO0TPK
X-Proofpoint-ORIG-GUID: 8-WcLfNocf-KSeZ5UDly1xGMDZPO0TPK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Yue,

> These declarations are not used anymore, remove it.

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
