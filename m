Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C666C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12FD461955
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhC3Dzm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 23:55:42 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:42578 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbhC3DzI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 23:55:08 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3jZKj192393;
        Tue, 30 Mar 2021 03:55:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Kbul+OdqP+OekPMLsbxlyQR4/dxaYndLHwbV/4DN6Vw=;
 b=pJTkBQ/X/4Dzw4kEMgjs6sZOli2h/s8eodvoE7GGK7qYFAcKVsiWnTvSfLbmH1Q2FzJK
 +3SJ2Aho+NzYS9BCf8LpiF26wdd4nIpM4eTFK5/8wD9l3G4RNnZVfRoURxVT+J4j7kFr
 JRLbXnfeYl2zygJ0E5qnbjyrtILkOVDKdX2JnfDQlUGsu2JMMIrfCJmqBAezyfqqY7XY
 FThfBNKIZ/oxMMiamFh9QehLn34pNhWabap0VZCzlP9Om5eD7qn5XQwAjNjwme8CJCkt
 zLjmPD6b9rDSpfyhRpT+LwPRlVEUOxihOb+G2uQ/9DbbwXYWTf7bUAnshquPM4MxLsNd 9A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 37ht7bdq4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:55:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3iXTT039487;
        Tue, 30 Mar 2021 03:55:01 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2043.outbound.protection.outlook.com [104.47.56.43])
        by userp3020.oracle.com with ESMTP id 37jefrkt1f-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:55:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nv1cH8qKkuBdXGVjIJyW8RUnyxIc01MgV2LDRxVxihu22kXZAb4oveETOpozvwgxDggQH5n76XlhmwFhlTjrFfk5OuWPFwmPKLvN6en2tDeq3P3Yl87Ye7w4qAKWRL/L7iXNmiBPt/QzNoAR68xT/xJMkGFkX1owlgznRidcia45ynHBUxSLPqMLIDQYV6vOuWyjsvUNosE7ZSxqG5AXQBbBf4a/q0Qc/4dh3vU++LHYik1GWopwHa0BbVaeom6ClkNrc/geURCK57Z+ugYDne9tlMH0CWixh+3AMvwiN/V5yK7WoHcN/Z1egU2nUKh253Gwd/s5iZTtdSPr/7QH8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kbul+OdqP+OekPMLsbxlyQR4/dxaYndLHwbV/4DN6Vw=;
 b=YXrPNaaVGkHgQ4PaggbkijV0dY5uBS90U1akjz2g2MzvrCg65vWG/D1bYvEBv+ISS2DtEPWAI4+vjJGsY/e8CPd6rRwA0a75Fiwb3okdUisIZPeNOPamJ6EOKDFWYDCAujxdrTvnfMWY7pW6/EORt2cjXMflvVPxk+0vpN4DmbckHC6x8HLPg7j0xkMNiHQswoCwCnh2/WB8lRpqyHlWr8vpmUKHEY/LyAB868d4BWkOWwnjvo1gqtfk3g8HEkviksK5u8qZm3NrlU89BedMuETDXOq4HOhJPrIduwliCMz7EQjaX1BkjDbbTwAF9Mca/I6v4curjBFnxnnfZXSDvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kbul+OdqP+OekPMLsbxlyQR4/dxaYndLHwbV/4DN6Vw=;
 b=pQ1d9sxT+2WgzDOOVSVJ1nToE+z/R0R3Tkhv9HrLNTYPBciQU9kFTtZi0TYIN10WxYPjw7IdbDOTwgEQFwsPYL2LbWKVvjaM+01oiBJJZEz/l/vJ16hvM9ECW+S1So6F/MfQY/vZND0fArHMq0g5x/98/oxoAjMEd2KtzNdmNts=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4758.namprd10.prod.outlook.com (2603:10b6:510:3c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Tue, 30 Mar
 2021 03:55:00 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 03:55:00 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: mac53c94: fix warning comparing pointer to 0
Date:   Mon, 29 Mar 2021 23:54:35 -0400
Message-Id: <161707636878.29267.12176817096806182916.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <1615349771-81106-1-git-send-email-jiapeng.chong@linux.alibaba.com>
References: <1615349771-81106-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0231.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0231.namprd03.prod.outlook.com (2603:10b6:a03:39f::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 30 Mar 2021 03:54:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 966f3172-0ecf-48a6-ebbd-08d8f32f9748
X-MS-TrafficTypeDiagnostic: PH0PR10MB4758:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4758468EDE58D51E5B3DD2AC8E7D9@PH0PR10MB4758.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R8OARY2rtkFoiqbmpCPKJWUgL+yEZOmSnOMFYGAT+1pmxXzto06tnv3evlu04bQVdjKPUqQV1YihSnjKX8NvgoVUCXnT9IcLUZsSd2ykQoNcbmpwpq8klUJk5Wa9EzCHoVC6+uTdWIP3k8qHm5FSk/fjw4j9S9wNFgMuosid1BUU3DxwPspBKW9Vh4rk2dTax2GAoFcBkyXD2Z/4owa8DAAW43zqJJSfA98ePnFo+YgbLk+2+4jSZkicIyTKDlnLhGGDrcE0FJ2fzCWhOufPPNErerS9YRDfz7xx6DR6Aa2gA03mfIUa3NSUUzkfmU+mwUNfRVyMQympIdK1F43MGpo0i1V5fuP/GGwabvLXKt+OEIwJoqIKhFuPAfVclxbzdvPfV8AusMA7C5aTOWCkePk540tOQN1GgHq0+lhSl7PsFUtpQWkbKkl2IBvJ0DGvcT5TGeTtcb+299I12QhD9ormKmp6fft2N9uz9mzSyVA8E0lBzsyiYebPoB59wD2ekYLT9BL7ffkOz3Tjq82bVMv42iJ5zrPU8AU9MZAWWc+2l8lmCyjRYF2inz0e7vTxmzPc6tJtvHG0DX+rP/uqGIvd8+QcIVApE+iXCwvZtglY/HARoABcJitx0kMGnHt9rsE+a5b5t5OMXIHzpLYhP8gmnBIF1bts/NQMFdw52rLJ574p5ysptHuSGzskWjsFlQQT964fnrXlQwN/Tc3Et69Gilrbfzv4DqleX+sUA4c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(376002)(136003)(39860400002)(2616005)(16526019)(6916009)(8936002)(4744005)(956004)(6486002)(8676002)(966005)(4326008)(66946007)(66476007)(36756003)(86362001)(2906002)(103116003)(66556008)(52116002)(7696005)(186003)(26005)(478600001)(38100700001)(5660300002)(6666004)(316002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?M21lMTgvRk1TUUg4OVBLT2dIQ1o3eGJaSllPcFJvVzk3SGtOKy9XZmJROVJr?=
 =?utf-8?B?TkthQnJMYVRwY1dQb200SDNFRkZDWjR5dzdNUy9vOUtKV0xheE1vOHhnalQv?=
 =?utf-8?B?LzlBU1h1NjJqZk1Ic2l2aVRKTExISDFpeHpYOEpFQzZtNkx4TitsUEt6YVR1?=
 =?utf-8?B?TkxvZkNXYURqdjMreEkrWktDVkNMQ3F2Q1RKWGtKT2R3UVlXMXJEVVJET3lN?=
 =?utf-8?B?b04xVkZoT1N0WTZWaC9nbnlJczJSUGNCNlcwTktoR2ZJUUl6QkJLMlgxTzZ0?=
 =?utf-8?B?clBBQzBOQjJSUzZGcFhsNFpEVXpJaEZoaFYwRFN0N0lRMnpUOFcycEV0blda?=
 =?utf-8?B?enVxUXBuMlV3N1VVVVZsekhVRmtOT0lxOGtHb2NSYnZEME96bHZnMVlSN0Z5?=
 =?utf-8?B?ck81T1o1Vkl3UWFGVEd4Z2FQVTQ4dEludXh4TDAzdnlPMElwVHNXS2NaM0F1?=
 =?utf-8?B?VlFMUURGQm5uY0V5UVNwR2JYbWpIMWJHVStyVFZ5Zk9TbU95WUY2TFBhcUNK?=
 =?utf-8?B?VThUbjVoSEprRWpoZTRIRlEvemZIMmRnNndoY2laMXIrRFBtYWFOMSt3WWh2?=
 =?utf-8?B?M3VMUG12amFPWDRjbWU4SkdwRzJHZ011N05Pdk9LTFE5cUZFaG12SklkMEgv?=
 =?utf-8?B?ZzhFSFJZRVVCSkRmaTJWOGszYU8vYk1UOXI4VlR0d3BpbURuM2ZxZ0w3OEc2?=
 =?utf-8?B?TkxWdElIbFdNV1hUbUdsWHFXazVIZ2F5d3RDYkNCd0ZCNjhZMTU0WWRRNXZv?=
 =?utf-8?B?M0tWU0xJTlQ5eWFybzhFOVl6Z3NJVStNcTE1WndFOCtnNEt6RldWRWFhWS9Z?=
 =?utf-8?B?RTU4VEdGU0wyS3psRXc1emp5bC9uZ1NnOHI3Y0N2WG9adjB2UEVnZ2RHc1A1?=
 =?utf-8?B?U1NDYmpBSUlhT0ljdWVhNFFLSzZ5M3N5dG1wYjJwUnhSN2UzeGV0dzFRU1hT?=
 =?utf-8?B?Q2lVS3hmOVlsc3JMdzJDWVBDZUI3cWUrbDhZb25OWVVIMENoUnFaMCtJdEZr?=
 =?utf-8?B?YnZobDlmT2o5WUdVZlVRcmkxUTQ2d0RvOWdWWHpoTnlvb2p2RldGUkY5aHF2?=
 =?utf-8?B?ZGxDdWdxSzgrOVJrUlBMOUNremR5OHE5enhHblIreVFOYnUwQ2NWeWRJUGFt?=
 =?utf-8?B?ay9GTS90ZVk2aXdjZjBRM0ordSs0QVNxZmlXblBBdWhkTlpjem9adGFuQjhL?=
 =?utf-8?B?TlVhYzFrKzByK0R1QXg2RHE3MlZjeC9meHFLaXZjYVRKOEtSUldFM0Nod3gr?=
 =?utf-8?B?blF4cDRBVzI2a0ZRd3oyTm9VR2VOdFFCYVE0L2o2d1pCY2dwTTFHNE9Ydmwv?=
 =?utf-8?B?ZUNyS1MycnVNMGl1M3RndmJicTk0TFpnK1JmbTdpaU82aVBQdmN3V29lSmxu?=
 =?utf-8?B?UGtpZVRubFRPTXFucEQzQkE0WmdXVlRuT2hKb3ZQMlpVdDVJc0xQQ2FaeUFL?=
 =?utf-8?B?enVhWE1tTlhKcmVWV3NySWFGK1Z6TzUxdWdUMExhN1UxK2tvRloxSHhmNm90?=
 =?utf-8?B?a1ZISElQYi94SGtXdktHeEFOT1hxNTcxekhKRW5wb2ppWjAyT3phdVIwTTl4?=
 =?utf-8?B?YVVoV3pGeFJNaDZCSTlKVEVaUE5nTW0vMndGbXVkdjJXejkyVWcxVVJ0V2Z3?=
 =?utf-8?B?YUJLajRPWDE4M1d5R3VKeGk0OTJraDA3R2F1cStPMVZ3ZEUvbXdGYzFqMGNq?=
 =?utf-8?B?MUkyNUZGNllMYnlLYVcvZmFrSGhacHJBbVgzNHYyQUFZVnkvbURJRUdiZHhp?=
 =?utf-8?Q?VPRbbhWr2+EtKluGwDT2v3KomuwRzT1l3OCnwvY?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 966f3172-0ecf-48a6-ebbd-08d8f32f9748
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 03:55:00.2216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZlQjaZVnqmG5HkxfhRtMiMSTg9REI45jeHjmt7OMHZ0SC6mSIrbOHyc4sD7EE4S0LdZhNPb2UMwYDxYFoo1k20NIJZ0ea9QaT83+eRU8YQY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4758
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103300023
X-Proofpoint-GUID: oZd6n5GR5n1XL8AZP9vrxxzvA9SG1xVE
X-Proofpoint-ORIG-GUID: oZd6n5GR5n1XL8AZP9vrxxzvA9SG1xVE
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 clxscore=1015 mlxscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 10 Mar 2021 12:16:11 +0800, Jiapeng Chong wrote:

> Fix the following coccicheck warning:
> 
> ./drivers/scsi/mac53c94.c:470:29-30: WARNING comparing pointer to 0.
> ./drivers/scsi/mac53c94.c:349:12-13: WARNING comparing pointer to 0.

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: mac53c94: fix warning comparing pointer to 0
      https://git.kernel.org/mkp/scsi/c/be20b96b6319

-- 
Martin K. Petersen	Oracle Linux Engineering
