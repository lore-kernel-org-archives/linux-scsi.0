Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3469C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 23 May 2022 18:42:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbiEWSmq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 May 2022 14:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239811AbiEWSmY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 May 2022 14:42:24 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BAF8195E9D
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 11:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1653330187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=izENrmT9Wq3bcGNlR5lLtdkfwBocf80tsoRwbglfu/4=;
        b=HqAWmc46EJaWy0fe4+j0UraMOSuthF3q2A6q1HOu18f6zBwwwCDtRa1QcXbJW7V+IHMzDz
        ITQP+AB5Cf0/L6TyGhri1PVJm6ma/MqGFuUmd3zxzKD/YmrQIvjonK1sit3cvh3XWwS1Lz
        hzQb97SLrCKVurv6+TrR0aE6X+ls7A0=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2059.outbound.protection.outlook.com [104.47.13.59]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-7-c2VZHD4qM3iDJ1CiRGtVww-1; Mon, 23 May 2022 20:23:02 +0200
X-MC-Unique: c2VZHD4qM3iDJ1CiRGtVww-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hBvu0inkcRgwTjzkKKz3vVPLdCX5L3NwsHH4GnJOWlabGbcffCXugsuflf0dXct/g5YyJYCzjXrmiypU2jPhDcPs9Y+rNwzOk872HQ7qtnN6+K1yYz46PS1GxCkhFuQXWKVberTMTLXESzq011UwFZWsJ2pGn/hdqowucS54bdG0v7rDHGa/t+6tyIaSE05pW6upEtw1xJ3X/tLa75iRI0QyPdKm0bKVuuK1XqFDF723fz3ivEcYp+d2Munn2xHEc2TvXRWMHZA5ysTpR5q3fPNFV5xxpXDL3mMmDqVFkKeskuf81W/a6SMU0Qbty2ZRAZmSwhomHuuqRuckap+EhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=izENrmT9Wq3bcGNlR5lLtdkfwBocf80tsoRwbglfu/4=;
 b=RY19ZvOUwO7lrxv2bGcowOm/8UNZpCerQOccnkNDrAbNXHRdhdPhCfFJa8HquQeqx6LE4JNOZA66nGsEo60BYrK1EiXo6kwaNPWARtz17GCnvRe7YK5PkmTOCsx4EgjP5H3VFmzawQB8A24XkzmrbxtzA2pgjHTw90HIu/IsL5sReVf6qZVDIHnO2PcMFD+vTChwWkoIQ20Ym2+qTx4PNdrMbJ/Pbswy0gvCXxtL8kEIKaE4ZdaH5D19dyIZNTAZHiDz5DUnVwuipZsWPjhTmA1eiUhdcBw9ejTxFWOTY44oEhRbiqs7rnA+WxBQe9UuSva7H5PmuOadNiE/8wXVEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AS1PR04MB9630.eurprd04.prod.outlook.com (2603:10a6:20b:475::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.18; Mon, 23 May
 2022 18:23:00 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::541:b6df:93f7:a5f9]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::541:b6df:93f7:a5f9%4]) with mapi id 15.20.5273.023; Mon, 23 May 2022
 18:23:00 +0000
Message-ID: <529cfa5e-97a4-6d4e-db86-b06cf6462372@suse.com>
Date:   Mon, 23 May 2022 11:22:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v5 2/3] scsi: target: iscsi: extract auth functions
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, linux@yadro.com,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>
References: <20220523095905.26070-1-d.bogdanov@yadro.com>
 <20220523095905.26070-3-d.bogdanov@yadro.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220523095905.26070-3-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0732.eurprd06.prod.outlook.com
 (2603:10a6:20b:487::31) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 41d724d1-ccb8-48c0-186a-08da3ce944bb
