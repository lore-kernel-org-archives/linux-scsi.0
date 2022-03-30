Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CE94C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Mar 2022 15:48:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348394AbiC3PuO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Mar 2022 11:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344628AbiC3PuL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Mar 2022 11:50:11 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E904D61C
        for <linux-scsi@vger.kernel.org>; Wed, 30 Mar 2022 08:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1648655299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4BFPBoZrV/aPs8yPXASQmXEb+Xv1j9qpwpumsehBaIU=;
        b=gCYpJzIKMngzdIuKQuxMmVwObHgNAGMPdvJJf6TZ8pW0tBoahQom2EnQOnBAGfxkJmdUIL
        9vTXRnddcO7MryhFmfUe4YuiG3DyXhOC7KLDwMpsREPV/Q2qSXjkl+2D+bm519oe02Mmbs
        JzjshJbwaanjXDIs3+0iLmeS4WXGZNM=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2105.outbound.protection.outlook.com [104.47.18.105]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-5-PQSxNUXjPM2HJ26IUrUAeA-1; Wed, 30 Mar 2022 17:48:15 +0200
X-MC-Unique: PQSxNUXjPM2HJ26IUrUAeA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nLOo4ZTrodfiCSsuH1xW1S531US0qZeISMhIDLf9URDOg3N47Q6E7CROoBKTcAeHUAryzL0V9/UqV71ufEdsNmdLKurbSaKAVB9/dUgzFPAF2eaNqnI2tQ4ltlmrYi9MNI21QluUCOK10/ODPo6Sgrvn/JGST5dK2pfoQlJDcm473VGORVFenogEgPA3tUEUiZhz84t7A9nZCOTgU6iuQvQrKGqq+zacK1GdiFRtO/WpcoleO6CxSrjnvsf5l0XfvCPLIivE4gq6nlwNZ6GDudPD0UCxxj0dEZpNNsS5Q6wOjzMh6cLLf5+Ztn3h7aD3gCt87i9aj5xd6lIRnFjEfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4BFPBoZrV/aPs8yPXASQmXEb+Xv1j9qpwpumsehBaIU=;
 b=APOciS8dEG6jqUQuKwegS0uM7wUZGTcmS9qZhmGndo5LIGxk73jkK3v7RwhdOLCiQNstZH3XXXtNm23LYEGm1B2r6Ij1FtWzei+S5w7eGLdhSTpKitB35v/6SBx6EI0v9NbfeZqbm3XTzG0O1LUlm0ukqKstM/PxEGxkr6KEnBIL3PrzXfoS3+J14I9274pPxKRc79dGi3RqZLr6SQGLwrqqyf/ciRWj3tdQPpW4EnN73nPMVsGVMLFjFGz4x+GDqtv9gv68dQo2zXlHDHXUAPk62EbBQng5bur0CurAwKp1x0uSl5JZuQBYHE3hCvhGUI9lvkl9p3if2Fn14DX2mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM0PR04MB6339.eurprd04.prod.outlook.com (2603:10a6:208:178::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Wed, 30 Mar
 2022 15:48:14 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::dc9:d46b:1a6d:2d44]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::dc9:d46b:1a6d:2d44%7]) with mapi id 15.20.5102.023; Wed, 30 Mar 2022
 15:48:14 +0000
Message-ID: <a937f583-f444-0c9d-821c-a1dbb1769325@suse.com>
Date:   Wed, 30 Mar 2022 08:48:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH V3 01/15] scsi: iscsi: Move iscsi_ep_disconnect
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
References: <20220329180326.5586-1-michael.christie@oracle.com>
 <20220329180326.5586-2-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220329180326.5586-2-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM7PR02CA0017.eurprd02.prod.outlook.com
 (2603:10a6:20b:100::27) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74e21fdd-9dee-483f-0372-08da1264b34e
