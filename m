Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FFAAC07E95
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 01:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63CFF61370
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 01:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237292AbhGNBXz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 21:23:55 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:45808 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237198AbhGNBXy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Jul 2021 21:23:54 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16E1HQqo008185;
        Wed, 14 Jul 2021 01:20:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=+7j9vDxFg3QVTrdvPaS88TGGvu8CI2aaghVYB1c0gNk=;
 b=THKYFMHrlS94oqHtN+R4Eo0t0NOyelMCQ1fE08XQptGZ7Bno6v1q7pR7fH2poG90MU4k
 lYOw1odvBhO9fMRqFD3Gz3mOB33fmbNXSoQJpgMhX0UHLVm4myqCOJiyUrQMnfSTGv4M
 ev2BIubWoyaYgox0YzyDNuVwQNrL64zjSwws466I7peCKuIIcOrB+xGBWJjijZjKjbD+
 3EOEfNPRc25QtY3a0IS8hyt0xNjyVPhVxFBctQ0YnDaUYlwtm53XdaXy7T0B5Favy8Em
 sPZJaGXTx4Y0xrs+6lv/5+6otO2RGjQci8q3oUUwwURzVdQg0K+Q6H5pa1QcEajqvwuK uQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39rpxrbm3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 01:20:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16E1EwCk174344;
        Wed, 14 Jul 2021 01:20:42 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2042.outbound.protection.outlook.com [104.47.74.42])
        by aserp3020.oracle.com with ESMTP id 39q3cde548-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 01:20:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=frrgy1XVdGsFqP2EbHkdtVrOI21Efl7oaY1mTrMkxxTCNbCfP3R89GaqEyhnefugDYRXjHFtusxKKJUtj1g9cIriJPmWelArDz/52P4IYCJ6l1E0TBOf9VBmCybXNsyhV0AywS+sCSS02vL4MuK/VrB1zR49UdSNZEeuPWWodXJJZfPqWJTUgTbhS79VmJNV/SEQLJjMcI27k3XPwvlwTTeQP6BObt3WFjgaX+yRPyaMWpTmMidsNWEVg9bw65ltBvYtMZzprT0hVlrOtCxJysg5pllu/ftDlrt1InUvPv3Ebk3f8PcjkZNQykh8GTjUrgnLdbif3+alGif2UJ7x1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+7j9vDxFg3QVTrdvPaS88TGGvu8CI2aaghVYB1c0gNk=;
 b=ehmjuIUAFdSpTv+GlXylMx5/OP6uV2Z2LrCuhahst2ge2fsdSdVtY/AvxXwJXrdZdAKHyMkRhDTzhp8UpE3MpQidBNuTd/vQq3gXAHIoWqVXtuyP5lDhugmHBLeJFZ3lUNT/7oI8Yr8U7jrGHzZL64YJ5gEJdLFeaL/Zq0FAzS+VfT8gEggJnrUUWG2hVo1ifGHIyPD5em9QHjFpKsNuX42kuHXpaWwPChxpbftZ1c4iomyjfOFix3ss0ZDz8NvviajAbe02115xo6LTZI+f8U0veynJzi7dAIRrVGSpNCQ9qqUsdBWpkVT9SFXEcdj+TbKo1IhIdlMG+tNYvGeMpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+7j9vDxFg3QVTrdvPaS88TGGvu8CI2aaghVYB1c0gNk=;
 b=jgZPKxYHt9cRSgaD2LAPzVQmrJHHxYI3ygpho6SoTaPPyhMP6SL7Rk68GFPhbDrmNKyJiQeHxM3Vod+amT3JuKtRStZgtKIIWtcT2G/Lby9R3bR7iC5G35+BOxINpCF8GMAhM+qx3ntlrmnsNA9Ope38uCFeY6o74fM/7oCBdsg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by MWHPR1001MB2349.namprd10.prod.outlook.com (2603:10b6:301:30::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.26; Wed, 14 Jul
 2021 01:20:39 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f8c1:a59:f070:5a5f]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f8c1:a59:f070:5a5f%3]) with mapi id 15.20.4308.027; Wed, 14 Jul 2021
 01:20:39 +0000
