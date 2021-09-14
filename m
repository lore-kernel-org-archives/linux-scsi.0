Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EC83C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:44:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D25A604D1
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:44:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239478AbhINDqI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 23:46:08 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:1464 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239333AbhINDpq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Sep 2021 23:45:46 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DNXwPW005128;
        Tue, 14 Sep 2021 03:44:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=CFqroVq7uG4/6bNCxkvp0jtbtY7lXehg4vuHQa0dGdM=;
 b=c+nnYe0oQR4ByZmxwinxBZW6Sh//NyxLYJgFvDXItrIku+vyuke15bSZhqPt1Cc66VG1
 Z7rZaXEzHJMxA6VkG5oZgGrH132B+XcVpa3F+5z9NADk7b7CSYNREvWleM90EAkLhdjl
 ILONOB/UZx/FBS86WqEsficE0i1SqQN+A+lQlBlVnGS0IdKJ+FMFuw9KWKPsAj0dDK1k
 wANlp/uZk9gxbrxA4UVS+bxzu03AxgIH/7g30gwgO767Y9X9YLx8NgzBdq9HoyLFFfg6
 AK0TfwAVlrqn5yzxfIs3FO/zj9hPzncPUEYkBM7nioOJkTVw0BOVue/SAQ22/yvRBTG1 sw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=CFqroVq7uG4/6bNCxkvp0jtbtY7lXehg4vuHQa0dGdM=;
 b=FcNGLfkC/9n70gzTEjaBXED0xlAa9cw0FKmxsM53YxqnlzZkpseaYJyGTpfOagvVlqI0
 vUvcbz/WemyZNuGJ9f73NYqfWT63MPv5H4kGnlwzcZNg7A9hxWsST/4JrkPi2qEjavQs
 sjf4EiH1lNbUY1XoF/v3t+SllyazBHNdwEVQoxToY1jymG4XAeYs1mTVAJHnjPyYj/K1
 BxOqErB6x8WoVIWjfUNDAUDrvmBXawx6JbjhMS6fl2VLDi76TP9D7iftpZPuQrr28Dbh
 qpQudzzPkeTuX3QkqFD1p604849aIyrwxW28DszrbcjmK+J0rTpy2dF/WWQd67J7Dqld gA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b1ka94wus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18E3fQqw109415;
        Tue, 14 Sep 2021 03:44:12 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by userp3020.oracle.com with ESMTP id 3b167rd618-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c+tWaXYWcf5gijURUBt5B8PlfVQmQmpPGUs1PxC3WKJVCopvtxDJgdr0JYID8mhBPu6NNmVP+2TXlGRZJUDJHxXe4LHk3cK4omFKkoEStLXQ2doAncm635d3LlTC/ycTgk0l9MtlIZsjvULbPzqz1/VMrHYy1zkxLTxlcNl1SLEQEIKAlj4kLmyQOYGakMg00fKT83ujD3RljHpwbQ5zouLu/H83MHqamNvqCeoY4pkGAe/VPqHYIxOAIO5W69FzytwOd+MHRR/BlT6dKsFV/e74BiUzszTOhGwACZKQTCZD7uTMXsj/B6HUmFhEoRhV3VUJvz4ni5PaBsMcE1+b0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=CFqroVq7uG4/6bNCxkvp0jtbtY7lXehg4vuHQa0dGdM=;
 b=XI3yO+aSkzIcHMu1cjkhs6WholY1nE+/JOBYeDCriBZnfWfs10ZQmxNTj7XFNmdKs77vowUil8O8XJ182VDo5FOvCtZepMEA4XAma2h7xhwFzeSgA1LFANVJ4wX8umHUbIDeOsC9aowigUFfIv0xPgRjjoUn56YAb+GjRVB3NSX1IefPEdodM88CPlmLSqBmzZ3fQKCjjK/5SHo1pSPLDYsjRKqTnEMgJszly/SByY9xJ4zneSY2i3vYcOvTDEXkto9bSPAtYbiUIejMO234tUZSYSrHrbp4XKGFgQh72nBF2cUIYn+GYN8B7tkf/QSkMGJCexShGEsB8wlqjt7PsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CFqroVq7uG4/6bNCxkvp0jtbtY7lXehg4vuHQa0dGdM=;
 b=QktC17xMoXSi0K8RKUmq/TX2cvtRrPb1aU8vC92Tb4CW/yfLVO1Q4wfl8eVw1g00xCHtf4uQYpn2oTfbNAjIihX54fDXU5q+vM/5arFckDdw76/EYN5sFD61NLNZA4x4492ARinf0rc7wPd0iyjmtdJhxHNTvTyY3ST0ir/9HDg=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4502.namprd10.prod.outlook.com (2603:10b6:510:31::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Tue, 14 Sep
 2021 03:44:10 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 03:44:10 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, avri.altman@wdc.com, daejun7.park@samsung.com,
        keosung.park@samsung.com, Chanwoo Lee <cw9316.lee@samsung.com>,
        stanley.chu@mediatek.com, linux-scsi@vger.kernel.org,
        alim.akhtar@samsung.com, beanhuo@micron.com,
        linux-kernel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        grant.jung@samsung.com, dh0421.hwang@samsung.com,
        sh043.lee@samsung.com, jt77.jang@samsung.com,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v3] scsi: ufs: ufshpb: Remove unused parameters
