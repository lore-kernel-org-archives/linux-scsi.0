Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 122A6C433DB
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 23:35:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B589764E34
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 23:35:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233213AbhBCXfF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Feb 2021 18:35:05 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:20376 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233141AbhBCXfD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2021 18:35:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1612395234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3pvvwSMAL+07oYM/70e9DZ9OqsN8ZASFRHaNA8UVuRg=;
        b=hoo92zb9WPF8132C2le1hVmzSxJTzZ8ZYtG6+IDv1gLMzgkoPCCT4YpTEcsSyKPJDccy6C
        wBgamleCoVzFBJzjrFf1rRIFVaHMQx7WCgYrImpraQYBKVWu+F47eOPhrS9Or28scgfp+j
        WvLQWq/0KVzoB0S+2xTtdcZerRtNdBE=
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur03lp2052.outbound.protection.outlook.com [104.47.9.52]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-32-G7LwMsMjM8aafhQ6vELplw-1; Thu, 04 Feb 2021 00:33:53 +0100
X-MC-Unique: G7LwMsMjM8aafhQ6vELplw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ob6TJFuIzglBXKbDpl1td2AbgJy/R07w/ZkxbN54XFIpjRFNYlcAgJVntSVM+tfzyGHt59sQscJPBPCdyqyxwVpCmg0b+XrVbRDKNkQ4spErqr5Cx/R/HwspSz3sb5XDcUfKZ3eOoiJbhVigFnq9P6r8euAyk3XqZ9MhaS7ygiaNFJYd6PPvqzrzTP+FYIVUju/50OS4Qs0rEBA23elgQKjZT6mvmh/0FHD3X9NpV58733GEpeAABxLgKZ+fPUsXnpFmWFh8R50ZBg8J1lrL30oO4Wg6c7jkE7rwBEZYeQkDg/4WTGtYt6mKwXpDq4oMB+uPubyrmTsrJYqgcc3jVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3pvvwSMAL+07oYM/70e9DZ9OqsN8ZASFRHaNA8UVuRg=;
 b=cae7JjxTpwZeF4wb3FzW26Y/tZ1T/MjQx/HcEIeGbQ6QmTOVz/PDUbWcIwZ7Mk4Q6dhuj4Hh5CJ1ieoFmqen8SRz9ZKzv116/ikVwAsLnLM3Zf/ztCP7QBG/YRpbGccyYy6sk+NzzzRRNdliQV6n0oFJR1bwAhB1Jo+6+Ki14Svj0nNNBOafXvwfCbXhX3PuFZRsXe8IPB5KunvCFCMmoWklZVfF4ocK1AENlpCFcIQr+a7D/IQcGLreV3YNhgKRZDUoglIsbaiHjqaY6BrHhTaeYpE4hAXZe0JhM9IjN3hPD4A3IQfFNWwzqyT+Qx7BdupF8qTsE3tIO90lXagMIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=suse.com;
