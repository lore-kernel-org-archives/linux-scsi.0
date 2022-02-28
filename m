Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E721C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Feb 2022 20:09:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbiB1UKa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Feb 2022 15:10:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbiB1UK2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Feb 2022 15:10:28 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326697C144
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2022 12:09:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1646078986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dAV8nDkSg8PeH8KHS+ThdCqINaC1AKaCjpZStQj1jMQ=;
        b=ZXzWOd4COApFCtfv3twPHzuYjj+3qaPyKX1lgp6DL/stR7xcg8RQrsB2FvnE/oiyk7Xsoo
        Jo1lRbft+4mDgEnAnypucAnjtUaqeeQwjmM5mYoimS5o/+UduKxw40ee4Sba7ouLBJ+H00
        mQcwBiD5xW2XxSOtH7Zhw4d8HcQ5mBM=
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05lp2109.outbound.protection.outlook.com [104.47.17.109]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-28-jVvdF-LxNLKUQL3UVdbzmw-1; Mon, 28 Feb 2022 21:09:44 +0100
X-MC-Unique: jVvdF-LxNLKUQL3UVdbzmw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bZPeLJoYmPnEwWMVs245qwQtl6bUjKPLzBgVqHdSqRNGLqEs5aEpzs8/i0XOQ6pAwlLLD/2mypBzOPPJG8evNMUQj4uDmrxi6vwGSpaeBzO9+wQR8r+SE6IBuNd/iSO1umoTQq6IDMItWDpF3ax9ELHAxeP2uw49l+It8pRgBlcqIqoLfzYQE/ZVBqaVXusf57mB0XM2/cspXl1Pb1CJx5Uyu8QgzzcdlMl268/nWqZ52yjGyQAVH6kKScGhnVhEw8vGYdxcbBFSIAhEYbRbRo+aWbYOAP41qSJfrX14JTc3oid+eUCTyLJ1op1B2MiSV4/QbMUVlaZECIqqN7S6ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dAV8nDkSg8PeH8KHS+ThdCqINaC1AKaCjpZStQj1jMQ=;
 b=ZWtqAAE0QAPdycNwmAMwI37ZtgUbQH4lDbeWyxrv5LRJ7fQ5kZ/KJ6pK1ZNmnHs4lgKHekQkrghWtRUXpS8c4xvOeGg1T8g1MrpOoN3vSEY4IzHFU2SDB7dwIO+/oHeCpQdPZBKIlBBm3dlaP3K12in/DF0+vSmVvclht5exBMNE2rN/1ACuphj+d9WbUCr17kOhVAdZkFYVci3fIITiMqs/iNt88IH3AaHRCdqBcwcG1PyWYi252F15Tg7ONLO9ZtKfVoTh6Cc3f209a4Aq+hQWDONqmR+e6rYN8m5WAoyBQe5OcNf97aXSlt9qA6BeKuZ9xu3KmiiSxSnEK2roYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AS8PR04MB8836.eurprd04.prod.outlook.com (2603:10a6:20b:42f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Mon, 28 Feb
 2022 20:09:42 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::38e8:ef44:f684:9eed]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::38e8:ef44:f684:9eed%6]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 20:09:42 +0000
Message-ID: <064e996b-f048-48c4-ee20-af50870a045f@suse.com>
Date:   Mon, 28 Feb 2022 12:09:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 5/6] scsi: iscsi: Use the session workqueue for recovery.
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        mrangankar@marvell.com, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, cleech@redhat.com,
        liuzhengyuang521@gmail.com
References: <20220226230435.38733-1-michael.christie@oracle.com>
 <20220226230435.38733-6-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220226230435.38733-6-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0143.eurprd06.prod.outlook.com
 (2603:10a6:20b:467::20) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d78ea21-c118-472e-28c8-08d9faf641ec
