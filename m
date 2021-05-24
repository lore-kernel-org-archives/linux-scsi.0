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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA5F3C04FF3
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 18:23:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB63D610C8
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 18:23:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233584AbhEXSYb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 14:24:31 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:50224 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232516AbhEXSYa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 May 2021 14:24:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1621880581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cDwedrxbTiAYdJ7r6chQNYp5YKEysW0R4Qf/fNBPHkU=;
        b=MfEOyn1i25CPvix+Q+6qMOOFjUS3PV+JcMGcekbooI34Pju7KddAaXcbJycAFkHThhP2wF
        ntFtEVBUt9vtN1SuvRBpAZGRuGGShyv6AbchM5/pLwmshNvKh31lT8m1TvPEx4NJT3Ijj+
        6m7KaLWZWbf681nRrIEyXRIaB2i7tzs=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2056.outbound.protection.outlook.com [104.47.13.56]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-9-8qbMjTqDOZKK2AhTJcJgMw-2;
 Mon, 24 May 2021 20:23:00 +0200
X-MC-Unique: 8qbMjTqDOZKK2AhTJcJgMw-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a06YA71d5T2y5B49D+dJ2X4yi9u7sckYJTpfiHikjTECpEt1gz8+2zKNXF8EoxfReN6FxnAdjKVz7fb5SMFLT3gWFyMJB16lCviyU3INfSYHjrhrs3W0AfhqHSZqL3Tp61IPKzSernRB4+P2sJMT+2YnIjasaw2LSLxgs2uGp0R3p6sn99N8dB2j3LKPIDZrSmk0cRKay2W8X+T1gT8pIK+cRn/E+F/Z2sMp47INx2GUBmEjFsHoK6r3Nvo5vw6ukJ757CoBHFpQdo5dXYbjYQ3L2GOdidhObA36BEw+g8ZqEXK8mmdJBNznW2rWLOWXJTOeQHqXI5lse6b1xD2wZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cDwedrxbTiAYdJ7r6chQNYp5YKEysW0R4Qf/fNBPHkU=;
 b=Ybv11ns+9fNsYrGT8NAWqBM66DFFFBKEQiUhmPAzwMZlCx3Y2dfp8/O2/6zrykq1RGzgE1Jnrd4MOppqfPjY4Igu6mbCDXFlkdsrr4D6fXLkxulm3VaPdUvcP8lOyxOcMN6wvATH1iDmk/kbfw8MqYxz6PGF8cTRnSXzeSiOuwphK35Gm5vGHjsuMYzGoXi/YtyJzTIQNA/Se8jxeHuJIE3lPMAHEBx7U529/Gt/KTHZVU6bN1wIBdyd9/aXNvzP9VxF/oTY9QgKt7DOpEQpQOksJKmqaUGLiQoZNPurcd05aL1aAluW660MyUzwERJEwtWFyaM48PJivtdLvDPQGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB4582.eurprd04.prod.outlook.com (2603:10a6:20b:1d::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Mon, 24 May
 2021 18:22:57 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d1a5:8072:c01f:3cf1]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d1a5:8072:c01f:3cf1%3]) with mapi id 15.20.4150.027; Mon, 24 May 2021
 18:22:57 +0000
Subject: Re: [PATCH 07/28] scsi: iscsi: Fix in-kernel conn failure handling
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
References: <20210523175739.360324-1-michael.christie@oracle.com>
 <20210523175739.360324-8-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <ca35c4c7-004e-9514-9533-260acaa9108f@suse.com>
