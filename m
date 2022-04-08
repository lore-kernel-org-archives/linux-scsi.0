Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52BDDC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 17:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiDHR6U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 13:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiDHR6T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 13:58:19 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C98205E1
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 10:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1649440569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8FAgs20XAUcmFBc6mL5q9DgPPm2OErsFNFwt9mnM9y8=;
        b=Ow4ZZWCML9bGRej3NgZHF3tdJ9ud/SejLM6lv9cHA0NUhCjMktASiVu9aPF/h+NID5y/0F
        nUu4votQgBtWb9t4L0eBjL3iD979sg2VCOlGZLBKW+G2EO/TqrfKjejxEDiOqs1gxyemkG
        sBK/UXha7YrT2oTWdF7j4KU1HGRHh9s=
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01lp2052.outbound.protection.outlook.com [104.47.2.52]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-27-atST_jRGON-uSt4XK3hwJQ-1; Fri, 08 Apr 2022 19:56:04 +0200
X-MC-Unique: atST_jRGON-uSt4XK3hwJQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ih4RX3dFgpgMz4sJd08IN+ueDH0j37iw0Hy0N9biZY2CDgQP0WiEUwPsQqBU3BUQ7ZoVXAzTFHSBxzNT3Jb7cdS6EAxiUZpRNsdxBVHnKmbRGqhmWg/JKEG9BFH32YldUrAbQ02c1ZmVqd7/RpXXuGtzkkakmrBhzLQACyTcjmzbAD7RCU/88tDFGHlRg3+oLAw1iBKWSb+vtG4l0INfPOtFGvFezNUBAjYWTA0TadaXS7rfGAoi+2UcYOKSqywRmNgT9hPMpDhzEC37Bp7PIR0wgysvLZwfYv332RzoAXy6V5yKQdgDui3m/hosVz4QlrHFZzYPL6KPOp4wwYpw1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8FAgs20XAUcmFBc6mL5q9DgPPm2OErsFNFwt9mnM9y8=;
 b=bzmGBEUdEI+cy/QX/j8S9WpC+VbxDMjHvgpn7pcagIknIReUzChSZ23z9GoTL1cw7JT/91NG1zTjWA64BZWYnNNpIcYWZRjzjPFZ+o13pKyeRzSo0F5WkP145isDn7vkRhm8bLDwxp2gS6NvJpqucthsB62uipPRZog40KmbcxN/ppQCA5a5c3GUw28a3/gabpmJ8o1zdECkdrMT257KGsqZ2Atu9/xK8JqIL5zNe0qoBVSXP2eUobJn1qcG9hJTnFmC/kesVlL8RSxVJ0RAdvOTjLdGtsqSY9zsEbZEr8R5tiLOb21M35pEz4B7h1fHUBRav/SVGCKVklIhmWdlZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM4PR0401MB2340.eurprd04.prod.outlook.com (2603:10a6:200:53::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.26; Fri, 8 Apr
 2022 17:56:02 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::6859:e5f7:b761:2d]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::6859:e5f7:b761:2d%6]) with mapi id 15.20.5144.025; Fri, 8 Apr 2022
 17:56:02 +0000
Message-ID: <dab118dd-c6e8-0970-2850-0337e367a204@suse.com>
Date:   Fri, 8 Apr 2022 10:55:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 06/10] scsi: iscsi: Fix unbound endpoint error handling
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, skashyap@marvell.com,
        cleech@redhat.com, njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
References: <20220408001314.5014-1-michael.christie@oracle.com>
 <20220408001314.5014-7-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220408001314.5014-7-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8PR04CA0063.eurprd04.prod.outlook.com
 (2603:10a6:20b:313::8) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b97bec7-0cc8-42c0-1965-08da19890bb5
