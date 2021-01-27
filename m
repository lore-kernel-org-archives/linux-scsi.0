Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7973C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 18:10:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 699EF64DA9
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 18:10:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344208AbhA0SKe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 13:10:34 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:56527 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344186AbhA0SKc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Jan 2021 13:10:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1611770964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KOaH0cqSzAqsN2/izf2rnkwRlgDLyn1h+lZbKC7J2Ek=;
        b=FsTcwaX06/Bwz988D6N7QxihZSsx5E9bkZtsNcw0hBrikta4Eu/AfpRAfMIUJ1JYMJ8K4o
        lcUbpuE8i59EprIBOL3We/CIc84koK0nCgsCMQbcnxLDKs1kIccOx97gFloNyS5oGcGY0W
        qbYLfqFR4Hwny8LYOvZqtWtG1hZYQrE=
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01lp2055.outbound.protection.outlook.com [104.47.0.55]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-10-14xXP0SxNVaagnpneq-4DQ-1; Wed, 27 Jan 2021 19:09:23 +0100
X-MC-Unique: 14xXP0SxNVaagnpneq-4DQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KlBCybKUNXfjt+Zmw3zFPExweIBbqlHLvAwTiyqCTawMqOIdsKE6P02a7q2OwsGSpAkrSi1AIORTtBVyw5u7D70LbuULq1clAKydTFlrZKKdB6PUWJ81ZcQ+56hHDKAtntdT1t3MW5Za22KTwFlZtynWr8H2TZtkN6eRcdBauCXMgFLiDjkmuw8jeXTPYfgNcZr2FtQB6p2QELbXiWr3FZ0q5IVvUbGGXr1WuJC4ssRzd75eafV9k6q5M7SPKIj1EJfrc1ulq9gQoGL29yB6cet8X33VM6uL1xP0VF07xa/O1eg608pB8psZnCA60TORBAejCRHAO/Hk326/4n/OpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KOaH0cqSzAqsN2/izf2rnkwRlgDLyn1h+lZbKC7J2Ek=;
 b=C/tGVXwZUXFN+D61+viopTTklWyEEyh3/w7UQPcFikRNIy7cSiJBI6G048OTqm/dvRtqaxu8PmSFhuxva9Mqb6bctquLWF3c48JUyrgeUNZl5Y2l6ZsJwGHA2ZkkKF9rHV6DFo7sOwaBTvtEu8cfAVcn0zzS5KD76ioJS9f0rhVDPqQaFCMAzZ9Txj3LQnjFELaym94Ea6FNAJxxLke/SvpyEowvYKHHtS/u7VZry9XK6F5RzxLKzaSyr3K77HjjI7x4mBMKt4Fo3y4fsl/oAsSjOE3Cm77vTivOiuW/WXG+byhGBlpVkAbSciRq3tuw5rG5qcr8O4AeDLSRvbF5bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB4070.eurprd04.prod.outlook.com (2603:10a6:209:44::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Wed, 27 Jan
 2021 18:09:21 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::c60:6150:342e:e042]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::c60:6150:342e:e042%6]) with mapi id 15.20.3805.016; Wed, 27 Jan 2021
 18:09:21 +0000
Subject: Re: [PATCH 4/7] libiscsi: fix iscsi host workq destruction
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com
References: <20210118203430.4921-1-michael.christie@oracle.com>
 <20210118203430.4921-5-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <b100eabd-4937-aeb2-7f3f-91656d113604@suse.com>
