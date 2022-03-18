Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A356C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Mar 2022 17:31:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239615AbiCRRdE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Mar 2022 13:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233290AbiCRRdD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Mar 2022 13:33:03 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0CBCF488
        for <linux-scsi@vger.kernel.org>; Fri, 18 Mar 2022 10:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1647624701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q0RI4WwxthWFzBpvaxQWOEIhxIUBMnxF8mBJNikI9g0=;
        b=J9/EG5gk2z26jhSaIZ+ik4O07fXDbOuu01pr1y4RhxKfT9LlDQFGerQ/dNmIpygJR06Z2o
        +SVrNJ6dDDfl8mqqXT4pPXx5PystLEAFF2PePr1//PqPQWwn64twy3jB5FNTh1SgQk3d3+
        BhecUInSbolzHzZgfW3KIojqcm0xA00=
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02lp2059.outbound.protection.outlook.com [104.47.6.59]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-33-FYtDrherNC-s3hriPWAk4w-1; Fri, 18 Mar 2022 18:31:40 +0100
X-MC-Unique: FYtDrherNC-s3hriPWAk4w-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f9B2utNWQr7IrZ9wfgobE4beUgAoUCw8PmueB0f/hwEWc2UXPeGisAOnTFi1A+Cb49Hl4ABAu+eKv6XBVUvGfybmgD19MQ4CAZ1scx42g0KBxr+KcObFPIuRYDnzYUPZSB35RPkqbjEVbma+QIWaeS6Pmoql+LHs7BjAdkaBqs4fMJiz1WKhm9wQWiZqeVGbjjIBJR2jJRj87SZgiisWaWjbjKlznzbABqPaXKC9FriE2CmGpNl+rJOrg1Mfzs5C8Z5KqzayCVkA+6biV2o5ZDWYgrGJxUSiDkZ3k7Q4j5jtuM4FdxZvnK2CmAOccCsBYG1QTLFusaCwrg83dsnNfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q0RI4WwxthWFzBpvaxQWOEIhxIUBMnxF8mBJNikI9g0=;
 b=M7nmLLPPk8iGmEqvcA3kld9ZrMZLufU0c2Tc9GZHP5Q8a4qU1YM1qAgIT46Up3d4O/nko78v9KoVtRElb97SEmtBT1K+024OkJ2GjR8Dlj3U/+0UAsb+rTGKj//S107lDHKytUf0vdur08jtPfiStZ3VJn15/f4XrPVUjmpSANl3aBfMqwU0fS4VgT2K3gX4j4l+TBJZs01Art3d2DgKKIRPsQjAxXcC4GzlNSrXLF1x4ONhZysCbBQ6MNe7jaTS0rCJj+zxFWp2/Tjl4EDNRDQ7Dl7RCWoADzlKOW7VqzZd8s4zZIp9ZNkyOHKcj2VNC/9SSea3r+rU9PJ5FeEGKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by VI1PR0402MB3791.eurprd04.prod.outlook.com (2603:10a6:803:1b::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Fri, 18 Mar
 2022 17:31:38 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::14d7:55aa:6af:72d7]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::14d7:55aa:6af:72d7%6]) with mapi id 15.20.5081.017; Fri, 18 Mar 2022
 17:31:38 +0000
