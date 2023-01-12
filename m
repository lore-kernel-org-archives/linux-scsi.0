Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 625BFC54EBC
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 03:11:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234039AbjALDLW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Jan 2023 22:11:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236177AbjALDLQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2023 22:11:16 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEE7630D;
        Wed, 11 Jan 2023 19:11:15 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30C1IZCT025348;
        Thu, 12 Jan 2023 03:11:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=8GPTVGzuA/sCofz11rSyuE5EE1sqUGilkwm9hCB0fjs=;
 b=pPDMHTNa4p0QTCTUwwoWhAckm3Nbdpa1irfUfeTLCuzet383FE7RhvshMiaQbmFs8imX
 1y3bvyEc+LXOeGboTp2svmcHB/YCR2bTKSIfkdoAsLZZRCBVBUwIL7p0zuFYzYTj/0I0
 7jKYa0BEh9xsLNX/XZm5GW5zGACagNENWPrMnHvJfu6b3LyQrQuQukMPXo94xDma1jnB
 nqq+W+LnacuEM/BDOEsNwxGnrXaR3LGeeJVbhlCo2mB9lUtALi6g/mI3/enN83Wa7LM+
 aEZFoGEPCbhOZ7XzdfzPpI/h/3paFmC4uRyb+stbKKZgKJ7VbfmNhBWgzCD68/BVYP02 4g== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n25k7gajy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 03:11:10 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30C0a8Ow016100;
        Thu, 12 Jan 2023 03:11:09 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n1k4q4mek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 03:11:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UoGXHWKjgPwhX8KsSzHoRQmGPe+OJGL5lYigu+HnmmBRVhdn4yCG+Ep0a85+F2egExCeq99uMwYrGdjYjQIbN0sBhi3E1JlIjRbD7rhJMxfsbsVvn7aITorS+5vW37m0jYIIxBW5AaQcZyaXpwmLji45RB/jqPLHyHk1c+L5o+I+R6gdNIxmDWpT8fISZSs3J7PFAySRaQgfebOKDijDNgBVVOX15V5MYemSUYJzkeOLV2jWHZzU9tt1mEQeg1ADRxyWKgDf/WIFVEJBDzA5SRMer3ZiXzMWLN3EUYHmLwADCORHSfUKLxV2BkcOfpQ2uNwrwmbxdOa4rFv0HdnzuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8GPTVGzuA/sCofz11rSyuE5EE1sqUGilkwm9hCB0fjs=;
 b=TqOKtTS5bSclslrfmk9dW39z/25rKJKumATUGIsXOGXXS/JCAhkv6/4YE6rNamvWMZzNNlclw4C0KLPxdFzecKlKiS7u4KwawCczSAhEFpk2rXX7qAk5WbcjGaQ48hyPe4AbEniBOJtM3Lt9asM2lKaqQj5ruCxHLkgFWwxsOSY74RLXGXdXYr21bhe4NYKjrvqv5WM3uWwjmTytgZRrB5z53CPKqN6X8eyIzAxiSXJCIRnEN82SX2ZhvARN3TzIswpdH1SU7NX2pqQU2aDTtKd4bmVa3cafAUed7+DzmacI8GaiA5cZPi8ViX//C9R2U6u347oLXlTLA/CA0vzmeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8GPTVGzuA/sCofz11rSyuE5EE1sqUGilkwm9hCB0fjs=;
 b=VHQiTh+EnnbjASKSYEu6FCyj417ntOwUSmvVEr6i6jT8X8Qg/ytljjjRLYbDTumFmmz3fZaTfNWRyvqTHtyO6Ai+3EUkHzsfpPglJIpmv5Ppuncwgc0ryVt46iLDUjoyd0Zln3VOidVDjQ8DOvI2Z7DEz3CyVbslgaeZdQRAU8I=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM4PR10MB6158.namprd10.prod.outlook.com (2603:10b6:8:b8::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.11; Thu, 12 Jan 2023 03:11:06 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6002.011; Thu, 12 Jan 2023
 03:11:06 +0000
Message-ID: <542545e8-2ba6-8221-16ab-17872ed8e4a7@oracle.com>
Date:   Wed, 11 Jan 2023 21:11:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 5/7] scsi: target: iscsit/isert: stop/wait on cmds during
 conn close
