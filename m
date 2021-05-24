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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F538C04FF3
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 18:45:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59FF961411
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 18:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbhEXSrX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 14:47:23 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:54123 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232746AbhEXSrW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 May 2021 14:47:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1621881953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fQSKoibVYXiOKgbsx0z6l0f8QctiP4nIKOpEB4GK8W0=;
        b=jzcypVzk/vPSv5fWIf+1mxsJ4Ite45aMLaZ3CW9PfWrQR64XGdUm/sUPllu13lTjnWhlOh
        44lJXZiCMA/yo8ztBhKlL0hjaTh8P956qXgbpeFwFGUpj4qdrZcb2nP7KV5bIWD/emhI/r
        HgQ3y1s0yfM85jI31gHIeONFiuGV3tg=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2050.outbound.protection.outlook.com [104.47.14.50]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-5-aJwaqEgiP_ikLHSevpNAKQ-1;
 Mon, 24 May 2021 20:45:52 +0200
X-MC-Unique: aJwaqEgiP_ikLHSevpNAKQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kbl7G0L9JLz1PF2K2+cOjtdCtBE/VNFTHTXamdjMziXpQi1Qv3q9KkUTZTLeu8iQ8twT6b2IWbAmotC8sWclRkiMP1/nQVq5sI6g1w42pmfuEMAp5ZHi890IHdoCHZK4mXZGcRlnikhEbfBVLNPlPMyKY35kBdA/Ns8D6CS8RMJ7UI+cBh/DXR0onMx0VAMXnM2Sw2CD91E1dKXBdPn45i29hQliG8SpwdY3dkvSLIYuYj+Rue45Tr/tshkZf97F68vidysZMEou4COK1fj29c6tvXKDNxiC62a6+tp4KhUgB5XDJjP7S11oEAnOVeo+ejn0jLRi8l+POgiSVta9lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fQSKoibVYXiOKgbsx0z6l0f8QctiP4nIKOpEB4GK8W0=;
 b=lnQaI3QTdwjUn65emUBZ5cBPa2+ouuQWu79qBbh9QxCU7eJHVwG5o7bIkYJ3yzmkxAdSZb9q/FAdAOLbJ7fKdiKByNxP1C/elsXQbAGFx4QLJ9ZOm1wyJDRDk8IREygRN+cXKVcRU8g3kPBaHDmK195hH+DoxjUNC6ENnkxPKHEO895tDu9vkIwlZngWL+KmU8Hh8PcdM7TdtQTf6R10FaqYwd0VXuru3UYNPA3ISwaobeFMMAKteESpVPGi3f2mcX/WbFisg3Lml0aO/QumssRZa1VXhWgAMnskMkzClxFqt+oQXb+BYt8aykhW3w9+rewnkRTNcFajW+VSl68OJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB5925.eurprd04.prod.outlook.com (2603:10a6:20b:ab::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Mon, 24 May
 2021 18:45:50 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d1a5:8072:c01f:3cf1]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d1a5:8072:c01f:3cf1%3]) with mapi id 15.20.4150.027; Mon, 24 May 2021
 18:45:50 +0000
Subject: Re: [PATCH 17/28] scsi: iscsi: Hold task ref during TMF timeout
 handling
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
References: <20210523175739.360324-1-michael.christie@oracle.com>
 <20210523175739.360324-18-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <2f0e9864-f940-b283-2dd5-a6945de05bfd@suse.com>
