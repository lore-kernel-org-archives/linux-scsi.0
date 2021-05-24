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
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2368C04FF3
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 18:43:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9E6561413
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 18:43:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbhEXSpJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 14:45:09 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:28785 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232442AbhEXSpI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 May 2021 14:45:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1621881819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e0+iWEVeKLHn8bHogpZB7ZbFEyRIg1JSlWryXy0IGL8=;
        b=MUwwuES2baXIRWToOYR+pRjKj2O1/Ktjy+HB7KKClRu0WTK/aguEqEG5nhVLf6ZglLsFPO
        XbnDt4eQurwmMKxw9W4L51igl1Gh2jE5Z00yLM0xw72vQB6lpsF/r/6ZQtSloti4M4wkXW
        R9gGPImSlfVOVB5MtwakhmUThvwv8KA=
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur02lp2058.outbound.protection.outlook.com [104.47.5.58]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-30-3iOZedn3NxGA1u3RQfYWGA-1; Mon, 24 May 2021 20:43:38 +0200
X-MC-Unique: 3iOZedn3NxGA1u3RQfYWGA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R9Ur3jxQynfa0gyx1wnBABf1b4TZAe8p+TKUyx1MoQxCroPcbsaOqjKa4sUpzLmWqLIF3Bab2LQrg9F59tlll7uNncZPAbh1tP+lJ9PayBYtD7MZgQGcIVQRWHkeo+8jrYmeQEqSHte/vsribq4e6WdPPltylYaT6yjK+rq1Jx2QsXA8nsuogj4ywaFTu5aGAj6/5qsym9KNT1biG6ilDaol+Gs7EIZSxx1frqMgujyMNYgkdxmRpzItfGzanEdGIH1JxA64Wj43o4gH1FQNHEYALJIyTg8jZpNxqpA0hVg1gXEjxIwsEOq285YomHqzlnTjyMbAE8IUAq0hw1JvyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e0+iWEVeKLHn8bHogpZB7ZbFEyRIg1JSlWryXy0IGL8=;
 b=PRUh/NOY1TVFrBQsFZtp1hQkHDRPPvqqYQfBp6iiL5OMK9yDvVIwjCoYzjRiJEROV/lXEBjTJPWCqjcJN0AAHI9CiGRxnfX2j/35PaveO8q8rQpfV81o7/m/plMco9L9mcJgxOFkf3r7rqCm9ZSoZbJuXClzkOqkFs95knvFn/PAAjDzQrhO5UGaAtuJRGu3xnxEt/hP/q/7Ft0sT76TvbJzF6L5SsP6y+AgbaqkZjDjwA+XyNbgUCYXV5tpx2S5dCqVYHdZpQzY3o0+pj8J3R+c08lJt4KYy+pCrxfC+9JBGWlOPAl6l19mapOG644iCRZ+mXrb2MlYE7TPRpaM3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB4023.eurprd04.prod.outlook.com (2603:10a6:209:40::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Mon, 24 May
 2021 18:43:36 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d1a5:8072:c01f:3cf1]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d1a5:8072:c01f:3cf1%3]) with mapi id 15.20.4150.027; Mon, 24 May 2021
 18:43:36 +0000
Subject: Re: [PATCH 16/28] scsi: iscsi: Flush block work before unblock
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
References: <20210523175739.360324-1-michael.christie@oracle.com>
 <20210523175739.360324-17-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <4d9dc4c7-71b0-6d4e-87d2-f58bd2837ead@suse.com>
