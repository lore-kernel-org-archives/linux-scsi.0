Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54755C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 18 May 2022 16:01:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239777AbiERQBe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 May 2022 12:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239860AbiERQBQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 May 2022 12:01:16 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4EDE633B3
        for <linux-scsi@vger.kernel.org>; Wed, 18 May 2022 09:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1652889671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4SsacLz18SUeiwVUuLg3MhXxpPESc9xDxenq1E1P640=;
        b=TqbzAr1uH21SbZb+PubtE8ZVIGDl6qD4AY8nMWh/uOgvEmi+Jznc6deAv8ndC7bh2iKCBx
        l2aYf7e6VF9HyZQ282kRDM6JK7iBizEKd9DC0VlZqpnO/2Z+gXBW11qvFLj/jKa8ZCXaz6
        RVS4be1n9B1lx2jHxCy9NAPpAeO60IQ=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2053.outbound.protection.outlook.com [104.47.13.53]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-27-Uto9o4-9P9iPiIyTRPJGfg-1; Wed, 18 May 2022 18:01:09 +0200
X-MC-Unique: Uto9o4-9P9iPiIyTRPJGfg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OSRvscDd+b/VLRIbNgIXOean8yjg2JJUpyE/eDMTL7+VoA3drw0idaw0xzxkrlayrK9GbyGC0qSqHhOtVGyC3Ge/oihReb9jsPF0B5scccBoW/cPNrL9+g5EywJPX3xgmkHZB6pKYFFe1ETP+lQ6iYdAdOM54gvXT7LBMxDdaNi/9EIB1g4ewT0zFlQiyqpi3k9jl8rcW/Ms1FwIYyBKUN0uMY7TSOt04it+Dr4glsUywKHAi3NBrG0zqW7yLzLXDGW0O37bevWE+f2wxYxBJz4gKCMnyD8RQyxfnUiBTZeOArbop1yq5Fe9S4VcIP9GITUH+SQJes4XvSBzbfaEdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4SsacLz18SUeiwVUuLg3MhXxpPESc9xDxenq1E1P640=;
 b=OeNrGVkz+2+rWPx0neuPBLiYBZO5EajexZhHlHIU5d2OxwWMHR6+dkRIXQpNlj40xk6a+wVXEnUsRrYj0LqLnR8ACUsJEElcFs3xmI2Um3OoBUrwjTHjBirPhQzzr61pgfub1LFncTs+bFzwuyVpNgKW3r3Ff3a/maXJ3+xs2v2/Z+FjuIkqs/UNnzZwPpUiKPMKqoNemaxSJUWD0+2TreTz53Bvak1Wg9W9QozquKp0ds+b3Xu/c5/oh5zexi3ItUfR9sGqCdbQ2OixOfpwpdrVBTU//ejtlQz5ygJFQNyg7zFJBHmYgutoAMUGoxv39hwLthW7NBBcA7TAQ+lJTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AS8PR04MB8705.eurprd04.prod.outlook.com (2603:10a6:20b:428::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Wed, 18 May
 2022 16:01:07 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::541:b6df:93f7:a5f9]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::541:b6df:93f7:a5f9%4]) with mapi id 15.20.5250.018; Wed, 18 May 2022
 16:01:07 +0000
Message-ID: <fdf2e3f3-d136-76e8-48fe-95e2760bcb1d@suse.com>
Date:   Wed, 18 May 2022 09:01:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 02/13] scsi: iscsi: Add helper to remove a session from
 the kernel
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
References: <20220517222448.25612-1-michael.christie@oracle.com>
 <20220517222448.25612-3-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220517222448.25612-3-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0318.eurprd06.prod.outlook.com
 (2603:10a6:20b:45b::18) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb213315-d350-4c42-f6be-08da38e79e72
