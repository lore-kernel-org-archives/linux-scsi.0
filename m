Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1D2AC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Feb 2022 18:34:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbiB1Seh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Feb 2022 13:34:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240635AbiB1Sdt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Feb 2022 13:33:49 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1017EDB4
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2022 10:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1646072353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aBp9f4DFnr9u2WotyVilfFiRO4ZfOA7Vgx/HPOCIOQo=;
        b=Si32dApRNSOt/VN/mdMJX3/E3PnBdrBrlYQdKEZ/XGU+MwpPUNRuXfimxGQ0xvasph/SBS
        aWq08ObuqwZcbRloGrD4CHi2hiMFIftp6WP7DsJA2TCDwHr/xZYu+GHz9Siftp0hPX81cg
        2gUrxISeNT1fz4OvOmR0VC+knvB1Xjw=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2053.outbound.protection.outlook.com [104.47.12.53]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-17-r_AHkid7Odu0DI_RWTxF7w-1; Mon, 28 Feb 2022 19:19:11 +0100
X-MC-Unique: r_AHkid7Odu0DI_RWTxF7w-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MHabCdMDi0zDHEqgXyafz7Uuk7VWPebRCzpi7XzEjsv3so+q90AgM0iL0VmCVEcGPGw4e0OZ/Qx3Wa0iHaK7j+rR+/SVYce1T+B0HF1ONQ9wsbso2iJOLb8OCX9N3OSv32GGvRbFaOd0yh6SDYad78hVlizNSEAxfyTWjW4osurQ1wiBDhY2P+/+ZnVYBu+nPURzcKntzuAPksO+vI/LpGY2hdPOz0CYtSW8mL+g4vbG+NtH+mD88ZdDjqa9dhWE4Y1XUV12d1YdVOGXi/8aNLD8OmfSLIR2LsKL2JNdfeTm47Opj6a9vUYLZPYCyHD7M1SCwNGJ0+BqRkYdXP3ivA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aBp9f4DFnr9u2WotyVilfFiRO4ZfOA7Vgx/HPOCIOQo=;
 b=Rkdoi/fWnX47eIWEAs/FW0IKkRuMrTwvtxIsxm+jorveX86noArokjROOQa0aMHJ+lOsDMZxbkSXmHeOiTPc/rFoK45fvxDYpmFXQtUtUDAX+nsVGmex/0NGR5NcHfkS8/aS481LERJF0GpLuk7Ze76fxw8eoJDl5r4yxq5q4k0M41sDi4JfPgCkQ7+rQEOsVTOmtsW49oR7XRhQTNPqcu0duNZ27BDRe42L8LMX8heab8zPMXrLC8rAjgxjn6Dzrbw2UZqiBxlq3XItwaz1oLk4L2fMJwdg0ZYOMFyEUoLONmfoutOZGPSxJ21H3sl4zneD4VpDX2/im7hkByJYDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM9PR04MB8383.eurprd04.prod.outlook.com (2603:10a6:20b:3ed::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Mon, 28 Feb
 2022 18:19:10 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::38e8:ef44:f684:9eed]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::38e8:ef44:f684:9eed%6]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 18:19:10 +0000
Message-ID: <fa265ba8-b0d4-0d02-ac32-27abab0e9f3d@suse.com>
Date:   Mon, 28 Feb 2022 10:19:05 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 4/6] scsi: iscsi, ql4: Use per session workqueue for
 unbinding.
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        mrangankar@marvell.com, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, cleech@redhat.com,
        liuzhengyuang521@gmail.com
References: <20220226230435.38733-1-michael.christie@oracle.com>
 <20220226230435.38733-5-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220226230435.38733-5-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6PR08CA0035.eurprd08.prod.outlook.com
 (2603:10a6:20b:c0::23) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d7b7fb4-f854-4fc6-67bb-08d9fae6d092