Date:   Mon, 24 May 2021 11:43:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <20210523175739.360324-17-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: FR0P281CA0058.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::19) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by FR0P281CA0058.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:49::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12 via Frontend Transport; Mon, 24 May 2021 18:43:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32c0d15c-fc65-4983-c763-08d91ee3d6f5
X-MS-TrafficTypeDiagnostic: AM6PR04MB4023:
X-Microsoft-Antispam-PRVS: <AM6PR04MB4023B6BC983B6E69B36DFF6ADA269@AM6PR04MB4023.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m+SOtM2IaXgODpzXfbq7DbX71wu4sD4/Ebxn/1Ucs/GOjhKUUIRYj8wknRdyNkbyenoIqQbdCh6Ks6kpEhAgT2ZeZ+xWmRWe4c+Kejh/b+LMtvJpNPMh84bwYGVRm78j1nv1bxAijstfgbL0ztr3IbzhYX2gPbwlY5hp/Lmnaepstmv88Nh0EjG7PvCxklaVSgTNeAEnqD0oBFJv3jlicmME+gfHVpZjT88pUndoFbPSuiuad2GFuhO0eNXkTFex2fWiOAGTVlLUYwHaQVkjB8m5AnEb6Pn7N2SQzMdgVxIhx02g91kgA35FLOvJkQ+FekJqwZLvDjzzdN04Hwl1hieZ3bXpa4TlnL0fsdsJX/eseCj9bQLfzcMSI2P4WAZWGC4rkUL4+ypar08VbH/cDwjT69IGCXQpnD45VWKagKFACROoUC6OqMLcF5GkrK4zDqEokXDGTLeJ9QZshO+qcoplJ4ukJ/gDSaOmqTvRvbChWOEeF/8+JeXjuI9Ms00hxxCM8+l+Fjqhe7PtUeZOIe3CUYwE6NxVLp5ajMBdPEA5vN6LC7lXBLfxNgWINyzTXDk5KtZFxtbZIfJnM5yxK+OJM+AfmD+BoTrLbe/XIjDjjdN5k7CpriOwRCvbPLICoPNdvj7xfMzy1w1Ojgv/O+0PrgWTEcsjUH//MkTY6begbg56t1R+hMozJuEDwUDK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(376002)(396003)(39860400002)(26005)(8936002)(6486002)(956004)(186003)(16526019)(53546011)(6666004)(66556008)(31696002)(31686004)(478600001)(66476007)(66946007)(2616005)(316002)(2906002)(86362001)(8676002)(38100700002)(16576012)(36756003)(83380400001)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Mk10c3k4T3hTM1FBTG03ZjZNTUpLTzlDTzV3em1GYjBGelVnZStnaWhkYkdD?=
 =?utf-8?B?WmNnSlZOd3VKbXBGeE1NczIvSWRVUWUveWxOUFFBd3JJbWNlWXVCcG84MDdH?=
 =?utf-8?B?eE00NzNqa1J0MWdza0V2eklMeHVzb1hUSjVQWUREemZHYm95QmNHSXQ5eEJM?=
 =?utf-8?B?aTkrKzA5eDhNZHJEMGxidHpnQWFnUWx1VU1MOGxqbUYwM2N2V1lqNDZhWGMx?=
 =?utf-8?B?T0poQ1ROc3c1RUlzTHBadHNHdzU1dDh1KzRXQjIyQ2puK1ZRTks3R2VFVEZk?=
 =?utf-8?B?R0lSdDg0YzV0cU9wQUdPMGtHaFg5T3p6akhNU2Z0MHRBQ0ZZT0IzM0JnRzdw?=
 =?utf-8?B?aUFDYjZGNWhXYjFxeWMvdk56RzVDSFBHWVFSNDlHbG51Zi9TemhmT3Vsdzlk?=
 =?utf-8?B?NG9WQUhSNUM2ZGZrUVh5TERib1ArQUFjQ0NnbFdNRGQyMmZnYk9ZUGpNRHFl?=
 =?utf-8?B?bEY1MmNqUE5RRnhmOUl4YTkrNGlaWVRUY2trViswL3pWc1g1ZkxQV3Rod1gz?=
 =?utf-8?B?UEVkTlJvTjNtbHFXckV2Q1ZaOE1QNDBtTkFIYldrVmxWckNqSXJRRE5yVWdR?=
 =?utf-8?B?MTJ0WTNvKzdVVkxNSWprZWZmWXBCaFA4V1g3WU9EWmI4bmdWOEVhY2ZnMU5M?=
 =?utf-8?B?dGhWbGJrOEFyMXF4aEFkd3JWL043NlFTMzh5UllDa281TW0wYmlHR1NFUWNy?=
 =?utf-8?B?MFpKZTduU21QNVNyT3hoNitNM2htLzk1UWNwMjd5TXc5aHBTL3F0WXFEM25F?=
 =?utf-8?B?Y2dFMVdDVTdzQ243UkJZL2F6TUJxUmdUdEREdGw5dURiQWEzSm9LbDhNTlo0?=
 =?utf-8?B?bS9hVjBSWXVRRm5BenJvWkZPRTBGZzVXTHIwUUJiR1NUSWhRV3VsWFdsMk8y?=
 =?utf-8?B?Rk1hQjFPZTR3VU1vczNPUVMrY0lFWEZDRkVqeURWMWkvY3oraE0zRlRGNjZ5?=
 =?utf-8?B?MUY5VW1pdi9tUXlwdTJwbDF4MzZheFEzNWxqSjAzbzFZZVFRSVZZWWtFTndW?=
 =?utf-8?B?ZUlMazFGWGJyR1FOWDN2NVl1cGg1disycFN0WDkzYkd4MG9tZXhKSWZTeWZD?=
 =?utf-8?B?T0ROaEVQK2lRVklxRnJLWDJJSU41NUMzbXJVYkc3QS95NGFFNlB6aFliL0lF?=
 =?utf-8?B?NFBaaDcyWlB0c0Y4Tko4elVnK3FHVzYrYlFIdmpGZmJBbE43V0ZTTG9idDJI?=
 =?utf-8?B?ZHN4RnE4TkxNSG9pK1BUczRGVStxQk5OVWdrb1UvdFU3QUlWTFRTYVlTRGlV?=
 =?utf-8?B?bFVEclBsWEhDSk5hVmcybjNjbjhhV2FWWmJZZlRMQnZGQTNuNGkrUE9waU15?=
 =?utf-8?B?bmlHeWNxamdQNGowTlVEUHZ6YjEyMXNuWVk3ZjdZMkNyRjZOQVh5M3BOcEM3?=
 =?utf-8?B?WXFac29FRHgyUHprV29XSkh2L0pxa3JBVGJQcmtNYks1bVMwT3VzbWtreTJx?=
 =?utf-8?B?a241R0JEK29IMFJxaWRtQTMzOWtIMms4eFN0enNmdXRNMUxsOG52OVJ5aXRp?=
 =?utf-8?B?ZTJlRC9hd3BDZUZLOGZKTmI3Z1U2dzA4WkZHbVlNMmlGdVpmSjRrZzd1dml0?=
 =?utf-8?B?U0RjYXBkRXV0U2FZdXdWZmFhU29QNUVINkhRQ0dqNjZ1RTFWdjV6LzQ2QWRp?=
 =?utf-8?B?MDBHWXNYb2d2VUljamtNVTlzUjBVVEZjdmNMaHJCUTkyMDgrQnEva1k2ZXcv?=
 =?utf-8?B?K21mM09BYmhweGJQR0UvQjJvc3R5OFNIaVA3ancvTjE0djM0Rnk2cStRb2JG?=
 =?utf-8?Q?lntvTfr/YaQujzo7Tzs7VGoCPaetlSLXMSNaPvz?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32c0d15c-fc65-4983-c763-08d91ee3d6f5
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2021 18:43:36.4025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9tJThfLoQXKRhqtJ/ReByDNV9x/TxFV40FHNhfKcz9Z1Cgg8d2rhycaObg68VYp3/1ybvc9510UJUZ5qLk/32Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/23/21 10:57 AM, Mike Christie wrote:
> We set the max_active iSCSI EH works to 1, so all work is going to execute
> in order by default. However, userspace can now override this in sysfs. If
> max_active > 1, we can end up with the block_work on CPU1 and
> iscsi_unblock_session running the unblock_work on CPU2 and the session
> and target/device state will end up out of sync with each other.
> 
> This adds a flush of the block_work in iscsi_unblock_session.
> 
> Fixes: 1d726aa6ef57 ("scsi: iscsi: Optimize work queue flush use")
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 909134b9c313..b07105ae7c91 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -1969,6 +1969,8 @@ static void __iscsi_unblock_session(struct work_struct *work)
>   */
>  void iscsi_unblock_session(struct iscsi_cls_session *session)
>  {
> +	flush_work(&session->block_work);
> +
>  	queue_work(iscsi_eh_timer_workq, &session->unblock_work);
>  	/*
>  	 * Blocking the session can be done from any context so we only
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

