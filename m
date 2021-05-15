Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9BEEC433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 16:17:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8990F613BC
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 16:17:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbhEOQSe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 15 May 2021 12:18:34 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33216 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233130AbhEOQSd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 15 May 2021 12:18:33 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14FG9TZ8016630;
        Sat, 15 May 2021 16:17:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=w8lSHSAqxtDgTOfIsTROaLHBiWtxBa5cpIgPtVLLVvM=;
 b=z76FxE7sHIQcCZ23bO9cEcd7UuOLiWb5TOE4wacDQvxeUBb9+kCUc7I9Tn4SGC9KJ2q2
 V+6Goz8QuGuUm9ie2jFzlyf//J3XDpNwwi6cz2YTlRfmWCvD/yOHPscUZAij2wTHQW8P
 mOlOAWRiC6TI19t8DJP4tEY5bdwPh4V434sY+J//Oz+UZ2z4xcHFAF0/vjQnwjRU+3Fs
 4m9jSM1/P0TXauLMqQoyz4j4xq5ErgAvYzDde3PMgMayKiAEQSGvYqeCkjUeVGuMBULa
 47tVTgqh2N1jMfZNu1JoRsqBJIDsEHeU1MAHfIPX0WmPqIJdt2t1HqQ/wMbEeFQ2/6lF iQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 38j68m8jj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 16:17:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14FGEuNW095893;
        Sat, 15 May 2021 16:17:19 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2043.outbound.protection.outlook.com [104.47.57.43])
        by aserp3020.oracle.com with ESMTP id 38j641vqtf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 16:17:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y5N4LOs6dZDRyRu40MGsIzqUuddl12f0ipoIMd0FZI7p+SkmR/mFd9ZhN/ausHsTkHZY2fQJ3Q3VBsWAFFjMXBF0WaHxBxokhTfyY/Ytabu98fO/eaFel7rbwg67PC5DZmqBKJN19LpfOS5JoTbF8RyaswhAQsPlFQOlZM1/F9M1AXFpRifYc8to27hWt3q1pz3nWKmo2cP1FLKut5EOXDVjKWuZmTmAbf9UB+fqm0AbPT4lvpbpbIlIEijBoChRa9tAJkKCxzhPUmSnsSF3aN73KeqbMneO2Rzt6wsBdF3CV09Jc8BZapOjHr81oQqM5deOAzExkZccVIIEWWUULw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w8lSHSAqxtDgTOfIsTROaLHBiWtxBa5cpIgPtVLLVvM=;
 b=MS/LlH/f9kYB3P+uj7AGbMCvdLrR4L7gKtGVo0qMmzDKg/S4BC46wMNsxDAGjMpKLQJZ/2pjtUb8C/cRtQZR2ZSk82U99/7Ma1cgcSVcG0WEhBU8xKepWCkMdtEqZHhLpxUvi/Mlqmr98x74D4TrSN6f3IKKzYlw0wbfnMpe8tGTfL+0Z9THbjVgQRdovaWVV3S6PhntzHs9Cbkt9kN8ADhUs0u1WayCwSEBXnLzcQxJWVIuOOzd5EVQk1l7oSl0F9WXa6fITy3cBwWu3+p9heopk7acSY3/el2+7MHCyMUle7L6eQpxUiTyREvNc8bUk+iHF1f1tmmFMY/Yjz8PQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w8lSHSAqxtDgTOfIsTROaLHBiWtxBa5cpIgPtVLLVvM=;
 b=yC9HPC+/0rDE6Nzv476Cd02b0bF/tnI8fSDFTsbv48La1kQzfC2N1lXYn2vDmYjdsXJOztYjK7UMlKGs3XugeAkGCCo3GPmm4tCWhWAztuueMj1pijk+y6XBZ9FtsrJxbKgg+160sMUAoDCldtwZ4AWmfPqFp69LKFAiUrYz0+I=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4416.namprd10.prod.outlook.com (2603:10b6:a03:2ae::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Sat, 15 May
 2021 16:17:17 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4129.028; Sat, 15 May 2021
 16:17:17 +0000
Subject: Re: [PATCH v2] scsi: target: Avoid smp_processor_id() in preemptible
 code
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
References: <20210515070315.215801-1-shinichiro.kawasaki@wdc.com>
From:   michael.christie@oracle.com
Message-ID: <1ffa6ca0-6a55-cfa4-af63-11897d88ded1@oracle.com>
Date:   Sat, 15 May 2021 11:17:14 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
In-Reply-To: <20210515070315.215801-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR21CA0004.namprd21.prod.outlook.com
 (2603:10b6:5:174::14) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.5] (73.88.28.6) by DM6PR21CA0004.namprd21.prod.outlook.com (2603:10b6:5:174::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.14 via Frontend Transport; Sat, 15 May 2021 16:17:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9d7be1d-56c6-48e4-e922-08d917bce81e
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4416:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB44161A1B7CC96D93BC36647BF12F9@SJ0PR10MB4416.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hUoX9X92MF0tSwckS9Ov4SJ5jhnZeQLDfgLkZIk8l/CPgAjsz6pqd9Kdft+NwOBagnJ3bCfjdqP+iA1Vdln4QpijrEp5ndfRtpBCrJ9ipB1dXsOm/2iRMrQhMx9HKUq71KmaV0GEEUlR4ADZJhRwO3ShJ1kojhrFQrr6LC36Tu8cYj3/c2cvjWDK0bx6fcDb7dcIn5GLl/PUySee0aZo7o77CF1sf9ZFDYGqOEzo2dGw2WCPGO+a8EUHd4SWg2E9MJZdd9WDejjhQTUdqJLjcrf9f/93+96cGy06qNrx4z/XT432yH4MJeZlEnQR+DCj0kVLb/25ZBBQEvyed0hQgEeGi5WHb2+p4FXYW1ndXK/I8iLzCBD5dCQY5W6Hq1nFoX2Du2elBMI/hFad8l+lzVcdWi2/3mtWiiXAcsj95xB7vbeUJuleKrJmJ+ZYfGiLfCVRDlQOhR9KPp3HKvaIb6ABegF4+XpeQUTgLatevpXgD9zIQ1VRRFAuv6kLZ9saGNHnR8jGQSibArKdtuBd7w7Kx/cc4VxtCADm6kL0+E5QBQiSaso2Fg2idHOI4qDr7jr4rM9m/EG1ME/KuKQ8MVoDY4+XTCt6o0Whg25Z5LH7ItDyHhZAd1/atiC0YCIjox5gdzq6cahk2LM48MLEsQopZpCNJfAOq/Q4Y1ZXoGu7EnDU5iiTq2czo8QuoG8e
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(346002)(376002)(136003)(38100700002)(31696002)(2616005)(66556008)(83380400001)(66946007)(66476007)(26005)(36756003)(86362001)(8676002)(6486002)(53546011)(9686003)(956004)(2906002)(4326008)(186003)(6706004)(8936002)(478600001)(5660300002)(54906003)(16576012)(31686004)(16526019)(316002)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NjZSWWMxb2xiUFlXemI1ajUxeXBQRjFIbEY4Wng1cUdTOEppNFZCWHE0WEdi?=
 =?utf-8?B?TDFVUzhqeCtlMmx1emFqTmF2c3lEeU81NHJhLzFhVGI2MlBwSnkxdUlicDJv?=
 =?utf-8?B?VWpvMjU3czJQUFVBYmJyQmdoUWdCTHVSdU9YZ3FZd2UyYURvNFZaV0VkNENs?=
 =?utf-8?B?c0lhYko5S2dlZEpNcVJhMHdIY1ZrdUQxc0RtSUhPMzJxL3lvdEM2SmdsVVFv?=
 =?utf-8?B?dU0yYUxDQTBvVWRtVnNiTzZYSENlcmQ2OE4zQW1sRFJ0dEIvV08xb0FSTTlv?=
 =?utf-8?B?NmdSQStrbmdFRWl6Wk9DZ1VRa1M4eWViVkhVMXhyMk9oTW5MSXVTcmp5K3Nm?=
 =?utf-8?B?ZTdGSWh5a3U2MnVHNC9Pb1RQQWJtMHdvOXo4L3kxclYvOHRDdnk3NW9FbHBj?=
 =?utf-8?B?amxZcWJWajlQU2VMSWN0QldvcUVVcDhmN0xzWDZtNFNpNUlSMlZFZWdqQWpS?=
 =?utf-8?B?Q0pLYmIydFFGekVrSTdieS9SM0tIUlhaU0xEL2JFNVZCdHhpcGVyOE5GdFJC?=
 =?utf-8?B?N3c2MlhoRzVSUGU1ZlJhekw0MWx4TWZTbWVMZy9UdEZLcUc3ZEVMVGRnWGp5?=
 =?utf-8?B?cnZDaG1ZaGw5WmlNZTNiRHVIZHIxbGlRQjJkaGtlSld3NEpHVnlsVDVlc2ZP?=
 =?utf-8?B?bDhyQ2o4R2FkSzI5Z0drcEhNM1g5dUtwaXNsN2l3NlRvRHFBYW1uMkxnVlVM?=
 =?utf-8?B?eVh5Vm5uQ3l3SmFJOUo0OXZkaEtvcEhJWTlKbzNqQStIdHNhVEpSbjF4UU54?=
 =?utf-8?B?bDRLMTlCYmw3Y0xYTjFEZnNIVVFvejFJNFM1MjRZcVlJNVZjYnh6bVgzaXQw?=
 =?utf-8?B?NS9RaS8vOWRiYTY3NkF1TFN1cnBRQmZkaUFhR1F3ZmRKakdrUytBQU5mczBL?=
 =?utf-8?B?dFZDc0hOVU1hWVFlamJsS2oreitIVXlSL0NleVU5SmRGTjNCMHdVa1J6SUZy?=
 =?utf-8?B?Qy9ZV3lkeXdBMzQrcDNVb2E5djZHU1plbVRneENjOCsyNk1PaCtESXNnOExI?=
 =?utf-8?B?ZS9Vd0FuUDR2ZWxqMXpLdjlsbFpUQWVDNWhmOVgremh2TU9NS3lGY3p4ZEU0?=
 =?utf-8?B?TlRWWDhiSzR0cmdQRGxSMmNmdUcwLzFia0FTRXFpMFhJRThtR1JWOTJUc25k?=
 =?utf-8?B?cnNtSkc0LzljeVhBekVUWGFGWHEwQmc1UWZyVncwanhOd2dCZlA2Qi92TThY?=
 =?utf-8?B?WmJMSzV4TlVmdEpWMm9ZNmxaTk14dDFoT0tvaUlMUEwyNCtSWUFSWVV6MS8y?=
 =?utf-8?B?UFJvMmQzaVU1OVVNRTBtU2Y2MFk0YXpLUTlnL01ZTFh4dFVGMWlDWUtGNjRq?=
 =?utf-8?B?MEtjSHRoUFllMmNzVWtjeXBkTmQzQ3hudVk3RTZrd2VvL0REdDVXTUwvOVVs?=
 =?utf-8?B?OUU1VVZmWEVyWFphVEttWENIT2VLbGhYdEYwQyt2eE12QVZlTWt1Q2RJc2pU?=
 =?utf-8?B?aGxkTWg0Y1ptRVRTRnljSjV5Z1ZNM1VaMU9qMWNqemN5SE5pbHdJN0NGWHFT?=
 =?utf-8?B?eVM2SlJDZDh0ZnNWS3E0OTNNSmxwb09pNWFsRXJTdzM1WnVsSmhEQ1Y1T0la?=
 =?utf-8?B?SjRvNWtrTG5SVExXMWdJcjRWbzRKSUdGbm5CdXY4Mm4ycTBoTkxEODljaWZR?=
 =?utf-8?B?c0FqM1FlQmZpbTJNTVlxZ0JUc2FFRjZGMG9wWGZnTXlDYmxOZG5BRHZ2VjhC?=
 =?utf-8?B?U0lYSFhxU0JqVzl2U1MyY21tOWpBSEJIc1FNTnVlcDJGT0NRRHNvU3ptQTZL?=
 =?utf-8?Q?w2uwFp7YTkImQsGLcE0z27PJn/Ns+l2eZcqscwN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9d7be1d-56c6-48e4-e922-08d917bce81e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2021 16:17:16.9683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UaOURbsQqrFHXvTxiKInnYNgoDFYXNcuPy4YmeocTQz+NlNZg+LXt1LXiXBFobbUJP6X0kxfJcaEDku6q5DuC3jMFs9wxfdX/sIuib6n7Ik=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4416
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9985 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105150121
X-Proofpoint-ORIG-GUID: GeGRCNYUwPtM2QC9J33khFJoO9Y50-s4
X-Proofpoint-GUID: GeGRCNYUwPtM2QC9J33khFJoO9Y50-s4
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9985 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 suspectscore=0 clxscore=1015
 adultscore=0 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105150120
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/15/21 2:03 AM, Shin'ichiro Kawasaki wrote:
> The BUG message "BUG: using smp_processor_id() in preemptible [00000000]
> code" was observed for TCMU devices with kernel config DEBUG_PREEMPT.
> 
> The message was observed when blktests block/005 was run on TCMU devices
> with fileio backend or user:zbc backend [1]. The commit 1130b499b4a7
> ("scsi: target: tcm_loop: Use LIO wq cmd submission helper") triggered
> the symptom. The commit modified work queue to handle commands and
> changed 'current->nr_cpu_allowed' at smp_processor_id() call.
> 
> The message was also observed at system shutdown when TCMU devices were
> not cleaned up [2]. The function smp_processor_id() was called in SCSI
> host work queue for abort handling, and triggered the BUG message. This
> symptom was observed regardless of the commit 1130b499b4a7 ("scsi:
> target: tcm_loop: Use LIO wq cmd submission helper").
> 
> To avoid the preemptible code check at smp_processor_id(), get CPU ID
> with raw_smp_processor_id() instead. The CPU ID is used for performance
> improvement then thread move to other CPU will not affect the code.
> 
> [1]
> 
> [   56.468103] run blktests block/005 at 2021-05-12 14:16:38
> [   57.369473] check_preemption_disabled: 85 callbacks suppressed
> [   57.369480] BUG: using smp_processor_id() in preemptible [00000000] code: fio/1511
> [   57.369506] BUG: using smp_processor_id() in preemptible [00000000] code: fio/1510
> [   57.369512] BUG: using smp_processor_id() in preemptible [00000000] code: fio/1506
> [   57.369552] caller is __target_init_cmd+0x157/0x170 [target_core_mod]
> [   57.369606] CPU: 4 PID: 1506 Comm: fio Not tainted 5.13.0-rc1+ #34
> [   57.369613] Hardware name: System manufacturer System Product Name/PRIME Z270-A, BIOS 1302 03/15/2018
> [   57.369617] Call Trace:
> [   57.369621] BUG: using smp_processor_id() in preemptible [00000000] code: fio/1507
> [   57.369628]  dump_stack+0x6d/0x89
> [   57.369642]  check_preemption_disabled+0xc8/0xd0
> [   57.369628] caller is __target_init_cmd+0x157/0x170 [target_core_mod]
> [   57.369655]  __target_init_cmd+0x157/0x170 [target_core_mod]
> [   57.369695]  target_init_cmd+0x76/0x90 [target_core_mod]
> [   57.369732]  tcm_loop_queuecommand+0x109/0x210 [tcm_loop]
> [   57.369744]  scsi_queue_rq+0x38e/0xc40
> [   57.369761]  __blk_mq_try_issue_directly+0x109/0x1c0
> [   57.369779]  blk_mq_try_issue_directly+0x43/0x90
> [   57.369790]  blk_mq_submit_bio+0x4e5/0x5d0
> [   57.369812]  submit_bio_noacct+0x46e/0x4e0
> [   57.369830]  __blkdev_direct_IO_simple+0x1a3/0x2d0
> [   57.369859]  ? set_init_blocksize.isra.0+0x60/0x60
> [   57.369880]  generic_file_read_iter+0x89/0x160
> [   57.369898]  blkdev_read_iter+0x44/0x60
> [   57.369906]  new_sync_read+0x102/0x170
> [   57.369929]  vfs_read+0xd4/0x160
> [   57.369941]  __x64_sys_pread64+0x6e/0xa0
> [   57.369946]  ? lockdep_hardirqs_on+0x79/0x100
> [   57.369958]  do_syscall_64+0x3a/0x70
> [   57.369965]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   57.369973] RIP: 0033:0x7f7ed4c1399f
> [   57.369979] Code: 08 89 3c 24 48 89 4c 24 18 e8 7d f3 ff ff 4c 8b 54 24 18 48 8b 54 24 10 41 89 c0 48 8b 74 24 08 8b 3c 24 b8 11 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 04 24 e8 cd f3 ff ff 48 8b
> [   57.369983] RSP: 002b:00007ffd7918c580 EFLAGS: 00000293 ORIG_RAX: 0000000000000011
> [   57.369990] RAX: ffffffffffffffda RBX: 00000000015b4540 RCX: 00007f7ed4c1399f
> [   57.369993] RDX: 0000000000001000 RSI: 00000000015de000 RDI: 0000000000000009
> [   57.369996] RBP: 00000000015b4540 R08: 0000000000000000 R09: 0000000000000001
> [   57.369999] R10: 0000000000e5c000 R11: 0000000000000293 R12: 00007f7eb5269a70
> [   57.370002] R13: 0000000000000000 R14: 0000000000001000 R15: 00000000015b4568
> [   57.370031] CPU: 7 PID: 1507 Comm: fio Not tainted 5.13.0-rc1+ #34
> [   57.370036] Hardware name: System manufacturer System Product Name/PRIME Z270-A, BIOS 1302 03/15/2018
> [   57.370039] Call Trace:
> [   57.370045]  dump_stack+0x6d/0x89
> [   57.370056]  check_preemption_disabled+0xc8/0xd0
> [   57.370068]  __target_init_cmd+0x157/0x170 [target_core_mod]
> [   57.370121]  target_init_cmd+0x76/0x90 [target_core_mod]
> [   57.370178]  tcm_loop_queuecommand+0x109/0x210 [tcm_loop]
> [   57.370197]  scsi_queue_rq+0x38e/0xc40
> [   57.370224]  __blk_mq_try_issue_directly+0x109/0x1c0
> ...
> 
> [2]
> 
> [  117.458597] BUG: using smp_processor_id() in preemptible [00000000] code: kworker/u16:8
> [  117.467279] caller is __target_init_cmd+0x157/0x170 [target_core_mod]
> [  117.473893] CPU: 1 PID: 418 Comm: kworker/u16:6 Not tainted 5.13.0-rc1+ #34
> [  117.481150] Hardware name: System manufacturer System Product Name/PRIME Z270-A, BIOS 8
> [  117.481153] Workqueue: scsi_tmf_7 scmd_eh_abort_handler
> [  117.481156] Call Trace:
> [  117.481158]  dump_stack+0x6d/0x89
> [  117.481162]  check_preemption_disabled+0xc8/0xd0
> [  117.512575]  target_submit_tmr+0x41/0x150 [target_core_mod]
> [  117.519705]  tcm_loop_issue_tmr+0xa7/0x100 [tcm_loop]
> [  117.524913]  tcm_loop_abort_task+0x43/0x60 [tcm_loop]
> [  117.530137]  scmd_eh_abort_handler+0x7b/0x230
> [  117.534681]  process_one_work+0x268/0x580
> [  117.538862]  worker_thread+0x55/0x3b0
> [  117.542652]  ? process_one_work+0x580/0x580
> [  117.548351]  kthread+0x143/0x160
> [  117.551675]  ? kthread_create_worker_on_cpu+0x40/0x40
> [  117.556873]  ret_from_fork+0x1f/0x30
> 
> Fixes: 1526d9f10c61 ("scsi: target: Make state_list per CPU")
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Cc: stable@vger.kernel.org # v5.11+
> ---
> Changes from v1:
> * Used raw_smp_processor_id() instead of get_cpu() and put_cpu()
> 
>  drivers/target/target_core_transport.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 8fbfe75c5744..05d7ffd59df6 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1416,7 +1416,7 @@ void __target_init_cmd(
>  	cmd->orig_fe_lun = unpacked_lun;
>  
>  	if (!(cmd->se_cmd_flags & SCF_USE_CPUID))
> -		cmd->cpuid = smp_processor_id();
> +		cmd->cpuid = raw_smp_processor_id();
>  
>  	cmd->state_active = false;
>  }
> 

Reviewed-by: Mike Christie <michael.christie@oracle.com>
