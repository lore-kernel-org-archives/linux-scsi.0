Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1439EC11F66
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 04:10:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E594261D4D
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 04:10:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbhF2EM5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Jun 2021 00:12:57 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:59322 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230416AbhF2EMy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Jun 2021 00:12:54 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15T470TM025165;
        Tue, 29 Jun 2021 04:10:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=UKh2q7kCLpk4Mklsn2xoWWPBMf3PBoXVSGapW2H6IUo=;
 b=sC0+lKnF5GR5nTYM9/m8yp9st63dR1GGGdGI4N0N/bdELX3prbP/HNTMsfHBx4+e2c6r
 Yk+Dn9+5ZZxdzivakRU+lpNNsjcvzc+Lgr0KOlmOhWHANfGo8phKcoX0fKSOz604h55b
 mGdxmSUEjqTWVLqpzk+tmJTjMt20ucqXVhxX8GvSXdfa+T7h94fTTOEASCKIM/ii70Ha
 7smBv8GQwblFAgj4Zm2ZIWMBQYwiR2GeH0Eei+ytNYWSXmLfq1gdaZWl/ufEPua5wIq3
 KfPsb0afpGhTTMLk8QYPwpU5vu6SbsmlSC0/aiJnUiXigrgh1FlJ46QGZiRGP+7iLXYy Fg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39f6y3jfg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 04:10:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15T49o1U150565;
        Tue, 29 Jun 2021 04:10:19 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by aserp3020.oracle.com with ESMTP id 39dv24tfcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 04:10:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ibBIvijtUjK920ICHmjBVGHG2cZm3sbYLv7ho8LUY0APVzwfFOq9bT3abC7dBF7pV/vymB9nKyxCb9naY2g6yfw2GVjr6jZ1o21sqs26724W5mKxll8smKW7tNwYlbYZLgejTBUxJAnF/zUYn7NRAHwJK1r2BIE5I+8HabStL0dPQI12Q/l/VqGMuTtPtejP4W4KZ5riihmTt/v8MfzUzAO2adOcqDHm0JRfnEptS6dI944+49xgWUrBBs1rO+5y0GfyNFsaxXCOSeui8CCwQ2CxP8FdL9+Jybcx8T81My3STNoA7iubZRs2hsdoCesURJcLEtHK0B3ZU5i/P3Wwtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UKh2q7kCLpk4Mklsn2xoWWPBMf3PBoXVSGapW2H6IUo=;
 b=B/gBHu9DOi6nRlTF5BXakG2Awq4vaPIjcNeDWCU6jw06Gol6sPnhhJrFvZb+allTbogAhzbxBx4NmmCay6rVZom0tLgb5x6ITP5mqUqWWdTjtWoFPDaqdPZe3BhrYHxK8A/GLwNVBoP4TZYWWg6HeEy5wHUmJlIUsKvjqOff05o1zzl+03LXWqQ21EOTt+EO6lFy8EcoQqzsbyc4VBOM4mm6WRyNX5WytMfenkdoxRkzTOPfH4NK6Nd8I7EwyhG5K5A/OiW2ov/8jrCWhttgWl9Qqt1dN9Rzo9UkdpGnWCAF5vquSQuZFdw/90SNAgEj5LSSD3LtAioJPM8cAPNsFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UKh2q7kCLpk4Mklsn2xoWWPBMf3PBoXVSGapW2H6IUo=;
 b=L6KrqpiU2pAzDc7VwmLSDfqWz4NltaZdxyArjBwUtMWOhRgErdtoa/n7GkBdfvE+B8GNKfB0VCXmZZAsjUf4SrElMX0ltYRAlDAnv2hE+lPLYagrrP18DuFrkQQUDbJTtp21RuQFgkR/kciIK3Kl4QVI14ImSuaH//voi7LoxmA=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4711.namprd10.prod.outlook.com (2603:10b6:510:3c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.20; Tue, 29 Jun
 2021 04:10:17 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 04:10:17 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Ed Tsai <ed.tsai@mediatek.com>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: Inline scsi_mq_alloc_queue()
