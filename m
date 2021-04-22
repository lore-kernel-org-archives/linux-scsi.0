Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11E24C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 03:00:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC02A61428
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 03:00:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233909AbhDVDAu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 23:00:50 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:50406 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbhDVDAr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 23:00:47 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13M2xqJh077589;
        Thu, 22 Apr 2021 02:59:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=90oBTfgYd2ZGPiWdIO/Mlcf/qcmvpdBhPBYyhsnM0wk=;
 b=LT2K+lCl60/4EK2yuMeUY/wITuThu35ozqKW2wch9AW9tIeWlEthkwlkihDre1gh7/F9
 X2AUN23uz43M1wt72crwMZU5KpTPKWZav5zy+kfCmIV3kx4h9a8wOoiFD8XHnmqzE6Tr
 yPgY+vb6K/Mge6MZg0Xvn7HsXBufG8g3u+5kHWIh9d5oZ6z+dRJO4xY0AF25pC7iyacn
 bleewvPFGT+R1QQ5WAf6IBOwhOwirS7JyLAIwQMlrypYQvUOTyW80mFa87IMnNe0P4+9
 rTsIlXRFofhbb9vpTF9m8M1cTdjre6nIbgW75CYAygQjzIxI4YEQrI+QNE+d/nmhxEww rw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 37yn6cc2h7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 02:59:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13M2owjj122743;
        Thu, 22 Apr 2021 02:59:46 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by aserp3030.oracle.com with ESMTP id 383005s8rp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 02:59:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HY+Bm3tgIvkei3LktxBNNM89UOLioZyF/6rWamAmj+OJ0Iv7SWZlZp46CrhzxCTL0oCa5TMTxldf1Hj4PoNXGZRkX2EThmoLrnLjoOMPS89+nHZArch7tR2kxNsoqLYHmsWXfUSUZnri5I4LoJK/bGQ9CmEaOfx+krCbbnId4y2/5tHEy3X5ep5h6XtdZ+Q/RgL8dFg1VE71xIvbSdTtcIN4JOIYQX2X9REf4qoZktMf5P2hgIfWypKYLfo81URHqUr4Eo1D2yqvEFbagM8LEh96wtBywKBIs05NAlFTeBOerbSZoacTx4V7g7Gvg74kHr4m77ww7l3KUcAUQ2aMPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=90oBTfgYd2ZGPiWdIO/Mlcf/qcmvpdBhPBYyhsnM0wk=;
 b=WgGNI7DV7nU7+cDoOt1XgLisvKeOQFzhdOFnwboYxsZ35V+rLPsw199H0NIZQcijBkE0bF/3G3Ucq2iAnwMje37HW+70usQPUT4r4TCgiLzT4VW1wCQUyzD3HQk8RmfxWEKlK62JemSidNQD8BtaoqcOmSJNM1FUP9WM8WLuhE8THtlZ87pjEwQccc/dH69CW0Sn20oid/SoVJKUBSaefoIz2ubXbSyKxAyLt1d2IFvS3UNkaVYqGchCQkESP2dHA++E5WiRiuo++RemCPeCOWOqsS3ZXGsTsGUA6CPQslSAuAyk+itIXl8SfP0yAWVpK+TVHbGSRJNUuaniPWrMfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=90oBTfgYd2ZGPiWdIO/Mlcf/qcmvpdBhPBYyhsnM0wk=;
 b=SYqiv0KLJou1IjX9NQN21JXimqP3cr3/sZzO4rtIHGog8qIaeOxiW6tDyeeiuA2PjKzBPGGLvpuuN1fLWzNi1A1kOG4kLx65HmlK2R83ktd5tKf8ON+QL0UP9rlp7RSOErGnBTw9vwOOUmWGTq2qjr9FLjHlcO1OqIw9uOTR/Xc=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4407.namprd10.prod.outlook.com (2603:10b6:510:31::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Thu, 22 Apr
 2021 02:59:44 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4042.024; Thu, 22 Apr 2021
 02:59:44 +0000
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] blk-mq: fix build warning when making htmldocs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1eef3t46s.fsf@ca-mkp.ca.oracle.com>
References: <20210421154526.1954174-1-ming.lei@redhat.com>
Date:   Wed, 21 Apr 2021 22:59:42 -0400
In-Reply-To: <20210421154526.1954174-1-ming.lei@redhat.com> (Ming Lei's
        message of "Wed, 21 Apr 2021 23:45:26 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR05CA0180.namprd05.prod.outlook.com
 (2603:10b6:a03:339::35) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR05CA0180.namprd05.prod.outlook.com (2603:10b6:a03:339::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.15 via Frontend Transport; Thu, 22 Apr 2021 02:59:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da2a7e10-6e83-4992-4360-08d9053aaec0
X-MS-TrafficTypeDiagnostic: PH0PR10MB4407:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB440714CCF10AD07623C8A25A8E469@PH0PR10MB4407.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kGWxUZ6RKCk2BaRF6P2ucMox5eEoFnZckFvwYLxzxp0ktJ0JNYJHLfXtYjX0cyInaSNOY4iDPffNTVyJvg00G4Y5cgZKwjbVPrQpo8PGUb4bkfjhBfoDAIEtK2XpOw+RMEbhU3TgXEZIYyPRa/AesCi2XFDueRtH+P/RqALWis/KwiO6/TKoWxv+0Kzxpja/N4hZ0bDT2bkWcagTg91vJOO+/uQrvRlQscpY5m3CR72t6SnfYcgLEbM4/IPw2gByxWNmBXk94qh5FvH25AiY2pEJf0skBk69pMFyGm0uvKEX2nhdel159fTDqV6Sq5wcn7tODdB7FuobqQS4xTbmfT5WpEuVnyUEMNUPddkjH9l0VndOePuljJT3VbdN1X6ytj6/7vRlQOpVYAylOS9db2E+zC3oUk5opUeLcAPEjZW93c2U4lpIjFt0pNr5PwaAQ1/6YznRnzpHfeq0OPabSCGml+JVqdUp8fXisj8gINUxbgIQ5QCD8sgsSuvdDdofMibhCr6yu2u+BdWrMJG6bFkLXOFwsqujsA4gite7nfHQ9h3JRxx/QfDHmW0S3oMFfNpF9bLc+Ho1GhTqFBDmEmNvwbSHAlaNblkHPVpU1ABGZPDdFVJqcL99aQ8ocoALwBz7MrF0hoMwfX1VLkO2RhmgGuYHEdV7u0EQb19HAWM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(396003)(366004)(376002)(136003)(8936002)(956004)(6916009)(26005)(54906003)(36916002)(558084003)(38350700002)(8676002)(5660300002)(316002)(83380400001)(38100700002)(66476007)(2906002)(66556008)(4326008)(52116002)(7696005)(55016002)(478600001)(66946007)(16526019)(86362001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?vA9G9z67T5ooaP9ZrLrnaZEOmet7d33XDC017WPHek7ihExgSWfU5T+Tx+lI?=
 =?us-ascii?Q?Tx/QrK+HW4ueQ5MxglhKNo6REBKG/QRX9RUx6+W6UQBjUI5WqS7uGPypUEmZ?=
 =?us-ascii?Q?PPEXMfJ7VcMV1EXyKUgvgapfMPQvzGOkpwaeaZ8K2B+4Kkup22I5VQyxgofj?=
 =?us-ascii?Q?eI8/k43p5JdU8GU5klvvleMtpJWxQixmxoSY671gLmIRbDI6Q/LSe3YNxf+C?=
 =?us-ascii?Q?mOR79mwYAGealHqD2tAVkbxvsqr5z3unicfTTH2GMcnL336+VzWK23odSbOu?=
 =?us-ascii?Q?S2ryRbloVyO5Wu5zJpjPGtS0Ko7zn63I3pHV4zEsZ9eiY0sNqmseCmqFueQN?=
 =?us-ascii?Q?IaeZaqVurcvYTvX4XNzrUXh29a12aSLBa4MCTaR2gHtfoqS/ERXbJ8u7/1GH?=
 =?us-ascii?Q?cKZ9k2VbW4KnBeU+Bo0lYI0NJjqk8sKsxLrKzsH5O6y6p5rcfVB8vUpCR/F6?=
 =?us-ascii?Q?TXzzlCcROHUs+DgUjaNehR93OBTAnjCQUN/BwFi5Tv04t/mp83JFyfffGS2U?=
 =?us-ascii?Q?EyB47IpdGCf2+UcAeSUVyUivjDKOSqfSiZ08DIa9BXLDzqHFE4N7a4oFaTu8?=
 =?us-ascii?Q?U9foOHiJGZ5Jg6mGbcEnsRfJVeVIr7jPXb9u5ZUyytjjrB6u65rCqSmE7XB6?=
 =?us-ascii?Q?KM4xA+3RcOIgk0ldx0khj1vvSTEY6PBaetIxSG3hAi2OdxW8qvTFEQbmPC3o?=
 =?us-ascii?Q?dI2M+UbRYlsrRT99EGSLH3IbyU5gPE/1IevX7nFoOQu0DIDarxVHiBN9Rrpx?=
 =?us-ascii?Q?2LDW4iSzrYAyV3dpX33jF/t7fJ9YCAVKFTsH8rfXl+qIo8nprutNCk50k3Gm?=
 =?us-ascii?Q?aoRlwglwo0qZXgnN/pyUrx/lI/IbbI6rNi1oL0otuOEGCSW7LV/f1bjgVd5x?=
 =?us-ascii?Q?Jwcq0nItV39KPBE2jbPhwgvUbYz94lMjLZbqcxwmreEpar0pHqG7Z4bjbLib?=
 =?us-ascii?Q?1yM+iI18H+Lu6bvmDJ3LMGMn/aBtGLo4xDMwVRIroINWiNJKYzD2u3cCDBY7?=
 =?us-ascii?Q?Mnw1rG2dOsTOSzrsbwEh+jBr24q1HnwkNQnSwcYU0bk80FWQzkA2gXmMVDVz?=
 =?us-ascii?Q?pcVonusBxyw05ASLCebYEY8iFSALNtMmlwbHciv6xQCP9EMRfEc1M/2mGVl9?=
 =?us-ascii?Q?EmKouazj7TUfpEJgOS/ONnbqVKWtnjlN3it2LQoqonP0p8Ylo1NSJqxzSb1R?=
 =?us-ascii?Q?Z6mCW5XxHM0XGqPIW7JWbDYKPo+OG4jEasRwsofjxWxQOj7c9B8KBRvSIWEH?=
 =?us-ascii?Q?nS0bTpuUNfQ+X0vI5cwtcSzTpa9bU7hBzIdznFZGksEzqmHXD3tQX1hGfI7+?=
 =?us-ascii?Q?6p/vmNLr/cplVwwI/HvHzhsQ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da2a7e10-6e83-4992-4360-08d9053aaec0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 02:59:44.8530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7UmxVXkhR255Gx7wGlKNDUy1j7+MN4MygkiaVCuyIhQiJR1fQC9W9AZ1+RC8AW28qvURPsMluKdILhth7Y9b5vqjEX6mToP43RTIl9z/yNk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4407
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=949 bulkscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104220024
X-Proofpoint-GUID: 09KJ9O2ehP8IJSEXMXtS82v3zebZidCM
X-Proofpoint-ORIG-GUID: 09KJ9O2ehP8IJSEXMXtS82v3zebZidCM
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 bulkscore=0 suspectscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220025
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ming,

> Fixes the following warning when running 'make htmldocs'.

Added missing warning messages and applied to 5.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
