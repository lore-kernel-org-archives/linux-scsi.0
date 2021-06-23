Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61E10C2B9F4
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 01:34:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4762461361
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 01:34:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhFWBgS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Jun 2021 21:36:18 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:42456 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229751AbhFWBgR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Jun 2021 21:36:17 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15N1VTbw002726;
        Wed, 23 Jun 2021 01:33:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=FySvbdNMmyTRQXrXc14aFXVQaugJW0ULK5j5EGaHxDI=;
 b=TqVAtUnjadfmPy0+d4gnjoa6OH7mjOu8xhZvYjPxW/aRSBiTmC8+qaE6zZA1hWgV0FAb
 LK+53bKW/CZoqogUd+wFQd5pXDnf5+2yScDNzKVV4Sj/Jjua/kiNn38umEp00uBN2M1M
 RW+UlwPGay+uuR37g0X4CaCwK7J4Go3tzON1741xKgTWny/L49g//zkIKITm6r0+lET/
 MFdBq+/MeAGdDRQHqXpKc3ofUCSK3L3BRss3lqPjJJ45OMkvG97uAtizLbLT0dYlpe26
 oMUT+iABdl7GE78u1Kuglz8XILLRW6YG+YSpGHKxajOC83gtnEBoGJZanvH1AlDxPwvB 7g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39aqqvvjwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Jun 2021 01:33:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15N1FR31076371;
        Wed, 23 Jun 2021 01:33:48 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by aserp3020.oracle.com with ESMTP id 3998d8cgg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Jun 2021 01:33:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CMSOiFToZylNrgC+WlARw8sKqZJnYYhahf5/5g0GgbCIF8DhKX/ooTh3qkGax5X1AwnUdcRctZKFFbtxudJ/x2nf1UViekVib23Ac1WuhLFWUG6y8XNepKyhcK1gv39Cmys0ONuWgyH5Q5UwhRuZsYZyprnvXWrXkOrJ4bMW7YqlhlHa+FI2hMw776MZp0djB2ME051aOcuj9+F48Yb7AoNeTFsW9U74Na2S5sV3fQJeb0WIQKfjzAAJpcgYVLv+ca9ugRTuYmafw77HK5a2pfrM86zZY/EHVVPEIyGRZrQDKEWvg1G142OKfxsvw64kQ9LiJAxlBdrv+HcsUqohyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FySvbdNMmyTRQXrXc14aFXVQaugJW0ULK5j5EGaHxDI=;
 b=LWBI2f/VwvNlH9U0s6fBNF2OKqmfStr4LDJlzHfyiT/GXRAUiL6Rbs/lrfLOJ6HcACZ7KooZnPRUtz2IcSUt8sCchQhiEUjkn3aVgyEWyDzNm+PpxHpY229XzF3QcMj1jxHLZhpSmaeNfs7V/doPGed5kK8jqGnoEXsF8slVHM+jjuul1lmx/jPDHYaSz1gaX6eRRSL2k4KYDr8+R1wZBTYQQ+cssA/1Kfab6AAdBgnF4YrE0KSPbwoh6rKnovShvayyAds+E/4D9GbLWvTCa3UWrnyHckjpkTwfqR4O0HgW/qVCVRZT/VeYTNhE08NQjxZlYiHmWO1yoDYL8MInvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FySvbdNMmyTRQXrXc14aFXVQaugJW0ULK5j5EGaHxDI=;
 b=W8o4rA9HTxNJYITkvbwRSAtRJpuzd3CwHO52EqtQERXGnSrPYe9XtzL+X8yCYMEFNzE4drSaFdzAdrj5IsEyc54u+fD5AJ9auVtFJEOntnHc+0cLFxknOTbXE6gI7mkC1xAilMNBdUKWIv693s1AJSbnGEdxqbKLnb5x6AnnOII=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4501.namprd10.prod.outlook.com (2603:10b6:510:43::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Wed, 23 Jun
 2021 01:33:46 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.024; Wed, 23 Jun 2021
 01:33:46 +0000
To:     Yufen Yu <yuyufen@huawei.com>
Cc:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <john.garry@huawei.com>, <linux-scsi@vger.kernel.org>,
        <yanaijie@huawei.com>, Wu Bo <wubo40@huawei.com>
Subject: Re: [PATCH v3] scsi: libsas: add lun number check in .slave_alloc
 callback
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0mls6tq.fsf@ca-mkp.ca.oracle.com>
References: <20210622034037.1467088-1-yuyufen@huawei.com>
Date:   Tue, 22 Jun 2021 21:33:43 -0400
In-Reply-To: <20210622034037.1467088-1-yuyufen@huawei.com> (Yufen Yu's message
        of "Tue, 22 Jun 2021 11:40:37 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR03CA0149.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR03CA0149.namprd03.prod.outlook.com (2603:10b6:a03:33c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Wed, 23 Jun 2021 01:33:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 856ac420-9ff1-449a-210b-08d935e6f199
X-MS-TrafficTypeDiagnostic: PH0PR10MB4501:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45011C20A9B4A2DAC55651C78E089@PH0PR10MB4501.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5cPpU0XHRjnPGGYOpLKjghuDnlLlfv3XQwfwKw+aV4S7zD7qHemezL2AdQPju35E/8lumACE66Zsm6CPE6P/BJmlr3MP3Bf7/sIoyATXZ+xGc/aU/Fa0+WctrqUtktbhaPL6L/t91cbFCxN41znQ5xykhBRIVfvAwT6O743tO923MUDE00O4ER5EnFdlG7khnSYyXpWMEjw3eqTWlttQckAAEeCKiKNUD9GFptplZOE7aZPEWwmFAvtG3k+3yhK/wOUwsyXuU+ozZQR77ks42ExpWkJYay64L5mi4jQtg9HrGnzUXdEGNcBFu/XL+Bf67dnCWjUN7ZQ7LLAl6BcmhVWCpswGQhrVmh5MyW20++TgR+40FE+2dKL7ReV8KUxMgpL4qE7bKIqAlbPuCxdQqtRfdpJsi5LfOK2WDBBIO/gNYh9ZRFS5DRXvTPTNpVjhxIM3SSUDbuqnsATi27Lkh5ApPmj/40KSkD/hUznwIkrnDh5DQ9AHlq+P1uVf2wSTgnLy0yeoNTJki6lmFpIJwNi3bYjOQjUFNH1zWP/xiC3rFx/249FiyK5s94vJBATuL+YLpVH/tj+ddmCu8dxNAJeMCe2i5lS8xoXyaxy2DX6li9V01JNpWDex7ADOrL+mQhXz7ZugrVC/nWpa8y1dmWlD6fkzHz9iSTjHr3YgadPbo2CQ2a2CZ+3ZsZ8yZJ5+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(366004)(39860400002)(396003)(6916009)(8676002)(16526019)(26005)(956004)(38100700002)(38350700002)(2906002)(4326008)(316002)(86362001)(36916002)(66556008)(558084003)(8936002)(66476007)(7696005)(66946007)(52116002)(54906003)(55016002)(186003)(5660300002)(478600001)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r+uKn029JkqREQIGrfCDpnOb2ixZBOakKZOxr0de++WpdbgOC1463Y0TTl48?=
 =?us-ascii?Q?CbS6GrpttAB4jUB95IybWYIqX0rJik5A/T1eu7yXh8JSgtaB/7PggZY0WT5K?=
 =?us-ascii?Q?jzxVZXSN8+/2j/vAsu6Bv0ffVOyQzYLm61Kz6v0BYRDgATdDN04iDJH7DdON?=
 =?us-ascii?Q?+a8FiaPYyFRwXPNr/TJd0dsKUSsTMvp87xbICgdCSU3nFEOyiemVbiAMhnGP?=
 =?us-ascii?Q?+uIPw1hwPKwoW8pgwSfM/eP00PjLaIfE5dX7if8Mt2VrDlq+L385cS2O+S1L?=
 =?us-ascii?Q?SfPVanDY3BD/syEiJBz00Yv+jF6ObqpmAPmMAOg885dhfcPrqGY82CrY2gTF?=
 =?us-ascii?Q?AdISkbgHcBVwlh+GSD7mxfcpcdtdUlx3jxUAtQI4cV5lO6wrui9X5ZA8zMai?=
 =?us-ascii?Q?mgObr0dFyq3eUDmSHvFDYx7qqv1yUA6tr3iress1ZCtIO2O/3t1jMFhnqoSw?=
 =?us-ascii?Q?9ZGaOExjUk/dttB9QbgjLgwN6AjkwPOte02ZX5kUh25l+IKTfqME/LbFZ8sR?=
 =?us-ascii?Q?GmYc5AJ2++/34SesYyAWJkqKtepnPgaN5qpgLflvujMPTy6GVtN85pOwCsFC?=
 =?us-ascii?Q?BgNfuRbrCd0+yfSpV+V/2XcsutaU5a+SomowuJLxqych98nUeEOekETXdXQi?=
 =?us-ascii?Q?7Gg3oxqgJT4uvTLAV6ZYIg0d6M+/4j4meaufbiSkf8NpewDXKKdp920arzlJ?=
 =?us-ascii?Q?7q9OF8OxBHo8bxLyZjs579Z4WNQLwSMoLCWwdoTECJp0z7P9Q+hbqdMDsYSl?=
 =?us-ascii?Q?/N+RSxI0Sy1ql82ygwHUDhFhemGv0RQ1r5T0Xjo6DrCTr+vgi9zkRsYZSUYu?=
 =?us-ascii?Q?lPovC161JGkaNIf08SXZi+fZPpd0pm04JrVL5WXxrnFvKE3F9adaEw6LVXAz?=
 =?us-ascii?Q?z8U8LIn6IW2GafJ89z2J+PAYV9vLvJchJkDRqRPFZA8x2am1dCfuQvZafmmD?=
 =?us-ascii?Q?Gm9XbZ7ply0eiNGZxqDXAnj059MmAE4P9X41zgUb6D5ibpxNXxNtrk+M9fzs?=
 =?us-ascii?Q?YZki30RXseN4YVpQBMfnuwEU9j7N8ylpBXDw5KWh/1vJVeyqN37a9ZpTPCsG?=
 =?us-ascii?Q?xU3NP9HcaPl8dzcE2ZRynRYO+rbczlMXGuedryV9/AdRACpsHaYSjFJ5kIZy?=
 =?us-ascii?Q?jKrhnQKUtuIwTu7o1TlTnD21oPPftGZQ45uMEnVLBfamTbhoIWVo/QeSK/wH?=
 =?us-ascii?Q?6Lo9aWKrq1kWOaubNpKlZXUfbDEutJTas/fye3txQqGqc/IkCu4jHr4U7O0P?=
 =?us-ascii?Q?L/atf49JP4CSh0nOirwhLAeLL2iMwBUn7nfxlOEbpaP1Si5KHZodle1LIT1J?=
 =?us-ascii?Q?7aIHnAUoFOJKytlxPJYgLDEj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 856ac420-9ff1-449a-210b-08d935e6f199
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2021 01:33:46.3164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pFLxxyldna16O/hicU7241MaW0x6Zi1IPsb9WoGK9/7L0LCz4WELTZnHgDsIdeaKkUPyiwqN18XPEddypial17qDCnZSf/jLaHXB1QokIlE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4501
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10023 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106230004
X-Proofpoint-ORIG-GUID: v58GmeEjUqSW9Ev7Gjie3YEkAoQ9TQO7
X-Proofpoint-GUID: v58GmeEjUqSW9Ev7Gjie3YEkAoQ9TQO7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Yufen,

> We found that offline a sata device on hisi sas control and then
> scanning the host can probe 255 not-existant devices into system.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
