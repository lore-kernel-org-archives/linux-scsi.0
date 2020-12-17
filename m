Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A66BC2BB9A
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 17:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BC95238EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 17:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgLQR7X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Dec 2020 12:59:23 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:53642 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726291AbgLQR7W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Dec 2020 12:59:22 -0500
X-Greylist: delayed 498 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Dec 2020 12:59:18 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1608227892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fA9XjSPn9i8WqxqPb5Pc732ulXHkeUbvY4Eun+ljHnM=;
        b=B00i1TyviAh6BNXpAoGNH77Q0dznd1KKjSbjD38RN8EDrKAROZ6k/xZ6U4lLWdG9Crr4UH
        8KHkee14hVxUR5ptcwy7iu97EYTv6J0eyNrNv0k+xgIxsErTHNdWsEkRHqRlO/yE/6Ysu1
        nF4GWYuYPLR5n5D1zPs8wg21eQUUnJA=
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02lp2055.outbound.protection.outlook.com [104.47.6.55]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-31-uox59tEqMvO5yvw8COJnkg-1; Thu, 17 Dec 2020 18:49:53 +0100
X-MC-Unique: uox59tEqMvO5yvw8COJnkg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nyV0+V0QGiYDFZSa3hxxHooJU6/EYz49OxfJL06d8Lz2DQG202OyO1XNtmDC6p8mUfZY8UsLQq6Q+/ZyKe78k/ptcCpn26fMdmYE1QzBUW7bkB5G6a5aP0rSAFo8t9iCSMfobWatWa8uEAlPkf/NM/q793hScQD9ewcHtQEMQp3i7Uh/goJL0t/UPpkD2B++/puEts+D5O44rnjZ78kMovAQviklQtzsKLwqik+Ve+R7hnop5TXN1CQ0LrUFLOGEEK422aQhzKY1JbO+MidXXmA1GQykJhBJWEVZBatPjNyNyP/X210gxTC7WWnk87ho7a6zoRqxsiZxXRQIVEqm7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fA9XjSPn9i8WqxqPb5Pc732ulXHkeUbvY4Eun+ljHnM=;
 b=Z53F5tWwJFJNLa5ERxT8TFc3EmhNJbKoYpNOk8kw0nrX89pDNr6JTm869qnztn7CJz85aNtvxyDzD1lUf5Rd0HyOtROoLknALpA9HYqnsuP406C+7f3teZJTANXu7zjIEOOGzKYa3+9uej41NV1/GSnWQlpfYH939muWZZeMkzwIeBlCiyxZzhNwJQ4FeEQfzIZ+PVYnPIE2DxMfBE91r67+RmfMjfIEobmJdVXg2TuUur3KRuxSm7Yi92VQIK2GHNgGURX9ICI+01BQ6LXxfKoxiS5PbFBC3ezKQ2+vAeZSbBdfrgjW038C4Zpk03P1/10QXUnBMiyyUFpY87huOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM7PR04MB7047.eurprd04.prod.outlook.com (2603:10a6:20b:11b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.14; Thu, 17 Dec
 2020 17:49:51 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d0f5:2f85:a7f2:2952]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d0f5:2f85:a7f2:2952%7]) with mapi id 15.20.3654.024; Thu, 17 Dec 2020
 17:49:51 +0000
Subject: Re: [PATCH 3/3] libiscsi: fix iscsi_task use after free
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com
References: <1608144943-4748-1-git-send-email-michael.christie@oracle.com>
 <1608144943-4748-4-git-send-email-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <c3929872-6992-28fb-139f-59aefaeb2816@suse.com>
