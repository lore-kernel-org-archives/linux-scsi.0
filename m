Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF338C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 19:50:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F8DB64DA1
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 19:50:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbhA0TuZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 14:50:25 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:48318 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231597AbhA0TrC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Jan 2021 14:47:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1611776751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cJQ0FWDTDo+F95xl8rmdJSpv52SsIaXF7JXXW5seeFk=;
        b=iSi//i6MTqgcTnpHddVDsKVCSOroiOXQJ1hJCwuf6qUwGOtez15iC3OB1z2GDLTYx2ZDRa
        HOnvCoo7IRA9C+Q1RTyhVJXfrvPwumTsjE9PeiFdnv3162f2P/6TKRR/M4qn4Sed8XLlwE
        /4nMndRWnyYp6PSmIOSjaJAX+7fpX+U=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2172.outbound.protection.outlook.com [104.47.17.172])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-17-PnA-6ziaOB6P4eN-KnoXtg-1; Wed, 27 Jan 2021 20:45:50 +0100
X-MC-Unique: PnA-6ziaOB6P4eN-KnoXtg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jhKQPpyvY7HqSXg8iPUW2jUxVGni7XMllfelNx0rdyIdR2L4tpAjc7Pd34GXGtVEQgGLOlVAh/pl62euOeo5aXxk88DS1VRB6ekANKwxZtxWfLizcb5+pKXA1dW4+aIUWHKXWbc0bRcPaMNFj/pNJaBSE/NNsBOL1nwk31AfHLefC3ACxzpXCgb6DjWE9Vg3kc6uNUj7j9PjnB3mwqA+GMeE9bKU7EGhGPo8s8Qla3uChNYCTfxnRjYgLd5HvMk9hoYazE/9RPznK4M/UNwEJKP57JYfbmmBj01Gboj37LfYMxT+N4TowNvVfDVUugo2dCkU8AvlNQK4bG+zvccJIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cJQ0FWDTDo+F95xl8rmdJSpv52SsIaXF7JXXW5seeFk=;
 b=WlXzrUJhxMdBU2w2lvsmeD7G8fHsS0H6Wz9trRhj8IWUC1ipU7PMlw4fYPf2+zxIDO4QweA2eXHI7nK8TB8ANAMfJk3TUYESYDrPDXXXipjN1UPY+ZQdW48BLHeOswGCfOgjPb/EmPMpN8npL71kOQv9xz+6GwgmqkpX/1Jg8E2oLN9cF8GPVGOYy9PcqbqPfr9Wa+LzfQGfVIRB3N3Y20SaS9qUDW5/jKpb5sjans0rBDpZ/mwhGKnQlNYBmVuVc8tBtS1eZDL7LP9RrOrXy9mhfnjCDrFldy+xum5gL9LFPQBU2doWwN20AVSZagArFySYo0oXk3TG9SoryXb0XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB5224.eurprd04.prod.outlook.com (2603:10a6:20b:f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Wed, 27 Jan
 2021 19:45:48 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::c60:6150:342e:e042]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::c60:6150:342e:e042%6]) with mapi id 15.20.3805.016; Wed, 27 Jan 2021
 19:45:48 +0000
Subject: Re: [PATCH 5/7] libiscsi: add helper to calc max scsi cmds per
 session
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com
References: <20210118203430.4921-1-michael.christie@oracle.com>
 <20210118203430.4921-6-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <8cccc83a-4f43-f3db-5f06-5a75f76e293e@suse.com>
