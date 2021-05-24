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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD8B4C04FF3
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 18:34:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD99061414
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 18:34:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233102AbhEXSgL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 14:36:11 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:26659 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232709AbhEXSgL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 May 2021 14:36:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1621881281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B56w4up+bX2NQGEjHyp2HkKwshJ7qPcmnm7yOpeSl/4=;
        b=GAnmsfU4L+7g7YdP6gd9oTeLz2jZyocyefKEdiT89c5SkMTn3BLChCXw4IiojgXVGgMT6k
        zCKAv1FNByScTgIwW0Gl2Z+QA4mYtud1gwgzZr6kN7EhYCnuhazV2IdnI4QxpZu8+Wb1qk
        HLrMrxkLeh08+DcYHdkGIMk+MNaHn00=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2177.outbound.protection.outlook.com [104.47.17.177])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-34-2xAGfY69P66NXmAt5rvQFw-1; Mon, 24 May 2021 20:34:40 +0200
X-MC-Unique: 2xAGfY69P66NXmAt5rvQFw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CS2Awr8AR3HdqwBBGq/fbxkyeXHeQeLaZWAgTSfD1jVP4iPmJnpogYk86Aj1zeDWvjRCYc5zgVAkzd2CZ5Tk3qXIIbb2lS6AyYA6i1tDlOF6R7pNQcEdIDAFMje8VaYVX7BIFTyATogZoSycvUBB5TAu27kTyRnGALrFO1uK9rJUQU1LItnnp3tMmkZVLVxZbU6FDYjdEdrYcyIL/T+khAAgOyP/42kzslNIaEgSe7gRYFMElZNKVpZ+EbZjdcC/7OLTkfrTAD35vHDBKhSf5u/8viiE8cNXe0nwfjTyRi7aNnSsayeF36AeIwI/sPdQu/dC9blhpouJcJEKPUitCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B56w4up+bX2NQGEjHyp2HkKwshJ7qPcmnm7yOpeSl/4=;
 b=fwHldPgfw3cmHh6ENwzHOwHT89mk93eMwb7VbnUxDsN1WNMODaC3OZ7u//YK+gImgHimSxErNH8siS1iCXasU2yCQoY5CEwKrpSRGVlzEjPiRXWdAXaK/jsFGiznrowdRd1LnjmEpiPQwrvTdoJ3vZDEf6culvJjG/hk58ifJKVNNimDDYHerVDlpElEKCWSJ4DlMpkC9v9YW79FERAC0IQXLzCZ+yHJVoKLyXt6Ps64iB536WLk81mL2XdvPq1m7yliDeJRoDKNTUbE4C3pG7QYAO7bQwbBeG7/hsKWegQ1KzVs6SU347oUNqskzdyQKrKw79SIQJkXVcTrgU31ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM5PR0401MB2660.eurprd04.prod.outlook.com (2603:10a6:203:3a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Mon, 24 May
 2021 18:34:39 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d1a5:8072:c01f:3cf1]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d1a5:8072:c01f:3cf1%3]) with mapi id 15.20.4150.027; Mon, 24 May 2021
 18:34:39 +0000
Subject: Re: [PATCH 10/28] scsi: iscsi: Add iscsi_cls_conn refcount helpers
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
References: <20210523175739.360324-1-michael.christie@oracle.com>
 <20210523175739.360324-11-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <443ebccd-6f1e-f5ca-3adc-75e0b76c8a88@suse.com>
