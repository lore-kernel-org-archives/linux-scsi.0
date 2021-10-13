Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BD6FC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 02:39:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0BA360F3A
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 02:39:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235800AbhJMCl4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 22:41:56 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:2970 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229980AbhJMClz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Oct 2021 22:41:55 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19D0ZVeY028779;
        Wed, 13 Oct 2021 02:39:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=t2CWOQ8EStR5WKjsZvK3E+dZXibdDn5M07OTPmXUMhM=;
 b=a/qL2xj24SR9rEG0BMzDrd2DjA0hqBajGGiRAlVH8mD+UXyPCsjpUOYu6sS+tC+Mu/9z
 H+b0IRcyPqjlwhNCBTX7Dp12TO2f3zfO5EVCQeYBq+e2fD3W5/sSYOt6czQ9WX35x5x0
 pzX8KIMW3KimauPPRLZvFuebWhgQyCAhBqGV6oRIYBBa8e7zeb9QXqv0TaLY36Jpsawi
 rLpCHwIS4xrXcmMwH/GAOuPIuBEDjlPPiabhkGobyktGPbAbPUCQKGNiqFlvRPbrQYwP
 B9XixcL3QwVikKbXnKeCdSZpGlIFVNid/biaQsj3hcQRsDeeSY5R9R5Cc0N4O9ocoY2I Dg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bnkbh0txh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 02:39:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19D2UkDR170221;
        Wed, 13 Oct 2021 02:39:49 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2045.outbound.protection.outlook.com [104.47.56.45])
        by aserp3020.oracle.com with ESMTP id 3bmae01t1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 02:39:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=URV9lCnG5UV+FwQyb4L9Lx2nFMcNMmrYV0YMdgNo1f5LPbkS/LEsW33dt2KEhE5iZwDWuuG0R/S3HglhtuQuhYDqDh0vG0R0pY2XIvHl+KamRIfHeZmqsk00HbyQkohxXK8CvreX+uhfL5qurdCUtmmXEPiUxb6k47KWGNpqqtdqAVvNEGXYao/aq0gDQFpqtmBLjHji88O769N+Al0jJ/nGq4pVRxHQdg7pXRzqWnu6NCAzHOE5H3d1luQbZsVO48rXxhnzaQjA1WmmHCnRQ5Lh9mYCPiXt0GHH0N+WpAa5+xqT5muEDgJd4Je4bHvr2jT3Qrn3LM9qDfD7eSf8ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t2CWOQ8EStR5WKjsZvK3E+dZXibdDn5M07OTPmXUMhM=;
 b=ezkWYl/Lo/EuAIuMuo4cDv1vf2Pj2f0pdTfUxvzqfF6a5Q5hyAaTlPE5DkRMCXVmAzEb3gVUthNE3p7N40OrgF7zmkQFTb6L8Ot7R44FwAeCB9hjgzxs+qmB5VNkAEPxPbotNT3IAKnhXC14h2vVlqcLiQSYmimg3S1SR3DWDmb1qmR5rgjLqVF4xPBSSEDo3kGz7sNNIbCpzM1JRsuoMT6io+3g8DVk+FTOaVOsNA+Lnj0d7VePU8SyRjKMJersenoJ/YZpqU/HBO+SJaHO28UqZQAtzJZ7jKH2DVXwzosjjtKlW/VnRXY3pkWXNgcAmTBiBrfsvWRypAcTPI/I5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t2CWOQ8EStR5WKjsZvK3E+dZXibdDn5M07OTPmXUMhM=;
 b=iLZ0T5dVNHxVpY4PZqw6RweKAwTnrJvdu6raucCEvZGjEEBVmXglgHP2+qpF0YIErwnUnjAHdUtywZO7S7N5nF5vMF9mBYuE4gS74bXzAfu2yQ2fdd73qXy03/ZcArMNtjC4hQl4ax8PFofjgvq8Ob1MYaf0g/UZtnc2VDN6ywk=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by CO6PR10MB5411.namprd10.prod.outlook.com (2603:10b6:5:35e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.20; Wed, 13 Oct
 2021 02:39:47 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::7c3a:acce:d3fc:a654]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::7c3a:acce:d3fc:a654%6]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 02:39:47 +0000
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Satya Tangirala <satyaprateek2357@gmail.com>,
        dm-devel@redhat.com, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v5 0/4] blk-crypto cleanups
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7dlps38.fsf@ca-mkp.ca.oracle.com>
References: <20211012214330.40470-1-ebiggers@kernel.org>
Date:   Tue, 12 Oct 2021 22:39:44 -0400
In-Reply-To: <20211012214330.40470-1-ebiggers@kernel.org> (Eric Biggers's
        message of "Tue, 12 Oct 2021 14:43:26 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0078.namprd04.prod.outlook.com
 (2603:10b6:806:121::23) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.12) by SN7PR04CA0078.namprd04.prod.outlook.com (2603:10b6:806:121::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend Transport; Wed, 13 Oct 2021 02:39:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: def6faad-742d-45c7-1ebd-08d98df2b8e2
X-MS-TrafficTypeDiagnostic: CO6PR10MB5411:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR10MB5411E51F502BD9A9ED9A63808EB79@CO6PR10MB5411.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kdKBApzz4XdzJYpg5Q6ahClm6OWqTJmLOITqSNq2Gc+G01g5xXO32kslt01a7l2R2rfp+lsXELDZYvg341z2ubGfjk+c6Bi8XUoDL2PBJZk3euM6Kx7m69g97vW7ExWcP2LV0ePeijRn3s4Lff/mVrVPaxXfbJeigQnP8GCzeIwMGWWM4nWmO9CDORtfyV9ucjCmo9lFL+kCfm90T8lbyfgYzMwrNOpK8+BPkkm6WZ7hs69Vzw/dausX/FUh2WoRKbRZOYLFS3j2wZ4leSBmAeSuel3d7JGSeBG4kvYNz4bk2AogmO/ismaHuvIMZ0JcnBZBab/Qc4/Yva6qS44PX1wy90fjlQ7ZjtUdJlOm1F6E72CvhMvHrf4MTTD3oa1iWJwgUqZDfpgHzXETvKe0/dFjNLuLAgB2kUDo2mvG1sPm7m7miqdGs9MTzcvxs2b9OLY0kjXIF2ubQ9pFkgi9ttI2L4CgYZq89zGvjsovSb1Ob+JnadgVe52aZ2XrLx9ASsjCKoXbcdPgGW9QL9wOqE8xHomJdKz7xmU0SbW4Kt+BlDDT/gRzI4sFS82eZMIl/RbPTDzVpyjiprR5Yk9EZ8Iwrf9tw1/LaOh4qkcbo1oqHSdazRgg/ut2SaOCCpl0fBfJ+x1WGAwneHYyTXVy59hoGAdg0vo52HSrGYilP4fux7+sJZzk6xwx76ZfkCGKdUZ12C+vAH8nhAa7DeSj2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(316002)(186003)(8676002)(4744005)(508600001)(66946007)(7696005)(5660300002)(55016002)(66476007)(38350700002)(956004)(86362001)(6666004)(36916002)(54906003)(52116002)(38100700002)(8936002)(6916009)(4326008)(26005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K/90f0YuCD304c7hT2Q2s32/CqsN1lAO9+EbbCKEIy1IaOh1Gqmb0b4PKPFM?=
 =?us-ascii?Q?L78Jo+lx93SeI5/G8maijP3ZclZPSGfO0cD5WOKte+yPgOC6iqz8jX+uNZ9J?=
 =?us-ascii?Q?wUyfsmSEHjzrzTx3BJePKjJMsXZ2sajzW/rQI1zJFG3V13DmdoGsTah1UAMn?=
 =?us-ascii?Q?tEmzDT/Y7ilAOGT+RGAiVMNmG86p65/W7vPzhx1BZlQj46DgflfUHmFQaxZA?=
 =?us-ascii?Q?uMMipOKEVYclrVqOb/sFE5L/WI2fbSAtmwdMVASNBYah9fosd8dZaG4OVfUS?=
 =?us-ascii?Q?Kycen8oAPzuYEHiUI7y40X+lgDkTdgYP4aiSm3r28H0Pox048RFx9dl11jJp?=
 =?us-ascii?Q?kWUha8qAEIzh1q+BnpGKc48eQcIoFj3eXBBIhQlc+BWgsfxHJAzMOnSKTxEw?=
 =?us-ascii?Q?qnBBgRXFVFoF8DXCiIRJyLJUPo+PZGhFNI754tyd2HKG2q/X7ChthFpvDS3D?=
 =?us-ascii?Q?LVNK28oL2WcY2JFOZ5NnlYgPcoV9v8lmmowW0YnFFNS5KOpCzEqb26A8U4dS?=
 =?us-ascii?Q?1OWz2ZeLPjNSZnbiK7xNA5XyT245L/ScOMClJkdiEX1FaLLULxu/bSWxbMew?=
 =?us-ascii?Q?Mq2jO/mBHyy8iI8JOCQlg7qfymURGKJxwsq5fzYQh5IUC3MzVSutrSngZz5i?=
 =?us-ascii?Q?pE/qwHCbet3SSEyf6JXhut2J6NinXfj/EpXRbgJr2CXABJJoLAXiqOJJIym+?=
 =?us-ascii?Q?MtSUCj/4Pr5XQwbo1UxAhej15+exoQVYmMF3GLAZ7r2ehIlTl2cjaG67plmM?=
 =?us-ascii?Q?A1sHfjwUDzDBjfgFqGQ8nx7jnohEN/goVqzTzxfpHO7EfI3DKNV+t+cGpHL6?=
 =?us-ascii?Q?q+KEgB1MySD7JoojnYtBnyNBsETJSxbeeGEh/bjfQqJ2tiX88Yvoqm9fIojU?=
 =?us-ascii?Q?XdKNRxguykL6JaobowHg1onQnSQZhhE1Lp93SK2p/jEr1L5iuk9mvrFC1tm/?=
 =?us-ascii?Q?cItW2O5EIIdNF57Tu8mxsakzewo9N7o+eHUwN5gmA/dFExsle8ZchlY9o268?=
 =?us-ascii?Q?Wrgqhxs9KvyJV1VnmZm32dwODt6F2A7XvCrVQLl+WGlJPwvOM01pyoib4ths?=
 =?us-ascii?Q?E/WZ0H4j5IupohnOuomSrla1kKG2b7iUC9N5pKt5F4gYG3NXx8QeY/lHCth9?=
 =?us-ascii?Q?2IVWmsCoVT/W+VLlrAEaByje/W4dnFUwNoqi0rah5aQksJgmwEcK8E6hpZBE?=
 =?us-ascii?Q?chNL7coUw2K/BQHLhjx8TLYWOtvsdgxrpVL4iHhNPR1xh8pemspz4KIrrPv4?=
 =?us-ascii?Q?f0x/so6bTUmbyF8FRkAnFhyTFVCIMhFnAOe3qg1PT/nbLijhB9V8oFWXsiSE?=
 =?us-ascii?Q?lFlMSi3rEpEh/fTpumJgZnAv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: def6faad-742d-45c7-1ebd-08d98df2b8e2
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 02:39:47.3900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b5DKqZlQILGMYDNBGtuawAZLl8goBso206I5gV/hGpLnj6smuDYZZ2Z35nwnb3uXMXaIIOMTf+8O8V73Rxmk64lWqlhZIKAEKDqVS0NCCu8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5411
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=994 bulkscore=0 mlxscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110130013
X-Proofpoint-GUID: QNXjq9eFW7lVqOXyPdF0ark14z9raHL3
X-Proofpoint-ORIG-GUID: QNXjq9eFW7lVqOXyPdF0ark14z9raHL3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Eric,

> This series renames struct blk_keyslot_manager to struct
> blk_crypto_profile, as it is misnamed; it doesn't always manage
> keyslots.  It's much more logical to think of it as the "blk-crypto
> profile" of a device, similar to blk_integrity_profile.

Looks good to me, easier to follow.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
