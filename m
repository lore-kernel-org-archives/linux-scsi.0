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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDFEDC4361B
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 17:23:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83442235DD
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 17:23:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbgLQRXK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Dec 2020 12:23:10 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:20282 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728080AbgLQRXK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Dec 2020 12:23:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1608225721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ft82JuU2e42y3LE3IbsMxnlWgQW6Wi7gJW0Q2yvkcLU=;
        b=EKrkC8m/D9glmNItqtFQnMv9RtAQmgTztuYSV6r+lj+8F/ByfY+gweUrEhxISLQcYddkf9
        6UTLA+39kx7ypU8QPVOtzMKOpL9+Hso+9K8pUlmxPmtSvaZaQGbmJiZfLVEURSjuL93Oge
        NeaQ08JoilVKKoe4O0zmYe52ig9v8LI=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2054.outbound.protection.outlook.com [104.47.12.54]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-12-qhOdFowWPB6oRCnzPOZqIA-1; Thu, 17 Dec 2020 18:21:59 +0100
X-MC-Unique: qhOdFowWPB6oRCnzPOZqIA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pvz2xOQj4x0ATYRKLhZyvZpCyUNrL2iCzCDZhD+0TMNxS6Zi5b3m8BJDDDf+AUK1T7fzjUYXitUisppznr7abKe4g+/z8xA6Ud3yXE4NDR6OyHmxDJUjZn8XM8L/dJazxFtG8uZemPtWXG+Jp/Hq4USh4+pEW1Ch3UfWpSmGE5hQSWcGUgePQq+qLeOeBFX0lbLssLRk5sPYkgaxf+66pVmQPin+oyI+e3Y8sqtz3kk7AucOU+MnVbLeYJqyalIUD8UkvJfcxoMkrtr5bznuIIw3e6x+Bx41zMDHzrb1F8IryQNCMmjn279nrl+kYRX4mPUfBqd2eOEdDSw1lOLPqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ft82JuU2e42y3LE3IbsMxnlWgQW6Wi7gJW0Q2yvkcLU=;
 b=GThqGF0v0PsTNa5vV76CQwrQGfkHqcUIrnPz0JmuygCIDNWmIh9hwmJ5MQAFRap1v2MwOEn28Oyz4pFjcA3av4B8nv3STGDkUOsgJ889SEZLSwGQrL4f+R1+mNFFi8tfj8qq7BTvIkZIuhnymc6G6RFI95x1XcLV63uYZ/6r0iT/5s57MCwCzY3W+4xiH2EfZUzq2LQvwuJ3KioiId8pdBW0aJAU7Ym7pl5yqhYJVpv74Z5t7XhJQmCCSjoRoRt8hFi41TaoOz+GVOyVxSKSG2oYhoZ6V2fObah8adbIOEUNp6GUwVyJ2sXJSdBaVvdkR0MTHfKkf3s0uR5lZRHqDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB5335.eurprd04.prod.outlook.com (2603:10a6:209:4d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 17 Dec
 2020 17:21:58 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d0f5:2f85:a7f2:2952]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d0f5:2f85:a7f2:2952%7]) with mapi id 15.20.3654.024; Thu, 17 Dec 2020
 17:21:58 +0000
Subject: Re: [PATCH] qedi: Correct max length of CHAP secret
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com,
        cleech@redhat.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20201217105144.8055-1-njavali@marvell.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <c57c8529-fdd2-d57e-340f-2af01375fe51@suse.com>
