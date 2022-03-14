Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 868A2C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Mar 2022 17:14:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243271AbiCNRPY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Mar 2022 13:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243238AbiCNRPV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Mar 2022 13:15:21 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2D536335
        for <linux-scsi@vger.kernel.org>; Mon, 14 Mar 2022 10:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1647278045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TMkdXOXWR9DKhrQ1aw8ZuRHZ8ZDU9PqxX25+Iep3tKI=;
        b=azFhqcDMxYsC3IEFmHoMnIwnGptLRpYtwGdLq9cUpJUoN9HefE+W3Rxyy0/wCgGEiG1N42
        kns7oSxwsytqtM7RX2GJDVlYLcKLg/fsDR2pxUq2Ga2ojDxXh08XihfK1ATQfH454pSpbC
        v8BqOBoeoUo05zMXLlwy6bDTQmX7KQE=
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur03lp2058.outbound.protection.outlook.com [104.47.10.58]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-37-SZilre4qPHe6XzreVoGmfA-1; Mon, 14 Mar 2022 18:14:04 +0100
X-MC-Unique: SZilre4qPHe6XzreVoGmfA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gks94nHNGq1E4I7SXWQX2Lkt6LDfZUiYcGGVn/j+zGAIzCv79blGMQa0JlqK/6mluDeGR2VZLFfdW8HFgEaWX5pEt0EzvMr44WTdU5T1br5SOK+Riu9KkgDa3NhG+aSSML/aQp7cduNHRfVVA02WFyk9iPY69fRKmyWBx2lU9vwAzO/JT4y3drSNZvX4oDH/vqQ8EPnl/ZpbRTBSwnhfe9Tz7P6hSNKlQBszPIjcJLhB9iGGhcKu4JMbwIizsFpEZBJOmXLo6oqLPi2jJjY2xq0UL9lhBEgjIhjlqWwwlDZ26/4J9rmHmM29fw0qSAoIgW3uK+3y4puwcFSzMhUhLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TMkdXOXWR9DKhrQ1aw8ZuRHZ8ZDU9PqxX25+Iep3tKI=;
 b=T5Nlq70y8POklpsGb4MAeprG5fp4xSPG5jtb3XfDbPYBz7T1UfoudG6T9RInowVLHjVA3IRIw0w97gA3h7n9RQD9E+rMKE0cEq8WAxv5omE8ySoPxypYEzLDq+QAdKFuOWNSna3vsIkVYQ4a8m3JZfOHiLUMUoaOO167+k2ZViJW+1RWM5Plvl1AJoELfgDV3ScB0uBVAvBZrBHmJUSSiSZVLrpUJ9lQ3dTN4ItgFLCXpEx7tD4EYevkSdzDKvRmse6AAww1SshLaXzghZnW6HN5zp13y3zaJSj1O4gAZF3nPb5Dyndmgmj1DDoCSLErYTFwAqdQeZrCxBqzNyOqrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by DB7PR04MB3993.eurprd04.prod.outlook.com (2603:10a6:5:1a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.28; Mon, 14 Mar
 2022 17:14:02 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::14d7:55aa:6af:72d7]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::14d7:55aa:6af:72d7%6]) with mapi id 15.20.5061.026; Mon, 14 Mar 2022
 17:14:02 +0000
Message-ID: <2fa05b86-f0a3-011e-7c77-bf81dab9f734@suse.com>
Date:   Mon, 14 Mar 2022 10:13:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 08/12] scsi: iscsi: remove unneeded task state check
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20220308002747.122682-1-michael.christie@oracle.com>
 <20220308002747.122682-9-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220308002747.122682-9-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P191CA0031.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8b::44) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7022a28f-041a-48d3-41cd-08da05de0919
