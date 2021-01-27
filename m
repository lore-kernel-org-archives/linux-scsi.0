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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EF48C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 19:51:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE6C764DA5
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 19:51:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbhA0Tuh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 14:50:37 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:28025 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233034AbhA0Tst (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Jan 2021 14:48:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1611776861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MkMF01ZDUi8Q1iQBG6dvYBZXeJiw5teJzQ3lBeTOXpE=;
        b=i2ZnFDtEuC0R3m6902eeDBucYLKnxw3KcGHfjGFWnAWaXBFmCsjhsiejfFWSgpg5I+l7PP
        cNeOzNKXjyXQSgUtLKBkDN7k8zJSDj4E+hKP4BwClxORdLkC1LnU9/6r5l4p4FsAI5Y1DQ
        RBzxvc7BSPa4+KJk/Qs2tNM7wB2TVUs=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2054.outbound.protection.outlook.com [104.47.13.54]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-27-YVZ8iCbFOsWqh_TSGG6Rag-1; Wed, 27 Jan 2021 20:47:39 +0100
X-MC-Unique: YVZ8iCbFOsWqh_TSGG6Rag-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DSOBw7l+/yxjNgvjuBXRRS/RaBfTpaLtK8rJB6k/QAdW268dgKpQpw+pMC6jRqgjo0p5b/w32YATNCsghlyHoWgBHH8NefAmu4tFoEuVxs/0uH3mkVHLemL27vPE9Y+9sxh3Xi/G/w9n+SjeQsQp7ZKXYefxWLRro5PTEiJuOVcsxNT1kee2ie2HRqzCKRebxjNNtz9bdBpbFsrhY0j9SecHAtjGI3uwHGtvya2MRNz4EfamcK/Meb0kpR0KcHvmK+vjimbk6PKKx4jlfF2AOPbk0O2WcWirgiXhsa+XvMlDxAXeXRA4vCu6YjClZUoeJTx0golqdPgHJweUwr7+Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MkMF01ZDUi8Q1iQBG6dvYBZXeJiw5teJzQ3lBeTOXpE=;
 b=LMjgQ+P6osIDH/l3jrpiVxxybnA8+tpZZw8j0Qd5fwXhuvOGxbYzTRyhHHm8Uewvb9RMPYKtvFTpPYlTegvWnOZE5WUotysdYZtdXspCyuGmzI29/x0W3Cihx160168mT6fNhLdbl8uUvNuxwYiq/CcI3v9yvZ8OW3gZACH6V0ATdInPTDb/mlVPdg7PZzafM9JPsT1V5nTbqFe10XlFJ7bRcylgE/PPQLV+H7iOAWNdWi9xF+APrpSDLHdetzCwwsUU2wCWveGLQtJbk83E4hfelT/6nTrUIWfBfbJK+aYqqMLWQDP4BPV3tbR9GWHoW07I16dfw6xRjssxijAdog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR0402MB3479.eurprd04.prod.outlook.com (2603:10a6:209:5::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.19; Wed, 27 Jan
 2021 19:47:37 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::c60:6150:342e:e042]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::c60:6150:342e:e042%6]) with mapi id 15.20.3805.016; Wed, 27 Jan 2021
 19:47:37 +0000
Subject: Re: [PATCH 6/7] iscsi_tcp: fix shost can_queue initialization
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com
References: <20210118203430.4921-1-michael.christie@oracle.com>
 <20210118203430.4921-7-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <acb2a56f-530f-bd63-d2a6-59fe1ee09075@suse.com>