Received: from HE1PR04MB3098.eurprd04.prod.outlook.com (2603:10a6:7:20::28) by
 HE1PR0402MB3610.eurprd04.prod.outlook.com (2603:10a6:7:8c::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3784.19; Wed, 3 Feb 2021 23:33:37 +0000
Received: from HE1PR04MB3098.eurprd04.prod.outlook.com
 ([fe80::c405:e91:effd:a348]) by HE1PR04MB3098.eurprd04.prod.outlook.com
 ([fe80::c405:e91:effd:a348%4]) with mapi id 15.20.3805.028; Wed, 3 Feb 2021
 23:33:37 +0000
Subject: Re: [PATCH 6/9] iscsi_tcp: fix shost can_queue initialization
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com
References: <20210203013356.11177-1-michael.christie@oracle.com>
 <20210203013356.11177-7-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <a386eeb2-81f6-3a25-2af7-523b85880eee@suse.com>
Date:   Wed, 3 Feb 2021 15:33:31 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <20210203013356.11177-7-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM4PR0202CA0015.eurprd02.prod.outlook.com
 (2603:10a6:200:89::25) To HE1PR04MB3098.eurprd04.prod.outlook.com
 (2603:10a6:7:20::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM4PR0202CA0015.eurprd02.prod.outlook.com (2603:10a6:200:89::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Wed, 3 Feb 2021 23:33:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d8073b2-9c80-4beb-12b3-08d8c89c2177
X-MS-TrafficTypeDiagnostic: HE1PR0402MB3610:
X-Microsoft-Antispam-PRVS: <HE1PR0402MB36107A815532AD23AFB65715DAB49@HE1PR0402MB3610.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b1cWQmu3A2kdqGbRtDZdFAcgEwyWJCWGX4vB2w1HSkXrtKhJlj+3exqfIiVKyMs51e3SmkIPfoZ4byhdVsojx7e/mfeFy/yH/uUECZbJ806xGyFq2+5ahA9yKNUzajPbrGvTnKUY4Bb2P/fhiacN//QXaoRN41N7nUgfCv1Rs8KnU9Zt85iZRxJy+v7BqE+QsmeXT5guKQ9nupnzaewCxLPrE8gi/GWsJlepOpCu6fq/kkYnC6hYLvWarFt/1spfUJ1iNUmUtemGYOQOTCsz06zBKXNXwucXZ8mUhZGqYylhmfz+6D4PZymy38sXDZZ09mPEUauvbiSwoGxmAUSD1vTh5TNm83/FwpDn+5zvkKGsINheQ+D5EQwghoru6NzXRU+wWNltHHd70x9Vpf0oetSj8myLQBJ84/T0iw+OB65X83JBgwvUbL9QgTGOzwpSN4QOfJKYi/8E7msS2GItDs3+up9KxG0QGDsKBIWtX3vNSEC4Pu4y0vDfb+0C9tEev/MWdj/mhQAzUy6L7NCUkI14bYXCtCgVnI2XqoSFizQ7hYV+ygPxEFk1/bOjKpConK93sR4Gje76rU88uMBAO6W3pmRGwybqjf/gAe0RDkU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR04MB3098.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(366004)(39850400004)(136003)(346002)(6666004)(956004)(8936002)(16576012)(5660300002)(8676002)(53546011)(26005)(36756003)(2616005)(16526019)(186003)(2906002)(316002)(52116002)(66946007)(66556008)(4326008)(83380400001)(31686004)(31696002)(86362001)(6486002)(478600001)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VVVnd053RVVxVUEvc3RQSW5lMUxrVWhWRFZEYUI2WTc0Z2FGWlFsdnJDYlFQ?=
 =?utf-8?B?WjVYZXBmaExqZlNZSDI5RjlYRzRmbmJtTDdzaXZXLzVyN2l1cDFFNEtOdkVz?=
 =?utf-8?B?Rm1VdU5MVVQ5SFdrb3lGYmEveXFvSkNUbU5qMDhXTkVZZVdhWWxZODVXK01F?=
 =?utf-8?B?S29SRFlGSlA4eVhBakRmdGlyNzhNN3pEMG1GQkxxTmczZmJCamFLZXBoOTli?=
 =?utf-8?B?UUEwYU5jNzVJUTFBSFJnZ3NsWE5PVUw4bFdrWlFOWU9leUN0NjBZRUV1RjFJ?=
 =?utf-8?B?ajIzSXFTaktvUEczSXV4U1FJYzBrVmhNQTJMSjBwRmQ1WWxtNUdWNlJUNDhZ?=
 =?utf-8?B?elBtUVdMOVhoZDRsOUd1QWNnRVVrVlAzRDE0MnhrZjQybm1IMWlabXJTYXhm?=
 =?utf-8?B?QzFqZ3dYNHRhekUvd3Zjczh3VnBqaHBzOHRMTkRWWFRUeFFSM1Z2T3lRLzc2?=
 =?utf-8?B?OXNQWHFBVm9SN0lWRU5UOHZHajNNTFVOV3VCZVBMQnlxUmVJamM0SC84Ykp0?=
 =?utf-8?B?dGtJZkU3TWZwV1pFTjdHUy9pL3M0TDV3bzd2SCtCbUNyelBYLzFoRE5yb0Rm?=
 =?utf-8?B?ZGdwT3RPMC8vb3FoVkQ0Q3FMb3J3TXdrcXh1RUpML3FnaldrV3pxT2pNLzU3?=
 =?utf-8?B?ZDhqMk5BdGRpUFBlOVp6S1ZLL2xtRExNQmRrdWtxejZud3QxTXg3L3N4eTAr?=
 =?utf-8?B?ZWI1VTd0YTk3cHpSc0k4dmo2ZHhWeHU2TXhWOXVnTjcwQnpVR2JydTZxenBH?=
 =?utf-8?B?QUNpck10L2tSd2d5OVlVR0JralNGQmtKZnBYQVNwZnZDNHE3eEpTNnNZakZE?=
 =?utf-8?B?dm01Um5YTzVGWTBkblF1OVFFa1FoNGV4STYyTHQxTVQ3TDNGTmRkb1lXTEk2?=
 =?utf-8?B?Y3ZqM3hqQlltSDE3eGJvSGIremtscDhVMlNGMitDTWdnbjlYRWxnOGtsQy82?=
 =?utf-8?B?VXdtNk85S0lHNnliRUVhMGcyWHBlRmpRZmladVBqVmRWMHVlQ1N5eU5jVEJQ?=
 =?utf-8?B?L3FxOG55dmg1blZ2ZFNqNkZxMlhGS3ArZ3d1RUh5MXNVRHFFcXpWR3BZU1Y3?=
 =?utf-8?B?bGtnR2N4QndJMGdGT3FtRXNsaFdleTh6dzQzT1lsYVRuZ3MvQm9nU2tOdWtP?=
 =?utf-8?B?c29PQ24yZDRjcHQ1NlZJSnZKQ3RTOXNjQVpoYVZZRStmNlJWdUZpcXM1K2V2?=
 =?utf-8?B?NW9KYkJkRE9Mb2tJdEtHMHptb2R4ZFhUcE1ZY09RTUgyVUdDR2RIOVl5QXJI?=
 =?utf-8?B?R1lGTHNaTzFDY0ZQV1FBQXNweVdzaytoekEvTlFIaWR5M2l3TFJLUUVKdmk4?=
 =?utf-8?B?MTdSUUx6RnhvVy9nUUU5QlVidTFKWEhaanYxMlhwaGRSNk1ya3BtOUplRlli?=
 =?utf-8?B?Q09QcmlrMjFCVUVhYWtyN3Bad1JZUWo3R0pXR1YrdjNnTnZnNFR3UWJMelNW?=
 =?utf-8?B?b2RjVkMrWFh4eDNrYVZVMVJidUN6RW9pRzB6SWhVdFRCbmtmMEpQMVRJY1ZO?=
 =?utf-8?B?WkpoWW5Wa3hnQ0tEREdGcTNiSUdnZUpQYTE2TW8wMGplaVJLc3dZVmZ5VllP?=
 =?utf-8?B?TW9TNkV0M0d5TGV0Z3pkUk1ybUlQSVZtaWhrcC9jV1pHRTQwU0lvVnducHlK?=
 =?utf-8?B?L1NseUx6MndSb1gyU1p6RFBPbnJMZUdrTEdJNkZKUkNad05hT1ZFNUQxb1lj?=
 =?utf-8?B?b05TNWpaNU1tejlUVGhFRGVDN0RYTHIwTE01VWVoVGUrMDlHNGtsRytZb2V6?=
 =?utf-8?Q?/3Wch/I6jeCjcHKvHMFrZmUZSMRKOFBHKb6XeOK?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d8073b2-9c80-4beb-12b3-08d8c89c2177
X-MS-Exchange-CrossTenant-AuthSource: HE1PR04MB3098.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 23:33:37.8118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 23WCPgt1beGpwlZniJXIxblJfq8rDa7R3yWV+tlHO1/w4pJmB+OhLYd8qJmGvavDLljtoMUOIz6GYXsXsh8YLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB3610
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/2/21 5:33 PM, Mike Christie wrote:
> We are setting the shost's can_queue after we add the host which is
> too late, because scsi-ml will have allocated the tag set based on
> the can_queue value at that time. This patch has us use the
> iscsi_host_get_max_scsi_cmds helper to figure out the number of
> scsi cmds.
> 
> It also fixes up the template can_queue so it reflects the max scsi
> cmds we can support like how other drivers work.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/iscsi_tcp.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index a9ce6298b935..dd33ce0e3737 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -847,6 +847,7 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
>  	struct iscsi_session *session;
>  	struct iscsi_sw_tcp_host *tcp_sw_host;
>  	struct Scsi_Host *shost;
> +	int rc;
>  
>  	if (ep) {
>  		printk(KERN_ERR "iscsi_tcp: invalid ep %p.\n", ep);
> @@ -864,6 +865,11 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
>  	shost->max_channel = 0;
>  	shost->max_cmd_len = SCSI_MAX_VARLEN_CDB_SIZE;
>  
> +	rc = iscsi_host_get_max_scsi_cmds(shost, cmds_max);
> +	if (rc < 0)
> +		goto free_host;
> +	shost->can_queue = rc;
> +
>  	if (iscsi_host_add(shost, NULL))
>  		goto free_host;
>  
> @@ -878,7 +884,6 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
>  	tcp_sw_host = iscsi_host_priv(shost);
>  	tcp_sw_host->session = session;
>  
> -	shost->can_queue = session->scsi_cmds_max;
>  	if (iscsi_tcp_r2tpool_alloc(session))
>  		goto remove_session;
>  	return cls_session;
> @@ -981,7 +986,7 @@ static struct scsi_host_template iscsi_sw_tcp_sht = {
>  	.name			= "iSCSI Initiator over TCP/IP",
>  	.queuecommand           = iscsi_queuecommand,
>  	.change_queue_depth	= scsi_change_queue_depth,
> -	.can_queue		= ISCSI_DEF_XMIT_CMDS_MAX - 1,
> +	.can_queue		= ISCSI_TOTAL_CMDS_MAX,
>  	.sg_tablesize		= 4096,
>  	.max_sectors		= 0xFFFF,
>  	.cmd_per_lun		= ISCSI_DEF_CMD_PER_LUN,
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

