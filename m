Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92D73C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 02:39:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234570AbiGSCjr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 22:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbiGSCjp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 22:39:45 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1158026566;
        Mon, 18 Jul 2022 19:39:45 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IKoPF3026655;
        Tue, 19 Jul 2022 02:39:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=GYTSJbS1KpwULgOK/qeF5+BCHdH2vLedl///ClxSNUI=;
 b=hkC0rSOk7CsP4plVPpw9kd/NLX2lGIS+S3HnCIFXFOVyvOY7eX8KIqoGAdSGyPcRGabV
 OHxvPJ7ICIfqrHXth0u4Jac+K5N7vFdxEBSD9KT+gkzN4OwChPkcx1w95O9fsUGvMVIn
 KZOhjmaBpayZJ6xaQQZwS17ElSjgXxfwJWocnqAzM7YNnqBZ37eikC62umaPT87r5g2e
 4lBHXOdKx7QtHI2rDqD2Ej12XaNYt/H7xoGJPw4YWBD4NBcXR/RV6M092Oya/vaZAOeL
 HySdzV7sDiLOiypwE/POZ1pvHT/wj4+eqCrN7vH3M65Hi12cIRmqcItSJfg+DEKynnHO pg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbn7a4v3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 02:39:42 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26J2LXxf001324;
        Tue, 19 Jul 2022 02:39:40 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2047.outbound.protection.outlook.com [104.47.73.47])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1k2y9rg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 02:39:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mf+lav8taEWTa3y/PY02x4RFEmbHaHDusRlTJxdw0IQdI4LjngrEyz9UmucBRGLVyxCWeUZXymIr+3Sq4+UHr663Lsd3LdLWbWOhrzP3hBtpjzyxZIQUhsFYvZbN1jGuPea46AuxI3tIBO4NQELKZxm8qcZUJbCjqXx2tfVUvIyetgupYEB3MrDnPF+qQK37GixNAZabTKbYtG/JzMnyeddN4YOPqFPiNbEhvwYrpE+uqHGeUlUlH3F36kjoPRbWv5Ct8WP2/bzqX6HYSB+156uh1QD7RdUIf93xGPv2GKYUFW8yw2MqXRPQUQtbivd21FIX+Imt5uCueqndPtYgMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GYTSJbS1KpwULgOK/qeF5+BCHdH2vLedl///ClxSNUI=;
 b=D3+XYq63ulaW/XlB9VSMlBv2YipSXtP62xABlfrm3bH406I68k39uHTm+yPURAmJh4uKqTOGzlt/Ouu+AH0ymez5c+MDZNmJuXDqAcckj8LHAFL7sCKPWeWIwXtk6W+PJvQvU3hgkaCMjdTqjzzEta+ohPLZGxHpFpz9OSnqyIASswtSxX0JMixsOaXV3y5jmtuY8G5sKz4dCoMceQ1Jgy8rXYuVwocW1+Qske3e2aFimljO/Ai5ABQYJhhKuGy5DL1O65b5HWlvDxsuFN4qCsXqTSLLnoYo9gc+oHYRRV9gnHtVaTstoFk6futOzAd/nzEEgOTyGQP8c9zQKcS1Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GYTSJbS1KpwULgOK/qeF5+BCHdH2vLedl///ClxSNUI=;
 b=DtSig9BMzi3A27ZzcAgRYxmutqbj3GFcK7kXc8fghhfLVcv77CJRjCR9KFtaLWzNRPAUWjLi1UQ/iRxBH9DF30Z2TB2gddH3NaWE2gtXRkCiOWbB/1q0pCMv9hQQKxryPTkBnjPCQ1/ymqRpNW9mZId3Sp1VWWkIQP/RwCqCM1w=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN0PR10MB5206.namprd10.prod.outlook.com (2603:10b6:408:127::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Tue, 19 Jul
 2022 02:39:39 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%6]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 02:39:39 +0000
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: mpi3mr: unlock on error path
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wnc9q10h.fsf@ca-mkp.ca.oracle.com>
References: <YtVCEsxMU8buuMjP@kili>
Date:   Mon, 18 Jul 2022 22:39:33 -0400
In-Reply-To: <YtVCEsxMU8buuMjP@kili> (Dan Carpenter's message of "Mon, 18 Jul
        2022 14:20:50 +0300")
Content-Type: text/plain
X-ClientProxiedBy: BL0PR01CA0015.prod.exchangelabs.com (2603:10b6:208:71::28)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0093a4be-978e-476a-deea-08da692fed26
X-MS-TrafficTypeDiagnostic: BN0PR10MB5206:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: leSC/zn92A5PRbfVoDnBjFmn18z1xuX6sQrTpF2EYs7ZUYS/R3B0Qd1MSh9CUuHK6Ihwms2l/1YCtHUxnxThLXmRfECL+bo8pBPuqzG1EtkSj2H0o7EVQAB6EmH3rZSXHwSLVSpLV5FABz3/P0FEHMYhcOcroclFHvH83FCW2yLPYc9fVH3aSMzhzvvx4HyqxBHzYtHOctIStBV65l3Cww8vvI9DJRvvcCgZNluAswmtdPg0hwMmEDqfNhmh99/0RNIN3Hg6Kj0WbQN7K0nsHQLIorKMM2wjEF87yfiZfEst7FsAZYcdiAhuCDA39oBe0LWAqE212RmwYL3J4n1bXdnMxh81iIyvFeis1vKW5k2yYvhjUzaczU3wq4wb8d+FlGWTeKVcvj2A4G82MwTFmqqhJiLcQy1sVIPj4FIkUoqUlk6bv9Vbf2BwPwc5AxMwYYxL0vNv6t6+43R41kjk0RQytXDLLR2LgRRb/t7B/i7AIgW2gDxXme4cxXXlgdUop9iHGoKaKltI79SJPYpa+WyDAgkbDc3tLCm277kPuvanCDJ7DkG1S8wkJ579axivA3imslBHA9aIgPs03Cecq/4Zik1CC+NZ9xF2AVRNrVwQAKVzzGHKDdZ4ACIu2pWWpsh2I95LVp85WN3w/lQ8j6Ek/aD6gQr49HNPXJxNUfNh+beyFXtp2BeK4AK7dpq6qAYg1J6u7U6KvHr8p14inBtkG6DbG1UZWkqhTLNQc3OO0LVSfyoCMH1RR4ddIlCMS48u7ZdJE9TATIpFbwW2/QVfetDnYcBf+U6EZkL2swQkkXitN8om6BkY4Rf8HLPCNEdqiK2VpYX8XDrGFYEjkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(366004)(346002)(396003)(39860400002)(5660300002)(478600001)(8936002)(6862004)(66946007)(66476007)(6486002)(4326008)(8676002)(66556008)(6636002)(316002)(54906003)(86362001)(4744005)(6506007)(38100700002)(52116002)(2906002)(36916002)(26005)(6512007)(41300700001)(6666004)(83380400001)(186003)(38350700002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Wa4iA++PK1TcomZYuhXUPyuM7wufC56twts1uPooOlFNIAwvOcJr9kZvx4S1?=
 =?us-ascii?Q?fWXyhpeYmUnokuIytlDISav3ZpyEjbkTucAZExsagNuLoEB5w2mi5qGVSIg8?=
 =?us-ascii?Q?MwMTijdtekDGHMM3QXF/JsohZkrTCroKC03ivQMiAt8W9RlnK/aapXGCQkJQ?=
 =?us-ascii?Q?NrlfpQqlRQ4S095lGt9b5k71t22jBFvy/aWacnQwsT7lIYn+TLQoLlV7tQHc?=
 =?us-ascii?Q?qhwWRpgp4eSf+zIzN8ypIfpobIEHTkog2d9GCeF0E7HvmVTbJGjYX4JtdEtp?=
 =?us-ascii?Q?iO4/PWqTHUf1Z1va/A8uPcxx6L/1LZi11k//5m0IEoXYUqQ80f7PoX3XozqM?=
 =?us-ascii?Q?LOJ2foZtdgUa/hTUAewSTmA89AoWBvPat0sxr7TYMm6Xy/E2LTzeq/axMNde?=
 =?us-ascii?Q?tmI9h8w2VRwEsKiuu4kCLcXjG+ae43O4rEaAA03CKeAT6G8vcpvu/omJLf97?=
 =?us-ascii?Q?sIMBSqRafil9acivv19Zf6qMSryL5V7DAoe+LP6jhYWiTgedroXexRHoCf4o?=
 =?us-ascii?Q?KjqHOlcpaOyUGZT+33nyBYY/x+azgyHnI72wwdjwv8eR/q83C3Pq9m4LzUmk?=
 =?us-ascii?Q?ZCfO1Fx+2Kz8iNS/9LrKJh4D5mQSqut8Pcgxtd4SpVNdEff2BeDCHNqAKoRl?=
 =?us-ascii?Q?JqMRk2LVnvHKHSSBKycVmAHO+cxYP7ZL3B3wV/BuufHJ2ToocAEzZ0oMwU5R?=
 =?us-ascii?Q?dYOKLtzgJNfFmB+bCvEvrAkaT+QmGk4IV7uBZgLdh344wV0e7IUQ0+gQ9fJ4?=
 =?us-ascii?Q?YmiSS0pY2WF6hQjrdz/i0iboxUKcBdjpHVZtr3FcLAVAauReaWbYQNo4Abib?=
 =?us-ascii?Q?O9H9/4/M1fsWdHKIJ5+22RSlY63Hc1I9COK5ywt+rXHOEACyzIFqP5+1NFn4?=
 =?us-ascii?Q?98iifLYHZIhd2DQ6FkRYBeQbVa3+Xb/GaYTfzjIjxLkDEC80Wz219OFGx7wo?=
 =?us-ascii?Q?SidZA9j7QaCpGv8w7qkc2hFMQ4smzQfkdeCHlx9fuoolDrIxpg7VsaIYh7Xx?=
 =?us-ascii?Q?6zc8QOp8XmoMwwSw5G4OVPXGy5H1aXe47QL4R+zcWqwYMXKxWxjCbO4TFUrN?=
 =?us-ascii?Q?IM3di6lLsyxQI1+bHNtMUnU0twn0TAHStUbApasFuXVmMYc4TPQ1IDfxgbQ8?=
 =?us-ascii?Q?tZ+Jzk6Vq26StPsVgmXcpr8DIvwmAT+PPJQugxhJgXVBLOvWj2UeyNs5By8i?=
 =?us-ascii?Q?eEghQsJsKXhx3mgSd+6QtovRqo4uKacyIRg94bBLdphwpSSAXmeOqj0+dsPR?=
 =?us-ascii?Q?BaZUuIu4EB2dlKHo4eU9qFF++EzvS03jo8XjZhb0DHKZSYpBBUe1cn3hWxeY?=
 =?us-ascii?Q?fmUp3rhhnUE8V3uUuow6tDUd813ASyP6PSkPwSImKzJfMUHw1KY2djtJWLLB?=
 =?us-ascii?Q?NkS5CCmZwxHPhYD0knDBKhR8Q8+gfn67mDJn/Sm3PcFk0a+oxFJRJZMZomyV?=
 =?us-ascii?Q?dAdmSjea1hvenLjwEDy/JVar5srAaOUZHnr9lkl17mjLbUqv4o/Ec+ciqSnh?=
 =?us-ascii?Q?GsJmDGrJDdK5s3h/mzIjuT5Vr94lpRB78TO23TkKOG6v0X+rs8JfXlJD+AnZ?=
 =?us-ascii?Q?P3bvaJqWcFxhOryEO/L1eGPu2HGi11TMNl4TFE3F+iwZh2fydJzgDPD6BMN0?=
 =?us-ascii?Q?Pg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0093a4be-978e-476a-deea-08da692fed26
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 02:39:39.1203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XECBWbNfVUYhPu6cyHkhR0CuVuWjqCo1sGGOvPpoZ4AT9FgF4f9M5pRdT2Qh8/PossWbKYPZWEOCnFUVyotL7ufxVj+qM4dxW2UozbWQskw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5206
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_22,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=730 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207190008
X-Proofpoint-ORIG-GUID: 0IlgZENAq3rqVdtbf90_c5LrhIQ_nKU4
X-Proofpoint-GUID: 0IlgZENAq3rqVdtbf90_c5LrhIQ_nKU4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dan,

> There is some clean up necessary before returning.  Smatch complains:
>
>     drivers/scsi/mpi3mr/mpi3mr_fw.c:4786 mpi3mr_soft_reset_handler()
>     warn: inconsistent returns '&mrioc->reset_mutex'.
>       Locked on  : 4730
>       Unlocked on: 4786

Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