Date:   Wed, 27 Jan 2021 10:09:16 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <20210118203430.4921-5-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM3PR07CA0105.eurprd07.prod.outlook.com
 (2603:10a6:207:7::15) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM3PR07CA0105.eurprd07.prod.outlook.com (2603:10a6:207:7::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.5 via Frontend Transport; Wed, 27 Jan 2021 18:09:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6cc0387-dd45-4aa1-9f48-08d8c2eeabd8
X-MS-TrafficTypeDiagnostic: AM6PR04MB4070:
X-Microsoft-Antispam-PRVS: <AM6PR04MB4070A3F0853D3BD1EF22741DDABB0@AM6PR04MB4070.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BZPgRx4gqLAMr7p2kIHn4SjrQOyCMD9G+a1TUxQBo/SsFFbImI86I2dTGPsgcHndG4y6cDtZpHHku1Hidv+RS8mVs+0Q7whRlAx3rqVIMz7cyUZHkKwubUPxOHPqO4SitZi9w7nV9pyAYrelnhRN/8q5cjODXI3o2kGrLHhYqsPT0dZ2iN06cYCIUtGrVXMzu9fMp7qPPHPH/XD3HkOh0dtlrZG3Fk5XdyMSBMxEXTL6kzDMHmF6gihAKQf22Hgaug7qkAgajE4v0ZOQxky6AWgLhCrwrIEjmzipQTtzpeMrg/1ATGOA6PMGH0/3O/VnFFv2YuOBtAohVbk53rIWI+6W7+O8zMYUjTH9falyxczCYQGEmkskmfcrYPRbBNE4h4mk4IvMVr10AwZyxUpaHKB3fRqpgiRm5Nqz0Xpokms4E/oOdf3bjOak4xHWvEnv4DkzkkK3+o588KAHsvtwg+ZYMrf0gXVHTnOKUuBjcPNaeuwLk+RMenfTH2uWNUfPWXy0150tVuloGCBwXZrzoPlrwiJ7hxpyt0M74ybggs3ogs8pMyPYMGgfWgMECY/ZLYhVZXRYZOE2guhg7zhRRTDXKYy8/UATnObIvv6oBOs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(136003)(376002)(346002)(396003)(366004)(66476007)(66556008)(4326008)(5660300002)(66946007)(8676002)(36756003)(31686004)(52116002)(16576012)(53546011)(956004)(2906002)(8936002)(2616005)(16526019)(6666004)(186003)(478600001)(83380400001)(86362001)(26005)(316002)(31696002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YXNTT2xRSUphNEdRdEllNlRRUUN6NDdLb0w4Zkx4Q1BLSVVSRHpIaWdaTE8w?=
 =?utf-8?B?SnBkSG5pYWFFNWtqandkeWpQc2hhRGlDTkxSZUxxZ3RKVG45ZVJRbjZqbkZk?=
 =?utf-8?B?ZENUMUdsbU53VGtqUCtOQXFEZDI4UDU0OE5mV3NxblYycU5ORHc3TWQyWEF6?=
 =?utf-8?B?eTM0NVlxQkZIWUI1azhWM01DcEh4em9DOS9mMWZ0WmNuSlVUdEg3OVl2Nk5x?=
 =?utf-8?B?TzlqRWRrOXFxdDgvaE0va0ZmVkVTWjY1V0tybDhhc2k0TWpJeWtNU0pKbW1T?=
 =?utf-8?B?bTV1VkFnOUwrRzhYL2duMlJKdzV0cDNNeFZyd3c4OTQxUU5ja1UrdDlBRHJT?=
 =?utf-8?B?ckR4LzNzbS9YNmpISHNQYThlUTQrT1FIYzRITExSYlJ4Y3l5NHNPNG8yU0cz?=
 =?utf-8?B?VlFIZTR2OFJRVXZNQ0xqR0xKaHV6WElaUnhGQ1RaTkZsQ1UxUUowb0N1dVhq?=
 =?utf-8?B?Z05qLzhGS1czV2RpVnFyLytXa0xyTlgwNVNEQmlOVEVvYStYZnhNTzlPQTNz?=
 =?utf-8?B?dmVmbWZ6ZDFLZXpXWSszQU8rOEI3MDgxbWlmQldVMjJlcVo1dmd5b1J6WUlh?=
 =?utf-8?B?c3ZmM1k0c2w5eG9TbURKTVJRekRDQy9Pc0kwdXNFLzVFSG5JeGp1MjNvZUNB?=
 =?utf-8?B?UU5zMEszNTBZN2VJYW9LdzdDb1VTSVJtRmdXa05YdzBKUkVwaElWNGpITVph?=
 =?utf-8?B?empmeUlzdEhUV2NnVy9XVWdkR05WdXA5OWs5YWxRek1pL3NoeHVRdU14ZWhT?=
 =?utf-8?B?VzB3d2N6WW1vQittb2VGb3d2YUw4b2hDRGovL3RMaEZ2Mk1heHNvM0tERlR2?=
 =?utf-8?B?N3d2elZKWTBtbCs5cFBWWGJLa0FLVVY2Mi9YU2dhTVdWcEJJT2Y3NVl0cWg0?=
 =?utf-8?B?ZStjNmRoaG9PcmtGVXlPUThFeDAvWnZMWnJVUFcyNVdYbEtOY1RXbHJ6NFdv?=
 =?utf-8?B?MUgvUG0wNk9VaVZzQ0VaSzZsVjl4ME43SGRHalZOU0NsdThyRlFlcHNsRjls?=
 =?utf-8?B?Z1ZZSTNad3B0b2ZrZzNXakdETHBkWDdsMHhMRStZQ3ZZVmpsb1VSN3MxbDlE?=
 =?utf-8?B?eHo4UytWVU96REJja2toV0hjZmNlb1l5T2NrYmZTMlRkSkJKTU9EK2FKTWJN?=
 =?utf-8?B?c0FqU3o3Mi8rVWlzdmEyLzJqQVkwR1d4NHFRaHd3YUdGWU40clpXOGl1TW8x?=
 =?utf-8?B?V0F5SGVrTVRoeGJmbmRnSWhheXN3R0FLTmVKQ2t2N3pvQUMwU3RuRm5wdHdI?=
 =?utf-8?B?dXJSNkRYRURpTnI5OWUvWnZkMmlsNVMyaGJEVHNnUVlYTUJQWUZubEo1b1cz?=
 =?utf-8?B?UmNZQnZnSUtlbVo0R3VkdFlmZjhJSWdCQVVEQjdLNTQvb0tWbmFKVVJEM25n?=
 =?utf-8?B?WTVPaGhLOWpYTTJtMkh4VlhxM0IrT2h0am9TSlh3U1ZqOWZKU0I0QlI3bklS?=
 =?utf-8?Q?8xaQtSh9?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6cc0387-dd45-4aa1-9f48-08d8c2eeabd8
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 18:09:21.5579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kKfQXR261AMFJ+85WhMKzotBKlemrN54lxdqoc2yYmx1iOv0Tu4urTMg50khejnMhwueie/hVdqyGUhNGWNFMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4070
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/18/21 12:34 PM, Mike Christie wrote:
> We allocate the iscsi host workq in iscsi_host_alloc so iscsi_host_free
> should do the destruction. Drivers can then do their error/goto handling
> and call iscsi_host_free to clean up what has been allocated in
> iscsi_host_alloc.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/libiscsi.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index ec159bcb7460..b271d3accd2a 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -2738,8 +2738,6 @@ void iscsi_host_remove(struct Scsi_Host *shost)
>  		flush_signals(current);
>  
>  	scsi_remove_host(shost);
> -	if (ihost->workq)
> -		destroy_workqueue(ihost->workq);
>  }
>  EXPORT_SYMBOL_GPL(iscsi_host_remove);
>  
> @@ -2747,6 +2745,9 @@ void iscsi_host_free(struct Scsi_Host *shost)
>  {
>  	struct iscsi_host *ihost = shost_priv(shost);
>  
> +	if (ihost->workq)
> +		destroy_workqueue(ihost->workq);
> +
>  	kfree(ihost->netdev);
>  	kfree(ihost->hwaddress);
>  	kfree(ihost->initiatorname);
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

