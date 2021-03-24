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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6A94C433C1
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 17:25:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B4D261A19
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 17:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237073AbhCXRYp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 13:24:45 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:26542 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237033AbhCXRYd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Mar 2021 13:24:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1616606672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kWz94vQgNoVKO0W4032KneOrDXBF9WEzX8FMjOtNwgc=;
        b=LO/QuX4F6CagJA6aOyxZv67SI7uAskAPLtuSN3IfZPHIWErybmIZxZ8x5tXmBtb2gRJFqk
        yLDH7ac5uJrbLIXcljN4B9nt68KGL7picied8OUEt+OSfCKdTKRj81DRL3z3g6tLyi1fc2
        9PfmZcsZzCnyD6upXQ0v8cclSxQCybo=
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur03lp2050.outbound.protection.outlook.com [104.47.8.50]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-8-13BXQjVpN2m6b07TeiapeQ-3;
 Wed, 24 Mar 2021 18:24:31 +0100
X-MC-Unique: 13BXQjVpN2m6b07TeiapeQ-3
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q//f6o5aGk5LriuQJC384wNMi8s3ivqndm0ESkAl0OXdzC7zVLd1IU6Ezw345fi0BbbMnPOU+Co+Nxn73TA8k4FPXLs+ZlxcD/FyEhPkMjAAsEmNp7MJEqHEN+OcNuVpL5TRMPeFCrAEeP9SzwZrIF0nHoZshArccaJWKs9nJyMXs6Kzp3JFJw785POt97QfEbuugp1EZ9u2M63Ad+Q2tGAR9ye1jud/fZkajaPOlLpgJsURdsjE05yAgLhtCCPc5b/Gv50jkBZ5xnes0ZtYRP9P0JzQ9NSfQoNvP0WOFhhfXOcoDNX7qV01BFVNaG5adktUyp4O7z/Iez1K1nINZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kWz94vQgNoVKO0W4032KneOrDXBF9WEzX8FMjOtNwgc=;
 b=JYEw7nRM0/vWaYCtxSxaY3tjE1OSoARMaSD5O9vakguUQx0FWFthbkOAF3szhSdQkV0K098TmhPAlY2a3u6jzENnFLvXU8rkBpnsEo0tmYpHb1RdXmv/Q9elnGmN6w1FzNvXIpM0Thr66rhGmIutHxVsctYN47yLVWQRY+Ia2LgW1aFgO06HVT5HH0AJhjQ+PYy5txn3Clfh2Tj5C4QUORvPRmtgX8RZrM1Sbn0ndZCp+pxFaA++/Xp88NU74gRn23OXPtwx9zddC/UcZBlpQwmQJnw1O/NwviPLUmH6WvQAHTbHhbJFfuC/nw6dgFmzjyVK8D65+F9Uk73SfPhm1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR0402MB3925.eurprd04.prod.outlook.com (2603:10a6:209:1c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 24 Mar
 2021 17:24:28 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72%6]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 17:24:28 +0000
Subject: Re: [PATCH v2 1/2] target: pscsi: avoid OOM in pscsi_map_sg()
To:     mwilck@suse.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        David Disseldorp <ddiss@suse.com>,
        =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
