Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A45C00144
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Aug 2022 06:55:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238965AbiHDGzp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Aug 2022 02:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238960AbiHDGzh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2022 02:55:37 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140083.outbound.protection.outlook.com [40.107.14.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C749B1FB
        for <linux-scsi@vger.kernel.org>; Wed,  3 Aug 2022 23:55:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n0C+ROSExNeDlNwSpo1l2PVkec+/mdJjZWd0DmjfZbrpxJG7F6O5Pw56MjkrEkFCRxWCANVuE41Wwf4QSXMzQBFMetTiLtWKcIUozNO5kWGNYS6FQLp2bsv2tCvodidIkYQ15VAKZyF+mGfWWrnqo9N/WaJziEPXsS3q2UW+FFZOZlXHNms+nUGG5EAyTNFiYKJZ0L+19BkUCEuwmjOc+FMfzGFiFvLiXjN/kY/MqrX/BZaJXRXufDvqle/T1HZBSpXdFfWsmah/0q1LouOzTqAgKBNfLdKqTCAwXJTAjT9RGXrleAV7FtP757v1wo67uI+lzanglEBg3ld9coYibg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OqPNOtYhGj0TtHP6uxrgS4Dr9+X1OX7GcSZHhJmStUs=;
 b=Y1F1OHXu9RNYwd6eGxIqXyyTH4smSi2Ddi7bfQ3O3AErq/c/DOaXaVmlVD8OV3Ti/b/mF+GFtOonifu5GqdN3lCK9jKHYYEIKt1NnArYvfmm1P010tIWKe2301RB5Gs7aWt3WJ0ELcFl8tccE8ZnYrbUY5Fm6np+pHwoLMkmdcSae6enB+ACukg6Ch8g5DNYNSw+kAp30kPh6Y90ztWOkOBg5d8LfVsrznrl7DoASk2PRbHIZUGL9IcMfZAzCZye4ay6mhWWHqS/cyDDnIWWTxLgwznhXxMEvxI7of1Ii5nXVKQFF8Rn7AWKhX50XtrTpbFt2D1Ntl6OZUrodAqBUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OqPNOtYhGj0TtHP6uxrgS4Dr9+X1OX7GcSZHhJmStUs=;
 b=YJ07daYgkYVgyYJhqNBTXRtO3WJI6TxfSMOpvqKDObpt5s2rJDd1LVOV92DS26qaLwIJGx8hJ9lCXc7+IPobpqMR1xpkbg20CBlFPWqQzAy3tABHPQLtCjq28K9o7JffyA/7jidlxfF3GYNyENlsba8dxLYJ2hmpqyg4mghLDFJG1l4T0lDoLGqGxJNOrgnt63NOC8Hzw2TbrzqlKT/3uTvjujpTe9iDw2xbiCuIGY3Z0IPdMEXwQsQIGBhRcgWEnY0N4rj4zsTWBmFCiUKIhajyIBDn/xC+dj+GsBbKkjuMCELCeNZpsvsqadEK5T1j8b9HJscriRyMX36Ev0/7eg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16) by DB7PR04MB4393.eurprd04.prod.outlook.com
 (2603:10a6:5:32::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.15; Thu, 4 Aug
 2022 06:55:31 +0000
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::9cc6:7688:607e:a3b6]) by VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::9cc6:7688:607e:a3b6%9]) with mapi id 15.20.5504.015; Thu, 4 Aug 2022
 06:55:31 +0000
Message-ID: <cb0b6190-558d-745a-9342-d7d3eadc680c@suse.com>
Date:   Thu, 4 Aug 2022 08:55:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 00/10] scsi: Fix internal host code use
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, jgross@suse.com,
        njavali@marvell.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, stefanha@redhat.com, oneukum@suse.com,
        manoj@linux.ibm.com, mrochs@linux.ibm.com, ukrishn@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20220804034100.121125-1-michael.christie@oracle.com>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20220804034100.121125-1-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8P189CA0056.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:458::33) To VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df49f3cd-d2f6-4d14-ae96-08da75e65233
