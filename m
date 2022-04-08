Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5229CC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 17:41:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238380AbiDHRnF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 13:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238324AbiDHRmx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 13:42:53 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE21990FC3
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 10:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1649439646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eiUE8swStjmMWByK+MV4SocAjP0m7E6OHmOVkn6A7pk=;
        b=iQAX4HiTEjn6klcUS6ewCMCdJURo5qW/LTagZY+d0Cq4xxZtapBt3M/aPU4jB6rDMsk90a
        1xXXL21VX9bUeCjN7HAUXZgEl8wR62auu3Kt0OLzqw0cwwbwh7PGpoQi7PUMMpk7YTcFck
        pzX3M5xthrc4VeYatjlL7prEyYTgJGc=
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur03lp2058.outbound.protection.outlook.com [104.47.9.58]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-23-JC6WnB3PMnChe32C13jYiQ-1; Fri, 08 Apr 2022 19:40:44 +0200
X-MC-Unique: JC6WnB3PMnChe32C13jYiQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KQdBgxGs0Qht72Qw/J8a+17wV7Wx+Z+uyrtgv8h91t9aVyl8+vl/VwAz71PxSMYDy1tOWsBO+eLEzLOpMCc3GALPLH9X/CXzafaSl/p1YjGH6QskaCabaDg3qn+RV8Jp2CvImwJ76h45Jv/J1bM3kUg+rkYQZlWQXW3cPfZLAiSPUzNw9zecR5XLYoWoyVFRWPEDafdI0mrJMkPJZ5oFK267pIx89a8AStwrSTuaZc1WNu79ZFMaeBwBWtXSqX68EQlqHA/610Zz1vMFhBjesWVnEseYh8ruoe42xal4BPGzE7Q+KAJydcTtekFz3C3JaF4VITqoJpiwXGa0Gi4aCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eiUE8swStjmMWByK+MV4SocAjP0m7E6OHmOVkn6A7pk=;
 b=Z0sQrcwUEmm8zmNXZxXRS5DS+UZzrJOLIWyb8THyZfhzQc6jgMyIFTCVsf4VZqt1AhMPwSjYW+6Nh+ktc1ZY2/JFHBLXD0e1htgixRjLgKa6ffYVZ0QuaV8gLrWeQc5mHTJzFLxWTZAvwQtqURew40oVpBdV96tUmsnisvmD90XKN43PhTUGFc6mp9xlEn+UdDUmUoVtBcXi12ohN3N4Ocy6J4ALORU/6gsm6iVZWnK8G/U1gRSk0rNOL5I3yt1D47U74x/KVEAxeiM9R6RXmRQtu9qWq3i4tgrFBUAQgOwOCvOy/EBhJvzzJWeWg1gYibEYxbydb1LYR/dX+5aaPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB5864.eurprd04.prod.outlook.com (2603:10a6:20b:a6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.25; Fri, 8 Apr
 2022 17:40:43 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::6859:e5f7:b761:2d]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::6859:e5f7:b761:2d%6]) with mapi id 15.20.5144.025; Fri, 8 Apr 2022
 17:40:43 +0000
Message-ID: <f4d0100d-a435-91bf-9f0e-5d3f3c88ec04@suse.com>
Date:   Fri, 8 Apr 2022 10:40:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 04/10] scsi: iscsi: Fix endpoint reuse regression
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, skashyap@marvell.com,
        cleech@redhat.com, njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
References: <20220408001314.5014-1-michael.christie@oracle.com>
 <20220408001314.5014-5-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220408001314.5014-5-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0037.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::19) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 873f0930-319f-43b8-0215-08da1986e81c