Date:   Mon, 13 Sep 2021 23:43:47 -0400
Message-Id: <163159094718.20733.5363065529903048173.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210901025617.31174-1-cw9316.lee@samsung.com>
References: <CGME20210901030336epcas1p160bcf6510e1eb742316bf0b052051a30@epcas1p1.samsung.com> <20210901025617.31174-1-cw9316.lee@samsung.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0401CA0014.namprd04.prod.outlook.com
 (2603:10b6:803:21::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0401CA0014.namprd04.prod.outlook.com (2603:10b6:803:21::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Tue, 14 Sep 2021 03:44:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23ebe774-9d9c-455c-915e-08d97731e972
X-MS-TrafficTypeDiagnostic: PH0PR10MB4502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB450271BE57EF91A4AF9AF2378EDA9@PH0PR10MB4502.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lEPvS6iX6EHgqKZe0Nv+sj0UlqwRRRSTcA4uxq9XwQPBlw0LzFPRT2LJ8IiWkFdPEeziDcuLiC0w2be9ohdJN7odaAMd3/F+wSgbwBMwytjW/pcszxSmarMuYSaADY+LqPlFk1K4rVK9pZs5Gddbsjcb1CtZ49tfM5om2MD+RETAXIRGmvVpq946671ZYrGVFpbZtWOc6pM5w8HCjeoqKGrqjOufOaabdIcuL6/WCfMLqfpZvuSh8eBJ1jT5RIElVnFfe5dtiVowcTjrtUpU4eqF1MLsixTzyFY5MwygF2nHKNrxg7YNn/V6VziF2jCgAYNAmJM9anBFI5kAxA2QOg6wB9nKvYJiOHXTZy63qc8gL4w8gqhjASjbVQdxAN1NT/NxjZZUFXCSyZmVK8AkPNYGqyev4GrrV8t5q2B7etIq4lIIjxsvyaSqIhEwm0FZFkhyzls3kYX7vgucXI79u0UWBy9NPck29QNcx0oqwZHMOZ5KUhkYmxZZnwCNEBGQXn67ILF4KAQGp5YO/Q1me2F2f9r6FtzXVONhEx7GZWo3j4bb13FrupnS2mT65p0oa8gCSl3OMsVjMj8BUAm3jKIhLmUug0kJAUCR/voWR7ywPj4kbl3D27G/RAmRgXc2sJCgMeZzq+2yk47OclnbBxFJv0tKBSIuJBf7cH43xyt+JoIWsZ9s1/9mCe9/2pRv7PcEqpHA1b19Ga0P+sqkuFZkQXRgxWsIyawUB/j+DCCcTWMIJtMOvT+pk/u0wv3gkaowNL/2T/17K72DcM8rykqt45Qf5QnLoBWNNt1j9vw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(316002)(86362001)(38100700002)(2906002)(921005)(956004)(8676002)(7416002)(36756003)(54906003)(8936002)(66556008)(66476007)(478600001)(38350700002)(66946007)(6666004)(6486002)(2616005)(26005)(4744005)(4326008)(186003)(7696005)(52116002)(103116003)(5660300002)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWMzMmw3QStjQzNsK3Avb1hXWHArWkJnOXFORjZjNUFUZ0V4SFAyNHArMkJy?=
 =?utf-8?B?dHFDdGM2azJ0Y2lpTWhOTmhSU1p1VWgzajNwM0kyYXdBekpHc3RvdjkrS1hC?=
 =?utf-8?B?YXBuZlk0NGVNUW9nWmdNV2VEeVVuelBRSk9RU3JjVEFKRVRwbTB2WXRMd041?=
 =?utf-8?B?SFJaMnJCeDBvSjA3ZnFSbXo0ZXM4c00wVDd3WURIcm4vMkVldE81MVJsbmo5?=
 =?utf-8?B?VWI3WW9ZZ1JHbHRJc0NpMitkUU5QeWZEejQ4Qzk2SHBPYVZUdEw5eXpyNE8w?=
 =?utf-8?B?S3pwcFQxYXNkaWhuRW9HQXkrZDh4YS9jcDNBSmxlUHJsNC93VGdPQVZuczU2?=
 =?utf-8?B?ZzBtUDN0QkJNYlp6d1lTUmRCeEgxVWh4NUQ0ckUwbmZ5clEwckkwR1pWRUFO?=
 =?utf-8?B?RVNuSkQrUTZPNWJLa3J0ZWtjU2FOU1dJNld6QktyTDRRNkc4NXdXNjJXOUJ6?=
 =?utf-8?B?K2JOTXRsZjN1b1pvWGNHNFpmYjZhL2pad2w5bXVjd0I4UkVFd09JcTBTNjJS?=
 =?utf-8?B?SVUzeWNvQk92RmhNbWxTMlRxVGxKN25vRUF0ZUxjeXdGQmNPb0Z6QW5vUWZR?=
 =?utf-8?B?bjFRRU5uMkpNWVlhYm5FL3NwSTRqWE1MSTdCalhkZkFoWm1zSnYrN3JucFJE?=
 =?utf-8?B?bkxERlc1THhsUURNc1RMb0UwU09vdnlZVU9qRGlyaVZGbTUvTUl5SEo4cTFY?=
 =?utf-8?B?YldkWWE5bjBXNFlRUmVRclNNRnpjOWk4dU1TdlhmUjlzZVQ0Vi84MjFrLzVy?=
 =?utf-8?B?bENGUlFrQkxQY3R1NHB0NUZ5ZVhTVUVPT3pZaVd5cVRKRElmVDdMcit4eFNZ?=
 =?utf-8?B?Q0tmRjRwdXE0dEtSRGE5UTRtQ2dEdTlaTWdEOWVrR243VXlxVVpVcmVzM1Yr?=
 =?utf-8?B?bFFPZ1BMc2pLUHMzSWpqcmhWb08yZUFnNXYzc2FxVUlDVHFEMS93Tlp5aHk4?=
 =?utf-8?B?ZHhzTWNkNUR1TncyRHlHbTVtMWdPUkppY1A3cnZlbzhGODFRMmV5RVpwVDFy?=
 =?utf-8?B?c1JQNkRueVBFR1pTWmRtOW96elhTNk5NWkZQWVNNUVhuK09rMFhSZGk5eUY5?=
 =?utf-8?B?SlZxSWFJdnRWcEpEM3JiNUJMYm1KcVl4N3NMZDlUWmRUZzQ1SjRDbmdDQTh5?=
 =?utf-8?B?Z2MvWE44aDVObVBDVW0wenZzQW5OSTlWRGRXMWFyZG1wclNwS3NvTFBJWDEx?=
 =?utf-8?B?bU50bHBHQVZuOVBkWTlITFRWZzVVNEpNSW1mNlpGbVZHamQ2MVBzYTJ3VjlB?=
 =?utf-8?B?VDFoRnhRVStmZW5ZalVObkhJMGF2UWZNNEdPeVhxeWxUb0dHbkpiaGY2VmJS?=
 =?utf-8?B?dk4veVRrM1dLOXorOHpSZk1zYTdmUFhlaGI2U0RTMXJ6L1RJaFc4akxmU0VW?=
 =?utf-8?B?Y0NvYVZoaFREbzhNZXZudllPbm4rSWtxSmV5R2JxWThxbUNoUkJSeEtDWnRl?=
 =?utf-8?B?VGlIckhCZks2bU02NWM5TlV0NHFscGkwZmVKbkREbHZVQlJkZXFORWN0RERi?=
 =?utf-8?B?djc4MVdFajFISHlUT29MTmlOaHE5ZmpSTTVMOTJudWVzcnpjdU11bWJMaGQ3?=
 =?utf-8?B?Z0JscktBVzhUb3JsdzhmTXVhN29MaW9YejlXYTRIeUhaRkFnVTRKN2I1RXIy?=
 =?utf-8?B?d0R2UlZSNkh4VFZnZDZsUjFBM0lhNmJ4eUVrNUk1WTg1MVpZekdQOWhkR0cz?=
 =?utf-8?B?VlVoZHR4T21Gdjd1SlYzeXVHY2I3bXNuSjFuaU1jM3IxYXViYmExem5HMmR4?=
 =?utf-8?Q?nlOVNY5UhsnIK0ceGmeZTM0zXAPDuOa/3R0+QL2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23ebe774-9d9c-455c-915e-08d97731e972
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 03:44:10.5090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8VvQ4tBT/MGpBmbPB3Mb0Feg/BADEGB6wbv7unbxH0CSRPHDpehCOYFIAMGG27R3yEugibQB06DHcGyGDHVmOOumFNB7vLAHTo559O87HGQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4502
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10106 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109140019
X-Proofpoint-GUID: g9YQNaEntZPLONP3BWTN8geixDKPE1kj
X-Proofpoint-ORIG-GUID: g9YQNaEntZPLONP3BWTN8geixDKPE1kj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 1 Sep 2021 11:56:17 +0900, Chanwoo Lee wrote:

> From: ChanWoo Lee <cw9316.lee@samsung.com>
> 
> The following parameters are not used in the function.
> So, remove unused parameters.
> 
> *func(): ufshpb_set_hpb_read_to_upiu
>  -> struct ufshpb_lu *hpb
>  -> u32 lpn
> 
> [...]

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: ufs: ufshpb: Remove unused parameters
      https://git.kernel.org/mkp/scsi/c/65ef27f7798b

-- 
Martin K. Petersen	Oracle Linux Engineering
