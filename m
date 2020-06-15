Return-Path: <SRS0=1R64=74=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0C42C433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 02:14:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9030620747
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 02:14:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="csBjt91C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbgFOCOT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 14 Jun 2020 22:14:19 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58221 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728013AbgFOCOT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 14 Jun 2020 22:14:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592187257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oC0av0vQJ8YG+fPpYXky82/c+3E5L5H7myi85YmcqKU=;
        b=csBjt91CFxEtafOiE48NGE7hpnC80z5jopZMKv/hlOK4NI25ZtGotrBF90QfhI5rQQhGPx
        DNEtW7WPPbH29TLuMvTw2h6yqkaFXlWTo0mid++IRL41ObjEsHe6i9+0RIiCavb9GCms4c
        rNJeGePIccje9s/Ge0TSyUMNCnMq6nk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-eBt34TJpM562vHAHM4b3ng-1; Sun, 14 Jun 2020 22:14:13 -0400
X-MC-Unique: eBt34TJpM562vHAHM4b3ng-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A25DC846348;
        Mon, 15 Jun 2020 02:14:10 +0000 (UTC)
Received: from T590 (ovpn-12-247.pek2.redhat.com [10.72.12.247])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 494A99032A;
        Mon, 15 Jun 2020 02:13:59 +0000 (UTC)
Date:   Mon, 15 Jun 2020 10:13:55 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
Cc:     John Garry <john.garry@huawei.com>, axboe@kernel.dk,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        don.brace@microsemi.com, Sumit Saxena <sumit.saxena@broadcom.com>,
        bvanassche@acm.org, hare@suse.com, hch@lst.de,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>
Subject: Re: [PATCH RFC v7 00/12] blk-mq/scsi: Provide hostwide shared tags
 for SCSI HBAs
Message-ID: <20200615021355.GA4012@T590>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <20200611030708.GB453671@T590>
 <c033f445-97fd-6dc9-c270-9890681b39d9@huawei.com>
 <bbdec3b3fbeb9907d2ec66a2afa56c29@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bbdec3b3fbeb9907d2ec66a2afa56c29@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Jun 13, 2020 at 12:17:37AM +0530, Kashyap Desai wrote:
