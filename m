Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D6CCC433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 02:58:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 828FF61428
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 02:58:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234128AbhEODAA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 23:00:00 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:20628 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233403AbhEOC77 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 May 2021 22:59:59 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14F2wkti025963;
        Sat, 15 May 2021 02:58:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=L7U08N0rypcIXTgrAvRneDe8eSWJszkfBnLEPOfAdps=;
 b=soREzjJP6p6dlOfJ7TleWFXt2yIUiMX11gbXGvp4hbsgfOrZp3EhWVE2iLTUp3D3WzeA
 WvNVzpVtfVO4wIT3HS5qentdDFzHMJnmUS6TVXcmkqmqQS43RqFvoEF0MC2XNrBBi5ha
 RKK4oElLS74lK8Rcwmxos++v4wMIGfxgVStHP5/HV6P9onKHFg/Ye3dT6E23NevFpVTX
 tG8J9e05x7xzI01pfsjqqZDD11Ygnro4mGsf5wSFHWOImAG+3tNaRNQAwgizgRgeqdhw
 rD+Gid+01r0awnHYGpj+RVEjmd4zcAhmAtY81xkskPazGiDMe1dUo221+9uNk+lCaBZZ bA== 
Received: from oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 38j5ws0011-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 02:58:46 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14F2wjlS155566;
        Sat, 15 May 2021 02:58:45 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2049.outbound.protection.outlook.com [104.47.56.49])
        by userp3020.oracle.com with ESMTP id 38j5mj0h5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 02:58:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VcpBmhaf4p6wJBUAzM+ZZlfDgmW7CU95R+L5yKH+qCJRQdyLyJ88e5S3FGGcskZQpl+vzh4+89YAVU1MFE9QUfXr/YuG7WN3TbjraDKUpM1xtIAm08zSPF4qjetBzCfILZI9DpOREbGC2ajcMFNrxUgeyFRL8i1GuC+X8+rmDVP7eDZkcZKe8r6T7G5HFjnu89SRtbyGLbh0Kz2zhqMHPC853XlqksTHALC2dcKuUe4J+0VjPHDsBkZydzzn07ArveOoxrh9aSFzXaH8dCRUt2cAxqOeUNp3N2VAz+z7VJvV9d59nHIeLQtL3ehHgsCM46tdfj8aBxtdaVeaXix4rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L7U08N0rypcIXTgrAvRneDe8eSWJszkfBnLEPOfAdps=;
 b=CnFisjTfhLWfnvFHAPNZFMJ5pyj3Il0mb0vLG0PnV9MTfEJvJkHCWt1tMr1wE4OBqOzHxe1nrDj4OsIPH0OXeaIHLNyKs4oG0+Uty1P5aEmYv77oXyCJkyH9SxI6eiqHwlUFn8FGlAcsrNfyFA9hb+ta+F8VJCciN9wD0urn11irrW9FvJv30mIoxsKiZ3Bvp8PMGj9bce2YNyTx475VGBXCc4xSU3UdcCaMV4wRgFiVU92xqryY5Le0pAh9PC3V+bO8am3TNVZkWXvuyXYiMDcI/eZWVWRKJCpcLvJn86SC1a2QjAtzE7oy5lYoH4hFC1Ehmy1I69lj3UldLl1CiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L7U08N0rypcIXTgrAvRneDe8eSWJszkfBnLEPOfAdps=;
 b=GpfZHediRnwOcy8HOLj79xV2c5EIEnt7LQmpoaql2Hp2hhPPjkRExd/l0/uicVDTqYz+KjCAMdGcll2dSz+sWAkmDNqJybAKaSW4Z/FD6YR6ly3AB0dTYuFROy+1sb5NOzKlsus/uktyJCjQmM5kSrPvHlgqHtwpELxPOanHjMY=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4806.namprd10.prod.outlook.com (2603:10b6:510:3a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.27; Sat, 15 May
 2021 02:58:43 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4129.028; Sat, 15 May 2021
 02:58:43 +0000
To:     Bodo Stroesser <bostroesser@gmail.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: target: tcmu: Rename TCM_DEV_BIT_PLUGGED to
 TCMU_DEV_BIT_PLUGGED
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0o0aejq.fsf@ca-mkp.ca.oracle.com>
References: <20210512140654.31249-1-bostroesser@gmail.com>
Date:   Fri, 14 May 2021 22:58:39 -0400
In-Reply-To: <20210512140654.31249-1-bostroesser@gmail.com> (Bodo Stroesser's
        message of "Wed, 12 May 2021 16:06:54 +0200")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN6PR08CA0004.namprd08.prod.outlook.com
 (2603:10b6:805:66::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN6PR08CA0004.namprd08.prod.outlook.com (2603:10b6:805:66::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend Transport; Sat, 15 May 2021 02:58:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48b50eaa-67f2-4f72-4751-08d9174d5974
X-MS-TrafficTypeDiagnostic: PH0PR10MB4806:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4806D3CCA263AB4E404CA3508E2F9@PH0PR10MB4806.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9BB+KeCZBpT/S4KVv2QbH1oso/okIhdIs7KO/+qqEi0Hnqin6NsiNFkM9u8Qg+SActkhnxdex+FtGi0bsqXAnyxUOd2hO8sFsmJq4aJq2OfQxROAbOHiytt7omc1dY7mrnSlUJDIuFtlfm64fqPR0DpRkcipBpAP5Bfc7/yPrQyRDc9i2ji/A+ImxuHZ13M7qU0k56VXI0wOdqvP2F/H5yQDBD2L1fWdsKFVasL+Tq1Pk1cbFNiy89ZyykZBZ+GCw2dwgaKx47wImzHT/XRFAAbl/S+IfllZkUjy9LP/OHPSbq2w0pn1ZyHGYbdBOkaGTohULiW5n2sffbRRYgeQ6nGR0axrlkXP1dV84lvy7RndTsb1ix2FeqNKMtsmlG1oqd1L5/OB84S4bbG2TuJ7XZ3wHxFdyrFe+NxrXSGS3zRcK3qLJGgvHprqGKGfAlcb4AARf6zX/9Ybkvs6a4T8E430djAyYleuLmQEr9Q3JJmKSmQKkz12KV+ULfj6i16fUsXWqrKim0KwP47ELzj8oWY5z2Uw+iW+i+NSfOY7oy//NuIf2TdWnaGapIRI89cOGdxlqC/TagJvTm+eFrPHw/zQyMjbBAibJ+ktazhdKjXrLTb3lOTxN2aAemscCGbq7zfQmkYbR+JPPWFwo2zEwqf4F6wf0Tv6PhVMALWpOw0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(39860400002)(366004)(52116002)(36916002)(478600001)(4326008)(6916009)(8936002)(26005)(8676002)(86362001)(38350700002)(38100700002)(956004)(55016002)(2906002)(558084003)(316002)(6666004)(16526019)(186003)(66476007)(66946007)(107886003)(66556008)(7696005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?jn1o1faRFNvTltvvNOOqby3ZFuj40uYIX8Uk5FK6dK/R9NRw2iiuv3aFptRY?=
 =?us-ascii?Q?/vzIFicodR1wOhQ3uGPf+WVUv44IBzYvW0I4b2Ink65IDo6V+dg7D+AHNd2D?=
 =?us-ascii?Q?u8vdr2z/yhQWhRdTVYVVAwvI3pS9vJaluy58m79pcaUI2lIkeYy/iREp1UT5?=
 =?us-ascii?Q?L0veu09YIjPkuwj0sHh9C1fxMGdOxcXQMkYBGCe4xr33SGRN94hD73fYPTO4?=
 =?us-ascii?Q?UPGuzhTnZcRqBnjRZq9ITPL2NQ+Cqh+/dNI0yhpb/C7iTc3WM9blnuMWFHzr?=
 =?us-ascii?Q?zBFw/ZjYf3lLh49S2HGWIwptQVFAPLKRcXioezjT1O7z0BGHOf9LB4UoOLVK?=
 =?us-ascii?Q?RHiefNq91FZvJcNkmCLyerI3abazO3WFYW0POmO6bClzA7vDGTmuI4Hzodwd?=
 =?us-ascii?Q?W+MjcM0/6nb3xRK0SuwHxnaNcGQSfA9fU2neQEjIJyAZIbXhi2fMxJgejKT5?=
 =?us-ascii?Q?ag2GYhD6xNnfBptObg8CJG+cRPQtpJIVuJyD1+P3afnwQOY/if+DrecCFREr?=
 =?us-ascii?Q?AcDBPz3OgekkpRKnKypMeWq3DOmGfGTq6QGiLG9XmnDlH4EXEc1/2HD8+HdK?=
 =?us-ascii?Q?UegxPu/nY/ywMKNfGCxnqG8XZ1A9D5AJZJtjUxP/FIGuOXYUBeAnmq66XjYw?=
 =?us-ascii?Q?8LxIbP5tIWcB6oPF+7dqmwGSW+VFY/U2utp1CrAcxa09ny0eK3jrliiS3f9j?=
 =?us-ascii?Q?14FAMM4s43sKocDUBDca74jIlWxWNZeAqW0iRfcG+CwcwJqRPzB9X4eyH9zK?=
 =?us-ascii?Q?lnHtquWvDnbY/DvwhE436qBrOMqLsLv6JWVgaGjYFsolaMgaEa/+oy3p4edz?=
 =?us-ascii?Q?wOAT0fgOzN4qaRWg0ZtX5QPpaFeTRfMVKkwSMRH43rUhwXj0Oz6swZuQj/Ow?=
 =?us-ascii?Q?R8jEqJnMvCD5cAB9ZxD6Ligq04ewdJQLevo1wfpqiXyMt6EcvFbx8W4e0yYl?=
 =?us-ascii?Q?31F5hAT9nplsaQI0kjxqVGrdWhuvhRi8smlnHx0+lR5dLWjewyGS3BbeJVmF?=
 =?us-ascii?Q?TiZwAxxEWHVonJzMi3v48JnTAcj6B/M8JqvMYZoBdLxHiNNHJQKkhlSq1EI+?=
 =?us-ascii?Q?2GlyH9YyDjrhSfKRnbcOEF0UMtwKyzxgMvh1u9qaGAVXps9O9vSKGolB9YTj?=
 =?us-ascii?Q?tS3BQBLVuTq5M7v92B+f57TlJ/tGmrZ5yPMp9651S/4QsIVoiNiCaBIj/6sD?=
 =?us-ascii?Q?T1qB0UN4buN6tdl8LJ+SJ30mRPm5duMVxQHAOsrwpy4udlGhpkEHopxM9UmU?=
 =?us-ascii?Q?Rm19yvydjalMCwiLhK6YgAuhHacxmkUuSvzpGsj28Unw7LQ4qnduP48u40pP?=
 =?us-ascii?Q?H4qXR1L3Canb/L+ofaK4YCFM?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48b50eaa-67f2-4f72-4751-08d9174d5974
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2021 02:58:43.1454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WTE9r8fjRtDdRdN/wBzgDsDH4K/D1fFHDsrh+K8dOedwkSbsZLPK7hSdDcbo1BxUhtTZwCjjHGpx8dR/T8tyG7acMjRoh2Hr2GMROH8rKBk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4806
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105150019
X-Proofpoint-ORIG-GUID: gXJsqIjBc9Y_fo1faMD-mMxBPdxCyDPc
X-Proofpoint-GUID: gXJsqIjBc9Y_fo1faMD-mMxBPdxCyDPc
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bodo,

> The bit definition TCM_DEV_BIT_PLUGGED should correctly be named
> TCMU_DEV_BIT_PLUGGED, since all other bits in the same bitfield
> have prefix TCMU_

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