Date:   Thu, 17 Dec 2020 09:21:52 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
In-Reply-To: <20201217105144.8055-1-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM0PR04CA0036.eurprd04.prod.outlook.com
 (2603:10a6:208:122::49) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM0PR04CA0036.eurprd04.prod.outlook.com (2603:10a6:208:122::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 17 Dec 2020 17:21:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bade8d8a-af87-4e5b-9214-08d8a2b04241
X-MS-TrafficTypeDiagnostic: AM6PR04MB5335:
X-Microsoft-Antispam-PRVS: <AM6PR04MB53356A7FEF99BBB8DD2BDC83DAC40@AM6PR04MB5335.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:13;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +M+ui+9/72LxxSkOnq3uXYQaFSGduHUnDF7QDdSSgQL7nA3EUAfRoD5gAqqrfbbKVTxL+oiKCLppEJ086mL/ykn4d/TqcDr3Zz+HNm1yg7JjbdAw9prURS0BVBabwSWFKM61koTiSUpgfoMaJrcP4nHdhjpEv1lX1AYX8MCHk5wodRhj0h+8v7m+LsWK43qfS+4wD2Ze5OjjMkM9oHnDsrMaB2mhOxMSoBEepvsvCgBL3Oz6UtSPBZNH5HHwDgwuhSvmjz5M5yjKeOyaglQ21FXcJXAFNgK8UJ6CJexAsqw5xwwl3QhK6go76207FsPR0ozkCKxIaNBIBfba82STX8weFmfsCC8TH5y8zqEmcekLiYpthmV+jvSYPITsMZDVU91f79pGe/b9Xp1ed0K3BiiHsUhkSFx6KhtXQ9lGtX3jB8kit0KjURJQCVqSzF28
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(396003)(346002)(366004)(39860400002)(4326008)(16576012)(8936002)(86362001)(36756003)(2906002)(66946007)(66556008)(8676002)(2616005)(26005)(5660300002)(31696002)(31686004)(66476007)(956004)(52116002)(316002)(478600001)(83380400001)(6486002)(6666004)(16526019)(53546011)(186003)(219293001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SjRraWJ3cXJNb1ZZeTRNV0NmM0J3RnFjWGZackZRaG8wMnV5UVE2YVpKR3Vr?=
 =?utf-8?B?V2NkMkU2VmxLZ2p6R25rL1FGZ0lDM3dwa21ZMUJUdGhDeWNWRDZIcDZTdEEy?=
 =?utf-8?B?QnY5enlGVnFhQ1JJVXo0QTI4V2g3bVlPZ21mdEJxUXpnUzd2eENodWd6YzZ0?=
 =?utf-8?B?N1N1STRHMVZSTlQwNjhwYUprd1VLTGZIaDNYNHdSSmJUUkZuNytKUmxjM2pG?=
 =?utf-8?B?SkRwUDBocW00Y1B6aXJaekNlZDBmREt4SVVxcWxNWFhpR2NDTndiQ3U1WXRr?=
 =?utf-8?B?YWVhU0NVdVpKVGpYdUQySGlkeWxBUGJNUU81M21rZ0E3QkJITGNtUFJiK294?=
 =?utf-8?B?WWJUNmNnN21vdGYxQVhOZ2J5L3RleEp5dzhKckFlWVVxV0dSc2RjN2RqTFhu?=
 =?utf-8?B?Ym5vY2Q0YVcyUWI4TExQVmo5K1ZpYXBsUzBLNmRTZi92aTFUeUdwcGlTZXlu?=
 =?utf-8?B?Zll1VHBERkdBVnNDeE0xd3VOZ1g1ZWErU3dHaWVBUmNaREl1WE12djVCMmVW?=
 =?utf-8?B?a0xOM1lXaVZTRDRZRTBZdUlIVFNCK2lEN29oSmdNc3U0NVF6bE4zTEFZeXB2?=
 =?utf-8?B?Vlg2VzRxRTFnOU9NR3NGNDNzbzFHR09CMHF0K2UxcjQxWUkvUGtSZUtMdGdB?=
 =?utf-8?B?ZGoycVgyd1FOWG1ic2RiZWJGZ2lsL2FRN2hVOUZaU3VndCt3ZTRJaWF4Mk1w?=
 =?utf-8?B?ejgxSndJYVlsY1dlcktuckMyMHZOUzRldjZhc1hJcHhvTVlDSEZ5YTBVa1h6?=
 =?utf-8?B?SmcrWVZoNHFnOFRRSTUvUlFOOXpLcXNhQmJpRUwrY0F2OG9ST2ZGbjROSXRi?=
 =?utf-8?B?QXVmcXRjaXk5RGpDS0tZYVplNzNiT2FvZUJ2MHoyQW05SVd2SzNDMFdFVFdL?=
 =?utf-8?B?d1REN2ovNDBpQkl2bDIyZjlSeXhMWEg3ZVRxTVJGclk1M0FUKzRScHZFSFBJ?=
 =?utf-8?B?UTRzaWI1OGsyMlBMVWhacFBQUG0wYWhQTnoyM1ZFM242Uzd3ZklCeHdGblow?=
 =?utf-8?B?RnNIdFJnS29peFJXSlBaZVZ6T2syUmtmVlhpaXlBc1hkYzZaNnhYVEhMT3dW?=
 =?utf-8?B?enNlRVN2eGJNMjdQSDJHRFZ5eEtIZzdtaUJMRXBNT2VBeGJyUDJEd1g3WVk0?=
 =?utf-8?B?VFdYQU9EemkrVWs1bHNwLzN1eHFjNEl4ZG1WUVd3T2NGNGF5YWhNVXYya3NZ?=
 =?utf-8?B?ZHpEZzY0SjFkV2ZiSS9Hc1NoMkw0Y0dwWVpHdEJqaW5UbkNTTk9qWWJhQ0tT?=
 =?utf-8?B?MENnSWp4ZmtYKzdVWmFycTg1NnN6em5jMlJJRDgvSnRGbEYxTE0vaUxyN25l?=
 =?utf-8?Q?8SIThxQz058u4=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2020 17:21:58.1652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-Network-Message-Id: bade8d8a-af87-4e5b-9214-08d8a2b04241
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bYBVspnihRcBeRv55BU6jxuO2y00UeOzubv6vMH1gqrNoPIbamlk3enUr69i6qxY9km+drSXbrWdiGMNfqWnww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5335
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/17/20 2:51 AM, Nilesh Javali wrote:
> The CHAP secret displayed garbage characters causing iSCSI login
> authentication failure. Correct the CHAP password max length.
> 
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>  drivers/scsi/qedi/qedi_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
> index f5fc7f518f8a..47ad64b06623 100644
> --- a/drivers/scsi/qedi/qedi_main.c
> +++ b/drivers/scsi/qedi/qedi_main.c
> @@ -2245,7 +2245,7 @@ qedi_show_boot_tgt_info(struct qedi_ctx *qedi, int type,
>  			     chap_name);
>  		break;
>  	case ISCSI_BOOT_TGT_CHAP_SECRET:
> -		rc = sprintf(buf, "%.*s\n", NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN,
> +		rc = sprintf(buf, "%.*s\n", NVM_ISCSI_CFG_CHAP_PWD_MAX_LEN,
>  			     chap_secret);
>  		break;
>  	case ISCSI_BOOT_TGT_REV_CHAP_NAME:
> @@ -2253,7 +2253,7 @@ qedi_show_boot_tgt_info(struct qedi_ctx *qedi, int type,
>  			     mchap_name);
>  		break;
>  	case ISCSI_BOOT_TGT_REV_CHAP_SECRET:
> -		rc = sprintf(buf, "%.*s\n", NVM_ISCSI_CFG_CHAP_NAME_MAX_LEN,
> +		rc = sprintf(buf, "%.*s\n", NVM_ISCSI_CFG_CHAP_PWD_MAX_LEN,
>  			     mchap_secret);
>  		break;
>  	case ISCSI_BOOT_TGT_FLAGS:
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

