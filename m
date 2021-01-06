Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4688C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 03:00:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62423223DB
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 03:00:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725808AbhAFDAG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jan 2021 22:00:06 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:47436 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbhAFDAG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2021 22:00:06 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1062oRX8017997;
        Wed, 6 Jan 2021 02:59:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=lnDikqmOfHBsnxcAhVpGfPm0A1J34mVCGzfxTDzz6G4=;
 b=cRa01ndoZBFjjnzuOgIYr8lhCWu2A0VWg3U1U9SztJ2URSq+2V0YmWc68B6jcUP9oju9
 yYqFJ10IVcAfx5Usg1sWMQQ2VZWsO0mBGDa3nTaqzS9NyjQNyW1HBbz75i0KJhIRS6Z6
 5cewxgRB2Wbl3tc9g+wtXtTpn3mMHnuwElFZmCP1Qsfx3l9ZUxphlOPyTk0wmmH72PPr
 berrixzwwikmg/nSt4LNjU38IkQXOn50me1F4yr6L78euf1vs4zUb26xEQRPHFXtLDB2
 xuDwur/eRxehNZDtx0glX4h71A92QhQ2kqlAYKyBFqIOAqGwLoMkfFsnko09PSN2ekOW SQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 35tg8r3k9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 06 Jan 2021 02:59:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1062lLtt116431;
        Wed, 6 Jan 2021 02:47:39 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2056.outbound.protection.outlook.com [104.47.36.56])
        by userp3020.oracle.com with ESMTP id 35w3qrafhx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jan 2021 02:47:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=keIHFLclIKmVrpLlAYLApyD8u7ZNONdnKBQFCQJprkf1AAWbZfnXDwnBjm9Gbp4bLuTw6hTtN/2aXdbeuofkwgXEM0WcgrWhveG5gl3wX/B4v+eNulSYNF+G3NGp/KW8/I8rVCDoKGAGFDP++Sys94NhdmGyqNHZoikcCTiWxYuqxmUpp1mLbuhQ3hzOn+jUp0zSDl/ej3WtcWZ+9kZEJ0cvNYOXuM43bK9c9xw4Tn4FvNyvOx+wL02qzkjZhMMvPD0aBx2pWCAzcBAJpHOj8EuTua9G0MV7PEMruUdc1YAQQpYM3+jKVzpyChKuxAgQvPUvm0wWEb2/gEg3URTEmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lnDikqmOfHBsnxcAhVpGfPm0A1J34mVCGzfxTDzz6G4=;
 b=IOvmRF3jNSgXAQgcszwbaLhog6b/zcFLAONM72jSG0ovhBDXVX0s9457Y22TTVY3l3cwyUp0zAbKlFcI3oD6XBCfccn3b2qjr54rUhNpxMD9XQVeiGG3/H6dsNCakCtI7q1M6f7544Vz22KnRqjyFU5s/xnTqlsDCYpTblrV9ZI2/iY1BEQ64Ce+avVjHATcaAh1BnRZW6k6tVDSZuJ7V/nSr4HVJh/GYu+O20JPWwfOT5GeaVjGSs/K7zem6jxHhCd9DZq7LKtoWFfJwmgtkHqzZgrgzKr0D6+xyC7QTcSS1jtMSTu3l4Vm1LJQc6u1wGD9eIkHhqk1G/UJ3yR2Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lnDikqmOfHBsnxcAhVpGfPm0A1J34mVCGzfxTDzz6G4=;
 b=IDPCNjiqE5bzgXsUIwxk+A/r2E6k1HKWkyMEghPBXhWEjhl1y2AIY/qWwceNJna250Gm7Olht6bcU1JUZ3gFj0Fve9oS+C0lFAqvssnU0InNDqSv8l//Afx+fD1rBqtEkIqjQMr7/Y9WTG59y4ugFR1aOK/IItM51Kc1J2PaIPY=
