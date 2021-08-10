Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F834C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 03:11:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECB5C60FE6
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 03:11:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236532AbhHJDMK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 23:12:10 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:1188 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236425AbhHJDMJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 23:12:09 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A30fcm030961;
        Tue, 10 Aug 2021 03:11:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=3lM36TEXzJ87qYfHlPZUjD3YBXKjWHbcF0i0dXdR6ws=;
 b=Zc/fXyrtKjPaQJmJqhLvV0aamqQzxI71gBTZzDnUFGjw5qFu2qdLDJO+Np28J7t+hlr1
 MQnaaBJ88YWi6wGUQeMDXI47LEbtmIwFuSRtnD73++Ah/O6OqQt1vWCELyarV0y3s0TH
 f0nhArxwLFFmOlQDh+ULQDXbSxJ8xOxfCavKD9RBXaSxmR7biSk/gHcuP+dQMRPBi45t
 pufLXSyR59Zv14MmsHfC5zJJYCUDVhj0zAp3b3PHTafd9/q/Ofp+SRtE9ZhxSuREsMuN
 m4QHLw+R/p1caBtygN2JfPMRSnUJgg73xoskZCwAk9bUmcIK1Bt4Mer60IayxEtQl28m hg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=3lM36TEXzJ87qYfHlPZUjD3YBXKjWHbcF0i0dXdR6ws=;
 b=ckOObd/yfd+SWs5dg10CEaqj8CP3V89pKUjLSmEEHjg4fxrtxaWPl4bnAKmOO2485u+B
 S9KtKJ3IyyskcLKU0NVwrwRp0RGaETzCniRqqoFUeDH2ROmWTyhKplQLLZyaLHMf7g2s
 sXzFPuxeG/9vdqje/Bd8v5a6mG0HRLXpxQ92gtRrSy0h9MVjRgc1HEDzRCU4e2s/RxN1
 b4miDZVQ4e9IfIRWfBQFFp8j0E98DxGsHO1H8QaXMeom8utpOsoR2OnErN58gQdTpn6K
 1sQ/+FLVRz/ZPgQ8263u7FZThp+bseNNXTQqhUztK0IuMtEa6/hUE1OvLei6LuDV/vnp SQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ab01rabdf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 03:11:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17A3A5hD084885;
        Tue, 10 Aug 2021 03:11:44 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by userp3030.oracle.com with ESMTP id 3a9f9w2uca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 03:11:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ceB2YVPw3BrLwZAdCR2YwTn1fB4n4oRFts+51Cf/FQ/fmL09dMUZa3VRmrJN2bq/3IrnzvFbne5p4hWIg2XT0giG4LBEs3AMr4RMuCYdXHLN78imSrjCzx+6o1DhLGjq3x5SDJ3aTBQ3hqq2u9hWMkQWNYfvbQd8Qydjr2DTQ86ALG+eZnt25l3V7o2MtUoJo/rT2WNjJSdkcHNNrPVdHPTUmPhhOXpfMaQXIuHiS3CdrLEspK0axPiBWmjKBgfHv/c6DOLFvDXS3T4xXu8UqjtpDOO4/H/UI0phzJRN8RGBCtrBDiVsRCPdg/TfgmbPF3DFrie+ZK26Ln68sk0i9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3lM36TEXzJ87qYfHlPZUjD3YBXKjWHbcF0i0dXdR6ws=;
 b=VCPSJ1FRWiAuxmAAg6fKeoTH3bSF3xChlPmMGn16qI2+bY+U8j8Luyu0pK7IvYeOfQMew+B3pCeVHT4NdTf67c557qNsqMEqSwe4TfPjRkQzMxS6LjvSfijQ4jAIAtMV0LdInxXW840UTlKbj0uIabswXdqD63955xxUDt1++8Fa9LMcTY22aJ0pVxuAuw/uJoUGa8FFtNR9cTtL3hXHx9LK2CeVa4PphMSdDcNi7Ev8dImX3jFUb4XwnmyUHrN/5W8qE3j6FL4zc6dFIQcXi8Ck9awnyGQGKacxPykytygjvqoGjCGnFv5rhHhdgVe6H67xZ6hzraBbZrvt240RfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3lM36TEXzJ87qYfHlPZUjD3YBXKjWHbcF0i0dXdR6ws=;
 b=nY0k8+TWc5UZWTbzPAHHHMmHn/xsAhOnS/yVkMsz7IXvGNr++RZByTVG3pjwAIrz0l2g40IWXoBb3aTp7f1Cn/vQycaBpYznQ2BBUaIqPLKgVRZFHzYP+xZ/JMvB7JFe8Y/JUclHM4kLBEcm6LzjDf9gAke4H0h7HxIeKgrX1yY=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4662.namprd10.prod.outlook.com (2603:10b6:510:38::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Tue, 10 Aug
 2021 03:11:43 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 03:11:43 +0000
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH] mpt3sas: Add io_uring iopoll support
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1im0exacc.fsf@ca-mkp.ca.oracle.com>
References: <20210727081212.2742-1-sreekanth.reddy@broadcom.com>
Date:   Mon, 09 Aug 2021 23:11:40 -0400
In-Reply-To: <20210727081212.2742-1-sreekanth.reddy@broadcom.com> (Sreekanth
        Reddy's message of "Tue, 27 Jul 2021 13:42:12 +0530")
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0008.namprd10.prod.outlook.com
 (2603:10b6:a03:255::13) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BY3PR10CA0008.namprd10.prod.outlook.com (2603:10b6:a03:255::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend Transport; Tue, 10 Aug 2021 03:11:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87139868-de21-4bb0-96b3-08d95bac9444
X-MS-TrafficTypeDiagnostic: PH0PR10MB4662:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB466203032848D023CA0AC2BE8EF79@PH0PR10MB4662.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iEPRrV3owjmG2a5xpof5rwLp9Nv8bglo3OcfBGVt4uAc6auwhTkHmln3V/SVKnfiHKZBiHeSJ3vdaYd5EmWculsKajuJjKNh72P+Vx2dVRugiY6Yd5hYDFtN4IT5yhbq8Mxx1/RSo0N0tII197jjUOQbfHM0FAQdYRNCWO0QW0ag0tiFUkq6AuRA+UoUD9+XDMoeQb1Xrb+YvOhAy9UsTb9/LUCbLPN+hCegjA04gxBs9BVikI1PSfQzpv0aJltOItwbMxeAUKYpdbjBD1N6R/OMQO/CutFcG7PVD5J4fkIEV6giKZPFQGjzJFHyW6SfcQxYPN2mmf1tFrrzfcTy0YSdRFZ4EkUvyzO+DS7976geZJZjfPDUJ3inH6jFx3fimAIB4y1DCuRyPhG3tn2+tYZoU8MsXhIDWLGO6GOma7v+jTO42uIFFayadpF80BxQkuS6Hlzkwcp3GEeN/Uz59POgx630vgyRdtg06J9VFR4Lu/nna5DJo532AjJyWO/DJm8iSpPDRnoQfd/z7//gi/4KfTPPaIafSPbNl0Y0+qfghVxsI2a8U5kw+YJFsuF+dn8STQieUfJzPz+BSDGA3h4sJzSxM47vb5skOqp2meH5tGnwf3YOlSnkFJEXGc6tIFgm/gE0d5WlIyKkRv62790g+D6qYMN4DUjIjrBPOiWAq1Nm3ACT+Nmk2aTpxeMilFnkCIYiJ+1GFnGGCnG/usS/ZGwYNplkV4iYHO8XTzE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(136003)(366004)(346002)(376002)(55016002)(2906002)(956004)(66946007)(38350700002)(38100700002)(4326008)(86362001)(107886003)(8936002)(6916009)(8676002)(7696005)(558084003)(5660300002)(186003)(478600001)(66556008)(66476007)(26005)(36916002)(52116002)(316002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/a5ImhmQPB8INU0k1W67dSTHoWXMLfpKTJbAx8S0NcY2DgyOeHK+3Xh2KRAC?=
 =?us-ascii?Q?9/OIWNzY/dSlC0Oo+G53AlGGvvlRWhWti+11KEDOnEDvjqfo7lToXv5jOMQ9?=
 =?us-ascii?Q?jJx4WP7hh3nel3wq4oCqmT7UI4aFrXccl1OHYbcqpeHOY1V7/S55GzMBObIo?=
 =?us-ascii?Q?0Is6dOQnGXPuFcl00W1wi65BOrT+6J/loHEjs61NKh7PhZzDWyJqS5rwGe44?=
 =?us-ascii?Q?vZaQMnii91a/0YThMO0yia5ZEU0KAPjjKgq/4sCA+Sab92MB7/V4qw/Yqgvi?=
 =?us-ascii?Q?seykcRUNug9/7p/nDD8IH6rbDUT3KLO3QFXu88PbbDbdzdlcpz+ll7KLiW80?=
 =?us-ascii?Q?Ov8U5Rfzk1EVlaJNWu5uamfOZOi+IqtB8CdTAuRLbg9mGsBAtVwc8E/BmkIf?=
 =?us-ascii?Q?GESKt+8lFBVsg+SxrZYWBIo6Ak/b2HnqytFdIBtbDaum8ek/JjkNtawx4Q8T?=
 =?us-ascii?Q?MflGRLkyPVp6wrerkaMv22+eqvCY/dXj1jcrNg8BxZFdm/s/WJtUA+ZSuupV?=
 =?us-ascii?Q?StSZNlx3uu6mVZN+NtrlBDCnsPxWA9Jspoy8hAjxQa9L4eLzt4dt+dLbyG06?=
 =?us-ascii?Q?fD2eMS3C6DVFBs1iQSGG7VDcnRQ7M8PXTA2xH3eblMgDQjGdOUI7j4x6Y70M?=
 =?us-ascii?Q?QuusF319t1zhrXPmO5v9WyQiShOS3B0PEijpbbhplW8hxHJMNdcH5UhwPsGq?=
 =?us-ascii?Q?bhOUhVTuSrxMOKL0gRNqxn9EwHMJ+WenqN8DbeEhzgP9+8tHXow/wm+8IrHn?=
 =?us-ascii?Q?iPUKq4k54Ma6J9QoWXIhlhIMLcBR49XF2qIMkoQl6f/WFgPcVDatglVqET3g?=
 =?us-ascii?Q?Y8ZzWhCW/Xpvb3hhLmHQ+aqNf+1h0DX8K6GSLRQzz/1Gvz9XLyzPLlpDUQMn?=
 =?us-ascii?Q?Jz/TXHLCanFgS3rYcW9Q14AjF9QjXm0UTGIwcUKmRBlIA+uHAJ2/RoJ7cjvL?=
 =?us-ascii?Q?xlpmEVE++Efya6IDXS6NpuCk2LxufjjJHQHAjNhF9z1tzCnRfMqzqLjNn/+a?=
 =?us-ascii?Q?0ahIChQWbhqbt0sL41HgjfRvUmr3lrTTeq2MocU+2vu1N0hT5f6+G6ZSxCUM?=
 =?us-ascii?Q?5qDDFyw2Tn2nSRhosIB96dNaYtSmi8bi1/iF0l1Z14SFiO2W27Zz9dCQ6qpV?=
 =?us-ascii?Q?UQVPKwBPcvOVg4ifMzMTSja29kXVZUkSdIqV/KosRx5808JtFgsxl1BoY/GZ?=
 =?us-ascii?Q?BWaq3Ck1Z20a8EjGZHqMdCe8VPfquryR3wyXyhVegVIf8QjONwmESsG+TzJF?=
 =?us-ascii?Q?g+cEJ565zuMhLmJN1VcI9G+b/UoXb5aE1dl/Nonyd2W1XFImFcRpkT0GKFkE?=
 =?us-ascii?Q?NCUks5THgokxTy2wFfUDjBOH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87139868-de21-4bb0-96b3-08d95bac9444
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 03:11:43.1194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: haqyah9UIiUrOXOxUGNZt2yiXVpiaEUzfUBaLAdM1UquiJ29BxW7473IaFENX+y6EqEBiYFHRZ7I6cprq7FI154r9VXaUyiruMemLVOkl0I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4662
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10071 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=928
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108100019
X-Proofpoint-ORIG-GUID: LOPk0b5KHPqOwaPWVyZD30Q254qzxHIt
X-Proofpoint-GUID: LOPk0b5KHPqOwaPWVyZD30Q254qzxHIt
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> Added support of iouring iopoll interface in driver.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
