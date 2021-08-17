Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12FD9C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 03:18:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF61660F41
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 03:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237491AbhHQDSn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 23:18:43 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:38478 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237028AbhHQDSb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Aug 2021 23:18:31 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17H3C19B024671;
        Tue, 17 Aug 2021 03:17:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=9e+Oqb+D31+qYPfvMQtGQk0JXZudLs7PiR/4i0UBNvk=;
 b=h4eH6opjZjBkCE/JfQqRnM0pC4DEsxOwj8giZkgKOV7eKdGxtYDk1z8ggWA0j1JbCkQ8
 IP0vibfiURiK15yT10VDQy88FVdnDavGmyPeEiatsN939Ec+cqOlR8F8ziHXL7KO1+DZ
 GSR+RBXPSQr05TKlYIBao7pC6JcKfifi482wdR7yg1hGW7HSZ5ydAUhT0y9sVoaGX2H0
 TAXch9abQJGLZYcZ7x2j0FMxqOoBR3Zo3UrJ8WJl23Fi55aOA7lv7Ncftq2cVAFKwe0z
 iRkdZra8qT0eVE2nRXD/KY8DqVjPjUC+W+iUeqSssjXOHNhKKP6GlD6H3CjSsIMUOm5T FQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=9e+Oqb+D31+qYPfvMQtGQk0JXZudLs7PiR/4i0UBNvk=;
 b=qbIhFMB9kX6ifOT7sApbIo4hqgGGZ7My/q/75F5+dr7X1y+W54viGeoBrKEmbu3K/d8S
 M0kMf0UEurw+BBT8rxW+qdQNylixY9/RKmRn7Bl0jHDrcr6vRyDvX27fYLyZ/ti0BPMx
 FzdMH/ZyfYDtIIV4AWVvG/cTNnX9ZVLfxEl2e8okxFEoPb8T4NfyPdZLAF3X01eXV3l7
 FyKuorDZ0sk54KpSSNc0Sm0zoXLNHDg1tvwja0y7r2US/+yuWz/FWPqnpdKlB+4jb/da
 nsBuWTlPbkshJ4veaO4/Qo5ChvAhSh/2vQTu3L4Ff4W9GHGNhy0ByAEF17qkBvxomOJD 3Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3afdbd2y3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 03:17:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17H3ArdY184253;
        Tue, 17 Aug 2021 03:17:55 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by aserp3030.oracle.com with ESMTP id 3ae3vetn7c-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 03:17:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IUNNnKkGgho0FRwKKpuTEqqb/iHyiErZqDFU5FKV2ilZ8pn42+ymF/J5Hy/pPQIwdnF+EdU6YXMugvlqBN2rgAts3oDAc/uQL0PAfee0v2k9bDxQyXEc6bgo/VNmjDN3/7z7QUxGPUNbmatc0b3nevxkO4FOo/cBV60NEdEDjrLO3Gzs0PS5aD73Xtcw22yfFyP2TKNRhh70OY+apugjJ3tpSHUCuo1fHq1myYW84xzSZ/YSa9knxn8pVXQEEdFRTlK7YqCevvyo2Gj7Xf2/ON7/7n6+7IjnwCajZI3I2dr8log/mUWvbedniU0B3bXIfGvhSQTxLuK0G+7Pn31O9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9e+Oqb+D31+qYPfvMQtGQk0JXZudLs7PiR/4i0UBNvk=;
 b=cG0bYsRIay6HqDR8TvMXGyqCnhtQeBLS44dd0mLSQ4SkLrleLT9EW713WJSMLq3NLUcWIZLzpdq8medMw3IVKyYhPWrgQvCmof4U1bM4H2/mNQG6ljEfZ4SWyamiWobjohl+0WcS0FQ1TcLJXr9YZ0Ia9q9u+RmxUFDyAE0yqR4gM0wjoQS05PCfBTE7PTbpy+/YSwltTkGZLuHfX8ktmuxDP/nMnVwFwYXLZ48p+UkQdzQRzi6PDYhTO1PSQGn7w8Z7hs1SmXbmV+WZbf/nycB9U+cZtnj9VENizqS7tzXEgRrWliTbxFhrj3/lr5rNw+NU9y+l1cbjGSSdQ5e+CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9e+Oqb+D31+qYPfvMQtGQk0JXZudLs7PiR/4i0UBNvk=;
 b=YMiOxjswbtgVYUEiKERmQvPraX80jJp/wTaZIiDwdm2mkWchE6IKPbwGB8k7Dju5LiuehasfjsGR2OWmpI8PrhN2iojAOf4VPhg8b/pYwoeZczQky4AX400N1E6CfMZAjkKtMY3YkBpKDcJhaVjuGME8fo1frKlo775CaKtn9uA=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4597.namprd10.prod.outlook.com (2603:10b6:510:43::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Tue, 17 Aug
 2021 03:17:55 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4415.023; Tue, 17 Aug 2021
 03:17:55 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2 1/5] scsi: core: Add helper to return number of logical blocks in a request
