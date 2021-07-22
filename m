Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22AEBC63799
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 18:03:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE2116135F
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 18:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhGVRW6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 13:22:58 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:57462 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229909AbhGVRW5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Jul 2021 13:22:57 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16MHv3sD025672;
        Thu, 22 Jul 2021 18:03:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=AUkTw2HkcMWZSM5C3CxRqSbG7TT3mKklEAM9Xyp6AxQ=;
 b=asgPXCtb5lWqFb31QTIxp6RLh+tMBMkUQO56h3xFsq1LLnnFUlXG3RThVBnDNp6uBDyG
 wF4hE8T+mM7Ha1CBXKtRV2UFCIWGp9yIdFZHc3Dtv49g0owiHTmBHsKaNs0mpMMGR/p2
 7LXxu+rXx2hcG+7oEEcQeZgwJu0e2Uey+n5RA3ijEj119KqHGEgTVqovVU4FC+j3ON1u
 pRkjWGgM1giSqceYVLH8snVxan0ByvyTpaNBYGQHDPd/SIuRNfJyiOR2PC5Pp7ov/EUP
 t2NJ9QYuLtw4jilYyN4wuMPOybkV0RDlF9hgWvfChJi3Fq7JzH32f6fXVRqBCNxVQbrk Gg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=AUkTw2HkcMWZSM5C3CxRqSbG7TT3mKklEAM9Xyp6AxQ=;
 b=y4QzyLMa4Hu3x7jgAQVwHNYg9hT7R0s5mzB/3pqhPpzRpWJ3P+V/1I5iLiAQ+eBblITz
 BxD1CpxC8ItdwYMsKSwQNWKu/3HHSQZy+5uVv2o8mfTCa8XHXvZVEEeBnMcLCiP28v3k
 CDO5Pog9NsJ8tjlYsCKap0/LjXYxgV0C79hCvnH/W6fZGf+fqIDvLoYemwfIjHYPFuLp
 WZpw+ar/GTqe6s9NHGhMi5fipmFiciCb6VT7ii0M+kCNBpTjC7S2MW5vFXuo9cA2TL55
 3IzXqdbCc9IiSYmzXLEKfiYjVcNNsHMedafw04bf1Q6Vo99MfCVSfnujPSJt0R2ofCro 7g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39y04dstgn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jul 2021 18:03:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16MHuUfv189251;
        Thu, 22 Jul 2021 18:03:15 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by userp3020.oracle.com with ESMTP id 39v9011dsy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jul 2021 18:03:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nBK12ElGj9RRkspVOARiCpYHyka2x/bskA1wJnM6P/RxHuZS7MCxzd4T6I2yeAia86P8KB81bUCtg0w8t5Evvb0LmGM+knOFKlbLG9SoeulgXkYp47p5PSOuwGONIwI8exV9lNXaVa2nXePZrUt3MfjVqe+18xn62EXGAeHvRUd6e3bEt/bVOzENebdRmu2sjcoY9aBcehO3DC+gPTLiQN2n3AHoF+EWgV+zuIEoFzPKlqpqqFeavTkkWGWQ0BFo9w7L3SotFyH7MJYprcgKDiJUd1XgqebSsdBS90Jwis4wOftUUux8swkmfPLFnPqTlt2RZhXp3XfCeT4zI8cDFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AUkTw2HkcMWZSM5C3CxRqSbG7TT3mKklEAM9Xyp6AxQ=;
 b=FZunnIKrKtAotpB3qm/6XKnnHdMWHzoDe/YYsWcM/PAybNLeqUGGMyoVs1K4UrORbW288z1Snh6VfEH513spk42FZ94pY0S9MyIF3izMjX7VYMqocoI9gMKh6AfKmYrF6OLP0V1n+lysSMoeCEPr7kZNX+QUrLbbIbPaSxi43V705j5iQh7B8WsP1qBOa3lFOw/+SJr/KEXRtQGH66cROuRDtwVDVm1vh6vvCe6hNbiWYXpH1m8wuv5tPoehbeHUAWWXBZr3MhYebRlqZJ1SoeN0DXh8UCxSyC29En7oV2B+1Y4oHl49qcDdzMkq6yQgt0ZRvRe8epjzpnzu+6IwPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AUkTw2HkcMWZSM5C3CxRqSbG7TT3mKklEAM9Xyp6AxQ=;
 b=cUzeg26shqsqxxOWZvr0yhfaR6eANL8VKMitIalq4uVwkpzgVUVojDDOMe3BPiqbUkCcR+ZrJeBwJarJPSL9ORxYE0iosejIYPlV1lV6OwNcBcVrIopPRkBs+AK0ssmDeCq4TnFGcgvqCfYeSSmAVAeW8R5j4oXqJtwkehs607c=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4470.namprd10.prod.outlook.com (2603:10b6:510:41::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Thu, 22 Jul
 2021 18:03:13 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4331.034; Thu, 22 Jul 2021
 18:03:13 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Doug Gilbert <dgilbert@interlog.com>,
        Kai =?utf-8?Q?M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 14/24] bsg: move bsg_scsi_ops to drivers/scsi/
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o8auw7ml.fsf@ca-mkp.ca.oracle.com>
References: <20210712054816.4147559-1-hch@lst.de>
        <20210712054816.4147559-15-hch@lst.de>
