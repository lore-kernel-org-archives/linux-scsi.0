Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F1E7C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 10 May 2021 01:14:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C18B613DB
	for <linux-scsi@archiver.kernel.org>; Mon, 10 May 2021 01:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhEJBPY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 May 2021 21:15:24 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:52565 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229941AbhEJBPY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 May 2021 21:15:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1620609258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DIT02CTBDQlY9paNcP36VYs1tByEhQiQDAinDIR6HXM=;
        b=VrYv07VwgCqtt/NCOM9bBYAIQ9c37cQE6Ny3uvbZeqM8hSJr7hKxXAjz0LhNrsQdQE1PcI
        oY/9r5IIsnZyyTHQwrl5l8LsJSUjM4HJBuXmwPd1wyx38asAwzp8FGfoi+spQJvTHKf9oI
        MfGufzuyv+kJnvwhBQGaol2USlF+nNE=
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05lp2112.outbound.protection.outlook.com [104.47.17.112])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-30-6BaDDIDSMS--48Upqg842A-2; Mon, 10 May 2021 03:14:18 +0200
X-MC-Unique: 6BaDDIDSMS--48Upqg842A-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bxeh2GNsjFeEAmNlEtz9G7ZUanwUSCZ1WEDg3tk5RcHWb697m1/V/Zo8S4bvnkRrmEXF2n0hjdPJLeNrH+DTOUFpJexs/AXY9oBBiYilr7PiiAHAfHcj7Bpbq2idcL+r63rgvf7JK5GqK/7rBznOBbyimAhLZNmTbCeTQ4+wGisTDTh+vNT3vM+JCm876Cb6E3YzuN7HSeV2zvCb2wBj12q1yhD5rN9LQiIv5Xpnv+LJfP4D4iCklRqaxsoOVLNr9Iy6/JZn3TV5BFTKWwyJ1BAIyEzLAbS8LphJb+N0HEL4z+MPc+XnKg4/ethlnGtnIrGiLy6Pz3j9xzP7aJsAeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DIT02CTBDQlY9paNcP36VYs1tByEhQiQDAinDIR6HXM=;
 b=WiI31GJW3sLN9eKGkRPn4ChCJtSTuEoP4WXgIx+TEPM3odfi/ssRBABzlvtHzDkkCK9F4eiqkb1xZ/iRh2lvCg9CbKMZzza4yTGBkuAi2SmE9c1cXDMeHxUFzQQCSCryGPpjMDyuzVP+OtxQ/I9jqUVOX/7K9pxtD2a8vDofOJg7DNxXP9LlTZzN3Bt2h5tkPiPr+3kWHHryefV8SrPEEfGnBW6ItiBw5rMB3HNyyJZFzK2miYfY9huBaFjKUBcQG86z0HdYHrVCQiDrk2ZE4ia2Or3/t+YtnzSPgkgRqrnEUuiGxpMAXaP0eyZ20xtQYOo7m6MM60SOs1FjdxPqKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AS8PR04MB8165.eurprd04.prod.outlook.com (2603:10a6:20b:3fd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.27; Mon, 10 May
 2021 01:14:15 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72%7]) with mapi id 15.20.4108.026; Mon, 10 May 2021
 01:14:15 +0000
Subject: Re: [PATCH 4/7] iscsi: Use scsi_get_pos() instead of scsi_get_lba()
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>, Ming Lei <ming.lei@redhat.com>
References: <20210509214307.4610-1-bvanassche@acm.org>
 <20210509214307.4610-5-bvanassche@acm.org>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <fbf33a76-18b5-008c-a28d-09ae158f0c24@suse.com>