X-MS-TrafficTypeDiagnostic: AM9PR04MB8383:EE_
X-Microsoft-Antispam-PRVS: <AM9PR04MB838343E7DDDA5E9885ACAAFEDA019@AM9PR04MB8383.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aZw40fwXADlaGOH/VO8ob7dGQuoxtT5uGA0p6TifwWGmYAZ40hUitT7f4TE/Gib/TO8RzeC3BxcksejSg7D/XyCnF5FaFfm5CfijLCnqljQMg4jfVvjmdoEkLUImikZa5Izvpyd0FvP8u1m1An4C1KPww8W990MN05Gsa69ZM26ACrDMHpUIx9b1vZod31EDvt0CrGlb1JAhBhhrIh6Cl1ZdsKqTmW07eZTOs08foa7WPICXdrW8brEVCR9kqufLBRsgCkMxMVH+xtaDYKDLrq3EjTBY7rE+KMl02Oyx+HEoo/NGJLJ9Cmo3D2B8iBapYaejwfyVhKuAH4Wqq8Ir0gox6oOeGWs1+KrXWURmF56U5reQV3DQjYdc4VQvFMAuBqV0BA17pD67pe7CvKR7iNASpChWCgXFzHtsUQKug2Wmr9tHEmR5iM8y0mUPjPXfkiQCFvhWbWlRJpFN9i/DXQ892twv/SODUSqKfeA9EEY0sufrfE6+4XVlqJmk0u19jKrUcRYzSAXWEc8+J7+DBDKzMIez5/MrbIXiWVHlmS+VSte+Vwfey5giZrt+oQCkxDwR628PZOn04b9AAed81lsxCK2c9G9tX5BOlyYKpG6fYTLwASdqDqBBg8/4OvmhVLxJhL2GpZkKctfpsmcVpHpgv267qdADZsElLw0HynODabeCJ4moLgZRTeQiiNzMtF6DKpmO/a2IIYY+T0eA81sV3ffSOSc4EEBRsF6DPNQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(86362001)(31696002)(53546011)(316002)(8936002)(66476007)(6666004)(8676002)(26005)(5660300002)(2616005)(186003)(83380400001)(6486002)(2906002)(6512007)(38100700002)(66946007)(66556008)(36756003)(508600001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YzB6bnhHV29VUTlYcWVxUDVET2plb0JIMDI2YWx2bFJ5c0M1TDZHWEFVb0tl?=
 =?utf-8?B?N1VzQmJMSGQ2Z1B0a053QmMvdHJFZk4xWi9ZenFFNTl1NU5DZ2hPcUVhb0hs?=
 =?utf-8?B?bmJvUU9tTGJkdm5TNWhRVkVVTVc2YmxXZC9TS2ZieWlzQWFnYUsvZ0Y0d3Vl?=
 =?utf-8?B?MVhpRCtvUDNYZmdjRzFhNG96dWI5R0JtdkxSaTJLemlnRkszaVM0YzJmQjVU?=
 =?utf-8?B?UWlmOU5XazRtakNjRnVQeS9Yd3BNNzYwSHR5cTNmV1RoYkc3eEhZU3U0cWlV?=
 =?utf-8?B?ZWpkcE41QzRGOGhoWnZvSXpadHZoejRJYWhXYnZaOTZuck5nSm92WmpPdVh0?=
 =?utf-8?B?Wi9TYlRtMHFURWljcVdzYisyeC93aGVuRS8vWE9hSnRPWjcxdi95aEpMTk1I?=
 =?utf-8?B?OS82ZUJ1WSs0QjV5SXdGREdyRVJMV0gzV0J6TndlUlorVzU1MGE3eTAzdmZU?=
 =?utf-8?B?WlZXNlNYd2dHSVRiSWtzSWRyN205VEh4WGFTYkcvS1lCQi9Zb1VGRnJ2MDZT?=
 =?utf-8?B?SlZCYksreTlKeGgvWWo5TTViTjNpOTZlaEt2WDhHOHRZWmVsVmxvUGhHUlVX?=
 =?utf-8?B?akxkcS9QWFZsM2JHL3VqdlhObnVxUDhHU2piWUVzM1ZHY0pNUjY2dFdCWEFK?=
 =?utf-8?B?R09CSy9ZeHlzS2lNMFFZaXpqMklBNk5USjNUWkhRZHJqTUpnajlHN0Rva3Uz?=
 =?utf-8?B?d1ZXKzJ5MHpaNm14WmhLem5ERW9SWTk4VGtrOUF3SFhwMFdmeGdDSEsrY0NW?=
 =?utf-8?B?eDNZUXNmS2UyeXI1Y3Fibjg1MlRPdGNYWFpJcWtlWkhHc1c3UG1LMG40c1Uv?=
 =?utf-8?B?UnYyK2czcHFmdXBRZ3RYckp2RXl5eTMwUC9tSkJZT3QxNFZFeHRCbW5rZGJP?=
 =?utf-8?B?dVplcjBjNU1TRGd4VXlFd3pFaVhqbjlWdnd3ZWNuZzVURmd2YU9NL2s1TU5s?=
 =?utf-8?B?ZWxwUC9iTWsrVEhuUkJrM1VsczR0NG82bThOT3FLVDZXL2xQWTJYRGJUZWJD?=
 =?utf-8?B?OVFZaXpwTFVZdm9TNFhnRFRLdkRGUUxPMU1XRlFzLzl5V0RST0l3VlcyYWwx?=
 =?utf-8?B?MGZvVWtYSkx0Q2s5NXZVRTBVNEtDaFFWQmprQjhwRURMUDVzUGlpOEwrM0dU?=
 =?utf-8?B?RTJiSjIzTndPRWYxY3N3NkNNK3NjTWczV1hjWis1MWoxZGl5dkJCN2hIdk1l?=
 =?utf-8?B?KytmMHJXOTQ5T3p5eUtWdDJyUmFSek9SYUVsTUNTQml5dHVXZ2x6bmMvRzUr?=
 =?utf-8?B?OVFPK2hrMmhpWWROTWRpT2NVWFE3Q2NrMXZHb3VNSFk4dG1HYXJEeGVYSzUx?=
 =?utf-8?B?MDNnRkxoMVo4QUFTbTBtZkhFNGpBSDNqM0pqYW1ZRGlMOHkrdS9ZMFcxdUhF?=
 =?utf-8?B?QVBBT21sa1luYlJwY1ROZmZjZ0FWcDFTTUFPcTM3YzJDOERTTlVsMDg5a3Jp?=
 =?utf-8?B?eWwra25tRGM5UGMxQmsydGdybzRGdVoyYkpreXRNaURDSlo2K3oxalozWUJ5?=
 =?utf-8?B?b095N3U3MWdnM3liWDc2TUZrbFZ3TGl3NWk0R1pFZ21WeDZ4OEJabW1zOUZU?=
 =?utf-8?B?SDFZRTVmU3YzUVdES2ZOVlRHRDBXMk1nRlZ2QnNNTnBsYjQ2a1dIazdSZUpG?=
 =?utf-8?B?UExDaFR4SUZWeXZuVHdnUExteHMyR3cyNmZheGtMeUtRSytQTU1TMDFObEh3?=
 =?utf-8?B?Q2tIcE1CaVQzanJqenp5RlRJNVlQN3llNjdJSXRjNGRQZ01kQTJYelRReHdJ?=
 =?utf-8?B?N2Nub2UxdFF6TzJ4VVRNZGRJQjRsWm5RcERUUHByRXp2MEZ4eGxjRUt1R2d2?=
 =?utf-8?B?aUNORFk1M0c0ZXJOaW9XQ08weExmalFseTlDMmJmelp3RkFiUE5MZ2QzVEov?=
 =?utf-8?B?SzBDQy9nMjlZNmZmYzVsTlYrekxLdi96eU8yYnU2bXVZVFN6M3ZsSnFQNVhQ?=
 =?utf-8?B?dFNPNGlkc2VQd1B6akkybjlENGJhYWw5SHljdkJyRFZuWlJvYm8wR2ZESEFl?=
 =?utf-8?B?SlpoMkgweWlSejM1OFFOSVp6NEVZQ1RCcXplMkg5SWFZZytBVkZrZ0JnM1k4?=
 =?utf-8?B?Rk1vK24rbXlyV1ZDdXdiYjE5UHUyWlhPdmtUOVFmMkpYaDdtN1cwcVFMVGR2?=
 =?utf-8?B?TmIvTWxXZ2t1enpLZmNsTmZPRk1JSzVqVDhvNUZIWW40aTNPSG9qYng1cDMx?=
 =?utf-8?Q?BMjqd5hIQiYLf2KodHlbctk=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d7b7fb4-f854-4fc6-67bb-08d9fae6d092
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 18:19:09.9407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qd5wHNQzW/kek3Y32KoxQOxN4Mot171FFxpm5GSDu731Qwv64SBPpfuhr6hrGF3RHX9jZUPYc1eQzkNsWCMRqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8383
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/26/22 15:04, Mike Christie wrote:
> We currently allocate a workqueue per host and only use it for removing
> the target. For the session per host case we could be using this workqueue
> to be able to do recoveries (block, unblock, timeout handling) in
> parallel. To also allow offload drivers to do their session recoveries in
> parallel, this drops the per host workqueue and replaces it with a per
> session one.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/qla4xxx/ql4_os.c       |  2 +-
>   drivers/scsi/scsi_transport_iscsi.c | 19 ++++++++++++++-----
>   include/scsi/scsi_transport_iscsi.h |  2 ++
>   3 files changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index 0ae936d839f1..955d8cb675f1 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -5096,7 +5096,7 @@ int qla4xxx_unblock_flash_ddb(struct iscsi_cls_session *cls_session)
>   		ql4_printk(KERN_INFO, ha, "scsi%ld: %s: ddb[%d]"
>   			   " start scan\n", ha->host_no, __func__,
>   			   ddb_entry->fw_ddb_index);
> -		scsi_queue_work(ha->host, &ddb_entry->sess->scan_work);
> +		queue_work(ddb_entry->sess->workq, &ddb_entry->sess->scan_work);
>   	}
>   	return QLA_SUCCESS;
>   }
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 05cd4bca979e..ecb592a70e03 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -2032,19 +2032,27 @@ EXPORT_SYMBOL_GPL(iscsi_alloc_session);
>   
>   int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
>   {
> +	struct Scsi_Host *shost = iscsi_session_to_shost(session);
>   	unsigned long flags;
>   	int id = 0;
>   	int err;
>   
>   	session->sid = atomic_add_return(1, &iscsi_session_nr);
>   
> +	session->workq = alloc_workqueue("iscsi_ctrl_%d:%d",
> +			WQ_SYSFS | WQ_MEM_RECLAIM | WQ_UNBOUND, 0,
> +			shost->host_no, session->sid);
> +	if (!session->workq)
> +		return -ENOMEM;
> +
>   	if (target_id == ISCSI_MAX_TARGET) {
>   		id = ida_simple_get(&iscsi_sess_ida, 0, 0, GFP_KERNEL);
>   
>   		if (id < 0) {
>   			iscsi_cls_session_printk(KERN_ERR, session,
>   					"Failure in Target ID Allocation\n");
> -			return id;
> +			err = id;
> +			goto destroy_wq;
>   		}
>   		session->target_id = (unsigned int)id;
>   		session->ida_used = true;
> @@ -2078,7 +2086,8 @@ int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
>   release_ida:
>   	if (session->ida_used)
>   		ida_simple_remove(&iscsi_sess_ida, session->target_id);
> -
> +destroy_wq:
> +	destroy_workqueue(session->workq);
>   	return err;
>   }
>   EXPORT_SYMBOL_GPL(iscsi_add_session);
> @@ -2177,6 +2186,8 @@ void iscsi_remove_session(struct iscsi_cls_session *session)
>   
>   	transport_unregister_device(&session->dev);
>   
> +	destroy_workqueue(session->workq);
> +
>   	ISCSI_DBG_TRANS_SESSION(session, "Completing session removal\n");
>   	device_del(&session->dev);
>   }
> @@ -3833,8 +3844,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
>   	case ISCSI_UEVENT_UNBIND_SESSION:
>   		session = iscsi_session_lookup(ev->u.d_session.sid);
>   		if (session)
> -			scsi_queue_work(iscsi_session_to_shost(session),
> -					&session->unbind_work);
> +			queue_work(session->workq, &session->unbind_work);
>   		else
>   			err = -EINVAL;
>   		break;
> @@ -4707,7 +4717,6 @@ iscsi_register_transport(struct iscsi_transport *tt)
>   	INIT_LIST_HEAD(&priv->list);
>   	priv->iscsi_transport = tt;
>   	priv->t.user_scan = iscsi_user_scan;
> -	priv->t.create_work_queue = 1;
>   
>   	priv->dev.class = &iscsi_transport_class;
>   	dev_set_name(&priv->dev, "%s", tt->name);
> diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
> index 90b55db46d7c..7a0d24d3b916 100644
> --- a/include/scsi/scsi_transport_iscsi.h
> +++ b/include/scsi/scsi_transport_iscsi.h
> @@ -251,6 +251,8 @@ struct iscsi_cls_session {
>   	bool recovery_tmo_sysfs_override;
>   	struct delayed_work recovery_work;
>   
> +	struct workqueue_struct *workq;
> +
>   	unsigned int target_id;
>   	bool ida_used;
>   

Reviewed-by: Lee Duncan <lduncan@suse.com>