Date:   Mon, 24 May 2021 11:34:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <20210523175739.360324-11-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM0PR10CA0068.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::21) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM0PR10CA0068.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Mon, 24 May 2021 18:34:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8a72402-2437-4321-99b4-08d91ee296aa
X-MS-TrafficTypeDiagnostic: AM5PR0401MB2660:
X-Microsoft-Antispam-PRVS: <AM5PR0401MB2660E4B8FD5DF24EC54AE02EDA269@AM5PR0401MB2660.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y+/5XrawyqV2+tp403vtHsbvqZXsYdtw0THG0MIUQCIZSqNUjoCUEPlxzZ6TMWNR0cR5w25WW7hZr8A0O8quXQr3WZaP4GTetseuBXWAJB9BRBnURntJ4shbH+8OClaV9UfWuBJ47ObD0WYL3QAZGwjGkoUDkNNWWWMG343m5vQfjae5kIhN9UJHVup8UZKZHLlYtYbTvbIXGDT1NbW/TRsZ2g9am3lA8n6vWOTEbmr9NHy+h8jhhqMe1hXPzw+bbJn14Gw96Xx/BHNoQfg45ZURqUgx+mZy6dCdginAHo8/BUOuZdCkN+xjrkOzzotJbpjOI2X1QUVaVCrWU5EGFmtLcht91lt5ut7JubpBzTHWK6kP0Aur+30uRvmW2zLVz+frg42gfqjgWjtsMeek5D22vJXn1LpPJsC/fljT/FpnffXXseiJmppprYeF+hpb/gvEy9GYmngiAfgqqYoE2fQYddtmSfSS1cViiZWsr7QyOVwl2AkPdHuxc/+84drxn4lDS0DjeXZC95opwvgFGDo5o3E9RK3c7u11HNWuK1iMd4/A/WRjBC5raqWAkiEdX2Be7cLzMhUU6FcVM5FeczfH6Gx3fq+bKfzt4mO3rTiOwYfarrQ9yUd+ugYsPlr0d3EPsfo/7RJI6rjfjemnZqafsSDEgK4islpNzSqO0fVwXBU+XYRIzizhq/y7uR5X
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(376002)(366004)(396003)(136003)(66476007)(83380400001)(8676002)(86362001)(8936002)(36756003)(66946007)(186003)(6666004)(66556008)(6486002)(16526019)(478600001)(2906002)(956004)(26005)(316002)(5660300002)(31686004)(16576012)(53546011)(38100700002)(2616005)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?K0daZ25NOW9xcVhkVC9SVyswQmZLclJJdVo2R2k0TUlOT3dnY3pGbk5IZzcx?=
 =?utf-8?B?ckxMM2pIV3JwTE9VbFkrb3plYmNjTFNyOEJXSFlxQTI5b29henMzSEFkbFdZ?=
 =?utf-8?B?YjZ3amhKd01QN3N6WjZjMWdyY3RvREYyRkNtNXlSL3NPZ2ZrVUlmNlVScGpp?=
 =?utf-8?B?b2tsaG9ESUdGc2FvbWdCbC83YzN1TE1PaXM1aEhWTkdnT1Zic0Zxc0FzWW9x?=
 =?utf-8?B?TEV3ZW8yai9uRDEzTnFuQ281YldFRXJiZGZGeHlMRklmc1EzRkVzZlRnaEhx?=
 =?utf-8?B?RWltMU1rd2FscnhKUFR5MWVORUMveHA2akFSdzJqMkZQYnY0VUtIeklwME44?=
 =?utf-8?B?YVBobWNmWXoxc2hxY09JbTZneTFsRmhMS0ZINDVzMGVVTFVlUlpweXpaM09O?=
 =?utf-8?B?bjhEUTdOcFpoSFl3TGVCdW5TWVJYTnZFdm45OWNLUVFvN1dyTThDb09BUmpH?=
 =?utf-8?B?N2krc1lnbjBTYUs1QXZYNHNpZGRSalR0SE9DMW52SFlWRS8vYmg5VVBRdkFX?=
 =?utf-8?B?OFdEbFZjWXVraEdsT0RTSnROK0I0aEZMWjZZckhsbzlNN0QwRjFiditIeTQz?=
 =?utf-8?B?QkhNZm5HWnMzRTZpWDBmT1EzdHNDeXFBWDFEYkhZNndUSmtaendwZmZKdW8v?=
 =?utf-8?B?YnNNanlyaURUa3JWUGJrMmVLcUNTN0Q4dzNmcnI4N0lEODZxd3FJeFZRd0NI?=
 =?utf-8?B?d2dNZnU2Ums1UUI5K28vVUVEL3kvK2tWWnN1aVpHNHJWMTNPb2pGeEg3d0g3?=
 =?utf-8?B?ZE9SQ2RpZTRYUHoyVXNKT2Vwd0RLUDRuNFprZGcxei9NL1kzQnBabitFNkdl?=
 =?utf-8?B?Vm5CTG5ZNkdUckliS0tIN2J2V0pocGZQTDFURFVxc3hxeEVYSm5ZTy9DRGhJ?=
 =?utf-8?B?Y1JDeHh1dndDay9RVmQvQXNvQ3RXV1o0bHhIVUczWGk5ZlFuWUQwV2xONklZ?=
 =?utf-8?B?YytQbUZlSUNCTmJwVU9qUlhpTzFSeVc4ZURFWmxqaU9oaVdqTVZvbElNdi96?=
 =?utf-8?B?Y00vcytjWWdpQkNqSmYxbG1xbEg4b2sxZmJ5QzNwY2NSMTRiajhLMmI3OUZ1?=
 =?utf-8?B?OU5ZcDE2Rk1nQzhLMXdhWWJhaGZCRHlHUkh0YVBEZ0NxbWl4TVFPQU9OY1RE?=
 =?utf-8?B?WTgzdDlsdWdXYlY5czNxUFhjelNwT0ppWlM1SW5SQ25mcFpDRG85bEFIa2pQ?=
 =?utf-8?B?NStYaGUyNzJzYVNpTStxdFNuakkvb2FSWXZWdlNLUEhsRHpncURZSTNYaUZs?=
 =?utf-8?B?bmlQZXNkOXozWWNHbCswMHU0ZlZQKzhsWjBsUVdFNUVlb0hoVkNzdXYxWVF1?=
 =?utf-8?B?QWpYcm1JUmFLOHpaT2VWTmJWTzFMUFpVUGU4ekJGdGhPZHFkbnRXQ0dHN1po?=
 =?utf-8?B?L3RIeFBsZnl0anBtT2VjZWRjeW9xdlJ2bUhGcXZGYW9YQjVycFRoT3l1UHN4?=
 =?utf-8?B?cnE3aXN0cTllcEgvU0ZTN3RYYU9UeDk0MURvT2dIZE9SSGszSXQ4Um00RlJp?=
 =?utf-8?B?SjJGbW8zRVN3RW8wOE9VU3ptLzZ4ZkZaWlZzR0I2ZENOVWlqRnltRURNdnpv?=
 =?utf-8?B?T1l6VUFWZHV5dC91MXVHRENLay9oVE1hWkE2aWxUSDdqbTY1dnJXNEk0ZTVI?=
 =?utf-8?B?OXhzZDFscCtZZlQzcG9xek1UaFIrSFVmWWRqYnJETkJ0eEgzd2dRUHJSS2hX?=
 =?utf-8?B?TXJIMC9EN0FPMzhqYW16MmNUODAzZDVSdEZMWE1KRFdEa2ZQalF2aE9jWUtZ?=
 =?utf-8?Q?uoXj/uJXyw2VG2hkxNuYtgfxRrm3DVx7s09q9Dr?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8a72402-2437-4321-99b4-08d91ee296aa
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2021 18:34:38.9790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ICWQoC5/wB3AR37Jx8nNuaem1Z+CUGzn99h0aecBmaKB1nNKpnpjhUENMjnB7Vsy3wAs3w4O56H0MOI99NECBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0401MB2660
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/23/21 10:57 AM, Mike Christie wrote:
> There are a couple places where we could free the iscsi_cls_conn while
> it's still in use. This adds some helpers to get/put a refcount on the
> struct and converts an exiting user. The next patches will then use the
> helpers to fix 2 bugs in the eh code.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/libiscsi.c             |  7 ++-----
>  drivers/scsi/scsi_transport_iscsi.c | 12 ++++++++++++
>  include/scsi/scsi_transport_iscsi.h |  2 ++
>  3 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 2aaf83678654..ab39d7f65bbb 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -1361,7 +1361,6 @@ void iscsi_session_failure(struct iscsi_session *session,
>  			   enum iscsi_err err)
>  {
>  	struct iscsi_conn *conn;
> -	struct device *dev;
>  
>  	spin_lock_bh(&session->frwd_lock);
>  	conn = session->leadconn;
> @@ -1370,10 +1369,8 @@ void iscsi_session_failure(struct iscsi_session *session,
>  		return;
>  	}
>  
> -	dev = get_device(&conn->cls_conn->dev);
> +	iscsi_get_conn(conn->cls_conn);
>  	spin_unlock_bh(&session->frwd_lock);
> -	if (!dev)
> -	        return;
>  	/*
>  	 * if the host is being removed bypass the connection
>  	 * recovery initialization because we are going to kill
> @@ -1383,7 +1380,7 @@ void iscsi_session_failure(struct iscsi_session *session,
>  		iscsi_conn_error_event(conn->cls_conn, err);
>  	else
>  		iscsi_conn_failure(conn, err);
> -	put_device(dev);
> +	iscsi_put_conn(conn->cls_conn);
>  }
>  EXPORT_SYMBOL_GPL(iscsi_session_failure);
>  
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index b8a93e607891..909134b9c313 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -2457,6 +2457,18 @@ int iscsi_destroy_conn(struct iscsi_cls_conn *conn)
>  }
>  EXPORT_SYMBOL_GPL(iscsi_destroy_conn);
>  
> +void iscsi_put_conn(struct iscsi_cls_conn *conn)
> +{
> +	put_device(&conn->dev);
> +}
> +EXPORT_SYMBOL_GPL(iscsi_put_conn);
> +
> +void iscsi_get_conn(struct iscsi_cls_conn *conn)
> +{
> +	get_device(&conn->dev);
> +}
> +EXPORT_SYMBOL_GPL(iscsi_get_conn);
> +
>  /*
>   * iscsi interface functions
>   */
> diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
> index 3974329d4d02..c5d7810fd792 100644
> --- a/include/scsi/scsi_transport_iscsi.h
> +++ b/include/scsi/scsi_transport_iscsi.h
> @@ -443,6 +443,8 @@ extern void iscsi_remove_session(struct iscsi_cls_session *session);
>  extern void iscsi_free_session(struct iscsi_cls_session *session);
>  extern struct iscsi_cls_conn *iscsi_create_conn(struct iscsi_cls_session *sess,
>  						int dd_size, uint32_t cid);
> +extern void iscsi_put_conn(struct iscsi_cls_conn *conn);
> +extern void iscsi_get_conn(struct iscsi_cls_conn *conn);
>  extern int iscsi_destroy_conn(struct iscsi_cls_conn *conn);
>  extern void iscsi_unblock_session(struct iscsi_cls_session *session);
>  extern void iscsi_block_session(struct iscsi_cls_session *session);
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

