Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40599C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Mar 2022 19:43:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232481AbiCLTo0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Mar 2022 14:44:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiCLToZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Mar 2022 14:44:25 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BA356C0F
        for <linux-scsi@vger.kernel.org>; Sat, 12 Mar 2022 11:43:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1647114198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cf5lgEyGH1HPKX2dfpWrwRhE67i2rkh5iB6KGQAz/sM=;
        b=Yrs1H2msR/uPwcTYY2DuF7sx29825dCerSwFVINuZ+aNegrrDcaDuaww/CmCusxRgEt3R5
        G/nuf9nr3daKpgkcN2uu+iEkRKYuzK20i/Nsq/kK4ocB62I2swXUxN98/agBwWTUXHwcFs
        8MkLbsdluqeKMAwTBx0wKXtRK397WGQ=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2053.outbound.protection.outlook.com [104.47.12.53]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-20-qYAn8CVgOMeZOPd324jonw-1; Sat, 12 Mar 2022 20:43:16 +0100
X-MC-Unique: qYAn8CVgOMeZOPd324jonw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LrzYBBkw3uA1upE6MOvbJjuyTrERMDJmvOa6trPuX6SbOgS1kMfcqONAiavRHgFIvQ2lxiOte7ptpKgmZCUYy9SyvC9sjn7JX3omQBttclnxxMZDxdzDtdwgXzQSwHfIch/1zm7kDvh/M6vPyIsKnKOeIvyRIROtocb0x74kv+fD6HOMKuEjd3akdewGi+2NsPEU7ykfUqke5JtYjz4vUbjZtiUI7nNoXmpjInJyvEofbYbEtySDWs11CfmmWOhEQGdU1ozGz09yttRJRjoFovftRFO5CJcdTJFAnpPjuAncGx850oeDczRLvfu8qYIGDwnTO3B7HiXrggWxPwsDGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cf5lgEyGH1HPKX2dfpWrwRhE67i2rkh5iB6KGQAz/sM=;
 b=Qzwzz+Xa2O8i67y366i9vnxA0+FAJvwxHLao77fK4HZWgrLFPude9r54uYt8o8lYM62awCdRgw5QQZT3ATy239UIHJpUxJNBG8oZjEWbfonB186Z+VV9B8aA8gL4wf6+4gG2t3i0462qK/Vs355Lo3Qhq4Z0Zz7pLjKZJr5wrajZ5pzp5xXRuHlEHYyEpcf0/S6YEGvSE5hntld5AXx/DTesk0j8eIyuTm9Q4XQHN0sEC3oMRYH5Y9vwpUeMOK9WPvLJ68J1d5d8TdBxjNDaXhz1pogBHfXkkNOrxrdUsL37CvbjmPTYkueML1GtAZjCY5MhwZwo+Q0NjEd1140lzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by VE1PR04MB7215.eurprd04.prod.outlook.com (2603:10a6:800:1b1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.25; Sat, 12 Mar
 2022 19:43:15 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::14d7:55aa:6af:72d7]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::14d7:55aa:6af:72d7%6]) with mapi id 15.20.5061.025; Sat, 12 Mar 2022
 19:43:15 +0000
Message-ID: <dae68506-82fd-541e-97d5-5e761c82ecf1@suse.com>
Date:   Sat, 12 Mar 2022 11:43:12 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 07/12] scsi: iscsi_tcp: Drop target_alloc use
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20220308002747.122682-1-michael.christie@oracle.com>
 <20220308002747.122682-8-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220308002747.122682-8-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8PR04CA0176.eurprd04.prod.outlook.com
 (2603:10a6:20b:331::31) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c4c9c8f4-fb21-43c7-7234-08da04608d03