Date:   Wed, 27 Jan 2021 11:47:32 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <20210118203430.4921-7-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM0PR10CA0107.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::24) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM0PR10CA0107.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:e6::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Wed, 27 Jan 2021 19:47:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6dc19b0c-3597-4a48-6cad-08d8c2fc6629
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3479:
X-Microsoft-Antispam-PRVS: <AM6PR0402MB34799371BEACA1427CE455B9DABB0@AM6PR0402MB3479.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6l3BU1Hu7JFAHeSU7wgpHzfMzxCN7cFdwmKIqtSYfoCI2oZRD/80vWzdztq1BizSCWo7myywEJgZfMKKcRH9KP6px+G3iVHcCHINNBymDOGR4Hm2k7G2PnDL242BV3STSKjhp6G1u/+EMMo9N7hs5FDuAyoCq0k/HHl4W8YPAJXunDXPKtt4KeZF6HLXOiYIUKRhHCYOLW6BK/2EZLUITaGj0sa1ruK8S45tkMbdTbzxWmac1E6O2b2O9nglBpzyF52BQWxVUOKgtzMQL5MCxJio9FKCc2KkIV+0z1/fBLfFPkV9JhALoUuih5rSe+AZ0JBiQJv381fl3LjQReupVG+lgHDiZl243xQB1IVN0iMZNF3IhqKUCmOy+RTJ15fw5319NO5uLc1fEbTGiEsXOY+TLlucUpSqPc/nPIGvsLXKSaonQQKJy/Lb+kVx9xewdVqtKw6MQAmBnd2eQcpzo7WqS3xHZpek2cDzXARqhlmVhRj6NZLLyNzZSEMb3hM3nJ+NX/Zn2Kqsojcbu6FpOBMiEj1Mt2nKQDEWm5PVHVNFZv16D42+6z6zUWymyv0glZM12z/Maz8DnMfkRDiHC01yFSx8Uqa/aHsH9mHEVEc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(39850400004)(376002)(366004)(8676002)(478600001)(66556008)(4326008)(6666004)(31696002)(66476007)(2906002)(956004)(52116002)(26005)(66946007)(83380400001)(36756003)(186003)(16526019)(86362001)(2616005)(16576012)(316002)(8936002)(31686004)(6486002)(5660300002)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ak02V0NRNTF5U1M5akZEMEp5ZXRtNGdwaytNV1JNanBMWnRZRWlNOTVEMDhm?=
 =?utf-8?B?c1Z0SkN1aHNVSU94eXZnMC9zQzNUYitjT0ozY2hXdnNEVEdTUjFFU0UySFZh?=
 =?utf-8?B?UWw3Um5OUjE4TXEzWnFNOE9PRlllWXh1QWFZenhmWWMxOXNBdkthdVh4cS9U?=
 =?utf-8?B?a0EwN3NpdlZQQUFrL0p4Vm5CdzhxMDlwNG5TNm84UXlUR1Q3dFpYdGJkMUla?=
 =?utf-8?B?bGRqRjdKbU5WRTdCK3BxdDBKOWtCMGdQNldhZk1sUmhaZSs4djdmTTNtZkZh?=
 =?utf-8?B?Y3VXcC9NbDh6RUlVUVRZdlFDMGFzK2crWDNJS2pQb0FSUnFTZFovQkRYMlUv?=
 =?utf-8?B?eDFadW5oZEVrUGMxTzVJa2JheGhaOGdoQ1lRZTNJNmNibnBJNGZTRklOMFNQ?=
 =?utf-8?B?K0FqdGg1YkVCZ3ZjZG5saU5tTVEzNXpXYXpiTWUxdXk0aXFJQ01YYy9Nd1Ex?=
 =?utf-8?B?VFN2Qk05T0xuaHlTKy9NSkRHMFNKQng1VGFTam4yUkl0Z3FEOUorWG1Tb1l3?=
 =?utf-8?B?VkRIVkowNTRhNDFtazBiZDZqdUhhSGNFMklGZjF0MStaOG4rV0FTRnBwN0ly?=
 =?utf-8?B?OUhCZ21sTUtLd200aFdocElSMEN6VFkyU0dZZmpXK1BJbDdCT010SktNMjBo?=
 =?utf-8?B?ZVN4VUFMMk93QUVHK1QwSElwd09qV3lRRXc2a2x4eEhBUndTcC9ISnVyRUFY?=
 =?utf-8?B?b29uWDFnRE41b04ycDFsYTJFcE1sN0pXcTJTbnA2V0Z1bUorS1NjdXVDYmow?=
 =?utf-8?B?Mnc5a2RWVWtkQVNkc1Job2doZ2lpcDdOUElRc0lDaG9xUjB3ODhOUElWTmRL?=
 =?utf-8?B?eGN1clBwMzJkaGRWeUQ3Y2E3OENFT2dJbjBweVFCaUdsaEdTenNrb0dMQTZX?=
 =?utf-8?B?N0JsK1VraGNhblVDSy9TNUdIYXFjN2hkbXFKN0RpcWNkbjExRENxTDJkQUtw?=
 =?utf-8?B?c1FzdUtuTXJsK2RneWdGS0N2VWQ0OXczZmNvbitXZk9leGwreDBJTUE2UXRY?=
 =?utf-8?B?bkJlOXdGNWI0Nkxkbm51VWNLU2pSc2ZpeTR5K0pWNFFtOFpkQUR4SENCRVhp?=
 =?utf-8?B?Y1BYdGd0WVZqWWRVNjBSWVlsOTJYRXRwVFBkcXBGRmoycDZpaVJVeU1rRmk5?=
 =?utf-8?B?OVV0ZWxXQVlVUXBoUytEb253dHMvcHl0OGZVMXYrRE1XREIxbC9zalRGN3NQ?=
 =?utf-8?B?WkIzTlA0K3UybWdOVHUrRnJGUnB6R0d5VjgxRXY0T3NKaElDNE80QnBUMHZV?=
 =?utf-8?B?SXJ0ak9ZaGRmeVdlb2N5eTFhTHcyVTR1YW8yOFZOSitHa0l5WWJhWXM2M09H?=
 =?utf-8?B?aitoa1hweW1sbzUzYVJ0MTdzb1BxK1dQZmxQUWczeW9UUVI0QUJFY2owQStV?=
 =?utf-8?B?dXdHdnMrd0Qza1FTU25MODA1ejRRTXNMeUhya3hSVGVHd2NVYktZbklxQ3Nr?=
 =?utf-8?Q?k/fUHnj9?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dc19b0c-3597-4a48-6cad-08d8c2fc6629
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 19:47:37.5972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 17GxsNX0bHxINuld+/RVAF/BCuMhRdk9Tpw3kqjpN8NxlUwZcDilzgQXTQqNVZP1gyMMRO8weMrgIZo//6HhBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3479
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/18/21 12:34 PM, Mike Christie wrote:
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
> index a9ce6298b935..f0070e3c7ffa 100644
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
> +	.can_queue		= ISCSI_TOTAL_CMDS_MAX - ISCSI_MGMT_CMDS_MAX,
>  	.sg_tablesize		= 4096,
>  	.max_sectors		= 0xFFFF,
>  	.cmd_per_lun		= ISCSI_DEF_CMD_PER_LUN,
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

