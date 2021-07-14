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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 388C5C07E95
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 01:24:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EFD461370
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 01:24:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237350AbhGNB1X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 21:27:23 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:54220 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237301AbhGNB1V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Jul 2021 21:27:21 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16E1G9xk008091;
        Wed, 14 Jul 2021 01:24:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=VYOXpVebynldywJu372KYB6+7mzh6yf2B86R6VkGjbw=;
 b=M9VV6ajLypuHfvBlIJE7icN7/VT/cy2RtM4GYNJ/8GETm8jBi3EYsFsB2CpqaSeAtOTD
 lPDXINPT5ZSKD/2aUKMlRgAvhHoh0i9Tt0RyxPbKO1pnANiwnOtZx/0uZSBF3nLqgUZp
 yC+cjaYKSyFJrjXMshASnMR+uDApzKowosqC0+lFuzpyZnv6urst7YtLACfx2b8vwdAm
 FNf2/0AW8IyKo2QJmYcwNZHy1eqJOEflaf42fqRX4xcjyqPXEceV8NhYpxxUOnQRtOw0
 LWFZJvwI9g7j0p4OYiPPuIGv94BamUmazoD1NCASHNG6y/M841d19Szvb91s329eWgF5 iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39rqm0up9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 01:24:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16E1GlEm051207;
        Wed, 14 Jul 2021 01:24:18 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by userp3030.oracle.com with ESMTP id 39q0p6jsb2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 01:24:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cdTDkPs78IWI7Qkrnq/WwU9Vt2LbgpxL2YsFTLOml2vL0xwByPF8U8XhfcBsdyr/Gti6wxtalESn3GGA7RZK2LO4M8Ci+nl1skdjlTsLq99luNc3mCFTojhKVBAwU9hGDhIrGrLz8UO8LVJkmNM5agjsN9Bveu4xfTl1p70vC9ElK7WBXPSlOxvpJKkpK3Fbbkef1HaBZsxFaSb3FurQswU5rJJ6STjwJTLV+zkZynAfROzGSg62BSEMarileWO1Jx4KaAuzVf+/1m4x5iKuTJibtpCNv+0E+LG5fzwzCsIgCp7i1fUyRXzDAF0W6yxFAIuqPe7DKLS/bz640Ot9+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VYOXpVebynldywJu372KYB6+7mzh6yf2B86R6VkGjbw=;
 b=NBBzHyPPOP0+ehOrKSKdlDBvaRNc6PDfsh3mO1f8AfYXpD37s0NzIS5RyWhAT0NDaPqMTNUY1T6TBxx8Vkphc4ggZRAYdCsuNSmypkRJtqBoEGUBxV2ivTzI8vmT2+QP/pqhaieR4NnvWO3o7WrErZEl+h8Z2GtwlObxDgqf1Wg3Itm+xc5oprLPptaPhkyEkjjPhGc0/HfIJ16Wb2sIHhShZmiMcu5ngITjW8gwP8Z/O+ss75YsSgz8/EXLhKNwQDIGXIq/MTlGRbUheQQRbjqri66h5wow2f4pZa4qTEu/fQzBw3nLE3QOuJipvCYPeesYo/OfgZckE7wVJuttFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VYOXpVebynldywJu372KYB6+7mzh6yf2B86R6VkGjbw=;
 b=mpDllG84KWDxAsqi/xPXr2wtSC+2HiI2zMaZvU+v5M/qLMG2+T47Gu95h/lXcE5LWkYGxkq0iJ8ZNKxGiC3vW3ihIqPy5a7Ws6suWmCAOUOOaFCHhTjKyM6xc7L8qU+u+ss27jsfUTo0kuLyCEq0fsw9JIjfcP6R29gJjAxzyow=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by MWHPR1001MB2285.namprd10.prod.outlook.com (2603:10b6:301:2e::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.25; Wed, 14 Jul
 2021 01:24:15 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f8c1:a59:f070:5a5f]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f8c1:a59:f070:5a5f%3]) with mapi id 15.20.4308.027; Wed, 14 Jul 2021
 01:24:15 +0000
Subject: Re: [smartpqi updates V2 PATCH 7/9] smartpqi: add PCI IDs for new ZTE
 controllers
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
 <20210713210243.40594-8-don.brace@microchip.com>
