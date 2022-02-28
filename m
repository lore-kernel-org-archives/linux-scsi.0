Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A681CC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Feb 2022 18:25:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235059AbiB1S0R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Feb 2022 13:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240583AbiB1S0I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Feb 2022 13:26:08 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A831E02D6
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2022 10:06:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1646071554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f+hw3EoS/4aTcl4jabWWHCZhyXLg7rTik7TjlbjPwM0=;
        b=QMWVsEktS9PMUgNeenVgdjKjNnAPNEsVnIJizuuFqyZhCtLZq3A9wDWYcocqQJSuWf0aQX
        e+WygvQTTl+HPKHuI2K+RPoQDFc+iGZUStm7bDeiSCu0jzbVC55hv4ZerWrw5YkQFO0ST4
        tQ9w4j8A8kHyoh4iNDtCQhPFx+V77FY=
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02lp2059.outbound.protection.outlook.com [104.47.6.59]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-37-Rpf9_mmoMgiDJ5M_IxCxCA-1; Mon, 28 Feb 2022 19:05:53 +0100
X-MC-Unique: Rpf9_mmoMgiDJ5M_IxCxCA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B3JLkkcTg13fHtHvh1OVPS4GL0yAEc0RBgkN82gJmOkXrw7uwbuntXP9kqYxZmNgWp7DoSvTQe+wHRpfRB/lbdD8RniFHKxSx0HpaLbrdWWESk8xAwQTtRgyPcHGJJwbyx+dxj4X7YIoDFozKDsxSuzLSeuQPz6I/tO6OVLlZpDS/LwjqfKfwDiRTyFu6nyNt3Ph0ZePAWxzR4Z77I7lLvn5RW8F2IbpdPyVWUEX63yTtoMz/t2Q2bFac1EXySke5XQVUQvSpz3Hmu4toVj4rbMij/42RV7oq4amOLSVnzM5qhxMp4zw2AlHCuy//YA+Cz4p1Q35s+AEmiq0x5C0ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f+hw3EoS/4aTcl4jabWWHCZhyXLg7rTik7TjlbjPwM0=;
 b=CRjCOiaVmZsrcXZdt2viTDHqH28+CcNC8vdYETkEX+nU5xYE2702tBp9vF/u6/V1IYIQNkDzEkq4gTm+UvDYvnG3gMOjBU+ggWCo5x/JblZ0afdsm/3Ad6L2vOpVVLBU33szkNNess4l0Mnb0Gz+pS5UvmfS74IuFFe0S3oED78bnhX0DiMu8T0s2EnYJjiO923djthG1OyRCcOODvJoWrJGcPLcSvwpBWcLN861eRYuvS7AXdz3nveaI3JUlsKwGMzmRzLfTRojnldoPedi8byEXAfRb/aMHub1Nm1mbxGbkD6dHNomb/IFAX+eNMuh3dZG5wA34Uz37eRXfdfLTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM5PR0402MB2690.eurprd04.prod.outlook.com (2603:10a6:203:97::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Mon, 28 Feb
 2022 18:05:52 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::38e8:ef44:f684:9eed]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::38e8:ef44:f684:9eed%6]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 18:05:51 +0000
Message-ID: <e77fae9c-d612-003f-5b9a-b0da4b389b14@suse.com>
Date:   Mon, 28 Feb 2022 10:05:46 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 3/6] scsi: iscsi: Remove iscsi_scan_finished.
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        mrangankar@marvell.com, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, cleech@redhat.com,
        liuzhengyuang521@gmail.com
References: <20220226230435.38733-1-michael.christie@oracle.com>
 <20220226230435.38733-4-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220226230435.38733-4-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6PR0202CA0056.eurprd02.prod.outlook.com
 (2603:10a6:20b:3a::33) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9cb335ac-0cc0-4844-f50f-08d9fae4f4d8
