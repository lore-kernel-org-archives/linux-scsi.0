Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64023C47082
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 02:37:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E0C261208
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 02:37:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbhFHCjM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 22:39:12 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:43802 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230237AbhFHCjG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 22:39:06 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1582XYmL021542;
        Tue, 8 Jun 2021 02:37:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=SObvbLdtwUEUEZ0Bm70VkxVZ+i0q4GWj0BQXcKfJGFM=;
 b=NhPhrmziJ9geUvtVKGDqzM0GDsrgDB8hZKpPCHgUbcetBOi5/3ycXBP8+w2T265qQ4gc
 4ZE9ju+Mr/hd30tQM0D3JGImQPpsDD6diiPyAMXor800bhg/iVkATA/Z9LhoJEgSbc9v
 S2BpACe4I/gRTt/TfCDTv6v3vvKA73wnUpILcmq3VfJ0x65ZeTlmUnG+xT0JGzCqCGN6
 SOK5VQak54vrfKDZKh5mN7Mynx0l+GYknTplzjCXzYyjFtit/UNSljKgU+uq3ev+LZ/F
 Ozxd3fQrCWVJcYM4IszqSnEjWzohCJqt9PiIB+zymouQsjba4TYJUFO9VNO82Au764dY rg== 
Received: from oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 391fyr0aug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 02:37:03 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 1582b2nP031053;
        Tue, 8 Jun 2021 02:37:02 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by aserp3030.oracle.com with ESMTP id 38yyaahkg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 02:37:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VfKgkNmebgWZx4vW0aTtV7FJQ6PJPW0XivB3m3Cj2mxw3l5QBxq9eXFG41et5Rr/GYx09oJFy9XW7d39yAcotrMgaWH6+e/10E5aqpqZym5gVy81iX2vKytEYNqQiOF9uwcEUvRz+8fXav0leocSIOTeEIs9n6KiBs1qtbvfjND6W6PtzzQapEocnL7SwN4lxsjR0RvwSQvJs2KzdbozFMpvCAxsqXuvjXsDarflZ3VBBw/bTXYT0qpK1y5NBI/reSJSgSGupKpAz3CmvpW1F+uqKm9RDcgRqnZ1UEVEZ4oBCcm74LbRMGqvHcwqYCCXgkT7lEhGlf/q/73cTxjDzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SObvbLdtwUEUEZ0Bm70VkxVZ+i0q4GWj0BQXcKfJGFM=;
 b=fAGD/M7JrDIaMgydhZXENekT8lVaAW39PuX7QHdrOIRodP0UAejRcsuaya/OPEK5NImDIOlsxyCJNJOgoGT/2kPbUaJleiZUI8lHKh3fEZpkg4NeNVW/ghAAxsCGr7oiewy3FFSxYvI8RqYEJ9YxoQXFK8Ia+VX+tlJE/PPdDJNV8q4kI5gvgie5zuV+ftw3AtQ+2KLJWwSJ5EROEcoS3T7uGO4wDJI+7J9ehhxAoy0F/8x7IEJtIX6BTAeLfzCRBXhLH17exSG6QSYpOFsWuJcQfbVmr99J5J/Bx9y8jOPCAfNFeW691mZy3vT8lk4VnF0/uzAbadRLO8SpVBoNhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SObvbLdtwUEUEZ0Bm70VkxVZ+i0q4GWj0BQXcKfJGFM=;
 b=joDivmPxEGft2neSuRb9GJl3basl91rDl23k6DuTzvC827aPhd7Btd2t2c523ZrzZq4+NQ8UFG1gY9b4R7edg9zIjI3UHqHtpxg1fTKusNC3vznlLaXQ8yJ38XTYS/UqC2bOXqLNCTAsjyXQC5bQJG9Fzn729VQwGQNxNFZM8B4=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (20.182.127.76) by
 PH0PR10MB4789.namprd10.prod.outlook.com (20.182.127.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4195.21; Tue, 8 Jun 2021 02:36:59 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 02:36:59 +0000
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] Several minor changes for UFS
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18s3ljd4x.fsf@ca-mkp.ca.oracle.com>
References: <20210531104308.391842-1-huobean@gmail.com>
Date:   Mon, 07 Jun 2021 22:36:56 -0400
In-Reply-To: <20210531104308.391842-1-huobean@gmail.com> (Bean Huo's message
        of "Mon, 31 May 2021 12:43:04 +0200")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN4PR0601CA0011.namprd06.prod.outlook.com
 (2603:10b6:803:2f::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0601CA0011.namprd06.prod.outlook.com (2603:10b6:803:2f::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23 via Frontend Transport; Tue, 8 Jun 2021 02:36:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50dfc825-d1c4-42e0-3111-08d92a264a54
X-MS-TrafficTypeDiagnostic: PH0PR10MB4789:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47895702F3B74B3826E886AD8E379@PH0PR10MB4789.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T2u1VueAcw8VteegDu6bOrxCh8QQGlGqv6T2TT5sjgnkX8/PxuRfyqOxKCLja/3M0ay4FNNgMqvu0lu7SziVjk2jw7f/2xpQNZ8/KtaAdAHqWsACCBVo5e2v5dqEmNHg6gVjP8aObCN/3SmmwO7EGUuhmmENXZrBjxv2FzvYCiIcScLRP2t6EB9JC7weaeQnasSz23vWe7m2hHXstp3bA33yjzeoD+f450yJrv3LHews0MMKtEMujnEFygR2pA1jTBAE82rRDs7QVTQ/Wb9+LHznpsz1qP9NQDMUWgCR84WrJeAF/ibLH5R6CGZReTUsVHXsF8hRqp7igQLVBRSxfBsqaJfnGjxgFvIugd1i9wIG8yClRyrKpF3q6zjH931QcwbJRnddAqQSgty+0Tf/EFrDoD0Aoxk0PQaAevWsSOeTYS1vQPfFEtioJ/biWVr/sja4E8aBTfH2Rc/vFdVoOVJBRjh+FwZqz7CthcmQnfYJRws6PQluXT33uvLETmfwOBNkwwe7Anp3HAKxMrX8azhcmquX4VQqc+1p8v78H8FMptn+NHw0cC59KqRZ1LVULK5aRlNwwq7YSIlS1Ke6LOZ5xeRRrGJAnoektBO/D/duELtqYE+dEOzk8GEfxa2hoZp7EGh56QCYzM6wj0cTHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(136003)(376002)(346002)(52116002)(956004)(26005)(16526019)(186003)(36916002)(6916009)(7696005)(4326008)(2906002)(6666004)(316002)(38100700002)(38350700002)(5660300002)(66946007)(7416002)(66556008)(66476007)(86362001)(55016002)(8676002)(558084003)(8936002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CQjchChcrTmiOiA/nYpuS7/F99oSuNAI517uvM4vT/N5rRSzMkcBVJKFUeIc?=
 =?us-ascii?Q?IfesVsIySh5x7lygwrDhYTIV/qpYMm4GcnRo4QSZJdMJfP2VpJGE+pVDYaCD?=
 =?us-ascii?Q?M32Xfl/GLaQg3ECW99ZxfBeK/dNDWTWTpLb9oVcLKXHzlZy8A99jAHYmjqCc?=
 =?us-ascii?Q?0uQk5oYJpYqrIdlmdKaghhEqbYXRnxv4x7sBeMLIEeBQmC4X6KC3sqFsqMkT?=
 =?us-ascii?Q?nrkPF/kS9B6o/wM4pFuPLnJkUy2WOcQHmMc0aMXkjxxfsak0U6uBGV3uwExL?=
 =?us-ascii?Q?eSPAqFf0zk9lxQff69GO5ScMlST6fsPzHW/XXyuzHbcp+4XRuI/VkkOgsn+P?=
 =?us-ascii?Q?l+jX/oPyg8i+rO7efWwphIPdXvfK2eCJMDuSBL6WQawgLqNv+2cvEzVC8LlI?=
 =?us-ascii?Q?pXVBxzDqGDYtKjizGlsetzB8wCS3vaL7GbrvwppZWmlk8VR490D7i93hLlRl?=
 =?us-ascii?Q?Jvd9XLrGMhYN33Gtmy1Ie/e6EHLB/ULXgD863qEs419FQtCcLY3DthOnSUHo?=
 =?us-ascii?Q?HGBPISyNvmNKrWFgx5B3v+7ZZy+HKfrMxT1H+aNktZjLeBlwlU5J6L30cPCh?=
 =?us-ascii?Q?N7fNEbqOMBokQG6GQR9eDzrLvrxnhk4Ldss9HytQeDkAoibALuJRoqtOk/8f?=
 =?us-ascii?Q?//jHwEh67Lyg0C44Bp8qTOBHU8ku/MiaFI29iOzkGiDaAdI7eiV/8akdqIMF?=
 =?us-ascii?Q?gaZLN2TMBiNjRDobB6532fhEtRmSFGv17UaMudot5fwDHMIjSkeUrUzahdgw?=
 =?us-ascii?Q?o8bZgPh0KAVI3izCUS+KUzltgF75Oe2polPtVkDFf9tcazYt/YQm3KuVPFhJ?=
 =?us-ascii?Q?VKCY44jNM6gz+e293vod0JgBCE4kCLIhCawa5cQeB+Jc1qTn2rz2PP7JL0W/?=
 =?us-ascii?Q?eb69eCD23Ybe3EeFI22HHB4liajm2TCV9APcrLR+vQjXG4Pnl6qqt7mKO1H8?=
 =?us-ascii?Q?v8x3PLX+6K5Fg1/AmzFzbdDiyqm+ZDYfc0A/qeQt+3qfPXm458bqj0RqE6EP?=
 =?us-ascii?Q?5/wXKSUibAqKQUus9lDG8/cg866T9H+zhP8Xo+elzdpMsAx/6cyjLuNEd1ao?=
 =?us-ascii?Q?ybptr9M47axl4ZaV9pyPbjj79FGuO/iAamItRbFXwE9U/q8w+QtxYOcahITl?=
 =?us-ascii?Q?VNx2CAu/FhNhv9TpEVU9nrutBYUgqufK6tGjZzqJ+K/zwNBG/FLjBrrIR8DS?=
 =?us-ascii?Q?bMiopZGW16hh4Ox2B2J/gP+5FyrMGhsxtzxmy7i0rjs8jN4CbOnQFg7lUEHG?=
 =?us-ascii?Q?4hsryq6XBt6kiqOU7jRnRlDCA+YwyRl/C9Q4bR+w7Ccs+x6pgbQ8qPUAP7b0?=
 =?us-ascii?Q?RihofA+5gdmzHZrma8Hs0WYo?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50dfc825-d1c4-42e0-3111-08d92a264a54
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 02:36:59.5414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rv+1HAvnNOq584JQG7BhS3TBQohNvrBhS0IofNYYUlnwt7jhNLkokKanw/FbHKWydKeIX7smO3X3RCsi5CamYTSMDJPy7JLPbFA5EvXPLiE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4789
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=930 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106080014
X-Proofpoint-ORIG-GUID: vo0sQsUJvBt6qtzKD9YrBj1pZd4QpBCK
X-Proofpoint-GUID: vo0sQsUJvBt6qtzKD9YrBj1pZd4QpBCK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bean,

>     1. Add a new cleanup patch 1/4 2. Make the patch 3/4 much readable
>     by initializing a variable 'header'.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