X-MS-TrafficTypeDiagnostic: AM4PR0401MB2340:EE_
X-Microsoft-Antispam-PRVS: <AM4PR0401MB234004533749E0D0489E455FDAE99@AM4PR0401MB2340.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jlumfR3paNtsxM9NMNi7/4reQTylE4HQWi9edM/gyb4sDiUR7e45W6ppo4J0X4rSF8+FBVPrOyU3uSKxJhNOsCpbFvZnzx9w/o5mH7+jkQUplM4myQeDWXAE3crUAGfP9/BTBoMVRiw2hAqefJQHYzBIZVO3KIZIL+I9XTuhiYU+Tb4J28R3ILSAwyuXTUcHxhd+Ii2lFTnSW4dHLHNdJDlxH2qRV5QuuGa6iyHH3+i69A5Yqqb+JmoQqr1EA+XTfUe/A/ALatH518KmDoFHokN8QZMiNu7fK92Mkoj7lRVFchMoczY5fmcPR8VXvF7R6OUjHzgMfj3l6Y3PFf+tsqsGLokoRX38WLBIITJhmBzZ39auykdjDqQkGnJVvA9dIlxeAWSgaTnQwYA8ltpP+YwE9NZH1RcCl/3Y64sR4FI0tdBgZhWTEQtLXGPEzefpqREtAAXbBHXVDU9rFbR4I3aukrXxAKfmqe6elAwR8x5QCeQ4b0ma43vP3XNr9/wqnFooXmz5td6lTx/tRhpPF9IIbIF9pCY+mVVG5lNcpX8dryHZyvWHQVlBp9jatWx2jkZaLK5eH8wsNitbDtjb8pQXON+nfQ/OXOjxrHFEb4SXeZa1z4lv1RUegZpteEDui2Ex+WEZYL5mpBjJBipQTC1scD9U+a74dg2JH2c+SsAGxZeKHoJBtK/iESZCcRYEuvOOhN/QB1D/cUowaqE9HvbTKcrYzm35sPTlBq3bbSI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(26005)(2616005)(6486002)(508600001)(6512007)(53546011)(6666004)(86362001)(31696002)(6506007)(38100700002)(83380400001)(2906002)(66946007)(5660300002)(8676002)(31686004)(66476007)(66556008)(8936002)(36756003)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZWR4bUJJWWlBMER5WTA4K2wzM2V0Sy9TNnNoZDFLdXptdXJpdjROM2U5Vm42?=
 =?utf-8?B?QnJpMXd4NDQxZHhxL3Rzb0J5M0NCWVJ6WDQ0RlRBNzB1b2tnamtudmE1NDhJ?=
 =?utf-8?B?ak9UMzZjT1FldVBnZkFVYi9JMFlma3h4eFZ4TTdkTEoxVDZxc2xFNEtvNXBo?=
 =?utf-8?B?cjdDUkdjSjk3VElOSzN6cjBqTW1jdXRCZ1RFZHllelJ5THZ2NGxZUlRIRTdl?=
 =?utf-8?B?Q1FLZ2xQaFdCYURObU4rbkZjZDhjcXJpZEM4aStkVEN4NnVDZ3lUUkJLZGho?=
 =?utf-8?B?NW1UWm5adkwzZFJKZkN3L3oxR0FSSWxrbGpRNXpFbm1mQkdHR0srVnZyTUlC?=
 =?utf-8?B?YzBuTW11NkNJb1lCUWdGNVIzdExpM1FFWUJhRmFjcHhDWU1lQnd0MGVkWG41?=
 =?utf-8?B?NTcyajN6d2lVUGNXZm9RcmpPNE1PTlNuRHhGVXl4N0dpdXRCR3p3ckpZbXQz?=
 =?utf-8?B?aFNyTVh4bndoUmlUS2swc3Jqd20vUGNEVlIzNktFUnUrcHlMaEZpOTBqWVlQ?=
 =?utf-8?B?ZUI0K2Z2d1RERE9yTEdKUXJVRmNoNGNiUm5MSlMybzNaM2pRL0kwcitMRGZi?=
 =?utf-8?B?T0YxMm1CL2hDWWN3b0ZOK2JBZHJZczMyYTE2ZWZDZU5RRnJVSTBtYW43Q1E4?=
 =?utf-8?B?RjVwZ1FDb2RQVHI4eTd1RGp3dlVNcDd2VHdQL08xL0I3VDZCN1NheFJQaEZm?=
 =?utf-8?B?QTlOYmJsaFgrYmd5YlBqYk9FM1FJSGFZOWs1dHprMTZZSTRXZzIzT3hvNmtU?=
 =?utf-8?B?bnlRSUF0ZUpyaU1BWFRzSUcwUGdnaXlnYkNRZk5DamxlZXhsZWkzRlg2TUlE?=
 =?utf-8?B?SnJyZkUyUFdIc2xyRTVDRVZzdmhnS3hCMkxXSEJjQXJqQk51N216dlFBSytu?=
 =?utf-8?B?dlgxaUJ4dVdibXh0ZUtLYzRWaGYvVEFHaFN6UUR1WUNNRGFYSXR1Z2lOaFJm?=
 =?utf-8?B?TktXL3lOZW81bFAwakZiNW9FZXJwb0d0V0FzTUQ2R2xaUEJGMThCYjhwdDhC?=
 =?utf-8?B?dk5ib3BreERjR3ZUT2s3cWdwekpHWWw3K3ZydHNnVDIyNlM0QkMyTTFxYzdB?=
 =?utf-8?B?ZGVMNWJzbkZuVHNoVVNaakRzL0VCOGhRUHdoSVRQL0orWVBkRzQ1RVFINDR3?=
 =?utf-8?B?RFBlMUJXNC9tbHVvdWRYaGYvY1pSSmFoRlQvc3krYTZlNFE1eWhpWStNQ3o2?=
 =?utf-8?B?WUhiM2s3MnJDcjJwOVgrOGZRS3FEc3BFTHJpMW16dVFuTURCeXFqcnhmdURR?=
 =?utf-8?B?THdNMlZkVjU1YVFncDhNWklnR0lnSEU2cGxkWFZ0MEtUN1V3NVNxOUtFWDhM?=
 =?utf-8?B?bEJIb2VjT0hUa3hxbWM2ekovYjFQR2pJalFJN2libm9xOTZUOW5GTmRqaGJ6?=
 =?utf-8?B?RWhkbWZzNzAxN2cyd3lrUXEyakZ5TlFWaDRKNzdIOXlBVENabEVhTEZ2bndK?=
 =?utf-8?B?WnZ6endlYnRBWGswYW9iMWpnSnJacU5BQnd6cGVZRjJEQlFiQUcwU0hQc2Q3?=
 =?utf-8?B?MkQyUjByMWQxMUx2RXh3ZVc0Tk1peE9wK3ZIYWRnYmJGNndsRjV4WXRYQU1Q?=
 =?utf-8?B?WXJzOFcrN3NYUkxTaXAyemdZb0Y0U09qQW8yamkxN3VnSDBEOTF2WWJNMk9Z?=
 =?utf-8?B?aUVnMzBUVURud2tEcFNjcktpREpEckZaOGo1a29Uek5ndTh1djgxSmhPL3J4?=
 =?utf-8?B?K21PcmNWUGczaFlvSEhoN2wrdHRDVUYvMkp5N0JNbFdGOFRqeStQcU1pVHI4?=
 =?utf-8?B?R1IraVdHWWNVc29HcUZmU2NvR2VFa05DSEtYMGwvWEQveWt3ekdBcmFuQ0Fk?=
 =?utf-8?B?Y3JwR1R6bkxaOVVHV2YvcHdBOUJlOHZXakc0d0t2YnhmeU5rdVM4bWRCbFpL?=
 =?utf-8?B?U2xUMjlrN0tqMFlCem55d2dsZGEvUWFNR2hybW5kWkt5NDdSN0pwd09OWTlw?=
 =?utf-8?B?RExUdG5pdVFKd3N6MEVSQmkxeFlFWUUwMWtWdE9HNk5GUlJTck5xclh1YXNO?=
 =?utf-8?B?K1VPYnJlQ3NTVTBBcmdGZEY1dUxac0llQUVWanNMc1h3Y2ExMlZxdnEvYW1r?=
 =?utf-8?B?U01hSUpKLzRlZjJXY1hYVTkyeWc1dmp4VTdBcXRQZS95M3hKakFqdk9zMXd0?=
 =?utf-8?B?RWFWMSt6d29EQXQ1eE93M1VTNjFJQjhjNnFUckZyT0wzSHdqZDVGc1hEeHNG?=
 =?utf-8?B?cEFsYk0zb29qNFZQcUc2dGo3L3ZpZForSjN4enp4V3RoQUVUL05TKzdNdXVw?=
 =?utf-8?B?NjVLdXVFTERBa296TzYxUm53Kzk3Q0EwQXdTcnRqZG5OczZBelRtazRTcGVy?=
 =?utf-8?B?WExoS2l0ZTdTMEpJa2ZQdUUzbTdjWmRXY3NyMzdsSzVQRVFrWnNtZz09?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b97bec7-0cc8-42c0-1965-08da19890bb5
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 17:56:02.4915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5d4oPE36WBQ9LZuBGiZrEtwSu743AX+kmUtxTaQHKpzYsfxadMk1p+rxQpnp8OvS72zT3OQ2y4rzMOwJb+y66Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0401MB2340
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/22 17:13, Mike Christie wrote:
> If a driver raises a connection error before the connection is bound, we
> can leave a cleanup_work queued that can later run and disconnect/stop a
> connection that is logged in. The problem is that drivers can call
> iscsi_conn_error_event for endpoints that are connected but not yet bound
> when something like the network port they are using is brought down.
> iscsi_cleanup_conn_work_fn will check for this and exit early, but if the
> cleanup_work is stuck behind other works, it might not get run until after
> userspace has done ep_disconnect. Because the endpoint is not yet bound
> there was no way for ep_disconnect to flush the work.
> 
> The bug of leaving stop_conns queued was added in:
> 
> Commit 23d6fefbb3f6 ("scsi: iscsi: Fix in-kernel conn failure handling")
> 
> and:
> 
> Commit 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely in
> kernel space")
> 
> was supposed to fix it, but left this case.
> 
> This patch moves the conn state check to before we even queue the work
> so we can avoid queueing.
> 
> Fixes: 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely in
> kernel space")
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/scsi_transport_iscsi.c | 65 ++++++++++++++++-------------
>   1 file changed, 36 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 63a4f0c022fd..2c0dd64159b0 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -2201,10 +2201,10 @@ static void iscsi_stop_conn(struct iscsi_cls_conn *conn, int flag)
>   
>   	switch (flag) {
>   	case STOP_CONN_RECOVER:
> -		conn->state = ISCSI_CONN_FAILED;
> +		WRITE_ONCE(conn->state, ISCSI_CONN_FAILED);
>   		break;
>   	case STOP_CONN_TERM:
> -		conn->state = ISCSI_CONN_DOWN;
> +		WRITE_ONCE(conn->state, ISCSI_CONN_DOWN);
>   		break;
>   	default:
>   		iscsi_cls_conn_printk(KERN_ERR, conn, "invalid stop flag %d\n",
> @@ -2222,7 +2222,7 @@ static void iscsi_ep_disconnect(struct iscsi_cls_conn *conn, bool is_active)
>   	struct iscsi_endpoint *ep;
>   
>   	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep.\n");
> -	conn->state = ISCSI_CONN_FAILED;
> +	WRITE_ONCE(conn->state, ISCSI_CONN_FAILED);
>   
>   	if (!conn->ep || !session->transport->ep_disconnect)
>   		return;
> @@ -2321,21 +2321,6 @@ static void iscsi_cleanup_conn_work_fn(struct work_struct *work)
>   	struct iscsi_cls_session *session = iscsi_conn_to_session(conn);
>   
>   	mutex_lock(&conn->ep_mutex);
> -	/*
> -	 * If we are not at least bound there is nothing for us to do. Userspace
> -	 * will do a ep_disconnect call if offload is used, but will not be
> -	 * doing a stop since there is nothing to clean up, so we have to clear
> -	 * the cleanup bit here.
> -	 */
> -	if (conn->state != ISCSI_CONN_BOUND && conn->state != ISCSI_CONN_UP) {
> -		ISCSI_DBG_TRANS_CONN(conn, "Got error while conn is already failed. Ignoring.\n");
> -		spin_lock_irq(&conn->lock);
> -		clear_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags);
> -		spin_unlock_irq(&conn->lock);
> -		mutex_unlock(&conn->ep_mutex);
> -		return;
> -	}
> -
>   	/*
>   	 * Get a ref to the ep, so we don't release its ID until after
>   	 * userspace is done referencing it in iscsi_if_disconnect_bound_ep.
> @@ -2391,7 +2376,7 @@ iscsi_alloc_conn(struct iscsi_cls_session *session, int dd_size, uint32_t cid)
>   	INIT_WORK(&conn->cleanup_work, iscsi_cleanup_conn_work_fn);
>   	conn->transport = transport;
>   	conn->cid = cid;
> -	conn->state = ISCSI_CONN_DOWN;
> +	WRITE_ONCE(conn->state, ISCSI_CONN_DOWN);
>   
>   	/* this is released in the dev's release function */
>   	if (!get_device(&session->dev))
> @@ -2590,10 +2575,30 @@ void iscsi_conn_error_event(struct iscsi_cls_conn *conn, enum iscsi_err error)
>   	struct iscsi_internal *priv;
>   	int len = nlmsg_total_size(sizeof(*ev));
>   	unsigned long flags;
> +	int state;
>   
>   	spin_lock_irqsave(&conn->lock, flags);
> -	if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags))
> -		queue_work(iscsi_conn_cleanup_workq, &conn->cleanup_work);
> +	/*
> +	 * Userspace will only do a stop call if we are at least bound. And, we
> +	 * only need to do the in kernel cleanup if in the UP state so cmds can
> +	 * be released to upper layers. If in other states just wait for
> +	 * userspace to avoid races that can leave the cleanup_work queued.
> +	 */
> +	state = READ_ONCE(conn->state);
> +	switch (state) {
> +	case ISCSI_CONN_BOUND:
> +	case ISCSI_CONN_UP:
> +		if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP,
> +				      &conn->flags)) {
> +			queue_work(iscsi_conn_cleanup_workq,
> +				   &conn->cleanup_work);
> +		}
> +		break;
> +	default:
> +		ISCSI_DBG_TRANS_CONN(conn, "Got conn error in state %d\n",
> +				     state);
> +		break;
> +	}
>   	spin_unlock_irqrestore(&conn->lock, flags);
>   
>   	priv = iscsi_if_transport_lookup(conn->transport);
> @@ -2944,7 +2949,7 @@ iscsi_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
>   	char *data = (char*)ev + sizeof(*ev);
>   	struct iscsi_cls_conn *conn;
>   	struct iscsi_cls_session *session;
> -	int err = 0, value = 0;
> +	int err = 0, value = 0, state;
>   
>   	if (ev->u.set_param.len > PAGE_SIZE)
>   		return -EINVAL;
> @@ -2961,8 +2966,8 @@ iscsi_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
>   			session->recovery_tmo = value;
>   		break;
>   	default:
> -		if ((conn->state == ISCSI_CONN_BOUND) ||
> -			(conn->state == ISCSI_CONN_UP)) {
> +		state = READ_ONCE(conn->state);
> +		if (state == ISCSI_CONN_BOUND || state == ISCSI_CONN_UP) {
>   			err = transport->set_param(conn, ev->u.set_param.param,
>   					data, ev->u.set_param.len);
>   		} else {
> @@ -3758,7 +3763,7 @@ static int iscsi_if_transport_conn(struct iscsi_transport *transport,
>   						ev->u.b_conn.transport_eph,
>   						ev->u.b_conn.is_leading);
>   		if (!ev->r.retcode)
> -			conn->state = ISCSI_CONN_BOUND;
> +			WRITE_ONCE(conn->state, ISCSI_CONN_BOUND);
>   
>   		if (ev->r.retcode || !transport->ep_connect)
>   			break;
> @@ -3777,7 +3782,8 @@ static int iscsi_if_transport_conn(struct iscsi_transport *transport,
>   	case ISCSI_UEVENT_START_CONN:
>   		ev->r.retcode = transport->start_conn(conn);
>   		if (!ev->r.retcode)
> -			conn->state = ISCSI_CONN_UP;
> +			WRITE_ONCE(conn->state, ISCSI_CONN_UP);
> +
>   		break;
>   	case ISCSI_UEVENT_SEND_PDU:
>   		pdu_len = nlh->nlmsg_len - sizeof(*nlh) - sizeof(*ev);
> @@ -4084,10 +4090,11 @@ static ssize_t show_conn_state(struct device *dev,
>   {
>   	struct iscsi_cls_conn *conn = iscsi_dev_to_conn(dev->parent);
>   	const char *state = "unknown";
> +	int conn_state = READ_ONCE(conn->state);
>   
> -	if (conn->state >= 0 &&
> -	    conn->state < ARRAY_SIZE(connection_state_names))
> -		state = connection_state_names[conn->state];
> +	if (conn_state >= 0 &&
> +	    conn_state < ARRAY_SIZE(connection_state_names))
> +		state = connection_state_names[conn_state];
>   
>   	return sysfs_emit(buf, "%s\n", state);
>   }

Reviewed-by: Lee Duncan <lduncan@@suse.com>

