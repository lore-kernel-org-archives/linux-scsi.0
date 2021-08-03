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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA7D9C4320A
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Aug 2021 15:16:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E4F960184
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Aug 2021 15:16:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236600AbhHCPRI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Aug 2021 11:17:08 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:43354 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234206AbhHCPRI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Aug 2021 11:17:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1628003816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k+7jC1zDvt2dGAOVG/KMjqXvWoW1o5PCHSTR+nGVFwM=;
        b=IwbORBBSZ15VECtyWQhkgv5KFOlIpUGYFtvplKrmuAc74PZsHehfXAyL1drWmexn3UTK36
        cXfZT8xBJllIN44pWQA+ynVM/lSXewM6uUOOVJO2VfDN/Y45Maz2vkcmu29wfFNoZoKl9v
        DK1OHoMFPdsMltzk6qy5zH/jdUHzqV8=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2171.outbound.protection.outlook.com [104.47.17.171])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-18-swHaT8UeNFGtf_EmTqNr4w-1; Tue, 03 Aug 2021 17:16:55 +0200
X-MC-Unique: swHaT8UeNFGtf_EmTqNr4w-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JgJtR1uZMw1anb/tlM6qmckc7TccqYZ6fZuiUrLHDYecoEUaEwEGH1HE3ZcL4y6oh9Wyd/lBvrf4v/EuDDzqQEOsfy6/EEd/ldChPdUnZcovjnr04RFodt7CwRTgOXjNS4a8hiSE5XljYi97CB91kDJpVFKINiIl0ovvuE8r6f4LlqlU5nhzhFErfHmLHaAFFZNCVhdFpbKj+1xY3F9R/eU9aNGJnCHtRpHO2AMlalV+UApJkx0C7qr5B/8VwcJoH3uG7W4I+8nfYK8I8sj9HiFxdp0Q6xbzcmelsyvIVB5q5wtPEtk5Es3rqlmG5KuvPHNXw9JtKqDhwRIMrqjkMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k+7jC1zDvt2dGAOVG/KMjqXvWoW1o5PCHSTR+nGVFwM=;
 b=jVcUSmCdmStrjdI7qNXZGT8QzRhttOGAZYlOmNe8E18LwpUwpZJ/9tM5BtE5PvFUFwALC4o+TTi0ZwtqcxT4S/eSI+HUweRigwJMjsW7YeyPLiHHDMLjGgHmDDyhD3IN6zNBmIl1ZSNxGOUoqjAVfmiSoB4jMc+B0DNKikUxpOzPI+16si2RqWKfuKYVSJY7VfhHzvmP0Au+Ns5HEF2Z9YKRRJPo7U+0Bev6i0ppostSZb2LnmE2MAfspNs6OU1kjZ68pGN5jDeOecd2wERJC4UhVQgnh7wp1gTTQBwk9u6qzLu8c345H1RVcavFYOc8RDLQt4SkK04RsQFfIVG0TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Tue, 3 Aug
 2021 15:16:53 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::9467:b2fe:fb0b:c57f]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::9467:b2fe:fb0b:c57f%7]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 15:16:53 +0000
