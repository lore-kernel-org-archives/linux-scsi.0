Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 643F6C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Feb 2022 19:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231492AbiB0Tt7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Feb 2022 14:49:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbiB0Tt6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Feb 2022 14:49:58 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D07220EB
        for <linux-scsi@vger.kernel.org>; Sun, 27 Feb 2022 11:49:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1645991358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TKQFrIwS+aK+sRoNVYJGU2TyhKu2r0yB/Ekhkq8xVXo=;
        b=LKlVIXB458NwkM/KAUie/ob+NHR64t0m7BuPIE06MMbDHCaH/D3jtgRLrbqpz3Td26poMa
        FlC2RtDyGD6Ll7JGggsg8vHlKUkaPgUbgwNpD8rgofeC3jxox0/NBn9IiZRpyKi+Yi6l5P
        U8acNayBlaE6bYZNP9njH/u/iP33Szg=
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur03lp2053.outbound.protection.outlook.com [104.47.10.53]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-39-UzpXY15OPcmpWnhUCsVZXA-1; Sun, 27 Feb 2022 20:49:16 +0100
X-MC-Unique: UzpXY15OPcmpWnhUCsVZXA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gZduLu2Jh9g8Oz4zyHnjiRbRwq6cxujBNlTTxu5YbV/q769a1BTDhpgjRaDNmj6PXScMo22ryCapZPB3luoImdAOtrTmc8kZdWz0h3d54gWawjt2LM8pHBJYmEzjhq1abjWTxoNuB0I+iabAxiEcBqVAViUIEsoOMzuaqDV3e71QDuXGCJZL6frAMUamcwOpFOKgZJbfn1wIWbi7pKgsxoBC9SQkHGJMs4Kwl/2Y0QPo4afZY3GBwbb5D9fBKsO/Ri+ATzfXGJAWH8wSwT6GjXdBpiYeM7eM00jdTEER8wYbEE80JXrokz9T4iPdhQerRkhGkehldyKuM4ZelKz6RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TKQFrIwS+aK+sRoNVYJGU2TyhKu2r0yB/Ekhkq8xVXo=;
 b=CGH0b98wulAj8zrRiB+W3riGgDnW8zjeaXDN9I+dAGuQ4wPXYqm/BVp41qjC6NigZC7oZAPELTAlVGw08apI05vnUZo/1O/7WElGR86QxJB/dlaGpMe4iuDMpwxxUI9s2LsMHa5A5liVjqdAzLw/DmGlc+XKKxj0QmsHNqDPO0Hj0ineF32W0wdZ3NXvwIh9FGhDPFjIxPZquo3+Vv4+sosGwCytZMuAqv4ko6D2rsya5gKk49/IuhuvvfiOhOJPhaFjKTkp3s3PfRJbrPPiGdN0w9dq9V+b7BPDghEk6ah/QOrZluVpqyheWoyz314r+W91LW1RlMyUoUK2mkqtiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM0PR04MB6531.eurprd04.prod.outlook.com (2603:10a6:208:178::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Sun, 27 Feb
 2022 19:49:14 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::38e8:ef44:f684:9eed]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::38e8:ef44:f684:9eed%6]) with mapi id 15.20.5017.026; Sun, 27 Feb 2022
 19:49:14 +0000
Message-ID: <30fc2700-1c62-c82c-ba7a-da22e60d4acb@suse.com>
Date:   Sun, 27 Feb 2022 11:49:09 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 1/6] scsi: iscsi: Fix recovery and ublocking race.
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        mrangankar@marvell.com, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, cleech@redhat.com,
        liuzhengyuang521@gmail.com
References: <20220226230435.38733-1-michael.christie@oracle.com>
 <20220226230435.38733-2-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220226230435.38733-2-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0285.eurprd06.prod.outlook.com
 (2603:10a6:20b:45a::31) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54a4a37e-0830-4d4a-4db8-08d9fa2a3b37