References: <20210323212431.15306-1-mwilck@suse.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <38c3aca0-cf28-eeeb-b2c2-558379c6d762@suse.com>
Date:   Wed, 24 Mar 2021 10:24:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210323212431.15306-1-mwilck@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM3PR07CA0114.eurprd07.prod.outlook.com
 (2603:10a6:207:7::24) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM3PR07CA0114.eurprd07.prod.outlook.com (2603:10a6:207:7::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.10 via Frontend Transport; Wed, 24 Mar 2021 17:24:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ffce9fa3-6f81-4b99-eb1b-08d8eee9ad93
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3925:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0402MB39253E0385485A63D6BD128CDA639@AM6PR0402MB3925.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UJLkFKCBwWa8fz8E2nl+iQ/LwrcfX7Y5vycWmWI+WU8YBVqHKYo79bD7j+Uet9qaxhW1jnhJyT772S8fdtR9Rv2MeKO2hWTOI5bZzivKaDWYHk3WEJ97dm89F4hiOaJF1rzgomoweFr/uQmcN3w9cfxHyiXG9cQyxdjdSdUxvAo3m/ML9W9CZU0V+I4XXPoO2yeY3+vT09WHVJOlu00omxFJ4emyeeG5KcjTYPetaKYubDvHf7K+a/VK0lBPmPLOzjOwGcQM3uAvX8LEHw+0Cf+IUQ9FH7YXyY8EAItUv9pzHXOepa2SUwul9tQ/mw8o0sfK0cvOS4TuXH6LghU7h25XVpr0yYsxJSJvrRu7fkaJ5SocxMQy3cmlVufzXYp6aOoN6Px+6qg83/Kv+gAzwsY9uAMVSQMSYPJOCtRKYcZ7rhMv7n/DLuXY30AfcG1uhFzPG7ygzWoVK63eYj9MYsEBx6O1uAGeU1TL1oNQ5kmX7VDbiRmNfkF72vf87Izff5Ou3QirGBKijKINKlSEAkmiv0duYyk9pUViHA4OmqohdXLJZFmtZrbq1Kowezzf2784bS7jhBaa8DzLa+srbEZBL/kgbxMTlIHj7kbipspUq/wcyWlwifgNNVLOL+2Q8btPZPqxLP9Yu4oTa60LqlcOtJJ3xg4TZ36u09NpfBEovvFu5/87frqEynxpJOFnT/tFv+gFTMD6fF2rUztCnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(396003)(39850400004)(136003)(26005)(6666004)(53546011)(8936002)(186003)(2616005)(478600001)(38100700001)(956004)(31696002)(2906002)(83380400001)(31686004)(16526019)(86362001)(316002)(66476007)(8676002)(16576012)(66556008)(52116002)(6486002)(110136005)(66946007)(54906003)(36756003)(4326008)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?a2R6LzkwbXBFRHhodGFJQkRPUW1QUHRkb1ZrVTc5ckZIYUZLZGFienRrY3pB?=
 =?utf-8?B?YzVDQzZIS2pzNFlZZXhIbzc4eUJxQ3ZqRTNzQnNIWnVvTSswRVVXd1huZ0Zl?=
 =?utf-8?B?MkExcnR0ZTNKWjBoeDZSc2pvdEVMelRqckNDcDIyYmhaMzNJemFoVHc1Zkx3?=
 =?utf-8?B?cE1vWWFSTE56eHloUUpCRzQyZDZNVno0MDhxZWJUTDJ4d2FFUHV5ODhLZFFE?=
 =?utf-8?B?YVB5R3l1RUZYaWppOGxkQmdPcnJNVnZONWVSa09aV0FsZFZFczRtYWd3R1lO?=
 =?utf-8?B?SzUyNTAzSUYvVjdHWHZkTTlVNUNCNkpQQW0rVlgvOGJyUy9hcXZzcXhSVjNy?=
 =?utf-8?B?aUVsMTRrUWJhVTFLN3BsazVKclRicVdvbXdCZHVtMHA2dW9VT2pIWjFwMGFI?=
 =?utf-8?B?MGxrdDVKUWs2dkhEejBGL1FWOHJnQ21hUnR4Q1VMdld5MUxhSmQ0VXhXRXZq?=
 =?utf-8?B?dHFxUDViN1U2TVFMVXQ4WTErS0dwZW1zS0pRcHF0ZWhqUXdPQXpyY01sQnRn?=
 =?utf-8?B?dzBTdWFjbTZsRjhOZkNEKzhJZmxFQnVCQ0swQ1NWYUdRNzJkbHpkNzN4MmRL?=
 =?utf-8?B?bW53T3g5OGIxeXlWV2wxQUM1WUZub2FmcFpEU1pUSTZrL3crSG1nYmV0ajJK?=
 =?utf-8?B?c0NPRXhwUjZEanl4dS9XTkRCSW1aa2MyWEdmTmFJbWk5cEY0eGRCN1o3K1Zp?=
 =?utf-8?B?b2c1aGtOdUt2NE9oTTBJWDRtOW8xQnpVOUgwcFN1NVB5eS9wblFmK3UydnlB?=
 =?utf-8?B?elcvWHBHWkNPVWFydXpaSkhKVzJ4TDg3NDFuSDQxQk00Zm0xM3NWemVHS1Ry?=
 =?utf-8?B?SEcraFFZaE9DenVMU09ZSnZFYzdZNEZodmhERGh3OWY0ak5NODd5bjJCWFB4?=
 =?utf-8?B?bDlDdG05aUs2T2pEQUxaNHM4R1VRS0NBZm83L28yK2cvMGpVYmRlRFBnRXk5?=
 =?utf-8?B?bkhBa3pHVURLdkxNQ0p5REtqM0ZPTU5RNmNsWEtpVmgxVXBVNzIzTk1IWW56?=
 =?utf-8?B?MWkwZ3l6aTRGRnFwY2xnRjBlZitRSGNZUm5waVBGLzljYS9BSUJiUmU5YUg5?=
 =?utf-8?B?MkFiVU0ySXlCajJ4M2Z3YTFkRWFRMVJId0VRcU83Y1kvakFmU21rRXhEMjdI?=
 =?utf-8?B?Nm9tYy9KTmVxdmF6djFMaDJCdkRCaUhtUEJQTnhxK1NLRXlkWFdENFYvVW9J?=
 =?utf-8?B?YnR3MXVyUzd0ZkNHRUQrcDFsbjhxOW90eDg1Qi9KV2piZzNMTEllekNmTEdx?=
 =?utf-8?B?WlVWdW9xRDJ3RHpXTGNQOWtGeDc1UXpzRXdBVmRuTTRxYzBlcWNwUEZqbEFK?=
 =?utf-8?B?YmdsTkt1ckEzb253ZFJLMTRrc0pNelBRNHEvMXRuWmFLOGgzeFZQeHNsVGFC?=
 =?utf-8?B?T3VPRWxIKzE3U0tIalZEaUlyS1YxNzNSeWxHYlpRYjRyVnVsRy9MTmtKQnln?=
 =?utf-8?B?b01Sam90SXpPWVg4aTdyVUVTeEhieFAzK2F6VUp6bmJRMVoxemo0NU5nWmsv?=
 =?utf-8?B?RHh4b1hlWmFiOVFLTCsrc2RheWVXUjlJWXRqdHlLQXVDMDd5WlpQMGw1S0Z6?=
 =?utf-8?B?ZWNGRDQwMkVnSG5VVURuck5VaG0vaEIrUW5xS0RMdUcrekpvMDhrNXlKZXo2?=
 =?utf-8?B?UmgyKzFhMlArRjNzWCtFVURVM2NkTTg2RTVxcGViTGwxbzNBS3J0c2NJbW5r?=
 =?utf-8?B?ZWwzZDVKMjg5OTI4akw3c0FIUnJUSU9yZjBzTjJOaHlML1BNYkJSRW9RckVP?=
 =?utf-8?Q?Hy5dwwA/2xOBdrVXxqocW3j86lnboaa1QdNoP5t?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffce9fa3-6f81-4b99-eb1b-08d8eee9ad93
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 17:24:28.2336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V/Lx0bMFuXh3M0gW7JefYECkXHd21wteF4jI3T6GYJv3ckUN7Y4aLV7b7sSxY3mLpFEyclPxZM/r/Xign1YH9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3925
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/23/21 2:24 PM, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> pscsi_map_sg() uses the variable nr_pages as a hint for bio_kmalloc()
> how many vector elements to allocate. If nr_pages is < BIO_MAX_PAGES,
> it will be reset to 0 after successful allocation of the bio.
> 
> If bio_add_pc_page() fails later for whatever reason, pscsi_map_sg()
> tries to allocate another bio, passing nr_vecs=0. This causes
> bio_add_pc_page() to fail immediately in the next call. pci_map_sg()
> continues to allocate zero-length bios until memory is exhausted and
> the kernel crashes with OOM. This can be easily observed by exporting
> a SATA DVD drive via pscsi. The target crashes as soon as the client
> tries to access the DVD LUN. In the case I analyzed, bio_add_pc_page()
> would fail because the DVD device's max_sectors_kb (128) was
> exceeded.
> 
> Avoid this by simply not resetting nr_pages to 0 after allocating the
> bio. This way, the client receives an IO error when it tries to send
> requests exceeding the devices max_sectors_kb, and eventually gets
> it right. The client must still limit max_sectors_kb e.g. by an udev
> rule if (like in my case) the driver doesn't report valid block
> limits, otherwise it encounters I/O errors.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  drivers/target/target_core_pscsi.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
> index 7b1035e..977362d 100644
> --- a/drivers/target/target_core_pscsi.c
> +++ b/drivers/target/target_core_pscsi.c
> @@ -881,7 +881,6 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
>  			if (!bio) {
>  new_bio:
>  				nr_vecs = bio_max_segs(nr_pages);
> -				nr_pages -= nr_vecs;
>  				/*
>  				 * Calls bio_kmalloc() and sets bio->bi_end_io()
>  				 */
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

