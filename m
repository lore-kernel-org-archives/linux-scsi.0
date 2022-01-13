Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A33DC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Jan 2022 19:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbiAMT7w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Jan 2022 14:59:52 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:3520 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229704AbiAMT7v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Jan 2022 14:59:51 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20DINiw0005402;
        Thu, 13 Jan 2022 19:59:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=HGhAgqgVX8ZMRQpyMcyLxVYIa6bmQmJzJnMlOp/fnlI=;
 b=G3LZbBvjmkcYt+eTdDbvFi08QFUOsPLgJ6o+Of/ZMjvVWSt9U1Rv5uBhItRFSBCm8YnG
 n6u6WnkrjpbnP4Pp3Hyr0LoVJg7XiGUcWPXooeF6jKUTyFhTsFd7ZR+EEwMj1POZKSKy
 EjglWmiY7bvLEyz/2Vr8LP9hmolCFMp60F9ZYRUTa8a68n/B8JVzJ7LKQHEUr18m9cQk
 Vg72yeNg6hwrTm1iA3q0UEqpFT4sxTBWZ0F5VxuXfeGGLd5tqPOyfrjgTVsVY19JO+o2
 7o3Obag2hTrmmuzFlVOfaxxXoO7ai1TXFgurzg10Jx8x2DNpk4kEsyvtxmQqVz/4KCKn mg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3djgv6a20k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jan 2022 19:59:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20DJo65S066505;
        Thu, 13 Jan 2022 19:59:41 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by aserp3020.oracle.com with ESMTP id 3df2e8b7mx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jan 2022 19:59:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=irLV/hCw95GxyPMtrfohi+ERP/OzMO89D15vZqbnlRl+WKj6gbheSyxsmuM2SS+yNzKC/0WaEk3dhxphomOW/t1MCGu/HptoRPJoE4pAVpnt/G6HBg7xPJFBYnR3YB1okrPvuJnKow0rAZZYyJrY2z+nPdyFySusRpEb8actsMZhtX/y5f3K94sCuZM940v4+X8zMo7gjAJRLz7mNb/7ARf7sj9twvLdl16w3tTg98RxUQvohGkoorKBAnvI1JHLsLPk8G07XjZoc503FnuUS/6IP0o1a+uDGzuHVLZs2mtLm1/rG/XdhFOTBh8kqGeeb7eCh02n1afUqf6oGJ+gqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HGhAgqgVX8ZMRQpyMcyLxVYIa6bmQmJzJnMlOp/fnlI=;
 b=fZXW47bNig/tEgCiZcu60cXt1Y/qfMDa5SxhhxqBr+s15wbC6tzht/qJOCy236PfUIsPQEGykF6RrgBbbFcFAsU0vL1+W9uXG8316sR0hl1QwqFsyU7OdVol4xjbSAYMElhDk6T1a7S1kUpp56ltCSf75wf520gzifQVjOYTk+OVr9aPumFjbxXCfZl3ZTldlZ2eaaSkFsn3jIBm1nU303ANoWlMp7+5grcBICfeGKuOp+ue61MQkqhNFoSlzr9SVZjuacVmMWQYi7jcLIbc4KHvytRPPQwCEN+0U4eKNoeeeC1hp+w5vq6w31eEESbeJjPTekHow2QPB6v9uSsNDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HGhAgqgVX8ZMRQpyMcyLxVYIa6bmQmJzJnMlOp/fnlI=;
 b=QAw5LczRz98YkRqF34CoYoHn1f+1oHRNJ2aXscbOOP/GKJZxjPJn4srN6PXUkCVu4tXGJKTvgUX0PLb8O4ehGT/QyDYqgOZwzlISLdJMQt0LD3wG7NF6SQ9FdZjjZrngTsRyj9TTo2oSSpsICCw/ZH60lErBA3pj6VJ63D9IhGA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MWHPR10MB1967.namprd10.prod.outlook.com (2603:10b6:300:10b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Thu, 13 Jan
 2022 19:59:39 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1053:7ae3:932b:f166]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1053:7ae3:932b:f166%7]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 19:59:39 +0000
To:     "Lyashkov, Alexey" <alexey.lyashkov@hpe.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Bart Van Assche <bvanassche@acm.org>,
        "Dmitry Fomichev" <dmitry.fomichev@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 0/1] t10-pi bio split fix
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0f3pg4y.fsf@ca-mkp.ca.oracle.com>
References: <20211220134422.1045336-1-alexey.lyashkov@hpe.com>
        <yq1wnjzi6oc.fsf@ca-mkp.ca.oracle.com>
        <82F812AE-BEFA-4F57-A134-C1EED7F1928E@hpe.com>
        <b16b20d3-fd5e-ce5c-f744-be5022b4156f@opensource.wdc.com>
        <71B870D7-16B9-4299-ACB0-F4B6D5188C70@hpe.com>
