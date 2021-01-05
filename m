Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26CDDC433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 22:57:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E24EF22E00
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 22:57:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbhAEW5C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jan 2021 17:57:02 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:29244 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726052AbhAEW5C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2021 17:57:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1609887353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SZlBF2J4vlPZaZpTvkRukB/NdRu/CFck3xDEyykus2k=;
        b=aXoV1AaLalP6LYkrhkc/XdKdKFB7TmiHkMdzBk8nmBl7jjAOE9qJipb0Gni5+U8lcsygOP
        NslPlAMle+CWQhLDkhRpja8wlgO+sID70MMRcppvgBwYaoqNm5wbtrtjuggi/lKuFA9XZ8
        lIaf4r8FjCQVyzWJMooMPPltryN4XNE=
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur03lp2055.outbound.protection.outlook.com [104.47.10.55]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-25-spyj6psyNkKALHVRgZMQ8w-1; Tue, 05 Jan 2021 23:55:52 +0100
X-MC-Unique: spyj6psyNkKALHVRgZMQ8w-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fn+7mH2BSAna4x89exzzzuW/a8nF3zT0QDEBZRel68kOnWbJ/pv1lptoMa76NXoE7ECFObtjg/MvhxyuhJK4XK0MXmIEiQ2vA8zJSDGnpbuTQUacthuBpXjYmhITaKt6xPlGgjvvkGalnfWJn1HHRQ+KzTQ1ERMWO8e2YgUwblkDzxYmpBwVxixh8pS8DuEICbFBM5RY0n8uNYg9JaJ0Q22mynM07z0Y/yqf9p/ASv9sWY2FWoD9ci6eIAmST0U+rPNza+EMjWq7ESYzMciQlsN1fmUGH/9QvPOcAd3K7rg5BqBktChUtYCB7b1dlSl0Pu8Typ4Fxh1i5YgRCcxh+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SZlBF2J4vlPZaZpTvkRukB/NdRu/CFck3xDEyykus2k=;
 b=DBbcEyJugKLDswkRS6UP3iL29JBMux6GnITUgy0Cl0PXq2zgIGlWZEYYU5AGm1pda6wen8/9pn2lYob6oGurJhDTmZKaTTM2AiL8V/AaRe2IFOEEtr2CNsB1QjdYiAF4hHUbXGNrWLQakdfIpTlWrVI7FJyIOXLYLVP0fUKSy7JNutgoCbmLmrP16qBvXHRnqf3vDKbermZ1mIjkTsdTLiiH23TkBgbTZ9feD+FkRtVGdzQKDLCc9e490JKcScw0clILWAX3zixZCB5TYM8t5FWNYXeYwrwZnxMXLIwzkEdAm52d3Vy4cM/mrWRaZIh9EqI/DS4mIe/WdDeQfWw2Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB4072.eurprd04.prod.outlook.com (2603:10a6:209:4d::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20; Tue, 5 Jan
 2021 22:55:51 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::f447:4cff:66d8:efac]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::f447:4cff:66d8:efac%6]) with mapi id 15.20.3742.006; Tue, 5 Jan 2021
 22:55:51 +0000
Subject: Re: [PATCH 5/6 V3] iscsi_tcp: fix shost can_queue initialization
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com
References: <1608518226-30376-1-git-send-email-michael.christie@oracle.com>
 <1608518226-30376-6-git-send-email-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <25e548a1-7407-726e-0db0-fb593aa4370d@suse.com>
