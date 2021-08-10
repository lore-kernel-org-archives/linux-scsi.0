Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9246C432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 05:21:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EDFC60551
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 05:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237627AbhHJFVc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 01:21:32 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:28132 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237337AbhHJFVa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Aug 2021 01:21:30 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A5AtUV012154;
        Tue, 10 Aug 2021 05:20:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=q+8mJSqqRE/GOvVqcnIz+E+Ku6U8KMv+N/WbE9e9Brw=;
 b=tJvZVC33KCahYI1EeSC8AzM4y5+/eG+JE/rnXWy+5zk4PpGbz5nxVkpgOPo4yQtz1CQr
 Gq663MgARExHFRmvI754zabbmS+xad8c/zapN6uo8J/fC+vxCK26RxLbWgxDIc4kOIuX
 FUQctIDyF8YDppkm/LL3S0y9TYtg9t/VDpcPvF69UZV/zMuqYY88XfHTpuQ4DemxStqt
 R2BOv2SBf/gZMCPxTBVt0Ni5fmuNwEk5Ntoj5/OjAGchr2ClAcrXOGzxlr7HQkWS7EzX
 3xgiO3dedJ3XtcXMdm0KEvpJleekF4MVke1zWhvzmPXvAvMWBRMBfZikGtnwkOzymD4S bg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=q+8mJSqqRE/GOvVqcnIz+E+Ku6U8KMv+N/WbE9e9Brw=;
 b=oRgRVZ58d2wciMF6tWnYR7P5wxQC8qVXd8WO9QkjJK+KIQlymV9ciVJ7oq3zSkGybo2M
 X6e91vTpjfg0/lVD0jmJuhoIdNjupz+x0S/paFTQ4rMRyFFlY+/Lj6GOcRwKo1p4A6zM
 qX01EZE6kjyZhhDC2gIb1aid7DzAxsQOhaT+pcwNLjl5po3oiZ2gYmOw59MyVROJALis
 cBeG1sORRnT/vybpPhNyO3rSJ2uiF2p6RdrZcihyKdbes1JbgZV/cOn4l9VUS//u8o1Y
 eb8o+EOhAkpSLU4YoPD6FEDhGUMPY+2vpqFUQ2hJrT9SOki+hU0h3YeO2YeiAvMWDup9 KA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ab17dt9s5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 05:20:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17A5A4Di149438;
        Tue, 10 Aug 2021 05:20:55 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by userp3030.oracle.com with ESMTP id 3abjw3rss9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 05:20:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UOZuSPiKE7sCU3ApCZOA3NmttoGesN1C/hoDEAkPPW0Mp5KCpDx6Ujrx5QaL/ByxPoO8Ux+JEy7XI+6nupsEB6sw+YLvXQrE5ZVbXB4HIDXQwyxTxava80KP1c5ORZEgswRzRQxv/kguWxPIDfiXqnJJjDTZkPGA84Q1vuLJHjhv8fpAYuCe2CAdUKLA7DQrlTLkvanIASVRua+No+TucX9Fi2qPHA4xDGpDc1lePGK60rsHvqBJ8QTmTenZrKR81cx4ixraKfir3hQJUvEgxjDCjYnWSltYKtayEdKgPHHaiDCiK+L0YHwVkzVSVLcsd+EkopEXYsEVsZ/3lkB6rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q+8mJSqqRE/GOvVqcnIz+E+Ku6U8KMv+N/WbE9e9Brw=;
 b=mcFpEdcuf3Rivmbm3Y2/UK6ZpnTvb1DT80i0aubgb/3a8wEwa9ICE+4X9T6+No8eOjyZP3aBVTwUIoNSi4bly1kiGFY2TTOVwuW5z6HQCGff5OoY4qurYImt9aSmT2K138yRflQmQa1jp8PLscaaM5FKOcZf1xODuwMzZxGmVtZ+iLnAPVHbpgQjfN1BxRCZrsps62Q58nCBXAzjF2w6Qt+bEiPq2w5uC5CQTjEbCdYbVH58C6PyYfga+SzeSKJYJzo+WIX4Iumy1Ky7oB1UCUT7QSuo9phlhCivnvF6xI41WMnkzOVPZ3gCcSgrjubQgH42EixGJ6UbazL2np+EgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q+8mJSqqRE/GOvVqcnIz+E+Ku6U8KMv+N/WbE9e9Brw=;
 b=0ApgKAKZ5PwCwvSUAg6D1NT3b3I8x2pxNAgRaRRlfJRmKLyjTn7xOJelb0gG5Nq1gnTrZu7xvlDWylDFgWgcboma/2w6NQnlk8qq4pjraHAerZymsI8ZwZlBrG0gZlzStPLiwQeFZuXpFw+w8sBo3b3W9Rt00QJ1zkgd7v+h7sY=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4597.namprd10.prod.outlook.com (2603:10b6:510:43::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Tue, 10 Aug
 2021 05:20:54 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 05:20:54 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     asutoshd@codeaurora.org, alim.akhtar@samsung.com,
        cang@codeaurora.org, daejun7.park@samsung.com, avri.altman@wdc.com,
        jejb@linux.ibm.com, stanley.chu@mediatek.com, beanhuo@micron.com,
        Bean Huo <huobean@gmail.com>, bvanassche@acm.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v1 0/2] two changes for UFS/HPB
