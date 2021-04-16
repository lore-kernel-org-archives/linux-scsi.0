Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1B10C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:51:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B0E6610FC
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:51:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238075AbhDPCwP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:52:15 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38924 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237810AbhDPCwL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:52:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2o0VR047302;
        Fri, 16 Apr 2021 02:51:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=MUJtw2KbGCU0geTQ9O1iMNx67FGRIEy/lsjda9o4k/Y=;
 b=KwCHBzxi+6TAjoCj0G+BXyWOSEmCzgW6N2zCJc4tq/WbilU9fE68o42xgurfFzJTPjDx
 JNwapVOdLJyVYVSJE5AahJCjbeTmpvcO/ei0RBeJ7pvmglKSM75psuuQGR7iFvGW5RLZ
 TYEEAwii2ebc0JkoaD2jqRKEiDpLHXZ0bFm7ebus/aERBeOmlaYZzNQFeeEXTXiibk+V
 7P+Wv7OAkmuF//fWO7lC9JXYp0JQ47RQ/imfSWNRGz3V0md2Ob4Nzgb/CHg1vSe6JHgZ
 dNGFvaAAX6e5ht/Ub6U6e0n5VrxvADS4MwVVam6Vo2Ttm5WBofX6eehBuG25/Ws1L3yg Jw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37u3ymqpm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:51:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2pcrH044945;
        Fri, 16 Apr 2021 02:51:42 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by userp3020.oracle.com with ESMTP id 37unswhm3s-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:51:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I3oNSuuj4TrhRe9ChATseArIxu0aDf0dxr0wQeoHQzXRM7CVySFuuzwodp/aTj8QS1t1XECW5qgAcKoIxXS3C7iwY59YThSYm8iBBEO7Yrk1BiJqP+g10El6o69TO2o9vmZCUSDL38/Anwqd/riPtGp1CAn//xFGVlhtzkKtR5bARCCsASbEhFJiI30IHnOxZgAgpB8z2/FhJ7gl2qMp/kZeHfwI0z9FJSNqvXbEZMAdg4zjp8q/VrxNmPMcHcYpQv1h5BzWIF5dF2NGyLNL/bk3Bt4eLnBG09ug6s+LZUVC8euAET0XPejSUew8qIfznldt88iZ7VgiFToQniqU8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MUJtw2KbGCU0geTQ9O1iMNx67FGRIEy/lsjda9o4k/Y=;
 b=ShGoyNjwSAaG3qpxaz9WXYPqZES7Q3be1wfk0NP/twMTN/fLgGVQGyWR2I9c+2ZwI3H+8zKxpr3f9Yfjbn0hkHWqgCNHzK2FeCppJ0O6xJoKnByWWZWoV3vjCa2KYoe3ejT+ew0Ym/0hNzoBzfr8145I/PHw5UxV9pz8rpDpf2kPzvb4P4RHTYaA9lvwniJz4FZxuZk9Gfj0TjN4wcDJOPJRZ+5UNiYjfWZNYdEmMwk3zBXbSqavSrMt4wJIOmR7ZZma6Bi2ynmnDuRu6HHvY32tXmfahACzZWYaLBjdjXgx1tmxOmO0iW5HJxixr5kOhV4ErumuOQqTos9ASIttVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MUJtw2KbGCU0geTQ9O1iMNx67FGRIEy/lsjda9o4k/Y=;
 b=vwXOgmKri0/7zEKcBNArEj4FC+D0n+oo4dz6LfNXAa5aYG2nvZVqIHp8aFoCdjCVNW1BWHLezkEiamKybRvrHHxC4PZa3/DHC0TaR4GOpl4zF4+7FL9/+tAZcnJxePrndMDo1MU6iMqf479JKSd++xf6oxUWAG7ZgWrMhzvoGAY=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4568.namprd10.prod.outlook.com (2603:10b6:510:41::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Fri, 16 Apr
 2021 02:51:33 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4042.018; Fri, 16 Apr 2021
 02:51:33 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     sathya.prakash@broadcom.com,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com,
        suganath-prabu.subramani@broadcom.com, linux-scsi@vger.kernel.org,
        sreekanth.reddy@broadcom.com
Subject: Re: [PATCH] scsi: message: fusion: remove useless variable
Date:   Thu, 15 Apr 2021 22:51:11 -0400
Message-Id: <161853823947.16006.5435817838859356006.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <1618207146-96542-1-git-send-email-jiapeng.chong@linux.alibaba.com>
References: <1618207146-96542-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR11CA0023.namprd11.prod.outlook.com
 (2603:10b6:806:6e::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR11CA0023.namprd11.prod.outlook.com (2603:10b6:806:6e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:51:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 446640ab-a1e9-4210-aab9-08d900828b77
X-MS-TrafficTypeDiagnostic: PH0PR10MB4568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45687FCE9F5834314A6852468E4C9@PH0PR10MB4568.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:854;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CHbTEEDfSCFNGMZD6Td5cQNL2yRxUzCGUmV0+sAw2tt28KLcRsHWhujoDKLhtrBwNu9w1dOPE54KjlYcH1S+J/QKIFUF4qsYYWTHqss7PjYlp52esV8Ito3Azivtq+p6fvb7LQD+aQfjgsCT2imY5iJ2o1P0W4i2y9tiRovxiH/+L55/mKZfyfvXUqAteGm3LwNjEll7tECgKYOgA5ZK2si6RMtHgyu7MdHzxIGbx0Kw+71PSYBgo+n316nigNA7qAXpuMnkQ0hmR8OWFkeT1/6YhEPxNxsDtef/yUaYjy9tGZLrzCy43hmOOJdzVjzqZKDn6cSMZChZVMichR6Elr0uhTIeRLzS9pv8eXFquGiMcID0/ngGreazzDrGEdTphSmAXFtOmIruWD+63WV3Lu1bgRkR/TNha8vEr4VcZdJcHuUzO7V5kNawulG/G/pWIR8WL/4uU7cektMwPxTjCPAUJwTrj/JehpqaO4g2J4Y5XGx0YmKqYG7IxCYvSE3+HK4QAFnO+CszHoOIQ0G3GDXudp8btMWBbUUyNWbmaGFCBc0piAlnBDBAg8KAK14es7mSTfuWxOLeb2HvMYgfPZjjRk010y17eN0I3h4/VI8WMQgXlhAL9NLHGvnEsM+rG8kkTKmPlkjezpl8+5n2ENdZqv7hxgTek/5IW5JdeusuM0VSL6VR8pWWzFcOQm3Qcm2DCjMn9EzPVBGlTqEdvYiOQQZI9AaNmun3XMFqNQM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(376002)(346002)(136003)(316002)(103116003)(6486002)(5660300002)(478600001)(26005)(2616005)(956004)(8936002)(83380400001)(16526019)(66946007)(66556008)(66476007)(86362001)(6916009)(4326008)(8676002)(15650500001)(186003)(38100700002)(38350700002)(2906002)(36756003)(966005)(7696005)(6666004)(52116002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Wkl2Y0JicG5neG4ySW5leXk1dVNaODVqNnRzNG9XZjJoMWJxVWNKT3dWYkts?=
 =?utf-8?B?amg5S0VnVHV6UkIrVDZ6NmJIdnpNem45dTdobkllK2IzMUxFdFlGVnFvY0NM?=
 =?utf-8?B?OVJ0bjVPWW5oOVdHSWxRSmFHdXJ2WklaMk56ZlI1Ykd5aEtYWnJuRkdqQzdo?=
 =?utf-8?B?YXBUWXFnUTBvQ05ZMW05VlBnR1ZqZTZSRmtHNDFVaU5FMlRsaS9Jdll5TjNJ?=
 =?utf-8?B?Q1F6N3loRHBNajRkYXIyTE51RVUrRFBLK09jSGxFZUlkcmhkYi9yL3Y0d3hu?=
 =?utf-8?B?UW9uK1NkcWtDUk1nenNSRitSN3FyMjErRDRlVndkSytQQ0pkeWJ1SCtZNEQz?=
 =?utf-8?B?SWpFWmNYZ0p6aXdMVHJvM1lSL3orS0N4dGxDTWYwbE5ERG1RQms0cFRFRjE5?=
 =?utf-8?B?dEdyQlNsY21IdFgxL1YrVWRxcGxUSmRKZEFQbHZ6Y1NGbGRkM1B3MmtROTE3?=
 =?utf-8?B?WG5MS29Rc1RHME0zZDFYNm52aDMwYTBqSFJQaTVmNTU2MnhubTJuZmJoYXJx?=
 =?utf-8?B?bnVBUWNyeVFQR3VZM1FZY3Z4WENPbURLTkQ0T2lVS04xOWM3WUtnaExSbUNx?=
 =?utf-8?B?MnNNc1JHdi9sQ2lTMWZqYU5NTk1pVDJrS2JHNzFMYUo4bkwxaXpQOTQzWUt1?=
 =?utf-8?B?aU1rR0dwVGtqemR0K1pSaXRYNDhhUlMvaDhvaWYxL1BXM2x4YUFDeXFsSlRi?=
 =?utf-8?B?Y3dmNlA1N3BmQmxBS0tOQjMwNjd4K0c2NHM1cldlYzVXeHlQSXZpMTJDMEJD?=
 =?utf-8?B?Wnl0enRSNnBkM1ozY0gyVEk2N0w0Qy9UUVVQM1VCK3dROUQwWGM3b214VlNL?=
 =?utf-8?B?VkFHSTRDTjMwYXlnV2NIendPSDg2bkw5UnY1L3JPRFM1djBUQW9rM0l0aXp1?=
 =?utf-8?B?UmZBYlFLTWYyYWNXaW5Rdml5aFY1TUc4dG5sYWtFS1Vkb2ZOMXhmNk9kMThX?=
 =?utf-8?B?akFveFdkeWpHVXpvN0NXS2I0SjRBT3Q1anppSk5jSU05WklMWi9uVjBJeVFO?=
 =?utf-8?B?eGdZdVZvYnorNEZOR0ZwaklnOGYzSDdzeUw5M3JGZEJuR1g2SHQ2akwxOWdw?=
 =?utf-8?B?NzhVVS8rTUFFMkdraEQrMjJnMGg3djFRZHZxVGtIdkxVdmdsdU9uZzczMERE?=
 =?utf-8?B?YSs0OGhJTnlMYTJvNnhqNDQ3aWJSaTdjbjNUc3VpMHZ6UVVYTkxHNmMySU81?=
 =?utf-8?B?aERIeWVNYnFBR085NVJ5bFpPcVM5aWk2R2VkekR3SDVnd1VUZ1AyTGgyajk4?=
 =?utf-8?B?VVFFNGZmMTJKaGZQbXpEWmVBMjh2eEtLSzdTWnVRVmhWeDc4RGJKL0RFRDRk?=
 =?utf-8?B?eGJhYzRzREZkRlZ1VWJyK3g1eWVDRFJhN3hWV0pWczZpbllhWSs5SXovcFZJ?=
 =?utf-8?B?NDlZVWdrQ3liS2RqcnY5TWxSa0ZBRXNmejQ4Q0VVNXkyWGxaS2dza0grejVJ?=
 =?utf-8?B?eVdzQVBDWGxWSXVxN3kxbEdxUWVtZ0xBM0MzNTJZNWluYlNWS0laVlBpTkFQ?=
 =?utf-8?B?cGV0Z0VDd3NjUGNsWm9VVkhyR1RZQU52ME5LSHlXVEsyUkRRQkZSSG1uSXJH?=
 =?utf-8?B?ZExsUUN1dHhFNHdHK3FIeTQ2N0phV0k4UlVkakNOVTZZMDVIdTNvNlNOcVcr?=
 =?utf-8?B?Sm84OGU5U0FMeUsweTM3ait3Z3pMQmtrY3hEaTFCbmJXckRZR3RoWlRqcGcw?=
 =?utf-8?B?a2s4QVQwNHNYbnFzYnpSUUlZTDZTUDBvMzlyajRpamZicmtnT3pRWU52RkJu?=
 =?utf-8?Q?y3HxxPS+3D4+VbsV4QGTAiZV5VbrETyJAB89H4u?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 446640ab-a1e9-4210-aab9-08d900828b77
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:51:33.7221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vrrusKvwAr71NQ2rTcyWBL0q/JkCoc8X1rymoRw6b58jp5ql0KjH6gsex1oiZTCM4InMzdKEzaGsSW8QI5M9yCCkac5bSS90CuIjn5eXUbk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4568
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160022
X-Proofpoint-GUID: 6vuQJ6d_IkmGLil30lPyuPaxN98l_nkt
X-Proofpoint-ORIG-GUID: 6vuQJ6d_IkmGLil30lPyuPaxN98l_nkt
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160022
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 12 Apr 2021 13:59:06 +0800, Jiapeng Chong wrote:

> Fix the following gcc warning:
> 
> drivers/message/fusion/mptsas.c:783:14: warning: variable ‘vtarget’ set
> but not used [-Wunused-but-set-variable].

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: message: fusion: remove useless variable
      https://git.kernel.org/mkp/scsi/c/cf17ff267880

-- 
Martin K. Petersen	Oracle Linux Engineering