X-MS-TrafficTypeDiagnostic: AM0PR04MB6339:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB633954E651890D8DCF82048EDA1F9@AM0PR04MB6339.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9P1TfIFtW6JaIWuAQVX7H2GiVWOeA7xa9bKk01fYj5UpBWu3Hw7G+GPaBjx3zNq6Pfh1XcdhuiFFpQ0LWaHrhPb4W37xWNWhjF2B+6NF8PtkIfrkm1GhXyzY+/F9rqqx9I43cnuqs5m3ndmJXmbjlZc3ojS1Kg0ezUBJdYtMw6xlnNs16CujqgIcwdE38KTwjyEc8v32Edat1O3gXEJeZkCl7kp6sMxSyQaTaNTj2WMFBw0HoFogyTHFDR05BZE1hIyU5tO+dAyy0mi+HZ0ybhuuFM2eQGK2VdSi8UtP6KUJHXxIjLO8EDh9Xv+oX9pkUE9bM8v84+lvWPTrAUv081oKHn5tP+/xsHSXQdtkfBqx9WP30RTS+eDJz4QG4jTTtHDZHaxXahfbkDCc796mvgBDxdLxVBhObgcoQ4Q2zRiFSiXt6bOnUHHkcnpAIvyOrjeqkVo4NisxViswma3kJj6O2tuJYu3/hPN6zZTHGXn0EDveGZ3LMhir5BhIJKJG6Gcsc3IJOQiPoI5VuuJA2n97FK/EXbQ5gb7kNdSUrr7mEbb433cJH/u1fykzp7ksRYP765NDO2+kk/dohRO8UyW5eKfmdFEEU5D3LTCtlUD3VACLRPMkLZBLSJPEIlCx//pP3N74KcNNUac+vqZUHtAhNtn/7lhtHv5W64/t/JmI/YRZmQ4DgGTejpF0pmR8kQQoHKz+vBa87cOMLoLB5dqT8g7TDYz7xxGsPWmYxGE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(31686004)(66556008)(316002)(8936002)(66946007)(6506007)(186003)(36756003)(53546011)(66476007)(6486002)(86362001)(6666004)(508600001)(5660300002)(26005)(2616005)(2906002)(38100700002)(6512007)(8676002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bDFrODk1c2I4MFMyKzNTTWhmdTRDY0pmcitzRVMxSmJBQmlOYXphSWphTWFP?=
 =?utf-8?B?MHZ3T0xmdnFYcWQwVzZQbmoyaGk0bFdpZFg4MEQ3cEpTOEs2cHJORjlpSU9p?=
 =?utf-8?B?M1hMM0R2YXVKMkVqNnVMS2kvaWIrWHpkOEZkcDE4RlBWVGQ0OTJTRThZZmFV?=
 =?utf-8?B?NEVFamU1UUlFdk9xRkd4cWYyUzFLOThuQU9QNUU2Mk9QZDV6YStVWFhlZFJF?=
 =?utf-8?B?bEc1cVdvZVQvVGFHZXFzSys0Yjl2RUVtN0tnZVZ5WVQyYUxTRXBxcmhaT3NJ?=
 =?utf-8?B?Mk5YeVFPL05LMlRia2prNENpYkNGbzRYZWY0N0J5OEEyR0p6YVlrNnRtck9L?=
 =?utf-8?B?ZzlqVTkvbEpxSmVIb3o3UDBaZFo0RjNMbmdNYjFHS04yanZNMDR4dlJpMW52?=
 =?utf-8?B?eEFZRHVxVXVRQkpWSlF5T1pCYWZHU2Joc21DZUZSUXhGZ0lnVDdSMXJtdS91?=
 =?utf-8?B?d2VwQU02K2MwTXpwWkRIZEJEMzhGOWdCUDdaUUppblBiK0JZQXRta05vcW9k?=
 =?utf-8?B?M2lKZVRld0pzWnFkWVB4cTZTdDlhMnV2TlFIR0QwOTQ2b1o0ZEgwZXdJWTFS?=
 =?utf-8?B?TlJ0eWlueWVLeUhtbVZ4NmxReTdyQ2JiVlc1SWVodHJxZ0xmWHFqelZMVmRT?=
 =?utf-8?B?Z1N4OC9yWnp5S3dFNzh3ZXF6QmJ4aUp1K3ZwRFNhbWdkSDlwekxwOFZ3U2RY?=
 =?utf-8?B?VC9CUUhXNElHZk84RUtLQ3hDc0RZOERad3ptbm5VZDNHRHFYcElvT1dFaDRQ?=
 =?utf-8?B?dENvTmYwTzZuQ1Z1QnkxOEMxTzR0Y204QW5LMnlRSHZ1Z2orN3VqOVVWYllj?=
 =?utf-8?B?TWZtcmlZWWs3K2VmK0x5UUhmZ1dJRURtdTNZaDBtNWlVRk13SFhkak90MHp1?=
 =?utf-8?B?Tm9zNVFrRWV2bzBzVjdHUlVPRjdQV0pqTUtYOFdvRzhIVThhVEVERktlUkM5?=
 =?utf-8?B?MmUyM0xKRXkzSk1Iemw1VDN5amdjNlNCN0dxV0piOVFCQVF3VEZ4RWRHNGdk?=
 =?utf-8?B?aXpqVFZiWk5heXNKR2JMZUlKRXA4ajhRQVladmEzRmJ2MGhEWXBjQkRia2h3?=
 =?utf-8?B?aHhtVjhwdDZkNFR0Q3JMM1J6RWpUa1hLNVI3V0JWWGowanVBdnRKamF4aWti?=
 =?utf-8?B?RUJqaVh2d1IrQ2hNMlpQSzIwcWtHUVYvQ1JiUElLUGxJV3NqZ3BKMm1BQ0VQ?=
 =?utf-8?B?TStUUkh6RjQzZXJlWWd5NThqSXB2aW8vck9kMjJqd2RPZjVBeXVKY0p5ZFl2?=
 =?utf-8?B?aU5YSGVMdk5OMURRMnMyS1pTdFZvczNBai8rUlVkZzVxWmVWMkZiMndRWE1u?=
 =?utf-8?B?VVIxU3VDNzZ3Um1vUyt3VmR2cHpLSlpqclpOMnRZRkhUVzBxNjFoMEkwVDdv?=
 =?utf-8?B?YlpMdm4ySXJjTjJRMmpVL3MyQnMxaXZQNTA0OU9yajZPdy9XdU54QTJhUmtz?=
 =?utf-8?B?eXg5cTBKQUpCU3Q3QWpUVVVUMEZvL0huUnM3YXd3OU12M2tiVnR1dk4yaHQz?=
 =?utf-8?B?Ky9HMjRSOUpLVVd3d3dUbW0xSVFCb1lKRWFsZzBRek85VXNPR0Y0V3Z6SEFB?=
 =?utf-8?B?MnJGQytIaFFyMTZhU0tWTURDMnVrODhJd0hZUnVWOW0vUE5zRzJLdGFkNTJF?=
 =?utf-8?B?ejlhMDhDSzd4Sy9nb0llaW4rU3BZS1UyMGFHTEdRTFMveGs5MEJ5MDRZMDJl?=
 =?utf-8?B?K3AyRU11d1daWXFMcUZQTWtuSnQ0aW5iZUljVFE5NVpORlJuTERaeGl6bnZE?=
 =?utf-8?B?U2ZsdmNpdEluUGgrK2NLUldtRnlTSzB1QjlFMU0vV0tWQTdIcS9rWktoc0FJ?=
 =?utf-8?B?VHNCNVhKSllTVE1ucHM0aWxtMkwzT0JLYk1jeXJYTUxCWldQdzJQZmNTbEw0?=
 =?utf-8?B?SmwxNFlMd29uN3R6aHVOQlovYjN5WU1BSE9hRU9PYUQ3RzBhTTJ1MWFSNGlN?=
 =?utf-8?B?U1kwdU5KZUErZlVIdm5pSmJrWVpRRUlDbWJMS244NUNBLzR5YjBmNDEzTExy?=
 =?utf-8?B?TmtHWnFSVTRBc1JYcjlzN3FnNWI3V01CSXNrUlhPTzNHU0Job0ZHd0RqSytT?=
 =?utf-8?B?ZEVrQXUrVEtnZDFFcmtCWDkrSHo5cGRzV3JXM2w0RGQxWXRTc2FZV0diU1F1?=
 =?utf-8?B?cFNBTFJ6dFJPMi8rUjB0U216clA3c0FKRXV5VjNLeVpxWS9ubnpic3ZrRCtl?=
 =?utf-8?B?VFRMeTlOTzBxdEE2N1RZUkoyeFZYcGlTV0k0Qm40N1dOL1ZETWdsWnNFQzRk?=
 =?utf-8?B?bnR4Z2RzaFdLK0krM3R0QlpFM2dIZlhwL2lIeXpmeEtFWU1xUHE1WGtFdU9q?=
 =?utf-8?B?aHh0SUoveGxOL0Y4SWJrd0tSRkhYZlhLWFRPb29GM1FLcjlFM0QyUT09?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74e21fdd-9dee-483f-0372-08da1264b34e
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 15:48:14.4516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ph7ydYPLoXIBBLnvV4Q9iShfZF8OMGbHMByLTQBMTbOBeFDOJuVgKclMtOjXmiQB2jJ0nBCjET6Zi7JOR7thKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6339
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/29/22 11:03, Mike Christie wrote:
> This patch moves iscsi_ep_disconnect so it can be called earlier in the
> next patch.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/scsi_transport_iscsi.c | 38 ++++++++++++++---------------
>   1 file changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 27951ea05dd4..4e10457e3ab9 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -2217,6 +2217,25 @@ static void iscsi_stop_conn(struct iscsi_cls_conn *conn, int flag)
>   	ISCSI_DBG_TRANS_CONN(conn, "Stopping conn done.\n");
>   }
>   
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
>   static int iscsi_if_stop_conn(struct iscsi_transport *transport,
>   			      struct iscsi_uevent *ev)
>   {
> @@ -2257,25 +2276,6 @@ static int iscsi_if_stop_conn(struct iscsi_transport *transport,
>   	return 0;
>   }
>   
> -static void iscsi_ep_disconnect(struct iscsi_cls_conn *conn, bool is_active)
> -{
> -	struct iscsi_cls_session *session = iscsi_conn_to_session(conn);
> -	struct iscsi_endpoint *ep;
> -
> -	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep.\n");
> -	conn->state = ISCSI_CONN_FAILED;
> -
> -	if (!conn->ep || !session->transport->ep_disconnect)
> -		return;
> -
> -	ep = conn->ep;
> -	conn->ep = NULL;
> -
> -	session->transport->unbind_conn(conn, is_active);
> -	session->transport->ep_disconnect(ep);
> -	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep done.\n");
> -}
> -
>   static void iscsi_cleanup_conn_work_fn(struct work_struct *work)
>   {
>   	struct iscsi_cls_conn *conn = container_of(work, struct iscsi_cls_conn,

Reviewed-by: Lee Duncan <lduncan@suse.com>

