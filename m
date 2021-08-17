Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22C56C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 03:18:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F5F660F41
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 03:18:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237623AbhHQDSr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 23:18:47 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:52506 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237142AbhHQDSf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Aug 2021 23:18:35 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17H3CC3f032605;
        Tue, 17 Aug 2021 03:17:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=jGYoSjWuEEqbnoCo9u/o71R8t76pKQC+1HCpAyZ1gvM=;
 b=wVOEyZ8W7FafkbzF6ZY1gCH+4eek2q+8YwQvyk2czYE+r5VQSX1Q+5HcPgxj8Z3tSw4O
 CQpvWTupgQYT5jerB1wWuunvfT+28OaMzyl411S7+6mA8UxRNN3AN1Rd89yA38Z86lM1
 Oq1HgMZZQLu28ycZczqWIEvKlHTSz68JdY4Ry6dUKVo1SB0r+Bt6uMeD+rm/eOd/jnR/
 +Byez/tTddvUAOqU8o9/YabpV7J1kUFzu06f69crhc3VB47h/9NODEiE/Ta8gM79Vtlx
 3TNKceXihqmT9hEzX32WEGWrhO5AiQBj4TnUIyFNCcuEyyqEM8zGiDWveq4XMIbBtt6j hA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=jGYoSjWuEEqbnoCo9u/o71R8t76pKQC+1HCpAyZ1gvM=;
 b=E4fFiBG5nbwVo92yAAV9Hxqu3XK4z0dOZ01gVAbTqlQuRhOFpIf7cIKdfbgHaaxnWrPT
 hHjLsDZdOUG22V+n5v4ro29DgmTmvswWiXOWJg4XYtJkEpSKgKqX9PwxydyAYaWPsa3M
 zL+LOwrSy8tfGavxG1BFyy9/UNAycrvwFSvFK/v14g1U1IcJVnLvU3OP7K/8xjsuVHb/
 +7icbvRLsNEYAnQc5d/+FWLnSznZt8POXx0YKE3866j0B5QPjVNPjlxQJR0onD0lJyEi
 xyHQ650jNxNtw2s/OhGTwLOPSYmcMoWydWtSLJU7EkYqoGXGecls0BlP1+IoZStOc3lX oQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3af1q9bptn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 03:17:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17H3ArdW184253;
        Tue, 17 Aug 2021 03:17:55 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by aserp3030.oracle.com with ESMTP id 3ae3vetn7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 03:17:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E51+OwwCEkaqBKqTCCVe3mW3Y0lTSNVApEC+yooZC8w8GR9smn4KQLv8f/89uoXEQit+crLLphXMDEl7+yQzKWXM+Fg83zBW/lkc9dubv5bfVYyyh4V7bQKbSYBVdDEZQ826VvoJJr5Xeh3tMUCZDeVlk8E7ijgtQWfm1vFabiT/kXEUX/ggfNmpIUAnGnfKm5M0QLf/Hc3w7jLdb/MxmRdEKrRt5WRl+D/dwbxXVn1P68nKSqARBgWROnq6FTttzfEPh1q5WPRdkOycjkhceP0f6WJB39IW9c0AjcfbvtvixmiQFvjwcJ+VRqXLFkZ9tX40gCYklfzYi8FZpE5vsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jGYoSjWuEEqbnoCo9u/o71R8t76pKQC+1HCpAyZ1gvM=;
 b=Ljds0EvY0NyicgrB6FW5Y5k5V7i+GZAl23ajsrysudqft1vjTOnvay2QN/YsJp2cSZAmS0E7DlAkrVUIKMjqRdXDpqDy7hC9mTAIXn3uQuYubHkuXL8bVEdld2HdVgJYQSbcW4PxRGoyGy1GLu/gE56qhVTOfBhx4z034pB4dqH8mWH2Xrr92hvVUogzkIHbnoEiUe+ZX7Zjj+mgWh2WS0Nnb6pODoDD/MeMOTYI8LJi5YcsprVqlcoMBXG9YzRghiDECHkw9DoZ+8X0wIxzqqwekE/EnWaYY2lOaJvZKNYblXXabCv7SK2G8m5xStpMWfhprsFYdDKwrtU94pA73Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jGYoSjWuEEqbnoCo9u/o71R8t76pKQC+1HCpAyZ1gvM=;
 b=RvvIfowztbdq3MAvTkfa11QI+zVqYJqpuwoqeiUHT8ZPxSrn2zAypBKHMjmQBeLVswEr+u7FP0IYGIIfVrY8GTTe9j05wBAB+96LkfoQvuq6cwcoOleRJloHJP4HKdwv6vjFLxtOAQ0c2s3gp7A6SDkXPlhVZbsTe0s5YGYqEno=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4597.namprd10.prod.outlook.com (2603:10b6:510:43::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Tue, 17 Aug
 2021 03:17:53 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4415.023; Tue, 17 Aug 2021
 03:17:53 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        Colin King <colin.king@canonical.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: ufshpb: Remove redundant initialization of variable lba
Date:   Mon, 16 Aug 2021 23:17:38 -0400
Message-Id: <162916990043.4875.9659942193448672189.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210804133241.113509-1-colin.king@canonical.com>
References: <20210804133241.113509-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0178.namprd04.prod.outlook.com
 (2603:10b6:806:125::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0178.namprd04.prod.outlook.com (2603:10b6:806:125::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16 via Frontend Transport; Tue, 17 Aug 2021 03:17:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57174146-a8e6-4485-b863-08d9612d99bc
X-MS-TrafficTypeDiagnostic: PH0PR10MB4597:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4597FE8F72983154DA83D0628EFE9@PH0PR10MB4597.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CkZ8qlu/lya39YpaAA8d2ol8oono7+YAz1YKsuucyIuTyRqOKVQL3/S4skkbIqNkc65w6nbPwtiK8YIo1dGI3u/5gYH/pNY3FkClcCiwqSLvxEDeeUSk/kfubgfadjzPH/gctBCdRpWYysv8V6Q1aQawdPsGBGMj0SHTeoeIadCLVcsYGoIRYycTGxdF4MlJxAjhqohuFUbUfVO7ImOUS079hbcfaNb0dH5rYYkbzQqFPFZ8YeCrsbmf4hEHWvCe0Ck9uKsS4TANEFvFzrPxqBBnz255RzppZb40+kth4Z1sN7425RSETxcKEZ2IjNTv3b93SPhtHayPJf3iUT8Dp8uBtp1lCJoAdZU/vlxIW2gPO6DoNqXqdvGK+uWEQgm9Gemmm1J7/HsexhqBXIvI+dmydqDQNLe28PLjXAZhrGn2buccssEKHIr+MRxYufUneWqiU7KX3m2ke/8FCZlZtdTuG8OoulM9KcViBVPSjpALDHK0SHqBqRKIY07VnrMLYkAWnGHbiHHbWb5gDFaroPjiyT2QMuzMuIrD2CisFYJYWaoFCfWWzbkNg2C1sgJsmAzzCrxLRIOvL7LcU3GW/TsEoZYoCnqFIA89ljtbOIysmxI9rwBFB03PrS610yjRbts1H4u/q1I7/xozN7NvF2ctNlhFl3+HDKIbzIhPKc8zN10/Zpncydkl7JrlqxwVpmWvCwGt5emyPK6mcKh8II2D2PQYkrCJpGQPfGOHDdPkVQbb3q29h7YKCu3rdq9QkBOupfZDsev8G+CnPB2j0ADMOvvt1/LU0ahHD7DXf5Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(110136005)(36756003)(38350700002)(38100700002)(4744005)(66476007)(2616005)(316002)(66946007)(8676002)(956004)(26005)(6666004)(86362001)(6486002)(83380400001)(66556008)(508600001)(4326008)(5660300002)(2906002)(103116003)(966005)(52116002)(186003)(7696005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGFqTTU2MUhMdWdRWDBvYU9pSnpORU1pcityVzl5MWV0RzVPaGRGRTdyYlph?=
 =?utf-8?B?VDZGWnpRVFhvNXFNeW0vQTNVdWpVcXIxSWFuSGwzanM5dFpac2w3TDF4Nk1P?=
 =?utf-8?B?NWxwOTY5VmpKZGZtMGM1WnBidEp5K1NDQTFXd3hlbmhYQmc1VEZ6eG56bjZi?=
 =?utf-8?B?OXZGTGNsKzZoREp1T3RJeVRUWHRNTXdONng0TWZobGcvaWRUYytvaVhEeTdO?=
 =?utf-8?B?Zkx0aUE1aFJ0TWpmdUxiYVhUUU50cGJBREx5ZU85SGtMOXNZWm5kT08zMmlu?=
 =?utf-8?B?aUxlb2tKTFl0eFRNOUphOTd0YWlNVXd4UTBtYU5ENmI2d05QN2lzdjRMY1lB?=
 =?utf-8?B?UFVmT1FGaWRMelNWTGdyemFTSzV2NUR4OFdPKzdGbDVMU0xlcXJ2MytzcHdN?=
 =?utf-8?B?Sk5IUGNubkt3eW1LZmRRWlJOM3NnUm5RY2J1V1hiY1NoWm1wZW9PRzRBeWNR?=
 =?utf-8?B?SlM1NEIwSnBFck44L1pndHllRUlFdjJNdHZOenFWUVc3WEEwWDRpNDhVY3hm?=
 =?utf-8?B?TDl5STRnYmFJZHZtdlBGcTE2QTd6djg0dG1JOStOVnExcHR5L1hoYkYzcm1F?=
 =?utf-8?B?eWtwcG4ra2xqa2tVeEludGFUMnVieTFLeWZkem15M1U4Z3IxVkpkZzNsWDIv?=
 =?utf-8?B?eTFlRjRYL1kzQ1BXYmMzd0VBdFNXSzMrUkxNNnpLVmx6STE2ZlUzK3lIV0tr?=
 =?utf-8?B?Y2xUSnpEeXVDY0FjaE9VTTRFeWFndW96d0lBeDhPN2srSFpvVEZnVysvaERM?=
 =?utf-8?B?czc3ZWVrOUc3NGR1S3ZpM3BTaUVrVkJ6L2JtbGdJM2thTC9adFRpZVBhemlu?=
 =?utf-8?B?dFJXcUxaRCt5VzhueW81QUs4S3NLS2pkTlBuWStrTEJVbG1WRVZ2MU5ZTURy?=
 =?utf-8?B?ZGNEbDJ0SWxUYms1RGFmUFo0ZFdBVlovTTFrL0gyckJueE5TNi9uSzlaQXZm?=
 =?utf-8?B?L1hoc2hTWmhiWFhnZU40aWhZWW9lT2ZveHJMeVBzRGsydnBwMndQUXN6b2VT?=
 =?utf-8?B?d2VKYmphSXdPdWw5YUdja2V6ZzNMR2pWV2ZEcy81ekJsYy8xczZLNnFJSGZZ?=
 =?utf-8?B?Ti85aDU3WW4zZDhzNGlwTXZaMVFUaDNyRGJZTzNRT3JRRWxISVlUek5iKytJ?=
 =?utf-8?B?WGxkbmh2eEhadFNoYnFlWDRCY05OMmJNS0puNit1ZXpuUkRZQUdYNXNFeUVw?=
 =?utf-8?B?U0VOSWcyWEk2TWRnTkRVRGV5akJWV1BlVkhNbnZvMnlJQmRqK2QwZlo0L0VC?=
 =?utf-8?B?RDhDUzhSRHd4Vlo1SDg3RlR4bFpVeGZjckNMbWdLZHV0Y3VwQWVSYmRmSytn?=
 =?utf-8?B?YUpJaVJNYUdFWFFxOVd5akUrYTVTY1F1YkJ1RFlTWTFMaGtOaWlqWGFyL2Rz?=
 =?utf-8?B?V2MyT2x4VC8rVllDT3dpeFVGZUV4OGpWelBjdXJaNG9DV1RpTHpRRnFoQzBY?=
 =?utf-8?B?NnB2MjIxQnZyc0ZDTUNHU2lEcStBT1JHSXdheUhkYThWUWhpMFArZFNxYzlM?=
 =?utf-8?B?RVJJZEVkL3MvRE92MUw5UDVvSnlPbWZvZ2hSM25OSUtvMjMvcEJ4QzZ3M2NU?=
 =?utf-8?B?OXdUWUtxbWpNalBCZ08wbldxTnlGUFpMNzBkblB3bW1hNmxnckJGWjhKWU9l?=
 =?utf-8?B?ZnQwWi9oc3MzV2dWdGljR1lmNitPM0RpTXVTMXVOVk1icjVFcWJPUzVocm5X?=
 =?utf-8?B?cjVpU3cycUljRm13MEZqRjdGTlBwZzF2bHRCbHdwdFQ5dE8zNXhQNGRubzZ1?=
 =?utf-8?Q?V10YRlz5pCDu64llOlVKOrG7N7lq1hcnhaMPNVn?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57174146-a8e6-4485-b863-08d9612d99bc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 03:17:53.2142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SpvT7SY2i9u5BxbANLOdQwjCeywznxFjjddyPgkSc0ielTUzWX5+oQugs1+ZIwsQuyvNEZR9g8TSx4hQ6z4r6r8BXsQgR3sH2VFMViMjyYw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4597
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10078 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108170019
X-Proofpoint-GUID: Y4z3D6XWF9eqfwN1dun8WUrByw1aDF-f
X-Proofpoint-ORIG-GUID: Y4z3D6XWF9eqfwN1dun8WUrByw1aDF-f
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 4 Aug 2021 14:32:41 +0100, Colin King wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable lba is being initialized with a value that is never
> read, it is being updated later on. The assignment is redundant and
> can be removed.
> 
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[1/1] scsi: ufs: ufshpb: Remove redundant initialization of variable lba
      https://git.kernel.org/mkp/scsi/c/102851fc9a0d

-- 
Martin K. Petersen	Oracle Linux Engineering