X-MS-TrafficTypeDiagnostic: DB7PR04MB3993:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB39939FA0D81F638BB35E6F26DA0F9@DB7PR04MB3993.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OQUoXax1IPnLIDty9ojZYZrI6Wb4S4KqT1s+uIOT0aM4kRmum/dnSydJwlkRjGT6QF+tQHHoghO/zkBaiZyCzrYIMYHWMB1tjFYNLp4wY0nxfy0RguXFzVbApgsJixaskqFLgC/RZlgpIlNaxDFqU8bA317GRB+rzVh09F+ZoOnE2fE1gC25VOpHPkXpNjlOJLYnR07Cjz3TYQWCUQA5LMrzlwELVP9YP7vH7IfobkozLdf0mD0BvKFHWToyCKAGxnPZU3zvrh/BXByzVI/YP7i4oS+qpuxyb8sUELkIZ2CqRf7j8I6lsO/k+NVv9RlAsveE4XqOk+HMozmkVTCT0o71zZMNxAUrMH9EXfxXjCtufVv/JMMDuJOLYWe9xUh42N/4TG7VveOxU5iNwkWBeYTbGSCJo//yCcOtLlifHjHTu0IJFtMroHiDlQtfc2/ZKTNni9m5B7Fj5up3NQvaFOZziVkxu11LyLoBseuGz1HOBfvPrgWiC6N1w/9HdFE47C3/clZke3Ds1GFJ8k5arOQwfHpSjodp19+BG2lW/fURKwLoApmnfpst7jG6vXCdF0/SuJL02KBFcQTOTbF4Tv/2k9tG/Ifx2+bkVp3autPC0OZj2mdE9GJDvbuFzNzYZ0CVaiqmnIxfCLb9ZacMv31FVSYQHziL6pNKmb62t7KexvLqDwMY/ysYdE++Mopgezjg4QDLnVHIlGMjkYI4Sai1KY86VavrDQWdn32qC3s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(86362001)(31696002)(6486002)(8676002)(5660300002)(66476007)(66556008)(66946007)(38100700002)(83380400001)(26005)(2616005)(186003)(8936002)(36756003)(508600001)(316002)(53546011)(6506007)(31686004)(6666004)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S1loZVZJU09oM3NLVSt5YU4vUDdzVFl2QzV3UXhZdWV0NXlQSkVqdU1kbFk4?=
 =?utf-8?B?eVpmN3FZRnZLQUk3clRhYys2bTA0OWU2Mjl2VG9sRHRSVDd2bDRNTWdmaHJR?=
 =?utf-8?B?OFBKZXN2d0FvOXVTWXp1c0s3NUJHYWY4Q2dvLzNuVmR0MENmV042REEzWm8w?=
 =?utf-8?B?dlpnN0gwcEMzaWFsWUkzOVBnd2NVdUZjdDQwZlJIb09kNitDUWdKSC9ISGRy?=
 =?utf-8?B?QUptbWllK2FFU0hnSll0blA5WmRJd1pxb3dEbVo5eFRkWU80U2YzUVlDeXZM?=
 =?utf-8?B?Q2d0MkIzVXhDYlk4OUYvWVhrQzFqQVdTV2lWV1lkdEhrSXBrYnl3TEM0VlNP?=
 =?utf-8?B?VVhnZXNTTi92SmRDQllaSWJKTGxXWWFuV2I4a2oxT1I4T3B4YjNmMUFqb3JG?=
 =?utf-8?B?SGYrWWlNWER1Z21mc2JURTZiNmE0STVwUXFKVWZJS3djNUwxYVoyd3pjU04y?=
 =?utf-8?B?THNVV0JlbzRPUWUxYnVrRG5DeTF1WXU3VzNyaTFEcU4vZ0dsdjRBbFpLamtm?=
 =?utf-8?B?RE85cm5scXJ4VWdWWEFpTW5scDZyamhkZXd0SlpTanlnZ0hUTUxPaEpyZzFs?=
 =?utf-8?B?cW90SzJJeXp5ZUFKNGtCOXI5cjNPeDRVYVVEdU9VTzYzMzJ2UlV0OWtCN3k0?=
 =?utf-8?B?c1ZQOE9YNmlzR2kyVlBjRHJIWEFMYlV6SlBOeXVPUVBhZ3BFY3VCVExReUpU?=
 =?utf-8?B?ajJjZURxUC9COE5mdkNQNzMyeW1saTVHSmVrRVZaNVowR0tLc3lmYWdVeUxk?=
 =?utf-8?B?TW9DMk9SSVFmdmQ5Yk5LbGZ0bFlFMDV4UlFwZExHTHBWVXM4YU14cUJLcEFk?=
 =?utf-8?B?N0V5TEV0VHBLUk1jM0dwOStHeDNzdVMwUzUzbGZXWXNYWnlyc0FRTXFsdjNs?=
 =?utf-8?B?M0R5bjJnUGVMYVkxVUVkNDFmWVJTTHd2Rk8wQVcvYmthMVV1MzFEWFIzQzZO?=
 =?utf-8?B?T0FzN3BVT3huWmMvYUxjMmxQS0tsTmRiK0F5R1IwQTBic0lxM0RCSENTNThV?=
 =?utf-8?B?WFBTdWIwdjN2b2dKY3BpV1F2MHhGZ0ZzSXRrVGpiSWVSek5MR09jdm0xYWVt?=
 =?utf-8?B?K09xem1YallnOXh6cXpKVTFtQmpEa0hqRWZCc1NrRjByaE9sQVZWU2lqaTEv?=
 =?utf-8?B?V29RT3pRb0hYMnh6TmNjSHJnc09FWkJ6UVgwU1JsQ3pGQWdtWG1uNlgzRkFP?=
 =?utf-8?B?ZmZWWTdaQ1FxK2tDdElNRC9YN3RxOVBPd3VselBOODBsV2t2L1J2endIbHF5?=
 =?utf-8?B?Y2FHNDhjVWdTS0ZHclpoSGUxR1pxditKQkswSmttTWlOS0NWZ1gxVURSOFow?=
 =?utf-8?B?bmRHNkdEU0VKU0VZbWNFUzNXQ1JTb0xUaDhwS3BhRUlHSXpUSEhTYXNqaDM2?=
 =?utf-8?B?TUJieVowdElvaWN6SVJuUzlYaXFUUU16NUJrRkVGZjdGdmNSWXVkYUUwdEZJ?=
 =?utf-8?B?cHRRT0dpMHR2TTdlOVNnTHk4S2trdXhyWWQ0cTlraWFQbWRYeFhIMHNsOFpq?=
 =?utf-8?B?RThLUnl3aFdwT1V0UXhPMVBMMlZHWXlSNSt2K3p1TjZ0WGVSRTNmajUyKzNY?=
 =?utf-8?B?a2loeVlZSTFrTjhNeHgrdVlzY3lteWVpMURzQlNNeUdpOHkyRFZxRnRUVGp0?=
 =?utf-8?B?UWl1M1Fpd1NQSXZsTjVWZUg1MEVaU2d0c09uNVRMN0s0Q1dDZjFTWTZjcG0z?=
 =?utf-8?B?RTBiSW9OOHdXc3Q1SXhzK1NIbGdMTDR5aHVBMXZzamsyNTVBV0pFTllxd3NW?=
 =?utf-8?B?QmhQT25uN0dFSFZ1bDFFeno3L2p0aVVPenlrQjh2NGg0N0pOSE16L1ZSTVRh?=
 =?utf-8?B?eDJ4RmxodXlHL21vNzdiVUd6SVEyT0k4V2hhbGlXYmh3RnMvZHZTMmFhWk4w?=
 =?utf-8?B?NkFEZEFDZ1JjSnpiQy9RcFdIWlljT0k4QXRaUnMrNGdVSVZvZk9nLzVVamc2?=
 =?utf-8?Q?huRaISmL1bcAT5HMUGA+VIR/PCEeqBOh?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7022a28f-041a-48d3-41cd-08da05de0919
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2022 17:14:02.4562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R8/w6sKkwpbzCQKnSTQRfMaKKLkb/W8pkmeGovYm28FH4ty2OyO2Xk1TYpB9TmH+pfSefIEMPikU8Z8OYUBiEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB3993
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/7/22 16:27, Mike Christie wrote:
> The patch:
> 
> commit 5923d64b7ab6 ("scsi: libiscsi: Drop taskqueuelock")
> 
> added an extra task->state because for
> 
> commit 6f8830f5bbab ("scsi: libiscsi: add lock around task lists to fix
> list corruption regression")
> 
> we didn't know why we ended up with cmds on the list and thought it
> might have been a bad target sending a response while we were still
> sending the cmd. We were never able to get a target to send us a response
> early, because it turns out the bug was just a race in libiscsi/
> libiscsi_tcp where
> 
> 1. iscsi_tcp_r2t_rsp queues a r2t to tcp_task->r2tqueue.
> 2. iscsi_tcp_task_xmit runs iscsi_tcp_get_curr_r2t and sees we have a r2t.
> It dequeues it and iscsi_tcp_task_xmit starts to process it.
> 3. iscsi_tcp_r2t_rsp runs iscsi_requeue_task and puts the task on the
> requeue list.
> 4. iscsi_tcp_task_xmit sends the data for r2t. This is the final chunk of
> data, so the cmd is done.
> 5. target sends the response.
> 6. On a different CPU from #3, iscsi_complete_task processes the response.
> Since there was no common lock for the list, the lists/tasks pointers are
> not fully in sync, so could end up with list corruption.
> 
> Since it was just a race on our side, this patch removes the extra check
> and fixes up the comments.
> 
> Reviewed-by: Lee Duncan <lduncan@suse.com>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/libiscsi.c | 13 ++++++++-----
>   1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 0a0076144874..5c74ab92725f 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -567,16 +567,19 @@ static bool cleanup_queued_task(struct iscsi_task *task)
>   	struct iscsi_conn *conn = task->conn;
>   	bool early_complete = false;
>   
> -	/* Bad target might have completed task while it was still running */
> +	/*
> +	 * We might have raced where we handled a R2T early and got a response
> +	 * but have not yet taken the task off the requeue list, then a TMF or
> +	 * recovery happened and so we can still see it here.
> +	 */
>   	if (task->state == ISCSI_TASK_COMPLETED)
>   		early_complete = true;
>   
>   	if (!list_empty(&task->running)) {
>   		list_del_init(&task->running);
>   		/*
> -		 * If it's on a list but still running, this could be from
> -		 * a bad target sending a rsp early, cleanup from a TMF, or
> -		 * session recovery.
> +		 * If it's on a list but still running this could be cleanup
> +		 * from a TMF or session recovery.
>   		 */
>   		if (task->state == ISCSI_TASK_RUNNING ||
>   		    task->state == ISCSI_TASK_COMPLETED)
> @@ -1484,7 +1487,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
>   	}
>   	/* regular RX path uses back_lock */
>   	spin_lock(&conn->session->back_lock);
> -	if (rc && task->state == ISCSI_TASK_RUNNING) {
> +	if (rc) {
>   		/*
>   		 * get an extra ref that is released next time we access it
>   		 * as conn->task above.

Reviewed-by: Lee Duncan <lduncan@suse.com>

