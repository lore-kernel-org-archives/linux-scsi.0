Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74A01C43603
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 23:44:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B2362072B
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 23:44:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="A9v1WAy/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfLTXoK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 18:44:10 -0500
Received: from mail-bn8nam12on2127.outbound.protection.outlook.com ([40.107.237.127]:51003
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726470AbfLTXoK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Dec 2019 18:44:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LSvArl7uXtc3AEfjIxpvbYKQvbxu096SaOjByUove8c3TpUe+Kz0WLsgP61IeX54n1VRZthlhdbcPtmOSnsVSxyAa1/Su+YYS46IhaXGo4YEdT7X6B0r2AqO6BFWy9MPUOZYUluAkofa7Zi09MJP1rjLCUHCEWCrFojl55qR6Sp3IGkHDzcGm2XO5/GQsj1vQru115AGWSnIavdqJs4E+xjCL7UB97P18PvP0fs+cNDkFBc/Id62V1Q2xMcYtetYEuYIHs3kGM4whhNI7cwBK1sYZHdWs9HyuwEnaK9curHeL/rNE6SnB7t9so1sh92G/F0rwRDdw8qw0At8UJxIqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=faVDxqi15toBHxO963/xmBnHxlzfh+UD1m6nVCtdJlM=;
 b=R+pTqa79sdeqXwBNam3/wPKLLKT8SiardPFUMoXgHmLHnTLA/HoaQke/ooQbAr/dSgC8b6GblR8m+2DocCtrvzlW+c4CueCuG3sdekwRLHcXazqus0QdrtvTQ2KHYUgHA2NItFBWd8pB+HuFUJOFYbqeFIqjith3f5Cji2lkq6T1AZK0gsAbBZrCTn94/d1a4MYUN0U15t1GEpNsHkDtd/DRoKOvgqBg5dzNVcXk0o+r5MmLZR9lBazIjzfE/dda1h4CibquMjroMdNfVBvWJKrIvSsX3JRslo5GMX7kVgPsDukUGk56u8IlTFwOfO/AocvvtxGGqT8tZDinaantDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=faVDxqi15toBHxO963/xmBnHxlzfh+UD1m6nVCtdJlM=;
 b=A9v1WAy/DZ2QKvUpqL3/OV9gDEVkZBzX7ZQ2GcnVboVeE5GzvJXDspLtJC+IQljOBLPGuFPvHkkXLkz0pAmOnso0n1Pd5LchRQ/FuXIzt2G5QZlzFr6PmBo1xfgV1NLq5YuFR8ZOETqnYwjzxGwlpmdwT9G8E+7ONqZh/izyOqg=
Received: from BL0PR2101MB1123.namprd21.prod.outlook.com (52.132.20.151) by
 BL0PR2101MB1089.namprd21.prod.outlook.com (52.132.24.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.8; Fri, 20 Dec 2019 23:44:04 +0000
Received: from BL0PR2101MB1123.namprd21.prod.outlook.com
 ([fe80::602f:c781:a5ff:39f3]) by BL0PR2101MB1123.namprd21.prod.outlook.com
 ([fe80::602f:c781:a5ff:39f3%3]) with mapi id 15.20.2581.001; Fri, 20 Dec 2019
 23:44:04 +0000
From:   Long Li <longli@microsoft.com>
To:     Ming Lei <ming.lei@redhat.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@wdc.com>
Subject: RE: [PATCH V3] scsi: core: only re-run queue in scsi_end_request() if
 device queue is busy
Thread-Topic: [PATCH V3] scsi: core: only re-run queue in scsi_end_request()
 if device queue is busy
Thread-Index: AQHVoBuDkuQCRWcx70KP5vOBgj6wO6fD3L0AgAABEJA=
Date:   Fri, 20 Dec 2019 23:44:04 +0000
Message-ID: <BL0PR2101MB11230C5F70151037B23C0C35CE2D0@BL0PR2101MB1123.namprd21.prod.outlook.com>
References: <20191121032634.32650-1-ming.lei@redhat.com>
 <20191220233744.GC12403@ming.t460p>
In-Reply-To: <20191220233744.GC12403@ming.t460p>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=longli@microsoft.com; 
x-originating-ip: [2001:4898:80e8:3:edeb:db5c:c6fe:798]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d3d5cb5c-375e-411b-cac3-08d785a67f47
x-ms-traffictypediagnostic: BL0PR2101MB1089:
x-microsoft-antispam-prvs: <BL0PR2101MB1089CD550FC8A0D28F4152FFCE2D0@BL0PR2101MB1089.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:513;
x-forefront-prvs: 025796F161
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(136003)(376002)(396003)(39860400002)(199004)(189003)(66476007)(52536014)(9686003)(64756008)(55016002)(2906002)(478600001)(8990500004)(66556008)(66446008)(71200400001)(81156014)(81166006)(7416002)(86362001)(33656002)(76116006)(5660300002)(66946007)(10290500003)(316002)(54906003)(8936002)(6506007)(110136005)(8676002)(7696005)(4326008)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:BL0PR2101MB1089;H:BL0PR2101MB1123.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zcc+HnA0hYD6oHYBOwnoJXVf/p5/V2iITFXn7EbKil3cXeZm5TvgtVHSoYQtuO/LxUdRxeeyY0hYgWXIgPVIVGllXq8iMJ0WImFC+PZEqBs+GFQanl63E4h46lYZeImhjL0f4Gr+gjL/1e+WIS7VF2t0WezzFFqr0yXnhsZnNkWaLCKYNI7i8vj5qiwXJXZ+L2XosdsfLGawfGHrq+HaMkGK7N7/KgawJ8unhx8zaripiQq93SaaITYfxWQWFLXw6ceTQeADt/C3z9rIDl8qyIBnzgQ6tdNNAJw3KRvgH1Lai6P/6FdfmvpPjDujNVZu4PXfEjjY6SCSdFYaIufpjTPLTu6g1FXKReO70NjnBZ/CpZKDpmjfcWAuKLw1eKSUhVh99dGicLHIsOcz67v/aVaYCS9Fux/gAKTFObLCtoy0xkiGWUX8MCvpDq/dVUNI
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3d5cb5c-375e-411b-cac3-08d785a67f47
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2019 23:44:04.1312
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OC+1DiORpjXHvvUFx5weFEGpR5Vl3kLWEk/cHDRWk5YFGYcknk/QrDve+tb0YVWm9brNsjgFJp93kb1OvreqVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1089
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>Subject: Re: [PATCH V3] scsi: core: only re-run queue in scsi_end_request(=
) if
>device queue is busy
>
>On Thu, Nov 21, 2019 at 11:26:34AM +0800, Ming Lei wrote:
>> Now the request queue is run in scsi_end_request() unconditionally if
>> both target queue and host queue is ready. We should have re-run
>> request queue only after this device queue becomes busy for restarting t=
his
>LUN only.
>>
>> Recently Long Li reported that cost of run queue may be very heavy in
>> case of high queue depth. So improve this situation by only running
>> the request queue when this LUN is busy.
>>
>> Cc: Jens Axboe <axboe@kernel.dk>
>> Cc: Ewan D. Milne <emilne@redhat.com>
>> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
>> Cc: Hannes Reinecke <hare@suse.de>
>> Cc: Bart Van Assche <bvanassche@acm.org>
>> Cc: Damien Le Moal <damien.lemoal@wdc.com>
>> Cc: Long Li <longli@microsoft.com>
>> Reported-by: Long Li <longli@microsoft.com>
>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>> ---
>> V3:
>> 	- add one smp_mb() in scsi_mq_get_budget() and comment
>>
>> V2:
>> 	- commit log change, no any code change
>> 	- add reported-by tag
>>
>>
>>  drivers/scsi/scsi_lib.c    | 43 ++++++++++++++++++++++++++++++++++++-
>-
>>  include/scsi/scsi_device.h |  1 +
>>  2 files changed, 42 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c index
>> 379533ce8661..d3d237a09a78 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -607,12 +607,17 @@ static bool scsi_end_request(struct request *req,
>blk_status_t error,
>>  	 */
>>  	percpu_ref_get(&q->q_usage_counter);
>>
>> +	/*
>> +	 * One smp_mb() is implied by either rq->end_io or
>> +	 * blk_mq_free_request for ordering writing .device_busy in
>> +	 * scsi_device_unbusy() and reading sdev->restart.
>> +	 */
>>  	__blk_mq_end_request(req, error);
>>
>>  	if (scsi_target(sdev)->single_lun ||
>>  	    !list_empty(&sdev->host->starved_list))
>>  		kblockd_schedule_work(&sdev->requeue_work);
>> -	else
>> +	else if (READ_ONCE(sdev->restart))
>>  		blk_mq_run_hw_queues(q, true);
>>
>>  	percpu_ref_put(&q->q_usage_counter);
>> @@ -1632,8 +1637,42 @@ static bool scsi_mq_get_budget(struct
>blk_mq_hw_ctx *hctx)
>>  	struct request_queue *q =3D hctx->queue;
>>  	struct scsi_device *sdev =3D q->queuedata;
>>
>> -	if (scsi_dev_queue_ready(q, sdev))
>> +	if (scsi_dev_queue_ready(q, sdev)) {
>> +		WRITE_ONCE(sdev->restart, 0);
>>  		return true;
>> +	}
>> +
>> +	/*
>> +	 * If all in-flight requests originated from this LUN are completed
>> +	 * before setting .restart, sdev->device_busy will be observed as
>> +	 * zero, then blk_mq_delay_run_hw_queue() will dispatch this
>request
>> +	 * soon. Otherwise, completion of one of these request will observe
>> +	 * the .restart flag, and the request queue will be run for handling
>> +	 * this request, see scsi_end_request().
>> +	 *
>> +	 * However, the .restart flag may be cleared from other dispatch code
>> +	 * path after one inflight request is completed, then:
>> +	 *
>> +	 * 1) if this request is dispatched from scheduler queue or sw queue
>one
>> +	 * by one, this request will be handled in that dispatch path too give=
n
>> +	 * the request still stays at scheduler/sw queue when
>calling .get_budget()
>> +	 * callback.
>> +	 *
>> +	 * 2) if this request is dispatched from hctx->dispatch or
>> +	 * blk_mq_flush_busy_ctxs(), this request will be put into hctx-
>>dispatch
>> +	 * list soon, and blk-mq will be responsible for covering it, see
>> +	 * blk_mq_dispatch_rq_list().
>> +	 */
>> +	WRITE_ONCE(sdev->restart, 1);
>> +
>> +	/*
>> +	 * Order writting .restart and reading .device_busy, and make sure
>> +	 * .restart is visible to scsi_end_request(). Its pair is implied by
>> +	 * __blk_mq_end_request() in scsi_end_request() for ordering
>> +	 * writing .device_busy in scsi_device_unbusy() and reading .restart.
>> +	 *
>> +	 */
>> +	smp_mb();
>>
>>  	if (atomic_read(&sdev->device_busy) =3D=3D 0
>&& !scsi_device_blocked(sdev))
>>  		blk_mq_delay_run_hw_queue(hctx, SCSI_QUEUE_DELAY);
>diff --git
>> a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h index
>> 202f4d6a4342..9d8ca662ae86 100644
>> --- a/include/scsi/scsi_device.h
>> +++ b/include/scsi/scsi_device.h
>> @@ -109,6 +109,7 @@ struct scsi_device {
>>  	atomic_t device_busy;		/* commands actually active on LLDD
>*/
>>  	atomic_t device_blocked;	/* Device returned QUEUE_FULL. */
>>
>> +	unsigned int restart;
>>  	spinlock_t list_lock;
>>  	struct list_head cmd_list;	/* queue of in use SCSI Command
>structures */
>>  	struct list_head starved_entry;
>> --
>> 2.20.1
>>
>
>Ping...

This patch passed stress tests on Linux VM running in Azure.

Tested-by: Long Li <longli@microsoft.com>

>
>Thanks,
>Ming

