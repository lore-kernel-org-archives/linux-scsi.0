Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECD1FC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 04:41:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1785610FB
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 04:41:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239316AbhINEmT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 00:42:19 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:35132 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239039AbhINEmT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Sep 2021 00:42:19 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DNXwaE005128;
        Tue, 14 Sep 2021 04:40:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=moiD/ZNiLR9pLC26w0YeqRoHPgHoHMiguOf7um446UU=;
 b=EeC7dmBQ3HC6pOFcrHqJscRzNpE8uNJ06Rjdq0gOjjYxwBGm4zuvHznSaf3g7HTaYJKD
 q3pksI3wWV0UZEo0sbmm/gTuL+SYoGzgjvt4R98NChTrMQiIVQgng/GhBzzQJxxquajt
 7u1l3aFmSCzm9IEdAQjUzrofaUy2OySMQ/PDA3S/ZWOyRtjTFfUgDU22R7JkOetTtlHR
 tsfu94tr2WPXr8obIk4BjJGalh24rq/hSItXt4aniv7yxWTLNjpR5G1bqDsM7lMvHoBT
 xJ4VSI2Jd3RvrD4hlO4nFOND79aaKU6gyaK7yEmkIpwj/JtsV/IPtd1SFYzqNyOjZaBf 7A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=moiD/ZNiLR9pLC26w0YeqRoHPgHoHMiguOf7um446UU=;
 b=aw6WhvO3YqPvfeICAVZNYyLY+g+I75qrhR3kMygGc4twhQPVk0r8usAaSIoifqJQia9Q
 DWlam+yxcb8v1QaIjEgqTZFssGZgbxwFVjTPl7R4H3X6K/vL80N6WsROjXJAzo5+mulq
 9zlc6Wu/obYHQcsRo12TuJFW8E9R7cJFfhZuMfn4ON+c+/4MPxKIr9+UK2lqCVuc6wLn
 R0TDfNF/2HarFjGkFqwMXLUtqbssOF3qgS/zmo+waIMnH6BBH5TZYMa5uj25YhRlOCHH
 P0EiOXcLHr6n/e3KzlS0ICLzirGznwJ46ue+IneMQTpQFdPK6sVYnp+vgAiMmQ/mRibm JQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b1ka951cf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 04:40:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18E4ZRvL061807;
        Tue, 14 Sep 2021 04:40:55 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by userp3020.oracle.com with ESMTP id 3b167remju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 04:40:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=agYIyNGFNZTnIWxVP2lRYv8LYTICU1dj/f4y9x45yPxHbSP+7TAo/HTi8hy8gjAPyeEvmHr2Fg/GKRRZKTyCrSayzuDnv8qzg54jkm3fDICn79umrb/gRZtnUDarjXvP5MFUv43pyzTL9XOOBjuUe1DLhpfoUAaabQNQH7bjNFoRJsC71/AonoX+1qxI5DGKlYUY6N1j+1Pa5294kbJjXLKatNETYXGtoKDF9aVCpeF09uMzeK3BlPbEbq6Kqv7HYD2D6y6XC783xtE6L1Wg6ha9PMF//9gBZbXXsPRK4EXL+hSu8nq9PkQKKdFQIhc0e7/TnCACCuxestl4sLVYOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=moiD/ZNiLR9pLC26w0YeqRoHPgHoHMiguOf7um446UU=;
 b=K8XQNY4iocuBbZMHjAdJCUmOGDIGm9Uco+o2U40r44HzuZDctgLol2xPeOCvw9mbc1wRXxMrUe1prIGalttDS7egoUKBSLZtZ5yKQhPDWFnVU/lNmoXfCur6cTdr9qo4E0OpMa5NPGKFJk3+8Jqx2sWAghxpjaPGerhe6urt/Ny/8KGC/1Lv4Hc5jpyL6v4NoaNCZpH3a79TZ+rp9Yd3JT/faZnZBzISq3PL47XfOriI1P6+W3XL5Bc6lwvuFKpT5ZeAkDf5JDM9H4KOm7MyUwD2fXFuagGcV4x3+mLrY0fELbfXxkLw+xQ0h1uF/iy41CBcyJW8jEoj3/Pcs0KRjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=moiD/ZNiLR9pLC26w0YeqRoHPgHoHMiguOf7um446UU=;
 b=nIGWp4HbmwDctPxw9UhKHuy5450nLS2y7Z59UZV/CNv4sNhMWvsQmwXY+r0hwuE89LF4q3cNmYg4M4iKSFTKG/nIFKd9MtITdakp1D8/idH3FIi+HEZnjk7DOAz/wXS2Y2waA5jtWPANjtqV/LXKWZVEMPuubYs9nlE6y8sPd1M=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4502.namprd10.prod.outlook.com (2603:10b6:510:31::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Tue, 14 Sep
 2021 04:40:52 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 04:40:52 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Christian Loehle <cloehle@hyperstone.com>
Subject: Re: [PATCH] scsi: sd: Make sd_spinup_disk less noisy
Date:   Tue, 14 Sep 2021 00:40:48 -0400
Message-Id: <163159443486.11082.3744944742385070671.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <a2d0a249-6035-9697-626a-e14ec50ef6ee@gmail.com>
References: <a2d0a249-6035-9697-626a-e14ec50ef6ee@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0104.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR13CA0104.namprd13.prod.outlook.com (2603:10b6:a03:2c5::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.9 via Frontend Transport; Tue, 14 Sep 2021 04:40:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b67325ca-373c-4910-b5e5-08d97739d536
X-MS-TrafficTypeDiagnostic: PH0PR10MB4502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4502112B051DF3937DC140708EDA9@PH0PR10MB4502.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S7DgIRSklUujnBBIrtVweH/Rcve0J/7aZimQBHGxiQv5H05IPWsReandwQyHeNBcwd+6dUigeEVEW6Z8JNNEvP0WOJVqOccbJ9fVvAlCBgkgQOO+DrJmgLnJG6Hr+SPRmHd9RbH1Kxfk4btKe0yCIFlFN/fzijavkoJrnOcIbtSrODcnsa0giFXyawLfOiXuUAlP7/BKCeVfZtEflz0Rk97GcyA434HqjJoAD6Kh8fOYgGZRMUvyORn5Q91ven11u/TDEoTLl0P/QHwlvUZ41fnDUE2iMLSJC7/ijFSYDr9jYj6yJZgsVCRiNkaHiyexvFSs1udngGWnh8TiOLEOb1PQ6lr+wGm9Sqwjk9jZkW/UACpYfIDkZcxzOqz6G3jiXD6vQqI3Heb4sSx6vn5woLHdSbOXR6ZIq3JJCFGlr77nb8kurdpMBRUrfTz+D17kg8P7UzSP6Sv5lR3BeUNBZ5fhPhNzO4xPkyi6TgPnBnGiJ9IZcllf4cFdK8xYHkLnQ4HKMTGpgrtm890kc+Iwkhb/RKq9q89AIsyyl6USOyEkm4LafAulBxrwP3uMDiTlWuWsRtjhcB1oMEzMkc1XESEM9XK0Ik/zUi5YKHmxUK+8Se14rwrOQQAc4Y48ORoKj40fGntVv1NH1ZJhouB0tRHsd6/Q+aaEZb4/C8BEeCvaA9bCNbapl5U+SLVJzeKxq3G60BKmyxDJjKcIEQ5vwUSQXfnm3sLIzDkjdxfZiEsrsCVyHUydQsZQXt3OPwjnSslE2kJJWLxMNs+p4Fbxpxiyu0Ip3kaFcVlZb9rs2Tc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(396003)(39860400002)(366004)(376002)(4326008)(186003)(26005)(4744005)(2616005)(966005)(7696005)(52116002)(5660300002)(103116003)(36756003)(6486002)(2906002)(316002)(38100700002)(86362001)(110136005)(66556008)(66476007)(478600001)(6666004)(83380400001)(38350700002)(66946007)(956004)(8676002)(54906003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QzdoazY0NkNqMzc0M3pvZGg2RnR4ZEJVRTMrMEZJc3lMTm45ekZ1WjRIWlBK?=
 =?utf-8?B?WXR2Qno3OW43cVQ5WWUwZEoyeC9xR3Q4WXZVVDdqUnl1aGxCZEgyVXdlZkww?=
 =?utf-8?B?em5SNlVxcHJKMDVFaXhTVGpKNzh1RHp0azBWSUtXenhLck11ZG16TmJocGlN?=
 =?utf-8?B?bURyb0RveEcrTXRaZXZFWFZYdENaWkJYbDFmdkVLZWJwVzlCR3pxdXFpb1VO?=
 =?utf-8?B?N2JDN1V3WTRTdzBqS0ZRem4vbVJ1TEVOVk8rNUdFRzVSTmVmMVQ3VldhQk05?=
 =?utf-8?B?S3VNSUw1NHlwaTRDS0tJNWtkQmZBYjdFODdzTTZWRXVueXJzVFBNeXozTjYv?=
 =?utf-8?B?TUdNWU1Wek9kQ0NPb2ZKcTFCQ2JoRitadmF0SnN5TWRjdUNndjNnbkxaendj?=
 =?utf-8?B?ZWIrY3ZnbGRZemNGMHF3eXA2Q2hQd2FsTHFNREdXQjNaM2NZY1c1N3JCa3c5?=
 =?utf-8?B?K1RIMUhLcjlORHVNZVNpM0c1NUFOQUFKYVBRR3lna0R4RU92SkY3Sk51citQ?=
 =?utf-8?B?WnBXUFY2bkpEU2lVRFVZU2l1THdYMWdId1Vvc3RZRnRVQjFTSXRFSHZjVDRQ?=
 =?utf-8?B?UENudFpBcDZCdk4rbVhBazBORWpUWXNCQUhuU0ZGdjErK3VFZFBMSHp3WEFa?=
 =?utf-8?B?ay9PVldBM1RlQmx3V1RWUVdWZUJ5RERxOWVra3JhZUlYL2ZnUDNDQ05QaEFK?=
 =?utf-8?B?Z25IV1pCTExxVVZqR2o0MGtWYU5IVVdwSUtvQWdJL05WUFFKSHFUZFRocGRI?=
 =?utf-8?B?YmUySU4vM3kxbXl1bjNkcDhBZ1RWR21NeGt0RUo4MWgwcDlXY0tzNVdUMk5a?=
 =?utf-8?B?OGcyc2IyWVRUUEhDY1RDaWUvOEpQNS9tOUhBZlp4dXFEakxPSkx5SGM5Zmxy?=
 =?utf-8?B?VEp5ZHQxSmpWa2Y5T05UY1ZwY3gwUkhUa0FhSGUzMXB1cWlpT1FucXl2UlIy?=
 =?utf-8?B?WGZzRnVGNE10Y0kwd3RraVJEMm9tRGcrVmg5dDB5TU5wRTZjdGsycGUzcDZp?=
 =?utf-8?B?a2piSGYxRHA2ZXJpaDErU3Q2NFJlcTNGWXdYWWgwamEwZ1RWVkNpSG9DN3NO?=
 =?utf-8?B?Tlh0SjFxRkEzNTdTN3AyVGtpcXh6TEl0UFBMVm03dXh2cW55TmVvckkrejJn?=
 =?utf-8?B?Nkt4VmszSldxVGk2R3ZIVVV3TFR0b21CZENFVlArcHN3TzNJVEhUSmd3VlZL?=
 =?utf-8?B?d09rL0V2aWI5VTJpRGJ2WDZoR09EU2ZXNlNxQ21ScnJ2MklmaVFsQThxUDdF?=
 =?utf-8?B?ZHY1QktNaW90R2V0QnZzWlJPMHJPYWFqU01SUWo3cUxTaU1Yc2ZRS2Roa3A0?=
 =?utf-8?B?bW5NSlRCQnd5TDhlVkFzQ293SFhvRHQvNmtxTkZ0ZlN1QW14VzMvMlhlNmFn?=
 =?utf-8?B?cmUvd2ZGcTRaUXZibnVYWGVIdTA0dEhvQTRnNWNqNVdwZlRDQnd0bDNBWFNH?=
 =?utf-8?B?cmpLZW04TmN6Wkc1c3dWSHNLTEg4d1UyR04wSFYvUzlkRnVRTmd4YXhuWUFQ?=
 =?utf-8?B?V1cxYTk0aVVUb3hYVTJNV1JGdm1KWEJIRXUrSnhhVWtJWWdYeGt5M1pBeVJO?=
 =?utf-8?B?czgwTEM5OUl2dy9pTUhHb01mMURxZHpnTVV3WGhudEFWUXFISzk5M05ISWZG?=
 =?utf-8?B?VkVRNVdTREFkcXgxRHpELzhKSUNFL25FQlRQbXpQc0ZwQWhyQ01rOVlTK0g1?=
 =?utf-8?B?UTNveVBzOTZta29SSlhNeE1OUlBqSlRRYU0rTnFqdk5mSUZxTnBVREZZaHhi?=
 =?utf-8?Q?wP2kW++lB3mJQb2oZ0vUS5vnlmNSob+rfQ08T79?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b67325ca-373c-4910-b5e5-08d97739d536
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 04:40:52.5700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RUw+tXzRARtl8AETPEpQQozBMmErPAu6ihL9YcrtSIq5VPEPUuDVcUzbDT+UrhywnI6t/z6vzz25dJhKndz5eXo2lpJ9d7CWYgQFevP/PKw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4502
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10106 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 mlxlogscore=593 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109140026
X-Proofpoint-GUID: cOHBxrJd6t9VJAdFuFg92iYSwFjN3mOC
X-Proofpoint-ORIG-GUID: cOHBxrJd6t9VJAdFuFg92iYSwFjN3mOC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 11 Sep 2021 14:11:59 +0200, Heiner Kallweit wrote:

> For my personal taste sd_spinup_disk() is a little bit noisy after
> 848ade90ba9c ("scsi: sd: Do not exit sd_spinup_disk() quietly").
> 
> scsi 0:0:0:0: Direct-Access     Multiple Card  Reader     1.00 PQ: 0 ANSI: 0
> sd 0:0:0:0: Attached scsi generic sg0 type 0
> sd 0:0:0:0: [sda] Media removed, stopped polling
> sd 0:0:0:0: [sda] Media removed, stopped polling
> sd 0:0:0:0: [sda] Attached SCSI removable disk
> sd 0:0:0:0: [sda] Media removed, stopped polling
> 
> [...]

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: sd: Make sd_spinup_disk less noisy
      https://git.kernel.org/mkp/scsi/c/4521428c4811

-- 
Martin K. Petersen	Oracle Linux Engineering
