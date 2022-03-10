Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20D3DC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Mar 2022 22:50:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344478AbiCJWv2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Mar 2022 17:51:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344487AbiCJWv1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Mar 2022 17:51:27 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7B1F4060
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 14:50:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1646952622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fkJ0IssjlxjNjN87pgBTUzsP0Qwfcrz0LAeEco/bkUs=;
        b=LXO85MYjOYcJi98+2fn55cuBTfHmwzD7VDZZyouYgLhsVKxqkBl5FJunJZRAfce8twlsQ2
        CoUc/f/IyPsFtcpeMLU5PZQdOkoLEfRlWauSQtJNMrkxkJqMsJk/skLn9whxvdJK+BGFTa
        7BODR2ljl64jzvE9hyNu5WhLQIX+yYQ=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2113.outbound.protection.outlook.com [104.47.18.113]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-26-2xUHkyi6PfeqKoEkbWLIiA-1; Thu, 10 Mar 2022 23:50:21 +0100
X-MC-Unique: 2xUHkyi6PfeqKoEkbWLIiA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ND8jr3NIsJhqSLIx65E1AEAZ4RhSyx55u9wxZW0/y93DWDgpIPZR1ut8dJE+wsdWT7PXG6CQiU8XKX2oyToouEibRDf8qG7cCja351EYyZ6LY012/0JGPCsLP78uLovbPuXVNG3J/RNUyk+s7ScL2x2nhPJRSS05s4/jO8VRxod/MSpV67u5+XxTgrB+LLdiKJHiNef2aKysV1ajeY0cKixtULJ+LJJVutCpz+Wc5Cg6W+Iri2ve8ibM++oI1LD7L1dvhSptMJkuioEhxKifBuaOl046tVS3KGMU39IucSYV1U4BJUlIFpx2YV1UuIH/5FdJOVD6f56YJl5IX92DKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fkJ0IssjlxjNjN87pgBTUzsP0Qwfcrz0LAeEco/bkUs=;
 b=mrAhrYx3KrHsPbfhTT9q0wecq+Ii6OSRqYbR16yREaYQykaia+AJzAEkseG+phL8Rb/I5m9e3qGFzE6Kw7BYibmshdAIBqsMmKD7k6qtLh+aI1YDIrjPoUazsjttc2pUIzhYiB9iC7LhgOGEHkuN1Due6lqWGOZXTwjCPNxaFErcFfkpviX1SUpTtURwEkmsOrdbVLXMTPHL4yZC6XR6/7juDw/vqzudmqGgijQverEL5a/VzR6gbiEyD3cgjFdOmRyZZrg1a+Wy3ZE33lPrPQoDtq8PLwxsKGj40J37fSzRf1qGoup7DAFnklr3LTSjuLKe7li7DXL8CzbPJ/3zrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from HE1PR04MB3098.eurprd04.prod.outlook.com (2603:10a6:7:20::28) by
 HE1PR04MB3227.eurprd04.prod.outlook.com (2603:10a6:7:1a::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.19; Thu, 10 Mar 2022 22:50:18 +0000
Received: from HE1PR04MB3098.eurprd04.prod.outlook.com
 ([fe80::74e2:c50c:5ffb:3980]) by HE1PR04MB3098.eurprd04.prod.outlook.com
 ([fe80::74e2:c50c:5ffb:3980%4]) with mapi id 15.20.5038.027; Thu, 10 Mar 2022
 22:50:18 +0000
Message-ID: <80fe5fa0-5b32-a1e1-3b14-30e1795dea9e@suse.com>
Date:   Thu, 10 Mar 2022 14:50:13 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 03/12] scsi: iscsi: Add recv workqueue helpers
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20220308002747.122682-1-michael.christie@oracle.com>
 <20220308002747.122682-4-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220308002747.122682-4-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0317.eurprd06.prod.outlook.com
 (2603:10a6:20b:45b::27) To HE1PR04MB3098.eurprd04.prod.outlook.com
 (2603:10a6:7:20::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ceb4da23-df3a-4234-05d7-08da02e85984
X-MS-TrafficTypeDiagnostic: HE1PR04MB3227:EE_
X-Microsoft-Antispam-PRVS: <HE1PR04MB32276F1EF9DCE40506686235DA0B9@HE1PR04MB3227.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fuRDGs4apTHbfKbfgE1rqZjNYVtZgwXvaCDFxLiHOjyXZBxN8/rIrgk5OFJy94M9dDXC/H47SGGhwXXWrvU9lqimR/1yumBwai3eu5oieBBA7W6NWT+bN1sST4gsd0Cl14orIJc5+4OjPtPjWyhA2D8d3jlphxu9yqM833p+2mReffoDDpqPO7FQulB0KgIXqXOQ4jrLgDvU6S79+Yp8y67pOM4n+fc4rHG39GeTiUlOMHk1EwYo98GNd/lz/l4KF6sbAfHOsjjRTwjC7SdIOWEdI8T8BJfirzkpiaa2pAJJkqvfcZl1ikY/Uc76ZcZk9/Onry6w/9oE2J/I/KecrReCBQ1IvtAe/0Xh99bFWvHNxEIW5wMfrMTI7aGNqPNWdyas7KnYmM0drCgcBWhnZTjvkhtyGWSbzrlkbN6aBbweFiANerX6d8/46DXx7sEqd+b9cpXBbvBB0EeUBQwWUdwg5D9nevIERNoIh3ELe9hotLhjQMG5ZN5wgaPJPo5FTENLfIWYX2eChi41V/xLaW1mdPNO8rhVLO4tO+rXHjAF8hkppeJZJ7GP7419Rea/wryJvnCDk32qW0YVP35Q40WZTa+SUSc7RHYAQCrm1AzrdTzCsSHK3xUmRyLVnxTwkTnhDQXJklKGfNMAnQUNZG+aovX1/+vykLixkB3NGZCMlqYL4DjgBzuU9wrjtom2+6814Sb4JAzoO0MT3UPx9LGi5JXFvX2FygrD0129480=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR04MB3098.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(38100700002)(2906002)(2616005)(26005)(316002)(86362001)(186003)(8676002)(66556008)(83380400001)(66476007)(31696002)(36756003)(31686004)(53546011)(8936002)(6486002)(6666004)(6506007)(508600001)(5660300002)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SmxwY2ZXQWJtL1RVVnp5L05XVDkyVmMrckJIMHNlaElLN24wU0x2U3ZUOFk4?=
 =?utf-8?B?VTRhV0Izdnd2d2NKK1FQSEZwc0pHL3l0bWs1cGdCaHl0WlR1bmtETytYdnhl?=
 =?utf-8?B?enp3YUFTQVRHSVNTVURvcjlWU1UyMWVUMzFrM0ZReGlVcUZRSnc2WWM4OUUr?=
 =?utf-8?B?Y0hRWENXemkxUTZFWmVwSy9PZm1pWVhzVHhmOUVsd3l4YkNtM1I1MDliMG4r?=
 =?utf-8?B?TzR3Q3ZIcHZhblJ4VGZXS2l1TmR0UzR3aGJDeFQ1UWdheXZVS29kUjJuczVQ?=
 =?utf-8?B?cTRuQ2JrblFaeUFubFd0ZTFVNWxNb0d5cEJXcUR4Q1R3VE5aWkZ5aHJFaUdY?=
 =?utf-8?B?dEJkcHpjQWxHd3FXTDZyam9JMWFrNXRQd2JqbGZCcExkcHh2S2lRTUlNcVRw?=
 =?utf-8?B?Rk5yMklYYmEwT214d1RpdUx4NnpUa3UwbEhuV1J2Y2VTSmV1WjBwenltdmxj?=
 =?utf-8?B?VVVSWmNIeEhVK3RpWW1jaGo1VktZUlRWVDRUWmRndmlaQXovTDMxOVUySGE0?=
 =?utf-8?B?cG5hY1BMbEdMWnFSdHdNVjk5bTEyZXZ3WHFuRVdtRTg2TWs5YVE0dVlUdThp?=
 =?utf-8?B?V21SZXlCZ25heThhVWNKOGNTeGs1V0FzMkptRnBCc2U1YlExdWg0SXl3TWpw?=
 =?utf-8?B?em84aTJqbWxrekd5azJMQ294M2pFd0NuVkZBUzNPREJZOHJoYzkrUHZ4dW1O?=
 =?utf-8?B?MHArMUN6WFYyM1BzZGRwNGlveHd1dVNRWUpkVXdRUVhJT0QzWVBHUHVqVFE5?=
 =?utf-8?B?ZVB0Z1BvazFhOXJrdURhZ0pYWFJHU1M3ZCtZcFNscGpncE41NW14SVREK3dt?=
 =?utf-8?B?OGFwdmpzdUl1Q2NZQnhmRkJ6c1JRZzFZR2RvTEpwRlhTS2gvT2tiMGM0MU9w?=
 =?utf-8?B?c08vVjJXck95Zll2OG5tKzJKVWpMUXRJYVFnZ1o5bWIrQ1F1aS9CMVRMbzBK?=
 =?utf-8?B?RmNGWTdRQk1ma2V0VW5YTDlCSnBwT0hOcTJRbnV4RllQblJyR2R3UGVWUzNp?=
 =?utf-8?B?VVR5dWRZd0JJekFwV0Z0QVdnS0MxVFB1Q04zaWo5ZktTSEZnbjFTaHFJQ3la?=
 =?utf-8?B?alhQZzAvKzVRdHlzL2xUNmlPVFNRM1NYVDBBUjNzeDdzZk1OY0FPYmlLbGpT?=
 =?utf-8?B?Qk4rcEtkdjJrZGZzMHBEOFBWK2haUVNqSi9wU01JYldDTzR1TWdGUFF6TXVn?=
 =?utf-8?B?MXVHZHdBME5KOEQ2YnhIaGtWR2t2bXpUZzFlb2tWc0J0Q25DdEFud29ZT2hX?=
 =?utf-8?B?Z0JudjIxQk52cG40NnlOeDJWTGk1UitpTFFrZWh1M0U2aE5UT0g0alIwS1pZ?=
 =?utf-8?B?YUZLMjNzSkpFcHdseUNkRC8xZUlFcnhpMkV5TVp6S0hqN3FyZGVCamJiSm5a?=
 =?utf-8?B?WGkzWCt1dXZidTFYN3E4WW80LzZ5bUpGNDJGSGpDMStTaFZxTk80aERQQVVK?=
 =?utf-8?B?L2NKSGU3ajNWb3cxek1FaWFaMVRWWkdicDBoL0FjMUlicnlWUDZsTW9sTHdT?=
 =?utf-8?B?N1VyUStnemNwcEhvT2JLbm5HNGJUbkN5RGMvUCtjODBPNU9uWE1QRXByOVUy?=
 =?utf-8?B?SkdOemtqamFkZzJWS2pqY1JYaDBmWmJDSCtmS3JIVTFkMEMwRjZkc2hZN3pQ?=
 =?utf-8?B?Q3BueEpqeklkTld6REhHaFhTbU1qREpRLzJWS2RtR2MrRGZ0Uy9rU0RrQjVK?=
 =?utf-8?B?TU1LTElaMjdaSUFpcmZFS1lCTU53N0pWNThQSHZETkxMbHdDUG9SQUxpMUZu?=
 =?utf-8?B?cjlXWElMVWVBeFJ1amdlNG52THNMc3lhd0FlYU41enhEUyszZ1dsS1RQNzF5?=
 =?utf-8?B?Wi8vT1ltejJkNlhtSGZLVmR6NzRFd2xaMTUzVjFRMFZ6TEtQZGZBRE1JUWFB?=
 =?utf-8?B?WW80dEJIbWgxNEVrQUZQRjJvSGNFZzhIODYySXdITFZHc1J6TTZ1a055NUJr?=
 =?utf-8?B?cEl0Y09XT0pzcUJIdDJQaGpVNlVuOTV5NFZiTmR1V25JNU1qazVMT1hiMnMz?=
 =?utf-8?B?akI3ZlB0YTlTenFSKzZXRjdsSHA4K2o5ZmdDMEN5bnB2dG1LRzAwOXRqMHY0?=
 =?utf-8?B?REhxbTk1SjVYdEdyODQzOGYrdVk5WTMwdG9JVzBBc2Q2WnVzMUFLK2Fhb3J6?=
 =?utf-8?B?c1o1TitBZ0ptRTY1c2N6bEwzbzRDTmlwSWhoOWZROEp4NTY4OEZFeXV1WVZ6?=
 =?utf-8?Q?ifd/hlBC36h30Q7455ApywE=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ceb4da23-df3a-4234-05d7-08da02e85984
X-MS-Exchange-CrossTenant-AuthSource: HE1PR04MB3098.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 22:50:18.6026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xftj9tKyPO1V+nR1Kn1Rl5Gc9C1XwdhIsOfxjyqn17kQM+awyq1tQXp7yQ0Xn8odAW3M8CWZya4Cy/pZfZrZ1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR04MB3227
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/7/22 16:27, Mike Christie wrote:
> Add helpers to allow the drivers to run their recv paths from libiscsi's
> workqueue.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/libiscsi.c | 29 +++++++++++++++++++++++++++--
>   include/scsi/libiscsi.h |  4 ++++
>   2 files changed, 31 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index fa44445dc75f..fec64cbfa4b6 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -93,6 +93,16 @@ inline void iscsi_conn_queue_xmit(struct iscsi_conn *conn)
>   }
>   EXPORT_SYMBOL_GPL(iscsi_conn_queue_xmit);
>   
> +inline void iscsi_conn_queue_recv(struct iscsi_conn *conn)
> +{
> +	struct Scsi_Host *shost = conn->session->host;
> +	struct iscsi_host *ihost = shost_priv(shost);
> +
> +	if (ihost->workq && !test_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags))
> +		queue_work(ihost->workq, &conn->recvwork);
> +}
> +EXPORT_SYMBOL_GPL(iscsi_conn_queue_recv);
> +
>   static void __iscsi_update_cmdsn(struct iscsi_session *session,
>   				 uint32_t exp_cmdsn, uint32_t max_cmdsn)
>   {
> @@ -1942,7 +1952,7 @@ EXPORT_SYMBOL_GPL(iscsi_suspend_queue);
>   
>   /**
>    * iscsi_suspend_tx - suspend iscsi_data_xmit
> - * @conn: iscsi conn tp stop processing IO on.
> + * @conn: iscsi conn to stop processing IO on.
>    *
>    * This function sets the suspend bit to prevent iscsi_data_xmit
>    * from sending new IO, and if work is queued on the xmit thread
> @@ -1955,7 +1965,7 @@ void iscsi_suspend_tx(struct iscsi_conn *conn)
>   
>   	set_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
>   	if (ihost->workq)
> -		flush_workqueue(ihost->workq);
> +		flush_work(&conn->xmitwork);
>   }
>   EXPORT_SYMBOL_GPL(iscsi_suspend_tx);
>   
> @@ -1965,6 +1975,21 @@ static void iscsi_start_tx(struct iscsi_conn *conn)
>   	iscsi_conn_queue_xmit(conn);
>   }
>   
> +/**
> + * iscsi_suspend_rx - Prevent recvwork from running again.
> + * @conn: iscsi conn to stop.
> + */
> +void iscsi_suspend_rx(struct iscsi_conn *conn)
> +{
> +	struct Scsi_Host *shost = conn->session->host;
> +	struct iscsi_host *ihost = shost_priv(shost);
> +
> +	set_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags);
> +	if (ihost->workq)
> +		flush_work(&conn->recvwork);
> +}
> +EXPORT_SYMBOL_GPL(iscsi_suspend_rx);
> +
>   /*
>    * We want to make sure a ping is in flight. It has timed out.
>    * And we are not busy processing a pdu that is making
> diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
> index b567ea4700e5..522fd16f1dbb 100644
> --- a/include/scsi/libiscsi.h
> +++ b/include/scsi/libiscsi.h
> @@ -201,6 +201,8 @@ struct iscsi_conn {
>   	struct list_head	cmdqueue;	/* data-path cmd queue */
>   	struct list_head	requeue;	/* tasks needing another run */
>   	struct work_struct	xmitwork;	/* per-conn. xmit workqueue */
> +	/* recv */
> +	struct work_struct	recvwork;
>   	unsigned long		flags;		/* ISCSI_CONN_FLAGs */
>   
>   	/* negotiated params */
> @@ -440,8 +442,10 @@ extern int iscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
>   extern int iscsi_conn_get_addr_param(struct sockaddr_storage *addr,
>   				     enum iscsi_param param, char *buf);
>   extern void iscsi_suspend_tx(struct iscsi_conn *conn);
> +extern void iscsi_suspend_rx(struct iscsi_conn *conn);
>   extern void iscsi_suspend_queue(struct iscsi_conn *conn);
>   extern void iscsi_conn_queue_xmit(struct iscsi_conn *conn);
> +extern void iscsi_conn_queue_recv(struct iscsi_conn *conn);
>   
>   #define iscsi_conn_printk(prefix, _c, fmt, a...) \
>   	iscsi_cls_conn_printk(prefix, ((struct iscsi_conn *)_c)->cls_conn, \

Reviewed-by: Lee Duncan <lduncan@suse.com>