Date:   Tue, 29 Jun 2021 00:10:03 -0400
Message-Id: <162493961195.16549.8668492655157666731.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210622024654.12543-1-bvanassche@acm.org>
References: <20210622024654.12543-1-bvanassche@acm.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA0PR12CA0029.namprd12.prod.outlook.com
 (2603:10b6:806:6f::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR12CA0029.namprd12.prod.outlook.com (2603:10b6:806:6f::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Tue, 29 Jun 2021 04:10:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58107d58-344b-47e1-370f-08d93ab3cd58
X-MS-TrafficTypeDiagnostic: PH0PR10MB4711:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4711E39147B581A25AF780688E029@PH0PR10MB4711.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z0iVyDuMQgJOzlB+VRfTKIVrKHDPdi/O1UqrE/D6/ns4NFCcI5JvQ/M4Okp1Gsn8mRIwzTFMiQR3sBZ6kkjtPbOXoK7CrVJORjSvoh39BQOcIOFoCo5+dpHwT3ErT4WG3+hieAukYDtZpSYSeyewRzOfXgosJfNE4wAuFqoPpWzAU1EpqLS9qaCucEQXJzepJjgK4ZH+uNt5nihZqTkfQt72VKhq0K6xs3E8WnxcCGDUfNw9kZPQetS+ZtEyKAqn0AFu/EuWQsSPLIJAzvIVgjGaCxX57lDrtQJSt4RAkyeEWWf/gClT7vyzNMTTxAq98B6jpSB/5d6FW/qbQ3K2NA90VvA16xjV44BZH3a6Adzxw9xICQdHY0TVx5aTI9IHYBcPc9atxSwHWkMnypcgmtMmTIWOsoyXteYvdX56/RQiYoJvKDw/J3J099KVGmKD/ULXFvh1ibdwkDkVONRL4fVAd8PpUbUCxBS4JT55UwvH56eO71d/27uufvs1CPm9N1/R2EbRTfd6+J4mW3ZtncapW9J4MZ2ydbpym+EJ67wAjkOoesiYJQ0rZL1Po10KJMi1PR6sTQnqwu1EvVBdjKEs+V2OhbOBdJrpX8FmOJP/KpsTIS0qwcQfK9hRGl5qsly1nlloG2ykob1KWwdZ47xv7kY7GUn1vFOjqwEe1LK+EalrqdzVICL2v2jgJrHM7r2AlNY0qCbGU/zRvsP4R+K3GuftCVDPdbrdXPgu73NBEwHrDVUn4q9gd430XuukHsKZEIurEPEmz272E6O03ZLZSwf2ShEPhGepZWom7GOGDj7yaBAZqz4JFW4jy4VRL3L3jGHelDbFutSIXutrmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(366004)(346002)(396003)(6666004)(316002)(6486002)(966005)(26005)(38100700002)(38350700002)(16526019)(186003)(103116003)(54906003)(4326008)(956004)(478600001)(5660300002)(7696005)(52116002)(2906002)(2616005)(66946007)(4744005)(8676002)(86362001)(8936002)(36756003)(6916009)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1pRTDliT2lWMkwyOGJVd2FNTXIxUHFPUndQclVvT1NVa3NCYUxabGM5S1pr?=
 =?utf-8?B?bW9CaHVUZW9wNDFrZUExOFg1REQxdWpJeWZlMTR0eUNLVDM5NXF0MXhVUjFn?=
 =?utf-8?B?REc4OFRpMzNFZ29RM1VSaGkyK3YyQ1NFRFBpZFRTNkJUM0d0K0syeFhRdnho?=
 =?utf-8?B?MWpyR0JMVy8yb1FLUk14NW5LOHZTK1k1MmphdDFuOXpFVi83UExCY1hCbU9u?=
 =?utf-8?B?VUQwSWJjZXJ4dTNvUE1yeHREMkxrOFVNWnRDYVliYUNyZU8ydHVOcmEwN2ZR?=
 =?utf-8?B?bzNsQ0hVY0dUaXUrRGo0TXZPYnpSc2szQTY1T2g3SG02dFVKN29kTGxObSt5?=
 =?utf-8?B?WFNWYTFFbnNuOUNIeVo4bFpDOHgzclFuT3Y0Rmx0a0hjdTY3YkRUc2tyMitZ?=
 =?utf-8?B?ZjNKNVZ2SU5NM2pVRVk4clh1ZW15c0R0aW9pWW5ONHh2RHNEeFY3NzVXaWhZ?=
 =?utf-8?B?RmdPTy81ZTFDQmd0REp5cEdoWG9YQ0UvMmdma0pPVDN4eEV1TnZqZW8vK1NZ?=
 =?utf-8?B?T2VFcmxicDdxRkkxWG5GT3NveWhuc25lWmg3NUZXeXN6K0lpa0F2MW5wSFp4?=
 =?utf-8?B?Y3pacS9yeXZFOVNYTjlWOGYwN1RqQ0o0bUhtbHliTFBGWU14aHJaMEhOUlUz?=
 =?utf-8?B?YkpPQUo3bnJqclFodEx5ZDBxSU9yNHFjUFFnRURVeTBpZXZJWDlmQThtdisx?=
 =?utf-8?B?aXBlZmQ5UzBBczJPb1N3UXRLVDdPUnZvMEl5RFJyVks1alBiL043RzRBc1pG?=
 =?utf-8?B?T0YydFF0RERKR1ZyWHBqdjhGeE9qMzkwWHpvYmlVRGU3SHhCRHcxdSs1aWNq?=
 =?utf-8?B?WjJXZ3BPZEE4ZDB5YWYwR1pIMXY3MlhWSk80Tmk5RXhKZU5vc3lzbXl3d1N6?=
 =?utf-8?B?M3htV251cmZ6YlllKzFxQ1BQZWhzeEVOT3ZFLzFnVDVwSzVKemFycGYrbTFp?=
 =?utf-8?B?cHJIVnRCS2hYZXdvWUtCdERReElaWFdXOGFqRzNRWFJZRjRySjMxVWRXR3pr?=
 =?utf-8?B?WU5XVGtZMXpBKzJVRFgrbnBUZVJyRHFrcUFJVlJVVzY5WG8rWHZwQ0ZSZGU2?=
 =?utf-8?B?ajdMMlRHc0tXLzcyZy9NOWJOMVdBSEJqOTBaRy95MjR1ZlVyaEx5WUd2RkRz?=
 =?utf-8?B?SEJyUFZwTThXTVF1NERnWVZza1h1NTlEakdnN0p3ZWc2Z3BoaFhsekREdDY1?=
 =?utf-8?B?dmwrOW96VVVkVkIxQXN1cjVpbzByQTZGYlYySmUvL0hlVW5tLzVCU2Vucngy?=
 =?utf-8?B?ajQ3S1ZsU3QyM0toVitVdnYvWERvdzliZm5QQ2ZxQm10OXR3d0tCMmlhSHQr?=
 =?utf-8?B?TnhyL0l4aG4yQk0xRWM2Rk5lZHJXc2xiWi91QWNrK3l1Z0wydzU4UFp3U1Bp?=
 =?utf-8?B?bWJFSk11NVp3TWVnUDc3VXNCdTROb0pFUXZIdXdPQitpWWxTZWhUMG4wM3lL?=
 =?utf-8?B?YXRoMXI1UGY1VTdhbmJUUEZMeTYvRGIvc09qMmZzWm9hbUFJY1ROUVB6RGN5?=
 =?utf-8?B?aUtOZkZGM0krUUVJOGtiTTNaaVVGYWlqOGhiSjA2MnBKZ3Jpam9HY05RdHNW?=
 =?utf-8?B?VWZyOWVYOW96RFVxRTVseGFld2NJQ1hkRE04Q1hRblZmVjFnU3VqdGd3M2cx?=
 =?utf-8?B?aUErVzlpbm03VnFpMFM0M0hUaWROZTlzYmpZcklGWjh0aGMvZVpPTWpKVmZz?=
 =?utf-8?B?a3NsSm5IRnR2QWl5eWpXemNzdHFQbjcxMnp4bHIzMWFSUDZYQVd4cHk3NmFu?=
 =?utf-8?Q?oFwGjK6DMKS4wV8cDCHuJFAjITZaMN6k41DSqTn?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58107d58-344b-47e1-370f-08d93ab3cd58
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 04:10:17.0623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VJBAew3kjtwSF3stPXF7lpMLn7MeOPy1YBIFBZa/1z97n5OkAfwl+K0e8Y+hmaNsqOMOEABRT/TJXcoBhKXs6qoz0/HpXD8xSl14btjWI+A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4711
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10029 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106290029
X-Proofpoint-GUID: Tx9ClCm9C0dtsFyEpkuCE6arpq5Z1vsK
X-Proofpoint-ORIG-GUID: Tx9ClCm9C0dtsFyEpkuCE6arpq5Z1vsK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 21 Jun 2021 19:46:54 -0700, Bart Van Assche wrote:

> Since scsi_mq_alloc_queue() only has one caller, inline it. This change
> was suggested by Christoph Hellwig.

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: Inline scsi_mq_alloc_queue()
      https://git.kernel.org/mkp/scsi/c/59506abe5e34

-- 
Martin K. Petersen	Oracle Linux Engineering