Date:   Thu, 17 Dec 2020 09:49:44 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
In-Reply-To: <1608144943-4748-4-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM0PR03CA0052.eurprd03.prod.outlook.com (2603:10a6:208::29)
 To AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM0PR03CA0052.eurprd03.prod.outlook.com (2603:10a6:208::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 17 Dec 2020 17:49:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5568e2f6-926c-4076-f349-08d8a2b42783
X-MS-TrafficTypeDiagnostic: AM7PR04MB7047:
X-Microsoft-Antispam-PRVS: <AM7PR04MB704761A81987730E5C632E7FDAC40@AM7PR04MB7047.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:260;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dI8Xozi1Wn79WZU2NI+x1OytVEWz3uf5l489Bzor+xQHrMBEuaKhObWh5f1Zwra67LaF8li/eGgxiNLR9Kgq6joeya/zbZ9j0y6GERq2v830kR1cM5O0lWizGN1OfgO8Ry5vF/i/1yUoEpNpDD8q0i8rzQRaaLsBPd1WGOF3WlhsOt0BIxtJL0oeOkqjazBnIz8XycFy9Ic/uYZZc5ia2YE9CTJKiu2QQvA+BOat6ZXCiNwBCjXcGdFOrhmUdlKVKg+ZP+cMPqkvzDE7YY0M1qIkC4AYx0cMwcFr4Q2/GhOaVB8yetRXerPuP0KapUU9UEcbsBcnf2vSKWZfOqEzK0uBbCEuxgzsoNmplB5sSUMNE1dOBX/Zst2q/4L+Efqf5bJdDHSl1Y94AJRuU/rk0M+7SGFOGcfcA+75N4xJpqU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(376002)(346002)(136003)(316002)(16576012)(26005)(16526019)(52116002)(6486002)(8936002)(53546011)(66556008)(86362001)(2616005)(186003)(36756003)(66476007)(66946007)(83380400001)(31696002)(5660300002)(31686004)(478600001)(2906002)(6666004)(4326008)(8676002)(30864003)(956004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?N0xqWWppSWdNdHJDbDgvOTVCYXVOOWVVNzhtQUhjVmJJanFJdFYvdUVEd3kw?=
 =?utf-8?B?SXdTSUJzL2ZHeEpBS290OFZuWDNmYnZ2OVg5UVNvcUFPL3ArMGdxTzV3RWhJ?=
 =?utf-8?B?Z1dVTU5FWWtmVHpORGtaeWlhTUhnVDcxQVd2Y3MvQjgzSE1Ka042VU52NHFq?=
 =?utf-8?B?aGpoK2hPVjRrMHA1ZUwxem5YbFR2L3FENjQwNUtLMUV4aUNnV2cvUWN0YmMw?=
 =?utf-8?B?K2lsS2ppK2NtbUw0eTUxZ0xSZ0ErQzNJYWxSWEVkM2REenNqNklZbUdUeDhj?=
 =?utf-8?B?SStGYnFyTWZ3Ri9VVnJSMDFIckNVcEFrRGNnVjB3OWdRK29vd1Z3aXU5bzJN?=
 =?utf-8?B?WjJNc1VxWGJJVEV1OFZITjJlMkl1bG9OTE5pSmxyVUFtY2REQlZUa25ua3p4?=
 =?utf-8?B?ZWU5a25icG10RkFreTNYR2Zya1JWWFJ4TCs1dnAvRFNhaGp0WGRpb28vSjRw?=
 =?utf-8?B?UWVyQmZ4bnh0dTV6NDlpbit0d1NpY1RzdGplY1RsME9oZkhoak1lMXREQk9V?=
 =?utf-8?B?TTRXejhYY3BlV1M1T0w1WGF0bFRCTUdpSjNFNDBjMk1BejBWenpWUllraTgx?=
 =?utf-8?B?ajBybjlOelJySTVDR1dOTk55TEpQQW1LS3grUzljYXJiaXNVTHk5OUg1ZlhI?=
 =?utf-8?B?Z29rVHNqeC9pQ3pWbTdEYUJBWmNLUGttS045elpia1RVZDBJL0RRQlRRRW9C?=
 =?utf-8?B?MG9SbXNJMGs5RG1xdmg1N2tMbDRyZVRVQ3N1aDBhUlAxL1lpdFFudnRwZjVT?=
 =?utf-8?B?OUUyZytGWTRuVkNFTGo4dWFvT0RUZ1lUU3p1bUxrR0EvOFRSRS94eU4yWmdG?=
 =?utf-8?B?M1dvTkNaTFUvbGVPaGtDV3dWdTRTelRqK3dIWEg5bkFhTXRlVlNjOTVLaFRr?=
 =?utf-8?B?THEwemQ2bTVjK2VnY2tWc2oxYm5KNHh2L0lnNFgyYkFRWlFSZkhpS01xRWta?=
 =?utf-8?B?VVFYNWdRRWVNcXhaMDNpNUZGYlcvUnB1SmxMc3hzQkFUcHhTOGFZbktwdzBq?=
 =?utf-8?B?R0lIUkdUYW9MVUx3R0ljOHo0ZkRqd3Q4dXI5N3hQTmVkUUh3RVliVUlOTE9k?=
 =?utf-8?B?SkxXYUFERzByYjZzS2diNWFEZEdOLzQ1UkVUS3NxTUFFMVprMks5RUV2RVh1?=
 =?utf-8?B?bTl5Y3ZtQmFiV0orR2lxOFRqb0NjTmtGaDJwMlZLWG00eWczTmV0Rzh3MVcw?=
 =?utf-8?B?U1lGR2F5MkxvYllhQVNXOGhxS1lVWmxzR2t4ZWNiNVhSeUJ6a3lmNjRVUkMr?=
 =?utf-8?B?RFR0VjdoeDJpTnkrbFJUaVl2Z2U1bkM4Vmpaa0xUOERKM0RtVUlqa2Vadk9u?=
 =?utf-8?Q?vCzm/bi2J50UU=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2020 17:49:51.2737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-Network-Message-Id: 5568e2f6-926c-4076-f349-08d8a2b42783
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ACXhfgFFSnv3Npp2AQW+oH4shKXMoPAxlFbGmgZwDawrOXD9g7SzKuBo0NfKUpsZJ4LLJSBRB0DN+/AaidsEIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7047
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/16/20 10:55 AM, Mike Christie wrote:
> The following bug was reported and debugged by wubo40@huawei.com:
> 
> When testing kernel 4.18 version, NULL pointer dereference problem
> occurs
> in iscsi_eh_cmd_timed_out function.
> 
> I think this bug in the upstream is still exists.
> 
> The analysis reasons are as follows:
> 1)  For some reason, I/O command did not complete within
>     the timeout period. The block layer timer works,
>     call scsi_times_out() to handle I/O timeout logic.
>     At the same time the command just completes.
> 
> 2)  scsi_times_out() call iscsi_eh_cmd_timed_out()
>     to processing timeout logic.  although there is an NULL judgment
>         for the task, the task has not been released yet now.
> 
> 3)  iscsi_complete_task() call __iscsi_put_task(),
>     The task reference count reaches zero, the conditions for free task
>     is met, then iscsi_free_task () free the task,
>     and let sc->SCp.ptr = NULL. After iscsi_eh_cmd_timed_out passes
>     the task judgment check, there may be NULL dereference scenarios
>     later.
> 
>    CPU0                                                CPU3
> 
>     |- scsi_times_out()                                 |-
> iscsi_complete_task()
>     |                                                   |
>     |- iscsi_eh_cmd_timed_out()                         |-
> __iscsi_put_task()
>     |                                                   |
>     |- task=sc->SCp.ptr, task is not NUL, check passed  |-
> iscsi_free_task(task)
>     |                                                   |
>     |                                                   |-> sc->SCp.ptr
> = NULL
>     |                                                   |
>     |- task is NULL now, NULL pointer dereference       |
>     |                                                   |
>    \|/                                                 \|/
> 
> Calltrace:
> [380751.840862] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000138
> [380751.843709] PGD 0 P4D 0
> [380751.844770] Oops: 0000 [#1] SMP PTI
> [380751.846283] CPU: 0 PID: 403 Comm: kworker/0:1H Kdump: loaded
> Tainted: G
> [380751.851467] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
> [380751.856521] Workqueue: kblockd blk_mq_timeout_work
> [380751.858527] RIP: 0010:iscsi_eh_cmd_timed_out+0x15e/0x2e0 [libiscsi]
> [380751.861129] Code: 83 ea 01 48 8d 74 d0 08 48 8b 10 48 8b 4a 50 48 85
> c9 74 2c 48 39 d5 74
> [380751.868811] RSP: 0018:ffffc1e280a5fd58 EFLAGS: 00010246
> [380751.870978] RAX: ffff9fd1e84e15e0 RBX: ffff9fd1e84e6dd0 RCX:
> 0000000116acc580
> [380751.873791] RDX: ffff9fd1f97a9400 RSI: ffff9fd1e84e1800 RDI:
> ffff9fd1e4d6d420
> [380751.876059] RBP: ffff9fd1e4d49000 R08: 0000000116acc580 R09:
> 0000000116acc580
> [380751.878284] R10: 0000000000000000 R11: 0000000000000000 R12:
> ffff9fd1e6e931e8
> [380751.880500] R13: ffff9fd1e84e6ee0 R14: 0000000000000010 R15:
> 0000000000000003
> [380751.882687] FS:  0000000000000000(0000) GS:ffff9fd1fac00000(0000)
> knlGS:0000000000000000
> [380751.885236] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [380751.887059] CR2: 0000000000000138 CR3: 000000011860a001 CR4:
> 00000000003606f0
> [380751.889308] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [380751.891523] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> [380751.893738] Call Trace:
> [380751.894639]  scsi_times_out+0x60/0x1c0
> [380751.895861]  blk_mq_check_expired+0x144/0x200
> [380751.897302]  ? __switch_to_asm+0x35/0x70
> [380751.898551]  blk_mq_queue_tag_busy_iter+0x195/0x2e0
> [380751.900091]  ? __blk_mq_requeue_request+0x100/0x100
> [380751.901611]  ? __switch_to_asm+0x41/0x70
> [380751.902853]  ? __blk_mq_requeue_request+0x100/0x100
> [380751.904398]  blk_mq_timeout_work+0x54/0x130
> [380751.905740]  process_one_work+0x195/0x390
> [380751.907228]  worker_thread+0x30/0x390
> [380751.908713]  ? process_one_work+0x390/0x390
> [380751.910350]  kthread+0x10d/0x130
> [380751.911470]  ? kthread_flush_work_fn+0x10/0x10
> [380751.913007]  ret_from_fork+0x35/0x40
> 
> crash> dis -l iscsi_eh_cmd_timed_out+0x15e
> xxxxx/drivers/scsi/libiscsi.c: 2062
> 
> 1970 enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd
> *sc)
> {
> ...
> 1984         spin_lock_bh(&session->frwd_lock);
> 1985         task = (struct iscsi_task *)sc->SCp.ptr;
> 1986         if (!task) {
> 1987                 /*
> 1988                  * Raced with completion. Blk layer has taken
> ownership
> 1989                  * so let timeout code complete it now.
> 1990                  */
> 1991                 rc = BLK_EH_DONE;
> 1992                 goto done;
> 1993         }
> 
> ...
> 
> 2052         for (i = 0; i < conn->session->cmds_max; i++) {
> 2053                 running_task = conn->session->cmds[i];
> 2054                 if (!running_task->sc || running_task == task ||
> 2055                      running_task->state != ISCSI_TASK_RUNNING)
> 2056                         continue;
> 2057
> 2058                 /*
> 2059                  * Only check if cmds started before this one have
> made
> 2060                  * progress, or this could never fail
> 2061                  */
> 2062                 if (time_after(running_task->sc->jiffies_at_alloc,
> 2063                                task->sc->jiffies_at_alloc))    <---
> 2064                         continue;
> 2065
> ...
> }
> 
> carsh> struct scsi_cmnd ffff9fd1e6e931e8
> struct scsi_cmnd {
>   ...
>   SCp = {
>     ptr = 0x0,   <--- iscsi_task
>     this_residual = 0,
>     ...
>   },
> }
> 
> To prevent this, we take a ref to the cmd under the back (completion)
> lock so if the completion side were to call iscsi_complete_task on the
> task while the timer/eh paths are not holding the back_lock it will
> not be freed from under us.
> 
> Note that this requires the previous patch because bnx2i sleeps in its

Could you reference the patch that is needed more specifically than
"previous"? After that, please add my reviewed-by tag.

> cleanup_task callout if the cmd is aborted. If the EH/timer and
> completion path are racing we don't know which path will do the last
> put. The previous patch moved the operations we needed to do under the
> forward lock to cleanup_queued_task. Once that has run we can drop the
> forward lock for the cmd and bnx2i no longer has to worry about if the
> EH, timer or completion path did the last put and if the forward lock
> is held or not since it won't be.
> 
> Reported-by: Wu Bo <wubo40@huawei.com>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/bnx2i/bnx2i_iscsi.c |  2 --
>  drivers/scsi/libiscsi.c          | 71 +++++++++++++++++++++++++---------------
>  2 files changed, 45 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> index fdd4467..1e6d8f6 100644
> --- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> @@ -1171,10 +1171,8 @@ static void bnx2i_cleanup_task(struct iscsi_task *task)
>  		bnx2i_send_cmd_cleanup_req(hba, task->dd_data);
>  
>  		spin_unlock_bh(&conn->session->back_lock);
> -		spin_unlock_bh(&conn->session->frwd_lock);
>  		wait_for_completion_timeout(&bnx2i_conn->cmd_cleanup_cmpl,
>  				msecs_to_jiffies(ISCSI_CMD_CLEANUP_TIMEOUT));
> -		spin_lock_bh(&conn->session->frwd_lock);
>  		spin_lock_bh(&conn->session->back_lock);
>  	}
>  	bnx2i_iscsi_unmap_sg_list(task->dd_data);
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 7efeec9..0e71453 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -586,9 +586,8 @@ static bool cleanup_queued_task(struct iscsi_task *task)
>  }
>  
>  /*
> - * session frwd_lock must be held and if not called for a task that is
> - * still pending or from the xmit thread, then xmit thread must
> - * be suspended.
> + * session frwd lock must be held and if not called for a task that is still
> + * pending or from the xmit thread, then xmit thread must be suspended
>   */
>  static void fail_scsi_task(struct iscsi_task *task, int err)
>  {
> @@ -596,16 +595,6 @@ static void fail_scsi_task(struct iscsi_task *task, int err)
>  	struct scsi_cmnd *sc;
>  	int state;
>  
> -	/*
> -	 * if a command completes and we get a successful tmf response
> -	 * we will hit this because the scsi eh abort code does not take
> -	 * a ref to the task.
> -	 */
> -	sc = task->sc;
> -	if (!sc)
> -		return;
> -
> -	/* regular RX path uses back_lock */
>  	spin_lock_bh(&conn->session->back_lock);
>  	if (cleanup_queued_task(task)) {
>  		spin_unlock_bh(&conn->session->back_lock);
> @@ -625,6 +614,7 @@ static void fail_scsi_task(struct iscsi_task *task, int err)
>  	else
>  		state = ISCSI_TASK_ABRT_TMF;
>  
> +	sc = task->sc;
>  	sc->result = err << 16;
>  	scsi_set_resid(sc, scsi_bufflen(sc));
>  	iscsi_complete_task(task, state);
> @@ -1885,27 +1875,39 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
>  }
>  
>  /*
> - * Fail commands. session lock held and recv side suspended and xmit
> - * thread flushed
> + * Fail commands. session frwd lock held and xmit thread flushed.
>   */
>  static void fail_scsi_tasks(struct iscsi_conn *conn, u64 lun, int error)
>  {
> +	struct iscsi_session *session = conn->session;
>  	struct iscsi_task *task;
>  	int i;
>  
> -	for (i = 0; i < conn->session->cmds_max; i++) {
> -		task = conn->session->cmds[i];
> +	spin_lock_bh(&session->back_lock);
> +	for (i = 0; i < session->cmds_max; i++) {
> +		task = session->cmds[i];
>  		if (!task->sc || task->state == ISCSI_TASK_FREE)
>  			continue;
>  
>  		if (lun != -1 && lun != task->sc->device->lun)
>  			continue;
>  
> -		ISCSI_DBG_SESSION(conn->session,
> +		__iscsi_get_task(task);
> +		spin_unlock_bh(&session->back_lock);
> +
> +		ISCSI_DBG_SESSION(session,
>  				  "failing sc %p itt 0x%x state %d\n",
>  				  task->sc, task->itt, task->state);
>  		fail_scsi_task(task, error);
> +
> +		spin_unlock_bh(&session->frwd_lock);
> +		iscsi_put_task(task);
> +		spin_lock_bh(&session->frwd_lock);
> +
> +		spin_lock_bh(&session->back_lock);
>  	}
> +
> +	spin_unlock_bh(&session->back_lock);
>  }
>  
>  /**
> @@ -1983,6 +1985,7 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
>  	ISCSI_DBG_EH(session, "scsi cmd %p timedout\n", sc);
>  
>  	spin_lock_bh(&session->frwd_lock);
> +	spin_lock(&session->back_lock);
>  	task = (struct iscsi_task *)sc->SCp.ptr;
>  	if (!task) {
>  		/*
> @@ -1990,8 +1993,11 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
>  		 * so let timeout code complete it now.
>  		 */
>  		rc = BLK_EH_DONE;
> +		spin_unlock(&session->back_lock);
>  		goto done;
>  	}
> +	__iscsi_get_task(task);
> +	spin_unlock(&session->back_lock);
>  
>  	if (session->state != ISCSI_STATE_LOGGED_IN) {
>  		/*
> @@ -2050,6 +2056,7 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
>  		goto done;
>  	}
>  
> +	spin_lock(&session->back_lock);
>  	for (i = 0; i < conn->session->cmds_max; i++) {
>  		running_task = conn->session->cmds[i];
>  		if (!running_task->sc || running_task == task ||
> @@ -2082,10 +2089,12 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
>  				     "last xfer %lu/%lu. Last check %lu.\n",
>  				     task->last_xfer, running_task->last_xfer,
>  				     task->last_timeout);
> +			spin_unlock(&session->back_lock);
>  			rc = BLK_EH_RESET_TIMER;
>  			goto done;
>  		}
>  	}
> +	spin_unlock(&session->back_lock);
>  
>  	/* Assumes nop timeout is shorter than scsi cmd timeout */
>  	if (task->have_checked_conn)
> @@ -2107,9 +2116,12 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
>  	rc = BLK_EH_RESET_TIMER;
>  
>  done:
> -	if (task)
> -		task->last_timeout = jiffies;
>  	spin_unlock_bh(&session->frwd_lock);
> +
> +	if (task) {
> +		task->last_timeout = jiffies;
> +		iscsi_put_task(task);
> +	}
>  	ISCSI_DBG_EH(session, "return %s\n", rc == BLK_EH_RESET_TIMER ?
>  		     "timer reset" : "shutdown or nh");
>  	return rc;
> @@ -2217,15 +2229,20 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
>  	conn->eh_abort_cnt++;
>  	age = session->age;
>  
> +	spin_lock(&session->back_lock);
>  	task = (struct iscsi_task *)sc->SCp.ptr;
> -	ISCSI_DBG_EH(session, "aborting [sc %p itt 0x%x]\n",
> -		     sc, task->itt);
> -
> -	/* task completed before time out */
> -	if (!task->sc) {
> +	if (!task || !task->sc) {
> +		/* task completed before time out */
>  		ISCSI_DBG_EH(session, "sc completed while abort in progress\n");
> -		goto success;
> +
> +		spin_unlock(&session->back_lock);
> +		spin_unlock_bh(&session->frwd_lock);
> +		mutex_unlock(&session->eh_mutex);
> +		return SUCCESS;
>  	}
> +	ISCSI_DBG_EH(session, "aborting [sc %p itt 0x%x]\n", sc, task->itt);
> +	__iscsi_get_task(task);
> +	spin_unlock(&session->back_lock);
>  
>  	if (task->state == ISCSI_TASK_PENDING) {
>  		fail_scsi_task(task, DID_ABORT);
> @@ -2287,6 +2304,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
>  success_unlocked:
>  	ISCSI_DBG_EH(session, "abort success [sc %p itt 0x%x]\n",
>  		     sc, task->itt);
> +	iscsi_put_task(task);
>  	mutex_unlock(&session->eh_mutex);
>  	return SUCCESS;
>  
> @@ -2295,6 +2313,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
>  failed_unlocked:
>  	ISCSI_DBG_EH(session, "abort failed [sc %p itt 0x%x]\n", sc,
>  		     task ? task->itt : 0);
> +	iscsi_put_task(task);
>  	mutex_unlock(&session->eh_mutex);
>  	return FAILED;
>  }
> 

