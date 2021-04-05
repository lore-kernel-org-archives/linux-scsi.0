Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C72B0C001BD
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Apr 2021 16:04:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 978B6613D5
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Apr 2021 16:04:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242020AbhDEQEZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Apr 2021 12:04:25 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:24365 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241882AbhDEQEL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Apr 2021 12:04:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617638643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4MLqTC3EqyF+JwWuEOrcAghkrZppOfis/QAZxgEy1HY=;
        b=P+E4nm/ARrkmhIR1bFWbUhDHFbCpyUf5wNpylNVG8gabtDPCLeHVzHc4YMXtPY6I+iMSqd
        NSaw2jNszDuxxLP2+KcGVwp9+qWTMRS+GoI2mgol8p44Q3sPNwiKStS4LrpU/1U5NzCR7+
        uJn4uQAigRTBFZv5kd9iLC7uKWkKVoE=
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01lp2056.outbound.protection.outlook.com [104.47.1.56]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-34-xvdgbKweO3K7M0_I6N6tYQ-1; Mon, 05 Apr 2021 18:04:02 +0200
X-MC-Unique: xvdgbKweO3K7M0_I6N6tYQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WQjjr735WYZGuH1f+dakkxvU/kYeaLToQwNVDs3Y1aCvo/NYc0JjgLlK3BDGjzCGXdfUsc9xDKPx6Kw4nPixGmtYQr553pKgKMcz7xJeX2ttPbVfoylo7QOOi5I2nQwuRoHpSm2EIUiuiDu6v6COoLtsiQOtLa3+Q0fstFRwnVH6/QyuHhgN9qVp6QETXJaJMazcpekGcRzRXK2zVtculgL2fLeuElYEFwiJMZo4i3f3HSgE5ncbmwm74x3SN7fvRGVjCvPgdm6iiQnHOC5o0PWaCunJG+c5BNI6i5xTsGL8/KUwdGXMJE/tFyxonHQu0XdPTxN2zOinUpLFPjpmIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4MLqTC3EqyF+JwWuEOrcAghkrZppOfis/QAZxgEy1HY=;
 b=Vney9xlksNucFAfGxcKlvHz1QS0oGBpsWeiLcYpTOa5EgEPzlevYuIHExlb4NDurpk3Fy/1g4n+M3mU6ANfohc3xRNZgCYXQIaNKHr1aMTFtWMxYQuy5y3D11ohtV9PCVrZ1qSF5GlAsfTSU4HYb/WNJUsosY1XsDpLikkf36BUZIFzzSc9v9a3zc4KcTORW2leJART0doA+fSsANrzFQzfmFLTY6pJkNRQnQASmo6Rhee1QEVngsy5Pt6YmXZokPQJiEHxnniuguVEu+m8Cw7ZJw9iX3XyKRV7CKZkWUWqCQVPq2qn0y5GAr4kPql/2TthA4L7gzcxH8ma+uxIQig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AS8PR04MB7781.eurprd04.prod.outlook.com (2603:10a6:20b:2a6::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Mon, 5 Apr
 2021 16:04:00 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72%7]) with mapi id 15.20.3999.032; Mon, 5 Apr 2021
 16:04:00 +0000
Subject: Re: [PATCH 03/40] scsi: iscsi: remove unneeded task state check
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, varun@chelsio.com,
        subbu.seetharaman@broadcom.com, ketan.mukadam@broadcom.com,
        jitendra.bhivare@broadcom.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
References: <20210403232333.212927-1-michael.christie@oracle.com>
 <20210403232333.212927-4-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <e7c1867e-9994-682b-4840-6488e4074b56@suse.com>
Date:   Mon, 5 Apr 2021 09:03:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210403232333.212927-4-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: FRYP281CA0010.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::20)
 To AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by FRYP281CA0010.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.11 via Frontend Transport; Mon, 5 Apr 2021 16:03:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce8633a5-1a3e-4ca4-27d5-08d8f84c6d10