Date:   Mon, 24 May 2021 11:45:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <20210523175739.360324-18-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: FR3P281CA0014.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::7) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by FR3P281CA0014.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1d::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.11 via Frontend Transport; Mon, 24 May 2021 18:45:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b62a16c-5e9e-4f28-4526-08d91ee426d5
X-MS-TrafficTypeDiagnostic: AM6PR04MB5925:
X-Microsoft-Antispam-PRVS: <AM6PR04MB59250311CF60D1723FB4C96BDA269@AM6PR04MB5925.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V2KaavtJqEkXOcMl4kWEn7H8Kyrr989E+CG95ZaA4NtfWkI4IU7uFe0ir/HRs4LG3k4USK6KS64uzF67dXLTazNKLcgWr5CwJ54mj79mdcUiBWYcwzYJ3PIqTZhCfaRb4ooVk9LPwExbyfDyfNjciOcQRaL0hiG4poG9WElZwgtkoKkD/wj0X3uq0Q+AHLpkoIfuARfs2fP+GEg8PSy8MuBk060yjqnkVNzxmkODChu707oc8KqGX6CLc2k9x7taACIyn0qlx/dX1V+1WL5mx8634ja5t2SBzM0zxBJ22noV0B7QGnjXfmvj37LLt6K4q106UJfP/4p7qIghjAZOO+q/QrX/6eKEPClH6FDu7xyuMnUhm12E2E6O3B9OA7fOfgMg7SlZk+9oSqB3Th9rT8eSUD3nBmtGiHgQ6mMsjLsl0kiWWGSOo3b8b96oPsZ1exS2W/JBGOEaRPJSHkoejRjPucE19xfx2vafo9ot1kwsIs5rsUHc0L2PXwGCIrZF3OGYOEFlPrebqTygIStGRMdc7PvZFKP+NOv+L7XTyrs+cNFIC5iqxYagwaacpaUyfNRhMyfeUadaWebJzC8lQa8wLwRpJlprOuVXqP5/TPLHxTl+v6YKkxeNsttbjsxvwuem0gRMUH4+feoMjBEBhd0iMQTubd0hYSt5cM9X9WYzYKdkhGQAV2rjxmmPSoNQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(136003)(396003)(39860400002)(2906002)(2616005)(956004)(66556008)(31696002)(8676002)(53546011)(36756003)(8936002)(86362001)(5660300002)(66476007)(186003)(66946007)(83380400001)(16526019)(26005)(38100700002)(478600001)(6666004)(16576012)(6486002)(316002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?c3JKWDJselo1dnlzWFFVcjlCSlBFbHVRektqeWgyOEF6bHJnMjJiTlh2TDZ5?=
 =?utf-8?B?S3BVSUxGNklyWTBSTmtiN1I3MmlPUlVWL1k5VW1rajdHenptUDZhQUNreStj?=
 =?utf-8?B?bmN0aWZybllDSTJvTWtFUzBvOUxsR3FOTVRYTllFWUVQdEl2b2RtbFB3TG9U?=
 =?utf-8?B?cmoySkVQRUlsRTVabVV0d2luY3l3cHFxdkUrdnhVSEowNVFSY2JGK1RHV0oz?=
 =?utf-8?B?R2N0QitJazN1dlFEZGpTSzk5TjFQZlVzNVVFenp4ZytscFIvTjJnd3NsV28r?=
 =?utf-8?B?bzhJSTF0QnFoRGJ6bUZaRDYzT2xwVDYxUGRwSVBWMVpnM0pYS2NET1dnb1g4?=
 =?utf-8?B?NzlINEUxMWJVa1p4TzU3LzlhTmZOMjJlK0c4VkUvS1Q3UDVOb3RyRVdIaUFm?=
 =?utf-8?B?UzVYQlB2Z1ZLV1dDelozQlhXZTJLWnRkMEpUbDNtMGJxaUV0Mm41RHZvZW5o?=
 =?utf-8?B?a1VmTHlZbFYwS2t0MDYrako4T0lFRmExdU5zazZvWE5rTHZxTnJOdzIzQVJ4?=
 =?utf-8?B?QnBIeVBZa3F2SUxHRlo1bDJLZVl2UnlpOUZHR0NMVjZOUWpmMktYbFl5Y1BO?=
 =?utf-8?B?MmgwU3grMmlISUhqZFV2cWMxckk5L1Y0Mm1TZW9OQ1lmc0dHNDhONVMwN1N5?=
 =?utf-8?B?cmExYlRVNjY4MlZ0WFRXQkwyUEJVOVdyUmtHSDJrekxxSHNKVnJtUXlkdkJB?=
 =?utf-8?B?OTBUeGxZYzNyYlhuZmJMY0JuSTY4d1VwUTZmOXpEVzRHUVBlRXc5cExpZEl6?=
 =?utf-8?B?a3JGUU9oTmFyUDcweU1wYWp5T3BKcGRmRzNGWlU0QkRsa2RRbG5YS3lVQ2U5?=
 =?utf-8?B?cG1rRWw0bGUvQ2dhWUpXZ2hXQnBtZ0tWZGhFdDl0MEZMNEp1QVdDQ3NVa3Yv?=
 =?utf-8?B?WGxBbk5MSUNqWW0veFhJOERyMjdZRklnanJtdGhQTkQ3SlBkK25ieHUvMmhv?=
 =?utf-8?B?b2Z1MytLMEZqM3FLUk9VQWNVd2NTNXFJWTJ4aittWWJaSFlBUmJTSTcvYTdq?=
 =?utf-8?B?bGVZdHAvS1NoZ0RrOGp0MWV4QWp2dys0Z3Y4SVFvQzJKWG9uaG9kRU9xaHJ6?=
 =?utf-8?B?U0t1WU50b2QwblJVY1JQMUpqVXZGVVVpem1IUFNoaTBFUFZicktDeXhTVFZl?=
 =?utf-8?B?TGhLOTdIT2pmQ2pMTHF0VndwVXNka0FMRzlxVHlzdlRORHRVUkZnOUkxVW1D?=
 =?utf-8?B?K0ZVZ3k4ZzFPR0hMcDlRZkI4NzEyV2RGWllUZmFhUnpHdzFKSlVhbGRBeWht?=
 =?utf-8?B?SUNoNllLNTVqbzVHbUxhellCb2p1MDlETFhvYzR2SFN0YWlLR0dYeE00U3dk?=
 =?utf-8?B?QmIvYmN2OThDTzE5TlVsdEZSU3NiT1JRaWFjRlpiL1o5cEtHb1BzVUxLWEpM?=
 =?utf-8?B?cmlLbEN1MWt3Z0tNUWNKM2czNUNpb213cnNQTkdDN1BaUDh3YlhabG1Xc2xD?=
 =?utf-8?B?aWRTcC9MaG16ZnVoanliWkZzcno0d3R5RVBiVnZoWno5WG40NnZVMnFEZ1Jw?=
 =?utf-8?B?MFlXelI5N3IxMzByRkd5SUsvbkczOTdiYi9oc1lXZmlyM3g2cGtscEQva0p3?=
 =?utf-8?B?RjlyT2tVbWVGSml0YS92K3FOSGwvWmVWM1UraGVHcG1hRHJXMjVCN1lnd1lO?=
 =?utf-8?B?emsyenI5UmRLblBlNmE3VEZsSXFvbHFIaUxUYU96dGF6ZDRtS1BOVEZCMVhY?=
 =?utf-8?B?M1BuSC82bk1xS3BOelpuSzJnR3V4ZzJGOTJTVTlqTXpmeWNSTUhFMnlxM0RQ?=
 =?utf-8?Q?JHJFTvpXrbNEFZhcXlUq1vN2xsgtndxF5RvGTg6?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b62a16c-5e9e-4f28-4526-08d91ee426d5
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2021 18:45:50.7830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xG0yKF1XlThP7jLsv5uhsHRqWAeqnuCx3vVL8Jncfc9AMEr9b2JSOWtC8+UB29a1HYUOgh7LjKQdEENzllKPnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5925
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/23/21 10:57 AM, Mike Christie wrote:
> For aborts, qedi needs to cleanup the FW then send the TMF from a worker
> thread. While it's doing these the cmd could complete normally and the TMF
> could time out. libiscsi would then complete the iscsi_task which will
> call into the driver to cleanup the driver level resources while it still
> might be accessig them for the cleanup/abort.
> 
> This has iscsi_eh_abort keep the iscsi_task ref if the TMF times out, so
> qedi does not have to worry about if the task been freed while in use

typo: "been" -> "being"

> and does not need to get its own ref.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---iscsi_stop_conn
>  drivers/scsi/libiscsi.c | 15 ++++++++++++++-
>  include/scsi/libiscsi.h |  1 +
>  2 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 8222db4f8fef..9247f70d2daa 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -573,6 +573,11 @@ static bool cleanup_queued_task(struct iscsi_task *task)
>  			__iscsi_put_task(task);
>  	}
>  
> +	if (conn->session->running_aborted_task == task) {
> +		conn->session->running_aborted_task = NULL;
> +		__iscsi_put_task(task);
> +	}
> +
>  	if (conn->task == task) {iscsi_stop_conn
>  		conn->task = NULL;
>  		__iscsi_put_task(task);
> @@ -2334,6 +2339,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
>  		iscsi_start_tx(conn);
>  		goto success_unlocked;
>  	case TMF_TIMEDOUT:
> +		session->running_aborted_task = task;
>  		spin_unlock_bh(&session->frwd_lock);
>  		iscsi_conn_failure(conn, ISCSI_ERR_SCSI_EH_SESSION_RST);
>  		goto failed_unlocked;
> @@ -2367,7 +2373,14 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
>  failed_unlocked:
>  	ISCSI_DBG_EH(session, "abort failed [sc %p itt 0x%x]\n", sc,
>  		     task ? task->itt : 0);
> -	iscsi_put_task(task);
> +	/*
> +	 * The driver might be accessing the task so hold the ref. The conn
> +	 * stop cleanup will drop the ref after ep_disconnect so we know the
> +	 * driver's no longer touching the task.
> +	 */
> +	if (!session->running_aborted_task)
> +		iscsi_put_task(task);
> +
>  	iscsi_put_conn(conn->cls_conn);
>  	mutex_unlock(&session->eh_mutex);
>  	return FAILED;
> diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
> index 9d7908265afe..4ee233e5a6ff 100644
> --- a/include/scsi/libiscsi.h
> +++ b/include/scsi/libiscsi.h
> @@ -276,6 +276,7 @@ struct iscsi_session {
>  	struct iscsi_tm		tmhdr;
>  	struct timer_list	tmf_timer;
>  	int			tmf_state;	/* see TMF_INITIAL, etc.*/
> +	struct iscsi_task	*running_aborted_task;
>  
>  	/* iSCSI session-wide sequencing */
>  	uint32_t		cmdsn;
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