X-MS-TrafficTypeDiagnostic: AM6PR04MB5864:EE_
X-Microsoft-Antispam-PRVS: <AM6PR04MB5864DB3ED78D79679E55F4A8DAE99@AM6PR04MB5864.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JkDePw86IJKlcDtdDkjFxjpeHIRlSJKGvlhKGmMoSqkWe2y0wBrYzA4L0lvEIPteVdrJQt0H3rWhbOoyh4900BsFwBbaVPAsIAzb0qjt6ll5xqxlPR/2IJgb2DTqBe/FGFdg1owJ/3OMHceae7OF6VhW6WTmzh0r7/dnCI1Ys86AhUR67OzK99yzqQa0ZfmPB3dJBomxtDOrU011BSKxclbKi1aXd3KlG/4TCs+nqYtwAYPn+4HFipgG9H7fToO+WLRSxj2DNppfjHrOdgCBb5LZAywKm6/gJWoks+2ecG6Aou+UcxMeschCAL+50c6jrsGHsU90HTNzMlixonyls3TP9DOvBWr6/t4nXDGDDyLALBxpnI4h6Ij0U0fG1B/bIT35P1onZPnQApwgYuGA/xOTpAbTjF5b5UokCWajZUAOMFMJTZ5bjFmPGmDubUmisH3/wPw8prWxdtVjEYcsOPHLs/jAEgFgZO7Aqq+8jKaTsfmm58aS/Mjm0S54CToBwhtRFY47fxec8Ca0mOkLMeM5jug42y7Tu3j3nJKoEraY7osPSkEa0ABWrqh8OIsqSRd/oZ3BO1DP0+LIfx0O455/6Sgn8y7KCFr/hD19XizTR7nMN5WagJSHiwBWlaSU7sxz3X0SihXb7KpjLfMFlgvdhuosTnxjkVO/FVUCEsNBfFRVWHceFUFWnDtWGrk4YFzCO45GwpQnsy7Qjek82AEee2qhXR/SnQa0KqxllIQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(38100700002)(8676002)(31696002)(36756003)(31686004)(66476007)(66946007)(66556008)(53546011)(86362001)(83380400001)(6506007)(6666004)(6486002)(2906002)(5660300002)(6512007)(508600001)(2616005)(26005)(186003)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WE91dVFSSmovOHgwYTBaSUV0WnBRaXB1eUJ6a09UVTBZVzNIeWQ5OExqajIx?=
 =?utf-8?B?dms0V2xYN3dlUS82SnM1MWFFK2pOWEk3eDJVYnVMVEE0dTVDYUdudGlsbDc5?=
 =?utf-8?B?WEhNc2phcldYWFdNRndXWGVLMjAwSnAxOUg2TFJLRlpGbDJpdTlzeWZzd3pE?=
 =?utf-8?B?U0dBOVo0L3NLZnpGVHVUZmRXZWduYWl3TjFFQkwzSkNYQ21iZUhDT2FFNzcv?=
 =?utf-8?B?K2VlVndyVTNUQUwzNTZEQjJqazV1OUE0bmM2eXFPVHdRbCtQZmY5bDFPYjdy?=
 =?utf-8?B?TDdWNEIyYWhaU0d1MEtiaEREeWxQdEJwSjRUb1VZMzFZMHIxdjhKeFZhQm5O?=
 =?utf-8?B?SGRFUzhNeUFacUEybVhqWG1GcmFqbGZwYW5uaGZtYkFEVmVjV1Q1SVFuM2hk?=
 =?utf-8?B?YVZQeWxiaW8raEVOVktBdzNZRnVFVVVOcEdjVXBscms5bGpZbkx2MDFrWVVa?=
 =?utf-8?B?TThUcGlvYU5YSkEwNVdmUGRkSG9jMktpUzR4SVAvNXd4VmxUckRQMDF4UXFt?=
 =?utf-8?B?aWlJNU1PYlNYZzVka0dQZmt5UWxDUUhJZmwvc1ZDZVVBM1RYYzc5Tml1d0Vu?=
 =?utf-8?B?K08vdWxqQlI4R1RFenplbWQ0WlV4YU5NL0d1Rm5jZWJqYWxEREVXQjlGZjN2?=
 =?utf-8?B?Q0s4WFdIRWFRQnRrU3dYbWZvdlBGVEIyOEp4K2JFYVplT1NKdE1FMElwVStY?=
 =?utf-8?B?K0JON0hzSmFRTmdEaHAvRVRRcEMxeUN6aEQzQzd4QWVLaXRVM1VYTTY3TUt0?=
 =?utf-8?B?YTdKNGJxOE94d05hZFhVaFNGMGxoak5LSzBETXVMdk5iUnU1d3NlVnZoeHlY?=
 =?utf-8?B?RkRGR1hVeWVJd3V4OWhtcml1QXczdFVEMy94NmxQUnZiU2ZNci91S2kxZXJx?=
 =?utf-8?B?UU5pTmpBOUdkNWpkMXhHdE4vWk9rM3ZNUHk0amFuZENWRUtPMGl0VU1kQVBJ?=
 =?utf-8?B?NWNEWWxZa2VWL3BvU1ZlTXpFV1FWNGVGT24yVSsxRlMwNndXUklLaURKTHdx?=
 =?utf-8?B?aUo2bVZ6eGtFRk93SDFCOWZGalgyTEd0d1ZCMHl2RTlDSEpseDVSSFlQaFNr?=
 =?utf-8?B?dm1kejJPTVhRMEZnNU5XRjNzWW5BMnFJVG5udmRJYVl1aWJ0R0U1bVVaWjZx?=
 =?utf-8?B?WkltUE5pUlcyTkg0eDhMQjljeXdOTFRWTDR2T3lIT1JhVHlMdllyZitZaEtJ?=
 =?utf-8?B?bnZ4MjFtcmRlTlE2TXZ6RXRabnBKdnpOODZhREJ5QzA0cHpzTU5FdjVRbi8r?=
 =?utf-8?B?TTV3UGRzaURpZm5CM1RWZnh0Mjk0aVFTZ014Z0hjQWNtMXhlQ3BpWnUrTTEy?=
 =?utf-8?B?S1pQSzByQ3EreHlHdndlY3VzVmthYTROK0djRnlQSExKbmRMdld6MmNRWXo3?=
 =?utf-8?B?b0o5OGdVVzE2MHBNd3Z1eHJSWlJxZlp4bWdJamQ1RjYxeDN1MUNzYUtlQUpI?=
 =?utf-8?B?OEFMVmNXbjBWbzFtL25zZmhYR3dpU3cyRmZwa0w0RUpDRTUwOXVOWCs4MXk0?=
 =?utf-8?B?ajgrT2FBYVVRSzFuU1FhV1RnRS81TlYranRsSDdqU3I2VkoxTVE0c2M4K0o5?=
 =?utf-8?B?SlJIcVY0NXJ6YkxJRk1BbFFyZFVaajRpZmx5REFnY0xkaFdwWDZFQzVlb0ps?=
 =?utf-8?B?ZFlOcXhVdGwrdCs5T1Jhc2hUMEU2YWdCRzFreW51dXF0Y1l6MElYQnJSN1Mr?=
 =?utf-8?B?OWk3VmNpL3d6bkFORVBzUjUxeUFTYy9DaTJhQklKTnV1cFY2TEw1bWNtczJU?=
 =?utf-8?B?MEFYMG5MMFpQc2RCT09uaHJZTjJGSWRMWkdWdk50WXhpQy9DcDZNT0IxRytO?=
 =?utf-8?B?dGcyUDRWTW1hc1AxVGYvWU5aZFBSOVBHNmRPMG50d0c1LzZUM2dZRTNNbVMr?=
 =?utf-8?B?N090SG5UcHlodldDcm1UMUlSeDV6MnhKbFBuYWU2SUs2S0w3Vk9WSU1xTmFB?=
 =?utf-8?B?RmgrQ2l2ZlhJdjZ2U0c1Zzk4ZjI2V2NTZCs0dWh0YS9jWDRSY3lMcWVCTzh4?=
 =?utf-8?B?UnI3cVZMRC9RVGF6d3JXTDBBK3NMdSs1bkRHRmpQUzQyaVlCYjk0aUIvS1dG?=
 =?utf-8?B?OVNEUDFoUG1xWDVwTXVzUytqbjR0dWhwdlc2eGZ4bERMNXZLbURKYmpZd0xP?=
 =?utf-8?B?emp1eTRIMWkyZ2hiaTBPQWNwazF3T1lnMUpHZDlaaGdKczA4VU5uZ0c0U3Ix?=
 =?utf-8?B?bkN0Yk9INFNqYjhyV2tuWVlEb3l5UFpiM3pXN2V6QzdQWk5MYXR4Y3JYYlov?=
 =?utf-8?B?cy9PK1JQSnArQWJhTk5tMEppSDhpOUJlQW5vY1czUUZDTUQvc1lMUkFlSVBa?=
 =?utf-8?B?cUxheXgra1JDTTZQMkh5K0JvbEc4U1NmTTg4MklXSmR4aG9HRmkxQT09?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 873f0930-319f-43b8-0215-08da1986e81c
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 17:40:43.7745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MYmFGp40JJAByYlbjRuoQIBZE9aMaKEchJV/bTecChaJn9fOWfkYpnskhlksaNJajjPaVI03ZC/rIXSWfHJXfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5864
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/22 17:13, Mike Christie wrote:
> This patch fixes a bug where when using iscsi offload we can free a
> endpoint while userspace still thinks it's active. That then causes the
> endpoint ID to be reused for a new connection's endpoint while userspace
> still thinks the ID is for the original connection. Userspace will then
> end up disconnecting a running connection's endpoint or trying to bind
> to another connection's endpoint.
> 
> This bug is a regression added in:
> 
> Commit 23d6fefbb3f6 ("scsi: iscsi: Fix in-kernel conn failure handling")
> 
> where we added a in kernel ep_disconnect call to fix a bug in:
> 
> Commit 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely in
> kernel space")
> 
> where we would call stop_conn without having done ep_disconnect. This
> early ep_disconnect call will then free the endpoint and it's ID while
> userspace still thinks the ID is valid.
> 
> This patch fixes the early release of the ID by having the in kernel
> recovery code keep a reference to the endpoint until userspace has called
> into the kernel to finish cleaning up the endpoint/connection. It requires
> the previous patch "scsi: iscsi: Release endpoint ID when its freed."
> which moved the freeing of the ID until when the endpoint is released.
> 
> Fixes: 23d6fefbb3f6 ("scsi: iscsi: Fix in-kernel conn failure handling")
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/scsi_transport_iscsi.c | 12 +++++++++++-
>   1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 1fc7c6bfbd67..f200da049f3b 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -2247,7 +2247,11 @@ static void iscsi_if_disconnect_bound_ep(struct iscsi_cls_conn *conn,
>   		mutex_unlock(&conn->ep_mutex);
>   
>   		flush_work(&conn->cleanup_work);
> -
> +		/*
> +		 * Userspace is now done with the EP so we can release the ref
> +		 * iscsi_cleanup_conn_work_fn took.
> +		 */
> +		iscsi_put_endpoint(ep);
>   		mutex_lock(&conn->ep_mutex);
>   	}
>   }
> @@ -2322,6 +2326,12 @@ static void iscsi_cleanup_conn_work_fn(struct work_struct *work)
>   		return;
>   	}
>   
> +	/*
> +	 * Get a ref to the ep, so we don't release its ID until after
> +	 * userspace is done referencing it in iscsi_if_disconnect_bound_ep.
> +	 */
> +	if (conn->ep)
> +		get_device(&conn->ep->dev);
>   	iscsi_ep_disconnect(conn, false);
>   
>   	if (system_state != SYSTEM_RUNNING) {

Reviewed-by: Lee Duncan <lduncan@suse.com>