X-MS-TrafficTypeDiagnostic: AS1PR04MB9630:EE_
X-Microsoft-Antispam-PRVS: <AS1PR04MB9630A9DDE1230F92FA00A8B9DAD49@AS1PR04MB9630.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xwfdXI4qTfwP/qUF57bPkeAIr4SBrMlhPLbJvqaIh0aIsolk2qMyBEgYEdF+yfJqCc3UFlrcGmrPP3heLXERgnIONtcHWhwsa7uKHJg8kGc/ZreOVPCSgeMMOzXEbnxx/iz5WCfk0hz0c57Rn2exYdaIWln6ZHmktO44QF669pwu377VvG6HrfAk2FujvEQK+QA1hn+ppJqvN6/UQBQBlwV4ChUSV2oPGXxnNpMlb19KbJOnEmjWWRmKDdCxTJBNAjXgaoGI+D6wO2XJxCdGhzn/FVdT7iu0s3PnKWx7gUdkTV7MRM4A1UvQeZJWq6c8baaZyokpZlh+11Vma/v+EepIuRzRbZmGfOstUGSIbOOhE3sFO9htQOe85olvc6+n5adz1H7GsKQehYvgrDeIAuO9F8Jn81aD299PkjdMFYORIWPh/S+LBVzOSQE03tNstW09guHSJ6ITS9ywe+iBzVBPjwrkw6/1tXgklEMGxSrM9c4CFM11OcpsLlNNIQ56w8VeRHInBgPxrEzN7fuy/aahKwu+9OY1+A1gReviefCr1ge0/0Y0VSkPnbDod6P6dkcV00dapqedXEM4zFW6bus8gty9eWk7tDVaq+mXFXWDC4I/hIrvm+8nYIMDR0kX4WoFdQUFYSWQi2MsVEHN/0TG/YY3sFe7dt1x7P5/VNUwlW+V4u+FntsjPAdim7GsBsi9UVbPKfwfs3zl8FjBYht5tZfgsulYU5QQnE/6xqCuSRr11XjOgG6IFui0Hede
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(6486002)(38100700002)(5660300002)(508600001)(4326008)(66946007)(66556008)(186003)(2906002)(31686004)(6506007)(53546011)(8936002)(8676002)(26005)(6512007)(6666004)(66476007)(83380400001)(110136005)(54906003)(86362001)(2616005)(31696002)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NjByS1hwWndsVFM5YitXcFRmQSt4Zzd0NGpKdDhFYUFUTWtiUDVPd3N0MkRF?=
 =?utf-8?B?YjdjTysrRkR3UXhRSGQrUHJHZzJuQlV0WUxrK1hJbG96b29TTFl1L0ZwUzZl?=
 =?utf-8?B?WVJrby94cG83VWgxd3NjNGUxSS9UZG14eGExc0Q0WHhMZXNZczlITHVGQTMv?=
 =?utf-8?B?cG1iRHRHRXJkVE5rUnh1Uzk3ZWFoQy9UMmZlVkU2dUVoUS9hNzBzTC9RcXZW?=
 =?utf-8?B?VkVYeHdYbkNqaTRJKzdPbGlyUEFNS2NqYSs5RXI3TDZZTHlQdG5UYmdxTmtE?=
 =?utf-8?B?aGc5TWZ2TnlIUVJzNTM0MjBaeUJvbWZjWEdweXE4RUw4NVpwdmxYR21iMUQ1?=
 =?utf-8?B?OWNDVVFGQ1dhanIzWDBwWHZldUplczhxbENIUW5yYW9sb3RHWWorVTlkS1Ar?=
 =?utf-8?B?cVNSN00xTzJZY1BWQXY3UEE3cXJpY0oxbTQ4Tko1OUkzL3NDM3hHVWxEWkN0?=
 =?utf-8?B?S3YxNVppY2pDWFlGOHltOXlaWW9wUWZMVGV1VlBKaUNMdjI1RDZLamRhVUxw?=
 =?utf-8?B?VFJkUWJzbExWMGNraXR0TU16a09YdU8wZ0Fza2VveGlCU1A2dnY2OERYNXBk?=
 =?utf-8?B?YXJlUTZhNmVzdDNhYXhDOW1aTWZaaFhvQTBKKzRRQ0pHUFd3L1lTU0pzVzd0?=
 =?utf-8?B?RzJDRVlteDZRSVZDbDhGR0lOSzhVaVlxUWkrWjBUaEx2VzlNRGZSY1ZqNXdV?=
 =?utf-8?B?Zm9FejlodDVvMlpBckt6QzZkRGxLREI5R29yalQ2OTVGbG1LZnFlNndRV2Z2?=
 =?utf-8?B?Q1lWK1VoMHkzM3VkK2w3dTF6aEgyeTRyeG1LRlZtb2FGaWN6QzQ0MEFyNEdy?=
 =?utf-8?B?ZU1jVWk0VFlUOWN6UDdBUWRreWJQTWtuTXFVRVdyQnRNdE1VOGR6eGZSZHlB?=
 =?utf-8?B?RVExR0FsZHErZGYwbk04VHdaVXAzUU1VWVIzU0RJNy9QamVwcjYwNmZhNzNk?=
 =?utf-8?B?MWZUQ21XUFFoQzlsWEJ0ZnVaU3ZDOWRzZ0xBWVcramFnMnZNd25sTWRIcjlq?=
 =?utf-8?B?TGtseWJLbWR6OVdkdTVMRHE0cDZVQ1BzcGZac2NERUZVb1lCM3pWb3FLRllT?=
 =?utf-8?B?UFZyczdCRkJXcUR3RGUwNHJBbHdoTWtmQll3WEN2OUNjSVVOckNremttSFk5?=
 =?utf-8?B?eDlTczMyTVBaSlk5aGdOTkNDQmFMNFU4YWl2REpaTVAyZ1BQSmxLemVwaFJm?=
 =?utf-8?B?K3NCdnNhTEltZ1ZCQTVoWHd4NVlwa0dnaVdNSFJRY2ZDaVVxTXNDeERENVJv?=
 =?utf-8?B?c0t2SllEcmFNb25QQTVaQXJ1NHYyUzNSdXBwQWxXTm9NTnRTbWNLZVVGWllq?=
 =?utf-8?B?cDJwa2hQcU1HNGNVQm9DOERzTVpEKy9qdkRtaDdVdkhiOXpDVlJKRVB3a3U5?=
 =?utf-8?B?cHR1bmM4YjlWNU4xaUZScldMcFJNSU01V0V4cWl0aVgzR0FlemhTenN5NGo4?=
 =?utf-8?B?Z0dJS0hQWnpBdnRoTyszT2JwcGJON2d0S05zdjRBL3l3OFdyUEhjeDIrRk8x?=
 =?utf-8?B?cWtjQ2Q1dWVOR0JmKzBlMCt0VkVpaUhRUXpRYkpqMG1lS2lBTnZyWURVMk1V?=
 =?utf-8?B?RnE4REFEN0tidlRkalQ2UmlHb29WWnZEYVhkL3JJazRFK3hRR3BUcXE1UFNF?=
 =?utf-8?B?c0o1R05hbkFKK29LUUNBL1dVb3FFMHQ0L1NFY0pMM01GNGZkU0tOUEU5QlBm?=
 =?utf-8?B?bUVTS0lSaDJnR3g1dFYwR0dZbGFYZGhCZkNneHdrZVBSMnhpY0p2dHFlQ1p1?=
 =?utf-8?B?aDQ5WjgxVzh2RU5lT1VuRGhLd3NHZHB5cDJvS0YyMEcxckt2UTFwOG1USWRW?=
 =?utf-8?B?Vmo2NUI4Q09WMnpVYzZjSm1XSE1kVnlFK1ZiNEluc0x3ZHpkQUh4bFNDTkhV?=
 =?utf-8?B?V216SWczM0FhTDNLUFZBdks0a3dEbnU3aE1Kd01JbzMrb1hrR2ljKzhRbE1V?=
 =?utf-8?B?VWgxZUEzd1JwcE8xWVU5dkhKRnJDU2VNRXJjMlZIY2lOOGRHQnFJMVFKMXZL?=
 =?utf-8?B?OXBCMkx3UEFHeEVwSHdCYVpneldNcncvL0hCejVQK3pGdG9NOEVVM2FiMGRH?=
 =?utf-8?B?Nk11OFJXRThDSVQxUitsYUhLUU5VZkRWdnJMbmFwdzNtcXdYTC9hRVlqWkoz?=
 =?utf-8?B?YThLNEhNNStqOVVobmtsQnd3cisyTkhKdGhvWFJUUTN0cEIrOFBJTGtaQTZ2?=
 =?utf-8?B?aklxVUs3dHlQZ0FmNjBBb3JDRkRsN0pRV1JURU1TQVBCU3BQeThzWHFkeWZp?=
 =?utf-8?B?U1FUdTAzaXoxeWVkeVlndUZQVGF2alF2Q0g5eEJSSzZwNzA5QzJrMU1VcWlB?=
 =?utf-8?B?OWZscjgyc2N3eFBESzdHOUkrL2RmM05TWGttMXVIcFlLVERRcHJlQT09?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41d724d1-ccb8-48c0-186a-08da3ce944bb
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2022 18:23:00.7317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wF9gWhaynQFuJG+mDcQjf07VqoT7t1G2GuP2LWrDZUuiY+z/yREglDefBye0xFCFre7vJ7q9g8qdlNfv2zTOPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9630
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/23/22 02:59, Dmitry Bogdanov wrote:
> Create functions that answers simple questions:
> whether authentication is required, what credentials, whether
> connection is autenticated.
> 
> Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
> Reviewed-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
> Reviewed-by: Mike Christie <michael.christie@oracle.com>
> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> ---
>   drivers/target/iscsi/iscsi_target_nego.c | 140 +++++++++++++++--------
>   1 file changed, 92 insertions(+), 48 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
> index d853bacf1cfc..f06f16d63fe6 100644
> --- a/drivers/target/iscsi/iscsi_target_nego.c
> +++ b/drivers/target/iscsi/iscsi_target_nego.c
> @@ -94,6 +94,31 @@ int extract_param(
>   	return 0;
>   }
>   
> +static struct iscsi_node_auth *iscsi_get_node_auth(struct iscsit_conn *conn)
> +{
> +	struct iscsi_portal_group *tpg;
> +	struct iscsi_node_acl *nacl;
> +	struct se_node_acl *se_nacl;
> +
> +	if (conn->sess->sess_ops->SessionType)
> +		return &iscsit_global->discovery_acl.node_auth;
> +
> +	se_nacl = conn->sess->se_sess->se_node_acl;
> +	if (!se_nacl) {
> +		pr_err("Unable to locate struct se_node_acl for CHAP auth\n");
> +		return NULL;
> +	}
> +
> +	if (se_nacl->dynamic_node_acl) {
> +		tpg = to_iscsi_tpg(se_nacl->se_tpg);
> +		return &tpg->tpg_demo_auth;
> +	}
> +
> +	nacl = to_iscsi_nacl(se_nacl);
> +
> +	return &nacl->node_auth;
> +}
> +
>   static u32 iscsi_handle_authentication(
>   	struct iscsit_conn *conn,
>   	char *in_buf,
> @@ -102,38 +127,11 @@ static u32 iscsi_handle_authentication(
>   	int *out_length,
>   	unsigned char *authtype)
>   {
> -	struct iscsit_session *sess = conn->sess;
>   	struct iscsi_node_auth *auth;
> -	struct iscsi_node_acl *nacl;
> -	struct iscsi_portal_group *tpg;
> -	struct se_node_acl *se_nacl;
> -
> -	if (!sess->sess_ops->SessionType) {
> -		/*
> -		 * For SessionType=Normal
> -		 */
> -		se_nacl = conn->sess->se_sess->se_node_acl;
> -		if (!se_nacl) {
> -			pr_err("Unable to locate struct se_node_acl for"
> -					" CHAP auth\n");
> -			return -1;
> -		}
> -
> -		if (se_nacl->dynamic_node_acl) {
> -			tpg = to_iscsi_tpg(se_nacl->se_tpg);
> -
> -			auth = &tpg->tpg_demo_auth;
> -		} else {
> -			nacl = to_iscsi_nacl(se_nacl);
>   
> -			auth = &nacl->node_auth;
> -		}
> -	} else {
> -		/*
> -		 * For SessionType=Discovery
> -		 */
> -		auth = &iscsit_global->discovery_acl.node_auth;
> -	}
> +	auth = iscsi_get_node_auth(conn);
> +	if (!auth)
> +		return -1;
>   
>   	if (strstr("CHAP", authtype))
>   		strcpy(conn->sess->auth_type, "CHAP");
> @@ -813,6 +811,37 @@ static int iscsi_target_do_authentication(
>   	return 0;
>   }
>   
> +static bool iscsi_conn_auth_required(struct iscsit_conn *conn)
> +{
> +	struct se_node_acl *se_nacl;
> +
> +	if (conn->sess->sess_ops->SessionType) {
> +		/*
> +		 * For SessionType=Discovery
> +		 */
> +		return conn->tpg->tpg_attrib.authentication;
> +	}
> +	/*
> +	 * For SessionType=Normal
> +	 */
> +	se_nacl = conn->sess->se_sess->se_node_acl;
> +	if (!se_nacl) {
> +		pr_debug("Unknown ACL %s is trying to connect\n",
> +			 se_nacl->initiatorname);
> +		return true;
> +	}
> +
> +	if (se_nacl->dynamic_node_acl) {
> +		pr_debug("Dynamic ACL %s is trying to connect\n",
> +			 se_nacl->initiatorname);
> +		return conn->tpg->tpg_attrib.authentication;
> +	}
> +
> +	pr_debug("Known ACL %s is trying to connect\n",
> +		 se_nacl->initiatorname);
> +	return conn->tpg->tpg_attrib.authentication;
> +}
> +
>   static int iscsi_target_handle_csg_zero(
>   	struct iscsit_conn *conn,
>   	struct iscsi_login *login)
> @@ -874,22 +903,26 @@ static int iscsi_target_handle_csg_zero(
>   		return -1;
>   
>   	if (!iscsi_check_negotiated_keys(conn->param_list)) {
> -		if (conn->tpg->tpg_attrib.authentication &&
> -		    !strncmp(param->value, NONE, 4)) {
> -			pr_err("Initiator sent AuthMethod=None but"
> -				" Target is enforcing iSCSI Authentication,"
> -					" login failed.\n");
> -			iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
> -					ISCSI_LOGIN_STATUS_AUTH_FAILED);
> -			return -1;
> -		}
> +		bool auth_required = iscsi_conn_auth_required(conn);
> +
> +		if (auth_required) {
> +			if (!strncmp(param->value, NONE, 4)) {
> +				pr_err("Initiator sent AuthMethod=None but"
> +				       " Target is enforcing iSCSI Authentication,"
> +				       " login failed.\n");
> +				iscsit_tx_login_rsp(conn,
> +						ISCSI_STATUS_CLS_INITIATOR_ERR,
> +						ISCSI_LOGIN_STATUS_AUTH_FAILED);
> +				return -1;
> +			}
>   
> -		if (conn->tpg->tpg_attrib.authentication &&
> -		    !login->auth_complete)
> -			return 0;
> +			if (!login->auth_complete)
> +				return 0;
>   
> -		if (strncmp(param->value, NONE, 4) && !login->auth_complete)
> -			return 0;
> +			if (strncmp(param->value, NONE, 4) &&
> +			    !login->auth_complete)
> +				return 0;
> +		}
>   
>   		if ((login_req->flags & ISCSI_FLAG_LOGIN_NEXT_STAGE1) &&
>   		    (login_req->flags & ISCSI_FLAG_LOGIN_TRANSIT)) {
> @@ -904,6 +937,18 @@ static int iscsi_target_handle_csg_zero(
>   	return iscsi_target_do_authentication(conn, login);
>   }
>   
> +static bool iscsi_conn_authenticated(struct iscsit_conn *conn,
> +				     struct iscsi_login *login)
> +{
> +	if (!iscsi_conn_auth_required(conn))
> +		return true;
> +
> +	if (login->auth_complete)
> +		return true;
> +
> +	return false;
> +}
> +
>   static int iscsi_target_handle_csg_one(struct iscsit_conn *conn, struct iscsi_login *login)
>   {
>   	int ret;
> @@ -947,11 +992,10 @@ static int iscsi_target_handle_csg_one(struct iscsit_conn *conn, struct iscsi_lo
>   		return -1;
>   	}
>   
> -	if (!login->auth_complete &&
> -	     conn->tpg->tpg_attrib.authentication) {
> +	if (!iscsi_conn_authenticated(conn, login)) {
>   		pr_err("Initiator is requesting CSG: 1, has not been"
> -			 " successfully authenticated, and the Target is"
> -			" enforcing iSCSI Authentication, login failed.\n");
> +		       " successfully authenticated, and the Target is"
> +		       " enforcing iSCSI Authentication, login failed.\n");
>   		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_INITIATOR_ERR,
>   				ISCSI_LOGIN_STATUS_AUTH_FAILED);
>   		return -1;

Reviewed-by: Lee Duncan <lduncan@suse.com>