Date:   Wed, 27 Jan 2021 11:45:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <20210118203430.4921-6-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM0PR10CA0119.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::36) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM0PR10CA0119.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:e6::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Wed, 27 Jan 2021 19:45:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0740383f-95cc-4c1f-639d-08d8c2fc2515
X-MS-TrafficTypeDiagnostic: AM6PR04MB5224:
X-Microsoft-Antispam-PRVS: <AM6PR04MB52245151639F1E00A4C478AFDABB0@AM6PR04MB5224.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rpapC3SWsl6bBFWNefR3gjS2qitB+KYBl8OYqUjdG5kS3ZFX3DpNnvPRPUWcltzc/oPu3ajwLgWmJOWJW1yGZevASW0LjkRO5Js6CEECS+f640G4cMl32ZLZXvdIh/YFKeAaiBMmlqJERPS69Pb5h0AWOuaMQMzigyKPnQ0MtagZD9hnfRjtHG3/jV2h4CRzLEOi7GPQCxFOgFG9+5cwm9CyO2e4R3UMZ5n+c36U91uIPOWztZOBfC9s8jWhVu84SqbuvDxG1rKngaVW+hQleQPnZ/vqlsbo2UCnTmcQjXQH3Ol9vnIVEd6OPWZwu5j3b6neKU8eqod0FIvttNxWVwqixNL3n/0XzpCP1/MrPmMAEXes3pgJvgM8d6D2dNO+WwqBLYGVENpAcJne0clhBIoU6/TCX9w6mlI5guUabLiQttTECS6I5QrmkjnNoF6vyeSvTVj5iy4CuVCxg4I3hCjj7WVALyl/dTbEb1SLBNA8OkIQtcvjKtdnXZL0/zQJu5TuYbKMWOVoUuZ2+A9FDNiHOkBl2ToMKISMetZ29OPKlEfxuuZwxA8gzRpxhnzJ+iIOU06FoK34QSCEc13ALlLQIuRAT80FWHW22Y3CFaA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(136003)(39850400004)(376002)(8676002)(66556008)(66476007)(478600001)(53546011)(16526019)(36756003)(6486002)(83380400001)(186003)(4326008)(6666004)(66946007)(86362001)(8936002)(26005)(2616005)(31686004)(956004)(16576012)(316002)(31696002)(52116002)(2906002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?L3dKdGZVNGNkaW8rUUtzVUFVaGFFRThqMkg0K3FneFN3REJiM1lIRlZNZEJB?=
 =?utf-8?B?MW1jbTFzMWVjeTRPZHl3ejRocnlzS1BLS3RRa0ZieFl3Ky9IVnpYdTdUMEpp?=
 =?utf-8?B?T29CQ1VrWm5VSzNUUnRJMkpGZnY4NmpaMlduN3pIMGZ5TnBlUXhGdmxaNDVi?=
 =?utf-8?B?YjRGc1VDc1BxU2hwaE42UkJSV3B3eUtKTVNvK3BPcjVxd1l0YWI4cXUxNGtI?=
 =?utf-8?B?TlVQVmJ5SGVKRGw5TUgrTXliQnQ4andNeFNoSTRUTzVtRUtNU1gxRjZyVVU3?=
 =?utf-8?B?alRFcEg1Z01PaFVETUxaOFZDNFlGb0EwcGx2Z2VmVFR1L2pIZnc5YkN0eVBh?=
 =?utf-8?B?U1Zkd094T2gvenRUR2c2OVFmNzNuZjY0YlBFMmxuZm1kSDErbmR6TXhtOERh?=
 =?utf-8?B?U3VKZThuWkViS3pPbVkxeTNpZXpqd29YMHV2U2lnV3A3VEYwaSs5OXBrclVi?=
 =?utf-8?B?WW9PcHpMY2VPNkJDVjFQMzZlN1dHMmtDcDIyQUtxUExYbERjZ3g1L2pJV0FI?=
 =?utf-8?B?d25jU2VEYnppK1ZRZ2dwTmloQWFpZHIrcTgvMlFjQmVkK1pIaEoyYmFxbjU0?=
 =?utf-8?B?VThLMW9hMkgvbm5ONWpzb1I4aXNYN2JwTUZJMjBVRUZOTUJzU2R2d2RaaHgy?=
 =?utf-8?B?Zi9lWVhSSk9lZ2xla2JscVFIL2lpU0FuNmdTZXlQUmtweEZKbGtoRllwbGls?=
 =?utf-8?B?NmY1U2N1cVZ0K0ZTbTMxVms3VjRNcm9renRlL1YyTzZXWU9hQjdWMGorNWFv?=
 =?utf-8?B?aFZiUDlXaDhrbkJ4Q1kzR0RHYy81NzYycG9JRWw1U0VKWCtLeXNYdjY0b045?=
 =?utf-8?B?UStFbzNjSTF4WmtoQVh6UTRBc1phb09NSmxOVi9SZWprQTVSckhqY2NONjJQ?=
 =?utf-8?B?ek5oOU9JRlVRaUdlVFZxdGVCRXpQNWN1NkhyTkVYa2xMR05RQ3Q0eTh1cGwx?=
 =?utf-8?B?NEZKYUNJUEM3N3RiUFd3YzhnR3hLdmY3WTRaUHd0VUVteEhSQU1SZG5oSk5C?=
 =?utf-8?B?YnJaczc3V2p1SVFyMmxJTkg0U3FsWUQ5Uk5GUDVpU0diUHhqL3hCYmt5c1BF?=
 =?utf-8?B?SVVBRTJ1NEx5UWVMVkwxSkZaM21mYUhvaTVFZE5tWDh2R3VYNEVxdllJcCtn?=
 =?utf-8?B?SjE0Q1dZWVpIWjdIVUY5cWZteGNDUUY5QXZQbXBxdkpqNXN5TWx1bWE5THdF?=
 =?utf-8?B?LzR3WnYwMVd1RnJNODdOaE9kd2YwemE2aEU0dVdNc2FOeU16M2d3U01hNGVJ?=
 =?utf-8?B?RkxsSUg4V2I5NVdWK3JJSUJsTEIza3Z1eFNGT1MybnhTZjRHVUQ4Q1FVbExL?=
 =?utf-8?B?c1NONDlDbVR6c0l1UERDTmtzS3E2RzJYL1MzalpjQWR6VlZhQVd4QXF3cTJj?=
 =?utf-8?B?RlNsYW5GZEE4U1lTTisvaTdVQUlGS0w3ZGxOTDRMbEhKVy9OeTdEN0RzQ3I2?=
 =?utf-8?Q?yOgNzo/n?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0740383f-95cc-4c1f-639d-08d8c2fc2515
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 19:45:48.3860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XSkOcDpIrF1LW14ZBEuihZZ8zBlGHuwxunja0x9Tu3IRO40ctCEZcQKhAMSegf81WA+Gy1x6r20UCUIVJ0RZyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5224
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/18/21 12:34 PM, Mike Christie wrote:
> This patch just breaks out the code that calculates the number
> of scsi cmds that will be used for a scsi session. It also adds
> a check that we don't go over the host's can_queue value.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/libiscsi.c | 84 +++++++++++++++++++++++++----------------
>  include/scsi/libiscsi.h |  2 +
>  2 files changed, 54 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index b271d3accd2a..195006a08e0d 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -2648,6 +2648,54 @@ void iscsi_pool_free(struct iscsi_pool *q)
>  }
>  EXPORT_SYMBOL_GPL(iscsi_pool_free);
>  
> +int iscsi_host_get_max_scsi_cmds(struct Scsi_Host *shost,
> +				 uint16_t requested_cmds_max)
> +{
> +	int scsi_cmds, total_cmds = requested_cmds_max;
> +
> +check:
> +	if (!total_cmds)
> +		total_cmds = ISCSI_DEF_XMIT_CMDS_MAX;
> +	/*
> +	 * The iscsi layer needs some tasks for nop handling and tmfs,
> +	 * so the cmds_max must at least be greater than ISCSI_MGMT_CMDS_MAX
> +	 * + 1 command for scsi IO.
> +	 */
> +	if (total_cmds < ISCSI_TOTAL_CMDS_MIN) {
> +		printk(KERN_ERR "iscsi: invalid max cmds of %d. Must be a power of two that is at least %d.\n",
> +		       total_cmds, ISCSI_TOTAL_CMDS_MIN);
> +		return -EINVAL;
> +	}
> +
> +	if (total_cmds > ISCSI_TOTAL_CMDS_MAX) {
> +		printk(KERN_ERR "iscsi: invalid max cmds of %d. Must be a power of 2 less than or equal to %d.\n",
> +		       requested_cmds_max, ISCSI_TOTAL_CMDS_MAX);
> +		total_cmds = ISCSI_TOTAL_CMDS_MAX;
> +	}
> +
> +	if (!is_power_of_2(total_cmds)) {
> +		printk(KERN_ERR "iscsi: invalid max cmds of %d. Must be a power of 2.\n",
> +		       total_cmds);

I don't like mixing KERN_ERR and KERN_INFO for the same event. Can we
make it just one KERN_INFO? (since we keep going)

> +		total_cmds = rounddown_pow_of_two(total_cmds);
> +		if (total_cmds < ISCSI_TOTAL_CMDS_MIN)
> +			return -EINVAL;
> +		printk(KERN_INFO "iscsi: Rounding max cmds to %d.\n",
> +		       total_cmds);
> +	}
> +
> +	scsi_cmds = total_cmds - ISCSI_MGMT_CMDS_MAX;
> +	if (shost->can_queue && scsi_cmds > shost->can_queue) {
> +		total_cmds = shost->can_queue;
> +
> +		printk(KERN_INFO "iscsi: requested max cmds %u is higher than driver limit. Using driver limit %u\n",
> +		       requested_cmds_max, shost->can_queue);
> +		goto check;
> +	}
> +
> +	return scsi_cmds;
> +}
> +EXPORT_SYMBOL_GPL(iscsi_host_get_max_scsi_cmds);
> +
>  /**
>   * iscsi_host_add - add host to system
>   * @shost: scsi host
> @@ -2801,7 +2849,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
>  	struct iscsi_host *ihost = shost_priv(shost);
>  	struct iscsi_session *session;
>  	struct iscsi_cls_session *cls_session;
> -	int cmd_i, scsi_cmds, total_cmds = cmds_max;
> +	int cmd_i, scsi_cmds;
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&ihost->lock, flags);
> @@ -2812,37 +2860,9 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
>  	ihost->num_sessions++;
>  	spin_unlock_irqrestore(&ihost->lock, flags);
>  
> -	if (!total_cmds)
> -		total_cmds = ISCSI_DEF_XMIT_CMDS_MAX;
> -	/*
> -	 * The iscsi layer needs some tasks for nop handling and tmfs,
> -	 * so the cmds_max must at least be greater than ISCSI_MGMT_CMDS_MAX
> -	 * + 1 command for scsi IO.
> -	 */
> -	if (total_cmds < ISCSI_TOTAL_CMDS_MIN) {
> -		printk(KERN_ERR "iscsi: invalid can_queue of %d. can_queue "
> -		       "must be a power of two that is at least %d.\n",
> -		       total_cmds, ISCSI_TOTAL_CMDS_MIN);
> +	scsi_cmds = iscsi_host_get_max_scsi_cmds(shost, cmds_max);
> +	if (scsi_cmds < 0)
>  		goto dec_session_count;
> -	}
> -
> -	if (total_cmds > ISCSI_TOTAL_CMDS_MAX) {
> -		printk(KERN_ERR "iscsi: invalid can_queue of %d. can_queue "
> -		       "must be a power of 2 less than or equal to %d.\n",
> -		       cmds_max, ISCSI_TOTAL_CMDS_MAX);
> -		total_cmds = ISCSI_TOTAL_CMDS_MAX;
> -	}
> -
> -	if (!is_power_of_2(total_cmds)) {
> -		printk(KERN_ERR "iscsi: invalid can_queue of %d. can_queue "
> -		       "must be a power of 2.\n", total_cmds);
> -		total_cmds = rounddown_pow_of_two(total_cmds);
> -		if (total_cmds < ISCSI_TOTAL_CMDS_MIN)
> -			goto dec_session_count;
> -		printk(KERN_INFO "iscsi: Rounding can_queue to %d.\n",
> -		       total_cmds);
> -	}
> -	scsi_cmds = total_cmds - ISCSI_MGMT_CMDS_MAX;
>  
>  	cls_session = iscsi_alloc_session(shost, iscsit,
>  					  sizeof(struct iscsi_session) +
> @@ -2858,7 +2878,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
>  	session->lu_reset_timeout = 15;
>  	session->abort_timeout = 10;
>  	session->scsi_cmds_max = scsi_cmds;
> -	session->cmds_max = total_cmds;
> +	session->cmds_max = scsi_cmds + ISCSI_MGMT_CMDS_MAX;
>  	session->queued_cmdsn = session->cmdsn = initial_cmdsn;
>  	session->exp_cmdsn = initial_cmdsn + 1;
>  	session->max_cmdsn = initial_cmdsn + 1;
> diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
> index 44a9554aea62..02f966e9358f 100644
> --- a/include/scsi/libiscsi.h
> +++ b/include/scsi/libiscsi.h
> @@ -395,6 +395,8 @@ extern struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
>  extern void iscsi_host_remove(struct Scsi_Host *shost);
>  extern void iscsi_host_free(struct Scsi_Host *shost);
>  extern int iscsi_target_alloc(struct scsi_target *starget);
> +extern int iscsi_host_get_max_scsi_cmds(struct Scsi_Host *shost,
> +					uint16_t requested_cmds_max);
>  
>  /*
>   * session management
> 

If you choose to change the KERN_ERR I mentioned above, please add my
reviwed-by tag.

