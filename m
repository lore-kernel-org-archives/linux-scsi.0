Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAE16C38A02
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Oct 2022 16:09:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiJ1QJZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Oct 2022 12:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiJ1QH5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Oct 2022 12:07:57 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246BA1FCD2;
        Fri, 28 Oct 2022 09:06:46 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29SEgNPd011144;
        Fri, 28 Oct 2022 16:06:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=87R3CpuhfF9OfaDZgCAp0ntE4dwKTSLfxs+4FOTAwpY=;
 b=GOOIsQ7e4kF9ZBDJrYG/xwKWboLPZYNRzLnq3mAHrLX4O27aX/WeUOvNlD8QMGKrHAIX
 iNxjgTNhDQOu9eZeTr3cZl/899h6zFs3aR0lc3YZixYLYUORGJCoIL4sC2pfw5kOaIzf
 zzZ6nlFSXHG7cDEra0AJLbUQKmG+UJlw1326cGBGZY6gHr1R5sRPPVkXRnefPrRvScjT
 HO0F1qFDXlstepC9JjMd0W7UWzaH7+3KVIzRD6sOOklJlOLHMt9JOOalZZZNT93SFsfS
 gslWHrbt6b+IVpYsGfsMPjH4Qumzp+BLJC6ZG5vzMwXPaZB1cWbtbilSTc+9OgZLJgHa eg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfahedspt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 16:06:33 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29SEv67k017633;
        Fri, 28 Oct 2022 16:06:32 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kfaghq8kf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 16:06:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J16Ew44A8fzFQKgKquCWxcCt481fHLxR+OPLsxGe0Q18KysXI3nHC0ZiTOU9a6JQ9wesFn0lD1ghFrOw2hcH8QYsvsZtqD6iimVLv41bOcQODURH7GAkfYuPfn7NCjs2Th+5ZNx+uZSZ55tPeRo0xBKM4V6AMo65eRp34guP5W8M0mlqxGXwFfyZN1F+1x6l09V9xY1in4XHMeaTP5EhSesgE1ijT+i4Te+TjLA18Qo0bgT/QqGs4Q6Wre8MWU2b8zAMSJXoIZFMU6wLbx4GbEVCbAqGj4ykx2y+Zkb/3FKos5pI8z2z82IH3+YpGR0nIqPDWf8so0gXHYKCC339ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=87R3CpuhfF9OfaDZgCAp0ntE4dwKTSLfxs+4FOTAwpY=;
 b=oI3ZBlvlDaVmMV1mtn7zM8yCn7rptlfnAnYtt+pNszvU1hRO7h7ufheMfSkKOD2uFYDqvYa7+S1K8z+HcYLAbHb2fKKOz9vMMISjVoNqBj6962U4g23de0QAq9/6c7WL0KBz6cRbAftKLh3y8flLYQuQiHZDP6XhqzOmqBn/JYW8fffStA81h5Sy9zVZ7irRu/zALRy+I6WWns0FFmExywWNjv1J5I4yoxFr3ZwLepyFlSVannXC//EmIfZeJqyNMThyUDxgkGspkN9ejMnBIFAd9Jh/fZoPGJLdwiWcnC7zCu0q0oU7u5mAjY0vzw6KizrAbbdtAxLLvqcFluBHPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=87R3CpuhfF9OfaDZgCAp0ntE4dwKTSLfxs+4FOTAwpY=;
 b=0KLSaNPMddItPab6zMUemg0vJGiZwryhiR/PYTkDNrO+2anrkcn6oeZBWC5WzKQEN+c0UyyoGCLmBLAkacd6ib3q9dFQCB/YPlxcFLju4uNMSjio9+4IvOn5MJucgwu3qO4g5+X7G94Gt2gX8ljgaO8403j8yxvmXSgjjp/9eSs=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN2PR10MB4272.namprd10.prod.outlook.com (2603:10b6:208:1dc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Fri, 28 Oct
 2022 16:06:31 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 16:06:30 +0000
Message-ID: <370e66bd-81d0-5451-850e-50a4172ed64f@oracle.com>
Date:   Fri, 28 Oct 2022 11:06:29 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH v3 08/19] nvme: Move pr code to it's own file
To:     Keith Busch <kbusch@kernel.org>
Cc:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        target-devel@vger.kernel.org
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-9-michael.christie@oracle.com>
 <Y1q6so/3Hx9GZmTz@kbusch-mbp.dhcp.thefacebook.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <Y1q6so/3Hx9GZmTz@kbusch-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR07CA0018.namprd07.prod.outlook.com
 (2603:10b6:610:20::31) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|MN2PR10MB4272:EE_