Date:   Tue, 10 Aug 2021 01:20:45 -0400
Message-Id: <162857263915.15955.2298626026891347656.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210804182128.458356-1-huobean@gmail.com>
References: <20210804182128.458356-1-huobean@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0601CA0001.namprd06.prod.outlook.com
 (2603:10b6:803:2f::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0601CA0001.namprd06.prod.outlook.com (2603:10b6:803:2f::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Tue, 10 Aug 2021 05:20:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6bc79c53-341c-4223-925d-08d95bbea04a
X-MS-TrafficTypeDiagnostic: PH0PR10MB4597:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4597505D948F671261B900DD8EF79@PH0PR10MB4597.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lT/ivlBE6qrFakdpi76GNi4gK3pjqHYgwPpQBb1b9Rxc4o5gj41xFttRFjG88LEkZUDd+cttliEDjCWdHKD87ycTtM8dlfi8A1uJARLyvmYZlaqxEWsF8C9O1lIDhZ0XG7zmkuRcurKmV12znp5BAXdYma7aS1a4kD97PQ3obYK26CdsSAUWqoYCXayn4YCFhZuuMNT/yZaBs2zWSHhmgHV1VuY7wJan/XVAQRQ5ooCMaFNOSuhoadb/sxC1CMEmv2j7KJ8DaGAjOLLAvTGbGIHg+15+VE0I4gogp8/CUsgFCLPO21TPgJnRJL9QY7ugt4nuXJV36O3xxbyeA62KHyjosdt9GNc3oYQXePsyPyDoOfmi6YJ1fw00WyMk/A/nM4sZ/Yb2fMpnhDpAM17Bh8FHith2eHk9ktfC5HnZ6m0LCZHUeIIuMqwZl47t+eOMM+p6ZV54GI+wujxdr3sZq1qoMZ8B6Zu+EJEQPhk9xGlPK6aZBpx/1iHXakxBjSGhSQXVNykbWf1c0J2HeJYxET3dNgi4YczmAz6ETPjnRPu2yn3QeFPg5lDk+GXrawkDm+Qp9yakEIZic2R5ZSgXM0Ry5QSh68JSkDVcRK3ymduiMbyDdROeYrhM1kkdEPNeh2lP1M3FsR39wXG3TBZTknZeKvWCi4HVGHWGn1xbolIhYTxxJ0S0P9y5r5in5Nt5JUUoyHVcV5UaF7zyGjxZ8yPSadX+RtwggSU7X0lVL6mYWOCNeMNUx7uafxb7jt83PsgftBAfmTMo65/udKZt0fjsuU+CmGjMqpdJWUI3rR15rszBsuLhNFid+Soe8IKAwcxYDVeztW9XeJf5qBDrYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(38350700002)(38100700002)(103116003)(316002)(966005)(508600001)(921005)(52116002)(7696005)(8936002)(6666004)(6486002)(8676002)(5660300002)(956004)(66556008)(26005)(66476007)(7416002)(186003)(2906002)(86362001)(36756003)(4326008)(66946007)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUQ2LzVMR0tSeXlzaS9uTjlnNGQvck5oeVc1MVM0a1JDT3R3NWF4MndDYjVZ?=
 =?utf-8?B?Ulo2QUd2UVZ0dXZJTExDTit3bGhCWmR4R2NCTlJRVnIvd3BlaW5vREVUWHNj?=
 =?utf-8?B?cG82cHhpVWV3aW82T2ExQzZNZ3BiVHgwZ1E0RW5HRTZyMU0xK3NBNFhSSGhV?=
 =?utf-8?B?UnpPWkE2dUxMcHp1QXhsZGN1Q3owTk5Pd1pkUUFOMDBPcU9QNlIvVWRmSG9m?=
 =?utf-8?B?KzkwY3dmcFFhUDhzNmtzSDdZREYvemFHczRMenU0NGovRmh1UG1Bb281eUdF?=
 =?utf-8?B?WThWQWpyTHZTd0dkWFZXUmpJazJBSEJDME8rTnBzSVlhK1g0WVR1bGtuMjRM?=
 =?utf-8?B?bkFpMFRXMzhjR0lpZFFBQnZ0Vmlyb3NValQzYzRQLzRFZTE4bEE2L1dQemZq?=
 =?utf-8?B?VFpLc0ZLQ3hsSmcyb2hwTFpxaFFhUTRVaEZ2KzRYd3I4NjZoR3JlNGlxaXQ5?=
 =?utf-8?B?VStHOWpVYkFyRWxtNHUxNEo3dEQ3THh4Q2M3S0R6b2psT2FPc01Kb2pNaTUy?=
 =?utf-8?B?N3ZIWGh3K0U4VCt2RE1lQ1FySWVFU3B5TURtcFBscTIweW9pdkdwWG1BMzdK?=
 =?utf-8?B?T3ZBMzl1SVN6R1Mvc25xblBpT1QzbVNOMXBXNWdpM1U0cjdhYXJRdWFUY0hR?=
 =?utf-8?B?eGFmZ0dxNVNWNHRHb0gzeDU0TENCWlN3eldSWFpidVNGNEl4bWtQMVdUUDZ3?=
 =?utf-8?B?WThabmJ2L1BRSmRyeWQrZEdPS2F0RlgxNkJHZDdwT2NFcFhSOG9mVndjS1ZV?=
 =?utf-8?B?NXBTNTJRK1VscFJZaTB3bkIwdTZ6SmRjamZOdzIwajlLU3UwbGNjSEplTmVR?=
 =?utf-8?B?UHdac2pEcUN5Uk5qSVB6QXhZL05mWFoydG9IV3EvT2dCK2xac3NwaTJJNGZr?=
 =?utf-8?B?UGtSckJ2aFBkdGNWMERTK0l3NUFlOVcvNWIxaFYvaFRMWUdzbmJxcng4VjBm?=
 =?utf-8?B?WkxWa2ttTURUVDY5YVh4dnFyQXIvUmZoemZMZlVqMjk0RUI3MEV2R1gxRUFB?=
 =?utf-8?B?M0FGS2NBRDdlVjkrTkRYWXRSZ0FmU25JT0VyYzdIN2FnY2tZb0E1Vk9TMTMr?=
 =?utf-8?B?UlNGOXIzYklCdGRMeGNZNmhjVFQreWRETFk2NDNpY2FUTHlpb3JRQy9PaFY3?=
 =?utf-8?B?WkxRc2JLSUhCaXpzeTB1KzdGU2ZxRWszNWt0aURVNi9hY28wNlVFOFNWa0l6?=
 =?utf-8?B?NnZSU0RLWCtpQmh2TnkrTm42d1pRV0FWZStMeGFiMkF5ekkwc3dRd1BONnIx?=
 =?utf-8?B?bVd2MnFMTDBpUkNvV2luMTBPTlN6N2RwSk5mL1Q5bXUzMmVObG1ON1A5REFo?=
 =?utf-8?B?YVZ3cmt0ZUp4OHpQUERHY3ZiVlBTMHB5L1M2czhsS0dhZllobUo0Z1lPdlov?=
 =?utf-8?B?d09KVVhqVVZiVWtUMHBueWJ2Y3RFODdrVVdhWGhLZTFnallyMzkxeU14Y0R3?=
 =?utf-8?B?djB2Um5YMUJzWjFLQXBoTmdYbDB6bzdJSzdBL281cUk5OHU0R2lVMy94dndq?=
 =?utf-8?B?NW00NCt5bktxNG1qRmdKNmdEOW90cHhMR0Q5WFlDbWdGL1o3b0UwT2djQUpv?=
 =?utf-8?B?U0RzRS94TlNHUVhMS3B5Uzd1MElySlNNY1JDeHBmY2F3RUJMRXlvbUk3Y0tW?=
 =?utf-8?B?OEF4QWE0eEcwbG5sbGZmaHdXL3NWaXJzenZIKzJMUmUzUnJmdHpCMCtFZ2Nz?=
 =?utf-8?B?aC93L0ZMUXlkN204d3BCc2F4OC82N28zWkhMdWRUVEpsTzJaVW41YlRsYkVq?=
 =?utf-8?Q?XXZYl9O86oSGGKVvnnTAirxQLYOQjQ3qaHeep25?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bc79c53-341c-4223-925d-08d95bbea04a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 05:20:54.2822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: plRbvReARwwZtGEICm3X3aOM0yn3phndgmngPfQy2tzIy1LiCUa2l6vDGos4CXB3k/WIYzS2N2ekqgFHeDPlkDC7amjtP1yZ5TknD+8TG+k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4597
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10071 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108100033
X-Proofpoint-GUID: JCzV0OWDWHForWJ7Xcc9mXe_MELxNsut
X-Proofpoint-ORIG-GUID: JCzV0OWDWHForWJ7Xcc9mXe_MELxNsut
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 4 Aug 2021 20:21:26 +0200, Bean Huo wrote:

> From: Bean Huo <beanhuo@micron.com>
> 
> These patches are based on the Martin's git Repo 5.15/scsi-staging branch
> 
> Bean Huo (2):
>   scsi: ufs: Add L2P entry swap quirk for Micron UFS in HPB READ command
>   scsi: ufs: Add lu_enable sysfs node
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[1/2] scsi: ufs: Add L2P entry swap quirk for Micron UFS in HPB READ command
      https://git.kernel.org/mkp/scsi/c/63522bf3aced
[2/2] scsi: ufs: Add lu_enable sysfs node
      https://git.kernel.org/mkp/scsi/c/f5efd4fe78de

-- 
Martin K. Petersen	Oracle Linux Engineering