From:   Mike Christie <michael.christie@oracle.com>
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     mlombard@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20221208031002.106700-1-michael.christie@oracle.com>
 <20221208031002.106700-6-michael.christie@oracle.com>
 <20221209123202.GD15327@yadro.com>
 <5282eea8-6648-4573-057b-7350955b2368@oracle.com>
 <785b5eab-8e2c-b5c3-e710-d16abe2a2154@oracle.com>
Content-Language: en-US
In-Reply-To: <785b5eab-8e2c-b5c3-e710-d16abe2a2154@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR18CA0004.namprd18.prod.outlook.com
 (2603:10b6:610:4f::14) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DM4PR10MB6158:EE_
X-MS-Office365-Filtering-Correlation-Id: fcd016c2-da05-4e4b-6576-08daf44aa55c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DP+4/hNgb23DoGFNFz2hwbs8JCW6cr0XRY1SmvsZXaNrD+t7IIb/zEw8I1dPlC/gMtwTYphSFQsnCbCQ9YquQ9hGriGEDj1TVULlQW3E7no5i4Axz/jS1h75ImldXk1lAw+sXoPtZKqN337WWrnM0W1hvU4qbFhFHDgas3QA167178llxWV5wEXFQg6Nt28jk602LpGCqh3nwz5e6/k06mrZsC4aWEidI1eshnK4xuV+oa5q908esfA375AhZe00W1HLYVvrmZWw8cCmXc+YiFD4Sr7MY20bpQG7Z9hH/4Zc65tYvPz15AbvJJ5yojDLZcp/QreRV6UwLHI0PclRBzYrLpyEJlC+ZASQbyJV0rlR2zxTC3XOHFBnCimFQB98u07Io5FoyZuNca8RurTypwRK57ycNMTfcGUFqGPjdy55AKFrnNkfW4i1kWLRPWpSvZAQ342VuMpdUf51WQE3yaM2t3TpK/UyUYKehSat/mankM+BFIMU5qxdUemAL5ZSGiC4WAyC6KazlrMmu8+YUXZB6k9eNe1wCo/gMkQSXfSm1v+UiHKSy/AcZfqe6t96dfkj2OKr7DHGBW4LeDgJnyl2MhrzIbB18+7B2l4zPTdwji+z/J8FKEAMFzAo4/V4TfPDf6J239GgMNsl83ksmO1KkvB7AhvVEQ1C/RMFEe2FaYsNEOGEexvvuPf9TBZHUpY2wRFehOfrIsnmhyr+QnSLlYEBQWKTl8PT+gikehY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(376002)(136003)(39860400002)(396003)(451199015)(26005)(186003)(6486002)(31696002)(6512007)(478600001)(86362001)(36756003)(6506007)(53546011)(2906002)(31686004)(38100700002)(6916009)(83380400001)(316002)(8936002)(2616005)(66946007)(66476007)(8676002)(4326008)(66556008)(41300700001)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Uk1wSGZLSk81S1l6NXFKWnk3OTZ2TFFYTFdsMkdGemRKenFYaU0reFZUd2M4?=
 =?utf-8?B?amlnT3R0T1VKRE5oYjQ3amwvYkJESTdkazZrbUZ6eS82dEozWG1ZZHdHdm1o?=
 =?utf-8?B?b1B1cjFmT2FPWVFOTjdyS1hwbXlnWlIvSVNubkhVQlVEMXRZcTViY2wzbWg5?=
 =?utf-8?B?YTVmaGp0c1g0aDhGNXkzZHpNcDczUCsycCsyK052cE8ybkd4NnNERlB5UHhw?=
 =?utf-8?B?Q0VHbkFuSVVzY2Jrc1lsL0kybzBrNGFDbXNpZktEU01lN2lVL3ZMcy95UWRF?=
 =?utf-8?B?SDZmeURvMnVoNmVFVzgrclVNNGtsNVdKR1pKU0E4c3dlMHhhY1dmN1Y3V1M2?=
 =?utf-8?B?NVVVSFBUSytLQXZodDdqR3ZFekQ4bzU3bTMvVC9GdWpOcWwvWTUzMUF4R1Nm?=
 =?utf-8?B?K3d4K2NMTm1Lb3ltcDJVRmFuaFdKaHl5QnRPbzRLVHBHY1VIR1FuWjgxMjhi?=
 =?utf-8?B?U0JWTWZpdGc4eURNZUlKcFZvdi9HYm5RZnoyUEc2VCs5WVBwamxaNjA2dmVG?=
 =?utf-8?B?MnMzbjBla2ovYmR3dFFHNVh4M1pzMHVhaE03Rk9XekV1WXVEYTdCbHBhVDF4?=
 =?utf-8?B?VHVzeDBIUjRJblBCREVUYXJHTkRqWUF0TGxvbmdGOUtOaUpVd0xqLzloS2dz?=
 =?utf-8?B?T2YyVXErMnBhVm5aZFpTZ2hlRlNiMW12SHdkWWx6S0VqYi9xYnpTTHB3V1I5?=
 =?utf-8?B?UXBNM0tJY090dGNkcmVrTkNnSkZSWC9YdzhnWi83cDdURk1CUHBVcDJLcEtr?=
 =?utf-8?B?MWtYUW9HbnRiY1NRczB2bysrTWxiWDlJZzE3V3dTZW1rb3R4K0Fxbm94RG1M?=
 =?utf-8?B?Wkw1NnRZajJhdFNuaEk0NWkrd1dwYU9Xd2pHeGdYYjZYNCtwNVh4OVYxeVQ3?=
 =?utf-8?B?SHZNZWdUZlQ0cVd2Q3U3bmRVRVJjWDVrQm9URkhQa1RnUXNGYTg3N2pVU0pu?=
 =?utf-8?B?Ukk5YnBQemFXbXVvRjZUTEV6OXRjWjk1KzRvYXM2MWptY3VXRjNDZ3k4MjhS?=
 =?utf-8?B?NWJYUklZanRXR2RIcVV2ZVlEcUZ0MUo3SXVOQ0NCSmVxSHp4V0JTSXQrYlVB?=
 =?utf-8?B?bVovVjVEaWZtc042aUJtMGFvblNUbG5CbDE4RWFqSU9hZVh4T1kzK0Z0Qzdj?=
 =?utf-8?B?UGxaYjEzODAxMmJIQkJEN0lnNzhJYlppeklYV29mTk9sNnA5NGU3ZjV4Rk9o?=
 =?utf-8?B?bk5OTHBIaFRZYytVSE9Ma0d4L1gzYWJYRHFPN2RkblIwOHhRalZuVG1RUFZX?=
 =?utf-8?B?dzZxRkRtZE82Z0RNeVpOd25ja2tibmhnT1UxUTdYMW1Td2NDYXNqTHRheGF4?=
 =?utf-8?B?WFdDRkdCTGtFdm5aNmIvaVYrcExIRkk2cEJkQmN1OTNlaUd5QmNkY1JaM3B1?=
 =?utf-8?B?WTMzazJYWXY1TndWYjJWdCtHb1QzMFlxbGxUUmFDTWtkc2J5eXdDdEh3NXl1?=
 =?utf-8?B?QzlQeEhoL3h0QXhvbGhGUUxzOUtHSklmUG5sZk9udVRuV1BTTHhlSWhaZUlF?=
 =?utf-8?B?bUZNSWovQWpwYmM1cjd3WTY4dlVWRXVOcnJoU0RPckUwdmVvYW5BZms4ZytP?=
 =?utf-8?B?U2lRdG42alp5a2IrMW5hUjkxd2hjWkR2QnJpc3NxUk9sRXliNy9KMlJZeG9z?=
 =?utf-8?B?OW5SOGlVcVU5czlTci9mQ1FqcUIrZXBKL1pYM1lFLy85WXpmZDYxdEd6ZEs5?=
 =?utf-8?B?SnNrQ3dVSDFoSm1XYjkrQk53aEZTTmRXd1FMVG1HSkRpOW8wOWwwRGRhaGd1?=
 =?utf-8?B?Ri8xN0RiNEkyZkpYVGNJM3o2TkR5K3Yreitlb1VydWhidldMZjc1Z2N6RTJk?=
 =?utf-8?B?V1FmN3NndWQrWm0xdWtZR1FvVWRhNUJQNjNiRVVZRVl2dW9EVHprMjNvS1NI?=
 =?utf-8?B?UGREaFZRbUtHTU1yRGhvUVcrb2JHNHpvQ0o1T1k4THIxMmFoRmFoQUFlSUJU?=
 =?utf-8?B?anNqTlU5WUhQMmRiNEtNZnNQNDhGK0pGaVlPM1g2STdLNk5tejNMV1NIem5R?=
 =?utf-8?B?WnM4cFZrNWVseTBvdHhTYVE0aUxJTUZlOGx2N0dtYjZlUFoyczcrRnd2dUZu?=
 =?utf-8?B?UitabHhMekk0enJ4ODFZK2FZS2J2OTNMM1pkMDdXYkdLem5JTjQ4QmZ6Ujd3?=
 =?utf-8?B?ZGFzQ1F3clY3dlBVSlA3c3BPNVYvc1ZDMkY5WXkyOEhLOUt0QTlFTS9VM3J6?=
 =?utf-8?B?UUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: W30rhXJ3l415mbwMHZ7sX5OJpfzmLYUTOu2SqtDxHpz8SMKdsONhx7mc8gxugL6ZSYrHvZzYaTov42eDxoxPpWOY8sdScdmZSSz/MdPHfG0mdK5vXhpinDvJkoqoj5PylIbalCy4jFcAWZYWdlUzWtas5XiRWpAd2GU8E81xkOsl57dhvvdhY2h+XXuyEhSlSILoo6RpkcmLfHLM8QnR5wDUgC28Id7UH2kGHjlAxNH96HmyXTloXU7fOKFvqF4mNqTM2srtYinSDwV8wFIMhlMGTu/wdXvPLj16yuwzpI+5tMqAOzBfs33Y8onq2FmImeOhhK+PeA8Zaox9W+A6EhgjnkF1tedV0el+mUbRyWJS5T+iJJ6LA32SMVebk7hfmI9JAAq/lgN0j2VXqtcnCrsSMRsaR5lXIyjlAlsFkNF8FgAEaSOqFPPmegzgOduGsifoENFIZKWTUhL5mWgzvQ0onZ+uQ9K5v+7yrMxoZTKvN10QxztZOHbG+ToeSHxEDp48zrmPUgK+ffhoEzLCmotH95rGwt6HkU0DfP882E+d0n73CiL51AKnKeFqXOhFQykfRAC9Fue2xamH4+3CeXWG93KwB9bKeBxx1S7HrljHZfyyI2Vv9ABBLP8UHnE2t9upAbsi+VgLY4omzYwe8/u+Carjc49CyZhLb1TE4X3xOzX3ELk++PJqDQuayKqbukfwSlSc4DSc7i8cX620NYtphK+coNRSSA3oNJW7Wh1n1URUZv6srpUHVQfWneRdPA5qSA4AY//vp64wMcYW2xTfwR5ZcpFgA22pzsgpmEwBzNTHmb9BwXDakxA/gwVH
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcd016c2-da05-4e4b-6576-08daf44aa55c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 03:11:06.7586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ftFa4K2PPdnJzhcPVTq+fZnF1kfj2pbq6rANze/ePHeuLnVpHxFmD0wKfIQuNM8qT8dvRfvSgwNfPLyobR3mhAmzchO2kg5L0lh6pZcBhDE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6158
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-11_10,2023-01-11_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301120019
X-Proofpoint-GUID: indfRAwhRgc9DdcL1ToC1T8ebIk1IREV
X-Proofpoint-ORIG-GUID: indfRAwhRgc9DdcL1ToC1T8ebIk1IREV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/10/22 7:38 PM, Mike Christie wrote:
> On 12/10/22 12:48 PM, Mike Christie wrote:
>>
>> When we do iscsit iscsit_release_commands_from_conn we are:
>>
>> 1. Waiting on commands in the backend and LIO core.
>> 2. Doing the last put on commands that have had queue_status called but
>> we haven't freed the cmd because they haven't been ackd.
>>
>> Are we hitting an issue with #2? We need a proper bug and analysis or we are
>> just guessing and am going to mess up.
>>
>> For example, for isert is the bug you are worried about that we have a missing
>> isert_send_done/isert_completion_put call because we disconnected before the
>> send callbacks could be done or because the ib layer won't call isert_send_done
>> when it detects a failure?
> I tested this and it's actually opposite and broken for a different reason :)
> 

Hey Dimitry, it looks like you were right :) After I fixed the use after free
with isert, I was able to test the case where there are TMRs running with
isert and the connection closes and that was broken in multiple places.
The updated patches end up merging the isert and iscsit command cleanup
and wait code in the end like you requested.


