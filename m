Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ED1BC43381
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 02:23:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C265F64ED5
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 02:23:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhBZCXJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Feb 2021 21:23:09 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:50666 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbhBZCXF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2021 21:23:05 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11Q2LRYc028895;
        Fri, 26 Feb 2021 02:22:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=+Cv/4kBRUkgn11bktklunpcjlcZl8KRAUeO2WEWpd4Q=;
 b=H7axHvA9gaAA8XdJyoi4bVSEQ6T4m5Qkx2E6peqKzp/4gOsQqMkb7FLS0xivfrSJyuYd
 XhOsQ4o+WFPPbftoMHTgByAEbSVt5jh0VAnyUEUbOYWNnF3Cy9954hExu1RAm5hSCNkg
 C7MyXKc6iIbbCgmqgoRyKrwVEesTMLuDRVRWQtYs1JyW5S/MkE0KQ9vJrV+RdSvrlV3d
 XKf4Th58HhCTt/2xB9BI6aWvZY7l0A1KVyJHTAfj8CgA25/rlfn7qR1icboEODGOg1wM
 eroyKUENfZe/4XMGCNE8Yfpxi4wVWSWf7QE31kIEpAzzUMGKbdkYo0ZlKalS4HX+Yvr/ pg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 36tsur8hj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 02:22:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11Q2Kiqx083129;
        Fri, 26 Feb 2021 02:22:20 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2054.outbound.protection.outlook.com [104.47.36.54])
        by aserp3020.oracle.com with ESMTP id 36ucb2ufs1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 02:22:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LKLL6w41ltNXEQD6pti0wA4Hw2nY/LMnsPQT5ejRmyMqJq9pOlchcQzCJMZnQWqfjDDlR5Vuq5hK7iMKLxTyWJVCrqlW+//1Cwo5OTPVOizYgDFu49RW4FU9V7pIw1EmDxu5rb+3A9LbUKpFH3HAUftHytpQuIfG6THU9AWaELDNxwGBMuM/EgMyXgq/g25eelN/HVY9aEG+0FbmKvxHLJvUwLPGIys+9cHcaYwD9dzM2txnOTqy3Xe2mBo68Dn9uhIGfFMhfiHhjlPplxGs+Je3yqZYHfzTukR1l3v7Qrg+qnF4FQauCCMPFd+xy3zwmlObB4b++5OaSY9nFt/gAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Cv/4kBRUkgn11bktklunpcjlcZl8KRAUeO2WEWpd4Q=;
 b=Bx77mMOoJx5OvvaoTYk05+1Up7LmC+P8ULzHjdHOSfO8b8Wd8iXkZbRqes9yPq6R8n16qhhLTA3GQVVUFl++po927rcjdRApnpQbuCZUawQZDJsQScTjJGgxNeT/druG0MnFJPUdvhI8LAKqc+c7IByGKugABM0Njdv7dDFmGi5Lfk3RqwsItbf3rD2QOp0njQ9eCD0qbwoXP2n0Zb1GVSISWKysld/46IloO/FPB1CCHS9SQqZlnJyEWiEhyvXVcmTaPHZMMQTxTBi1FgVzv5czIvokdIPrRIMlxcmlZw/o3ZxfyKLHcYv/OiuOtChkcOCdF06uKB8MJ2klm2Rg5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Cv/4kBRUkgn11bktklunpcjlcZl8KRAUeO2WEWpd4Q=;
 b=JX7YOarz6su514hmFHAm7FM74QHCL6xurMOqfxFOD8tgR74tWbLvo4ypB3NsAJ7GbumEFq97wBo8O3IChmbisRNLk4qhS7PuAs2XcHsJh3KHBaPJUIQVj34FBs600P/b9qHdaaHh709wwhzqTh82G775bs6H9EpvPCs/RgaT7Iw=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4696.namprd10.prod.outlook.com (2603:10b6:510:3d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Fri, 26 Feb
 2021 02:22:19 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3890.020; Fri, 26 Feb 2021
 02:22:19 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bodo Stroesser <bostroesser@gmail.com>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: Re: [PATCH 0/2] scsi: target: tcmu: Fix memory leak
Date:   Thu, 25 Feb 2021 21:22:06 -0500
Message-Id: <161430583252.29974.5977995641102362991.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210218175039.7829-1-bostroesser@gmail.com>
References: <20210218175039.7829-1-bostroesser@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SN7PR04CA0031.namprd04.prod.outlook.com
 (2603:10b6:806:120::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SN7PR04CA0031.namprd04.prod.outlook.com (2603:10b6:806:120::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Fri, 26 Feb 2021 02:22:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb42a047-b579-4788-d5f2-08d8d9fd5780
X-MS-TrafficTypeDiagnostic: PH0PR10MB4696:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46963E7B75AD18535CB6C27F8E9D9@PH0PR10MB4696.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OdJhN8rWWkEi++oAMwjQwOg5IE0Mkb3PfjorOH314EarxF6p5cFVeUyR/yYIrQ+D1wdH8XRIefz8IJEWrcq0gQtuFV7GnNQWBCEP+mPEGxt+WJLWFIr2KVMxyt3XeKhvSw83wy+HCZIvAfw2scLBnrbTQ4mhfVG9hWH3JsjC/yhqhim4iQ0Bd+42qO6TmPG6CE9bDt4/7DIU29XugaumR0fgbZOOpN7/7lK7RGmXoVdEWDyPdK4LyfuNwr70p5a+1k4xVivRJUmhfeatCx4H/GCK6+kPTFM9dsoSoA9dJ2v9cCAvIDVIzQBcIw5uU7cBKGuFa4UrHPsNFbzz2r1Lbv0zWn/EZh4QAGAjUS3toX42Qzy5rep11deNJx+JoXjW4uvav+YhzDBH2ua9TprKIZG5jsepE0EwmSbCDKFuq7H5z0bJYE2vtTL0oaC5rLpdPVVFUm+q81LuOR6WE2v/t2lMXgThQ9IluCb1eSdzvrqpud60QTIPV90+aI2ic0MyzrA9kJqO0fmMnzuoot4Rh49U28gUcUD1HnvgB6okj7qP4oZSvwlRCmS6M6d+CQN+qyGp4KrfNwZgWsM0eVZeLv6pGtgb6XudgXZUUjmegp4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(346002)(136003)(376002)(36756003)(4744005)(8676002)(2906002)(7696005)(52116002)(2616005)(956004)(966005)(103116003)(8936002)(478600001)(26005)(316002)(6666004)(5660300002)(66556008)(66476007)(66946007)(107886003)(54906003)(4326008)(86362001)(186003)(16526019)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dFhDcmV0NHVzVTF6S0FYeUdtS3R1TktuVWo4YVl4K3VqdDg2dHFiZFdQd3Nv?=
 =?utf-8?B?K29oRXB0Sy9Sb2YxNW5WeGVNTjVDa2VqQ3NwZWVwWFVjK3d5SkhNSjZjd1pM?=
 =?utf-8?B?TXBVWkhSa3hpNitrS1NqSlpIT3pkMDZvcmMyaGU0bHBpSTZyNy8yQkYrNy9h?=
 =?utf-8?B?NnhjZTR2UklXSVJmVWNoZS9ieEhZZVVzSmJheENOSEtmNzUyRkthVll4NmdZ?=
 =?utf-8?B?WGUyTjNqOEdiQWo5OWl6citMdzZITnovSjlmcFRxcGdMWm01RmM5djhrRDB5?=
 =?utf-8?B?NlJxMHNPRGpXejhPS3RKWjAycXhGRllBcW1oY3N1NHF3Q0FGdXpDZ1EyeEJ0?=
 =?utf-8?B?bkhWNjY4dmFWTWhGakEzenRnY0krajZFbnBYMkZqQWg5dFR1K2NHR0FhSE5z?=
 =?utf-8?B?K1FpU3hUbVdhQ3BtdlJyMVpXRUV4ek52Z01OOVduSmlDd0dnY21HYyswQ2FI?=
 =?utf-8?B?SHFVYXZkU1c1cWV6TjVFb2J5Z01zcklDZTFDUFVnVW5BL2liY2hwMWRSakM2?=
 =?utf-8?B?dFA3S2pVV2VuRi9JSUdObXZEaXFaSjNtR3hTbS9Fdk9KMnNKczg2c2MvaWUr?=
 =?utf-8?B?NmVGdWNrMTRIRmJxZnVWOFZzQVRVczgvUmtKQi9tblRKQkhQM21qMFB6ZnJ4?=
 =?utf-8?B?VXFUVWl5c09abVZlWE1ZY3kzdXh0RndJQ3BxeFNpUy9LOFl2OGhTSkk0YnJa?=
 =?utf-8?B?YUp4OFdYSmJEWms5RVFwN0kxQXI3ZWs0WWZoMDBUZ2YxcXE1WlhJaWJMY09m?=
 =?utf-8?B?VUVOS2poeWtRc2FPTGYyWmVieTE3ZEEvamRJRVNOVGJLMURhSEdmR0RXM2gw?=
 =?utf-8?B?aTl5TXVsd1cxK1RjdFE4MzUwNmVtUGFPdWhoTWRxY1B0cHVYc1dDcDczTSt6?=
 =?utf-8?B?YWZBZWtnYUNnZ216R2JNVWp4bjlldGUrS29ZdmlNUmFRVktIOGRZTEVvbi9C?=
 =?utf-8?B?blU0VW1Lbi9aTTUzM3M4eGh2c09qVFZJTGZaaks3Y1AzTmhHM3NNZlBhQlV1?=
 =?utf-8?B?TktVK1B1YVdpRk1DVW0zRGlLck1ydEdMS1ZOSW0xTVBYTWVMN2ZuM1J0bjd3?=
 =?utf-8?B?TWlpeWxzNVFBa1BDaEM0ZXBQTXZVTmNOVnk5MGNlVlplVllzck95NkxXd0pB?=
 =?utf-8?B?ejcyWHB3WE9iZ0ZMb1djQjJvQ3ZxV05JdTI4TGw2YUgwQzZTQlRkRU9RZ1pM?=
 =?utf-8?B?K3RtK1JMS0RCbENia2VyY3d0bS9oeVlHRHJvNTJ1WS9Xa0Q5dzRYWnBHdDla?=
 =?utf-8?B?UCtuclk0VTNKTlhiajM2K2dqRkcvZWNSOTdGMld5dE43cEw0bnIxVTE2ZHFE?=
 =?utf-8?B?UkN1U1BtT1pzWWRWRUU1MFVCdkdpc0d3UjNlUzFsU1lpNTdtMWZJeUErRnM2?=
 =?utf-8?B?cE5lU1RqckFsZkxUcUgrdFY4VEZrcFQrYUVGb204WitOSTZMeGpxNGplZmI4?=
 =?utf-8?B?TDRDMzc0K2FxUDAyUk9HQ3o1Mmx6VklCVFVDQWlaNGczalZVNmJDblBRdnRO?=
 =?utf-8?B?c3l5OUNZM01JaWpKeWtBbmZuUTVlVEFuYkswQW9mUzNaZ05Oa2NjYisya0Ju?=
 =?utf-8?B?Q1BORkdkSHdScXczQUZDTzBrV1RSTEp5WGdUYWVxMk5aSEllV0pFOHJockZE?=
 =?utf-8?B?RG9nWDYydW1yM2pkSDJ2V0VwZDgxU05yUjlkWUgwNWRpSFoyMzBJemMrMmY2?=
 =?utf-8?B?Yk9NTlZzZzZGOWI4OERSTy82NWdlck9yRzlxb2xNRy9yTVYzZ2RvbFhta0NM?=
 =?utf-8?Q?BV6x2QeYHg1FwENvc9nLa7J0WpKKouxq6OrOV7w?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb42a047-b579-4788-d5f2-08d8d9fd5780
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2021 02:22:19.2910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QQemmWNyruB2ceS+FTXOUcX5Xis/rNHYuHfbK0quA/mHjRSnyQxP6J0pJRAmL4EQy6cRPk4WzkMSkfdfxnd/JsdQav9kCPRykEx3IROqTp0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4696
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102260017
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102260017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 18 Feb 2021 18:50:37 +0100, Bodo Stroesser wrote:

> This small series applies to Martin's for-next.
> 
> This is the third attempt to fix a severe memory leak in tcmu.
> Previous patches:
>   https://lore.kernel.org/linux-scsi/20201218141534.9918-1-bostroesser@gmail.com/
>   and
>   https://lore.kernel.org/linux-scsi/20210210194031.7422-1-bostroesser@gmail.com/
> 
> [...]

Applied to 5.12/scsi-queue, thanks!

[1/2] scsi: target: tcmu: Move some functions without code change
      https://git.kernel.org/mkp/scsi/c/43bf922cdd62
[2/2] scsi: target: tcmu: Fix memory leak caused by wrong uio usage
      https://git.kernel.org/mkp/scsi/c/8f33bb2400f4

-- 
Martin K. Petersen	Oracle Linux Engineering