Date:   Thu, 13 Jan 2022 14:59:35 -0500
In-Reply-To: <71B870D7-16B9-4299-ACB0-F4B6D5188C70@hpe.com> (Alexey Lyashkov's
        message of "Thu, 13 Jan 2022 11:13:36 +0000")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0021.namprd21.prod.outlook.com
 (2603:10b6:a03:114::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3641d5b-4515-449a-946c-08d9d6cf3b52
X-MS-TrafficTypeDiagnostic: MWHPR10MB1967:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB196757C54A2F2BF339AD848C8E539@MWHPR10MB1967.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HmR9D5c1T6Qc5WnwFj/vEjd8XC0KJ7zslikzIxpTUp3e2B4MU9Kzb/CzfedWfZmKl1Y6kTBVW316I6/+qAMafC8/hjnghU5IfKyLJlYHEsMNxFBCJLkfvCvewX1eoavE0uqKhMCH0cdO8NLpdqcXdZyIpabzNlXNPccFCdw825Zv0fwwRoAPqIbdPP7dbS3agTqeWphVwjTw1JI01IQnmPKVK4ynV+jkoNX4U8X5IPLPIUKZtwAk7dsWkPdiAOELTmjF1KKYQy++wKJ3S/UMI3R/qx3r3sju5a1mzjMkTIkyWNcL6VkwolV4hm4+10FAVFm4hWLrqeeg2p+6LT8wLh23QOInAT3GzOEiyHIDuqeMOkarPauvRdke32WdTaD8x6Y4tbPpXRvreBK47zUwXOcv55twARZDiY1hJpZUfARJUwgFn5Nbh9NJ0qTbhZp9hP94gHsD7ysjCLhY+sg+Rt4KPoONH2NH69HhlRylq+KB8EWvSsHTBHHusQkDYsjqTOPDL6SNspoA01HW+wy8M9MlIXDqmkyX44FW/XeMubMnh69rYPXGLqivWomj5an+ONpHdPrbXl+e+Xe+AiSiGvxwsgg/9ZL0tmy1YdDcHjcySpb604lvi8nym7yvKpn+G9WyWmUitXp+8s99I3zVEnztitzZhe7M9mM4bATNoIIPMKS2QbkSz4y9sDweOvneUntwo6+ddsIYKKTRNbcJdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(5660300002)(4744005)(296002)(36916002)(54906003)(316002)(8676002)(83380400001)(6916009)(38350700002)(8936002)(52116002)(66476007)(26005)(508600001)(66556008)(6506007)(6486002)(6666004)(6512007)(4326008)(86362001)(186003)(66946007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CXayHCo+C7n/YGdh58CdWqDcUZh1JhG7DgunGTcoDzOgJVcjXPLde+FRVFeB?=
 =?us-ascii?Q?VAaJykKThwU8hjNrOdMHqBEaglOj+FkJIBgDajV43+szc3jcgRQUTzpV05eb?=
 =?us-ascii?Q?/t8DQCQRnpGc2aaL39CfuaZIRQgAN81QUExEJpfX/mfADOPRwCWSgdiznVag?=
 =?us-ascii?Q?iDjMJKYoESlIv5ljrx3qNvjoiBuO09iv2uX7YgFgFDppLz4TXL3oj4/nxM8R?=
 =?us-ascii?Q?en0NlAjnHG2YKFC9vvjobreyhZpY8zR+qpCPWRuLDwvcKbubtEogFtPX9xqG?=
 =?us-ascii?Q?WFXqyBf7FTqCtrhI/k/oR2NCKtyPWRW1MQId+Rb91C855AgjmJ6eCY+BgQ9R?=
 =?us-ascii?Q?PjleTg/u76U+MNWyViOT9B5swfm/h/JaN285Zik2858MgIeSnvXtNC/5qNZF?=
 =?us-ascii?Q?WNMRoXy3qVwzZ8pbkGo184mJ7mqOntx7ykvGYCOa8A72zMdZOscjhv8OHiDE?=
 =?us-ascii?Q?uHvY9Yf0s/DRL3lsp2xulEXEREcpAgWvN6ppWURjR1pnGrDNxEfaZ3IV17EX?=
 =?us-ascii?Q?xbLVUwmg+RI0VXZWkwRJqOABzt5G3SDVzlOm/xiu52cJPmikOHAFAFTvoEpy?=
 =?us-ascii?Q?VJrEw+hREQMzFmYA8w1TX3xCsahMWZOYZHLGcgwsHh6cYtHl7oDGJcFtHWdQ?=
 =?us-ascii?Q?jWSJQR3QeBtn+uG/MZ0B35dGxfV56lc4rrLNa9x6WDEEB831qKtqq38AzF1O?=
 =?us-ascii?Q?UwiKy9x8xIeQv/R2KRGaWWS+A5FO36H17g8USmO3RanlCuI4nN65lUj8eAjM?=
 =?us-ascii?Q?RkuV2FgBbqYBc1p2MTqqG0/fo+8ZpslYTGGs61S6TTjPBgDdpeVjjZlMJMF6?=
 =?us-ascii?Q?2p0m+xqyWEsH0AFmnGe97KGglX86ziupN7bfNHX62R7PqB7AIWVeie1V5WqZ?=
 =?us-ascii?Q?rfaLdcOmR2LMunBHNZ2gHaZjfgIJNk0eu83MQoenxCEmjQKpt9/l1leDnmnf?=
 =?us-ascii?Q?qxch6B6i388nOtpwcS93Jbx/HYISzRd6Acl3ipfQjOAiSpxV4oqLlK/vRqnb?=
 =?us-ascii?Q?SIoEYzBRK/JxdyPcNjAXNYaHDzCjxuCF08GIkn17BSlMoGvyFHAXnlVGKGHl?=
 =?us-ascii?Q?eodEyFHTWAxNkoIfFOD19WPYzTQueHoFmOXy0+o8idCrH+yuE9N8dXEZQPkt?=
 =?us-ascii?Q?1eAnRcRlF1F/l6Xsmin2sMyKLJhurxX91kh2RSazFPB8383qTLIuEvPvS+rW?=
 =?us-ascii?Q?jPwOKup8jZ2mWVGQm0GikeC2wnHnrbnOwj5Bak/pnX0xOXrjtigEPwU9aaNV?=
 =?us-ascii?Q?Kuwsiy1vjvpRS0LylNy0Mazy325gDsu6JcGY7CnzVhtRgdpEZzJX4WOcREo7?=
 =?us-ascii?Q?ZR9u1saV9QQKTThRfTaVGo/XIg/rvw/Dv6z2QFNibw2UP0ahF4lS/VhYyVLo?=
 =?us-ascii?Q?odFkTmqb464vg15vDSYwUA+qqUQLr78zVmN5KullT4ELxc1ZyJ/Cybci6/Y4?=
 =?us-ascii?Q?KADmEmta0lBcY0doUGSh89baeKhXqpDj4uyrXdAk9Mkyn/7jTWVr6zNt3oZ8?=
 =?us-ascii?Q?HMrbp5hKNO+F8wy9h8coucnz3vkORh80iUURl0yi4WpWDAEsdAPevGyz5JDW?=
 =?us-ascii?Q?tcPUTYiltJ96zYC1WFjbC9I2DNWjOxiz71xftmF4/VR/o8yBPS7kEdyIdNg9?=
 =?us-ascii?Q?43WA7or9FpRwQdIw70bAIKMT1J/e9a6GEpFBUlJgpMa0ITY+VyLVt8/1fKvR?=
 =?us-ascii?Q?MhbVWA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3641d5b-4515-449a-946c-08d9d6cf3b52
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 19:59:39.5383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BUYaQBrI7C7T11qXVjG0jKPKIg6BetN6BwGatDTiqPUynSf/xfCOqk2t9sBLov31uJ0vdfRmi+IKdCVy6Gap3x335GqmoAliAVeBZk8deNg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1967
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10226 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201130124
X-Proofpoint-ORIG-GUID: bHLay3IoYIR4jozfc0ifCtMzMKJfuuk_
X-Proofpoint-GUID: bHLay3IoYIR4jozfc0ifCtMzMKJfuuk_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Alexey,

> Ping for review.

Can you please try the following patch?

-- 
Martin K. Petersen	Oracle Linux Engineering

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index c0eb901315f9..fa5bc5b13c6a 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -387,7 +387,7 @@ void bio_integrity_advance(struct bio *bio, unsigned int bytes_done)
 	struct blk_integrity *bi = blk_get_integrity(bio->bi_disk);
 	unsigned bytes = bio_integrity_bytes(bi, bytes_done >> 9);
 
-	bip->bip_iter.bi_sector += bytes_done >> 9;
+	bip->bip_iter.bi_sector += bio_integrity_intervals(bi, bytes_done >> 9);
 	bvec_iter_advance(bip->bip_vec, &bip->bip_iter, bytes);
 }
 