X-MS-TrafficTypeDiagnostic: DB7PR04MB4393:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e/5ESec4tBO8jMvLcrdwNFr+RmnoUVs9g4QOqQq0BN1++Gs7Ev9vcaSBpSBWFHFMk9iyMuA8/dKhuEYHVMsfxKn6snzTxKwv3ZFh+PE1KZXvQLzpiq7nyx6Tkp45RYo90lMgUtpQeYPsrCuEmnNl8WLfyzS6zQIsfyWox1OIFRx2Nvvt89Ky5znqMZRg8Lukdt5IfDdt9r7kzqq/R8piVFv2RK8Or6FbUxHhoNQXexy794wUXjW05MFLe5wCeW/+QKi6mazBK7ol8It7M3hvCfaWNC7DFgXXvyCf7QZ1hEWhA5wkm0h20xDtm45P8TY33+jXRJEGJ+1j3qU80z4DSHorp+Hb41hInKStEe8Q09rNOQOQ+Y3DSLhs9ewzvDuOYnhGk7P4grs3Y8IQUV4L1/fwxF4ebK/Qv5wgSHXyG3+cmk3WbDxINBmyGBeMcyLrc/ptLAxQB9vcpsgh4b9uscPviXm9jORLcvhgLYJ78kjAkdVPCIUysxCzcWwQrSib+VSxHnm8/bcWj9UfYCnalZLWPvln3kfYWB8Ze9DmkQrvGr3x0dPKM/OW5Xj0hRu4abnhYeyYlDLj7Ogo3YjGOPlyjzk7iyrd8hHijgkuvjo8GBIl60kMT9SRNOPvDezcqZbWtXVYYllUCs+2rR+LJJNJKz0PawhsnqQcjvetiM1G9uOax+RmscfTmT37+EUlWNPlbKHWfMcgxDWad9Ok5GZiM3IwdbPYWgJHd5JjI2qim5y/0lqDLRr5U0jc0ZQ9H/CLZuuo93C8/fK4WGErhrVyfQ3OEouzva6lUcDFo37cb4jSytchjDWT93FFq5WEG2JftqGGw+G7HYT4UagU0i3cth8FeKXPN1g0neMYOo0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2526.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(346002)(39860400002)(376002)(136003)(36756003)(478600001)(6486002)(66946007)(66556008)(66476007)(8676002)(31686004)(316002)(8936002)(4744005)(5660300002)(7416002)(6512007)(186003)(2616005)(2906002)(53546011)(6506007)(6666004)(41300700001)(83380400001)(38100700002)(86362001)(921005)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M2djZ3U4ZlNGQ3loNmFyVEhsZjZiL3JUdGVhZ2Z2T1FFWGZldElJUDRmY28r?=
 =?utf-8?B?RnYwM2l3ZWNSVGg1Um5qNmRXOThWSmFRVlZUSEl6TDc0OU1yL000SlNzRjNP?=
 =?utf-8?B?dnhsb29FcFM3YkU4bVo4OTFLdk8vUWRyOCtuSDJ4OWdWejkxamF6K1NWSExn?=
 =?utf-8?B?MTZ6MS9oOG1pamNxbnd2OXcyY1hkcDJYdTB1NnJvdGVSQ251L1NGR28xQVZP?=
 =?utf-8?B?SnJUVFhYZWhOSUxySWczZjkzRFo2UXdHSFB6UEJRVVB6elNyQjlHYm8ybmNI?=
 =?utf-8?B?ZW93anVmanZIZnBZMENaOTVESWhWQkI5OWQva1kxRnpFa3JrdWlsQ24waHJj?=
 =?utf-8?B?YmVUZmhtbUtTRGZvQjJkWEdBUFVJY3FRMlEyZXJqVjY0bXVqU21iUWJqMkFo?=
 =?utf-8?B?T1p0NFZQczRmNkxWQndqeGNaMCtDcUFRaUl4cmJkcnZKcm9ITDRPRVlzR2Fu?=
 =?utf-8?B?amNCenFHUzVBMUczSVFIUHNnSk56dE5WV3VkeG9nRGdNR0F0bHBuZllqeGxw?=
 =?utf-8?B?OU9HNUNZdUJyb0gxUUJ5QmI1R2tSNlhaYm5DV2hYYnBhK1h5MzNuN3hoTE8y?=
 =?utf-8?B?MElNTEttLzk2UThhQVdBUFFXSmg1YjFJSEc4RUFjM1plSEo1cE05UEs3KzZs?=
 =?utf-8?B?YnBvUU1sc3ZuZU9pMTluZU01c2ZSaHFXRzVvQVE4S2NVSDVCWE41V1pncmNF?=
 =?utf-8?B?eit3OC84NjQrRmpTZFEreVdxMWZ5ZE9aQ0Z6N2tVanNkWDh2SllydnpnU3R5?=
 =?utf-8?B?eFB5WE1qN1FaZGhGVW9MNGlaWG41UHJLNUZGUEVQbkJYU1dVOGFiT21lRE1Y?=
 =?utf-8?B?RFJ2bzNQdkcvdzJudG0waCt6U2FzMEVncDZsTjk5N1dybTJIZmRkbytMZUdH?=
 =?utf-8?B?VCtvTzZsUkhteGNtdTN6V0Y3alVKYUxSNGxjVVo5MjlzWkhRUHg3dU9yQXNG?=
 =?utf-8?B?L21jVmdCZ2t6NytMTUQ5dGduZWtlQkhnZGV6Y00wZEc5ZTNoSzdIa1pvVjZJ?=
 =?utf-8?B?TVZCTHUrM3FHclpRVlRjNG1VbTEzeHo3cXQyM3FDUmplcExZZW1TNUxrdXdE?=
 =?utf-8?B?TjEyM2NtVE1aRU95enpHMzl5OHROZThVQ0xaQjRTQzZaS0Zza0xNcmg0TXNU?=
 =?utf-8?B?UkdlUzI4NHlKSW1Eemk3SXBtTGRuczdHalZ5VXpWTDM0VVk5dnBoVFlMSGQ5?=
 =?utf-8?B?VTZubkxtUXRCcXNVNmozUWtMZkYyZWVuQXMzeUkxVTVuRVl6L3JxcG0vU1ZE?=
 =?utf-8?B?ZHBjRnFsd0lUMkE4c1VLaGE5ZjhYUkNPbnBDMldlWXcwY2RJMFNtczlndE1D?=
 =?utf-8?B?QVVBNkRLcVJrblVJYkZrNGZTd0hWODJLdVBKYUxUN2RYRk9LakhZbkVMS1NE?=
 =?utf-8?B?UlZNVzBMeDlGbmxFTUVYTHg3Qk5UcCtvc0NuckdUQ01QZkgweWJsNUVHQWkw?=
 =?utf-8?B?TXI3cGRpU3pGT2xQK2dhNTZ0YkR4Y3RGSWg5R1NJRExrQStyZys4c0d0Rng4?=
 =?utf-8?B?NDhpVjNPU1E2VXpIYzNGOWxqMUlIcHhXT3NNTEdIVm0wcTNtM0ZVRkpVT3pw?=
 =?utf-8?B?NTNma1htQUp4aExTdVl3WktJdERYRjJEOHN4TlpMbnM4ZGdCN1AwMjdHOFUw?=
 =?utf-8?B?dS9IdDNRbHhzdTdGVlduMEZCMXo1SUVPb0RZUmlxbjFlWVFxaUhFOG9iYUpk?=
 =?utf-8?B?YWw4UEMrZ29tZkNLcVlDUkNHaFRBZmZQZEoraTVmYys2d3VpMXlKRzNUSDBP?=
 =?utf-8?B?WVFBTlhnTmhmVHowTCs4cXVGV1RFUk5Vdnk2NkpRSzZEa3B4QnYyT0o0dXlU?=
 =?utf-8?B?M0hnaHlCZUxOQjBMOWd0K1NkejBSRXJrYnNpN0NhQmdlSDdrcklIcEp0NVoz?=
 =?utf-8?B?NGlmbE5ubTltc1JJUFp1SE9FblIxVEtreDlFNHBzUnBxQjZSR1E4ejcweVBE?=
 =?utf-8?B?WG9oY056REFEbUNMWnZ0UW5Ccnp5eDR1NGtDTDVsQU1LTk1GMEVUVnMzVU94?=
 =?utf-8?B?M1cybHJrRGZ3QW1MQVBjTHNGL1JHTU5aOFFRT0duYTYrckdnZ2tYcE9WTVNS?=
 =?utf-8?B?WjUvdVJBUTJCdFVVM3IyV00yajJEdUR3cmd4c0NaVFZwR2xVRk8wVzRNckFS?=
 =?utf-8?B?aGlJd0dCYjFEeWNjTVFKU2lHQ2liWWREZHNNTWdtYWtERWlkV1hJa21ybmxy?=
 =?utf-8?Q?jGyHAoc0jnIH2/b9dTif44AxoA/kr5vqf7g6qsd2+F//?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df49f3cd-d2f6-4d14-ae96-08da75e65233
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2526.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 06:55:31.1205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zr1uq0/4VqL9FwwZg9I9A9AlW6sdaeZX9ZR5GYxA0uluJiKaKHBI6KqieUFAo5l011tY6LUZA9cH441QMkYSZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4393
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 04.08.22 05:40, Mike Christie wrote:
> The following patches made over Martin's 5.20 staging branch fix an issue
> where we probably intended the host codes:
> 
> DID_TARGET_FAILURE
> DID_NEXUS_FAILURE
> DID_ALLOC_FAILURE
> DID_MEDIUM_ERROR
> 
> to be internal to scsi-ml, but at some point drivers started using them
> and the driver writers never updated scsi-ml.

Hi,

this approach drops useful information, though. If a device
reports such specific an error condition, why not use that
information?

	Regards
		Oliver

