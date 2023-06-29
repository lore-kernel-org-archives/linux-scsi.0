Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2924EB64D7
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jun 2023 01:47:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbjF2Brq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jun 2023 21:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjF2Bro (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2023 21:47:44 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65162693
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2023 18:47:42 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35SKiYlI016681;
        Thu, 29 Jun 2023 01:47:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=37fphaZM1TGyCEA5xNrWQ3NnfbjFvbHCoM3BjvavI34=;
 b=TlVliFwwteGk6u6lySixBGrN0JuzuSwbkSsOMp8/T81SKTJM+rrTmf+GN3gjWnUmZyHD
 RZ2tYLl4tXsH2rbZAtxR/6jZc02obN6CUSINfoHEMfl3tooyVlLVeN8+WsOLHNw5pLaz
 i8BfXR7tubdIEFYC7y5QbYCBejaDlyZAOdd1knQZp1Oo3mUM/07p3PWz5uPUEhQ4Wues
 kFhY5IT+bhXai6dCl3YHHV2NbBAsA2DnBtl0cmuC1+St5+Ngeaxy4d4AdQRmDIG6SEHm
 2YJacf1EdWueIJHvon5zuTsVMGfrnATCcl5uqliy+UCcxwhh7a/Wkac6uePES3bM4x+g pQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rf40e87f3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jun 2023 01:47:36 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35T0MYLl029704;
        Thu, 29 Jun 2023 01:47:35 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rdpx6thwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jun 2023 01:47:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lv3r1Ch+XSMvBJJ/H/0DcG7LRCj6CQd8k/16z21evUJpFk2KXtygeTSGyIrTK00awSsj0/D8JNAuJ9G+zf+TsSeHdS2BSIIeWUJr+sVHUbiNkfJ+EnIMRJzuTPW5duv7GV6srrV0sn5+nj2GXhAA+02e90O29tCUbDe/lenpqFoQGhA7DQX/X2elJQwKQcBiA0fG3VAZbxq4rsh/XD/grv0+9UR4xaUrSe8E7Uwek897KZsOG2yLjMeUp/g5SdqHC/XiG9x91ih9K53/xJjeFI9THNIpSzWZWJjJg7Oef0KUq+wOOQ64TjsODsz2tVOBRny2L7UxTR/dghmD1Xjf2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=37fphaZM1TGyCEA5xNrWQ3NnfbjFvbHCoM3BjvavI34=;
 b=n63juPcJxmoO2nSk6GGMtDV1KlyMrEDOFEtADKZM5t6k3gs9r5WR/ae1zf5TpAoYk+N61RPnZqGzf1wIJCHEdcVYov2rtey/wN2I15kFjvAyXaWidLpgc44tFBxDwM4yrURV7V6dji1nOt/gWjYSpoebOXX+VdWfe+3A0cVXsKxVbHuuUikcEqe87eO/dxlTC74bUekzVumxrRVNNPEW4mUv2K3abbuAFXK7o0eXwQAJhBijiqbJDmBPYJ4/DV8Lzm0O7vThq+l80AJ1WSIk8MaQcaahTW/qwu/gRXHWsRGY44dgAnpmDsmqdoWLwX62mK4Z4bWP7LraCsXYcpbsxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=37fphaZM1TGyCEA5xNrWQ3NnfbjFvbHCoM3BjvavI34=;
 b=Zv0SVSLBCfK22Q3h7wrukQePgTqxDJfQ5I0ktmt03vvwfhR0qFZ6GMhbo73ARR51lxTDDcYfgyYPyyUUrTi/9NMxq62JGdEw5ialcxxWE/qw/YWrH075rV5oNasKhDSVe+4nRmQeB0B8aZIr55hJcsTOdoXUDh8hnA8zYuVYo20=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN0PR10MB5111.namprd10.prod.outlook.com (2603:10b6:408:123::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Thu, 29 Jun
 2023 01:47:28 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b77c:5f48:7b34:39c0]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b77c:5f48:7b34:39c0%7]) with mapi id 15.20.6521.026; Thu, 29 Jun 2023
 01:47:27 +0000
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: Re: [PATCH v2] scsi: Simplify scsi_cdl_check_cmd()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a5wjox98.fsf@ca-mkp.ca.oracle.com>
References: <20230623073057.816199-1-dlemoal@kernel.org>
Date:   Wed, 28 Jun 2023 21:47:24 -0400
In-Reply-To: <20230623073057.816199-1-dlemoal@kernel.org> (Damien Le Moal's
        message of "Fri, 23 Jun 2023 16:30:57 +0900")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0030.namprd08.prod.outlook.com
 (2603:10b6:a03:100::43) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BN0PR10MB5111:EE_
