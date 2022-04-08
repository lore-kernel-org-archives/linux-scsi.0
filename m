Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44BA4C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 17:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiDHSBh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 14:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiDHSBf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 14:01:35 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A532118546E
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 10:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1649440770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HLpzDWxSGlPwEVLLm83ohBDnu2JeMOID5Yx/xIvdYAE=;
        b=JALSh1WhwyPpSiHZskXOYMyK6xNM+E7drg7km+JIayd0/kdqd3zgsf7hxJL8SUWnxVf/iK
        f1zyLSPw62IPnqYM3xRzjvxEYpwTTapctnXnB43Yx7dky+AqDG+uA8LhMd/rzpLyyRQRF7
        0To6AKq4Ackcs3tUTgbp+D325Lo5FUI=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2054.outbound.protection.outlook.com [104.47.12.54]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-11-NtC1y_oCOiGat0_DSf0fOA-1; Fri, 08 Apr 2022 19:59:28 +0200
X-MC-Unique: NtC1y_oCOiGat0_DSf0fOA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nNnHALXwudST2jmx71GLhy+h0T5BygTe6mFpF2xPT6JNqcldhc8tUR1wFqdC/spTsvpIkbMk7gAOx9ZZfUKS/OA1azrVgDKrFatzEqfeWtJOPvyFjLIcpcXBWezSyU/yZ+dznEC17MWf+cl7mpG7EJu/iZD1GBdKeIUHxcO0etrckvcRk7djkVt+EWwvE8zYutEKSeETb5WC7Uw0CS7rbY/tESIYA0ro/xLEqu/6D4GTpVOTU8nIUDO7+dGV0u+3Xl8gOPyNjXqF7wHhfGpSKqpRkqVN1fOv4HFAkRBshX1vVRL+4d9P3wtWqrPHvmbB312JSox7eAHN5oNQWqRa2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HLpzDWxSGlPwEVLLm83ohBDnu2JeMOID5Yx/xIvdYAE=;
 b=h8egMmus+ySjEaVqwo9D/oTRw1PfwViYnWIJiyiigaDmUnjdZLObAiA6HmVcp5GWCJEe3fkKXqUO/rJhG01QvOFf+L0w1pDT0WJsZirnPfWo5ARAfw4lItx5v8R2JqL2wdwBmWn++NasLpq47VeKSxASnsvbPF2Lbz5VgKsxzXQVSI+z3h7pJ2LJ7FCgvU6B2mJyZS88P41JszJaWgqPMDvpz+pFTYOFdM5GcQUn16X2HwkKTNyaxISD+gj1cVdgn7UbKjoOsAec+WjzYIk/BzTI9k55LybhUYrqqSicH0H3Np3M2LRUIoqGCbikQPgpJisxgQkFt7OEF2L41ImvoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM4PR0401MB2340.eurprd04.prod.outlook.com (2603:10a6:200:53::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.26; Fri, 8 Apr
 2022 17:59:26 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::6859:e5f7:b761:2d]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::6859:e5f7:b761:2d%6]) with mapi id 15.20.5144.025; Fri, 8 Apr 2022
 17:59:26 +0000
Message-ID: <422ac775-62c2-08cd-23bb-2018278b4907@suse.com>
Date:   Fri, 8 Apr 2022 10:59:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 10/10] scsi: iscsi: Add Mike Christie as co-maintainer
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, skashyap@marvell.com,
        cleech@redhat.com, njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
References: <20220408001314.5014-1-michael.christie@oracle.com>
 <20220408001314.5014-11-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220408001314.5014-11-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0063.eurprd06.prod.outlook.com
 (2603:10a6:20b:464::25) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 42261249-b661-485c-17d5-08da19898575