X-MS-TrafficTypeDiagnostic: VE1PR04MB7215:EE_
X-Microsoft-Antispam-PRVS: <VE1PR04MB72153C79C5B7E1177CC856C2DA0D9@VE1PR04MB7215.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9OK1Q2IUgo+ukhb1xyTZlB9leUgI4JkPra1pS1UXxoUdz0co+okIp7jbaiMQTJLXOI/Z6Z/NpzikStO3o4HZFo4a27dZdmkxywny5mt02jZAf4zUjJsnPHV4bcbIZ4O7cPWdQa8LFccpEA2dQACVUvzRWSD8RbZFPWhg3d9ME4ZsjAJ8WOu+SPD1U+AV7WyIn3hhJxKpNtRT79Fpo9klfTaPI53cdpNlu816VBO02Cxg5geVEoxqRNufcaonxwL6v32M0r8JY/G676W0R6ujP8VUM6w4ohMyuGxJiCz1xfl+458vyL9YxPl/5CjspJ/MMhOBH7W7+R/vep8rn3gy0Gl7PEEXgmR80cARVCXvmBjixHgTHqpniO0iAmj7b962bOxm/PKgOetcKYQSf1YlA/zaSjgaPw9cskAHJd9lq8M/WTQx+S+3ZDvan0YtLxDeDxfa1vDM+eEQOZ/6Ixfo1RYRyQFSnE27tVKzk0FzKraaqZkHvSAqdaIhjy6dhcRGgsfngmfJ+A3EEVCPjnVjbGEP8vEkTNn3HzAi4cdDdSesQ3NmBoPzxnBsok/8bkazzm42OF30ALfh2iEH5nDwCI0Ghi6dAsordxCWohhBRNuY6IVsjGFEfAxK1iAq0gQaYDhuS5XeYDahhAgkV9FromUHHdykltWaLBmU6V2/2bAN05qhR990QUHkw0qK6xMwB6nIibXbO+H3wKncdFWdFfG3cvI3h4+Szqli9wtqMzg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(31696002)(86362001)(2616005)(5660300002)(31686004)(53546011)(186003)(26005)(36756003)(6506007)(4744005)(8936002)(66556008)(66476007)(8676002)(508600001)(6486002)(66946007)(6666004)(83380400001)(6512007)(2906002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UDU0UkF4OFdRMVd4NWVkWENwT1I5MTNsVFI1V0tMUm9RMnhZWjN3RUlzVHNm?=
 =?utf-8?B?UEM4MHJkMU5zaElHN3pvbHExL3JxcnlLWFlkOVJoM21RaWEySWdnbXZ2ZDJs?=
 =?utf-8?B?QkgyTUhpdnVibDgybTF5MlM3ZXN4UjR1akZ2M1NQWGcvODJobm5zaEF2aUJx?=
 =?utf-8?B?ZlhMakdMYm9sR2RGSnNxQkNVOU1FM2dZa2kwa0hBcjF4OCtpOTAyRUtGcUxH?=
 =?utf-8?B?ZFliN3FiYVk4dlJEd0dvT3lEVGhsZGg3UnU1MGVveTNOdXVNMkRwb3M1MEl0?=
 =?utf-8?B?T0h4bWlWbzBveFF3aHh4UVcyVFZFVTlwd3hVM2FocWZkaGRoZVJLOVNGVDZF?=
 =?utf-8?B?Rkw1TjF1OUhEazNPYUh4N1pOaWNSTGlHbzNRVUZDa2FySlVxSW9EVGVSS1ZC?=
 =?utf-8?B?eU1mK0F5LzJ2b25YSUNXZzdMN3pVNEs2OWdQNzM3dGpqR0dGRGs2V3NvZUU0?=
 =?utf-8?B?L1hYeTU2Q2RrZFFpc0V3cWFXYXEzNFEyelMrVUg3b2IrK1NiZFlubmxIMjU0?=
 =?utf-8?B?ckZlUkdaNElZa3MzbStqc2NhVkJHWHFnVFZDanBlQnltbHEwUXZpbFdUbVNt?=
 =?utf-8?B?VGZFbEhrWWtnRVVvNlVzS3ZNaW9MOXo1ekdCbThSYmpxemZMSWJDU3V6UTZT?=
 =?utf-8?B?eVRsUi85UGViK2dZc1MxWFNhbkxDS0UzWExGVWMxN044eVlmTjFxUFdRSnBW?=
 =?utf-8?B?eld2LzluZXV4dkk1L0Rna3NHNGhSeGxmS0V2S2FIclNsN0hzeVZ6NWphbWM4?=
 =?utf-8?B?SHVoM2Rud1FSUzFTclovYmxNNk0yRWl6ZjJRbm5oWk1SMVdNU1dzZ0lyTmJN?=
 =?utf-8?B?dFlrQmM0OWV4M0lBSDNXdEZyUGRxYmg4VkFMM25BM3JUVDRQSFJhQllkVzRS?=
 =?utf-8?B?RFdqUFREUlRtNGdIZnU0S1hjV1RzRXl5OFFvaVQwY1pVRUU5bGJFR1FLSC9Q?=
 =?utf-8?B?cWRUNHRYeE5Zc1BSSHVpWjBxMVU5b2g1VllCa2k4K2cvMVpMUkJqcEwrYVlS?=
 =?utf-8?B?YndtN2pHVE5FZnBZN1ZYOGFlZSs3S0UwcVZuSHErZmtqK0tKN0pYRkp1dDcy?=
 =?utf-8?B?eWU5MXpnSjI0T2lsUTZyZHdFSGJ6NHE0dzFTZkFGVmFnRWt4OU9ZQjByVjM1?=
 =?utf-8?B?WHFPNUZyMmtPeEd6YjBRMWlCMlFFZ3cvOHlVTXZnM2hLRUF4MzZENGdvOFF1?=
 =?utf-8?B?V0EweG11MWxqQmlrK1p5NEFKTlJ2eUJ2c04vYmZTeGlJOFRIc0xGOWE3cWVG?=
 =?utf-8?B?SGFpenhvWFJGakNDMXh1SFFpWVVPMWg4eUhYelF1ZlA0VlcxOEFlTHIwSGhO?=
 =?utf-8?B?aVlkM1NTUks1SUR3RjY4N2ZZWXF3dk9WMGJmRzF3dHRsK0NUYUw1MW5udnpo?=
 =?utf-8?B?WXdhQXVSYTNuK1gzbi93L0ZRdWdNV1VJUittS0RsUTRIQUxMcVZXRndGWnhF?=
 =?utf-8?B?ZWlMU2xLRG44NWZwT25ucXlySnN0b0xpRE0yWUtCQXdTemwvcmJRTkY0UUgz?=
 =?utf-8?B?S1NXRCtQVVJFKzRHNEEyalNsc2Jqa1VJcjZPZ3l0aVV5bkJOS0pvUzRnbE9I?=
 =?utf-8?B?OWVXUENZMGZHSE8xYVBCaHcrVC96ZkVZTSt0ckdxcHBLNW5ObmhaZmVIQVpl?=
 =?utf-8?B?VUsrM2xWVHI2UVdwZFJrZmdFZTNZQmpnSUg2aUlnV2kyM215MVZzQ2pxYTh3?=
 =?utf-8?B?TUFPK3QyajNaUTVKZklDTTBjakRUMHc0RUFaR0ZMeURFUmdReGJ3U0k4VkFj?=
 =?utf-8?B?Y2RvS09rOGg4NVRDMW95bFJMQVB6SXRsWnowemh3MFZ2bllOdkRLSlJqU2Vu?=
 =?utf-8?B?NkpUa1VERmt6bDhJZkgrbnN1clJ4Uk1SK1UzQ2JqQnFPdTFaa25ORW0xT2lp?=
 =?utf-8?B?cWlrd2Y3QmQwNWZxVTY3NW1MbzBENXR6WG1KbHlCM3c3eTh6U1ZGS0ZPSFBy?=
 =?utf-8?Q?Zdh+/1X5l3JGz+miPb8kd+FBx8Mrh88W?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4c9c8f4-fb21-43c7-7234-08da04608d03
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2022 19:43:15.6312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bvw51ksC9HydFpaw4k397Jm5THJWpRzgQGyKzHIRdjTYT5+vgG9Yx3JX4C+P2KBE0bFBPt9AI+XNxk7zdG8xvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7215
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/7/22 16:27, Mike Christie wrote:
> For software iscsi, we do a session per host so there is no need to set
> the target's can_queue since its the same as the host one. It just results
> in extra atomic checks in the main IO path.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/iscsi_tcp.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index 3bdefc4b6b17..974245eab605 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -1053,7 +1053,6 @@ static struct scsi_host_template iscsi_sw_tcp_sht = {
>   	.eh_target_reset_handler = iscsi_eh_recover_target,
>   	.dma_boundary		= PAGE_SIZE - 1,
>   	.slave_configure        = iscsi_sw_tcp_slave_configure,
> -	.target_alloc		= iscsi_target_alloc,
>   	.proc_name		= "iscsi_tcp",
>   	.this_id		= -1,
>   	.track_queue_depth	= 1,

Reviewed-by: Lee Duncan <lduncan@suse.com>