X-MS-Office365-Filtering-Correlation-Id: d17070e6-d822-4cee-a599-08db7842cb21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1/VamXQXv+Nl/CJo1fUqfJCLwOFaU3RhlmJ2JCr0mHgcG7WM4rORuPNY8xrJs2y7LLO1RUZu6+JBRREu/YywbHP4niOcoJPcAMOsIYJ/SW1Lim98bv8g5Q4RLeel7KFhL4muUVJ5W65zfSk4nqzh+BtmJ1HUdOUzF4lREUzgDj7lT4bk8V0gSpy4YhkM0VV009Muwq8BocNcVT49FsXJAZw8Ip8jG90HIV+bxlnR204oqe3K5Hzu7mdLwnbm8tfbKGTG1mJGFeTM+gxk6rR6YF1UYisB4G2b4hzpL6eBrIxZNHPolx/Sr1dm7UiBuOtMt+5NpDveJPXD8IJK/HNL3oZVBAreO80Kh9kHVVGjRSipFdhnd2/7wgb1zhQSf59o3d8mQYlLMDHBQcAxw373nHnUI8274CTv0AqDjkBOtEMtuheF3PZrUNL/hiciUrbgLOR1TY8CPRwFd/leqp9/WKrt2Em2toeASNsmSFEgrWEmJCZle83yZdsN1itjfex3TKkdLl7zB5FiwR6KFNusjE+uWKCqgnZPqjc79hl+5Vmq/u2bgo27qr3Geer7TAcW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(136003)(396003)(39860400002)(366004)(451199021)(6506007)(66556008)(6486002)(478600001)(26005)(54906003)(6666004)(2906002)(4744005)(6512007)(36916002)(186003)(86362001)(316002)(5660300002)(66476007)(66946007)(8676002)(4326008)(6916009)(41300700001)(38100700002)(8936002)(66899021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0r20by0wyC+TKTMph7T667M+RpN9xE3czpC5oc2WOaOagkw3b/aUEA3yl4xQ?=
 =?us-ascii?Q?tn7qtw/UYfbuwjTvqCZyzrrh0HYoIjxyr7RNcnHvolI/oE54X7nOc2P45mjT?=
 =?us-ascii?Q?l8SCpT8PvabOxnM/y3KzLaDgCWG0Sna0Kb4ALEsLUf9cvgh2v7OV6vsQFp4q?=
 =?us-ascii?Q?m7cTmD6/Wvcb/nobDcIJX33KYUD07rGMNh6HNiXJj1oBM0sSyIULIN35jY//?=
 =?us-ascii?Q?eHxiGrHnGVy4IPF6sr+f7tw+wu5BQPKSNJ0zclNLmJEEMwOni99Fqx8U+/Ac?=
 =?us-ascii?Q?xeOArBiU4ls/LQQoS2oJljkhL+H3CGSqOl8pB3FySTTPvF4K2aiuTryhCVi+?=
 =?us-ascii?Q?BcEN5bwh471Ay7wqnVPvL5mPk8uHzckxprNSMfwZyWAyE2ND0AtDqOEepahU?=
 =?us-ascii?Q?pf2MCggEk1M4sN/xJXmdCBgOOu/2bNkmJUKoGtnX+mONMDLQ6XlxS4XMPBjh?=
 =?us-ascii?Q?5AazGOgMzJ0Te/6KHBqlNkTFC25EFCtCkaG6JzFOOGU227fHjxS1dfrXzUqf?=
 =?us-ascii?Q?/5fPIw6V3MvnBFBGfamvjWEh8Z+Vrb1fRsozAAB8lMgDC4eWJYgwhSHxZM7n?=
 =?us-ascii?Q?czcFIsn80oI+frTW85vTxYce5+h9avStC65npvl4kanWr1eEYwiKgbPdGNv+?=
 =?us-ascii?Q?tVL8QAmGVvqERjx4y/jQ9pY33oBtXe5ZQ2LL0qEn8uA+1jmxlMnfVc5cPgSY?=
 =?us-ascii?Q?idTrca0jeqfXmSv0Txd4Oph5yI3UVYMry7TcxjSbZqPZCpjGXdhdoCjMgmdU?=
 =?us-ascii?Q?QJ7NzgHNUtw1O/VYeWyW87oMRbwvC4+KLvdTW8JaRCldNhfXuobTPqJN/G3s?=
 =?us-ascii?Q?Ii0fcQlgYr36vs12rXtuHSHnIUOfXfek35whfmaRekaqdelBloS+/VYGXzfu?=
 =?us-ascii?Q?LxeDPkDU7Sr7rh3bhExPATBFAm/RGforM8c2XEKgo4Qp7Ts9bnpMeuvFdy4T?=
 =?us-ascii?Q?7HbTEbpVfbMQu1/kc7bse6ZZO8nafpduTbjCb+7dpV/IrholCxPRiPmF9PZd?=
 =?us-ascii?Q?ekGCdCKveefYWodXJ2VtidrscWM4P+Xaj3PduzBqX6h08hW71RmPm6D+dOrp?=
 =?us-ascii?Q?ukhzDgz9vFtJkZKQh4pxDCFc4L4urU+QfgrheGirh9bXmdaF1dalNoKfqhnW?=
 =?us-ascii?Q?CLaSYrqe0tnhlfXgyfdAIZvNkRcHsbbcpvaBrubDMFJ+PFsWdSbHJIonB62X?=
 =?us-ascii?Q?Xqui1RDnOY40tBtqBG4kIevX6v/1HFVSIVdHu0cK7XAvTUdN3T54SdJaSFor?=
 =?us-ascii?Q?HoZ0s2m8hD27Lf71+oPF+rNhevMB8Qa2ELyIHyyjAK7IW4o+QZv8n5OF3guy?=
 =?us-ascii?Q?Ti6HOluwKIFQMOnB9PTxXZ6tJCOd5LZwuuqxivChXvSUxxXpebSX5WOI5TZB?=
 =?us-ascii?Q?okhETv69G7R8Az7ruWKhfNKGLvCRp6JzLJQlRLhitjHD93Qhu8zXaO0ba60Y?=
 =?us-ascii?Q?CO4JRq4M7IDs9vKFKgViE1ZEZQVuv+v8iKxxS0EJ+kDnhqrG7IRIDvEyLEFi?=
 =?us-ascii?Q?aWvxSHFtGZtc97rXw+c7sbcJWIKaiip59QuZDJqyPSzDdRTQvNquZ8wi6KMV?=
 =?us-ascii?Q?0EaB2TIG69Z2JK92UDz85aUIK4eTu4Pcs7yi3ALflX/iVn/np/+357A9qoV1?=
 =?us-ascii?Q?UQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: vsm/GSDV+9jftTTJ8q7eb11YG9Sff+u63/P6KRUht67Knr3e5V3TMHDBSOgv6aPjcOt7mspKD0jX7KUodC+R8kJAWOoua13pYi+ltlgZzJkrIa2CCJ095tf/tb0LgVd8DnROt0GIgQm3tOSUDiIGkNhqR/kfvXb8O3bqZRah8QVJ+vB7U9PSvaL8M7vsSiPUSC8lWoVXrsz0aAPbBglHtQB0xmtU2wwUEHR216G5mf6EJvSenlIsK3jmxymmgK89UbVwOwH4owl9+9Diku/3vka7ZoLVoYJALSjr5f14F12WBCDxGDQxMvqgfJhqsl8nvVmZ2nR8IOChptTvcuvaCkFJfmcU6lYMkJyjAI+tMF7ktNadPRXhnsxN2t3VCD9KSbP37aFNIPGVcwNoHBvltys5+fNqsBz1nMEt/Gyr09wmtCYR1xW2VYWO/yt6eXvAs4GyfXZp9srUY7nnuYZ71oGaex1Ktxl3VQUmpwZdgaBkPkdgrR/5EdQ9jiYYYOFGzvfO4WU7UnQGuxn54Uj0S41ygMtIdq3KzyS6sNQYnhFJqdgXweAJhiKrzayhP1wLvxWNHyUdm7Q1oex+RLOtcFQCdhUUXZ8saRqTT3lItOa7zaovdiSbOEnJRsOVGQQwi1qI36myb8UkGvKLTyos14Ddqb7ojkiSjoVBQMBP4i45YmGb7fztkim72e5s03mbL/vjrBPzSUXj8WwwYok8nbOGQv0E+P03JSjyYyaFOsB0Qmg4GpUARMSPx4kFMveG0Iq3Flb4ZpVgO+/H1yJAVtGoVVqBPSE1YdjGd0IXIQjL6Axi7fLalIiu0CNYJz5D
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d17070e6-d822-4cee-a599-08db7842cb21
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2023 01:47:27.5319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZHsM2l82u5y6YHs0qw0qpsOZhYY6B3qfRaQESrdAbqIvIPLCR12eE2YoEZ0H8UmdwAo9UHfhxa/4BoJbqAsvGhCnzDvHvx2W5Hqi0LcvXEw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5111
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-28_14,2023-06-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 adultscore=0 mlxlogscore=639 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306290014
X-Proofpoint-GUID: xSimzNg6j4DefRPzR88UETpByOEP7NDK
X-Proofpoint-ORIG-GUID: xSimzNg6j4DefRPzR88UETpByOEP7NDK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> Reading the 800+ pages of SPC often leads to a brain shutdown and to
> less than ideal code... This resulted in the checks of the rwcdlp and
> cdlp fields in scsi_cdl_check_cmd() to have identical if-else
> branches.

Applied to 6.5/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