From:   John Donnelly <john.p.donnelly@oracle.com>
Message-ID: <dc485e6c-3f85-ae1b-959d-9543b4fb9563@oracle.com>
Date:   Tue, 13 Jul 2021 20:24:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210713210243.40594-8-don.brace@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR05CA0021.namprd05.prod.outlook.com
 (2603:10b6:208:91::31) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.106] (47.220.66.60) by BL0PR05CA0021.namprd05.prod.outlook.com (2603:10b6:208:91::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.12 via Frontend Transport; Wed, 14 Jul 2021 01:24:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c2cce52-cc7c-41a9-9ea1-08d9466617b2
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2285B3FCC22A9BA0BD5D9E22C7139@MWHPR1001MB2285.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XwhSV1flBYSxv0G/urvnbbcjeLusGuRMQZqYya5m3e4r1nXp/6KftfWmtciR0RHW7wIAgx7gSlVrSV8LEWqlhROvbUB1+MGRp0so0m0TwVGPujVBXsNCS09YS7PYfcxem2qaRgZDHmjyAdn10JxEnrg0vEYrR4bwPcXIHf7iYKBWHVRSCoo1u6L1euR2e/hXBEXzv7/v5Y96V5hrO5e9oCgR0KpXABWsYUTfUv0JgXprAxp8vi5q70iTRsM8WasNvZWkpEWEM/1qzVQLuKMRgceQl8ITJeKfOpZYGjhkSx9naXjVNUCn3HvLZxAxlF831kF14m6GRXNrcA4O2yXneuslqsJkifiLJlV/iSHR+OdisRVmfFViSDcUZfL9P+er76ezUugOhY3NKTJgt70d4RYEkLKyBFjOa3a1lraweBPMvA01wDK8dOaENF3eJRqzWaY9AKGHQNgXVKc9BbNc5vRCJ4fek38cEQ6cJ51x3RWUaPfOfVdfkaBUVfJwzC/p6aY/0LaBhqdvwB6G+vTbTHFrYZWAtbFv8a2Vjch/yrcsBJWcFr2RkjwehZIx7xlRJWE+UBTNo/AzJhPK5r6cODmPVEIDvVb9M5CaJyYm0ItfiuBg0OnE77UxI/zMVMzR67hsUC73Cb4IbY9awdcj3cZln/q5WlxpDX5zEtxYkoDIZJlvRACf61HhV1Bx5rIdHBXrmGjM7OcC41GrgQnPWoYw9HvUzV0/eVb6utgEBew=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(366004)(396003)(346002)(376002)(7416002)(31686004)(36756003)(2616005)(38100700002)(478600001)(2906002)(956004)(5660300002)(4326008)(6486002)(53546011)(26005)(16576012)(66946007)(186003)(31696002)(8936002)(66556008)(316002)(8676002)(86362001)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MUlER3VqQ0FEZGhha1RFWEFJY3paRnFpYWt2STBEU2Z2ckJXZTFJVzFCamlj?=
 =?utf-8?B?UXVIVnhaalhZQ0RHTnl0VWgzWW1qTUxPQVUxWHRxb1prQkZWclBUeVVrZkVi?=
 =?utf-8?B?L2l3L2xFZ1FFdTc2SmlQZ2dDUDB0a3pZRVJCVzVwaGtmNHZja05BdHFiQU1y?=
 =?utf-8?B?Q2M0R1RzMjRIVXI3Q2gzVStFT0sweTMxem92OXA2QWZFUTdTWGJWdEV6L3hN?=
 =?utf-8?B?cFR4TVpYTjk2R1NpdjRuN09vSTcwb0dMUVptWXJsTWR1cXQvdmVScHNsRnRh?=
 =?utf-8?B?Ui90U0NwdGNtOTRwYTJ1NURzb0Fod2RtOXNlZzRGdlNwcG5CTjNZcHo5L0lP?=
 =?utf-8?B?S0ZGNnY5UVY2RmNCalNwK2RzNm4rSC8yTDhySU1WUXJrMnlLdjlrTGVvQTVu?=
 =?utf-8?B?YWl0T3RqYU4rUU1IR0MrWW1WK2xsMkcvMTlRMHI5ZnVMYW9ncDBlc21HemJw?=
 =?utf-8?B?dVJRdW1qSmdZY3FwRy9aSEU3ZkxMY3Z0K2lJcVM0N1BhY3o5endsNC9XbnlN?=
 =?utf-8?B?a3hzeVBjRHJTeXZpQm5PNnZMV3pBajZkUHFxSVpDUnZ1aUgwR0lkY2RQamla?=
 =?utf-8?B?Q0Rnbk1jaDJFdncyb3dwM3JCS1g0RlNYd25OZVlKQXdMeUY3T21oVXVUWVQ2?=
 =?utf-8?B?Y0gwWFRwVUlaZUtXQi9JT0Vhc09vWUZKdmVmVkFRdHR4K1ZiMFQvVGhQOE5q?=
 =?utf-8?B?VFpYdDNGNno4N0hLdjNIU1FtSENoNFR1bzV5M3FFV1BnVUM0YWw2dXh3cW82?=
 =?utf-8?B?b3lMdjNvU3JnSTlWRUtNdjl0TVRiemVzaXFNVjlPWDd2bkFIQ0QxMVprRzdB?=
 =?utf-8?B?NXdYd254SVdqa1J1VmR2dSt6eEluc3RXM1BCVGFJZ1I4clFTYS9ZZFltV1BW?=
 =?utf-8?B?LzNjY0lvRHpuaWo4dkdFNmRkd3NYMTM0Y0tqU3d3d09oZndlVXRTSTNhUGhz?=
 =?utf-8?B?QWJvby94RWNBV1BoRzJYa0dObzgvb0x0YW5WNjdWbTB0cmJXWitWMWcwbVBG?=
 =?utf-8?B?Y0R1V1pBenlGVzNZZ1ZEanQ0YWI2NTdGelVZb00zN2IxVmp6alJXZmJoTE1Q?=
 =?utf-8?B?NktsOVAyMUQ3cTc3cEJrYVpjNHRQaG1LTjVUb0Ercmh2bm9sUzIrS29kUjdD?=
 =?utf-8?B?QUovQXB1VWNCQVFQZHA3WFBiZkQwYnhMOERabGZJZWZjOEVLcGV0K3VldU5N?=
 =?utf-8?B?RUFHcWlYdTV6WVRWN0U5MUh4TG1ESFZISVplcmR6eGZ4YkVRdUdXRmVvR24w?=
 =?utf-8?B?dlZWR3dUQ1M2SXd5OUo3dk9pMlNtU3JKYTdBSC83Sy9PZ2lDd1pMWm95R3V3?=
 =?utf-8?B?clpMaWRyNitGKzI3UitLeXRRK0NIVk0wZ2U2dTFpWTB2c3lmTkthR3U3WW9S?=
 =?utf-8?B?THN6N3BlZ3FYKzVCc3Jza1Y4Zk4yZE44dUZVWXhTdFFMVTJYVjBZNiszbWZM?=
 =?utf-8?B?b1Z2c0VJNzNEM0RCKzluenZxbGNnVE02cXJQU241ZnFuMGZGbmVzYmtoOG9N?=
 =?utf-8?B?bDk3VGxRNkcybGlJRTdQRWxBVkc5aHBYcnZFUjNaaGpaamIrMXpyVWlCU0lo?=
 =?utf-8?B?dFpJVFM0dXd1OUUwV0Y0MGVLSzJqMEFib1lhYW5NRTRyNStGcFFFTGgxbXhJ?=
 =?utf-8?B?MUVjbGVSSjVKcXFmQ1NyL0J2dWpnbWFSTS92Q1NDcDA0MTJoc1ZDaktnODZ0?=
 =?utf-8?B?MUhoYWR6Sm1WaTJFWUN4WUg4dThYUWUzMmNLdTE0RXB1RmxxRkJDT0REOC9C?=
 =?utf-8?Q?VeMsHzKkU1QYXp0tPxz0ce38KxZYFgNPmPFFDYk?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c2cce52-cc7c-41a9-9ea1-08d9466617b2
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 01:24:14.9718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BD5puEahABEGIDRb+My+XntUuHIga1Mw7NznQ2lq+w9SQ7YKawdVn53NBF1jTxJjnyZ/xUkgLCgrogLrTn/ow4WymM03ifGkNRauyyO7EIQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2285
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10044 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107140004
X-Proofpoint-GUID: IoSRBqwphZqCuCRXw2iAsKi0cZdGnBON
X-Proofpoint-ORIG-GUID: IoSRBqwphZqCuCRXw2iAsKi0cZdGnBON
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/13/21 4:02 PM, Don Brace wrote:
> From: Balsundar P <balsundar.p@microchip.com>
> 
> Added support for ZTE RM241-18i 2G device ID.
> VID_9005, DID_028F, SVID_1CF2 and SDID_5445
> 
> Added support for ZTE RM242-18i 4G device ID.
> VID_9005, DID_028F, SVID_1CF2 and SDID_5446
> 
> Added support for ZTE RM243-18i device ID.
> VID_9005, DID_028F, SVID_1CF2 and SDID_5447
> 
> Added support for ZTE SDPSA/B-18i 4G device ID.
> VID_9005, DID_028F, SVID_1CF2 and SDID_0B27
> 
> Added support for ZTE SDPSA/B_I-18i device ID.
> VID_9005, DID_028F, SVID_1CF2 and SDID_0B29
> 
> Added support for ZTE SDPSA/B_L-18i 2G device ID.
> VID_9005, DID_028F, SVID_1CF2 and SDID_0B45
> 
> Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
> Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Signed-off-by: Balsundar P <balsundar.p@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>


Acked-by:  John Donnelly <john.p.donnelly@oracle.com>


> ---
>   drivers/scsi/smartpqi/smartpqi_init.c | 24 ++++++++++++++++++++++++
>   1 file changed, 24 insertions(+)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index c0b181ba795c..f0e84354f782 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -9185,6 +9185,30 @@ static const struct pci_device_id pqi_pci_id_table[] = {
>   		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
>   			       0x1dfc, 0x3161)
>   	},
> +	{
> +		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
> +			       0x1cf2, 0x5445)
> +	},
> +	{
> +		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
> +			       0x1cf2, 0x5446)
> +	},
> +	{
> +		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
> +			       0x1cf2, 0x5447)
> +	},
> +	{
> +		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
> +			       0x1cf2, 0x0b27)
> +	},
> +	{
> +		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
> +			       0x1cf2, 0x0b29)
> +	},
> +	{
> +		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
> +			       0x1cf2, 0x0b45)
> +	},
>   	{
>   		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
>   			       PCI_ANY_ID, PCI_ANY_ID)
> 