Date:   Tue, 5 Jan 2021 14:55:45 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <1608518226-30376-6-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM3PR05CA0141.eurprd05.prod.outlook.com
 (2603:10a6:207:3::19) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM3PR05CA0141.eurprd05.prod.outlook.com (2603:10a6:207:3::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20 via Frontend Transport; Tue, 5 Jan 2021 22:55:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c145591-eb43-4ab7-3fdb-08d8b1cd0ce1
X-MS-TrafficTypeDiagnostic: AM6PR04MB4072:
X-Microsoft-Antispam-PRVS: <AM6PR04MB40725CC999F376172EBD8A50DAD10@AM6PR04MB4072.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fgV1nvxkExoWLi5i/EugZzDHvf0nUqHc8w3t8udS42gi2k8hBc9EJ+reIc831e/GrEaP8JK8CxV2YMShV9PB/HaA/r26JzCXb7FIy0kRGPMxwScMtLoFPe3oVystUhJ+EH3FXxlwl8i4PTt1rr/yC3qsO+rNZdPSYGGQPvp7z331X6wlW7rxf1jkFQdDnvVgXgDjJ2P4j4+gK2io+dfLZY1OpaPcEWUxFm+JsZEzeAR3A2yjNGA9/5kcztJjk+g17QXi/MSC/EpssGumD8RaZAjOjMHwoWZI7U7MsvORWeKIUsb8o6W3eLg+oOc8TkkkoErYgnroHQZb1WL7Y2/y+fMrR+IuBnATU1/IZ18PzCxNKCmdUr+A2HEpXeCVIcrDqRSzEQDB1XIW07QFT7rO3cLmp+QWpwauyJV0AiofPahLPqp9fR8jyy/6oNAfCah0jjbu6jJWhJvqzZSZw7Q/Q/Qbi5FccACFWLq5yNyywWE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(6666004)(52116002)(6486002)(36756003)(16576012)(53546011)(956004)(2616005)(26005)(31686004)(31696002)(66556008)(66476007)(83380400001)(5660300002)(498600001)(2906002)(186003)(86362001)(8676002)(16526019)(66946007)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eXdTbzRONGI4UDN4L3RxbC9vQUxOWjRSUFFlNlMrSVhLQVpXdUYrQmdRSWNV?=
 =?utf-8?B?cjdtREZHM1Bqcjh0Z3dWelloMWRTcXkyZG13QWZDVXVxVERzWEdFbHh0QVAv?=
 =?utf-8?B?R2RNOHgrUTUwTm1BLy95UnB6TjFNN0p3Uk42YlNLOTNPWEZ5R05KRUhEdHpj?=
 =?utf-8?B?b0FadlFuSHYrbWx0VkFoRm9WZzNybERuSk1GKzdLbENMTStZeUtRaHF6Yngw?=
 =?utf-8?B?WmxJU0IxaGk2YitaeFNqQ3Y4V2RKNzNyQzdKU1RkOUQ4a1dUaWVEN1dVWThI?=
 =?utf-8?B?cmlWV05HMWJuTDFSZVRDZWg1eXhvOXJUN1oraVVUODhGVUR1czd0MjdwUG1G?=
 =?utf-8?B?Wm0xeU0vVWxoaTRRU01mTlZGQ2F2YTFqMHpKRnpmdC9BaXZKdTNPT3RkSENI?=
 =?utf-8?B?VXNmc25waXhpaGlodzJqMW9ZSVl3ejEwLzA0TGUzZ3RGOGw1V2tSbzFWNm43?=
 =?utf-8?B?akg2UDA3cWlEY2oxUW9PU21kT21iMjR5MzNxN1pTdDlIVU50MjhlaFRnQVBj?=
 =?utf-8?B?eEIxSnhTYlhJa25odGZ1MXBrWUQ3NWkzUlljM1hJM2hNTU9GNEpOUkFnSWVI?=
 =?utf-8?B?R3N1VXhXZlhtc2xhOHV4cnd4SGF1UU9IZ1did3FWcHM3SlVzSVpPUllRVHUr?=
 =?utf-8?B?eVNZQXh1V01mSGdReE82UXU2cHVaREFaRExrSHljRWhsdVkwMmhFRE9NZHhi?=
 =?utf-8?B?RExZaDRmMlpGRzN2RnpwS1FaVzU0RHdKcXRZcitDa0h2blRLU2FsUmRCZzlk?=
 =?utf-8?B?VmFNL0pzRTd1UGhqN2VQTEhQT0VUMUlTbE1sbk1SOEVjbE5yWU1EZWRWdHBy?=
 =?utf-8?B?eXpvU2k4N0RzN1p4K3dXZlB1OXBISHMwYTI0WnJkQmg0R3RLSEo4QWFrNDNW?=
 =?utf-8?B?dDk4SHdGVGZUSXhJZW9jQStXb2RPS1JZRmtsRG5vOFo2NU0yOVZncHBjL01M?=
 =?utf-8?B?M0ZxWHFpRTBvNENLei9pbVQ0UmhkSGFheFgrZjRiWndnSXN6cmhjUGZrYW9D?=
 =?utf-8?B?bXpZS2lRMHdIelE3eUpFTzFmR0tKQkx6RTkwT0cwdXNpSU4zcHI0TmlWQm03?=
 =?utf-8?B?NVlQQ1lnb3ppN3BVZXFEdWY2N1FFUzdXQ3EzcXFUdllEUUNISmpPYWw5QnlH?=
 =?utf-8?B?cW1LcGh6YzNCWlU4Z09ENnZwSzBuenpXOURycXczRkVSQ1ExYngwVklKZUd5?=
 =?utf-8?B?Uk5YMEFBbFN2N244N0VoeDlrS2ZzaGJtN0RPOWZZd0o0bGZ5eWUzSm9SbDcy?=
 =?utf-8?B?NWZWZ0ZrdUdtUTFyVXdTQVovYkJhVmdUaTZhY0RJREM1d0o4TWNTeXdLUWtt?=
 =?utf-8?Q?Tnv4FaDR4DvcI=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2021 22:55:51.4826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c145591-eb43-4ab7-3fdb-08d8b1cd0ce1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: avMwbbRUoodO4bkrb+ENlQPQ7pqzhxazneS6/tIXvIqOYxTzh0EO5TAhySFfEY1aBngaUXYt7LbJB9QO8H5SDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4072
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/20/20 6:37 PM, Mike Christie wrote:
> We are setting the shost's can_queue after we add the host which is
> too late, because scsi-ml will have allocated the tag set based on
> the can_queue value at that time. This patch has us use the
> iscsi_host_get_max_scsi_cmds helper to figure out the number of
> scsi cmds, so we can set it properly. We should now not be limited
> to 128 cmds per session.
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
> index df47557..7a5aec7 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -847,6 +847,7 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
>  	struct iscsi_session *session;
>  	struct iscsi_sw_tcp_host *tcp_sw_host;
>  	struct Scsi_Host *shost;
> +	int rc;
>  
>  	if (ep) {
>  		printk(KERN_ERR "iscsi_tcp: invalid ep %p.\n", ep);
> @@ -864,6 +865,11 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
>  	shost->max_channel = 0;
>  	shost->max_cmd_len = SCSI_MAX_VARLEN_CDB_SIZE;
>  
> +	rc = iscsi_host_get_max_scsi_cmds(shost, cmds_max);
> +	if (rc < 0)
> +		goto free_host;

Same question as in Patch 4: Is having "0" max scsi commands ok?

> +	shost->can_queue = rc;
> +
>  	if (iscsi_host_add(shost, NULL))
>  		goto free_host;
>  
> @@ -878,7 +884,6 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
>  	tcp_sw_host = iscsi_host_priv(shost);
>  	tcp_sw_host->session = session;
>  
> -	shost->can_queue = session->scsi_cmds_max;
>  	if (iscsi_tcp_r2tpool_alloc(session))
>  		goto remove_session;
>  	return cls_session;
> @@ -981,7 +986,7 @@ static int iscsi_sw_tcp_slave_configure(struct scsi_device *sdev)
>  	.name			= "iSCSI Initiator over TCP/IP",
>  	.queuecommand           = iscsi_queuecommand,
>  	.change_queue_depth	= scsi_change_queue_depth,
> -	.can_queue		= ISCSI_DEF_XMIT_CMDS_MAX - 1,
> +	.can_queue		= ISCSI_TOTAL_CMDS_MAX - ISCSI_MGMT_CMDS_MAX,
>  	.sg_tablesize		= 4096,
>  	.max_sectors		= 0xFFFF,
>  	.cmd_per_lun		= ISCSI_DEF_CMD_PER_LUN,
> 