Date:   Sun, 9 May 2021 18:14:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <20210509214307.4610-5-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM4PR0101CA0060.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::28) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM4PR0101CA0060.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Mon, 10 May 2021 01:14:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bce3f539-d04b-4358-23fa-08d91350ed56
X-MS-TrafficTypeDiagnostic: AS8PR04MB8165:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AS8PR04MB8165F6ED0A24DC54FF1C7EB7DA549@AS8PR04MB8165.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JI7+s3BIXRuP/Q1Yt4md6nYt/GkCZz5k0pCuhIFKY7IIhFvRmaMXluyHdNGDQxHOHvS4H2Q9iIANcc7mkqDzmA8bxmWN10Y+4a3dUKqsGt75tzK5zogVKkxZ7hSEZuNgZCEF50d9jFLjED6hZHXm9sgCqXI7IWwBHUfi7BUM2AFS4MgK9ir5iRFOJVC5hsSysRw0EY6TXme+hHG8BtUiRgLDk5KYiOQ8n8zTyK7qLuajEyAOwiF/SbSxeLXamNben2AB6qQ7cVy4FhGWF3wS/dnn6ZyJXp1h1Navrm9GcplEAT87nBGvCZVpHNQx4YOq4FhGPg58Us+oR1n3Zf/286AVEwUn7AK0u0HYrXzkUo3qyfmJgd7Z0NkF48Aq3J50D4u2mA7oLiXnudPT2419oAw/cjgiSqG5uuG9C9wIawp2MTYNoK5tOOIH2JYu9gk4/cPuAT405ErYXLSIqrcjeUwrmmCA+JFheMG/KE3hen6u0mRvRttOrPffM4YgfKm27an8vlx8Ms9JXp48l6FPwxb1vy4LZbrl6hVqk2S9orcbRsVhD3FnrPXoEVyL6WUA9jJ6XjEIfI83vkG7/DGw+2FAztAoFuvJAAC1HCAa4jeqI06++NnzZzZO/o5b6blRNMH/L6OCnjk/kRfqWBhZc1HUS6CN/Su+GbzTqdovJ9KSxw0G/ejrsImzZUk2glKj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(366004)(39850400004)(136003)(38350700002)(2616005)(956004)(52116002)(8936002)(66946007)(478600001)(8676002)(38100700002)(66556008)(186003)(31696002)(66476007)(16526019)(110136005)(54906003)(4326008)(6666004)(53546011)(316002)(26005)(36756003)(83380400001)(5660300002)(86362001)(31686004)(2906002)(6486002)(16576012)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RjlsN2tyRzhSUU1PcTUweThCcWN2a0FGR2pHdm5iTHNDcW9BczN6SS9ZSzQv?=
 =?utf-8?B?QThxam9EMDRmOVFEL0Z5RTVWWlI4eDBSZ0JZb3llVDhkUm1JZEFEaEoxdnpC?=
 =?utf-8?B?WmRCbVlydTFFZmpMNS84OHBNMlovN0Y5R0FleTg4Qzlrd2VFYldzT0Fta3F5?=
 =?utf-8?B?WVQ5YXZ0RFd5eEVlR21JcFIzanNWdVg2TldtdUNFLzlpenhvQ0U2UkJWMmJ6?=
 =?utf-8?B?dkk2eUJiUGJZMmVNR05McTFWOGsyc0YrbTgrVlVyZWFSU0NUUmdVemxjbTA2?=
 =?utf-8?B?eTA4dmY3YzNBUko5bk5Rell2cXVQYzN3Snd5TzhZOElPRC9tZEVENHNVYndH?=
 =?utf-8?B?dCtLY2VZQWJSakdaeVJreTlxcUxVY0RtR0cxZ3hkMkRVaDA1UFhqdTdpc2FX?=
 =?utf-8?B?MEdaNis0cy80Vm44YndlcTRWaURySVFSSmRmdzNXclZmMlhxYmY3WCtGVVB0?=
 =?utf-8?B?QU03NWZNL2pZbjJoNkxESDhLelVqemZDdlZDSjFTcWtvZmVFbTEzdlIyeXA2?=
 =?utf-8?B?enZVejUwZFRYVXNBVE9aYTh1aEF1THlra29nY0owRGhTRHZYOGlKeXkyRjJE?=
 =?utf-8?B?RXJuWVdqbVJJeDJyeU5lSGRRUEJaejNUOEplbC9XUG5HWmJVSXIzbkoveVE4?=
 =?utf-8?B?RGdTRjliMWpqa1VRNzN5TXFtUWJZUTJEQVFUSDIzUnRwUHc4ZUMyS3BtcmNL?=
 =?utf-8?B?VGhvOTRFMnVucEhWQnFNQndLQUMwNUt1R3FTVHpVN1c4eTJQbTZEbnNSdHdX?=
 =?utf-8?B?TUZjN1BiNzRkQ0k3b0xyMWFZSks4TUdhUU5kR1dIdThDNG5RNENxbmppTURx?=
 =?utf-8?B?ajNLNzF4b3FNL2NISGRrR2xwTkRjMFFNc3k2a1IwTGhyQUJ5WFNLY1FVVW9E?=
 =?utf-8?B?T201V0s4c0syQmlnK3NGUDEzbkxWb3l5VjVQL3BWVEtOVlZJcnYwZ2hwbnMz?=
 =?utf-8?B?aGhuVktlTjNBKzgxTytEZFoyaVZaSVJtQTYvNm9xWGdXa2kxczYzNVJyZ1Ix?=
 =?utf-8?B?eXp3MzJLMUJvVjNIQlRYaUdHUVh4amEzK1ZNSzFBZEphbEN4QjlLbkltdmp1?=
 =?utf-8?B?ZkdIN0I3QXFjT2tPOC9BZlNQdTlOY1owbzJnVmNPdGVVVTBFMGVTV1c5a0p5?=
 =?utf-8?B?Sk5HLzZPYUpsNW5HRkpVY04yZTJEQ2t2c05yOENmc0VKdnBXaW1ZdVUybUpC?=
 =?utf-8?B?VkdMN3k1Z1gvZDg1MEU1Q1VoUzl0dHdrdUJ2QjUzczIveisyVk5HdUM2em1r?=
 =?utf-8?B?TDFSa0pxUHR1cE9HUUFlN0dKNUFwV0xCVDJJbldGSysyQVJVdDBtbTB1N0E5?=
 =?utf-8?B?VnJqazFOTXlLb3phM3UrRllWbDg1YUticWtXN1g1VTY3aWx2ZDF1WitjQ0ZF?=
 =?utf-8?B?N3gzQm5sU1ZuRTlvV3pBVVN5K3pkeFNGdkNLbGlqUkphU2Ywb1QzWlE0K1Fv?=
 =?utf-8?B?SmcybTViL0pzYW1yaUxaZGtSVUU0Wll1aDJiU0d4Z3ZuM0xRa0RPeXUzcXln?=
 =?utf-8?B?ekpGb2FiWTdOdnVpUi83RVFUbzlMMWxHUnJsVmJRSjhaWitSK2xhdFBibVlI?=
 =?utf-8?B?WmNJLzlSSlpoSjYwYnVwWDJhOHVWenUzM0lCeThKWHN0RHVvTDM1ZnlYeWE2?=
 =?utf-8?B?SlpLZUlzc29SaGFRbS9jaUM2MjJ4Wm45aFpFZC9nNDBVb3FxRk9FVlJxaER0?=
 =?utf-8?B?dFUvbnR0MWF5UnQwYkp1UjY3VjhQUkZ2SS92ZHJkNnR4a1daMTF1VW56ZWFS?=
 =?utf-8?Q?2KSZzG5e98rGNmwPSPnO+TwWqZFWXWLSAzBr1jt?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bce3f539-d04b-4358-23fa-08d91350ed56
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2021 01:14:15.3070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E/8fqhXv7UvptC/dQJsdknEb/VUa3IZCrYdLW0jTpv+vjwoAD4+xYihcq/Z2f3cIUbLPfAf4vzPV3mouPDLJLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/9/21 2:43 PM, Bart Van Assche wrote:
> Use scsi_get_pos() instead of scsi_get_lba() since the name of the latter
> is confusing. Additionally, use lower_32_bits() instead of open-coding it.
> This patch does not change any functionality.
> 
> Cc: Lee Duncan <lduncan@suse.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/isci/request.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
> index e7c6cb4c1556..1c25f28385fd 100644
> --- a/drivers/scsi/isci/request.c
> +++ b/drivers/scsi/isci/request.c
> @@ -341,7 +341,7 @@ static void scu_ssp_ireq_dif_insert(struct isci_request *ireq, u8 type, u8 op)
>  	tc->reserved_E8_0 = 0;
>  
>  	if ((type & SCSI_PROT_DIF_TYPE1) || (type & SCSI_PROT_DIF_TYPE2))
> -		tc->ref_tag_seed_gen = scsi_get_lba(scmd) & 0xffffffff;
> +		tc->ref_tag_seed_gen = lower_32_bits(scsi_get_pos(scmd));
>  	else if (type & SCSI_PROT_DIF_TYPE3)
>  		tc->ref_tag_seed_gen = 0;
>  }
> @@ -369,7 +369,7 @@ static void scu_ssp_ireq_dif_strip(struct isci_request *ireq, u8 type, u8 op)
>  	tc->app_tag_gen = 0;
>  
>  	if ((type & SCSI_PROT_DIF_TYPE1) || (type & SCSI_PROT_DIF_TYPE2))
> -		tc->ref_tag_seed_verify = scsi_get_lba(scmd) & 0xffffffff;
> +		tc->ref_tag_seed_verify = lower_32_bits(scsi_get_pos(scmd));
>  	else if (type & SCSI_PROT_DIF_TYPE3)
>  		tc->ref_tag_seed_verify = 0;
>  
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