X-MS-TrafficTypeDiagnostic: AS8PR04MB8836:EE_
X-Microsoft-Antispam-PRVS: <AS8PR04MB8836B73BA6E5D0F1265448DEDA019@AS8PR04MB8836.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LogAIm6NBB1awt4budZZrwF/FjWY9C2PIVqMUfxOnR9JJw+i56tTrXHfViwrMcgTFeBIKDkolY05+S8EP98bSXrVL4DHo7THc6pw0/9eSL7W68rYNoGtPRcQqYAp6VDpLoRuzD/mq2QdMmpIqyOpQbvthD96bDiijcrEt/8m14+ip47XueoVaHzLrF2kb2DS70vHabUFyHN1gLai4enBUX/bNg+/w2i6aWckdTVZHrhnA9ba3jeIrk3yB4dfXZVaX7E8hvw8oEjQdSf+PE06CIOpKke4W5CBnJ9h4khZaTUhO8ZyWirrVOoVbGcDJyTavc45pqosf79KVhA7COk1tiDfEpMrY18f0hT302Rc0mUlcPlns8czC2rExsHvAjh0u3Q2DDtOLSGQKB2bliuJ34JX2HDKVkwbqTeWfCOTDtmINfczVmZI98qzhydGAU36lwOObWhpgNfi+vH7d0Yg2S7ujhEEcVEJ02Ze+ea04BGyZKHBCazj4Zt4EsQgdsWqEJkPnyXo9aYw4hJU7orRQ+1rv9ZJshGD/47vtZhzadsEp8+mpWGTcIZZr//YVwRCl0dEOdiWPLu3ev+xr+UtKGnkH/53bv3x3N6VJdjuiJuIsWfa3kkrlM0GhO0s7ocezotic+tFfYN3TnSefit+/Fbk4YuWZW2ownYerSvcx/1wS6otF8ktxu+6UIrY3lTpEWsZlnJnNA4G9NwuIFj0/cJ/3PLhvlA8PI1a1IRGk/Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(6486002)(8676002)(6512007)(6666004)(53546011)(2906002)(86362001)(36756003)(31696002)(31686004)(316002)(66946007)(66476007)(66556008)(6506007)(83380400001)(186003)(26005)(38100700002)(2616005)(8936002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?LzE0TjhURHVRa3NMcXc3T211L3JkeVM3aUY2U1lNSElEdlFLdW4xMldGOHV0?=
 =?utf-8?B?RW9jSUJ3S1RHbnNGeFJXV2xNUTZBMW5HWmNmSzQ3aXdsaWgwQ1lDVC9OcTZN?=
 =?utf-8?B?ejhrSFFjRkQ3SW9RSlY5UHkvT2V1TzZLRW5iVkdPeHdsbU1nUnFQMXViOGQv?=
 =?utf-8?B?eDNnRmhMNEQvZEMweXhKbDk0dHdTcExteDdUSm83NVcxRkRENmptZ2dlUjVj?=
 =?utf-8?B?SWs0NjFtTHNtd284NlVkb2NjdUdJdHpUU3Q1dEtld3pvRkRYZ28vVVpOSFdH?=
 =?utf-8?B?cE5UT3cveE5wVVpHWFRJY0NzTDhIemtWUUFuQVZPTlVqamgrTHYzUnhlT0JJ?=
 =?utf-8?B?eFlrMUJHSUdQM3dvL2E3ZFZwcUlIY0dRMkx3alZtYkE2dEFOemoyZEc5UmVF?=
 =?utf-8?B?Umh3UmFVRy9sdUR4VkxHaDBjUSsyekFrTWVTMjE2VXZidW1DanZZaE9TNEZX?=
 =?utf-8?B?RTNwekV2S1U3N0c3OUVDbktVY1lVMENhbFZScnpBRFZLREphTEhqT1Y2ZUZH?=
 =?utf-8?B?UVZrSDJzOGI1dUp0OE1vUDM4Qm9lcnE3ZCtyMHppMk5jY3JWY2lTMDhLb2Rp?=
 =?utf-8?B?NDY4TVRmQ3Z3dUxpTDVaL0hpMmZ1UUZpalhOWElsMXZRbDZIYzBhdG5TcmZX?=
 =?utf-8?B?c1FPNloyYWoyRlpxL2Y0ZU40aE1zaktqRjhvb095bGtTaERWcC9nRktHMmRu?=
 =?utf-8?B?T3FQaXlxRFhBYlROTUEyYngvWnI2UnNsMjVQS0o3UGNXc1ZoSTlrNWJoU3Vo?=
 =?utf-8?B?YUZBYnUwL1d5SmxQZ0FYSEVHVXplbmEvMmM3SlNRNWZ1NXJSOWt6QXorekZG?=
 =?utf-8?B?cXF3TDBwY3NWVjAwNnNXZ0syL2dTY3FuZ0RsNnZuWFlJWHpQZEhlNnVYeC9s?=
 =?utf-8?B?QkpUeDF4MjZKWHVjRzNZYk8ybmpTb0dwTERPMTE0S1VzY1VkMURLNVVwTXZR?=
 =?utf-8?B?c0Y5L29VRVExdVR2Kzgyb1FVOTQ1cDlQRlBpazFzRGdRQ013MG1FS2xmMFBV?=
 =?utf-8?B?NlpNUGttT0g4WGw0cHFYdTdmMWFWbnRmK2xzdkp3Nnh1di9SR0ZZa2tWcFc5?=
 =?utf-8?B?cms2VUZ3TDQ3eWl3Uk5YdWdiWUN0eHFNYjYxalhtTTBpR3FwN0l4dTFUNHB6?=
 =?utf-8?B?bnBMZDVGbFpMS2JXU0Zpa0wvU1Q5L01uQ1lPZHFKWlBRL2F3MmFuUytlMzZN?=
 =?utf-8?B?WG43VGJtOXErRk9uaXFvVVdUb1V2U1NjeStiRXQxYkdIbWgzME50Z2l3OVlp?=
 =?utf-8?B?ZTVNWmFob2RHTE1uTXhmMHo1bDJ2bTUzWHhwTEVnWC90VEZ1ZTZCWE5LVk5u?=
 =?utf-8?B?ZHUrOE9hdXgzSEZySDhReFd0SFRWSzdjNHZYK1BPZTlyUDU4blY0Rm0xWndw?=
 =?utf-8?B?T3ZpdnFrWWdHenNsUTh4ZHdxVlJMSzVOa1lnU2ZpbmU2ZWVOSjRlODAwaFFn?=
 =?utf-8?B?U0JkTlcreUJVVm5XRXNTRTNBZHp0Y1dSTURNTjVkNXpteUxSMEI0RGdhb3NV?=
 =?utf-8?B?VU9NRHVwZDhiaVJRWER1cWJCN2VEQ29YeHNZSldBd3djNUhMbkZldDdpUnQ4?=
 =?utf-8?B?cUlDaXd4K2dxZmlBNmVucDZRQ3dXOVFQc0NQNE53ZTVnbnlzSktLczBWUEkw?=
 =?utf-8?B?RVZMSXJ3dXJpTmVYeVVGbUdnY2tJMEtCME8rTjQ1YjF0VWJmWWpqNlZhV0hs?=
 =?utf-8?B?R2NOR1E4NTk4aVNEZXhkZnROVk5ScW40VGNnQkt1Yk50YUVJUFBoeUJHTEVG?=
 =?utf-8?B?TkhKV2tvb1Ntc0Y0T29oNVZiMUl4Ry9Fb3ZxV3BqdHJrcEsrVkpMcGhTaUZQ?=
 =?utf-8?B?eDJ2Q0M5cEpIMzkybnpoSVJkTmRaQUw0Y21VKzdkSk1mWXF0RllUY1NiTU5t?=
 =?utf-8?B?Ly9ON1dQbmtCdnNCV3NCRGY5WEYwYVdhR2o3NGtjNkhvWDNUOFl6bWVPMTBj?=
 =?utf-8?B?aHNicm1YT3JPWWpocmNNYkx3cWdrSHdKak0zQkRJZmFzVEpWclVtNFRDTnA4?=
 =?utf-8?B?TGZhSy9VbDgxdEs5VUJldlBuR2NNcTFWaUdUbmcyWFcyRG5IZW1OdnNlZ2d6?=
 =?utf-8?B?dkJhb2NjS1FpVUhCQnc3WEFRRWdqRlJKYktPcXBPRFVCSFc4a2ZFQ2VyaXR0?=
 =?utf-8?B?UXlsaHhZdkdYUkxIT256eUNLN1VrcUdPSm91M3QvRWJRcFhxS2Ura3B4dG9s?=
 =?utf-8?Q?npBZtbDsaEN5sBtwdROllD4=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d78ea21-c118-472e-28c8-08d9faf641ec
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 20:09:42.6405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FiV1i22c0qbMKyaOPw9jsDGf4arzAjC1E/t8kZ6Ng/sqhWTJeC6qhTQdOIPIZV96b2afbRBPVImsoD/eFbS8Fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8836
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/26/22 15:04, Mike Christie wrote:
> Use the session workqueue for recovery and unbinding. If there are delays
> during device blocking/cleanup then it will no longer affect other
> sessions.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/scsi_transport_iscsi.c | 20 ++++----------------
>   1 file changed, 4 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index ecb592a70e03..754277bec63a 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -87,7 +87,6 @@ struct iscsi_internal {
>   };
>   
>   static atomic_t iscsi_session_nr; /* sysfs session id for next new session */
> -static struct workqueue_struct *iscsi_eh_timer_workq;
>   
>   static struct workqueue_struct *iscsi_conn_cleanup_workq;
>   
> @@ -1913,7 +1912,7 @@ void iscsi_unblock_session(struct iscsi_cls_session *session)
>   	if (!cancel_work_sync(&session->block_work))
>   		cancel_delayed_work_sync(&session->recovery_work);
>   
> -	queue_work(iscsi_eh_timer_workq, &session->unblock_work);
> +	queue_work(session->workq, &session->unblock_work);
>   	/*
>   	 * Blocking the session can be done from any context so we only
>   	 * queue the block work. Make sure the unblock work has completed
> @@ -1937,14 +1936,14 @@ static void __iscsi_block_session(struct work_struct *work)
>   	scsi_target_block(&session->dev);
>   	ISCSI_DBG_TRANS_SESSION(session, "Completed SCSI target blocking\n");
>   	if (session->recovery_tmo >= 0)
> -		queue_delayed_work(iscsi_eh_timer_workq,
> +		queue_delayed_work(session->workq,
>   				   &session->recovery_work,
>   				   session->recovery_tmo * HZ);
>   }
>   
>   void iscsi_block_session(struct iscsi_cls_session *session)
>   {
> -	queue_work(iscsi_eh_timer_workq, &session->block_work);
> +	queue_work(session->workq, &session->block_work);
>   }
>   EXPORT_SYMBOL_GPL(iscsi_block_session);
>   
> @@ -4851,26 +4850,16 @@ static __init int iscsi_transport_init(void)
>   		goto unregister_flashnode_bus;
>   	}
>   
> -	iscsi_eh_timer_workq = alloc_workqueue("%s",
> -			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
> -			1, "iscsi_eh");
> -	if (!iscsi_eh_timer_workq) {
> -		err = -ENOMEM;
> -		goto release_nls;
> -	}
> -
>   	iscsi_conn_cleanup_workq = alloc_workqueue("%s",
>   			WQ_SYSFS | WQ_MEM_RECLAIM | WQ_UNBOUND, 0,
>   			"iscsi_conn_cleanup");
>   	if (!iscsi_conn_cleanup_workq) {
>   		err = -ENOMEM;
> -		goto destroy_wq;
> +		goto release_nls;
>   	}
>   
>   	return 0;
>   
> -destroy_wq:
> -	destroy_workqueue(iscsi_eh_timer_workq);
>   release_nls:
>   	netlink_kernel_release(nls);
>   unregister_flashnode_bus:
> @@ -4893,7 +4882,6 @@ static __init int iscsi_transport_init(void)
>   static void __exit iscsi_transport_exit(void)
>   {
>   	destroy_workqueue(iscsi_conn_cleanup_workq);
> -	destroy_workqueue(iscsi_eh_timer_workq);
>   	netlink_kernel_release(nls);
>   	bus_unregister(&iscsi_flashnode_bus);
>   	transport_class_unregister(&iscsi_connection_class);

Reviewed-by: Lee Duncan <lduncan@suse.com>

