Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 432F4C48BE5
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 01:17:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E02A6128C
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 01:17:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbhFWBTe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Jun 2021 21:19:34 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:45366 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229751AbhFWBTd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Jun 2021 21:19:33 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15N1GGZl017647;
        Wed, 23 Jun 2021 01:17:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=GvV9lmAIy36rYy+R5rAmGbC1kZlFF6ooGsin9vXZqbU=;
 b=KnnNZC3B6Lqqv5IfE7KL0J5lK4sq1doXokiCCLZqgnU3VWGESh5Ex/YDcD212x8c0jbF
 AL6p3xFk49hN42R1Wh7h9yFUyr9MEJqA3yIEGIxqb5zNabOBBkDeDCr/wNerOMSjTCVP
 ohse/HjTpCuGVuWTx4xnSwir2KjZxEHnozDKnTxivls/vphXsKSMpCDVIHaQLjd0dUJd
 JPagu7DBUWdVNtcnXXV2sOxyIvjM5/W3DMc/lXy7tRj+NGG6wKI1j6nC/lfEpLXLw/DR
 4HNnCqXAmTPGXcYFMPFHu+JQmdtboOnK2gvbzdlarlyOZxi78KnlJslckqvl+iqyh/PG 4w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39b98vagf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Jun 2021 01:17:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15N1FdZp137234;
        Wed, 23 Jun 2021 01:17:10 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by aserp3030.oracle.com with ESMTP id 3996mec0sk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Jun 2021 01:17:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LDQo1bjlvSsltHEoscD60oOtAfndUauZTtABJEHNIdlZ8ox9jsJhFPASEdzvOxvvkbFFM1oGUNbPS6ezS3xCHefSp8aYfyYB8XxRLH68V1JP+nm4AOo97S0GKt5+oH1BMeJjRORgMxK9el1M7ppfxyntox/UVKzbCW+kU3cNC/CcXgUXnEGXzqah55BA8OicbB5b8cHXzwzCtruHFCrI3YAu11Qj7Fb6UL48+qkH7xO/YMIN2Y11O+FnYqNhjZPkQx0G3ph7Vj0iHHu52F3us1iYH0A1n6YQM6w+jlqkRCO7aLppqU3HdRBkT6SVepcK5R32x0kjFBudJvuwvhWMMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GvV9lmAIy36rYy+R5rAmGbC1kZlFF6ooGsin9vXZqbU=;
 b=YrRdg+s3BZjpTMaKi6MAY1mW20GjvzaCvqSbjuOp/f3RxwH6Wimr08JCJa8aDJSEPeDrECma2lVzezNoV8tm3pOCA8C+xJIdyFPW8G+z9pixNnEpt4bRTPfFjdVsAyxk0wVJ6KYTeCcOVNAKJRg8JgGcrm7K47bkgxRMBNatFcr2fSso/JiaYro2OO7E3VuFO6t7/ZvFIYmXu4iiOMxRAmMBbzzFBVYrMe2nN4p0iqv2QBRCpFUeI5TmAMcZ/daP8JdQJhDByDGPMEvU3eXGQO323CRYNVQbqqufifb5W+8J8O8Cto/hpJZpG0j6Jhjv0Ok6bpC84/5CyT2LwdrwwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GvV9lmAIy36rYy+R5rAmGbC1kZlFF6ooGsin9vXZqbU=;
 b=TwY4T1VF5inltCexJv0+bcZMUPWKB1CNsc4ycpmp5j6FPO/v95fJ00GySmhEosw4GEBo9sqViqXgluMrT84x9fZn4R06ZNx8uMgF9fsIQSrkRO++GXv5i5f6iZO1SP3lrfZfOoX9u4KaT+3GU5sdY+79+e3VRCpz9ug7fBv+sGo=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5450.namprd10.prod.outlook.com (2603:10b6:510:ee::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Wed, 23 Jun
 2021 01:17:08 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.024; Wed, 23 Jun 2021
 01:17:08 +0000
To:     Colin King <colin.king@canonical.com>
Cc:     Hannes Reinecke <hare@suse.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: aic7xxx: Fix unintentional sign extension issue
 on left shift of u8
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v965s7ln.fsf@ca-mkp.ca.oracle.com>
References: <20210621151727.20667-1-colin.king@canonical.com>
Date:   Tue, 22 Jun 2021 21:17:06 -0400
In-Reply-To: <20210621151727.20667-1-colin.king@canonical.com> (Colin King's
        message of "Mon, 21 Jun 2021 16:17:27 +0100")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::15) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR05CA0010.namprd05.prod.outlook.com (2603:10b6:a03:33b::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.7 via Frontend Transport; Wed, 23 Jun 2021 01:17:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f9e0dc0-7b33-41d0-542d-08d935e49eea
X-MS-TrafficTypeDiagnostic: PH0PR10MB5450:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54501FE190CA0EC38467BC2A8E089@PH0PR10MB5450.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rBSzkAygFZpeU/Xb/RroWunWWRJpjAVNMMVt/AjfNk0fgqKku9nIXDkA2dOQbimx1Ifut9bcd5XOkLpLdR5WmltgV2WUeaxA8Yf75An7XB8jcbl05Z1kj2x5xptJF15723sEwwf+8I32mrw1PLIZE/wjy9H/L3hogeAQRHPQKeKXTy16x/zJ7whg64pE9ls3UJmyJjyUUo/zHGH2hP529blGGQd7+44Ns1Bmzh4+d695OTIIOLBnYjWMu/FX5/AxPrYWSlrp+t78SMLUl7Bykya8UQDOFC1hIPcbpYQ8PVDo8UEwouPIQlD36XY4XkJe9APrZ8TG/19CqWkxnUJltdL4zB6ZFG2C0n7Uj8ezvp5qomgnXnyvuvIMFTF4tunEOpO5LH9gtSrIajR4H7Fh5AfQebATXF/Hbit/ciG+BBN50ox+S6Kl7ysCMWrISSKCBVcmBx+FMjskfAdPr0II/C0ctIvf9fNmvX25pAdXYJiMW8VBpxVzyuPx7S1zINgB3WQKMpnaAA3Dw/jFC+dVssgYmZSVtvDgFqVEGwjvk6rJT6kq/pyzocyt2xZqA12otwuEHCpqg6cygcYCbIYcXA7Myuxi2Ua0pwfeLl2hOtAcjkya3TxBNC3xe3wQOK9Y0xgL6r/XPC/nHZmymfiZ5HHmzXsUCjv/mHS5WpV5y/o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(376002)(346002)(136003)(26005)(558084003)(66476007)(5660300002)(2906002)(6916009)(16526019)(8936002)(66946007)(8676002)(66556008)(186003)(55016002)(478600001)(38100700002)(38350700002)(52116002)(956004)(86362001)(7696005)(36916002)(54906003)(316002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vyFYV2Qm1gZ1yHpsOdndnz8i6MKlquEUFeME5TpTE0mUmR4eOvaZCXlbJHBZ?=
 =?us-ascii?Q?jF4+Sb3B9CO88coZPiWPaQimH4p1X2OAE0uQc8w0gM1qpTsJcvDGaHXYj5sM?=
 =?us-ascii?Q?nKH861r9rMKs7wxvJZctbF2xDbA/OvJxniEMMCWx+E8DiMQylT2RbIKb2cWf?=
 =?us-ascii?Q?4RcdoJsgEA6mFjEPxwALv7OKkdep7iZyT+Tk+rhU8ktltNCw9j3u7Km+Pcgn?=
 =?us-ascii?Q?VNP1p7wmvaJodme791smSR9Zv1Vw3PlKbPJDWwWckLuLg46zVmdd+Cm7gEUM?=
 =?us-ascii?Q?tkf1+rXBw/nbCIEtIt/MsN4s18efOUFHj4hozhoCKZY4BIJpTdfr/EvpODF4?=
 =?us-ascii?Q?4znSH+QghuGquSu6PpWzNY5Xg+L0oPf2XiSiC2S2nKmJtJRgbrRzHtRLAtlX?=
 =?us-ascii?Q?/MWhZqBcLtz/f+zI6tOUF6JMn7sPUEPJEJBDn2Yv2UfrouoiEltNOjBEhQjF?=
 =?us-ascii?Q?y1Ntoaw/FYJIsFRq89S4Iu5HfwchHU0rgFaCW1ZqVuoiu4QoZm0vwN0S3SjL?=
 =?us-ascii?Q?+8FDDpkbXPtRfFDq5/oAUl3qoztQ2uc1tgy1RdI9WQ0eyXnvPsvn0S6EkzjM?=
 =?us-ascii?Q?FlvGNibJ8yBsdTKIZHOV5Y3bg9enyj/f1+foyewziHGGa9ILkQue3EzaeMXs?=
 =?us-ascii?Q?+oLfxjE+Q50x5qBFJZxeM15yUrFCTdc5O834DNtomZPN5XWfpLvJPEUgR7OR?=
 =?us-ascii?Q?fihplUamTiHfsh3UUB5ckxf4IWsCusumegAHNkXOrSAWW0fEEVyBMcw8WhPo?=
 =?us-ascii?Q?nTauTnXXeSKG8Eu2yGQcV3CPei3rGT7ptTwdluwzqlZtelgGA6QmDGApLJYO?=
 =?us-ascii?Q?CgqFyetgUkBFq7XmED2dLquAFCBqYYOxYH7S73NxHxzQoS+R1lNSF5tEMEva?=
 =?us-ascii?Q?ZuqnzHq/sbWwWhyEL6cGTQ5BX6GwD5Weu/lqRdDLm2n84i3GW3PIt6LGnbfM?=
 =?us-ascii?Q?/eWa3eT74uJuYsd30OYWu4GLezStqQUKXJaJzi6rdSv2YMRaUDNYhu8ggG+7?=
 =?us-ascii?Q?EStQHQWSNnklCjmXboBvrsrsuY6T2dZ4Acg4CQlCVSAnbwNP36T5bs6lTcz8?=
 =?us-ascii?Q?8MJFceOyX4VfrHBqwLUottQzQUltGE/3XbeGLp4T9kweL6yVY8mjYhuOIfkV?=
 =?us-ascii?Q?Jd/5tiZsUCdiEhqyuDEoqbjPOqcc7tBfqVe5q02H4vTx8ZjCLjZi6Ahv/R7X?=
 =?us-ascii?Q?Hky/60rxvTETHjF5wRLIClQwP+qDyCglR9wgL386b+zOXvBqp/r9fovq0Yrv?=
 =?us-ascii?Q?gByuHLAfO62zjS5M8wUxsrHZStakXh28VpiKixAo0B3fnLPk4N6Ny+wQ3wnw?=
 =?us-ascii?Q?s/q/7PlQrL0RPNDKlv9AIA4W?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f9e0dc0-7b33-41d0-542d-08d935e49eea
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2021 01:17:08.5395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G4OAo+Q8pNi7x7NLEQIjS1x/yazgB588OaQG4vpoPu+Le5ib1GTaH810vfSmkC4/Bp4xwTu9p7xyxzHjop15Wv8w0f69Honl7hv+Roz/V94=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5450
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10023 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106230004
X-Proofpoint-ORIG-GUID: SmF2H3-Nz04OAX1pboUteVK_phkfHUQJ
X-Proofpoint-GUID: SmF2H3-Nz04OAX1pboUteVK_phkfHUQJ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Colin,

> The shifting of the u8 integer returned fom ahc_inb(ahc, port+3) by 24
> bits to the left will be promoted to a 32 bit signed int and then
> sign-extended to a u64.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
