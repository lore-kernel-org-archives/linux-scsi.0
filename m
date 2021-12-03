Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24E1AC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Dec 2021 18:48:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343835AbhLCSvi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Dec 2021 13:51:38 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:33616 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233187AbhLCSve (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2021 13:51:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1638557287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tQIeGwkBSOnnN/e5MZi4TullPL0lLBkyVAKnNGK+M54=;
        b=guyF2pRdwYeMD0e8OiuzSaTxfHlPdygrrxOOiZCN0oliXOCukGV2oGO78WqUzHx9+jn65s
        z1Qr9aEwjIJxd1dt2euMUXvV4jYeSdKPdrVcE3xxzesYFxmBjHLevK2sapxUygMoFKL5j/
        dtMig2XQ8U+TEQbHrFEJUv++Li9TwOM=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2175.outbound.protection.outlook.com [104.47.17.175]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-16-NuNZDymdO0-CcUm_aDJbOw-1; Fri, 03 Dec 2021 19:48:06 +0100
X-MC-Unique: NuNZDymdO0-CcUm_aDJbOw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N3HaTHw6Tkt7wUsKNBfy/0upYXbiMHCZP7enMq6+p+n8XjDf6CzJBcD5miVBmmDf2FB6llzIkvXo0EVpKZZCqJeW5D3mk9T9kbj6ESwAjLwr9HqjyInHtte1E6iYZxClE/izsSkp8aXWkpa0HK32YQycSeOTaZgG+1fc7CqmTbcETLwJ3dwm7QxQRQC0WzLVOCRd1enSJFmBfMDgnojduX//X7FcWO9Q3K6Vk9uWR4Oytib7Z8/mt5TIX/dxxp+tT/TKewXledPsNSpVMz7NVe7qXuiyGWGfsPLVIv56R3R0f3GpeNhlaZtsV2SzmnZwrIZlrxAX4vOwq9w9mkwZzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tQIeGwkBSOnnN/e5MZi4TullPL0lLBkyVAKnNGK+M54=;
 b=k2GVq+RtZRKfJjccrDK+jGuPCL+xGpjULTziczioxgcoleaD4Co+XfaIQLGHBu8qq5KBc0V/TmxVRcb4q0ppj8TYUx1cy1zHWE5G4agxMhGQ0NRdshpnbVMnSRJToCS85M3pnHNmMEI6XOdqoO+vQ4ZrOJZ6e40xJ5WjyIzB1TeZsrRntglUFrSRnMJGoPBYX5QAd1B1rlsyelVg3uuNG50K7e1gY9YygLRPDl+JM2RLSqjXGA0xeG5j8HC7KG8TSXXnUFIChNABQQAvDK3JcCm/x8K4GvqmDOFprnCFT2XK99zRiswwuAez6zqxCU2xXbS04cLDYR0/I1xaHo8R8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM5PR04MB3267.eurprd04.prod.outlook.com (2603:10a6:206:d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Fri, 3 Dec
 2021 18:48:04 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::a555:3b27:dc03:8fcb]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::a555:3b27:dc03:8fcb%6]) with mapi id 15.20.4734.028; Fri, 3 Dec 2021
 18:48:04 +0000
Subject: Re: [PATCH v2 REPOST] qedi: Fix cmd_cleanup_cmpl counter mismatch
 issue.
To:     Manish Rangankar <mrangankar@marvell.com>,
        martin.petersen@oracle.com, cleech@redhat.com,
        michael.christie@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20211203095218.5477-1-mrangankar@marvell.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <87db07ec-63b8-ee96-14bd-1cc170228c1a@suse.com>
Date:   Fri, 3 Dec 2021 10:47:59 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20211203095218.5477-1-mrangankar@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8PR04CA0039.eurprd04.prod.outlook.com
 (2603:10a6:20b:312::14) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