Date:   Mon, 16 Aug 2021 23:17:40 -0400
Message-Id: <162916990044.4875.9161466810744866235.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806040023.5355-2-martin.petersen@oracle.com>
References: <20210806040023.5355-1-martin.petersen@oracle.com> <20210806040023.5355-2-martin.petersen@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0178.namprd04.prod.outlook.com
 (2603:10b6:806:125::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0178.namprd04.prod.outlook.com (2603:10b6:806:125::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16 via Frontend Transport; Tue, 17 Aug 2021 03:17:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4020cc03-d3c3-47a4-de9a-08d9612d9ac1
X-MS-TrafficTypeDiagnostic: PH0PR10MB4597:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4597992F8BCBC111284170C28EFE9@PH0PR10MB4597.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /afUnAXz9txuwo01y1mOmUIW44DPemUGDI4BzwM2rIfB/aVI83NE3oHf0pPmVqEWBk/5dR/FoxgU9InRx6A8tEaKAfpMAFNi7jhNO8D8Qjar0+ji786AmC7O2quHIHVeHLrzg01GXBNXDsNxePppZ8VHjXCL18iNIPLNtEx7hasTEviVLvKiIwAUiE9Q2C0ocazxQlxZ8oiaHxXSq6R2rAMUoApdgC6tgIRgRAhwpmrypKlQH0xpN8hXQewjG1VI6QWNDCi7Llc/6fw08lD3ph3EvW2wFspmMXQ4ftkkKjbjEeIsgFPO7+UjQ0FmR+ccPtHmVWe6QQgkprTVYxki4ZxAYIrlGfqcteb9rtnz74SMpYyvvrMkK/Vc9vWtXu/rdA5It2y5qkPy0if45xUvehqAh11ECFeFr4dtUHMTXUhoTGU/ZueeJStGNnpcXUecDhynhMoPAxU0YFPkJtHtNu6c2y39B4YpkyZitmZINfQ3is20aaBq6aYZFgfpwSFIoFcfcxyCWtCQJmKr+Y9+jVOL7t01baJn0ZcTlRht7AJD39iazTRQkXWsbK07PcG7iyKqHdkwIjRHBL+INVMsrREShrkkAXN1LApm7L2wbHNdgmCyjVZB5R9uxrq9vcDqr5mdOhORI5Il+D3WrvCvzd53Jwrm0iel/4DbVXI7lpVuUK9nqEuKRRJuGcRmj6XfKkf2bqc1KXWG1EjwBwG+MCaAOkQ2jURUTMlWzNd+bZy/OomKcdiqBfrG0WnwQd0YLDqeF6/QvlAjxhk2yEjgpMIuPaeAqLuNRIxFTorz26g6XZr9L7BVi76WX9kiBlw0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(38350700002)(38100700002)(4744005)(66476007)(2616005)(316002)(66946007)(8676002)(956004)(26005)(6666004)(86362001)(6486002)(83380400001)(66556008)(508600001)(4326008)(5660300002)(2906002)(103116003)(966005)(52116002)(186003)(7696005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SUk4bk84Qk1wK0ZmcDMrd3drRjd4bXQxZXY2WEJ0LzZ5eVczODYxOTc4K004?=
 =?utf-8?B?ZGtHRFp0WE1QcFJnbDJWRXlFdElxQTE4eEVPYnNRSnRZWDJpZnRCaFJKNEtB?=
 =?utf-8?B?dWx5NndnOW1JTldtR0NxNXEzM2xUczRWUUVTUjBkR2xKMkVmbnJOMElwdHpT?=
 =?utf-8?B?c29zMEYxZ1RxNlU0bUtublJZUHJINjZQOGJCelVyTzJ2S0ZsU1V0YUpFc08x?=
 =?utf-8?B?eE1VNWhET0E3V1c0UlRrRmFQREJ4TUxIVGEzMENnT05aaTM2Q2kyNFBtN0NQ?=
 =?utf-8?B?L2ZSSXJHWlFTWUhEVVVJVVUyaWI2UjNRdURYa1pzdkxzUjJzdXovMjVnMHdP?=
 =?utf-8?B?QnNwL0Q0L2pZVndNWUZRdmVpRmFnVG9iMkhHVVlRS2tWTW9FTXJOS2V3R1Fl?=
 =?utf-8?B?N1FaRWpUWitvWmorcmNhbTdQS3IrdUpSZGpHOVNuR0JzQXJOZmNpQW5VL25V?=
 =?utf-8?B?VXVxUDdma2lQcUtOVEEzRk1XRUNEU2JFMFcwY2Fqdy82M2VPVGRHZGRYQWZU?=
 =?utf-8?B?NEgzME5lekM1Z3FUUkwzbUNCOFFyYnZoZGQxOEQwYk9TSGV0UC95QjZBUlVT?=
 =?utf-8?B?TjFtQWpTUGprVUgrVXlESzJ5TkY4d1RBUjM5R1A2SHNuWXkzbzVHZGlJcG44?=
 =?utf-8?B?cG85UlJuekZkc2ZlTkNYRWNheDBGSzhXSFl6cEVaclhGZ1d2OVV0bWVnYWpu?=
 =?utf-8?B?bGY5OTgxZVRQMmRRT1V4MzVXSTVkMTBFMVcvRnRuZ2pXUlFUSlJSZ1I5OEtw?=
 =?utf-8?B?NXV2Ykdac0FaeFo2RURBekdZYlZ0Y3Y4NHVKQ0dIRGpFaDhyRzVOWldkZm9Y?=
 =?utf-8?B?RWx2N1VQUTY2OFFia1d3MU5Ja25BaTFmTEVmd3hocFJpNlFrWVlCOWt4cFdU?=
 =?utf-8?B?TmdGU0xPalpIRFZJY1lmVHRqVy9YWnpsc053ZXNWa0JBM0wzaCtzeldJUzJ5?=
 =?utf-8?B?QXdBTFpjaTR2ZDRSRE9EWXh0MnRFelF3WHNteEo3cXRrcmxoazBoWi8zR2ZP?=
 =?utf-8?B?K3Y1SFhKN2JmbWxsZWJleENVNHZKUjd0aUkyTzlSVmJnMVZsNFJoRHZMcmND?=
 =?utf-8?B?eE1sbldFVTlxVG9Ga2lUdTBMclcxSGVrdmFRS01SUlBFejhUZytJdmhOVzRy?=
 =?utf-8?B?SzUzazRDaVpxYzIxVGg4RDgvaFlmUzdqMzRnVGNVNEcxZE1PcFBoNWdWQmNy?=
 =?utf-8?B?Nk5PK045TGNLQWg2bWQ1NHRBWk42WjFTUkJSYkh5a2drTnlZQVh1N3dFQTZU?=
 =?utf-8?B?K2ZBWC84MFFKeWJrTTkvbnovUEFJRFhMQ044OHZFMWJOUGN0ZG92VlhwbXI0?=
 =?utf-8?B?QUtvTG1ueUlsekM4enlHTlNHaTdNOGJpMGRxVllsVmtxQ1dJMHkxT1E3bzhS?=
 =?utf-8?B?Y1BqZ0FOSjhSSU5WUHUvNEJwVzI2Uit5K1VDc3hTSnpxaGx6aTdLUWN0Smwv?=
 =?utf-8?B?a2NmNUpteElMTWRWZElQcXFIcHptb1NtQk1aQzltNWd3dFV6M0Izb2w3NktH?=
 =?utf-8?B?MGlud2pZOC83WTFaeTU5UlFIdVFUelBCMW5hTjM0clFvbGdPOXVXR1NnWlcv?=
 =?utf-8?B?NzEycmFxRUk1L0FPb2Z1V0RDelNxOFFtMXUwM3hwUHI2bHQzdXExUU13aXh3?=
 =?utf-8?B?VDlzcG5aT2lpdzQwajUzMTlMN0MzejM2OU5VOTRVdGdQU3VOaFZIN05DZnpR?=
 =?utf-8?B?VzlLU0lOMXZ6TFcxOTI3RVhQSkN6WmhjMUY5ZWN2VlZYeVlkUjRiRWRDb2ow?=
 =?utf-8?Q?LpYYUaJ4ZT6iId9qoSiusN0iVQJMZCqCkf1/Clq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4020cc03-d3c3-47a4-de9a-08d9612d9ac1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 03:17:54.9526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fEdFwG5AA7nlDdStgd9CDpq2mEUI4S1bOubUvWYvtY6J7lmOWCKITOdYA9lWJgNbXZW8ADNw06zZO1v5/jnEpEryAercNnvhL8zAEnorTes=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4597
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10078 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108170019
X-Proofpoint-ORIG-GUID: A39FfyZgo8fXPXBCjG4ak2jTX-igUKup
X-Proofpoint-GUID: A39FfyZgo8fXPXBCjG4ak2jTX-igUKup
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 6 Aug 2021 00:00:19 -0400, Martin K. Petersen wrote:

> 

Applied to 5.15/scsi-queue, thanks!

[1/5] scsi: core: Add helper to return number of logical blocks in a request
      https://git.kernel.org/mkp/scsi/c/6a20e21ae1e2
[2/5] scsi: isci: Use the proper SCSI midlayer interfaces for PI
      https://git.kernel.org/mkp/scsi/c/4cc0096e2d54
[3/5] scsi: mpi3mr: Use the proper SCSI midlayer interfaces for PI
      https://git.kernel.org/mkp/scsi/c/92cc94adfce4

-- 
Martin K. Petersen	Oracle Linux Engineering