Date:   Mon, 24 May 2021 11:22:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <20210523175739.360324-8-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: FR0P281CA0050.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::13) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by FR0P281CA0050.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:48::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.11 via Frontend Transport; Mon, 24 May 2021 18:22:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d3155c6-842d-4ef0-bffd-08d91ee0f483
X-MS-TrafficTypeDiagnostic: AM6PR04MB4582:
X-Microsoft-Antispam-PRVS: <AM6PR04MB4582A4B5B39D3789EF4E4D02DA269@AM6PR04MB4582.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ngN8L88IrudEcQOie84WMiqgDnWsPAgQQvDJS/KQwWNBxb3mGFLbugOA2Mlxyy88oQzVcXOz7DagqU7en7/oMMwgSs7kxFvg8STWfDVJQO9ra8fJW0TDEi6CYw19FKQWN4yybm+LO0Gj3dJhwA3ttY8qSLsGGEcXVhX6kKy8txtwNhmNWyI+TZmBJndDhlQoapCn3yOdr+IX7PF7jWRWjxP1ylwxXHgRMsDfda9ti/RMZyfacu8q9z8qCW1QNacXLhxtRx4/Ebf1cshEf2+l9dGk7if5fbcbpQ5e81gZNy6LS+uuqo49PiehnFiRLovkkPk9PvRvJx7FiolJEIlrdhRKzUitwErF88epP6KVZS/NibM5WmVp9oFYch7OinsAF+7fLTCK580sOmVtwf19E0GPaUUxDaTFze6mBpMsjS4EDTibwNsc4uIAXsDjdctD4cXUlEpRZ7bViV4SQ+5R45xIxagQoyE5Co8PqrV7GbPXnqF9aHjRxZsDEGSn4JmSFNXTCkWfnPlg5l81yBbUnZxaaYI5ogsiS9xwVDIiX2hLZGw04iVdSa7WzIYoovBnDjJeRVvXH1XCrqjl/fYDSQShYFTe+Bwa4hG/ysP7b83YLj8ckXnzcvJU+OIptlXpuIXXG4Sy0+IC4uOnnrZ/aRkG2LCkEhJDd2RA81zMqEeoj7pt2dRp+Ga9h+I7MU96
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(366004)(376002)(396003)(346002)(83380400001)(478600001)(316002)(8676002)(8936002)(16576012)(31686004)(186003)(66946007)(26005)(2616005)(36756003)(38100700002)(16526019)(956004)(31696002)(30864003)(86362001)(5660300002)(2906002)(6486002)(66476007)(53546011)(6666004)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NG5XaXZyTzVhZjBFVFIvazYxZFVQamJRSlgrVndHNGMzSksxNWxEWFlCa2xU?=
 =?utf-8?B?RDZyVDRpVklCYVZpNDJqOVZ5YS8zU2w0UWNyMkRDODVPcnBQY1JHSnFBUjVV?=
 =?utf-8?B?TWR3ZHN5VjBqN29jdFVGMVJMQXRaT2VucU9JUlJGSkhYVkd3OWtTaWRrelg2?=
 =?utf-8?B?L0lwdzR0SGlXYTNFSDE2dlVIZUtWdVhpdnkrRmwzS0cxSER1MDFLL1kyNGlh?=
 =?utf-8?B?dmF0L1lwZHcxNTBSUzJMK0sxdHl6MTRocElaVVQ2UEQ0RWV5dmhxYmJVSEhv?=
 =?utf-8?B?WlZMWTl0VVdMNXdtc21hemZwdXRvcTlwd3BGU01hSENTQXhxTmcrMGF3c1c3?=
 =?utf-8?B?akx1di84Z1daMThxRjh1VksxNkZNdkt6bWRFM25lZUQwSUdoL1hLQTVlUGZ3?=
 =?utf-8?B?VVI1c1M4ZWI1ZFRuWnJwc1JvZVlzUHNQbTYrWXQwQlRGUDZEaHhocTlwQ0k1?=
 =?utf-8?B?bEhMNUo1UzhwKytLSCtBSXRqS1NFSjk1bmlrUG82ZlJLd0RnNFNWakg2TEMy?=
 =?utf-8?B?UnlNRnZmY2NBVFlTNmdHYm9POE51clVwOU5rMjFjVHpxdllnTGRmQmxKd1ox?=
 =?utf-8?B?VVp4cDNOcnl3NzVhY015dWF0VDdrVTFST0h6eDhER1pQMDBLWXg2Y1V2ckhj?=
 =?utf-8?B?ZjB2amFZd0hkK3JZNFRrVmlzWGtDZXdLQk1HSTVhb1JqdXdFbXlhNis3dG9u?=
 =?utf-8?B?NUtzQ3VKNGt2RGE1NGVRRVBzTTF1WjU5OXlab3IrMktBeG53Y2hjNW80dDdB?=
 =?utf-8?B?U0NwR09XOE9EMFlHZXh6YjdsRVdtdFIycDNXdmhuSk1FNDZxN3FxUmdTTlp3?=
 =?utf-8?B?dmYvOE5JancrR3ZnR3lERS9DMlFiUXpLdzFFUFJhVXdJT2pITXFkOU1oTHox?=
 =?utf-8?B?SlZwMk5CRWo5MjhhdFhLc0lRZEpXemlycUp2cHV2SElvNFZ1MndNZ3hUd2NU?=
 =?utf-8?B?UXFVZmpJUk1SM0NOZ213RVdXOXVUQ3FFTUduNWZMcjF5UFAwQ0F3ZVpodWdn?=
 =?utf-8?B?d25qdGs0U3ZLRkZlbUdUZzlwaHdDOWYyTWFneW55S1lkdjIxcldHVzliWFh3?=
 =?utf-8?B?MEdieGoyTDkzMFBXWWtQeEphQjMyQWR4aWQrakZydzdJSGpYZWpEaEp6OEZN?=
 =?utf-8?B?ZnVSaUlLZmZ3OW5XTGcvRjhJb1V0ZjhqMWhIWFY2SmFzY24zam96YzVpL0dR?=
 =?utf-8?B?NkpFUEQrQVhPMFpGMThrY1Vrekk4cTJIRkhHUDhjNTNrZGo5dDZ5VjhPV3hh?=
 =?utf-8?B?ODI0Zk00VlF2NWFNNlJCTUp0d0M1ZDMvZmo2M3NOK3h1cGV2UjRIZ3ptK2wv?=
 =?utf-8?B?bm5YdVZVQkFyZGc2UTZCSXVtTVRDUmRHcWZPS29hTC91SENKRGFhSGlvSzF0?=
 =?utf-8?B?OEF2TnNhbkxRQmd4RUVpN2t5MDFNWFZZeGtZZHJUN0Rjc3Vxd2FLUzNjZXNV?=
 =?utf-8?B?NzRHMVFnaDBUYXMyUzIvelRwSkVQL1d5dElsWk9yV0ZySEJNNVNkOFJxOFBp?=
 =?utf-8?B?WTdMODkxalMzUnlRc09xQ3VKOG94TW9WaEUzUzErQkR5U2dEYTBIckZmYUZ1?=
 =?utf-8?B?TzQxc05Bdk9vTE8xT0xNeDNKU2xqMmRnT0dYSVI5anJtOXNIaGMyUm9QNnoz?=
 =?utf-8?B?NnlQV001VEt4R2RodWVFUWVkZE1LZU9BM2o5Qjg4dTRqRStmby9UbnpBbXV3?=
 =?utf-8?B?N0UyODNuSDkrelRCRGhqQWIxQlUzVW9qVFliRlhKWkFqWmpWcGNiWFF6YjdT?=
 =?utf-8?Q?KIhyWjkFVQeG4a18RBqEuwCKrH2guKX/sJFzwlY?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d3155c6-842d-4ef0-bffd-08d91ee0f483
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2021 18:22:57.6396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3gbjQszG70jvYyZKOMgW/24w1AADW27XcBiCj8fdPKMj5cR5eZDUBGSGk+kck9nfAQwMTfbShTfk9pQPT4yJsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4582
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/23/21 10:57 AM, Mike Christie wrote:
> The commit 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely
> in kernel space") has the following regressions/bugs that this patch fixes:
> 
> 1. It can return cmds to upper layers like dm-multipath where that can
> retry them. After they are successful the fs/app can send new IO to the
> same sectors, but we've left the cmds running in FW or in the net layer.
> We need to be calling ep_disconnect if userspace is not up.
> 
> This patch only fixes the issue for offload drivers. iscsi_tcp will be
> fixed in separate patch because it doesn't have a ep_disconnect call.
> 
> 2. The drivers that implement ep_disconnect expect that it's called before
> conn_stop. Besides crashes, if the cleanup_task callout is called before
> ep_disconnect it might free up driver/card resources for session1 then
> they could be allocated for session2. But because the driver's
> ep_disconnect is not called it has not cleaned up the firmware so the card
> is still using the resources for the original cmd.
> 
> 3. The stop_conn_work_fn can run after userspace has done it's recovery
> and we are happily using the session. We will then end up with various
> bugs depending on what is going on at the time.
> 
> We may also run stop_conn_work_fn late after userspace has called
> stop_conn and ep_disconnect and is now going to call start/bind conn. If
> stop_conn_work_fn runs after bind but before start, we would leave the
> conn in a unbound but sort of started state where IO might be allowed
> even though the drivers have been set in a state where they no longer
> expect IO.
> 
> 4. returning -EAGAIN in iscsi_if_destroy_conn if we haven't yet run the in
> kernel stop_conn function is breaking userspace. We should have been doing
> this for the caller.
> 
> Fixes: 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely in
> kernel space")
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 471 ++++++++++++++++------------
>  include/scsi/scsi_transport_iscsi.h |  10 +-
>  2 files changed, 283 insertions(+), 198 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index bab6654d8ee9..b8a93e607891 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -86,15 +86,11 @@ struct iscsi_internal {
>  	struct transport_container session_cont;
>  };
>  
> -/* Worker to perform connection failure on unresponsive connections
> - * completely in kernel space.
> - */
> -static void stop_conn_work_fn(struct work_struct *work);
> -static DECLARE_WORK(stop_conn_work, stop_conn_work_fn);
> -
>  static atomic_t iscsi_session_nr; /* sysfs session id for next new session */
>  static struct workqueue_struct *iscsi_eh_timer_workq;
>  
> +static struct workqueue_struct *iscsi_conn_cleanup_workq;
> +
>  static DEFINE_IDA(iscsi_sess_ida);
>  /*
>   * list of registered transports and lock that must
> @@ -1623,12 +1619,6 @@ static DECLARE_TRANSPORT_CLASS(iscsi_connection_class,
>  static struct sock *nls;
>  static DEFINE_MUTEX(rx_queue_mutex);
>  
> -/*
> - * conn_mutex protects the {start,bind,stop,destroy}_conn from racing
> - * against the kernel stop_connection recovery mechanism
> - */
> -static DEFINE_MUTEX(conn_mutex);
> -
>  static LIST_HEAD(sesslist);
>  static DEFINE_SPINLOCK(sesslock);
>  static LIST_HEAD(connlist);
> @@ -2245,6 +2235,123 @@ void iscsi_remove_session(struct iscsi_cls_session *session)
>  }
>  EXPORT_SYMBOL_GPL(iscsi_remove_session);
>  
> +static void iscsi_stop_conn(struct iscsi_cls_conn *conn, int flag)
> +{
> +	ISCSI_DBG_TRANS_CONN(conn, "Stopping conn.\n");
> +
> +	switch (flag) {
> +	case STOP_CONN_RECOVER:
> +		conn->state = ISCSI_CONN_FAILED;
> +		break;
> +	case STOP_CONN_TERM:
> +		conn->state = ISCSI_CONN_DOWN;
> +		break;
> +	default:
> +		iscsi_cls_conn_printk(KERN_ERR, conn, "invalid stop flag %d\n",
> +				      flag);
> +		return;
> +	}
> +
> +	conn->transport->stop_conn(conn, flag);
> +	ISCSI_DBG_TRANS_CONN(conn, "Stopping conn done.\n");
> +}
> +
> +static int iscsi_if_stop_conn(struct iscsi_transport *transport,
> +			      struct iscsi_uevent *ev)
> +{
> +	int flag = ev->u.stop_conn.flag;
> +	struct iscsi_cls_conn *conn;
> +
> +	conn = iscsi_conn_lookup(ev->u.stop_conn.sid, ev->u.stop_conn.cid);
> +	if (!conn)
> +		return -EINVAL;
> +
> +	ISCSI_DBG_TRANS_CONN(conn, "iscsi if conn stop.\n");
> +	/*
> +	 * If this is a termination we have to call stop_conn with that flag
> +	 * so the correct states get set. If we haven't run the work yet try to
> +	 * avoid the extra run.
> +	 */
> +	if (flag == STOP_CONN_TERM) {
> +		cancel_work_sync(&conn->cleanup_work);
> +		iscsi_stop_conn(conn, flag);
> +	} else {
> +		/*
> +		 * Figure out if it was the kernel or userspace initiating this.
> +		 */
> +		if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
> +			iscsi_stop_conn(conn, flag);
> +		} else {
> +			ISCSI_DBG_TRANS_CONN(conn,
> +					     "flush kernel conn cleanup.\n");
> +			flush_work(&conn->cleanup_work);
> +		}
> +		/*
> +		 * Only clear for recovery to avoid extra cleanup runs during
> +		 * termination.
> +		 */
> +		clear_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags);
> +	}
> +	ISCSI_DBG_TRANS_CONN(conn, "iscsi if conn stop done.\n");
> +	return 0;
> +}
> +
> +static void iscsi_ep_disconnect(struct iscsi_cls_conn *conn, bool is_active)
> +{
> +	struct iscsi_cls_session *session = iscsi_conn_to_session(conn);
> +	struct iscsi_endpoint *ep;
> +
> +	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep.\n");
> +	conn->state = ISCSI_CONN_FAILED;
> +
> +	if (!conn->ep || !session->transport->ep_disconnect)
> +		return;
> +
> +	ep = conn->ep;
> +	conn->ep = NULL;
> +
> +	session->transport->unbind_conn(conn, is_active);
> +	session->transport->ep_disconnect(ep);
> +	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep done.\n");
> +}
> +
> +static void iscsi_cleanup_conn_work_fn(struct work_struct *work)
> +{
> +	struct iscsi_cls_conn *conn = container_of(work, struct iscsi_cls_conn,
> +						   cleanup_work);
> +	struct iscsi_cls_session *session = iscsi_conn_to_session(conn);
> +
> +	mutex_lock(&conn->ep_mutex);
> +	/*
> +	 * If we are not at least bound there is nothing for us to do. Userspace
> +	 * will do a ep_disconnect call if offload is used, but will not be
> +	 * doing a stop since there is nothing to clean up, so we have to clear
> +	 * the cleanup bit here.
> +	 */
> +	if (conn->state != ISCSI_CONN_BOUND && conn->state != ISCSI_CONN_UP) {
> +		ISCSI_DBG_TRANS_CONN(conn, "Got error while conn is already failed. Ignoring.\n");
> +		clear_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags);
> +		mutex_unlock(&conn->ep_mutex);
> +		return;
> +	}
> +
> +	iscsi_ep_disconnect(conn, false);
> +
> +	if (system_state != SYSTEM_RUNNING) {
> +		/*
> +		 * If the user has set up for the session to never timeout
> +		 * then hang like they wanted. For all other cases fail right
> +		 * away since userspace is not going to relogin.
> +		 */
> +		if (session->recovery_tmo > 0)
> +			session->recovery_tmo = 0;
> +	}
> +
> +	iscsi_stop_conn(conn, STOP_CONN_RECOVER);
> +	mutex_unlock(&conn->ep_mutex);
> +	ISCSI_DBG_TRANS_CONN(conn, "cleanup done.\n");
> +}
> +
>  void iscsi_free_session(struct iscsi_cls_session *session)
>  {
>  	ISCSI_DBG_TRANS_SESSION(session, "Freeing session\n");
> @@ -2284,7 +2391,7 @@ iscsi_create_conn(struct iscsi_cls_session *session, int dd_size, uint32_t cid)
>  
>  	mutex_init(&conn->ep_mutex);
>  	INIT_LIST_HEAD(&conn->conn_list);
> -	INIT_LIST_HEAD(&conn->conn_list_err);
> +	INIT_WORK(&conn->cleanup_work, iscsi_cleanup_conn_work_fn);
>  	conn->transport = transport;
>  	conn->cid = cid;
>  	conn->state = ISCSI_CONN_DOWN;
> @@ -2341,7 +2448,6 @@ int iscsi_destroy_conn(struct iscsi_cls_conn *conn)
>  
>  	spin_lock_irqsave(&connlock, flags);
>  	list_del(&conn->conn_list);
> -	list_del(&conn->conn_list_err);
>  	spin_unlock_irqrestore(&connlock, flags);
>  
>  	transport_unregister_device(&conn->dev);
> @@ -2456,83 +2562,6 @@ int iscsi_offload_mesg(struct Scsi_Host *shost,
>  }
>  EXPORT_SYMBOL_GPL(iscsi_offload_mesg);
>  
> -/*
> - * This can be called without the rx_queue_mutex, if invoked by the kernel
> - * stop work. But, in that case, it is guaranteed not to race with
> - * iscsi_destroy by conn_mutex.
> - */
> -static void iscsi_if_stop_conn(struct iscsi_cls_conn *conn, int flag)
> -{
> -	/*
> -	 * It is important that this path doesn't rely on
> -	 * rx_queue_mutex, otherwise, a thread doing allocation on a
> -	 * start_session/start_connection could sleep waiting on a
> -	 * writeback to a failed iscsi device, that cannot be recovered
> -	 * because the lock is held.  If we don't hold it here, the
> -	 * kernel stop_conn_work_fn has a chance to stop the broken
> -	 * session and resolve the allocation.
> -	 *
> -	 * Still, the user invoked .stop_conn() needs to be serialized
> -	 * with stop_conn_work_fn by a private mutex.  Not pretty, but
> -	 * it works.
> -	 */
> -	mutex_lock(&conn_mutex);
> -	switch (flag) {
> -	case STOP_CONN_RECOVER:
> -		conn->state = ISCSI_CONN_FAILED;
> -		break;
> -	case STOP_CONN_TERM:
> -		conn->state = ISCSI_CONN_DOWN;
> -		break;
> -	default:
> -		iscsi_cls_conn_printk(KERN_ERR, conn,
> -				      "invalid stop flag %d\n", flag);
> -		goto unlock;
> -	}
> -
> -	conn->transport->stop_conn(conn, flag);
> -unlock:
> -	mutex_unlock(&conn_mutex);
> -}
> -
> -static void stop_conn_work_fn(struct work_struct *work)
> -{
> -	struct iscsi_cls_conn *conn, *tmp;
> -	unsigned long flags;
> -	LIST_HEAD(recovery_list);
> -
> -	spin_lock_irqsave(&connlock, flags);
> -	if (list_empty(&connlist_err)) {
> -		spin_unlock_irqrestore(&connlock, flags);
> -		return;
> -	}
> -	list_splice_init(&connlist_err, &recovery_list);
> -	spin_unlock_irqrestore(&connlock, flags);
> -
> -	list_for_each_entry_safe(conn, tmp, &recovery_list, conn_list_err) {
> -		uint32_t sid = iscsi_conn_get_sid(conn);
> -		struct iscsi_cls_session *session;
> -
> -		session = iscsi_session_lookup(sid);
> -		if (session) {
> -			if (system_state != SYSTEM_RUNNING) {
> -				/*
> -				 * If the user has set up for the session to
> -				 * never timeout then hang like they wanted.
> -				 * For all other cases fail right away since
> -				 * userspace is not going to relogin.
> -				 */
> -				if (session->recovery_tmo > 0)
> -					session->recovery_tmo = 0;
> -			}
> -
> -			iscsi_if_stop_conn(conn, STOP_CONN_RECOVER);
> -		}
> -
> -		list_del_init(&conn->conn_list_err);
> -	}
> -}
> -
>  void iscsi_conn_error_event(struct iscsi_cls_conn *conn, enum iscsi_err error)
>  {
>  	struct nlmsghdr	*nlh;
> @@ -2540,12 +2569,9 @@ void iscsi_conn_error_event(struct iscsi_cls_conn *conn, enum iscsi_err error)
>  	struct iscsi_uevent *ev;
>  	struct iscsi_internal *priv;
>  	int len = nlmsg_total_size(sizeof(*ev));
> -	unsigned long flags;
>  
> -	spin_lock_irqsave(&connlock, flags);
> -	list_add(&conn->conn_list_err, &connlist_err);
> -	spin_unlock_irqrestore(&connlock, flags);
> -	queue_work(system_unbound_wq, &stop_conn_work);
> +	if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags))
> +		queue_work(iscsi_conn_cleanup_workq, &conn->cleanup_work);
>  
>  	priv = iscsi_if_transport_lookup(conn->transport);
>  	if (!priv)
> @@ -2875,26 +2901,17 @@ static int
>  iscsi_if_destroy_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev)
>  {
>  	struct iscsi_cls_conn *conn;
> -	unsigned long flags;
>  
>  	conn = iscsi_conn_lookup(ev->u.d_conn.sid, ev->u.d_conn.cid);
>  	if (!conn)
>  		return -EINVAL;
>  
> -	spin_lock_irqsave(&connlock, flags);
> -	if (!list_empty(&conn->conn_list_err)) {
> -		spin_unlock_irqrestore(&connlock, flags);
> -		return -EAGAIN;
> -	}
> -	spin_unlock_irqrestore(&connlock, flags);
> -
> +	ISCSI_DBG_TRANS_CONN(conn, "Flushing cleanup during destruction\n");
> +	flush_work(&conn->cleanup_work);
>  	ISCSI_DBG_TRANS_CONN(conn, "Destroying transport conn\n");
>  
> -	mutex_lock(&conn_mutex);
>  	if (transport->destroy_conn)
>  		transport->destroy_conn(conn);
> -	mutex_unlock(&conn_mutex);
> -
>  	return 0;
>  }
>  
> @@ -2973,7 +2990,7 @@ static int iscsi_if_ep_connect(struct iscsi_transport *transport,
>  }
>  
>  static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
> -				  u64 ep_handle, bool is_active)
> +				  u64 ep_handle)
>  {
>  	struct iscsi_cls_conn *conn;
>  	struct iscsi_endpoint *ep;
> @@ -2984,17 +3001,30 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
>  	ep = iscsi_lookup_endpoint(ep_handle);
>  	if (!ep)
>  		return -EINVAL;
> +
>  	conn = ep->conn;
> -	if (conn) {
> -		mutex_lock(&conn->ep_mutex);
> -		conn->ep = NULL;
> +	if (!conn) {
> +		/*
> +		 * conn was not even bound yet, so we can't get iscsi conn
> +		 * failures yet.
> +		 */
> +		transport->ep_disconnect(ep);
> +		goto put_ep;
> +	}
> +
> +	mutex_lock(&conn->ep_mutex);
> +	/* Check if this was a conn error and the kernel took ownership */
> +	if (test_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
> +		ISCSI_DBG_TRANS_CONN(conn, "flush kernel conn cleanup.\n");
>  		mutex_unlock(&conn->ep_mutex);
> -		conn->state = ISCSI_CONN_FAILED;
>  
> -		transport->unbind_conn(conn, is_active);
> +		flush_work(&conn->cleanup_work);
> +		goto put_ep;
>  	}
>  
> -	transport->ep_disconnect(ep);
> +	iscsi_ep_disconnect(conn, false);
> +	mutex_unlock(&conn->ep_mutex);
> +put_ep:
>  	iscsi_put_endpoint(ep);
>  	return 0;
>  }
> @@ -3025,8 +3055,7 @@ iscsi_if_transport_ep(struct iscsi_transport *transport,
>  		break;
>  	case ISCSI_UEVENT_TRANSPORT_EP_DISCONNECT:
>  		rc = iscsi_if_ep_disconnect(transport,
> -					    ev->u.ep_disconnect.ep_handle,
> -					    false);
> +					    ev->u.ep_disconnect.ep_handle);
>  		break;
>  	}
>  	return rc;
> @@ -3653,18 +3682,129 @@ iscsi_get_host_stats(struct iscsi_transport *transport, struct nlmsghdr *nlh)
>  	return err;
>  }
>  
> +static int iscsi_if_transport_conn(struct iscsi_transport *transport,
> +				   struct nlmsghdr *nlh)
> +{
> +	struct iscsi_uevent *ev = nlmsg_data(nlh);
> +	struct iscsi_cls_session *session;
> +	struct iscsi_cls_conn *conn = NULL;
> +	struct iscsi_endpoint *ep;
> +	uint32_t pdu_len;
> +	int err = 0;
> +
> +	switch (nlh->nlmsg_type) {
> +	case ISCSI_UEVENT_CREATE_CONN:
> +		return iscsi_if_create_conn(transport, ev);
> +	case ISCSI_UEVENT_DESTROY_CONN:
> +		return iscsi_if_destroy_conn(transport, ev);
> +	case ISCSI_UEVENT_STOP_CONN:
> +		return iscsi_if_stop_conn(transport, ev);
> +	}
> +
> +	/*
> +	 * The following cmds need to be run under the ep_mutex so in kernel
> +	 * conn cleanup (ep_disconnect + unbind and conn) is not done while
> +	 * these are running. They also must not run if we have just run a conn
> +	 * cleanup because they would set the state in a way that might allow
> +	 * IO or send IO themselves.
> +	 */
> +	switch (nlh->nlmsg_type) {
> +	case ISCSI_UEVENT_START_CONN:
> +		conn = iscsi_conn_lookup(ev->u.start_conn.sid,
> +					 ev->u.start_conn.cid);
> +		break;
> +	case ISCSI_UEVENT_BIND_CONN:
> +		conn = iscsi_conn_lookup(ev->u.b_conn.sid, ev->u.b_conn.cid);
> +		break;
> +	case ISCSI_UEVENT_SEND_PDU:
> +		conn = iscsi_conn_lookup(ev->u.send_pdu.sid, ev->u.send_pdu.cid);
> +		break;
> +	}
> +
> +	if (!conn)
> +		return -EINVAL;
> +
> +	mutex_lock(&conn->ep_mutex);
> +	if (test_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
> +		mutex_unlock(&conn->ep_mutex);
> +		ev->r.retcode = -ENOTCONN;
> +		return 0;
> +	}
> +
> +	switch (nlh->nlmsg_type) {
> +	case ISCSI_UEVENT_BIND_CONN:
> +		if (conn->ep) {
> +			/*
> +			 * For offload boot support where iscsid is restarted
> +			 * during the pivot root stage, the ep will be intact
> +			 * here when the new iscsid instance starts up and
> +			 * reconnects.
> +			 */
> +			iscsi_ep_disconnect(conn, true);
> +		}
> +
> +		session = iscsi_session_lookup(ev->u.b_conn.sid);
> +		if (!session) {
> +			err = -EINVAL;
> +			break;
> +		}
> +
> +		ev->r.retcode =	transport->bind_conn(session, conn,
> +						ev->u.b_conn.transport_eph,
> +						ev->u.b_conn.is_leading);
> +		if (!ev->r.retcode)
> +			conn->state = ISCSI_CONN_BOUND;
> +
> +		if (ev->r.retcode || !transport->ep_connect)
> +			break;
> +
> +		ep = iscsi_lookup_endpoint(ev->u.b_conn.transport_eph);
> +		if (ep) {
> +			ep->conn = conn;
> +			conn->ep = ep;
> +			iscsi_put_endpoint(ep);
> +		} else {
> +			err = -ENOTCONN;
> +			iscsi_cls_conn_printk(KERN_ERR, conn,
> +					      "Could not set ep conn binding\n");
> +		}
> +		break;
> +	case ISCSI_UEVENT_START_CONN:
> +		ev->r.retcode = transport->start_conn(conn);
> +		if (!ev->r.retcode)
> +			conn->state = ISCSI_CONN_UP;
> +		break;
> +	case ISCSI_UEVENT_SEND_PDU:
> +		pdu_len = nlh->nlmsg_len - sizeof(*nlh) - sizeof(*ev);
> +
> +		if ((ev->u.send_pdu.hdr_size > pdu_len) ||
> +		    (ev->u.send_pdu.data_size > (pdu_len - ev->u.send_pdu.hdr_size))) {
> +			err = -EINVAL;
> +			break;
> +		}
> +
> +		ev->r.retcode =	transport->send_pdu(conn,
> +				(struct iscsi_hdr *)((char *)ev + sizeof(*ev)),
> +				(char *)ev + sizeof(*ev) + ev->u.send_pdu.hdr_size,
> +				ev->u.send_pdu.data_size);
> +		break;
> +	default:
> +		err = -ENOSYS;
> +	}
> +
> +	mutex_unlock(&conn->ep_mutex);
> +	return err;
> +}
>  
>  static int
>  iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
>  {
>  	int err = 0;
>  	u32 portid;
> -	u32 pdu_len;
>  	struct iscsi_uevent *ev = nlmsg_data(nlh);
>  	struct iscsi_transport *transport = NULL;
>  	struct iscsi_internal *priv;
>  	struct iscsi_cls_session *session;
> -	struct iscsi_cls_conn *conn;
>  	struct iscsi_endpoint *ep = NULL;
>  
>  	if (!netlink_capable(skb, CAP_SYS_ADMIN))
> @@ -3741,90 +3881,16 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
>  		else
>  			err = -EINVAL;
>  		break;
> -	case ISCSI_UEVENT_CREATE_CONN:
> -		err = iscsi_if_create_conn(transport, ev);
> -		break;
> -	case ISCSI_UEVENT_DESTROY_CONN:
> -		err = iscsi_if_destroy_conn(transport, ev);
> -		break;
> -	case ISCSI_UEVENT_BIND_CONN:
> -		session = iscsi_session_lookup(ev->u.b_conn.sid);
> -		conn = iscsi_conn_lookup(ev->u.b_conn.sid, ev->u.b_conn.cid);
> -
> -		if (conn && conn->ep)
> -			iscsi_if_ep_disconnect(transport, conn->ep->id, true);
> -
> -		if (!session || !conn) {
> -			err = -EINVAL;
> -			break;
> -		}
> -
> -		mutex_lock(&conn_mutex);
> -		ev->r.retcode =	transport->bind_conn(session, conn,
> -						ev->u.b_conn.transport_eph,
> -						ev->u.b_conn.is_leading);
> -		if (!ev->r.retcode)
> -			conn->state = ISCSI_CONN_BOUND;
> -		mutex_unlock(&conn_mutex);
> -
> -		if (ev->r.retcode || !transport->ep_connect)
> -			break;
> -
> -		ep = iscsi_lookup_endpoint(ev->u.b_conn.transport_eph);
> -		if (ep) {
> -			ep->conn = conn;
> -
> -			mutex_lock(&conn->ep_mutex);
> -			conn->ep = ep;
> -			mutex_unlock(&conn->ep_mutex);
> -			iscsi_put_endpoint(ep);
> -		} else
> -			iscsi_cls_conn_printk(KERN_ERR, conn,
> -					      "Could not set ep conn "
> -					      "binding\n");
> -		break;
>  	case ISCSI_UEVENT_SET_PARAM:
>  		err = iscsi_set_param(transport, ev);
>  		break;
> -	case ISCSI_UEVENT_START_CONN:
> -		conn = iscsi_conn_lookup(ev->u.start_conn.sid, ev->u.start_conn.cid);
> -		if (conn) {
> -			mutex_lock(&conn_mutex);
> -			ev->r.retcode = transport->start_conn(conn);
> -			if (!ev->r.retcode)
> -				conn->state = ISCSI_CONN_UP;
> -			mutex_unlock(&conn_mutex);
> -		}
> -		else
> -			err = -EINVAL;
> -		break;
> +	case ISCSI_UEVENT_CREATE_CONN:
> +	case ISCSI_UEVENT_DESTROY_CONN:
>  	case ISCSI_UEVENT_STOP_CONN:
> -		conn = iscsi_conn_lookup(ev->u.stop_conn.sid, ev->u.stop_conn.cid);
> -		if (conn)
> -			iscsi_if_stop_conn(conn, ev->u.stop_conn.flag);
> -		else
> -			err = -EINVAL;
> -		break;
> +	case ISCSI_UEVENT_START_CONN:
> +	case ISCSI_UEVENT_BIND_CONN:
>  	case ISCSI_UEVENT_SEND_PDU:
> -		pdu_len = nlh->nlmsg_len - sizeof(*nlh) - sizeof(*ev);
> -
> -		if ((ev->u.send_pdu.hdr_size > pdu_len) ||
> -		    (ev->u.send_pdu.data_size > (pdu_len - ev->u.send_pdu.hdr_size))) {
> -			err = -EINVAL;
> -			break;
> -		}
> -
> -		conn = iscsi_conn_lookup(ev->u.send_pdu.sid, ev->u.send_pdu.cid);
> -		if (conn) {
> -			mutex_lock(&conn_mutex);
> -			ev->r.retcode =	transport->send_pdu(conn,
> -				(struct iscsi_hdr*)((char*)ev + sizeof(*ev)),
> -				(char*)ev + sizeof(*ev) + ev->u.send_pdu.hdr_size,
> -				ev->u.send_pdu.data_size);
> -			mutex_unlock(&conn_mutex);
> -		}
> -		else
> -			err = -EINVAL;
> +		err = iscsi_if_transport_conn(transport, nlh);
>  		break;
>  	case ISCSI_UEVENT_GET_STATS:
>  		err = iscsi_if_get_stats(transport, nlh);
> @@ -4827,8 +4893,18 @@ static __init int iscsi_transport_init(void)
>  		goto release_nls;
>  	}
>  
> +	iscsi_conn_cleanup_workq = alloc_workqueue("%s",
> +			WQ_SYSFS | WQ_MEM_RECLAIM | WQ_UNBOUND, 0,
> +			"iscsi_conn_cleanup");
> +	if (!iscsi_conn_cleanup_workq) {
> +		err = -ENOMEM;
> +		goto destroy_wq;
> +	}
> +
>  	return 0;
>  
> +destroy_wq:
> +	destroy_workqueue(iscsi_eh_timer_workq);
>  release_nls:
>  	netlink_kernel_release(nls);
>  unregister_flashnode_bus:
> @@ -4850,6 +4926,7 @@ static __init int iscsi_transport_init(void)
>  
>  static void __exit iscsi_transport_exit(void)
>  {
> +	destroy_workqueue(iscsi_conn_cleanup_workq);
>  	destroy_workqueue(iscsi_eh_timer_workq);
>  	netlink_kernel_release(nls);
>  	bus_unregister(&iscsi_flashnode_bus);
> diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
> index d36a72cf049f..3974329d4d02 100644
> --- a/include/scsi/scsi_transport_iscsi.h
> +++ b/include/scsi/scsi_transport_iscsi.h
> @@ -197,15 +197,23 @@ enum iscsi_connection_state {
>  	ISCSI_CONN_BOUND,
>  };
>  
> +#define ISCSI_CLS_CONN_BIT_CLEANUP	1
> +
>  struct iscsi_cls_conn {
>  	struct list_head conn_list;	/* item in connlist */
> -	struct list_head conn_list_err;	/* item in connlist_err */
>  	void *dd_data;			/* LLD private data */
>  	struct iscsi_transport *transport;
>  	uint32_t cid;			/* connection id */
> +	/*
> +	 * This protects the conn startup and binding/unbinding of the ep to
> +	 * the conn. Unbinding includes ep_disconnect and stop_conn.
> +	 */
>  	struct mutex ep_mutex;
>  	struct iscsi_endpoint *ep;
>  
> +	unsigned long flags;
> +	struct work_struct cleanup_work;
> +
>  	struct device dev;		/* sysfs transport/container device */
>  	enum iscsi_connection_state state;
>  };
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