Received: from [192.168.20.3] (73.25.22.216) by AS8PR04CA0039.eurprd04.prod.outlook.com (2603:10a6:20b:312::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Fri, 3 Dec 2021 18:48:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 592233a1-8afb-4982-e97b-08d9b68d7057
X-MS-TrafficTypeDiagnostic: AM5PR04MB3267:
X-Microsoft-Antispam-PRVS: <AM5PR04MB32676CB01C6285B694728C73DA6A9@AM5PR04MB3267.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e/0VFiRD7Ocpx4+fWLmFsb5NSgYktCRLvsMwh7kU+gX/xO+jJQNiBWteC+5OqizqAo3kh6JRjfU3is23s35s40xkUGdVK9cjz65z/DVmQDRLv8uMvKF9dnAta4H+lZ6NZIA1wc3ztj0uoYl2jwzj5NDXAJQwmT1GXuusW6I2ttMA9/872omLEtWV4mX+t0+tSZNDzOHRflx4GdUC8Ex9lQ2XfQ0EiKijXqgCrkdMhDEDuSrWzhaje0GofnB42DreJF1KKzQGIWTMrxhdgO0zAQUnB9n7E2fOcghnzXkPF9aB2MTOr1bsQ9EVRPtATJEd3rdjs54vvx3FZ3gnhom4jPMXp6UGlHM6VWYUPcTZEFHCi4d/iKn4w8NyR5cDfZSVt9bbZKY/86041TaGDjhICNxcvqwhoYf6k6xvJodlIjxQIVv0Ckxff7uE3kGLRNk0dEAqkeG1543PLyxZgWJ4WBLOQ9hDB4Z/dG0iW5K/hxwJm82tLaaj0YSpdxAsmF5HJEigCyJ/LumcDceOcQNQMzGINxJBbNEGyu84PbVoF5pVrvh2nlJlrXzqqck0r7veM/kyCkcojVrki3UEeMh4fEjctkvlzy1YX6L62yjnG4sLQQWRVt4363RcUg3ZwduBuxz5/4zcGUyCJTfav1ZqUuitjaQbIPEH1xeZbKx4uZWp304w26E891k4VzOUfKDaiq0QYyAEfMJxPkV5wxeePAsat8twgssy2kylZGwBlf8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(4326008)(83380400001)(66476007)(5660300002)(956004)(53546011)(2906002)(6666004)(66946007)(66556008)(31696002)(26005)(16576012)(8676002)(36756003)(316002)(38100700002)(508600001)(186003)(6486002)(31686004)(86362001)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RGNpTUFtSnkyYVIvWUF6bVdheTZraWc2WjVnQTFXcGpYYmtOdFdTMGJHR0RR?=
 =?utf-8?B?ME1ERnVEUVFnYmFjMG9VYThxYStJVDhaVjcvVS9sTXUxOStvQkVwN0VicExo?=
 =?utf-8?B?end6MzFwZ1NDNG5qUVZKSWQvNlM4SHpTUWZJZWM2QkZFcGdhQTBEb09IOHF6?=
 =?utf-8?B?UWIwZ3o0cDVtVGZETzVYWXdaT1Q4bUZpVHA4THFwZzQ1aU8zVzlrRkFMaEsv?=
 =?utf-8?B?ZVArVk9WRkFTRGp4MEJsUDg1akJtQ3pOd1RScm5xTE9xWFpRRW43Y254QnZS?=
 =?utf-8?B?bDNyOGVEelpBN2w0VTZqWmhUY0wzRUV0OVVrV29nMGw4NEhhVnRBT0RxT0lV?=
 =?utf-8?B?VzI1c0tvYVdQTURiME40R3VqWEtPby92a3VCaGVFVXlyeUNHMjVzNDRUaHNZ?=
 =?utf-8?B?QklsR3JyTW1iZnlhanhqR2xtaDFsZHdTak9WODFXL3JneFc4QkFaelNUNlFF?=
 =?utf-8?B?cXlBK1ZiT2FXSVU1S21ZSktaRDRHSnduZWh0R2hZOGovYVRGT0ZuVDJTbnQz?=
 =?utf-8?B?NUEra0RrbVlQalhqNExOQWRzSU9KZVprNEZRUDlETlc1VnU4OGdqVjVvQUdw?=
 =?utf-8?B?QkFrK1lETytPY2xiK2JrNUZxRk5sUjhZWEhMSkJGU210L0daNEN3TWo3ZEFr?=
 =?utf-8?B?M21ZOUVRR0s0SERmR0JNbDBxbEwwbVpyUUxJRVdIdUI2VDZzd3k1SVBydDZY?=
 =?utf-8?B?RjVWN2l5dDQrVmpraGo5U1BNY0tFTUQvZzRxbWZOOHJGWW9iK08vQjJzVUsy?=
 =?utf-8?B?alVLUW5McjFJQ256cDZTR0VMYjFrOE84ZFZqaXQ0OHExcEpCNGo0TmIrMVpv?=
 =?utf-8?B?UXBCNXpmRjVRdm9EUzg0QXZLMlRDdFlUT2FlRTBBa2RHRUwvSzQ3SUtqeGhD?=
 =?utf-8?B?WVh3V0M2eE1TVDNtdTN3bEZxRTQxTnUwQlZ6YThYQXZ2YjNoMjRiVVZBWlF4?=
 =?utf-8?B?RzBGYzFCTWFTL3BtT21aRlVZQTdubmZERjRDbElIWGNrdE4rd3ZmUXF6WkRI?=
 =?utf-8?B?U200bnBtcWg0WFpZRnpVbkFDUmt6TkRZYkhGeFpNNVRjZ1RDMW1XWEwzVUVC?=
 =?utf-8?B?dXMwYS9YUXEvakJnMk9QQkpvcEtzNTZ0eHBrdDEwaVJTakhZYkZDYnlIaVdw?=
 =?utf-8?B?eHBZRWt1TzZUaVhyVHBRMVBaaXB4NjZ4R3A2QVZqenhVTWQ2cS9MMkpJVnRr?=
 =?utf-8?B?VitvVm1mTkE3S2xnQWxLMWFpUGVVVFVUWDFaWUtUUFNGRVVWQjVpaWdPNzZ0?=
 =?utf-8?B?VDRER1duYWNvM1hkajNNaFFmQkppdG54RlVnWEIweHgzb0VzYjZKOVBpSXo3?=
 =?utf-8?B?c3BqVWZsL2g4cTVKKy9iZjR3SmlSTnVQbTdtL2lienY5OWxDMmRhRWNCZXM1?=
 =?utf-8?B?UGNpN085c2QzeWFQRjZRZzlEMjhhYWNiWEZ3MUM2eGh4OHkyTWM5ZDdYaCs5?=
 =?utf-8?B?TUZ0dzhWREt4RkdGbW1hdU9QNTd6U1VROTRjRDFMbUJFeExOOU1IaXMvVjBE?=
 =?utf-8?B?REprRGNOMWFFQ3lRK1crSFM4aGJyL3J4NkZFR2FEYmVSTlRtQVJBVWFHTXB5?=
 =?utf-8?B?cEMxZ2NMeCtnVTJSS0VaUlkzY0hBQWNKN2h5dWhFT3U2SlJhU0ZOZjhFZXdK?=
 =?utf-8?B?WkxhYVFGKzlwcjgwdEtPejFIeEtxZHFXL2NYcGhmNExRV3M1ZlcvRU1WRm1S?=
 =?utf-8?B?Q0dxaVY2Tjc1czE2SjVqSlBaQi9ORy9DY05ZeEcweXR5MW5uMmdMTDJzRU0v?=
 =?utf-8?B?UUdDSFJXVXpMdFVTOGttLzYwOFJJZURCb0NoVDRVQlhHKzMydFdpYXpReldM?=
 =?utf-8?B?NElOZHNiZFBGS1cwcVpYT1IySjA5SnpIb1VQNUQwRUdJeEVOY3d2QlZQUlBq?=
 =?utf-8?B?SEpGSUkwSEFnSzYyVEZ4Qk00QzgxZzYxNitKaTAyMlllWmM0N0JxM0hVd3g3?=
 =?utf-8?B?eUZSa04xWmtocDhtYzZXY3NQdi96dTlPSHFUSEdaNGFZNnRTbHJlMnZrckNx?=
 =?utf-8?B?ZlJSZzU4VjBnVk9IN1BiWXFYSW1CYnB1UmlKcUtFUFB4UU1aaGRTb2hnV2RG?=
 =?utf-8?B?UWtoZ0lVMi8zaTRPNFVuWDBjYW0rR2Z5OHpLWENoZ3cxWjRLU0grbXdLaHFu?=
 =?utf-8?B?bjlNaURjT0J0U25hMUtSd1QwWXorNFkvL3ZqaW5EMzVINWlOMllycXQwM2Fm?=
 =?utf-8?Q?Lpw+HlE1Uwi95f7/5Dzi8no=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 592233a1-8afb-4982-e97b-08d9b68d7057
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 18:48:04.2878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QYOlzM3MkKohfgJ96bIqWoXik4bDH7P1rLvNXF7wltoxX2WV+q6Q1Fdm4ZLKInUpGIitcmR9Or74AI3yjafhaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR04MB3267
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/3/21 1:52 AM, Manish Rangankar wrote:
> When issued LUN reset under heavy i/o, we hit the qedi WARN_ON
> because of a mismatch in firmware i/o cmd cleanup request count
> and i/o cmd cleanup response count received. The mismatch is
> because of the race caused by the postfix increment of
> cmd_cleanup_cmpl.
> 
> [qedi_clearsq:1295]:18: fatal error, need hard reset, cid=0x0
> WARNING: CPU: 48 PID: 110963 at drivers/scsi/qedi/qedi_fw.c:1296 qedi_clearsq+0xa5/0xd0 [qedi]
> CPU: 48 PID: 110963 Comm: kworker/u130:0 Kdump: loaded Tainted: G        W
> Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 04/15/2020
> Workqueue: iscsi_conn_cleanup iscsi_cleanup_conn_work_fn [scsi_transport_iscsi]
> RIP: 0010:qedi_clearsq+0xa5/0xd0 [qedi]
>  RSP: 0018:ffffac2162c7fd98 EFLAGS: 00010246
>  RAX: 0000000000000000 RBX: ffff975213c40ab8 RCX: 0000000000000000
>  RDX: 0000000000000000 RSI: ffff9761bf816858 RDI: ffff9761bf816858
>  RBP: ffff975247018628 R08: 000000000000522c R09: 000000000000005b
>  R10: 0000000000000000 R11: ffffac2162c7fbd8 R12: ffff97522e1b2be8
>  R13: 0000000000000000 R14: ffff97522e1b2800 R15: 0000000000000001
>  FS:  0000000000000000(0000) GS:ffff9761bf800000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 00007f1a34e3e1a0 CR3: 0000000108bb2000 CR4: 0000000000350ee0
>  Call Trace:
>   qedi_ep_disconnect+0x533/0x550 [qedi]
>   ? iscsi_dbg_trace+0x63/0x80 [scsi_transport_iscsi]
>   ? _cond_resched+0x15/0x30
>   ? iscsi_suspend_queue+0x19/0x40 [libiscsi]
>   iscsi_ep_disconnect+0xb0/0x130 [scsi_transport_iscsi]
>   iscsi_cleanup_conn_work_fn+0x82/0x130 [scsi_transport_iscsi]
>   process_one_work+0x1a7/0x360
>   ? create_worker+0x1a0/0x1a0
>   worker_thread+0x30/0x390
>   ? create_worker+0x1a0/0x1a0
>   kthread+0x116/0x130
>   ? kthread_flush_work_fn+0x10/0x10
>   ret_from_fork+0x22/0x40
>  ---[ end trace 5f1441f59082235c ]---
> 
> Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
> ---
> v1 -> v2:
>  - Changing cmd_cleanup_cmpl variable to atomic
>  - In completion path instead pre-increment use atomic inc.
> 
> 
>  drivers/scsi/qedi/qedi_fw.c    | 37 ++++++++++++++--------------------
>  drivers/scsi/qedi/qedi_iscsi.c |  2 +-
>  drivers/scsi/qedi/qedi_iscsi.h |  2 +-
>  3 files changed, 17 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
> index 84a4204a2cb4..5916ed7662d5 100644
> --- a/drivers/scsi/qedi/qedi_fw.c
> +++ b/drivers/scsi/qedi/qedi_fw.c
> @@ -732,7 +732,6 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
>  {
>  	struct qedi_work_map *work, *work_tmp;
>  	u32 proto_itt = cqe->itid;
> -	itt_t protoitt = 0;
>  	int found = 0;
>  	struct qedi_cmd *qedi_cmd = NULL;
>  	u32 iscsi_cid;
> @@ -812,16 +811,12 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
>  	return;
>  
>  check_cleanup_reqs:
> -	if (qedi_conn->cmd_cleanup_req > 0) {
> -		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_TID,
> +	if (atomic_inc_return(&qedi_conn->cmd_cleanup_cmpl) ==
> +	    qedi_conn->cmd_cleanup_req) {
> +		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
>  			  "Freeing tid=0x%x for cid=0x%x\n",
>  			  cqe->itid, qedi_conn->iscsi_conn_id);
> -		qedi_conn->cmd_cleanup_cmpl++;
>  		wake_up(&qedi_conn->wait_queue);
> -	} else {
> -		QEDI_ERR(&qedi->dbg_ctx,
> -			 "Delayed or untracked cleanup response, itt=0x%x, tid=0x%x, cid=0x%x\n",
> -			 protoitt, cqe->itid, qedi_conn->iscsi_conn_id);
>  	}
>  }
>  
> @@ -1163,7 +1158,7 @@ int qedi_cleanup_all_io(struct qedi_ctx *qedi, struct qedi_conn *qedi_conn,
>  	}
>  
>  	qedi_conn->cmd_cleanup_req = 0;
> -	qedi_conn->cmd_cleanup_cmpl = 0;
> +	atomic_set(&qedi_conn->cmd_cleanup_cmpl, 0);
>  
>  	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
>  		  "active_cmd_count=%d, cid=0x%x, in_recovery=%d, lun_reset=%d\n",
> @@ -1215,16 +1210,15 @@ int qedi_cleanup_all_io(struct qedi_ctx *qedi, struct qedi_conn *qedi_conn,
>  		  qedi_conn->iscsi_conn_id);
>  
>  	rval  = wait_event_interruptible_timeout(qedi_conn->wait_queue,
> -						 ((qedi_conn->cmd_cleanup_req ==
> -						 qedi_conn->cmd_cleanup_cmpl) ||
> -						 test_bit(QEDI_IN_RECOVERY,
> -							  &qedi->flags)),
> -						 5 * HZ);
> +				(qedi_conn->cmd_cleanup_req ==
> +				 atomic_read(&qedi_conn->cmd_cleanup_cmpl)) ||
> +				test_bit(QEDI_IN_RECOVERY, &qedi->flags),
> +				5 * HZ);
>  	if (rval) {
>  		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
>  			  "i/o cmd_cleanup_req=%d, equal to cmd_cleanup_cmpl=%d, cid=0x%x\n",
>  			  qedi_conn->cmd_cleanup_req,
> -			  qedi_conn->cmd_cleanup_cmpl,
> +			  atomic_read(&qedi_conn->cmd_cleanup_cmpl),
>  			  qedi_conn->iscsi_conn_id);
>  
>  		return 0;
> @@ -1233,7 +1227,7 @@ int qedi_cleanup_all_io(struct qedi_ctx *qedi, struct qedi_conn *qedi_conn,
>  	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
>  		  "i/o cmd_cleanup_req=%d, not equal to cmd_cleanup_cmpl=%d, cid=0x%x\n",
>  		  qedi_conn->cmd_cleanup_req,
> -		  qedi_conn->cmd_cleanup_cmpl,
> +		  atomic_read(&qedi_conn->cmd_cleanup_cmpl),
>  		  qedi_conn->iscsi_conn_id);
>  
>  	iscsi_host_for_each_session(qedi->shost,
> @@ -1242,11 +1236,10 @@ int qedi_cleanup_all_io(struct qedi_ctx *qedi, struct qedi_conn *qedi_conn,
>  
>  	/* Enable IOs for all other sessions except current.*/
>  	if (!wait_event_interruptible_timeout(qedi_conn->wait_queue,
> -					      (qedi_conn->cmd_cleanup_req ==
> -					       qedi_conn->cmd_cleanup_cmpl) ||
> -					       test_bit(QEDI_IN_RECOVERY,
> -							&qedi->flags),
> -					      5 * HZ)) {
> +				(qedi_conn->cmd_cleanup_req ==
> +				 atomic_read(&qedi_conn->cmd_cleanup_cmpl)) ||
> +				test_bit(QEDI_IN_RECOVERY, &qedi->flags),
> +				5 * HZ)) {
>  		iscsi_host_for_each_session(qedi->shost,
>  					    qedi_mark_device_available);
>  		return -1;
> @@ -1266,7 +1259,7 @@ void qedi_clearsq(struct qedi_ctx *qedi, struct qedi_conn *qedi_conn,
>  
>  	qedi_ep = qedi_conn->ep;
>  	qedi_conn->cmd_cleanup_req = 0;
> -	qedi_conn->cmd_cleanup_cmpl = 0;
> +	atomic_set(&qedi_conn->cmd_cleanup_cmpl, 0);
>  
>  	if (!qedi_ep) {
>  		QEDI_WARN(&qedi->dbg_ctx,
> diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
> index 88aa7d8b11c9..282ecb4e39bb 100644
> --- a/drivers/scsi/qedi/qedi_iscsi.c
> +++ b/drivers/scsi/qedi/qedi_iscsi.c
> @@ -412,7 +412,7 @@ static int qedi_conn_bind(struct iscsi_cls_session *cls_session,
>  	qedi_conn->iscsi_conn_id = qedi_ep->iscsi_cid;
>  	qedi_conn->fw_cid = qedi_ep->fw_cid;
>  	qedi_conn->cmd_cleanup_req = 0;
> -	qedi_conn->cmd_cleanup_cmpl = 0;
> +	atomic_set(&qedi_conn->cmd_cleanup_cmpl, 0);
>  
>  	if (qedi_bind_conn_to_iscsi_cid(qedi, qedi_conn)) {
>  		rc = -EINVAL;
> diff --git a/drivers/scsi/qedi/qedi_iscsi.h b/drivers/scsi/qedi/qedi_iscsi.h
> index a282860da0aa..9b9f2e44fdde 100644
> --- a/drivers/scsi/qedi/qedi_iscsi.h
> +++ b/drivers/scsi/qedi/qedi_iscsi.h
> @@ -155,7 +155,7 @@ struct qedi_conn {
>  	spinlock_t list_lock;		/* internal conn lock */
>  	u32 active_cmd_count;
>  	u32 cmd_cleanup_req;
> -	u32 cmd_cleanup_cmpl;
> +	atomic_t cmd_cleanup_cmpl;
>  
>  	u32 iscsi_conn_id;
>  	int itt;
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