Subject: Re: [PATCH RESEND] mpt3sas: Bump driver version to 38.100.00.00
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com
References: <20210803065134.19090-1-sreekanth.reddy@broadcom.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <95eef3bb-29d4-0b28-9d96-532c1a3d0002@suse.com>
Date:   Tue, 3 Aug 2021 08:16:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210803065134.19090-1-sreekanth.reddy@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0008.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::13) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by FR0P281CA0008.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:15::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.8 via Frontend Transport; Tue, 3 Aug 2021 15:16:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa8108c6-238c-4504-9e85-08d95691b995
X-MS-TrafficTypeDiagnostic: AM5PR04MB3089:
X-Microsoft-Antispam-PRVS: <AM5PR04MB3089A567638706147A2449C8DAF09@AM5PR04MB3089.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:361;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1sbTndsEwe93Vwf1cPffn27141KZIxEk9JdIGbYQkiUNxrxQYNfQUG1/2BwK39PrEXAP4rt9mowuAG+sh0YBPK6h8Ep1RMjZsRn1hRFtqsz2HmjLKzwh/pCFtRAjOTJhE1W27weubWoiOW9Hp+ylirxV9jIHaaKXneLND9M/TU2rXtTdo/4XoZmZErt9+C/o5Sglat8kVD4bckpAXeFBspalUB85wWxvi2yIjZD3tf/Z5JA66WDyAF8bBDyIQrqU5IaBtZCyMd/DopQCcGw8FrpD45eyn7QwihwGkwrd9may2trT/U5/bXggxscitxtU4m0kgax+vV4Kj8ZX8puLx0zGL4tk686zo5bPIOgHivN61K+WzyAaBv/E0XXevR8oMaw8iqPCBeFiT63bhnCkj4tOPfMC4wLw5Ko3UiefvlXMfZqdpZSiJoSa+2YUS85gkqiG+oHL9Gor1d0AXkubIxwNxmY/kSUpta2plzyqKsmWKTdpez4KGqVAoLzwIN8TlTKy+zlusRURQ7P6g7VHz/W7xwrq/ySy+PW1mxS6MBxFhyTqOo7SQV+guFo8Md0fF9M32XfW5ff/pDpTpo5ztccRmFErY1oVNJgppaLMhG39wg6e/VAAvh7O/U3VsralOuF7CaWXQ3E33Z1BUdUzqAUczS7lGMDS+x70SkTWNMi8jiALAiwTYo5+GulKNlDDEUjhDuZ8YLpW4RAX+jRmq10qictv02K98YeFVBxVYK6Qj9k1WeERDq1e71ZSJX0s
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(346002)(396003)(376002)(39860400002)(53546011)(36756003)(2906002)(6486002)(86362001)(8676002)(478600001)(316002)(38100700002)(5660300002)(956004)(2616005)(66476007)(16576012)(6666004)(31696002)(31686004)(26005)(186003)(8936002)(83380400001)(66556008)(66946007)(32563001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R2U1ZWlpRVVuZmpBSVY0SmF5YW52SUkrSldiZFIxMU5LMUZibXYvS0pLOHlW?=
 =?utf-8?B?M3pId3daN1ZBNTBkbW1Velh4eC9VQk5CWWRYQ0lWSnEwY2k4dU5lUXhzVmJO?=
 =?utf-8?B?MlNMdVBYMnlkMVk3ZXhTM0J0cnhaUTVzZlc1STB5bXdnNmtTRkdzbzhaUWd4?=
 =?utf-8?B?U0F4eGlCUzlJTUVpWHVITEZ6dnpCQXJPQi9vOEVwN3J6bU9LdTVBdlZIdklG?=
 =?utf-8?B?NXZrOGw1dHNpZmlPLzZKWnB4SnFLUmxXZkVWNFFvSEVFYVBicy92SHVJZzV0?=
 =?utf-8?B?alJjK0wweCs0VDlWMTR5NGFrQnhqdzI1TC9GSFlncEJzRGx1TFBYVTZFWjAy?=
 =?utf-8?B?MzJnNTJwL21PMlZSU1R1am9GZEdmeG0ycVBiRTVGeTh3NFBpNkk3NDFFeWx1?=
 =?utf-8?B?MWx0a1JzdWdYb003NlVVMWhqSnRxamVnN29lYjBaVlg2N0RGYU9pSlRtZ0Y5?=
 =?utf-8?B?T210QjRtVWNXb3hnVTA1MVNyYTIzL0lnajlrVi9Ia0VkL3hJRzMwZmliaVFa?=
 =?utf-8?B?Ry9IQ1BtMW11UFlFNzkxbFJEbUp0U3RPU1J3MDVVTGFRWjgxR1dZYkFNTlIv?=
 =?utf-8?B?WE9ZaC9yTWFTME0zUVhzRm5CWG9hS3R5TUxwc2VtdGRuKzlWQ0hkZC8xOW9t?=
 =?utf-8?B?L011OXZQcHVQbStSQ3JyNzdwemx4MWlTU2ZOZVlIZGYyNkVFZ0pSVGhLTTNY?=
 =?utf-8?B?dDdDaFhhbEtvT2ZnUnJOMkFuOUMzTTRaN1ZGbmhmeFNlL1lMbFB1UFREWlFv?=
 =?utf-8?B?LzkvRWU0My9reFlUelZLaWU3b0RzYmhkNk9vZ2NYbGticnZ5Y3l0eXd3RE9M?=
 =?utf-8?B?NG9XQ1NWVmg3amZFTmIvb3RUOEFscllEQUlHai8wOU9TVjVHNHAwZk1lUGlR?=
 =?utf-8?B?VURBOThkUVNQTzdDcnp5WXE5Z2NmbWliWDlDaGlITUxUUXlOYVNVOGN5VGZV?=
 =?utf-8?B?ektPbnY3RTRXVGl4R2ZDRHIyMmFXZ0dpTUw4YWd4aDhVbGI4UGJCVStWRVNt?=
 =?utf-8?B?QmVJU2NLcWVNdWp0c0R1WEgwZzYyU1M1aGlEMUJ4ZGRzZXdDM3dJUENCc0lv?=
 =?utf-8?B?UGRJL1RscEN0MjQ0eWFCelZQQ2lrVmx4Mk1zVUZZeE13WjFvNXNjNzBVVXhw?=
 =?utf-8?B?YzRqd09PRkxkcVVSQk5oMVErWC9WaEp5dmI4OHlkZzJnQVBOcGhyL1J4R1Np?=
 =?utf-8?B?U1U3a0xTdEhlaDF5bW4rVnFDRzJkVGdXZmI2ZXl2c3RPb1VSSGVOdVkwUWln?=
 =?utf-8?B?cnFkeFhJV1hkUjZVWDVoakxhYVVpbW9ubG5iNm1qclRKZ0V1aGVoeTRLYldU?=
 =?utf-8?B?aC9ndzg3ZmM0TkVYeUJqV1IrOUc1NnFUSjZFUVVIOGNSMVpPZnhtQkNyL3o0?=
 =?utf-8?B?K1JFenN6S2JXZk9IcWU0S2Y4RkFSZjJHTGova3prSkVrNitYQ3JYbnZYL0Jr?=
 =?utf-8?B?QUdIeXVOQ1c2bTFUeFhHOTNWcTd5b3pjWnRSS09TVzJCZGxjUFk4bk5sK0g1?=
 =?utf-8?B?WnB6R2lRTEVCaktXd2d0Ry9OY2ZRajlLUTRyY2ZiblJ4bGhVTUltTHcwVHI0?=
 =?utf-8?B?czRGUzZOY0hzcDVNRHVkL21yRTh0R0dScGE5VlVqanhVdk0xWXdndVNXbVBM?=
 =?utf-8?B?ME85d1B2aC8vV0d2VjhUVlh0R2poNWllcVRTejVOMkdJVXdWbkVZVzRvNlJV?=
 =?utf-8?B?c3JObWo5VXU4UXQ1bWpIclVoZkZYelF2b056eG1tWnhCV3NVSzBYY3lDYjR2?=
 =?utf-8?Q?2mYiIJQFZtEPWx3QHdbTG/2dqtD96E1OdkuJm+o?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa8108c6-238c-4504-9e85-08d95691b995
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 15:16:53.4572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 31tFnIU2jkyv06DvWEfUNoHXX6ztJgREzMSGcodvm2/8uTcK1nZmlAI92ILmUAVjmLN/OG4JKVNPP084r90Mjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR04MB3089
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/2/21 11:51 PM, Sreekanth Reddy wrote:
> Bump driver version to 38.100.00.00
> 
> Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
> index 0c6c3df0038d..ec0be3e80561 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
> @@ -77,9 +77,9 @@
>  #define MPT3SAS_DRIVER_NAME		"mpt3sas"
>  #define MPT3SAS_AUTHOR "Avago Technologies <MPT-FusionLinux.pdl@avagotech.com>"
>  #define MPT3SAS_DESCRIPTION	"LSI MPT Fusion SAS 3.0 Device Driver"
> -#define MPT3SAS_DRIVER_VERSION		"37.101.00.00"
> -#define MPT3SAS_MAJOR_VERSION		37
> -#define MPT3SAS_MINOR_VERSION		101
> +#define MPT3SAS_DRIVER_VERSION		"38.100.00.00"
> +#define MPT3SAS_MAJOR_VERSION		38
> +#define MPT3SAS_MINOR_VERSION		100
>  #define MPT3SAS_BUILD_VERSION		0
>  #define MPT3SAS_RELEASE_VERSION	00
>  
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