X-MS-Office365-Filtering-Correlation-Id: 125cdb2f-26e4-46b7-280a-08dab8fe6090
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zyPv/XsAv/XB9Nr+PO3sf3mROBuw/S6SXz8DsC/LjRgV6k1usXHUjnPoMBc7G/lvRrtFu/10vnQZ6YL2pi+Vde7x2zFg4gazhEUNrgY8ExT+uJ6ah8oZO7odTQg/BUGM5MLCkOToTbv1EXUasuwwo2yI/tWcKoF8Q/+08339fNniefqFEPg9AH9Rr2PhKqUYN1mdzDRyAQMVoxzRD7XnCaJJCQzrdCS+E8mu9xXvezkEiiBAeTDZhbS2KAlD/ALyyvHLe1V+muoThWg98rd0dw9tkUGrrvtIhAKFkGxZLkanURmunp+KpIAaC38CkS4XdPDmghXA6thrPpb76MJadaXL2UB+uMBESgEu6gaOmWT8mK/ks7LZxz6lAK2MZC01u6vJvt5ks1edMOSW7QJNmou0BeFYHRA5XmQjHtWvzlD05/+/egvkTMge8afyqOypK7Za8bhSKsQ9ymm4rHCEkFZ41/RBRXQ9/Qbme4DR4Pbp3QC/Ft0Vx/J39XPYYeTwX7tp7zE5go0F7089NtWBDPylPQeAWV5bF/DcHxadmG7RRYmW1hQ1b7RhqUpwmg2r4VVcF4jJXJlL34AXIUoEIpysibajuYSnRzeDUgdjEj+bVB3QI7sIlz9NXy4cYxkx5cIwuXEmU/xT0dUkfz0mcrk3cuxx7Y9POY4ZP2DtTM5NrTtRKQ++Q3L11WRkRkjYw+IgQgomYIXqyLN4vgyDRG8/6c7BMy/0+5I0e38dAJhvydhL5y9zy/ApVPe1HLq0UyEWaz0Q6zaqxtCJmeajirKdWxJa3jtwTctmeMuOdA4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(396003)(346002)(39860400002)(376002)(451199015)(31686004)(36756003)(4744005)(7416002)(5660300002)(2906002)(38100700002)(86362001)(31696002)(2616005)(186003)(6512007)(53546011)(26005)(6486002)(478600001)(316002)(6916009)(41300700001)(8936002)(66946007)(4326008)(8676002)(66476007)(66556008)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QVpSR2sxQjdnU20vSEZnKyttMlFmcTUzUkdwSDhWcVpyQkhQWXUyTkZKTmNw?=
 =?utf-8?B?Rnk3TDRqM29PNDhHSXRPVFIzeGVzVExoL1cvS3VoRzFBcnd1aXh0SmM3Wlds?=
 =?utf-8?B?SzBxNlVJbC91S1lFa1JMZzN0NUxWY0NpY2JIQkd3REtGKzdnVU9kc2RhZkxM?=
 =?utf-8?B?a1EwWXNqaUE4QnRRN1pta0JJOXhFSkRrdHd5R3JHK3VHOHVmUFlQUEpTZG1O?=
 =?utf-8?B?bVVqc1Y1Y1FKUEtlcDlUdHdydHRlYTd4QTZ0YzlZWHJwcmJBaHJHM0dJcUZI?=
 =?utf-8?B?M2svK1NYM1lZNnhyUkM1YkFpRy81Q2NtY1F3SERrZnZhL0drelkzZUNoU2Nm?=
 =?utf-8?B?TUI1NzZ6S0J2TUs2YVhDOGZibjhRQ0ZzUVZkZk1WSG55TkN4dU1SdVpabW1M?=
 =?utf-8?B?alZQTW80TlVvUVVTczJOMnZ3L2kxSUh1a1FUc0Z0YzFGaVZiZEFKY2tYVXA2?=
 =?utf-8?B?bEdDNFJtYUg4L3N0Zy96bmVxanZEWXVBUlpsMU9peEZDYXhJek1iNCtmcVp0?=
 =?utf-8?B?NkVIN0R1ZnptRHJnN2daWGxOSmIyOExPWU9NMlI5UDZzUGl5ZnUxaDhHU2Fp?=
 =?utf-8?B?c1EyNjFpNTVCTzV1dk1hTCtuNEZYMjFOT0RaMTBObFVERzJtLzBSemd0WEtq?=
 =?utf-8?B?ejM1Y2tjcS8rM3MycFJaS05ZTWlqZDFVcW1oV3VmL2wyK2lsOGR6RWcyQVl4?=
 =?utf-8?B?ejh2bnpkZkxNVGRpZGdKVStyeTdNRXpTQUg0V2tEZVVRNGgyOGZqdSsrL2ZF?=
 =?utf-8?B?ZHAyT0kvWm1KOGhUaSt3K25XdTlmMkpuL2Z5YlpXRE5xSDdvY3c0M2hSaFpm?=
 =?utf-8?B?aTJhVFBNc1hlZitINWF4S1ZZNlJ5cFE1NlBicHQ5UWlrR1d1b2FqOHRvejBn?=
 =?utf-8?B?ZE8rSFBlZWNtOVVwcTRKc0owaHdidE4yTTVYQ0VvT3F2cTk0bnFYN3daYWZQ?=
 =?utf-8?B?RmxkbkYyaFVmSGFQdlR2dFVPclJuZUtkUnhqbDM1SThUaEIrVmFtTWh0OWtm?=
 =?utf-8?B?R2JFcnNuY0VCT3BWeWlSeWhkbzlEQWpSNDVJZjcvZFltdEsxbVlpRXJhb1Fh?=
 =?utf-8?B?MHFHSklNd0pBYTE4cVZuTlFTYkVuM2U4S2dwVjRRNS9hWThuMFB1cEY4dnVW?=
 =?utf-8?B?QWMwSVJhYXVyRndWMXJ6OHl1ZXc5dFh0S25UQmc2NTh6USt4cUIrUEk4bXlo?=
 =?utf-8?B?bytSOUdxaGJEOG5pTEw4NXpLYkRDK0xIWStaUUFrYlBRWWN0cVljbEVJMXBI?=
 =?utf-8?B?ZG0zaVZaN3E4MVRHUW5SNzNoWFBvTlJ2cWFZdEFzR1ZSYVVPTVNNcUVVNHpW?=
 =?utf-8?B?all6c01nZnRBdk5jV0ZBSXNuanZGSG9jdFlwV2prRGI2SVJLSWFJVWV1UC8r?=
 =?utf-8?B?OWdBVkcwaS8zazRTL1ZBbTZrMmlNK2ptaEU2d24xc0sxWWJmSEYvTDFhdEps?=
 =?utf-8?B?bkgvTXAxM3gzQU1tUEJWSzFXa0JPM2QrYXpFRHVHeWNDbldGQ2JoTFRLbEJ2?=
 =?utf-8?B?cEhCTnN3Y1R1dHZYY2pIczZxNUJXVjg5MFhsODBkaXlINEFjVFhRSndUbFBP?=
 =?utf-8?B?ZlBQM3RLazhPcEZ6d1pJcjcwblhwNks5YUZoV1IwbU80MWNMaHZMU0QvbFBx?=
 =?utf-8?B?MVZmbWF0M0NrYkRMQjlxZVZ2T2UrRnhSYVgvazNiSWhMNUdOd3J6SnZMbmFn?=
 =?utf-8?B?LzFrMGVRaWtzTk9SY29nRHVrUEszVjhHelhYSzZiWm9jc2NYTmlsbGdNUmlu?=
 =?utf-8?B?L3dCWlBGWkh5YVI1NWQraTVNZVVIdnQycXIvcnQ0cE15Ykg4UExBajNBSGo1?=
 =?utf-8?B?UHBKcUppcWFsSFpXWUhXQnJnM1BIRVRnNDdjaDI5VUF0ZTI1S1NxNnJicy9j?=
 =?utf-8?B?cjJDeC93eWI5QW83QUFTbDZCcEFNWWVCSHhkS0hBRWkyUjdiS1VmM3Zac2x4?=
 =?utf-8?B?eXZkTWVFVHNTRS9QYnJNYy9LZ0tyK1VGVmlEMThrNkhGS285bUNBSkVKKzhH?=
 =?utf-8?B?K0VPL2FJTHQra0REUll6elVnWVptaUFBMUtGK2pkeHFGZ29TSXBMYkhGSUov?=
 =?utf-8?B?NVUvWHFoeWt3elR0blJkemtUaCsvbDM1SzRKQUpUcEdqUzJVWW50bzBFdFdL?=
 =?utf-8?B?RkZkWXVEQUJ3NHNOYlJJaS80S0w2NzY4OVNhdHJ6c1VhWUVoSnMxVHF5Y2Fs?=
 =?utf-8?B?bUE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 125cdb2f-26e4-46b7-280a-08dab8fe6090
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 16:06:30.9016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sLph7N4dnZP85qZG9cDz4afNwiNkroC63W4TL+bMnnTvrHMUq6id1oplO7LxySSI2yBAPFIY5ySIA8HXrvhi2JoarOxxInxT5Q1CWJ7RTwE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4272
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-28_07,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210280101
X-Proofpoint-GUID: N1nlvLLMKpHmPw-5ZBCnwNaYdgwQ7URQ
X-Proofpoint-ORIG-GUID: N1nlvLLMKpHmPw-5ZBCnwNaYdgwQ7URQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/27/22 12:06 PM, Keith Busch wrote:
> On Wed, Oct 26, 2022 at 06:19:34PM -0500, Mike Christie wrote:
>> This patch moves the pr code to it's own file because I'm going to be
>> adding more functions and core.c is getting bigger.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> 
> Good idea.

Credit goes to Chaitanya.

One question for you. I wasn't sure about the copyright. I saw
you added the pr_ops code in 2015 when you were at Intel. Do you
want me to add:

Copyright (c) 2015, Intel Corporation.

to the new pr.c file?