Message-ID: <3fd9469f-4b6b-7264-2365-e9aa4e9234fd@suse.com>
Date:   Fri, 18 Mar 2022 10:31:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 09/12] scsi: iscsi: Remove iscsi_get_task back_lock
 requirement
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20220308002747.122682-1-michael.christie@oracle.com>
 <20220308002747.122682-10-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220308002747.122682-10-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM7PR03CA0030.eurprd03.prod.outlook.com
 (2603:10a6:20b:130::40) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9923622e-d171-4e78-7223-08da0905285e
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3791:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB37913E631D9F67550E720AD6DA139@VI1PR0402MB3791.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gsDliL0fDEwTp3rsbI0ebYFTcx4ORIXhkrqDCy5YEIm5jCya5AcjRzsxhEczKFQ5LHOLhuL2tMKxJWafogS2RafC+e8cou9SUABLWJDFruiBlETM4YnCnu8xlfr4CZbPqoK3w+lJrM/LcKA3kO1Phlw0SeYqV6gVNpAVyqb0JjgB6CnmFkhtALXMgdDTXXixlNNM4BuEN4hZR2mAS3UkGls6MFvgOe9p8vSbw4KW8SLbfBcdCrvDlkUIxnLM1pUX9YeVOUuOjI2sz3G/OejbfNIaUv5f8vBAV7AMTfJVnDOUqm0Q66Uvg5/9SoKnaFXgyVvPUmTHt/l5lnfzsb/PnPMtH/e6CX6L64Im94xrLj845QAXTeusNiDpR+WtWMr1pmhAd+Ia5odReMSM/oZA5CvXN8NSG4Db5att2pjyB9iBWc8cgq6k88wdNDJ6wi6QHdn5bFnPQN2sYoqY8PZX5kYz/4+bkuVjES/IyMcocowR6ar7YlXvvRvVYf2EiwiQk14+LoWSujl30wHMnmyJn8t9T+UztEd54uqZxyxH9frsztvuqwaLuwLiffhRjQv1FzMFNYnjxJo+j+eO0opEapBYCFxTe3i3dd/AShnvp3Fdw4CPg0IMDxRGPVr+/P8sV/kXofb1JtZ2QZQWJ5LMNy2m/gp8AMUCeufQnVU1EwYq5JRjmRkOrh+I7v2pSHFA0xgB+IRjwC/zoONas3V0zv40n7eEAw0iJF1FqoFiRIzrqxCfGSVaAu3NfbmgFo3D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(53546011)(6486002)(508600001)(6512007)(316002)(31696002)(66946007)(83380400001)(38100700002)(6666004)(30864003)(8676002)(66476007)(66556008)(86362001)(2906002)(36756003)(26005)(31686004)(186003)(8936002)(5660300002)(2616005)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QVhwU2ZVTnZCSGJua2VhdjdQTy8xUjFEZU1RVGtOZHZwa0pjRUxsK2tRajhD?=
 =?utf-8?B?RkIxU2Q4TlA2N1dONStjZVRUSTVBWGNPMHBWR1dMZ3ZYSFAxdUFlVHpndDhP?=
 =?utf-8?B?clNQWU9TZzl0TFk2QUR2OU9ZVHRkQkZIdU12L3l5cmY1Q3ZlWTR5K0thNlJ0?=
 =?utf-8?B?a3g4OWpiU255dW4waHRoRWpOT0d1OHpnUURBS3YxMlZpNFNnVFV6VHovUzMw?=
 =?utf-8?B?b29VTkdyTTFpVUo1RElkcEpQRmJpRnc3L2FweWVlTXg4UFphK1N3bXQ4TlRr?=
 =?utf-8?B?cVY3QWl2U3Y0MVNJTzZ4VHY0WXhEcHgvZjVKWkE2d09PZDFLUmJwNUlnSlFu?=
 =?utf-8?B?RlpmYmFEcW5jN2NyeWlSK3FXRDE3dU0wM3pyOFMzNXJ0ZkJDTXJ0TEt4MnRG?=
 =?utf-8?B?WHhDaHJDSjJIeW52N01aZnlMMFZRVEtTQzhFWDJtTHpsVUlPb1BCTTZYQWVv?=
 =?utf-8?B?b0F5cnRQWlpiUjA0UCt2cFF3amd1RVNzZjFuQ29oNVp5NGRWSXc5MnZqTDdu?=
 =?utf-8?B?bGpqbTN4QVFYWHdVQUJKNFc1SjdLSjhvS2xlTU9jU1JTdHlsbDFKUStEdVAy?=
 =?utf-8?B?S3BXL2xqMmtkWVJxbTVDVWFmNXpROWUvNUpzZEtOcFV6eVNUNWNJSlJLTk5O?=
 =?utf-8?B?ZHlsSFdVbW9senJ3akJCY2hkaGY1ZmRsWHdyZFlTQUUyMU9OUDU2djNxSWg2?=
 =?utf-8?B?dHJKRFVySXVpUFRUS0tScTlFSUFQNHZUV0tNQXpkb3dYZHNJaElUYnBsZm1p?=
 =?utf-8?B?RU5ZZ2NGQXBUSGtZblpyMTh0MDJURnBtTkgvb0xRMlk1S29IWENjckFCelpB?=
 =?utf-8?B?d2xldlByUnE3ZFhvZi8rZjcwMWFXZTJXZUZobGw3R05uYitUQmJSZ3BHM2hm?=
 =?utf-8?B?ZnpGWUpYdC9xQ29BQlVsN3NPSitGeHYzOXZIVTlTNG1odzd3UndzRHhEeWk2?=
 =?utf-8?B?cGF6cmdJUmxBRCthWWVEdlZMSitkVk53NmZ6QW92TkVUYXVITjhaRWk1WTA2?=
 =?utf-8?B?YUVodlZZbnQ0UzAwNHhLOXVBSkk2eG1EakJuazU2dVhSYTBHaWlHcVpIbkYz?=
 =?utf-8?B?d2hFekFMMjJ0a0RhSkRWZXQ2SmZyc1puMzJ4d2ZpdFZTaUJmNDduYmNITnY4?=
 =?utf-8?B?WmRyN0VKQ2FlVm9rNnMyMlBLN1ZiZW04RUpGWkw4ejUvKzJxeEYxcWZRZ2lW?=
 =?utf-8?B?QVhPRHh1ZFAwWnBlVXhGdDNEb3RBZDBhbFBjMy9iU0swVTYzbmpmSkRuZEpJ?=
 =?utf-8?B?d1BLby9UbFVLTG1aQVI4ZThERzZSTEVabk1FdUV5a1lHUjNsUWV6U3E0Wkdz?=
 =?utf-8?B?WDIrMEVhZ0dKM0JpbHJNbklwSXE2QkN4a3VLQkx1VEJ2OUhrMHFhblNhQ056?=
 =?utf-8?B?WEtBZmtHbGFvVnF5OUVaZ0ZCb2NVOEZndEFIUi9hR0xybkhSbldndFBJUEQ5?=
 =?utf-8?B?ckVyY1NYc2NOT1Nmb0dsbWF2Y0JudEdDcnVhS2RGSGpGWlV2Z2MrUjIrUEFj?=
 =?utf-8?B?dHZ0Y0xJc0JlZk96bUt3bGhVMEswL044N3VGeExBdGRRU3AyTldnaGR5Q2Va?=
 =?utf-8?B?b0VlSDFjalRhRllMUzdFOEJGV1FmOFJIUGVrcFNMVmRzMEhKWlJGMDZMVlFL?=
 =?utf-8?B?S1RGK1JNdlFyczU4eHB4bTVMb0JGWGk1K2JYcVh3a2x2SGtEQ3FiR1gvTjVi?=
 =?utf-8?B?RHlmUENFUTJnb2czbE1VTzZwSG1PMFZ2UktjNUhQRHVpb3BMSjZ4d0lLRksv?=
 =?utf-8?B?ZkdPOGN1MWpadTcreXM5UHVLNndHdFpFWVJBeWlVUXltc3doa3FhenNoR3V1?=
 =?utf-8?B?dnNRaXUwTEYyY1pNdHZWazJBWklZQUJoWWFhK3pvZGsvU1hKRVFkK2FJMkZ3?=
 =?utf-8?B?akNCekplQVpGcE9XUDNIMW83dEUrZnhvY0ZCck02emVsRFNBMzZGK2NybGdK?=
 =?utf-8?Q?D+ZMeAe2wFCd2KklRuH9dPdILz56BIMS?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9923622e-d171-4e78-7223-08da0905285e
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 17:31:38.4361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Q1pS1j58yPMz3XX/k399e0i/OUr0ruYRkh0NhK9if0ySXrrYArZi+XmFjvDpZ/c1h+0rCT/P0X3ipW6nEiiYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3791
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/7/22 16:27, Mike Christie wrote:
> We currently require that the back_lock is held when calling the functions
> that manipulate the iscsi_task refcount. The only reason for this is to
> handle races where we are handing SCSI-ml eh callbacks and the cmd is

