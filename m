Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39911C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Mar 2022 17:44:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238425AbiCNRpz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Mar 2022 13:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiCNRpy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Mar 2022 13:45:54 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DEB6164
        for <linux-scsi@vger.kernel.org>; Mon, 14 Mar 2022 10:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1647279881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UGxDtoHYCcxQhOje+q8zcWTOfc3EDn0ruvOONGtn/Vs=;
        b=JzmFpshTkN5lFMshFjCnNe6zE/yxD0c881zkVO79PzzdFogjJJk6fOdB1yKwq0ejgPrQhk
        812+QNDeLat8ylyIoGVdAJviu8V8NlIV3SvnnquQRDI9KnRR+GCHYC9ibNKV5KdaQhaoEK
        wYn09TGG4ZXFlRwXlr7npvdGHGxj/ss=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2107.outbound.protection.outlook.com [104.47.18.107]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-31-FlfL6ocRNzW5TGF23tFBmA-1; Mon, 14 Mar 2022 18:44:40 +0100
X-MC-Unique: FlfL6ocRNzW5TGF23tFBmA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HhAZwAxs9PkWaqcz8EJ0xSMSieWq2tPp5UbU99QCa3mFWs9du3CZMMAPUVTOMyGlsNoNjzcr4Nmu8lHAwpyV/FA9jnpcMGdDaO57lW835B4nqxxbe2xeqad2DE6+WJEoiGmYBgNSKUUMcD9cADLfhhZq6xLOMev41CI8o7zZA4gJ/Q1PPg7f+c9kr9qVPinrZS59r8QHsxlXCrywRsiuR+LWrDn933747iX2wumnZ7kXw7kBSFkG5AC1V62JdPr29CduW5IVUxK7x97KEfqKQuDcWptokU9b0MwQFp2AGe0qXDTNRqP7UTFAkPu+kZtQuEmck57oMLASMV7YTDyc9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UGxDtoHYCcxQhOje+q8zcWTOfc3EDn0ruvOONGtn/Vs=;
 b=GiSD+ledfYNM/DYnXTii7KXEPVbNdzrOq3ghLL2u04WWx9Tqutk92elmhCDMZuYGE2SWg8j5wK5hGihDsXM8jUOlfDl0Dy2/1v5/O8zSfp6i43dJWHy5//VnT1S84Ib08suXndi8Ut/XXfz/mEb8TlRwzOmSmTh/TVQRDaHqLoy+0etgLaPt2F7h+fvul6Qh9sw7C9m1wq+MbRz/ugCglVrZ2MzAoE5I5QZykXl658bEF7asUJVUNbOQly784uc8PBfznrCMqxPuTW2D7uahxZMgE4qnRVrImsRSLIs/6KjNEwzjdb2/tPIVY+9smtemuhdsrCXu0+1f6nfn1kbi+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from HE1PR04MB3098.eurprd04.prod.outlook.com (2603:10a6:7:20::28) by
 AM6PR04MB4773.eurprd04.prod.outlook.com (2603:10a6:20b:10::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5061.28; Mon, 14 Mar 2022 17:44:39 +0000
Received: from HE1PR04MB3098.eurprd04.prod.outlook.com
 ([fe80::213a:cd92:6fd4:7fe0]) by HE1PR04MB3098.eurprd04.prod.outlook.com
 ([fe80::213a:cd92:6fd4:7fe0%3]) with mapi id 15.20.5061.028; Mon, 14 Mar 2022
 17:44:38 +0000
Message-ID: <5897bbd5-d3e2-0c4a-62f5-572955d266bf@suse.com>
Date:   Mon, 14 Mar 2022 10:44:32 -0700
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
X-ClientProxiedBy: AS8PR04CA0140.eurprd04.prod.outlook.com
 (2603:10a6:20b:127::25) To HE1PR04MB3098.eurprd04.prod.outlook.com
 (2603:10a6:7:20::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2ac2237-d305-47b9-7444-08da05e24f28
X-MS-TrafficTypeDiagnostic: AM6PR04MB4773:EE_
X-Microsoft-Antispam-PRVS: <AM6PR04MB4773787CEAD3A3E7DAC673ABDA0F9@AM6PR04MB4773.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2oktCn29VSMuzVRpb7Yo+dwLhklMic+1KGpRohPWQ1jsrF0Iqe0Ld7TdApenj7OhNfJq3OBRjgqBJveLjBR8hdVN3QIaCb9ouEubZiVHHj0/K4j7iLnNuThB5xDQN9WN78DJyJA29QyBXI09ViWzxsxWMQv6RmwaE2xUuMZ2PrIdVdCJv+ZbEec8+2kBI6H5Dt/e8G0uCaRF8Visap2pDaAwJLgdffypuryjIzSz5GrWri0ae0tHcJ9E4UqoJ2YsU9/eI7F1YLrmFYLJLXZu3h6fu4jAlRAtPmmB6FBw9vboSXIIsFvLATesJfFUDvXHVnokR9p2sLjnDr51f31xj1hYxakFiXZckIfGJ0ZWe0ofpjW+yzU/XfcfX8ddyCZyQfC9dx5s0IyAvjJtvjPhMRm6A0o2yH0aMp2PqenxoxUivvA0Hi1IjXuYkIWr2kjgTs0k6mNGB3ZeKcnvydA11oU8p+bwyGr+c8P8d+F0W86Or1a+Ebn3bZMLtZfcX5aKww0QE6/T38jj7+NEI5OFgcUavXiLKOVvByxbejRPo1pKWL/LYTcz/0GNtfBpLSH0ghs/hKUrvx9e7dgqOQVhn7wWzkdMePj0gOzAWiYCQpt6I6Og+3RyEVpHTv7otdxqTTeq7987eXVG/YlorzRdqkvPGUyZpyGgGgNDziSR/+AO/nbbNq8+RVFg78ni1OA9uc3JIOiVFHTgVwqy5LpcKz4UaQ6xLAk1KirTS948bSU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR04MB3098.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(8936002)(2616005)(83380400001)(5660300002)(30864003)(38100700002)(6666004)(26005)(508600001)(6486002)(186003)(86362001)(36756003)(31696002)(31686004)(2906002)(316002)(6506007)(66556008)(8676002)(66476007)(53546011)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VUYwRGJXclJvQ2VtaFpERTBOZHdEODFpTlRobVBKOUxQL01CWEE2ODc5eTlN?=
 =?utf-8?B?eld6SHRtOGdhYWpiQytidHJ5TEZ4TVVNZCt0UHdvSDFnaEJNd251UllTenNy?=
 =?utf-8?B?VGZNcThFMWhUWUs3aXpsekJneHVkWkpKWWJpcUpMckRwVXA3WkkyUjB3ZnpJ?=
 =?utf-8?B?eFBQNzFNMTZJc081YzNabngrZWZTbVBMYkxJYTR0Tkl4YlJ3alJwNEllbUYx?=
 =?utf-8?B?UzhEY0ZIN3IvMGhEc3FBeWFJWDRxbDFNQmxnbmZyZHhKb2JrdFR1dWJlNnVR?=
 =?utf-8?B?OEc4d2VFYUtvMWNUTHFXbGd6R2dXZnFEWlROaDc2YW90cUpmTk8xUXk5bVJS?=
 =?utf-8?B?WDVEN0pGYThaWWowVVBEc2Z4T2VOVVVpaUx6anNCa2ZtZU9INEp4NHVUTzVu?=
 =?utf-8?B?UnhDMVRBamUwTlNUWnRkUUk0a2s4ZFlucU5YcHIwRnFDbUgwWEptVWY3OEU1?=
 =?utf-8?B?WTNPdVRyVHlPYThNYjFMb0J5dmI4bVVHN1k2UEtGRnVPeU4zclN4dlh3KzdT?=
 =?utf-8?B?QkROWlNSaWJUUDh4Z0ZOclNXU0JmbGF1d2J5eDVhZDIvY2tISkdaeTVaaUNR?=
 =?utf-8?B?Y29wSVBYNnRrUFp6YUkrQ3RZREo5eWhxeitYTkcxdS90eHJ6cVFCVFRleG9v?=
 =?utf-8?B?UU45T2ZJSVZYSnk3K28rNmtERE9YWUxvaVlsdUJWaHV0WEFXVkFrbmFNcmgz?=
 =?utf-8?B?Z3o0SzlYZlJFZ0NJOXV3dUROSFYvL1lkS3E0amZMTFZ0b281V0ZwSUpFcXUx?=
 =?utf-8?B?R2RMSGg4WGJaN1JLb3hXWXh4NWpyZkFJSG5PVm8wOC9pak5GMURQRGRtSjNU?=
 =?utf-8?B?alRTY3NiOTVxSjZuN0V6Y2tOWC9hTlBrRjZ6YzBZREV1bkFxaTNxMm1rakU3?=
 =?utf-8?B?dzhSYVB2NEI2akt0WitGTTF0MmxKQUtKRis4bWJUMUZJcnBQWlRQZENZUGth?=
 =?utf-8?B?c2hMMEVLbTR1R3lWNnBRRE5SemF1Zi92SnR2V0VMczhCbUdVZjZPYldHdG54?=
 =?utf-8?B?YW1ZaU4wV2tsUGlZOUlPTUdIaFF6WC9QNWRINVVFSGk0T3ExZDMyL29acmM5?=
 =?utf-8?B?MEZTaEwzd1RaQTRqeHlyR2V0dy9naXdITmRpWWlIeVJuUFNMeEQ5WGZhcmcy?=
 =?utf-8?B?UEcvWUJSMDRVcWV6OEhYckxFaUkvN01MM25DdVpVUFFuWE9ma01ESHpzbC9y?=
 =?utf-8?B?b2czNysvQitGbFNSSUZPbm1QLzNJWHZxS1ZyUWdYUXRZN1NKMjlEL0dUWTV2?=
 =?utf-8?B?REtnalI5cDlCWjJFWnNuTmVBSm1YYzVwc1YvZnkwZGtTQnlRMm9zcEhyUnVm?=
 =?utf-8?B?NUtFdTdHMUZDSTZWZmQ2bHRLdXVEdHdQcUJ0T1NZenRVbUx0ejFMMjBKTFFt?=
 =?utf-8?B?U2JjeWZ4SCt2QUk4Sk9haVJwZDFvdmJwaFd1UUx2UFZNZkw4QkVuSVRHWkdm?=
 =?utf-8?B?dmhjeElmdmswWGZFK3YwTi9Uc1BSWUtaUGJ1d3RKWEM0aXEzanVZVms0ODVH?=
 =?utf-8?B?VDdITENUYTAvakwyUzkwMm9HOVcyM2dSbkJ5V281MjNWcDdmZSt4ZUsxK2w4?=
 =?utf-8?B?UmtyMm51R2FRbHQ5djY4QnZMZSt1bFNpcWtLZDY5T3l0RmZOdCtLNDlza2Zq?=
 =?utf-8?B?VUJtdlB3aVdMK1BPdzV3TGx0MWVPSnpyWWVxSmhqNmZ4Z2lZQ0kza1lZVjIv?=
 =?utf-8?B?cXVlZEwweDlOcTJ2MHN5Rnd6Mm94VHhMeDJ1Vjl2RUVkMDRxb2Q2VG9SL2gr?=
 =?utf-8?B?NUVRRXNvdmY1SWlTZ1p5TXFpcktiK1lMcC95RXRwN2I5dlZGYTRuSXNQZHhG?=
 =?utf-8?B?VVJnYWlPUjdxRzA2YVp2cy9ETHZHSWNDc0FFeTlFckwwRmVNZ2xHZFlvd3NX?=
 =?utf-8?B?Q2FsOWZoLy9SZXc0aGhxZzdzQUtlTVo2dzJ2ZEsyYURnNkZMQW80ODRPZzZv?=
 =?utf-8?Q?ZJQ4TfSEgxZgulHz2VUB2qOrUwsSWAai?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2ac2237-d305-47b9-7444-08da05e24f28
X-MS-Exchange-CrossTenant-AuthSource: HE1PR04MB3098.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2022 17:44:38.9363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1QZfxPMZW/FOslZysSdRfhX0xZKW4U+X/NX/V3nFzJId2RW08UtfFsiEjAFw8dTLRI1hquViSf03P8kHtjzsTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4773
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/7/22 16:27, Mike Christie wrote:
> We currently require that the back_lock is held when calling the functions
> that manipulate the iscsi_task refcount. The only reason for this is to
> handle races where we are handing SCSI-ml eh callbacks and the cmd is
> completing at the same time the normal completion path is running, and we
> can't return from the EH callback until the driver has stopped accessing
> the cmd. By holding the back_lock while also accessing the task->state
> makes it simple to check that a cmd is completing and also get/put a
> refcount at the same time.
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

