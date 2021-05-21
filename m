Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A58BC04FF3
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 21:11:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48B14613F2
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 21:11:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbhEUVMd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 May 2021 17:12:33 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45248 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhEUVMb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 May 2021 17:12:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14LLA4vP030244;
        Fri, 21 May 2021 21:11:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Hu0n5eC6AIqSpCI4Kj6qTiPSnSGzXERb5kkBRUtYsN4=;
 b=cdiprctQv0AblaOrVK4TlodeQr+3PmWB8QAjTOGtqU8J7QtXYZzwy9W2vwHiZ1P8tqhJ
 d+PuBPeHeVS1rETI8razMP5v6ml3IZZ/JsS8+2HpnE1rqOQS5s7wnygC22oEPDzCdQCa
 WyBycvM1pGcjaVKKeruuNpB5aD4QhYuFUpw8qP6XRayj6yVJDROYoCKiDeyL3T8LjZOl
 EaA/zYyN5m74HiTywdaopT2/HkRZsDH55/HV+koxluBfZ8KUcLHkGa/hUbrb+m8LyaaK
 m8OJ0aa0wEH0XqP1rWtbdOmD6VIxpc9yzYGC7M/ldFOBVrPigBRUROiE93VLMYsgfCBC Sw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 38j5qrgsbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 21:11:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14LL6aZ4094632;
        Fri, 21 May 2021 21:11:02 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2040.outbound.protection.outlook.com [104.47.51.40])
        by userp3030.oracle.com with ESMTP id 38megnwnvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 21:11:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c5juy+2KABQbMwb2JpJIdcn57gdQ6g3ueHd0NcIRue/+RjYNW2Y1BEm/GlmBSlFIDOBjxg+j4cPmJPXTgKAIxfBJ723vM4rMj3+fZ9flSTRlSY0oiyjDfmGcxMQmCgpGXlFAKFbWU3Z3we9yvFOKES825/T1eB6GtcTpqZE5RoPfoq/pipt0fgXvIkzyK4b1GRivteDwXkN5GzI85SSUihzsvOjmYQrRcJzM79/KwWiqAfLQaEMmhSw91Y31Mb8FjbPpRJboKRp912XWgItGvhbdKsk62w6t/iYar9v4RXH8Sf51wNtmELF4U1gtZBETLLtYdDjPuVJBWgLafpHlmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hu0n5eC6AIqSpCI4Kj6qTiPSnSGzXERb5kkBRUtYsN4=;
 b=RRMRfCizSnQhEIAVy4+oqNKWjV1wd2MnMiTZycTR4lFz5jErVuY8lgBkdNkTp+3hsbx/oE3cS4C7gEbrc195gQ6Wx6QgD4j4C4U/7mgBrouGfqyLeeEHnkVEXJ0fD0CFfIYxspZtcEAObuudgbXNRM9Rh6p8dvCwZg6bv4+tCJbvt8r1RDQ9pRX6i9zUsSCYS8UacmpAmhau/cf8xKUuGFw0uCY1j6ypxHdwshaTm6O43YdA9wbCyrDxAgsjFrW87peyBOW513/paFwJVFrwbUmsYgm1qySKrFWNqRlkxp9Sgpf1V1KJ8fmA1hEC6kXZTW6HLncgTHF6Nslsyv2lAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hu0n5eC6AIqSpCI4Kj6qTiPSnSGzXERb5kkBRUtYsN4=;
 b=ZSaUOsgty7KlxQPcohz0nkO1+6jF2uZaQz9khN55fzftFtimbdPi/KGC63aCJO5zw1/3spDGR9r8E0HOMoEDK8KBAbBuoVOzlAf46W3rf87bWMZYCE1OHewDmftV43n9GXWsE1r+xqf1y/VzT78OlrdbgtnI2md66HJmxOR12ck=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4680.namprd10.prod.outlook.com (2603:10b6:510:3e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Fri, 21 May
 2021 21:11:00 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Fri, 21 May 2021
 21:11:00 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/2] Two additional UFS patches
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v97b23uj.fsf@ca-mkp.ca.oracle.com>
References: <20210519202058.12634-1-bvanassche@acm.org>
Date:   Fri, 21 May 2021 17:10:56 -0400
In-Reply-To: <20210519202058.12634-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Wed, 19 May 2021 13:20:56 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN2PR01CA0053.prod.exchangelabs.com (2603:10b6:800::21) To
 PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN2PR01CA0053.prod.exchangelabs.com (2603:10b6:800::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26 via Frontend Transport; Fri, 21 May 2021 21:10:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca43a17d-33d7-4cab-a2bf-08d91c9cef03
X-MS-TrafficTypeDiagnostic: PH0PR10MB4680:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46805CFAD49492151910AAB88E299@PH0PR10MB4680.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bayXdnsKzDHNHM2lR9aLjLqPtGBUy5Nz6tVw0bBjwUAOc902GHvgcSyBfX28Y02sOgLUl5R0IcG7FTSMHVxKtwK77aeyb31gBx90WKYo7iRR3nv47r8NeV2Xge50eoPnhjgPlXTvGUhGejEAPaXfdE/BXs7zIqyP5SdI3WhlkXIlaOFY9eVj9oOgl/80i3evEEcen1J9/EQ1EybFxx9vWer/bqmPpSyew39MBX7QrRpl5BSLCE1bIMMmEn0PwQUhpI2y7ymL8TyFjpv+ZErPVAMHXUscDi7iRXO/OJjvY0p9jP153c7a4T3dNHe/IO1+u/ddmuR3z9DWMU4LfoYu3kPEtyQtGhsbAzbybBjPeKcQkCVFTR5mzdbw0FGSTAAUu3Q0kLSHlzEvyC7dL6zruozpi0i0g2UvnosQ2UJIbZ9lPDYhw8W9PwwJqQMtY+Lg9TVGt1PuFg8GSUKeSQqQHZJpPIypsmCq+V3iQol5nggDbsZ/+LNmCsxF7MpeISBd74dBHgNRnX7+hvZPXvsJXoRQXJArqp0DzM8hB+F3twTtZZIZhck36gKa77VTJ81D7j4qLZEqyWmkZaf8oL1l0Uxf0nN4SrJ28n7WtUXPC8vdwoUByWXLcwyrA9AJKKYf3/9k8CeXcA/+/NSQBCf1+MGeGvobnQ+F3hFv3nSWbyI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(396003)(39860400002)(366004)(376002)(38100700002)(6666004)(4326008)(8676002)(38350700002)(2906002)(316002)(54906003)(26005)(55016002)(8936002)(4744005)(5660300002)(956004)(478600001)(16526019)(86362001)(6916009)(186003)(7696005)(66556008)(66476007)(52116002)(36916002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?PBde7gnuQ4Lp+IuTg1EVaWvFKthCtjnNX11K2bCj1ry5Dw1Jr5kLkDtlucJK?=
 =?us-ascii?Q?5sF4V9I8pOGyku3Jm9pwOpIUjWJjjY/2vw63YxeguWehPEkmMWbnq6pfAB+o?=
 =?us-ascii?Q?ROkwKVNusL8+LxNXNycaya/1ALH4RPgpzeLQfFjn/FlyqFyBvO0wpeGXX6BU?=
 =?us-ascii?Q?/CALEm+uHUFhTtu8IkutWq96k7AqiXWSccsnDqcTBKZuNMQdV7bFuoU+3lLK?=
 =?us-ascii?Q?EL+vj6rnD/+0gzydoHzqL1T0p9QeIKesL7PcN1kkeyoC7hEuwb4kttLC0Xox?=
 =?us-ascii?Q?0SAGRV9nqmFB0MMAAfdGurcf1cAFA7/F7SLuSxVkdvpYduw4oIaMvSbiDkaz?=
 =?us-ascii?Q?fBtP5r+f+ufm7zsbulcgNWTD/ZrRwNdDRSb8uwwLpGl3Dgg24qeiI1F8/+db?=
 =?us-ascii?Q?voVy+uJ7GtrlhqDF3AyqdH1FcDzcum3w9Zo9c3lLvA0r5Pa+oZFgBQTlN3Fn?=
 =?us-ascii?Q?edVD4KFM8cT4Dw51CPi5k9vvIdhLi+vJxh8/SWAWD//iWbjZuDpbGHQpctLW?=
 =?us-ascii?Q?ec2xKceG+AuSOcO5nVqM2ckwF1h1uY96gbmpENqp34kdZP3Nf16+/gj3h3L2?=
 =?us-ascii?Q?2QYsFjBOqNrxTSJLszi20poqypVFh0zWcQRIBzosLCrMu0IZIzA4bv9EtHfN?=
 =?us-ascii?Q?3HgmwLfxaR7696Rfk592+4ACBTy8Ad1qKGKc5fE7WBIE0Ep3otJzO4w+zjOQ?=
 =?us-ascii?Q?TmD/lPTaWOP7AzU0YHBxBWmi962ryfqQX+xDVKHA6XaW2ZJ8ToZE8yjeJyf3?=
 =?us-ascii?Q?GybdfBRO8r5mK43/EYV2WdAqsgmuLHUgE5dyeDYCQL3MzTTUrCS/pv49iV6V?=
 =?us-ascii?Q?CrWV9IlZJf0Tu8++d+Cx2HfelzjBZPv0kSB8uXRqrfbEZrLD6YAmiYtgpY+A?=
 =?us-ascii?Q?Mu5Yna9NsftRtDe6ffCNwlxu42Gps6tM9cpyNF9X0+9L5STkct+qks83Jb0+?=
 =?us-ascii?Q?7Gxz1ieOIzaO4KpMw+Lwp0e2Xbxs0Jn9L6KAprFFdpAbExJQm+VMiSsV6YCK?=
 =?us-ascii?Q?XesoaeprGNVg6IwgmvyWywEU22FH0fr7xAorsaPrhxlbeFGZJ11GYrs+AZ6v?=
 =?us-ascii?Q?clZTifzMIBEg0azLwLtbL1gziTUpPd99RHyqY0F5vJDFhyxDpe4Efgduo8cf?=
 =?us-ascii?Q?DMYEvsp1d4Gaz1WX5eLA/PvYZyUFDK+jMgoFsm5EM6kFKpwjwpPT4NkRnpSG?=
 =?us-ascii?Q?TsEE9NSBoO273UNyiLatV6kvBygH/1MZfRUs3mo0INLUMEnwvA60GF4LvpKf?=
 =?us-ascii?Q?sDV/gU5Ru5Sr5tfz4BRvc6xtzselq+XP9hiGd4wiBTfKLS0bB4D08vETDEqe?=
 =?us-ascii?Q?Qu4ySIis/JkUzVG4dFg+opL4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca43a17d-33d7-4cab-a2bf-08d91c9cef03
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 21:11:00.1408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +hGCBP8Z2LYvI/QdJJg4ay2iO5Sa2O/vsEHYQJAmL+YZwk8ifqT5GKfrUfJugx3YbEStQbWrbDEMPUhUtqLQvBQfXGhfSuZUCd/+hKwDT2Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4680
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105210115
X-Proofpoint-GUID: 8M_ivOTAm4RrJPecTZFT_xqJAH53FrGf
X-Proofpoint-ORIG-GUID: 8M_ivOTAm4RrJPecTZFT_xqJAH53FrGf
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105210115
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> There are two UFS patches in this series. One bug fix and one cleanup
> patch.  Please consider the bug fix for kernel v5.13 and the cleanup
> patch for kernel v5.14.

Applied patch #2 to 5.14/scsi-staging, thanks!

Minor nit: Please send separate series for separate trees. b4 doesn't
deal particularly gracefully with parts of a series ending up in
different branches.

-- 
Martin K. Petersen	Oracle Linux Engineering