X-MS-TrafficTypeDiagnostic: AS8PR04MB8705:EE_
X-Microsoft-Antispam-PRVS: <AS8PR04MB8705AF4C1850CA44E7981EC5DAD19@AS8PR04MB8705.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +WsN8RAtQk01v9AxHEYLR8wIrff+TWEDMl0HQ/T749w9vD1nl4eVmS+LA58NOfnKXfpCpr7x70avhzCU0kj99/+b3oquPisCkLZff7Zjl/a1r53mb9hCDQ/1U1ikQhRu2JKLebiycaQRVtt3AtaQU9UA+czBye/uE+knVsGiveoInU540F14xXIo3Sd5LPA6gLQPp4y1ZQ/DKENdGE3uLzDnvcSiMWyATDuKbR4bYiViX9Xls8dI9jc7tyKoQnkeWjbvTlvoWMrp0LqRd47POU4FrxdDQQrH2NxQq2zEitS8W18kj3tHho2gbzoosivuJdyTnMzHX1xFAtt7nTE66zT1aWW/aPug5lcZDlxAFospmHFQA2JjAtS1fuO2k2nA3rCCr2FA0LFddyM+X+4p2nFqN4NSHkuPtOQyzGroOaCUXRIF+r7h9YDYFRa8kOqCW1k6qdizDdFRhomXHw/ys5s5k/Zb8KI9eKbL94/rs0y+Vp65jOLarwSrbUZe2WGrBndNHFOjfUZXrVlN09tlBQwQQbOqZDif0OJpJ6uk2n54T0wXPi4dv+iuAG1IsYrB8aBwdhUZ4/+fMklhJZicEb0bFiKHB2yEfUpqJLvIm0tMIxFpKKgC6kumucQ2GXpwgoJM8B10sfnRryWsgrZGTiLwpVOQt3TLSkYFSLeXU8iUTDmHfJp9bkX1NGOm2pBou3DPWtKbuW17JgCcxdXgg3RQyUNz+ckWJcm+MVo8g8Umml87VsN4jPqKBHYOJKkZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(53546011)(6666004)(26005)(6506007)(6512007)(508600001)(38100700002)(6486002)(2906002)(8936002)(83380400001)(66946007)(316002)(86362001)(31696002)(2616005)(186003)(8676002)(66556008)(66476007)(31686004)(5660300002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dXJhOHVMWmZ5ekwrYmNSbjQ4c3gxZ3VVd0t2OVFwd1RMNTBVbERVei9OODM4?=
 =?utf-8?B?NU9Sclg0ei9JRGhJUnY0bGNMU0JTUndHSzlTSWNLa3J0cVZGbWZ0MUFwUnBU?=
 =?utf-8?B?V2FIbG5HR2hXQzRXWTd3amNrTEdDam5ubHMwVHBreEFaZ0ZUK2s0YWlGb2hh?=
 =?utf-8?B?MEdSdFFXN01uQnZwNHFrQml0UVhkZklCa0RMNXBudS93LzVGcXJTYXEvMnFu?=
 =?utf-8?B?ZlRhUGM4OGxTY29EdXhYd1RLTHozWkN1ZW95dlVOM3AwQXFoU0JldStYaGRy?=
 =?utf-8?B?K0g3UkErUEhPRi9lQ0p3Vi9kSGJvSzJTVFV5WjhUcUpDWTdkTnJCTHd5MFpz?=
 =?utf-8?B?WWZwdFVmM0xYN3BtYUczZDY3MTZXVU5xOVJEZ0NoREh0Nkx0TVYyMUdXbHhI?=
 =?utf-8?B?QmhlanZNdjVTOFhxYjZ5SG5zeGVOcHF3bnpiei95R2oxQnVCMExzcVhNOTdI?=
 =?utf-8?B?ZFMvL3YrSVdtWFF3QkNFMXAwbExtVnBGcjZVQkNjU0ZPN3FhY3dZMU90bERC?=
 =?utf-8?B?K1Y1Z0kycWNJR2hNUk5SK0tXNzBTZ3JiUTUxZlpBek5JRU1RSEZxOFlxY3ZC?=
 =?utf-8?B?Qk04VWYyZmVmVU1iMys5R0E3c3BPYkNMRXhQT1VjcVBYOWVxRGM2SWNjQVov?=
 =?utf-8?B?dmZlSkd2a3FCbHJWOE54cU9qdlFNVG8wbHJqTXlqd2d4ZURCUzRhRWF5bWJF?=
 =?utf-8?B?UFdpZmdOOE5RU3JianR6VWlEaFV1SkllV2U2Y1NIcUJoOWVjQjM1ZEF4MFVk?=
 =?utf-8?B?czFYdjUwbDJxbkIveEsrOWxBN2dwcUxOYnNJNHlDS0FjSE9PZ0Mrd0h4ampo?=
 =?utf-8?B?OGkzNlBmVDBNREY0TEk1aUwxS3o0QjQzSXJVUFBIWDlOdnFNdkNwWkJwWnFL?=
 =?utf-8?B?YTVKcjVBTHVFL0NDSld4NHhmMW03K1E5TVlha3pGM0tzTzY5cU9vd29PZXZR?=
 =?utf-8?B?YTBCMlNPWkpTdFduRHZrRmxnRTQyTTFSRDRLN2pRZEpFalNVTmF3STlOdDh6?=
 =?utf-8?B?bERnUmhjV3Z6dlJlWnNjczE0SU5nTzA5NGNadWZpTElXT3Y0WG1IdDBuWmtD?=
 =?utf-8?B?ZVRQMUd0QkFLVXpKelhoNDJORFZjRDVPNTdhWlJhVHhvUkE3SjgxUkVLVEtv?=
 =?utf-8?B?SW1nQjBIOTRHZk94TE5yQlBER3BxNGJEOWFLemJqS3BWVTJXNUYzM1EyTjV0?=
 =?utf-8?B?a1c5RzIzVWIrekdRT0JoVTIrVFF2emNmWXM0b21vS0s0azZ5QjVFcFoyeGVL?=
 =?utf-8?B?TW53V1pTTTRzWnF3S2pzQ2lhSFJDMXN2VnE5VFdadzh6UUdzclRHUVhFYnhD?=
 =?utf-8?B?YTgyOFVMaCtlQ0QyK2Qwd3ZWa2pFSlFxSDVxb1ByYmlVcjFVd2tncUdWTm5B?=
 =?utf-8?B?M1RldVVGMSt2YnBCMy9WYU4rTmZDMi8yNUVFUVBiS1dJVjkrMndNaXIxRkMr?=
 =?utf-8?B?OU9EUitZWWdadGpSSEE4bm9jSXNMNWN5cWFRUnpiM0p5UXpYZHlHb0dzT0pp?=
 =?utf-8?B?SlM4aTNzK2xWTU9STlp6MWVOb0JQNmZ4aytjK3g0NkZvYS9LRHdtM0Q0NS9r?=
 =?utf-8?B?akc2U0hlVXI0YjVmcGJkY2orN0dqcFVuaVdCQ0UxcnJ3Vml4ZVFJQ3J6SzhX?=
 =?utf-8?B?ejkwcEt2aTdtRWIvd25HaUNsekQvWFlCVnhaR09tTDJCc1g1UW54Q0FDdlhQ?=
 =?utf-8?B?TDFXRWxOamp2SitiWTQxR0dpZndMbDRkbXVxd3VoSElYdE1YZG5HNERJRTYz?=
 =?utf-8?B?c0hHV2VwVFNQVFoycC8rWmV4aFdlOC9Qcm54TzhCcXZ0MjIvSldrUlRBRG4r?=
 =?utf-8?B?bE9WbHNrSkY0RjBGaHFpRUpOeWQ0SEpsa1NSdmkxc1czV0xzeTFRcmJQSEFw?=
 =?utf-8?B?RUNyWWM1WjE0aXNlM3ZTamY3UGo4YnFUZVdKTHV5TlZsTDdBcTg0SVlMSGRn?=
 =?utf-8?B?V2pZKzF6MUhlcHJmR1hvajkraEttaVhTWU83aWcray9NbWpKY2lIMXBnS3Y3?=
 =?utf-8?B?SENPeGNaWVl6bnpSKzFVQ1hZU0FteGpzSnhneG1PU05lNjlpUjBpWHZheWxO?=
 =?utf-8?B?QnBQemVUbGF4VHZUdzZYZEdBZVBzYlJ1bkhzK1RrK0M1NGI1SlBXMUVLYmVY?=
 =?utf-8?B?SlVYdzFEMTFxUm5JZ2NiVmt0cFFSWkliSmpvSk41Zi9ac3FZekhvZUxyWDBJ?=
 =?utf-8?B?WjdZMUs5QkkwYUUyTm1YTDJYN1o1WlhUNWp6bGtBWkNBTHA3bVIxQ0FNa3NQ?=
 =?utf-8?B?SHJ2OWRpci9oVlBDZmJZRmtXYStPWUVmT3lJU3pjcWN4em9pTmdTNGxxbHRM?=
 =?utf-8?B?UWgxaWM1MlF1VWpNNVliY0NSTUlLUkg1YUxXMGpIYk9hWGd0ZVdudz09?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb213315-d350-4c42-f6be-08da38e79e72
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 16:01:07.4375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RZnJL0Nmwg17jhqpYsYHJ5Dtu7OaHb9Ub5UBS/MiXUZjtJ+i2FppezBgrTSLEw6UhR7bqqeYZNYH842R13R0Xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8705
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/17/22 15:24, Mike Christie wrote:
> qedi requires that we at least tell the FW to disconnect and cleanup
> connections during shutdown, and patch;
> 
> Commit: d1f2ce77638d ("scsi: qedi: Fix host removal with running
> sessions")
> 
> converted the driver to use the libicsi helper to drive session removal.
> The problem is that during shutdown iscsid will not be running so when we
> try to remove the root session we will hang wait for userspace to reply.
> 
> This patch adds a helper that will drive the destruction of sessions like
> these during system shutdown.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/scsi_transport_iscsi.c | 54 +++++++++++++++++++++++------
>   include/scsi/scsi_transport_iscsi.h |  1 +
>   2 files changed, 45 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index e6084e158cc0..3b5e07544324 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -2257,16 +2257,8 @@ static void iscsi_if_disconnect_bound_ep(struct iscsi_cls_conn *conn,
>   	}
>   }
>   
> -static int iscsi_if_stop_conn(struct iscsi_transport *transport,
> -			      struct iscsi_uevent *ev)
> +static int iscsi_if_stop_conn(struct iscsi_cls_conn *conn, int flag)
>   {
> -	int flag = ev->u.stop_conn.flag;
> -	struct iscsi_cls_conn *conn;
> -
> -	conn = iscsi_conn_lookup(ev->u.stop_conn.sid, ev->u.stop_conn.cid);
> -	if (!conn)
> -		return -EINVAL;
> -
>   	ISCSI_DBG_TRANS_CONN(conn, "iscsi if conn stop.\n");
>   	/*
>   	 * If this is a termination we have to call stop_conn with that flag
> @@ -2342,6 +2334,43 @@ static void iscsi_cleanup_conn_work_fn(struct work_struct *work)
>   	ISCSI_DBG_TRANS_CONN(conn, "cleanup done.\n");
>   }
>   
> +static int iscsi_iter_force_destroy_conn_fn(struct device *dev, void *data)
> +{
> +	struct iscsi_transport *transport;
> +	struct iscsi_cls_conn *conn;
> +
> +	if (!iscsi_is_conn_dev(dev))
> +		return 0;
> +
> +	conn = iscsi_dev_to_conn(dev);
> +	transport = conn->transport;
> +
> +	if (READ_ONCE(conn->state) != ISCSI_CONN_DOWN)
> +		iscsi_if_stop_conn(conn, STOP_CONN_TERM);
> +
> +	transport->destroy_conn(conn);
> +	return 0;
> +}
> +
> +/**
> + * iscsi_force_destroy_session - destroy a session from the kernel
> + * @session: session to destroy
> + *
> + * Force the destruction of a session from the kernel. This should only be
> + * used when userspace is no longer running during system shutdown.
> + */
> +void iscsi_force_destroy_session(struct iscsi_cls_session *session)
> +{
> +	struct iscsi_transport *transport = session->transport;
> +
> +	WARN_ON_ONCE(system_state == SYSTEM_RUNNING);
> +
> +	device_for_each_child(&session->dev, NULL,
> +			     iscsi_iter_force_destroy_conn_fn);
> +	transport->destroy_session(session);
> +}
> +EXPORT_SYMBOL_GPL(iscsi_force_destroy_session);
> +
>   void iscsi_free_session(struct iscsi_cls_session *session)
>   {
>   	ISCSI_DBG_TRANS_SESSION(session, "Freeing session\n");
> @@ -3713,7 +3742,12 @@ static int iscsi_if_transport_conn(struct iscsi_transport *transport,
>   	case ISCSI_UEVENT_DESTROY_CONN:
>   		return iscsi_if_destroy_conn(transport, ev);
>   	case ISCSI_UEVENT_STOP_CONN:
> -		return iscsi_if_stop_conn(transport, ev);
> +		conn = iscsi_conn_lookup(ev->u.stop_conn.sid,
> +					 ev->u.stop_conn.cid);
> +		if (!conn)
> +			return -EINVAL;
> +
> +		return iscsi_if_stop_conn(conn, ev->u.stop_conn.flag);
>   	}
>   
>   	/*
> diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
> index 9acb8422f680..d6eab7cb221a 100644
> --- a/include/scsi/scsi_transport_iscsi.h
> +++ b/include/scsi/scsi_transport_iscsi.h
> @@ -442,6 +442,7 @@ extern struct iscsi_cls_session *iscsi_create_session(struct Scsi_Host *shost,
>   						struct iscsi_transport *t,
>   						int dd_size,
>   						unsigned int target_id);
> +extern void iscsi_force_destroy_session(struct iscsi_cls_session *session);
>   extern void iscsi_remove_session(struct iscsi_cls_session *session);
>   extern void iscsi_free_session(struct iscsi_cls_session *session);
>   extern struct iscsi_cls_conn *iscsi_alloc_conn(struct iscsi_cls_session *sess,

Reviewed-by: Lee Duncan <lduncan@suse.com>