Subject: Re: [smartpqi updates V2 PATCH 2/9] smartpqi: update copyright
 notices
To:     Don Brace <don.brace@microchip.com>, hch@infradead.org,
        martin.peterson@oracle.com, jejb@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org
Cc:     Kevin.Barnett@microchip.com, scott.teel@microchip.com,
        Justin.Lindley@microchip.com, scott.benesh@microchip.com,
        gerry.morong@microchip.com, mahesh.rajashekhara@microchip.com,
        mike.mcgowen@microchip.com, murthy.bhat@microchip.com,
        balsundar.p@microchip.com, joseph.szczypek@hpe.com,
        jeff@canonical.com, POSWALD@suse.com, mwilck@suse.com,
        pmenzel@molgen.mpg.de, linux-kernel@vger.kernel.org
References: <20210713210243.40594-1-don.brace@microchip.com>
 <20210713210243.40594-3-don.brace@microchip.com>
From:   John Donnelly <john.p.donnelly@oracle.com>
Message-ID: <20e5b58f-062c-1ecc-006e-adc3af437354@oracle.com>
Date:   Tue, 13 Jul 2021 20:20:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210713210243.40594-3-don.brace@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR04CA0042.namprd04.prod.outlook.com
 (2603:10b6:3:12b::28) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.106] (47.220.66.60) by DM5PR04CA0042.namprd04.prod.outlook.com (2603:10b6:3:12b::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Wed, 14 Jul 2021 01:20:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e598a8b3-2592-40c4-371d-08d94665973a
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2349:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2349F929E14BEB13ED280902C7139@MWHPR1001MB2349.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LIFJHdTHAx41Z/03lxlTysVeunBsezMi2szZzbFMfZK1NPUSdj1WL/6m+edQsf2qkAsAasIAG2b+covfDaZkecRhhhd9MApeWY0RS9de3bTqlP6cj+D4YZSk+LP/nwi0kXqqOc6Xg36iXfQr9TQme8Ps6afMhNrdqwAGe+Xyq3LTyqPRQ1BQTcPzP7fCU4q0kS7oHxb2T66Q3znMZpcoSybKi7gGp2DVINNj4JmBFtsz3juv8hloW+VaSUgVgRVhcLtlxb24pLWrpWlgVhHQteH4u34szJjYFl69aC1pJjM8CzBEs60hQQOGq61HcOkCY/k7Rkm+s0uxJCW8g4Y4VGdj20bdICoQ4fOXhzbTWoSX31mSX3JHN9uDioURerUBr7racdu3DGdjNayCoEKQEBw/TP7KbFUDLdzGhT6ENBY8VYa5Z/RNESd9DcMZRwNyk17MvIyaGhvPhcwqYRSYjIVL1xy9+/UU5w06nHmsSC5uZGqk7l24+pl0qtqZS/nOzZsdlpX8EO5JdIUjAGwGuH+jYUjX61lAj30Llb7QePDMFbwimrxR7y1RQghN7MjsG+arMs05FAfI56Cwhy3DziRTPX5ggMW6+vM10XpZmYwxN7Q+c2ruAUsC/sc54GZfVWT2Y342/wTBO0mx2/66qDj/Bs0aJZdwaxiCUuFGdEReSsaKtArCFqWmqt7XWRNKep5dpuxKwedJliXvCQcVbpqh04/A//Cg7vdGIITHYf4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(136003)(39860400002)(346002)(4326008)(478600001)(86362001)(186003)(31686004)(5660300002)(316002)(16576012)(6486002)(15650500001)(26005)(38100700002)(7416002)(2616005)(66556008)(956004)(2906002)(66476007)(66946007)(53546011)(8676002)(83380400001)(36756003)(8936002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZjFRTlplamk0ek1XRkVjRzlGNUkyMTFjMWROVU9SUDZZS25pSXc3cGZwdlZM?=
 =?utf-8?B?NFpuQzE2czFVQ2ZMUEVEOUN0R3BXYjNTU3h1VC9mRWlPSFYzUlpOSnVGRjF5?=
 =?utf-8?B?NGo1U1JxUXhUaU9lcE1WL0s4MEJhc0JwWDlBTnZ4T2JsYWUrTDJhWW5aNHpn?=
 =?utf-8?B?eDNmRkR6QjE0cm1wb1VHTGtXSUhMNy8reENQSXZGSWRQZE1lMlhvWlQ3bGRt?=
 =?utf-8?B?NDBjU0Z3WW9zdFZnWmVMN0liOURzTVE4Y1NpL1FCeG96bnE5TzNJanR5eXF5?=
 =?utf-8?B?b1FUWGRleHZ0MmtLVmxOMmhqR2RnN3FjQUhWOHZCZGlvNEFlQmJROG81RzhP?=
 =?utf-8?B?TGNXb2pHYzI3UFRvRURtamxBM09FSnA5djVmTy9JaVo5Tm15WXdaKzh3UmFt?=
 =?utf-8?B?bVl1NEZQSnljV1hkRjYwdkpOd0Z0VkdPdko0Q1VpV2c2TGZQaXViTTdDbjlq?=
 =?utf-8?B?R1A4NnRWTUVobFlNQmFZUUl3dzhBWDhYR052YTFXb1R3SnlramFiVEx5NXJj?=
 =?utf-8?B?R2dqUThnaHN2TTY4SEJuRERVQ2JnT1A2TzlmYXBTVXpKUFhKRzVaNnh3TDJX?=
 =?utf-8?B?Z3NWZytWQ0V1MThiNGZvVlMyRmw4OFVSemJmejJuRTgvRCtvZ01Ta3FkRytz?=
 =?utf-8?B?NU9aN0lJbU0wbnF2TG5XMVNSWHVRZzFLbTVmVkhud3RMbVB4UVJSdmJEZHZn?=
 =?utf-8?B?OXR6VDFaQm9vdjRvdU5EZ0Y5RDBNUFp5VkloVU0zQ3JGM1VuUXhFTTlTUklv?=
 =?utf-8?B?YnJtK0lHR0Y2VGJpR3BnQjAySlJoTEpIMzVubnZ2aDRuVG9uZlZ2azdydDVz?=
 =?utf-8?B?NDBHYnZxY0hDR243Vk1NaGJVeWtIUXZJN3V2UlNxMXJYTmJ4clJ5Y21HUEM0?=
 =?utf-8?B?Q01OdkNoMitJTzNSRDFNditVU1JhaUtIUFEvRWJ3WlNVdGRjbzFEcHJTRmFj?=
 =?utf-8?B?cGhjUm1DK0xVakRITzMwKzBLTkdBV2ZudkxFQjF2OGxnbVluOUpPVUpOQWRF?=
 =?utf-8?B?aURlMGZ4dXgwK1RZdGFXNWdvdlA0RHZ2Z1JMQWFNQnVRcVE0OGtjOURPSFJk?=
 =?utf-8?B?VmlZdjg3SmVMWUt6YmY3L1NYNnNTeVdjejhzSjY1NExyQXdELzJ4QXIzQnU0?=
 =?utf-8?B?TVMrQmh4TStNMDQ2bUNWVmovdTZhZDRwQXFabFN3alBpeU96Sm1Ha3NxUXZR?=
 =?utf-8?B?eFpOUzh5eWtFWkxOQ3N2NWQ0N0ZmZU9RbjNja25JWWZvZ09nK0ovQ2ZRUHBx?=
 =?utf-8?B?anBPU2h2V3FoSmhCbnpnOU5uTU5oNHJUZllPbDZpN043blVKVkFPMTR5UmVO?=
 =?utf-8?B?YXpUemFHYnV1K3dmNm9FbTZxRXE0SFZFbUJIdjhPSEVjRlhnSnNaNktKeFVO?=
 =?utf-8?B?azBYQlV0aGRLSUtCdHNiWTllb2VKYmUvYXEzaU5VM1QyYXRPTnVoZThjcHI3?=
 =?utf-8?B?YXFBdW5LeEx3LzhlNWFPKzc1YkRCejZrTzlVL25kZldaN3YvNlZPQWdZYkRD?=
 =?utf-8?B?Zy9idDhjZy82UUJraHEvUkhMRGZaVGVKRkFCYjJIdGh5YnJpakFiL21BZVFi?=
 =?utf-8?B?RlVFUE1iNnhJbU00b2hNY1BiZUI2cllVS1BKa1RFWW1Mbm8vYXdTNjkrdHNQ?=
 =?utf-8?B?RytCWjFqUENlUlBYNE1BY3ZraUVwOTE4djNRdHRnejk0QklHdFUyb0s0UlE4?=
 =?utf-8?B?eDhmY096Z1lvNUNYOEs5Sk9UMHpnajdBVFdaK1NpYWlwSmFrblR4ZlZ3eU04?=
 =?utf-8?Q?z2pTcEDTxA0eIyl93QWH4SGc5rCsRZ8xMj5kogb?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e598a8b3-2592-40c4-371d-08d94665973a
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 01:20:39.3736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z06qEKKnSlUL0J3DglNLyP5ir3mdEsrLHGMRuGSlyD2ZCT0sSK6sybKh49QClRAslaPHmWbw1iCgYB6NLRvnvsIAkTlAByX4j5hKAO9GCqw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2349
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10044 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107140004
X-Proofpoint-GUID: WBytMZhQKfqPk2WEx7s_4C3-UP1m_xZo
X-Proofpoint-ORIG-GUID: WBytMZhQKfqPk2WEx7s_4C3-UP1m_xZo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/13/21 4:02 PM, Don Brace wrote:
> From: Kevin Barnett <kevin.barnett@microchip.com>
> 
> Updated copyright notices and company name strings to reflect
> Microchip ownership.
> 
> Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>


Acked-by:  John Donnelly <john.p.donnelly@oracle.com>


> ---
>   drivers/scsi/smartpqi/Kconfig                  | 2 +-
>   drivers/scsi/smartpqi/smartpqi.h               | 6 +++---
>   drivers/scsi/smartpqi/smartpqi_init.c          | 4 ++--
>   drivers/scsi/smartpqi/smartpqi_sas_transport.c | 4 ++--
>   drivers/scsi/smartpqi/smartpqi_sis.c           | 4 ++--
>   drivers/scsi/smartpqi/smartpqi_sis.h           | 4 ++--
>   6 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/smartpqi/Kconfig b/drivers/scsi/smartpqi/Kconfig
> index cb9e4e968b60..eac7baecf42f 100644
> --- a/drivers/scsi/smartpqi/Kconfig
> +++ b/drivers/scsi/smartpqi/Kconfig
> @@ -1,7 +1,7 @@
>   #
>   # Kernel configuration file for the SMARTPQI
>   #
> -# Copyright (c) 2019-2020 Microchip Technology Inc. and its subsidiaries
> +# Copyright (c) 2019-2021 Microchip Technology Inc. and its subsidiaries
>   # Copyright (c) 2017-2018 Microsemi Corporation
>   # Copyright (c) 2016 Microsemi Corporation
>   # Copyright (c) 2016 PMC-Sierra, Inc.
> diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
> index d7dac5572274..f340afc011b5 100644
> --- a/drivers/scsi/smartpqi/smartpqi.h
> +++ b/drivers/scsi/smartpqi/smartpqi.h
> @@ -1,7 +1,7 @@
>   /* SPDX-License-Identifier: GPL-2.0 */
>   /*
> - *    driver for Microsemi PQI-based storage controllers
> - *    Copyright (c) 2019-2020 Microchip Technology Inc. and its subsidiaries
> + *    driver for Microchip PQI-based storage controllers
> + *    Copyright (c) 2019-2021 Microchip Technology Inc. and its subsidiaries
>    *    Copyright (c) 2016-2018 Microsemi Corporation
>    *    Copyright (c) 2016 PMC-Sierra, Inc.
>    *
> @@ -59,7 +59,7 @@ struct pqi_device_registers {
>   /*
>    * controller registers
>    *
> - * These are defined by the Microsemi implementation.
> + * These are defined by the Microchip implementation.
>    *
>    * Some registers (those named sis_*) are only used when in
>    * legacy SIS mode before we transition the controller into
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index 64ea4650ca10..6ce17a191c0b 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -1,7 +1,7 @@
>   // SPDX-License-Identifier: GPL-2.0
>   /*
> - *    driver for Microsemi PQI-based storage controllers
> - *    Copyright (c) 2019-2020 Microchip Technology Inc. and its subsidiaries
> + *    driver for Microchip PQI-based storage controllers
> + *    Copyright (c) 2019-2021 Microchip Technology Inc. and its subsidiaries
>    *    Copyright (c) 2016-2018 Microsemi Corporation
>    *    Copyright (c) 2016 PMC-Sierra, Inc.
>    *
> diff --git a/drivers/scsi/smartpqi/smartpqi_sas_transport.c b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
> index dd628cc87f78..afd9bafebd1d 100644
> --- a/drivers/scsi/smartpqi/smartpqi_sas_transport.c
> +++ b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
> @@ -1,7 +1,7 @@
>   // SPDX-License-Identifier: GPL-2.0
>   /*
> - *    driver for Microsemi PQI-based storage controllers
> - *    Copyright (c) 2019-2020 Microchip Technology Inc. and its subsidiaries
> + *    driver for Microchip PQI-based storage controllers
> + *    Copyright (c) 2019-2021 Microchip Technology Inc. and its subsidiaries
>    *    Copyright (c) 2016-2018 Microsemi Corporation
>    *    Copyright (c) 2016 PMC-Sierra, Inc.
>    *
> diff --git a/drivers/scsi/smartpqi/smartpqi_sis.c b/drivers/scsi/smartpqi/smartpqi_sis.c
> index c954620628e0..d63c46a8e38b 100644
> --- a/drivers/scsi/smartpqi/smartpqi_sis.c
> +++ b/drivers/scsi/smartpqi/smartpqi_sis.c
> @@ -1,7 +1,7 @@
>   // SPDX-License-Identifier: GPL-2.0
>   /*
> - *    driver for Microsemi PQI-based storage controllers
> - *    Copyright (c) 2019-2020 Microchip Technology Inc. and its subsidiaries
> + *    driver for Microchip PQI-based storage controllers
> + *    Copyright (c) 2019-2021 Microchip Technology Inc. and its subsidiaries
>    *    Copyright (c) 2016-2018 Microsemi Corporation
>    *    Copyright (c) 2016 PMC-Sierra, Inc.
>    *
> diff --git a/drivers/scsi/smartpqi/smartpqi_sis.h b/drivers/scsi/smartpqi/smartpqi_sis.h
> index 12cd2ab1aead..d29c1352a826 100644
> --- a/drivers/scsi/smartpqi/smartpqi_sis.h
> +++ b/drivers/scsi/smartpqi/smartpqi_sis.h
> @@ -1,7 +1,7 @@
>   /* SPDX-License-Identifier: GPL-2.0 */
>   /*
> - *    driver for Microsemi PQI-based storage controllers
> - *    Copyright (c) 2019-2020 Microchip Technology Inc. and its subsidiaries
> + *    driver for Microchip PQI-based storage controllers
> + *    Copyright (c) 2019-2021 Microchip Technology Inc. and its subsidiaries
>    *    Copyright (c) 2016-2018 Microsemi Corporation
>    *    Copyright (c) 2016 PMC-Sierra, Inc.
>    *
> 

