Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF8A3C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 04:54:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236815AbiCBEzj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Mar 2022 23:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233841AbiCBEzh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2022 23:55:37 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26DBB12E0
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 20:54:53 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2222m9hm014692;
        Wed, 2 Mar 2022 04:54:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=LXIHorUP+PqBlxQt+Xnojq96D3Oy0GK+Li75lC3iF5I=;
 b=j+RtZkJtO89SLlamCA/Ig+PjTZzx9Sxoqwm4z+gBbZnb+t9AXBOlfw9BrTdVAOCZs1rm
 PP7SX60X/vnVy/hhi7yOiAdqbJ0KlOG/a6XmUBGxU2vbIw2Uu7gaV0L0MGXR6+J9+DBI
 QIrfeiQPlMUtN7ay80CDp9q5zXGFeIIJYX+3NGHmiJfxOOeprQAHwi/t3nLi6JOEv9Lq
 90UDUBfJe+BOjy740J09YF20+38sosnGUjEPbbzjYKOm1M1Vq2jDmX9W8DBZZ743ePIn
 D7XWFuNZ0uzCOBhOCCfJCr9+CnqZkneC4hdTco1Q5ODRKRtk/i5RobQzsynp4vOU6277 7w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh15amndb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 04:54:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2224m1wK134444;
        Wed, 2 Mar 2022 04:54:43 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by userp3030.oracle.com with ESMTP id 3ef9ayws5q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 04:54:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZZ60G4qeSS86ZRmrRdRfAkqB/+b8cRjhYQ1S/kVyWZSEHtE6wTJF8P4pdiFDB2UHvfdUx65+TV8rqBcmkzGYgmdNPqExNLCZWXhVwQcSu/hkGRjet24w4oXhoa1kRU/7NgdjEfN5t9Ui8SsKrK4jcHu872RpStGd/1m5leoXnSY/iV3wVSMqZKK8Nm2r/zbILWihvWGWdVIkd+5WhgMPAON1N1MMepKhJH7eVGo4+NWhbHxOQIUp2oko8b5nRO5v0gYYzLSisG69CdT55FWaE7eIKKtrC/M6aS2iKd1gwlBKZQkyYOrSYRMvLGzZzCyOwcQT8Dt5S4/OXJKR2sn8Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LXIHorUP+PqBlxQt+Xnojq96D3Oy0GK+Li75lC3iF5I=;
 b=KN8fTdgpWaAuaGoNl6K9SJOYHkEMHOvRDwnOTfeqSGOqpkU22t/GQeN/B6o6KLwRuKvaOPFdVrPRbkvKDkXcY/0vRVESWt9Bi1ivsipAcgVE2dZfex1aJWz9va1Texj8wzqt8CMxWy92tF1LI9P7y5X5sIV0zpRifZWne9ybv78FhplNe3K8eksTQ8foAsKKWInyCOogc7ndRG/N0KtcnZorGZmkHj/BKzNaurtrP3EsQHkyYoSuvXi5JX/A6g9F9qigqRHHKYEYinvCw9+HbJZSn/MZe+gQexxKtyi51+17zEfLOH0FpRnGXZoQQsy3sSi3k3P+ULxf75Ybf8LZHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LXIHorUP+PqBlxQt+Xnojq96D3Oy0GK+Li75lC3iF5I=;
 b=k8vxPe69lPzWobA5OpxF40r1Tcw57Jrnf8lQaiY6FqIWf30Io1izn5Xo3f8QQcSgoEcjs4BpHGp0aK4sK4gNwYxK96HKUOUbCgawCN1RZ78fOx//A9mKEKO8NYXjHV7ivLDa09hTjrs5cLVUe8U1w40SchyguwSqPgUEOyaqkEo=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN7PR10MB2707.namprd10.prod.outlook.com (2603:10b6:406:c9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 2 Mar
 2022 04:54:39 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::180:b394:7d46:e1c0]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::180:b394:7d46:e1c0%8]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 04:54:39 +0000
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V4 0/2] scsi: ufs: Fix runtime PM messages never-ending
 cycle
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h78hymxb.fsf@ca-mkp.ca.oracle.com>
References: <20220228113652.970857-1-adrian.hunter@intel.com>
Date:   Tue, 01 Mar 2022 23:54:36 -0500
In-Reply-To: <20220228113652.970857-1-adrian.hunter@intel.com> (Adrian
        Hunter's message of "Mon, 28 Feb 2022 13:36:50 +0200")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0067.namprd03.prod.outlook.com
 (2603:10b6:5:100::44) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c55e469-c105-48fc-95e5-08d9fc08c226
X-MS-TrafficTypeDiagnostic: BN7PR10MB2707:EE_
X-Microsoft-Antispam-PRVS: <BN7PR10MB270787F782198078DD9119948E039@BN7PR10MB2707.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JQVsmTnPRVjBVMxGWINvlf7DigOOOF3vK4MQI2pd0R4Z2B/qIQ3MwkoC7klpaeKXphGgAcZfJb7MDVqAls2y1iJibXA1D+W6ToG/2fbOtbmIzqOAsk977mCG//IqTNscDlORUA0T7/PEyTnprd9AkFiPD/m6kZDbQk633IYYIleAxewyu3N06RAzb9aZeuEJwUQtrm/xi0PxgRcQy6CpTUyeNO4rhrnDwR13kXMFT+nq/XfXirNtAVAvpG8B+8SlSkE4jmO7LmWrcgdtSvp7g4dPcW3s0t9OgRcSfgTJUIRugt1++afBQ2IIl8sTrFtiysvBkEHCqPOi7dwG5lx33iEr6TeoQHnJOrvQ0LXKG4RJyNQoIK6My3E3iQlzPRllHVZriklstDkvH2vct2mIDr3+m70GZUe25+qSQixZ+RO/B/lg9zkAouz3FoVrD66wed3116Y4wcEsi5czfnImzVobPOZxtL9A2Jou8fYf5KvixU6Z/6sX7zLVkSvy7QzLJldM6p2qEUDmZMDKBFzX4EwF33MBiA3BNRLsKlDV7QRAf/Sez9Pf+8inLfRRTMIi+w8EF28byZ7ca6tF98jodtezMm0gj+nZZHu2aiudDcmf8rEit95zWgAFRLdsDllSlllEYcln3enzCkjZl9sn9udX1uozk2XBNPpLI+nk1bSRvkVSFCTqzabZfjqfuaknbLvdSJ6v9RPaUH3iyu/QHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6916009)(26005)(186003)(316002)(15650500001)(54906003)(2906002)(4744005)(6666004)(83380400001)(52116002)(36916002)(6506007)(8936002)(508600001)(5660300002)(38350700002)(38100700002)(8676002)(4326008)(66476007)(66946007)(66556008)(86362001)(6486002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MpmLxZWTjG97aNAJ9uTgqS4F5HZvGEzdAvWD1w3Pr3q5ANj2wCPr2jw6PlTW?=
 =?us-ascii?Q?tvsfej0alHQjj5axZUwBgit3eJrsdd8cVOkYLdKE8BYGgsf6+x/e3E//8eLT?=
 =?us-ascii?Q?pQuNreUiwLxMC3ldg54XgqYKqCtKf7oHTUytuUh7vFuKbkL1dauHnyrcwj6B?=
 =?us-ascii?Q?OGLaJ2TS5UFbukXxlG63W5JFM+fCXZ3u/EivCqV1eaE8zEFfZsoJ3DIQvW/F?=
 =?us-ascii?Q?PZTRzzha4t+XVv2J2CWWnCAZF46fmXMDIEE1901z5Y6JLFXZhtvymPpW+8xy?=
 =?us-ascii?Q?+fJmaU9/zcvdvkHkBqIDZjcaJ5sACXc56b+HVo0wEu13k8qZrI13QRVw84N0?=
 =?us-ascii?Q?SGsCqH9BdGTlPW+lW8KBfN/fOuPJbTS4LqBKkLzVbr0rKVcThmBGJ8J7Fnt6?=
 =?us-ascii?Q?zkJhZfCB24jmXzQ21FADH/wys3voPRAeeRVMfP2Pa75IjdxEdQtp1D6LFzuQ?=
 =?us-ascii?Q?zI4C68QJ+LpNI/VM0rbt2Rdbv8eoSa8gduR3HqVfIwhhhVBVrvxL/W6spWHh?=
 =?us-ascii?Q?J5EkieGwFx9gdemV1algOvPVTjzy4cJcGkUiSI1rJGx+FfRjVbpE8ssMTRMc?=
 =?us-ascii?Q?Xb42JhJWj8/KQVBhT2r7IonmeMsC1xetngAyjSXB2JeKea9umHTogsACT9/O?=
 =?us-ascii?Q?0ktYYM5ESKGetpZ/l5wLarzo/J2wWMv9w6yDF9MQ2DKWtL41PJS7inwFMsqO?=
 =?us-ascii?Q?4LIWqwkHZncD1PMYGKYH5lYPAZ+X4fRgkxzPtdzej49CdAszTrajxWeVXxIb?=
 =?us-ascii?Q?kK+brIZ4M4pjoByWSfdpc4D8tzNN6OrHZY1BPkM5NPPbmQDdAFbUlzo6NKej?=
 =?us-ascii?Q?mqjOnsbkjvhMz1jLqGCpWqK5TasrVcujW2XbjnRuxJZ9KkL7IKFnh9bq5ANW?=
 =?us-ascii?Q?Q8e4DSm+ZSevCtYEkA2zMUH/K8KPhpvc73aUVGyHPj95JR8wvgQvr9v5Dw51?=
 =?us-ascii?Q?XgBBL0cn59B0NBcn9Da3PpKGCJrr6l/xh9MZbvbE2NZA8xufpsI9cKLWH+lV?=
 =?us-ascii?Q?Mb1knpsIPbCdNWIGCn3YXvCUW4tWfX06gRXXbFQfyUyqwKw/hULTd3ymw9Kq?=
 =?us-ascii?Q?iktuJhLwZ3GtXaSl0v+qFanJZpBOI6EhD2wrqPFgXKvDzPAt/6Vv2T6xYTT4?=
 =?us-ascii?Q?e8Tgt7XlGKqJXtqjpaR85pHXbdu1vAJ/3UI2ZoU6dAowSuvNsjgrXruac+iO?=
 =?us-ascii?Q?hvmB8QFsh6VUOezbXx2Cj19cANwApFNmUpDT1mK4lS4x9uAOhfs79WLxhMkL?=
 =?us-ascii?Q?ANfbTw3VLh4MCzm/kh6dCIwYcSuQzayp8fbSEzSCJrdXp9kGiiuBXi1NDHXm?=
 =?us-ascii?Q?FR83OFMmR1PpUIvBQKw3WBAnBhVQZs5ikkbv4tabWiQwNBz2mJmty/UUmzLa?=
 =?us-ascii?Q?NTvK5MAnoQ0PjaA+KQPUFeZjfy768IlKJK3Wl/OdEVjRqp8ys1mffT6qAm05?=
 =?us-ascii?Q?6pwQ9fhR0OpGQ/bemWiW/P2/wSeBk7t8IqnihMIAeJf+PZpx+ndJ8x2188+/?=
 =?us-ascii?Q?oOoWrGmggHSglAka4ovD6j58Ml4gFw+kUebcGL+/quIFj54zCacdmvPkPwsk?=
 =?us-ascii?Q?s5wGML995UUNKkaWhwphubZQGh2zU+RfIS50rzPTaAVA8FBlwo74aGOu23RY?=
 =?us-ascii?Q?VC2dCMV8bJvMVTfmaxT8el9kRbWmRbKzfBMUpp77mhJvzsw1HHZ+w4uOes6k?=
 =?us-ascii?Q?p8VOsw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c55e469-c105-48fc-95e5-08d9fc08c226
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 04:54:39.7819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NMnL5ObJBfroFH2Ni4b9ixQHMUD0aMc+ozxf866YblToBxCFRzGOxt6N6ZiZ300yY0YviQv4sEtOrUNFQ8bp2RmMHqN/DoqybH2JL3Iyo8k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2707
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10273 signatures=685966
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=888
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203020020
X-Proofpoint-ORIG-GUID: oJPEly96v5it6alHKyozeofxxiG4yjBV
X-Proofpoint-GUID: oJPEly96v5it6alHKyozeofxxiG4yjBV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Adrian,

> Kernel messages produced during runtime PM can cause a never-ending
> cycle because user space utilities (e.g. journald or rsyslog) write
> the messages back to storage, causing runtime resume, more messages,
> and so on.
>
> Messages that tell of things that are expected to happen, are arguably
> unnecessary, so make changes to suppress them for the UFS driver.

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