> > On 11/06/2020 04:07, Ming Lei wrote:
> > >> Using 12x SAS SSDs on hisi_sas v3 hw. mq-deadline results are
> > >> included, but it is not always an appropriate scheduler to use.
> > >>
> > >> Tag depth 		4000 (default)			260**
> > >>
> > >> Baseline:
> > >> none sched:		2290K IOPS			894K
> > >> mq-deadline sched:	2341K IOPS			2313K
> > >>
> > >> Final, host_tagset=0 in LLDD*
> > >> none sched:		2289K IOPS			703K
> > >> mq-deadline sched:	2337K IOPS			2291K
> > >>
> > >> Final:
> > >> none sched:		2281K IOPS			1101K
> > >> mq-deadline sched:	2322K IOPS			1278K
> > >>
> > >> * this is relevant as this is the performance in supporting but not
> > >>    enabling the feature
> > >> ** depth=260 is relevant as some point where we are regularly waiting
> > >> for
> > >>     tags to be available. Figures were are a bit unstable here for
> > >> testing.
> 
> John -
> 
> I tried V7 series and debug further on mq-deadline interface. This time I
> have used another setup since HDD based setup is not readily available for
> me.
> In fact, I was able to simulate issue very easily using single scsi_device
> as well. BTW, this is not an issue with this RFC, but generic issue.
> Since I have converted nr_hw_queue > 1 for Broadcom product using this RFC,
> It becomes noticeable now.
> 
> Problem - Using below command  I see heavy CPU utilization on "
> native_queued_spin_lock_slowpath". This is because kblockd work queue is
> submitting IO from all the CPUs even though fio is bound to single CPU.
> Lock contention from " dd_dispatch_request" is causing this issue.
> 
> numactl -C 13  fio
> single.fio --iodepth=32 --bs=4k --rw=randread --ioscheduler=none --numjobs=1
>  --cpus_allowed_policy=split --ioscheduler=mq-deadline
> --group_reporting --filename=/dev/sdd
> 
> While running above command, ideally we expect only kworker/13 to be active.
> But you can see below - All the CPU is attempting submission and lots of CPU
> consumption is due to lock contention.
> 
>   PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
>  2726 root       0 -20       0      0      0 R  56.5  0.0   0:53.20
> kworker/13:1H-k
>  7815 root      20   0  712404  15536   2228 R  43.2  0.0   0:05.03 fio
>  2792 root       0 -20       0      0      0 I  26.6  0.0   0:22.19
> kworker/18:1H-k
>  2791 root       0 -20       0      0      0 I  19.9  0.0   0:17.17
> kworker/19:1H-k
>  1419 root       0 -20       0      0      0 I  19.6  0.0   0:17.03
> kworker/20:1H-k
>  2793 root       0 -20       0      0      0 I  18.3  0.0   0:15.64
> kworker/21:1H-k
>  1424 root       0 -20       0      0      0 I  17.3  0.0   0:14.99
> kworker/22:1H-k
>  2626 root       0 -20       0      0      0 I  16.9  0.0   0:14.68
> kworker/26:1H-k
>  2794 root       0 -20       0      0      0 I  16.9  0.0   0:14.87
> kworker/23:1H-k
>  2795 root       0 -20       0      0      0 I  16.9  0.0   0:14.81
> kworker/24:1H-k
>  2797 root       0 -20       0      0      0 I  16.9  0.0   0:14.62
> kworker/27:1H-k
>  1415 root       0 -20       0      0      0 I  16.6  0.0   0:14.44
> kworker/30:1H-k
>  2669 root       0 -20       0      0      0 I  16.6  0.0   0:14.38
> kworker/31:1H-k
>  2796 root       0 -20       0      0      0 I  16.6  0.0   0:14.74
> kworker/25:1H-k
>  2799 root       0 -20       0      0      0 I  16.6  0.0   0:14.56
> kworker/28:1H-k
>  1425 root       0 -20       0      0      0 I  16.3  0.0   0:14.21
> kworker/34:1H-k
>  2746 root       0 -20       0      0      0 I  16.3  0.0   0:14.33
> kworker/32:1H-k
>  2798 root       0 -20       0      0      0 I  16.3  0.0   0:14.50
> kworker/29:1H-k
>  2800 root       0 -20       0      0      0 I  16.3  0.0   0:14.27
> kworker/33:1H-k
>  1423 root       0 -20       0      0      0 I  15.9  0.0   0:14.10
> kworker/54:1H-k
>  1784 root       0 -20       0      0      0 I  15.9  0.0   0:14.03
> kworker/55:1H-k
>  2801 root       0 -20       0      0      0 I  15.9  0.0   0:14.15
> kworker/35:1H-k
>  2815 root       0 -20       0      0      0 I  15.9  0.0   0:13.97
> kworker/56:1H-k
>  1484 root       0 -20       0      0      0 I  15.6  0.0   0:13.90
> kworker/57:1H-k
>  1485 root       0 -20       0      0      0 I  15.6  0.0   0:13.82
> kworker/59:1H-k
>  1519 root       0 -20       0      0      0 I  15.6  0.0   0:13.64
> kworker/62:1H-k
>  2315 root       0 -20       0      0      0 I  15.6  0.0   0:13.87
> kworker/58:1H-k
>  2627 root       0 -20       0      0      0 I  15.6  0.0   0:13.69
> kworker/61:1H-k
>  2816 root       0 -20       0      0      0 I  15.6  0.0   0:13.75
> kworker/60:1H-k
> 
> 
> I root cause this issue -
> 
> Block layer always queue IO on hctx context mapped to CPU-13, but hw queue
> run from all the hctx context.
> I noticed in my test hctx48 has queued all the IOs. No other hctx has queued
> IO. But all the hctx is counting for "run".
> 
> # cat hctx48/queued
> 2087058
> 
> #cat hctx*/run
> 151318
> 30038
> 83110
> 50680
> 69907
> 60391
> 111239
> 18036
> 33935
> 91648
> 34582
> 22853
> 61286
> 19489
> 
> Below patch has fix - "Run the hctx queue for which request was completed
> instead of running all the hardware queue."
> If this looks valid fix, please include in V8 OR I can post separate patch
> for this. Just want to have some level of review from this discussion.
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 0652acd..f52118f 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -554,6 +554,7 @@ static bool scsi_end_request(struct request *req,
> blk_status_t error,
>         struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
>         struct scsi_device *sdev = cmd->device;
>         struct request_queue *q = sdev->request_queue;
> +       struct blk_mq_hw_ctx *mq_hctx = req->mq_hctx;
> 
>         if (blk_update_request(req, error, bytes))
>                 return true;
> @@ -595,7 +596,8 @@ static bool scsi_end_request(struct request *req,
> blk_status_t error,
>             !list_empty(&sdev->host->starved_list))
>                 kblockd_schedule_work(&sdev->requeue_work);
>         else
> -               blk_mq_run_hw_queues(q, true);
> +               blk_mq_run_hw_queue(mq_hctx, true);
> +               //blk_mq_run_hw_queues(q, true);

This way may cause IO hang because ->device_busy is shared by all hctxs.

Thanks,
Ming