handing -> handling

> completing at the same time the normal completion path is running, and we
> can't return from the EH callback until the driver has stopped accessing
> the cmd. By holding the back_lock while also accessing the task->state
> makes it simple to check that a cmd is completing and also get/put a
> refcount at the same time.

This last sentence doesn't completely parse. Maybe leave off the work "By"?

> 
> The problem is that we don't want to take the back_lock from the xmit path
> for normal IO since it causes contention with the completion path if the
> user has chosen to try and split those paths on different CPUs (in this
> case abusing the CPUs and igoring caching improves perf for some uses).
> 
> This patch begins to remove the back_lock requirement for
> iscsi_get/put_task by removing the requirement for the get path. Instead
> of always holding the back_lock we detect if something has done the last
> put and is about to call iscsi_free_task. The next patch will then allow
> iscsi code to do the last put on a task and only grab the back_lock if
> the refcount is now zero and it's going to call iscsi_free_task.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/be2iscsi/be_main.c | 19 ++++++-
>   drivers/scsi/libiscsi.c         | 95 +++++++++++++++++++++++----------
>   drivers/scsi/libiscsi_tcp.c     |  5 +-
>   include/scsi/libiscsi.h         |  2 +-
>   4 files changed, 88 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index ab55681145f8..26e5446ac237 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -231,6 +231,7 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
>   	cls_session = starget_to_session(scsi_target(sc->device));
>   	session = cls_session->dd_data;
>   
> +completion_check:
>   	/* check if we raced, task just got cleaned up under us */
>   	spin_lock_bh(&session->back_lock);
>   	if (!abrt_task || !abrt_task->sc) {
> @@ -238,7 +239,13 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
>   		return SUCCESS;
>   	}
>   	/* get a task ref till FW processes the req for the ICD used */
> -	__iscsi_get_task(abrt_task);
> +	if (!iscsi_get_task(abrt_task)) {
> +		spin_unlock(&session->back_lock);
> +		/* We are just about to call iscsi_free_task so wait for it. */
> +		udelay(5);
> +		goto completion_check;
> +	}
> +
>   	abrt_io_task = abrt_task->dd_data;
>   	conn = abrt_task->conn;
>   	beiscsi_conn = conn->dd_data;
> @@ -323,7 +330,15 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
>   		}
>   
>   		/* get a task ref till FW processes the req for the ICD used */
> -		__iscsi_get_task(task);
> +		if (!iscsi_get_task(task)) {
> +			/*
> +			 * The task has completed in the driver and is
> +			 * completing in libiscsi. Just ignore it here. When we
> +			 * call iscsi_eh_device_reset, it will wait for us.
> +			 */
> +			continue;
> +		}
> +
>   		io_task = task->dd_data;
>   		/* mark WRB invalid which have been not processed by FW yet */
>   		if (is_chip_be2_be3r(phba)) {
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 5c74ab92725f..a2d0daf5bd60 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -83,6 +83,8 @@ MODULE_PARM_DESC(debug_libiscsi_eh,
>   				"%s " dbg_fmt, __func__, ##arg);	\
>   	} while (0);
>   
> +#define ISCSI_CMD_COMPL_WAIT 5
> +
>   inline void iscsi_conn_queue_xmit(struct iscsi_conn *conn)
>   {
>   	struct Scsi_Host *shost = conn->session->host;
> @@ -482,11 +484,11 @@ static void iscsi_free_task(struct iscsi_task *task)
>   	}
>   }
>   
> -void __iscsi_get_task(struct iscsi_task *task)
> +bool iscsi_get_task(struct iscsi_task *task)
>   {
> -	refcount_inc(&task->refcount);
> +	return refcount_inc_not_zero(&task->refcount);
>   }
> -EXPORT_SYMBOL_GPL(__iscsi_get_task);
> +EXPORT_SYMBOL_GPL(iscsi_get_task);
>   
>   void __iscsi_put_task(struct iscsi_task *task)
>   {
> @@ -600,20 +602,17 @@ static bool cleanup_queued_task(struct iscsi_task *task)
>   }
>   
>   /*
> - * session frwd lock must be held and if not called for a task that is still
> - * pending or from the xmit thread, then xmit thread must be suspended
> + * session back and frwd lock must be held and if not called for a task that
> + * is still pending or from the xmit thread, then xmit thread must be suspended
>    */
> -static void fail_scsi_task(struct iscsi_task *task, int err)
> +static void __fail_scsi_task(struct iscsi_task *task, int err)
>   {
>   	struct iscsi_conn *conn = task->conn;
>   	struct scsi_cmnd *sc;
>   	int state;
>   
> -	spin_lock_bh(&conn->session->back_lock);
> -	if (cleanup_queued_task(task)) {
> -		spin_unlock_bh(&conn->session->back_lock);
> +	if (cleanup_queued_task(task))
>   		return;
> -	}
>   
>   	if (task->state == ISCSI_TASK_PENDING) {
>   		/*
> @@ -632,7 +631,15 @@ static void fail_scsi_task(struct iscsi_task *task, int err)
>   	sc->result = err << 16;
>   	scsi_set_resid(sc, scsi_bufflen(sc));
>   	iscsi_complete_task(task, state);
> -	spin_unlock_bh(&conn->session->back_lock);
> +}
> +
> +static void fail_scsi_task(struct iscsi_task *task, int err)
> +{
> +	struct iscsi_session *session = task->conn->session;
> +
> +	spin_lock_bh(&session->back_lock);
> +	__fail_scsi_task(task, err);
> +	spin_unlock_bh(&session->back_lock);
>   }
>   
>   static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
> @@ -1449,8 +1456,17 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
>   	spin_lock_bh(&conn->session->back_lock);
>   
>   	if (!conn->task) {
> -		/* Take a ref so we can access it after xmit_task() */
> -		__iscsi_get_task(task);
> +		/*
> +		 * Take a ref so we can access it after xmit_task().
> +		 *
> +		 * This should never fail because the failure paths will have
> +		 * stopped the xmit thread. WARN on move on.
> +		 */
> +		if (!iscsi_get_task(task)) {
> +			spin_unlock_bh(&conn->session->back_lock);
> +			WARN_ON_ONCE(1);
> +			return 0;
> +		}
>   	} else {
>   		/* Already have a ref from when we failed to send it last call */
>   		conn->task = NULL;
> @@ -1492,7 +1508,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
>   		 * get an extra ref that is released next time we access it
>   		 * as conn->task above.
>   		 */
> -		__iscsi_get_task(task);
> +		iscsi_get_task(task);
>   		conn->task = task;
>   	}
>   
> @@ -1907,6 +1923,7 @@ static void fail_scsi_tasks(struct iscsi_conn *conn, u64 lun, int error)
>   	struct iscsi_task *task;
>   	int i;
>   
> +restart_cmd_loop:
>   	spin_lock_bh(&session->back_lock);
>   	for (i = 0; i < session->cmds_max; i++) {
>   		task = session->cmds[i];
> @@ -1915,22 +1932,25 @@ static void fail_scsi_tasks(struct iscsi_conn *conn, u64 lun, int error)
>   
>   		if (lun != -1 && lun != task->sc->device->lun)
>   			continue;
> -
> -		__iscsi_get_task(task);
> -		spin_unlock_bh(&session->back_lock);
> +		/*
> +		 * The cmd is completing but if this is called from an eh
> +		 * callout path then when we return scsi-ml owns the cmd. Wait
> +		 * for the completion path to finish freeing the cmd.
> +		 */
> +		if (!iscsi_get_task(task)) {
> +			spin_unlock_bh(&session->back_lock);
> +			spin_unlock_bh(&session->frwd_lock);
> +			udelay(ISCSI_CMD_COMPL_WAIT);
> +			spin_lock_bh(&session->frwd_lock);
> +			goto restart_cmd_loop;
> +		}
>   
>   		ISCSI_DBG_SESSION(session,
>   				  "failing sc %p itt 0x%x state %d\n",
>   				  task->sc, task->itt, task->state);
> -		fail_scsi_task(task, error);
> -
> -		spin_unlock_bh(&session->frwd_lock);
> -		iscsi_put_task(task);
> -		spin_lock_bh(&session->frwd_lock);
> -
> -		spin_lock_bh(&session->back_lock);
> +		__fail_scsi_task(task, error);
> +		__iscsi_put_task(task);
>   	}
> -
>   	spin_unlock_bh(&session->back_lock);
>   }
>   
> @@ -2035,7 +2055,16 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
>   		spin_unlock(&session->back_lock);
>   		goto done;
>   	}
> -	__iscsi_get_task(task);
> +	if (!iscsi_get_task(task)) {
> +		/*
> +		 * Racing with the completion path right now, so give it more
> +		 * time so that path can complete it like normal.
> +		 */
> +		rc = BLK_EH_RESET_TIMER;
> +		task = NULL;
> +		spin_unlock(&session->back_lock);
> +		goto done;
> +	}
>   	spin_unlock(&session->back_lock);
>   
>   	if (session->state != ISCSI_STATE_LOGGED_IN) {
> @@ -2282,6 +2311,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
>   
>   	ISCSI_DBG_EH(session, "aborting sc %p\n", sc);
>   
> +completion_check:
>   	mutex_lock(&session->eh_mutex);
>   	spin_lock_bh(&session->frwd_lock);
>   	/*
> @@ -2321,13 +2351,20 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
>   		return SUCCESS;
>   	}
>   
> +	if (!iscsi_get_task(task)) {
> +		spin_unlock(&session->back_lock);
> +		spin_unlock_bh(&session->frwd_lock);
> +		mutex_unlock(&session->eh_mutex);
> +		/* We are just about to call iscsi_free_task so wait for it. */
> +		udelay(ISCSI_CMD_COMPL_WAIT);
> +		goto completion_check;
> +	}
> +
> +	ISCSI_DBG_EH(session, "aborting [sc %p itt 0x%x]\n", sc, task->itt);
>   	conn = session->leadconn;
>   	iscsi_get_conn(conn->cls_conn);
>   	conn->eh_abort_cnt++;
>   	age = session->age;
> -
> -	ISCSI_DBG_EH(session, "aborting [sc %p itt 0x%x]\n", sc, task->itt);
> -	__iscsi_get_task(task);
>   	spin_unlock(&session->back_lock);
>   
>   	if (task->state == ISCSI_TASK_PENDING) {
> diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
> index 883005757ddb..defe08142b75 100644
> --- a/drivers/scsi/libiscsi_tcp.c
> +++ b/drivers/scsi/libiscsi_tcp.c
> @@ -558,7 +558,10 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
>   		return 0;
>   	}
>   	task->last_xfer = jiffies;
> -	__iscsi_get_task(task);
> +	if (!iscsi_get_task(task)) {
> +		/* Let the path that got the early rsp complete it */
> +		return 0;
> +	}
>   
>   	tcp_conn = conn->dd_data;
>   	rhdr = (struct iscsi_r2t_rsp *)tcp_conn->in.hdr;
> diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
> index 522fd16f1dbb..9032a214104c 100644
> --- a/include/scsi/libiscsi.h
> +++ b/include/scsi/libiscsi.h
> @@ -470,7 +470,7 @@ extern struct iscsi_task *iscsi_itt_to_task(struct iscsi_conn *, itt_t);
>   extern void iscsi_requeue_task(struct iscsi_task *task);
>   extern void iscsi_put_task(struct iscsi_task *task);
>   extern void __iscsi_put_task(struct iscsi_task *task);
> -extern void __iscsi_get_task(struct iscsi_task *task);
> +extern bool iscsi_get_task(struct iscsi_task *task);
>   extern void iscsi_complete_scsi_task(struct iscsi_task *task,
>   				     uint32_t exp_cmdsn, uint32_t max_cmdsn);
>   

Reviewed-by: Lee Duncan <lduncan@suse.com>