Date:   Thu, 22 Jul 2021 14:03:10 -0400
In-Reply-To: <20210712054816.4147559-15-hch@lst.de> (Christoph Hellwig's
        message of "Mon, 12 Jul 2021 07:48:06 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SN6PR16CA0051.namprd16.prod.outlook.com
 (2603:10b6:805:ca::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN6PR16CA0051.namprd16.prod.outlook.com (2603:10b6:805:ca::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend Transport; Thu, 22 Jul 2021 18:03:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e99bf935-af62-43e5-ce80-08d94d3af935
X-MS-TrafficTypeDiagnostic: PH0PR10MB4470:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4470D3E0C4D0F48835FCB4518EE49@PH0PR10MB4470.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IkpKKEmwS9iIk/mRUBeRY3EJZqZqV7dk30rokz5f+OZbT0gbkMx+z4jbwdz5fKzi1JSiUS4vAfGw5Ba5z+77tvyHSPebc/Hsx1aYLmjGmhBhoa2uxbg2F3vkiYYe+ldVsDuFdlK24hnyfaxvsXdzWMkWa9dw/ZQImSVrrC3crvx/KA2/uavFeNsqEg2nwfVCw9SnW2PxNkbvzpzxKc/z3c58zRT0Jwi0BJZytz3DJwWZq5o3JmpPzxFO+XxB5e6N14p+TjYCa1Wp38049mbkRvpVmd3ly6Xl875Hwym5CE4++r8Auix6PfnRz5NZrmWkLaCNnUvsGKMen6ozZqGTipGSEREPwmslL6cknitY29nAx9cbHchrZd8SzNW22APFyB0Cp2KKAXbiAGIeVkpy9PWjAFyoD2LsyoFztN2GRt0GugqjtvxWJLQ+41yAG54vKX+pgqEKfEGY3vC3O5/tDVUOjt1bPUjxRmLXSMBST3HF/GSV1zjwBIKkEXJAG1gP1mLefsvcr4cYF3+D4H3mwFxx+j3vQBHKhTqW+DuBhwejLpOVemeVki3QDQPEliE3OmfccpoAhqGDspL/j++pXzjAOJoqmSYjRqYMLMyMVvQxpIhxTrMLaHpt1g87/QuRyyhrnsiW7Ub+lzwFDyB8X20XzxPu/MKJTdQIUXqu+n7whpdKKOFXbxiqtgDcN7Lk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(39860400002)(396003)(136003)(2906002)(4326008)(66556008)(66946007)(4744005)(66476007)(38350700002)(316002)(54906003)(38100700002)(6916009)(86362001)(7696005)(52116002)(36916002)(186003)(478600001)(83380400001)(5660300002)(55016002)(8676002)(956004)(26005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7IqgwLym2g2b2XtRUU+yAzY2f6U2/xOfT6wiToTa7n7YBYrrGTZzs0XrK83D?=
 =?us-ascii?Q?q3+NkmggbkkcCmQhyqsGpR5ydWIsn/tdKoEH/hyKphgtv09PTjDsRqzVuC4N?=
 =?us-ascii?Q?JCl0vJYazvUhtoWaMWUlfZBk6EmhtLkBO/gBRnEhO/k/0JRi7TbXRmWB5Sql?=
 =?us-ascii?Q?tUNehfflmJoem5Om5Qjs/WPGlxnqxah3R+aLz5E9e7HbPn4Nw2KGrZD7EHgp?=
 =?us-ascii?Q?b/q8mjYxAmN6MGGT0yGvPqCRTT7lu6w/6BKjwl5jiheIq69rRBb8c9yOeOOS?=
 =?us-ascii?Q?Qa4ZQh3mBSmpharFI9Jk8wCoR8gshV6dFCU5Le8oUSvgb5LDP6T0nHoG4M38?=
 =?us-ascii?Q?BgDLya7Rttcootyd2N3KMLsWhLpSyDJiT1RTG1NFnQeAgViWLtdh/4/0IU8C?=
 =?us-ascii?Q?P8ggPkU43VlMEjMuZOV8OIYft2F54irIa2hf7CBxgO50700GKeDLgfLuXYRU?=
 =?us-ascii?Q?YbNdHfH/5hbQARyfsW7sUn1TWzKcI/msONTjYjZrRrXM+jplWrVaxvx6DwbJ?=
 =?us-ascii?Q?5A+DFrGY8D1vrLFA860nDpYVbnLq3eNPHzddw7GHzSEo/054X9Z9pKaxVlv1?=
 =?us-ascii?Q?eSEIfKv7Xa32GweWSOpZwrN/W6ZpGHTRrUwPwzqh5SPuo6J0oMtOJrA6Lgm6?=
 =?us-ascii?Q?vvKqCYr68t7pWLxfRl1CdhOkneLxM/os0veoSQyUtdqlr1ikFrvUnNbRfHba?=
 =?us-ascii?Q?b9qT3clDoaRLdb1Gzb0OIDaQQTd2OH2a7l6Uj84LYKgLecziL2P+SCRC5umZ?=
 =?us-ascii?Q?BqVsFIBnRNsran/cUbVejBoj8RcKwN5SK8fgLsU3Xmpxso8lmd3ljy9/8Dgh?=
 =?us-ascii?Q?hEFpz0m9SBSWrbHsoHt9II1ViIzyszJEc/ipCjAIYTJoM/cbghmz6aDhQITG?=
 =?us-ascii?Q?NSZrm9p4OBPk6zf+tr89pqKNYy0+ZPhJY/fQrxR2+xAdbiBiP2hfjxF8VvuZ?=
 =?us-ascii?Q?SHtlHCmfGi6f6q5N9pd7pBpUfO8L+dr7XVNLWGdxIdFaKzoQpF8NWmhSxQRT?=
 =?us-ascii?Q?ajnSq0CukEPmXbQKdsB2Uyulltt27CkvhoB/nTk9qQsHvYGPz4kz0tBZVWr0?=
 =?us-ascii?Q?NmPkJbnsPh0PraR0LkjCSKZdUHKhJ1fivDdXJ3eysSbqNnS+gQ1LvLP/h9wt?=
 =?us-ascii?Q?2++s4XVFKCSviniGL7NAVhZTcqKJfwI2aM7hbTEbSX2YmTE2V6lWtW1ufyUA?=
 =?us-ascii?Q?RABVShRINABLnyRfAzhPwNPQ2hSxIU+C6/YLnnz/EDHOYacuYetQk57Ne8AE?=
 =?us-ascii?Q?7DLUuYS8AfZLws66YA6Kv0bFCv31lNFQ0TF5vMJ9U6OkugXc1U/sSGbEz4fC?=
 =?us-ascii?Q?OLdvFXjq0BsrgVn1NSMbTHzX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e99bf935-af62-43e5-ce80-08d94d3af935
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 18:03:13.5972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QACbD81YgMmo+Rz5HgNRO9hGKTfWxBfRz33CJnBBVdC2SJ6hpQeqnFn6tx1vlLV3kYgP1r+Q55Z0wCtyS8LzRTSJpBzLOBdmMxlMGvKXd5g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4470
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10053 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=909 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107220117
X-Proofpoint-GUID: 4mRWJ6nmgry_9-M3pxALA5xQs5YduXQE
X-Proofpoint-ORIG-GUID: 4mRWJ6nmgry_9-M3pxALA5xQs5YduXQE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> Move the SCSI-specific bsg code in the SCSI midlayer instead of in the
> common bsg code.  This just keeps the common bsg code block/ and also
> allows building it as a module.

> +static const struct bsg_ops bsg_scsi_ops = {
> +	.check_proto		= bsg_scsi_check_proto,
> +	.fill_hdr		= bsg_scsi_fill_hdr,
> +	.complete_rq		= bsg_scsi_complete_rq,
> +	.free_rq		= bsg_scsi_free_rq,
> +};

Maybe just cosmetic, but now that this code lives in scsi_bsg.c (which I
do like), I think these functions should be named
scsi_bsg_check_proto(), etc.

-- 
Martin K. Petersen	Oracle Linux Engineering