X-MS-TrafficTypeDiagnostic: AM5PR0402MB2690:EE_
X-Microsoft-Antispam-PRVS: <AM5PR0402MB2690ABE24CBB4D3FE7C1E71FDA019@AM5PR0402MB2690.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F4z+SQRMlAEwTlfk0q58j5yjhN/EZ+1hohm1xO1emjAJ3XtfxSLiVRzlN0XP2BAVpq4xPrSepulOdZZ4EcRBhHLLB21dLtUqkQ2BS9VFecPxyPiQlzuoS3aykhzWY7Msotc2DbMUAAlybsMCMxP61can+3IoAvgQfCOfKGliNxJVfLzsZY+BYGIew6InLGVWZgd1485egVy1doiFKnF4FYwgsV+Eb8RX+sGh8eg4GsEHVSuAQUMY/QKrsVPk8BZeXR0kS9ASAapIqnljh95RxyiREZ4bkremgZt1c/QEnhgDZmwBM65sIpt7KnzhAjKsibgrxeJWOO+hSxI0uYIEBYiMIadYFzYtCt9ZuwJ/sWyLkW6m5TlAgCE4YU73Tf2gJyYeObDBLMcNu3TIFco9hHDt/NP5FTzKYrCsiojWFFkBpvF+45CiUTV1mypXDirdmj201M1hHiKrfBPa8yM7E7gYURwCNPeaOhq6c5c13NlnSOFM2ZlWIh6n5+bQZr242zZniE7RufPrFqkfu1NGsInFgtw3Dk/GMUhIHzLrNhq7An2eZj7LQL/rOTU/S7LKwfz2o3FOgOuLVycqpO4N2kRHUVkuSude0yQahPfZG99JLXYSZNwAz8VxEY+lVwWOyrsBzzDmMrHfUkJzZTJJXuR6MWNAg+n5M97vCZjB8L7KvJGR4sMBFIJCabQFyoxar00h9teDs2l7Dw6ycyRiWxAlWZ5x+7xTv6GWvRAz/yw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(38100700002)(508600001)(6486002)(36756003)(53546011)(6506007)(2616005)(2906002)(31686004)(186003)(26005)(31696002)(86362001)(6512007)(8676002)(6666004)(66476007)(5660300002)(66556008)(66946007)(83380400001)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cDB4MHJmL1ZKZWxmblJTNnZ6a0Jndy92MDR3bXJmcmt3ZjVoUmFuaVlCRDFC?=
 =?utf-8?B?TlVPMW1CeUwxSUJ5SFdzanBGUGNLNFNqZ1JPTU1KLzUzMjZWTzBwVDB6VUdF?=
 =?utf-8?B?eHBaYkk0VkRIUlhWSGx0bTk0ckNHeFVNRThZOTYwWUc0a1NwQjNGdmppaWxi?=
 =?utf-8?B?UnNEdUFkTmppN3BadjFNdUNNanBORlFRZWZUWGF4b0JoMXZOcGxGZjBrUVZX?=
 =?utf-8?B?RUFuWjg1TnFOUCtwNm9zS1cwUG5ZWHNTWXhZV3RSTmZqdU1vMzYwemF2bGRi?=
 =?utf-8?B?ZHVrOG5uOFNSVHd6UkNDNFdwVUFsT1hzSkh1aEUyS1ByLzRUTVI0SGszS0xT?=
 =?utf-8?B?QmhoZEpTcEZnRStHZ0NlOGhiWlVJL3p6VHE4ZE93M3phK3JjTXUrQ2xzUWpl?=
 =?utf-8?B?a1R2NE9WanF3SDFoV1A2M0pkMTdIb04wZkhiN0ZkNEJsV1RyS2ZGd3puUE5D?=
 =?utf-8?B?cDd3dzJpK1FUTlZKbTlxOEMvV1I1amh5c1VReGF4ZVhkQ293Y1pteHovMUt0?=
 =?utf-8?B?UUFVTnVZVGp3Q2RyNWxieHptNm9UVmVlbmZlc0R6YW9IdmNIakNObEJqMnNJ?=
 =?utf-8?B?eUoxL1hGS1JQK0RyL3ZCQityWkZ1Yjg5LzVhelh1V1p5U2xaNjZEcEUyVUg0?=
 =?utf-8?B?VmRndk1EaTZXWENuazhXTTBsVGZBUTVLUmdGeU5mdTNuQ1lzeVpTRnRlYm1a?=
 =?utf-8?B?aGFVQVBmaDMxK2cyQU9sRVU5THZFUlI0UWJIV0w4aDNMK1pRRktpZVdpRDgr?=
 =?utf-8?B?SVd2WUFZcjYvRjIxWjZ5N0I0bGJSL3VIMTQvVldmSzJGSzB0anpPaDdHMVZV?=
 =?utf-8?B?K2xHUEI4YUxHYUthQ0pHa3Q0b3llaGF0Sk5KaUFtZzZtK1NieTl6bXp4NEZZ?=
 =?utf-8?B?MG9lNlI5UGd3RlZmY3NXU3lxaDZkdzJUamM4ZGM5WDlPQ0oyM2d5WDk1dHhj?=
 =?utf-8?B?RXdNY0hUZW9lSUtwcjlrLzhDYTVKNTlaYkV3My9tY3N6Ly9QeFF2U2p0dGNT?=
 =?utf-8?B?c2xORkpEVDJudHc1OXM1V2o2OFo1K2c2b094QjlQekhJdmZ4cVc0Sk5EVGxz?=
 =?utf-8?B?emRUQmVuRmRjeHdnS2tDYTd0dmd5QlVUd0JzbDErbzVmdUt1bm1NQ01JVWhH?=
 =?utf-8?B?dUFreEVYUjRTNDBGZ3FOSDhWZldvZTVsU3VaeHVUMXpRaTlXQUt6N1hkMEpI?=
 =?utf-8?B?SVVQZmJuZkFaRFdMMGtaRkJuaXZBN3dTVG1Jd2gwdU5TaCtHd0FaUlBNSVBC?=
 =?utf-8?B?SEpER1dsNzB1S1JWQTEzOUJHU3RiaXpRVVRSVU1BTEJGMWowaUszcTNhemdy?=
 =?utf-8?B?YmoybDQxVzFOME9JZDk3dm5WVWgwd0FEK2FvaGl2VnJXZ05La2pNUWRZcTVB?=
 =?utf-8?B?em1yYStWK2xCUjdaOEtOaFUxVUlZTkRxV05WR3lYNjBKWUcvTUFsUUlXQ2xq?=
 =?utf-8?B?S29KdUhTVmtRZ3ZKWE04SkxlcVhJdWFJd2ZOVEJ6VGVwby9KK2o3V2V2WGhM?=
 =?utf-8?B?SU93bUNZM3BEazFNWXN0YTROaUo0VXNGNVdsYWVoN1VOVkFKQW1UTUxES1I0?=
 =?utf-8?B?L29JOGFhREZ4U21OeUJIUE12K2J3MXdORk1ZZmtOS01hV1RmUFdZTDl1R1kz?=
 =?utf-8?B?Q1lSNTlHd1pndnl2MWFpamJ2Tm55K2ZzMHJ1bFc0UnZSRk5mYWVwNWt3ejdN?=
 =?utf-8?B?Y0Rrc29WU25QSlREU0NYWWJCV3FHa001aWhtbjZmcWhTUUlVcDZFNGdhR1Zt?=
 =?utf-8?B?RUZCQTNIYkxjS0lEYXNoVUl1THg1b1VONTFKeTVhUTdzRm9xTjgvVU5YZUwx?=
 =?utf-8?B?QnBtSjVQK01iSmRUazU5NGRiK1hDdG91UDMyVGxzWmhwNEJ0R3d3cW9JOE56?=
 =?utf-8?B?WjlPd1lTdzN0QkhwTDNWdFBZUVZQck40bVl2bE41WFBwTHpERGJ4Rm0rT2tM?=
 =?utf-8?B?YUZaN3ZuRlFpSWdsa3kyam5IUURTaVdSeGx0Q2lYeFR4MjM1MWZuc1dabzNx?=
 =?utf-8?B?M3Y0UVlibm9rZTZhaTZyczhSaitrNG0rbkkzWDllcnh4YTl2NGpPdWhrZlRN?=
 =?utf-8?B?c3NoNGpDS3hPd0ZyTXBjblUxMmQ2T0t6eVUxVmJuK3Y0THQ1eERQMnpzM2tP?=
 =?utf-8?B?dlczYjdaZ2FwNmhrdmFoeEtWTG9rY2czd0duWmNmd0hiSUcrVERYM3BtdVFk?=
 =?utf-8?Q?L1ibOeuBnUq4L7C5zffT35U=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cb335ac-0cc0-4844-f50f-08d9fae4f4d8
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 18:05:51.8701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TQn0DyWNBVyP3RlnkzHSGXxcWt+v3jE1Ew5T3Eox/0rKTagbRlzmCAR5vd6VP6hQzFoZp655rgn0e4yho5HDfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0402MB2690
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/26/22 15:04, Mike Christie wrote:
> qla4xxx does not use iscsi_scan_finished anymore so remove it.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/scsi_transport_iscsi.c | 39 +++--------------------------
>   include/scsi/scsi_transport_iscsi.h |  2 --
>   2 files changed, 4 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 732938f5436b..05cd4bca979e 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -1557,7 +1557,6 @@ static int iscsi_setup_host(struct transport_container *tc, struct device *dev,
>   	struct iscsi_cls_host *ihost = shost->shost_data;
>   
>   	memset(ihost, 0, sizeof(*ihost));
> -	atomic_set(&ihost->nr_scans, 0);
>   	mutex_init(&ihost->mutex);
>   
>   	iscsi_bsg_host_add(shost, ihost);
> @@ -1744,25 +1743,6 @@ void iscsi_host_for_each_session(struct Scsi_Host *shost,
>   }
>   EXPORT_SYMBOL_GPL(iscsi_host_for_each_session);
>   
> -/**
> - * iscsi_scan_finished - helper to report when running scans are done
> - * @shost: scsi host
> - * @time: scan run time
> - *
> - * This function can be used by drives like qla4xxx to report to the scsi
> - * layer when the scans it kicked off at module load time are done.
> - */
> -int iscsi_scan_finished(struct Scsi_Host *shost, unsigned long time)
> -{
> -	struct iscsi_cls_host *ihost = shost->shost_data;
> -	/*
> -	 * qla4xxx will have kicked off some session unblocks before calling
> -	 * scsi_scan_host, so just wait for them to complete.
> -	 */
> -	return !atomic_read(&ihost->nr_scans);
> -}
> -EXPORT_SYMBOL_GPL(iscsi_scan_finished);
> -
>   struct iscsi_scan_data {
>   	unsigned int channel;
>   	unsigned int id;
> @@ -1831,8 +1811,6 @@ static void iscsi_scan_session(struct work_struct *work)
>   {
>   	struct iscsi_cls_session *session =
>   			container_of(work, struct iscsi_cls_session, scan_work);
> -	struct Scsi_Host *shost = iscsi_session_to_shost(session);
> -	struct iscsi_cls_host *ihost = shost->shost_data;
>   	struct iscsi_scan_data scan_data;
>   
>   	scan_data.channel = 0;
> @@ -1841,7 +1819,6 @@ static void iscsi_scan_session(struct work_struct *work)
>   	scan_data.rescan = SCSI_SCAN_RESCAN;
>   
>   	iscsi_user_scan_session(&session->dev, &scan_data);
> -	atomic_dec(&ihost->nr_scans);
>   }
>   
>   /**
> @@ -1912,8 +1889,6 @@ static void __iscsi_unblock_session(struct work_struct *work)
>   	struct iscsi_cls_session *session =
>   			container_of(work, struct iscsi_cls_session,
>   				     unblock_work);
> -	struct Scsi_Host *shost = iscsi_session_to_shost(session);
> -	struct iscsi_cls_host *ihost = shost->shost_data;
>   	unsigned long flags;
>   
>   	ISCSI_DBG_TRANS_SESSION(session, "Unblocking session\n");
> @@ -1924,15 +1899,6 @@ static void __iscsi_unblock_session(struct work_struct *work)
>   	spin_unlock_irqrestore(&session->lock, flags);
>   	/* start IO */
>   	scsi_target_unblock(&session->dev, SDEV_RUNNING);
> -	/*
> -	 * Only do kernel scanning if the driver is properly hooked into
> -	 * the async scanning code (drivers like iscsi_tcp do login and
> -	 * scanning from userspace).
> -	 */
> -	if (shost->hostt->scan_finished) {
> -		if (scsi_queue_work(shost, &session->scan_work))
> -			atomic_inc(&ihost->nr_scans);
> -	}
>   	ISCSI_DBG_TRANS_SESSION(session, "Completed unblocking session\n");
>   }
>   
> @@ -2192,7 +2158,10 @@ void iscsi_remove_session(struct iscsi_cls_session *session)
>   	spin_unlock_irqrestore(&session->lock, flags);
>   
>   	scsi_target_unblock(&session->dev, SDEV_TRANSPORT_OFFLINE);
> -	/* flush running scans then delete devices */
> +	/*
> +	 * qla4xxx can perform it's own scans when it runs in kernel only
> +	 * mode. Make sure to flush those scans.
> +	 */
>   	flush_work(&session->scan_work);
>   	/* flush running unbind operations */
>   	flush_work(&session->unbind_work);
> diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
> index c5d7810fd792..90b55db46d7c 100644
> --- a/include/scsi/scsi_transport_iscsi.h
> +++ b/include/scsi/scsi_transport_iscsi.h
> @@ -278,7 +278,6 @@ struct iscsi_cls_session {
>   	iscsi_dev_to_session(_stgt->dev.parent)
>   
>   struct iscsi_cls_host {
> -	atomic_t nr_scans;
>   	struct mutex mutex;
>   	struct request_queue *bsg_q;
>   	uint32_t port_speed;
> @@ -448,7 +447,6 @@ extern void iscsi_get_conn(struct iscsi_cls_conn *conn);
>   extern int iscsi_destroy_conn(struct iscsi_cls_conn *conn);
>   extern void iscsi_unblock_session(struct iscsi_cls_session *session);
>   extern void iscsi_block_session(struct iscsi_cls_session *session);
> -extern int iscsi_scan_finished(struct Scsi_Host *shost, unsigned long time);
>   extern struct iscsi_endpoint *iscsi_create_endpoint(int dd_size);
>   extern void iscsi_destroy_endpoint(struct iscsi_endpoint *ep);
>   extern struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle);

I have no issue with this, but it seems kind of unrelated to speeding up 
session unblocking ... Never the less:

Reviewed-by: Lee Duncan <lduncan@suse.com>