X-MS-TrafficTypeDiagnostic: AS8PR04MB7781:
X-Microsoft-Antispam-PRVS: <AS8PR04MB7781EB807AC08A4AF1836FB6DA779@AS8PR04MB7781.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SNW4zfUw5Ep8J8/CXG3175kSoZrZrdZeB1ukEyUrgHRE0cvz256bmF9iC5tW0+6Qgqb0WMIQFnAFjPLI0hlADXcTf9XSaHP1XtrEBB3T6L49Pel9IkFaSXYYPGZsI+glWx84LQkp2vDLTd86Q6wlLCFPmv0Z8PSTZEugo4+/IU7C7QDABaUjuCuTRFXt16p2bG17Mat4TGhK7qhcML3xKCfVgKU4dRLZBUHEY38aXIsM5GRUnXYBBUrTtd1LKVTOgB64TAQ8AZQ3FdyGfhm0nbv8W9QWOIEtQDDzF0kRtNTt8GzAQ13jbO19uHg1Sy4b//yfh8HqtQeVfOk3S/3JBnWU8GFBaVMMHsNBJKXx9yspM9wykwcp6ApMKsJfMS4JwdYy0YFUaJper/H301sG4y1f/aRt3cBUnrXjJLLUjFAg10iKdraOLOpBMw/cCBzKXGnffd1kwLKHzRJ2twD/7iLaJD+3/Yd51G+bdVzcnt7veNqg4enWTHAPQkHdIcLLPrUF+RqygiU4VmGvSC15/9vVynStugnvlM93mlVFiVT3ZT2zCoXJS4I3aO4BQ2FAqsO1Pu28XXkbBsc1czAvurbUhYvVVR0r1gftDwIzKg+mc+LP0cwD7ZRSXOX9U4HrUfo7VyHGtS8dD/nl/lUl5orbYycZa9jglsVnGhBgL05QnT6kp2PwCaQ3yb51xxaA5dARc8kkD7Dl8JbvURistxYf13JYuWcCVF4mrJvBXtQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(346002)(39860400002)(396003)(36756003)(8676002)(5660300002)(66946007)(66556008)(66476007)(83380400001)(16526019)(16576012)(956004)(31686004)(7416002)(2906002)(6666004)(53546011)(31696002)(26005)(52116002)(921005)(478600001)(6486002)(38100700001)(8936002)(186003)(316002)(2616005)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VnlzbW1XNW5hY3c4N1dDT3FoangybU9OMVhMS1JyYWxTWUEvLzRXVUw3RnNw?=
 =?utf-8?B?SS9vUmhMOVh2ZHhmLys3MVE1K29iZWpYV1NGbU5CUjNTNldaaGJQR0lMMFVi?=
 =?utf-8?B?emVjenhDOUZvRmVaMXc4Q1ZGdWJrWVNZaWF0WVlacWo4YzZ6SjYrTjlNL1hM?=
 =?utf-8?B?MVRnVmRxRzA3T3AxSjF1RURmaU1la210b3Uya0FZSVpKdWFKcmc4YUViWG9p?=
 =?utf-8?B?dzdyL0x5TlhqUzUzZUcwNnBpWVNYckRBZURoS2YzNlhGVGFYaTlPK1NUUlZQ?=
 =?utf-8?B?dWZ6U3FSL2FjNnpST2dRUDRRQnpBRWJoMStseklFdzFEZzB6WHk1UTgwRXF3?=
 =?utf-8?B?T0FlbWZxRVB1QXdXS0k4RDV6aWRvV29nU2QycDdyVlBGcEIxbCt1QmRLZ0VP?=
 =?utf-8?B?ZUFpV21ob2NDUkJMWVZWcDlidHNYazBWQVdkZUNiSzZFY1I4bW5EbDcyTG1O?=
 =?utf-8?B?T09RanFBTjUyYlRvK3YxdGNXcU5MTm1uQ0xhMEc2K0taYlJ5YlNmbVJjZ01Y?=
 =?utf-8?B?SXFBZGhLamZHcXJLRUhYZ2V1VHFMWnV6U3JLSG5QUDFuZUhOaUkyR00vWk1C?=
 =?utf-8?B?RmdJU0xiOHNmLzVmZEwweml4SUpRdlN6Ujd6SHRQZU5qdEtNNFpOUm9CZmlJ?=
 =?utf-8?B?OFM1NS9CWE5XYVdKWit5bFViVzc2VHFXcE4rZmpLRkxydEI4NE14STVjN09i?=
 =?utf-8?B?OTI0RG5OSlNkRWJLbE9CL3pLTEo1QUxPRDJwSThhZmdKMk1YamFodmcyY1dx?=
 =?utf-8?B?bzZrZktsNHZ0YUFWdmxzVkQ4K0htSDA0anBpNWJhOFdJVFhFYjJPZ1NQMG1i?=
 =?utf-8?B?K2R5bWppYTA5TkxiVVBrUkQ5RHFhR0JVMUtaZWdCcm9jM1RvQmFpWituc244?=
 =?utf-8?B?Vm5DRHhGNURVeDJLVHRuRWFxLzNHcEQ3cFhqUjIvWTRjankyK1piWmt6RW1o?=
 =?utf-8?B?ekFGd0NlVkZWN1lUZTY2TVVhbEpCVjRvMEdpSTQvSFVSR08xR2Q1b0ZvbHhx?=
 =?utf-8?B?bzI4THRtVE04VE1yaGFXRkZjRnRZbkVMTU1YUXlmd2FJNmFNWm11Z0EwdENG?=
 =?utf-8?B?b2VKZnVVSHBwajB6c2xyR2dGZldBajNnUnpDRVQrdUpZelFNNzFoOWptSlVZ?=
 =?utf-8?B?dnR0WnpQZ3U5bUdjc2JUc1B3Wm5NMzdSUDR4VTZVbS9jb3FRcVRIeUxueTFY?=
 =?utf-8?B?eEovUHlNb0QvSkgwMnJ0eURjZjc4NVVsMmR0dVhKcGNDVDNOdWxsL0VkUi95?=
 =?utf-8?B?RWVBTkkzMUlEMUszYWNwNTVxNEZXQXhJd29FTHI5a0xUZXFhVFB1VWtaNkw2?=
 =?utf-8?B?bnNXb3RqMU1PaE5CSXkvMldMSWdFc1F1cFpGMjIxNmdFV3hrd1djUHNneTJ2?=
 =?utf-8?B?OVlRS2tWcnBMRWpwSkJIczhnODZRT0pqNUlFVDlxRjJoNUJTRnRKczQwSEEz?=
 =?utf-8?B?cG95TmhIZzBGT0h5eDJqaXhTamkxNmc0b2J0emduRmR4RmduenFLajBKSDY4?=
 =?utf-8?B?dGZMVWJya3BWblJZZHRlWEFFNnJta3ZFaFF5aFdrWFlvS04xUXdKSVNqRjhH?=
 =?utf-8?B?VFVVdS9RWmFiakJmZFdaN0Nsd1dWMkdRczFGUFhNeTZJY0xXRVZyNnQreDMw?=
 =?utf-8?B?b0FzbFZIVEFmQnBad2hLQjZSbzR0aFpTaGFsZ1lNNTdQWmlQTjNtTUFaN3BI?=
 =?utf-8?B?M292cjZlSmtyUlVQbndlUDhLd1U1NWRIYmtYOHRIUlIyODhsdmRPaGdkck9y?=
 =?utf-8?Q?yvzvz/ENkDhIyqeO6ONXOgYtf4tw3s0rP+NqnQw?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce8633a5-1a3e-4ca4-27d5-08d8f84c6d10
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2021 16:04:00.7211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jQ7Y0IOzohwE3//fDWOF5RvP2Dp3ByAG6Zh//N0kZ/CTcleLPgsFHmeRiYvXXbc5aTxTxMHdq2W+wlUbGsgepw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7781
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/3/21 4:22 PM, Mike Christie wrote:
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
> sending the cmd. It turns out the bug was just a race in libiscsi/
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
> Since it was just a race on our side, this patch removes the extra check.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/libiscsi.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 643edc4eb6fe..94cb9410230a 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -562,16 +562,19 @@ static bool cleanup_queued_task(struct iscsi_task *task)
>  	struct iscsi_conn *conn = task->conn;
>  	bool early_complete = false;
>  
> -	/* Bad target might have completed task while it was still running */
> +	/*
> +	 * We might have raced where we handled a R2T early and got a response
> +	 * but have not yet taken the task off the requeue list, then a TMF or
> +	 * recovery happened and so we can still see it here.
> +	 */
>  	if (task->state == ISCSI_TASK_COMPLETED)
>  		early_complete = true;
>  
>  	if (!list_empty(&task->running)) {
>  		list_del_init(&task->running);
>  		/*
> -		 * If it's on a list but still running, this could be from
> -		 * a bad target sending a rsp early, cleanup from a TMF, or
> -		 * session recovery.
> +		 * If it's on a list but still running this could be cleanup
> +		 * from a TMF or session recovery.
>  		 */
>  		if (task->state == ISCSI_TASK_RUNNING ||
>  		    task->state == ISCSI_TASK_COMPLETED)
> @@ -1470,7 +1473,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
>  	}
>  	/* regular RX path uses back_lock */
>  	spin_lock(&conn->session->back_lock);
> -	if (rc && task->state == ISCSI_TASK_RUNNING) {
> +	if (rc) {
>  		/*
>  		 * get an extra ref that is released next time we access it
>  		 * as conn->task above.
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