X-MS-TrafficTypeDiagnostic: AM0PR04MB6531:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB6531BA852C050423D8169842DA009@AM0PR04MB6531.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iRM23yrl8SewmzNXSGtVMTgNucE9pMpwtWNVIgp/+0R3pPwOAlCeQPTbwxFtGFYa7oi21llF3lQPDEma0Ab4tcJwTYbuhp0SGGrOKUMasJ7dniHq2MdaPECB3Yiq+58k3UF6mR5Mzz/mJB8U/2Bx6FcRz0FWewFTdAMRNmMyMZIfYk8wkq1HA11q2X/HYLn5Wr599lVzfyM8+ldEUNdDaTCgp0i8d/ttu5764kFQ0q6Oiwku6+vfA3QLScWk1kA8LmHz+7jL/nbydo5kln7MbVBXHNgErS62+xfxmHUPJoXjpXhc9U+8L+0iLEMgdiVyP7/km/hJv+Tdjj6ZcetNBT7yWY6QeeWHKJvLmVbT7jB8YdkUM98KU47msnsvT20vhuqiv5ZQ9OM8Yy563/UwChDsBHfsrnL8A3M/K4KYmR+n1IAhljhUWwNKalhaDmEXo8QGbFxuJ2etCbaRS/HvKcDLgR8fKTr6uKE62bX17FP6EOczFyp7ve72FZ/b2xEyxX0Gp2l2O6X6FcXkfYyQ9pKGjLhU1cQytH3iOfwbb8Q9zQ52xGtnOxqwrCfUV2QsWEC2vxf3ZNOQVQiD/hE0vQINkyy2hnN7ImfmpKKs5TEaUoAp5+6TkgYyxJ2/rP0pcpru3meLFNbyiH6win/KAmnUrS6HGY0FQ5d3haft3TpOLoTNauPhD8vbgAqfizXEx51oZg8ICwP0d7tYPXpPoQZajXWKqnX3F9PR7yjwER4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(31696002)(316002)(36756003)(31686004)(53546011)(508600001)(6486002)(86362001)(38100700002)(186003)(8676002)(2616005)(26005)(83380400001)(6506007)(6512007)(6666004)(8936002)(2906002)(66476007)(66556008)(66946007)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?czVpNUJ3N05DdmtqcGZGT1BWREFRZGgzeXJlR3BXN3QwcW9tUDZrWGtaSGNh?=
 =?utf-8?B?dFF2TXIvV0FXdzZ5MEQ3ZnlyYkJ0dkYvK0VTWURnNEJiYjhxM0RYV2VkZUUw?=
 =?utf-8?B?Tlh3cFhrRWZLM201dFFrZFQvR2ltRmc5TG9FcUgzamt1TDR4MHRsWUJiSGR2?=
 =?utf-8?B?Z1Q2bldpb1J0QkhIWVdxdStVSWdCV1ljU25KTDB5MVFuc0NlSmhwSTdpWXhq?=
 =?utf-8?B?QXplYVRoZWRoZVdnekpuTEZhUGgwNlFCVG1sZEpNNzc4MkRjdlhSREFKZU5B?=
 =?utf-8?B?OHRkakZwSkJQR0Zrak96c085OTBRY3R1Vkd5bW9mOEpEYkhGa3FvQ0tMSzlr?=
 =?utf-8?B?ZHh2TnpkRlhNOEF3V2lkMnA1RmFVQ2kvMzNvYWNtR1FaT0xpWWh0NlVSb2Zx?=
 =?utf-8?B?QTQ3Slc0Q1ZtT2daNDdXNk1LcXFCV3ZFM3hUbGtlSmI0YjdzenluaXdQVXZK?=
 =?utf-8?B?YlBqYW9QUWJuT01tUy9WNW5nSVB0WklqdHM1ak9mL25wOG01ZGNPYkdUelN6?=
 =?utf-8?B?UzFndU1ZcCtpMkV0RTdyMzc4QVloeTBUK2NRWC91ZkF6Mzd1Ykt1amxQdUUx?=
 =?utf-8?B?QWNrT0ZSM1VFRzdmaE9rTGM4aVVGczVER0pLWi9KR3NVaVNFeVlzQTMwL2t0?=
 =?utf-8?B?Wnc0WDh3WDhYbnU2Rk4rRVVRZkpFbnowTkJoejV0dzVoZFJETTJCelhMbHkx?=
 =?utf-8?B?TTBXTExBM2s1eGYrbWtMYWUzS0IraXVGYVlGamh3U0VDQkZoNXdiY0doaFJX?=
 =?utf-8?B?NklHdVdUcnprRU1HaEliNWJXVEI5VlIyTnZ6c0VGZ3VoelN1cWUzY1RkK3hw?=
 =?utf-8?B?Q0VlUTBVR2dENnNaUTMwMWcxUXczU1BlZENGa1F2MEQyUVJTMFh0L3ZhWHdH?=
 =?utf-8?B?Qi9BSHlmR1k0dWRJQzNpTG4xTW05a2hSR2tmMDZ6SmUxaUVEZml1QkZJZmJ6?=
 =?utf-8?B?NjhvbnE2WWEvRHpvS25SRS9QeTdlamRwYjZ6RG9FSE9GVHVRTTZ2SnIva0Yy?=
 =?utf-8?B?cG45Y1gwRTk0V0Z4V0ZuUUE0UVlEc0laY3Fwclg3dGlCNHUwZEx6VVpEM3o2?=
 =?utf-8?B?WnRheDdObGNXUmtEZFoxTGkzMmxQeThZdWVOZ0F1bWtudzJRc0NSVXZERGRt?=
 =?utf-8?B?OUhER0VLdlViMUYrTUpRenFzWlJUV3dxYS9YMmpzZzRyMkk1OVdvaE5IdHR1?=
 =?utf-8?B?dUJqaU92cXZseW1tajB3UXEzQUk5ODVOVVNyQ3JkRXBySXVuTk1jcklldFRD?=
 =?utf-8?B?Uis2MjZyVWJwTnhRYTNIUWxmWU84THljclFJVkNSNHk2K1lESGg5ZmpvU0xW?=
 =?utf-8?B?Slo2VjB3Rnh2RzJmZ0dMa3grMWJHSzZmbEEvbHVmRXJuUGJMV0lBZEl0YmxN?=
 =?utf-8?B?VStFV1FGRWpheXZyN3l0SzBpamYxWHFsQzZNbngzV0FMQ0NkSk5HanpNa01s?=
 =?utf-8?B?T0pxeEludTlVZVB0bWtZYWx5ZGl5NzFja012NGl3elEvSGVKTVdRSWZGV0hL?=
 =?utf-8?B?MHFIeHNoRmRiWStxQStFR0tTRmE0UU5hMHpqdXNHajJRWDJvbGxSbjRzamYv?=
 =?utf-8?B?SkVSdlprMkpnRUNtR004eHR3R1c4UkQxc1Jsd0JwcG04YTJNamhKWXkzSGYx?=
 =?utf-8?B?dkR4MS9IeU41QndNRHRsRmtBQi9oWXhBVC9BVS82Vi83SWxpWWh3eHRlakpy?=
 =?utf-8?B?QWZORHI2TUJqTEQ3Q2lqQXJmWjNUeFIzSjIyL1VkUjFJMHhGb2l0UzRPaGNt?=
 =?utf-8?B?TFRkb1kyV0xTZFNDMEpsdUhGSlNaNDNBYU55ckUvTE9rUi9jaEttMUdoWTk3?=
 =?utf-8?B?RE1KMzBvYUxrT3ZWemdySThpZnNiaDdMR1NnVC8vQitSWmJCa3FzZ0kyK0xB?=
 =?utf-8?B?Z2x4R0hBa2p2aHUvSGZrMHFCZ2tZaFB1Rzl2eDQ5OWljb0VhMEg1STg0dTFz?=
 =?utf-8?B?LzVDU0tpWEJZQUE1b2tzcWxzZ3EzQkl6SmFRamwvL2NHSzZZNTJ2MER0T2Uy?=
 =?utf-8?B?eVArODlSVUo1Qkd0WDlJeTZ6YkNVNmlHTU1PVGExM0JhZzF5MEd1WkFmTU85?=
 =?utf-8?B?TzU4akNZOWpXZmpEVFhaSmNiQzZyTld3YlIxZWVXT2FSa041NGc3M0ZWNG9i?=
 =?utf-8?B?S3Z6L2pydlgzYysrSEQ4TGh5NHE2RjRtUm43SXhaTzVTd2ZESXZuWW1UMkYw?=
 =?utf-8?Q?zi+HC5egZK7xIFQUt2z6DaM=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54a4a37e-0830-4d4a-4db8-08d9fa2a3b37
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2022 19:49:14.1186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WuyxKK6CmmdVW2ovAci7nj4wqYLg5w9vikOvU0XxV+Qbo/H5fLeDoCbutl9A/uvUIxm16kMc0ekijULS4g8/pQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6531
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/26/22 15:04, Mike Christie wrote:
> If the user sets the iscsi_eh_timer_workq/iscsi_eh workqueue's max_active
> to greater than 1, the recovery_work could be running when
> __iscsi_unblock_session runs. The cancel_delayed_work will then not wait
> for the running work and we can race where we end up with the wrong
> session state and scsi_device state set.
> 
> This replaces the cancel_delayed_work with the sync version.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/scsi_transport_iscsi.c | 7 ++-----
>   1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 554b6f784223..c58126e8cd88 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -1917,11 +1917,8 @@ static void __iscsi_unblock_session(struct work_struct *work)
>   	unsigned long flags;
>   
>   	ISCSI_DBG_TRANS_SESSION(session, "Unblocking session\n");
> -	/*
> -	 * The recovery and unblock work get run from the same workqueue,
> -	 * so try to cancel it if it was going to run after this unblock.
> -	 */
> -	cancel_delayed_work(&session->recovery_work);
> +
> +	cancel_delayed_work_sync(&session->recovery_work);
>   	spin_lock_irqsave(&session->lock, flags);
>   	session->state = ISCSI_SESSION_LOGGED_IN;
>   	spin_unlock_irqrestore(&session->lock, flags);

Reviewed-by: Lee Duncan <lduncan@suse.com>