X-MS-TrafficTypeDiagnostic: AM4PR0401MB2340:EE_
X-Microsoft-Antispam-PRVS: <AM4PR0401MB23403AE1371C7A6A50094F66DAE99@AM4PR0401MB2340.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MdvqsZO+VQUDosGntRAIHhdhfYi7OGH9C9xinCOKEe63w56R3LtGG6/+HlqWRpaccA2z1YouAPa+2kVAuBrF5o1Ia4VMaFufwF485Dw1zZYLMcOIddZx8AiF5KGmuLIMgIx6Y3pttHUkfE0j2mZ2pKNJMW8YTTHZe7q5WT8Ixsi/qIrclZpxaEZkamNh/8fppGirVzkM9g/4hx/t70Mb/1vqttyKwXrsd+965LbbRJCx3h0OSOeZuBIF3gdg8YSYhUaPaQFc+sRFamUkJPpEBBxq1bIWYf/Fy9JfSjAMHyQmbaeML3FqnvecwSaQcrPQA/LWGsRgeA22uVt9sm6BvzJ6BEW56UptvNVtDSd5jJssZH9Y7o1WZmQGc8MNxV4NnkFKAwdb2YFrnuh7EsOqriX01UwJLzpYy3QSU1OjEmMMf6Ud1xsurYd5tj6UIX6W1QuQC2CnXS7+JD/4CJhBYd5MJhW3b0Y/HQrGTcXZaBpz+Bm+NpduhEbyjBuhcqFDubjZP943yOdjozYNmsacax7m7GPgtWUkAJ7GmYkfyJyx+uMNlJKPoPMAylnafuppZkvabYs/F79ETFaaRk9fPaH4wmpxelo0nVpJZ2kLDK762Jn6XX9+LbZ+sPC9jPLh1Y56Ss0KzUZhwKCKpdCoyImY6eaSiRK+OVPqCtBEF2nSBMoeGl3kq5PGJcccNo6yvcGJdtJhL7QBH8YA9lz5EDHOKn/QLtWP7Ry0XKqk+bA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(26005)(2616005)(6486002)(508600001)(6512007)(53546011)(6666004)(86362001)(31696002)(6506007)(38100700002)(2906002)(66946007)(4744005)(5660300002)(8676002)(31686004)(66476007)(66556008)(8936002)(36756003)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZnZ0dmNpMlZyL3VucEROaWNhL3hiK3M1UTRET3VHb2F1U0Q5WGNUSWJoOEhM?=
 =?utf-8?B?TGk1ZStVSndHcHhSc3JWcGVLT2d0ajJUeWlEWWNkVFhNWm9iZEFRc3puUW1R?=
 =?utf-8?B?YXZuQ1QyN1pCSzQrVjlNTVpFMTJoVFRkZ2tRYlNYUElya20vSFlPcTg4bVpl?=
 =?utf-8?B?SGlMOTBSQ0FtbFI2Q1VwZkcwS21oTlRqWGlsbTJPQVoyVEFlL1ArNWtFUTEr?=
 =?utf-8?B?SEF3VUN3MkJZeEpjN0V5ZlBjVjh3OXp2alh0ZXJFRjhBQ0g4WkU4UkcrR1VR?=
 =?utf-8?B?RC9va0ZvZXE0aUYxQWM2dFBUWVdzVlJIL1cwamtxSWFYOFhpQVlDWGlLd0t0?=
 =?utf-8?B?WEVxUzNCUEZXL3JzWFFHeG92VVZUaHJMQ0M3WVRkYnpZK0pmUGZiek9uSXRP?=
 =?utf-8?B?dXJLbnc5aEVnZThrTEJpODN0dUZvNTFOak5CK3hlZFEyNGNDdlNBaHRSRTlE?=
 =?utf-8?B?T2U5UmpaMVA0b1g0bTJHYjRQRzUxNVRKcXlJdjNlUWtTdWtXQVRWb2JxVDcz?=
 =?utf-8?B?aDRNY1N3V1daUm1pWUtST0FlRWRiOExyR0dMai9NalZacUZYY2F5d1lEaXlY?=
 =?utf-8?B?dThUdWhaK2tSK01zMjFqS2J0cTZqQ1ByMWhpOGl6U21UWkViTGFQaTQ2bXBi?=
 =?utf-8?B?a2huUFJUazAxazhjQ1pNUkZOQnYvcFBtaWlRR0duY1ArOVN6dnlLeEM2aTFv?=
 =?utf-8?B?UlhSMERkdGlXL3hHR3FCNUxEd1ZtbUh3MFhhSnBGZzcxenRCZ1gyT3RWRzcr?=
 =?utf-8?B?NFdjZHVWQWxEY0lFZDBoVkYrdXllUkFOd3hkVEYrL0VSYXlMaERMMmdlSC9L?=
 =?utf-8?B?YzF4S0JhOG05OXpaTTFHQUJocUovWHlXRjV0UG5VaWh3NkN1Ukkzak5BeWJQ?=
 =?utf-8?B?citoK08vM1BPRHVmTnB0QzA5MThCZ2FEbnYzUjIvZEVDeXl1ZXZtNVNTT0U4?=
 =?utf-8?B?eWhGYVQ5Kzg1T2NRRGpQRlE2YnJUbXBMNVduQk9mdHRiVlNzVkgzNXMzQVN6?=
 =?utf-8?B?MXF1VXlKcXVVZWIyUFlWUURaT0hXaGZYa0E3VzQ2R3BWeElIVmE0TFhyekdE?=
 =?utf-8?B?SEYxVWNWL285UXJETkh3R1ZIQnNMUGVGeXVRb1kzak5ZUTQySEM2SFAxSml1?=
 =?utf-8?B?NVJEY3Y4NWhGRU1hSlFWTjNraGFicDc1Z2QyZ04zTllQYlRIL25ZZ1FzdjBG?=
 =?utf-8?B?VWt4WU81ZnRkTUo3VFJObkM0RkZOQVRscUVMZTZ6REJVYUxZMTE5ZDkxRUdQ?=
 =?utf-8?B?bXVTT1hmNnpES1A5NEc4anduUFJjN08weWJoRkRDRkRBdW1zdnMzQXprcFds?=
 =?utf-8?B?OVVkQkdXUWsrbGpvMHU0UUVZN2tiU0lOeWQ4dm8zYVdyR0R2LzkrRGNpbmJs?=
 =?utf-8?B?Y3BuaWtQNm1kNThqWnFLUkNLYlJtcjRCTkRhRTEwWkYxc01HWXRMNGphczFN?=
 =?utf-8?B?MmpyTzQ0cEVnQ2srK012Z1Y5Y1Q0b0FWcnFlWG13dFoxRCtaKzJqM0lwTmVi?=
 =?utf-8?B?TFpkRzQ4anN4V0cwQW1oSVBQR28zUFRhNDVJa0hSdWlMTjBLamtRenB1RUZo?=
 =?utf-8?B?UjVqNW5MTWswM3RjU3NsRWNWc2VTTGlxTlkvN3lPdEYvZjRIbmVKMTRDdFZq?=
 =?utf-8?B?U3VPUXN4aVdQd2lzT083dGlFeXROLys2QUJzVmt2Y2wyTk02VG40bnBhd0Ju?=
 =?utf-8?B?ckVnK1ovbE41UVdFZGxLQkdXS2Q0Zy9LTExlRjI4MDg4R1Q5b0hHYzNPNkdu?=
 =?utf-8?B?MElBTStqSk9idEJOQkVOTDJDRzBwVU8wdHQ5WjY1aXMwN3BWRVQwZ2xKKy9z?=
 =?utf-8?B?WmtCZUJ0bENMc1luYTlyK3FUSmN1RWZibFlVM3g2bExVejFXekpjR084aWE1?=
 =?utf-8?B?SnVXZjFQMGg0ZnBRTG1uZ1dCRE9hcDFxVUZobC96a0ZNL3NuKzE0a0xFYko4?=
 =?utf-8?B?bkJGaVlKL05FQ0ZwbmFaai9YTGhaVENIdkYvZDNqZ3RUZE9ycFN6QTJzVXcw?=
 =?utf-8?B?OUw0bmJ0Ym1ZVFNJTkhPcTdnMCtQcThvTGEwUlRMeXlaS0l2YnVzZFJqMzZ0?=
 =?utf-8?B?eFFJYW9TQ0cwNHFGSG1XcXVDMWpVaCthK0lQVVlkL1dkdmdHVHRKeHRIWTN3?=
 =?utf-8?B?bGhsU1B5U1JpVGJOdHh1SnZVQjFWMnhOaHJ1SUJZVDdlV0RxbGpoTkpEaHlN?=
 =?utf-8?B?UnNiQzlrWmlnTFN1YmxJeGQxd1ZuN00rdThTUmErajBUbWgrOU5mK0ZXNTlH?=
 =?utf-8?B?eE9SdllpSENuR3NHSlpzdkphVDdNL014UklYa1pHMmpUSjZTWlJMbjlRTGU3?=
 =?utf-8?B?SGxQQmxJdmdKR2gzdlhnVkxMR1VnQnNzMlpwYVVuWVozYnFuQ3hLQT09?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42261249-b661-485c-17d5-08da19898575
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 17:59:26.7697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GF1EgkFl4M5Ti5wvarEHD0zQ5KJ9m9kpx93LnLlES3XfTu/Hm5PgDxW2BVLEFRY//S4co9CS6IuSDMf+bFiySQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0401MB2340
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/22 17:13, Mike Christie wrote:
> I've been doing a lot of iscsi patches because Oracle is paying me to work
> on iSCSI again. It was supposed to be temp assignment, but my co-worker
> that was working on iscsi moved to a new group so it looks like I'm back
> on this code again. After talking to Chris and Lee this patch adds me back
> as co-maintainer, so I can help them and people remember to cc me on
> issues.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   MAINTAINERS | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index fd768d43e048..ca9d56121974 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10369,6 +10369,7 @@ F:	include/linux/isapnp.h
>   ISCSI
>   M:	Lee Duncan <lduncan@suse.com>
>   M:	Chris Leech <cleech@redhat.com>
> +M:	Mike Christie <michael.christie@oracle.com>
>   L:	open-iscsi@googlegroups.com
>   L:	linux-scsi@vger.kernel.org
>   S:	Maintained

Acked-by: Lee Duncan <lduncan@suse.com>