Authentication-Results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4711.namprd10.prod.outlook.com (2603:10b6:510:3c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Wed, 6 Jan
 2021 02:47:10 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3742.006; Wed, 6 Jan 2021
 02:47:10 +0000
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, <jiajie.hao@mediatek.com>,
        <alice.chao@mediatek.com>
Subject: Re: [PATCH v2 0/4] scsi: ufs: Cleanup and refactor clock scaling
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1czyig4vn.fsf@ca-mkp.ca.oracle.com>
References: <20201216131639.4128-1-stanley.chu@mediatek.com>
Date:   Tue, 05 Jan 2021 21:47:06 -0500
In-Reply-To: <20201216131639.4128-1-stanley.chu@mediatek.com> (Stanley Chu's
        message of "Wed, 16 Dec 2020 21:16:35 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: DS7PR03CA0007.namprd03.prod.outlook.com
 (2603:10b6:5:3b8::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by DS7PR03CA0007.namprd03.prod.outlook.com (2603:10b6:5:3b8::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.23 via Frontend Transport; Wed, 6 Jan 2021 02:47:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cda990ea-8e1e-419a-15ab-08d8b1ed5d6c
X-MS-TrafficTypeDiagnostic: PH0PR10MB4711:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB471152482D4A61EDA36E62658ED00@PH0PR10MB4711.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fmKEEx34GugKwe5y/lPRj8go3PAaRIQWot9SqeAgV5T06l7EGlrZ/EcnCakRnbX1wYe+ccNbHpyQLfp22GWxkjiwpKLIz4lgqXZ1YXsReVHwgTNzhDbVyLWojnpSzN0oUgWZVRSG5yX7Q5EQpDxy6tKJjklmxSNdntRjNRuEhsEQn3bfraY+Z/j9maLTTj65UIuuQq5XsCtBRnQK296w5iF67dt1/rkE24c0848f883SLkJeahGATCACKXkhkmjyx9mmmClMXxOxa+em/z+cpesOdvFBGvfbKy0wvQWEu57b/8IhhPQrMFlXPI3xPyXa9RDor3RR5dUfPMZHHOyawWUITW0mrLlsmdyLiuK71AwDtanXNtYXZNiWgHGJtZGZNCnKweUafBDMyYRFnsPWnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(136003)(39840400004)(346002)(52116002)(316002)(36916002)(7696005)(26005)(2906002)(6666004)(66556008)(478600001)(54906003)(16526019)(956004)(7416002)(6916009)(4326008)(8676002)(4744005)(86362001)(55016002)(8936002)(66476007)(5660300002)(66946007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?0t8fOZ51w6RMRWwhWe0PGSbcwYImROEtgWI69Pdp+YtKRtrc9h9kpJ3QcnoG?=
 =?us-ascii?Q?qyh+n0N7/Mc4xKLnNPPv5csTnGTBjDzo/fnVVs/H+cRsmDLohab89ALfnshL?=
 =?us-ascii?Q?QR72gDVAOQE/qKybg5hhJmO4jqpXgKlN9rXUfPcnG/cA83R0ysck6ATo9znw?=
 =?us-ascii?Q?S8awCRUX5Ow297p9/xVarriLkaMNcOolgu1sKN9CDRcsCqZxHuZQFRmGhU5c?=
 =?us-ascii?Q?ED8ljbLFqe1FeUVbhlo8jdH4tV5SubkViU06RBl9DeDDZmjHJpveagMw+Yg2?=
 =?us-ascii?Q?WhgtKPheWtQMz+6MKaY4wnsuwv8IPfIT0sVMW9jHiNIRVvMEwz3C3tHWN4+Y?=
 =?us-ascii?Q?vOOXUvY1VgbRZXhVizfv5m/ktMCSfDg6kAbWV3+uSaesxo5fV7MnbGtwReX0?=
 =?us-ascii?Q?MkCgxdsIjCbPko+VoC1rrNRycFf5bDLogenRgV5BVIgOxdBGkg7ugVTy+LBM?=
 =?us-ascii?Q?FYtEkXmhqi8z7PeS6qYQt57hTaAitXfS07FyLUs9Dya/o6KNkti4YJFpWfqu?=
 =?us-ascii?Q?g3pUM4q8e5fKk0rG6eTvOTk+M57aDaG68Y6RKT5rtfqRdotjCMG3bmjvvv3P?=
 =?us-ascii?Q?hv7PFiMla0Q1mzr//15eyBR41CVf2e/6yocxCDYl8j4mmtYLS2Gej6wK8Dih?=
 =?us-ascii?Q?MGUPoqTO/smOQfjjoXqAXWWSXRznoy+D3k85HaUK323X2+wCRB9c+fAoi1m7?=
 =?us-ascii?Q?ib9ERPYcbM2vmgQMffbIlX9360vcHo4J24aS3rIFxB7x8HGPbGN7JFYLI+Ss?=
 =?us-ascii?Q?fDDmPdT2VLDYABeocuoXlvxM1sE8i2+XDwvXfOn0a+q6b0PdB1LJYPS67kak?=
 =?us-ascii?Q?Rc9RY6TTaTUbhj2Q6OgoIuy5+hhWngUFAjpQpO+mp5+vdBrEzeeGbp2gMBmb?=
 =?us-ascii?Q?S+sX7jtk25KcOjK9mNHImji30pY+xOVCUMYYs8BJne6PTIb0LyJGod/g/2QA?=
 =?us-ascii?Q?D3V1z64JkHiwORG916hy68iDnX1x6tIr6s3Oumt9QTQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2021 02:47:10.4759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-Network-Message-Id: cda990ea-8e1e-419a-15ab-08d8b1ed5d6c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WX9XJcxfYM1cL//w5TA0xrwinX03qZZIQZT5NX+iHCIRV6hEQwZ6pyGX9ra3N/lQczG8CkI1YOCwL3CKURjRwNF4ZQiLJ+U8fZycustzb6w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4711
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 phishscore=0 bulkscore=0
 spamscore=0 impostorscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 mlxscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060016
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Stanley,

> However this series may not be required to be merged to 5.10. The
> choice of base branch is simply making these patches easy to be
> reviewed because this series is based on clk-scaling fixes by Can.

Please redo your series on top of 5.12/scsi-queue + Can's changes.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
