Return-Path: <SRS0=UMfj=7Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4D98C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Jun 2020 18:47:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BFC820801
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Jun 2020 18:47:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="SsDNJEJD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgFLSrm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Jun 2020 14:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbgFLSrl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2020 14:47:41 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF44AC03E96F
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2020 11:47:41 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id d27so7924244qtg.4
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2020 11:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=rI24GO/8Hr+LS8jdF1oMcr0n+yC/NShjfT4BypB7VFo=;
        b=SsDNJEJDn4/mO5P3o4yahoddyjd8ikKaBXn3qH9wpaOf4wyEVbWRmWEMEgpIK5GPxd
         kxHDnPvs3tV8Lt6UzVYHFDFIoO4zMlo5qNCc3ESb5eH7Hv5tDrm8LugX6ib9zHPG87Gw
         Vt/kT8gy4FZD2FivqyY9n7dEa1pJGdxxBH8eg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=rI24GO/8Hr+LS8jdF1oMcr0n+yC/NShjfT4BypB7VFo=;
        b=USs5bL9Ym2EVNXwctlAbXMyD2c25HR0DNI2GMSKW3NK6A5R5gjZ9bGSq0W/d74zI7w
         kiKA3V/sL/Yx+yCDdMtDbAaRr3oiR3JwEuSR2kZTa5NJLRf50+THeiiCBWzD1pQTCYp0
         J7k/RhNsV/n8LEH0SDDPcszIcChhI0oSJuT2SwcHhJMA9hplT50yEqBI42uI/r7g8VNv
         VkGLeIZgWNnuDL8eLS5q3gZt3yuKRe0ycborUUKnnmFYWs7/yaCfvQbxC36XF91wwEsn
         NdHj5+zrqKfzL+cvKPP/VtQtPQGRlm0CX12hxq1uGyTn63HrVWVIPyUijjNPYoRyEhmS
         YbSQ==
X-Gm-Message-State: AOAM532JEevpeDVMZyvxXMr0m2TNTAizIpyHPDLJbgCHPJfnKr2KvrAb
        NRGyVIBYZlXB4+uSfsG/a84FtJIYdiw/Plx8k73IiA==
X-Google-Smtp-Source: ABdhPJyBjmgpQEOQwPQqFedtCWeyCwsOxhVNf4Mi9pk6UVPk1iSL9GhHitWg+NDcT12vWELNU7SSof+SrvOPM+A0nkI=
X-Received: by 2002:ac8:7413:: with SMTP id p19mr4513121qtq.387.1591987660733;
 Fri, 12 Jun 2020 11:47:40 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <20200611030708.GB453671@T590> <c033f445-97fd-6dc9-c270-9890681b39d9@huawei.com>
In-Reply-To: <c033f445-97fd-6dc9-c270-9890681b39d9@huawei.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQBVjmvxAE7FMYb7GtMRWGcwtMcECgGaerxUAVTJvjGrvzbDoA==
Date:   Sat, 13 Jun 2020 00:17:37 +0530
Message-ID: <bbdec3b3fbeb9907d2ec66a2afa56c29@mail.gmail.com>
Subject: RE: [PATCH RFC v7 00/12] blk-mq/scsi: Provide hostwide shared tags
 for SCSI HBAs
To:     John Garry <john.garry@huawei.com>, Ming Lei <ming.lei@redhat.com>
Cc:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        don.brace@microsemi.com, Sumit Saxena <sumit.saxena@broadcom.com>,
        bvanassche@acm.org, hare@suse.com, hch@lst.de,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On 11/06/2020 04:07, Ming Lei wrote:
> >> Using 12x SAS SSDs on hisi_sas v3 hw. mq-deadline results are
> >> included, but it is not always an appropriate scheduler to use.
> >>
> >> Tag depth 		4000 (default)			260**
> >>
> >> Baseline:
> >> none sched:		2290K IOPS			894K
> >> mq-deadline sched:	2341K IOPS			2313K
> >>
> >> Final, host_tagset=0 in LLDD*
> >> none sched:		2289K IOPS			703K
> >> mq-deadline sched:	2337K IOPS			2291K
> >>
> >> Final:
> >> none sched:		2281K IOPS			1101K
> >> mq-deadline sched:	2322K IOPS			1278K
> >>
> >> * this is relevant as this is the performance in supporting but not
> >>    enabling the feature
> >> ** depth=260 is relevant as some point where we are regularly waiting
> >> for
> >>     tags to be available. Figures were are a bit unstable here for
> >> testing.

John -

I tried V7 series and debug further on mq-deadline interface. This time I
have used another setup since HDD based setup is not readily available for
me.
In fact, I was able to simulate issue very easily using single scsi_device
as well. BTW, this is not an issue with this RFC, but generic issue.
Since I have converted nr_hw_queue > 1 for Broadcom product using this RFC,
It becomes noticeable now.

Problem - Using below command  I see heavy CPU utilization on "
native_queued_spin_lock_slowpath". This is because kblockd work queue is
submitting IO from all the CPUs even though fio is bound to single CPU.
Lock contention from " dd_dispatch_request" is causing this issue.

numactl -C 13  fio
single.fio --iodepth=32 --bs=4k --rw=randread --ioscheduler=none --numjobs=1
 --cpus_allowed_policy=split --ioscheduler=mq-deadline
--group_reporting --filename=/dev/sdd

While running above command, ideally we expect only kworker/13 to be active.
But you can see below - All the CPU is attempting submission and lots of CPU
consumption is due to lock contention.

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
 2726 root       0 -20       0      0      0 R  56.5  0.0   0:53.20
kworker/13:1H-k
 7815 root      20   0  712404  15536   2228 R  43.2  0.0   0:05.03 fio
 2792 root       0 -20       0      0      0 I  26.6  0.0   0:22.19
kworker/18:1H-k
 2791 root       0 -20       0      0      0 I  19.9  0.0   0:17.17
kworker/19:1H-k
 1419 root       0 -20       0      0      0 I  19.6  0.0   0:17.03
kworker/20:1H-k
 2793 root       0 -20       0      0      0 I  18.3  0.0   0:15.64
kworker/21:1H-k
 1424 root       0 -20       0      0      0 I  17.3  0.0   0:14.99
kworker/22:1H-k
 2626 root       0 -20       0      0      0 I  16.9  0.0   0:14.68
kworker/26:1H-k
 2794 root       0 -20       0      0      0 I  16.9  0.0   0:14.87
kworker/23:1H-k
 2795 root       0 -20       0      0      0 I  16.9  0.0   0:14.81
kworker/24:1H-k
 2797 root       0 -20       0      0      0 I  16.9  0.0   0:14.62
kworker/27:1H-k
 1415 root       0 -20       0      0      0 I  16.6  0.0   0:14.44
kworker/30:1H-k
 2669 root       0 -20       0      0      0 I  16.6  0.0   0:14.38
kworker/31:1H-k
 2796 root       0 -20       0      0      0 I  16.6  0.0   0:14.74
kworker/25:1H-k
 2799 root       0 -20       0      0      0 I  16.6  0.0   0:14.56
kworker/28:1H-k
 1425 root       0 -20       0      0      0 I  16.3  0.0   0:14.21
kworker/34:1H-k
 2746 root       0 -20       0      0      0 I  16.3  0.0   0:14.33
kworker/32:1H-k
 2798 root       0 -20       0      0      0 I  16.3  0.0   0:14.50
kworker/29:1H-k
 2800 root       0 -20       0      0      0 I  16.3  0.0   0:14.27
kworker/33:1H-k
 1423 root       0 -20       0      0      0 I  15.9  0.0   0:14.10
kworker/54:1H-k
 1784 root       0 -20       0      0      0 I  15.9  0.0   0:14.03
kworker/55:1H-k
 2801 root       0 -20       0      0      0 I  15.9  0.0   0:14.15
kworker/35:1H-k
 2815 root       0 -20       0      0      0 I  15.9  0.0   0:13.97
kworker/56:1H-k
 1484 root       0 -20       0      0      0 I  15.6  0.0   0:13.90
kworker/57:1H-k
 1485 root       0 -20       0      0      0 I  15.6  0.0   0:13.82
kworker/59:1H-k
 1519 root       0 -20       0      0      0 I  15.6  0.0   0:13.64
kworker/62:1H-k
 2315 root       0 -20       0      0      0 I  15.6  0.0   0:13.87
kworker/58:1H-k
 2627 root       0 -20       0      0      0 I  15.6  0.0   0:13.69
kworker/61:1H-k
 2816 root       0 -20       0      0      0 I  15.6  0.0   0:13.75
kworker/60:1H-k


I root cause this issue -

Block layer always queue IO on hctx context mapped to CPU-13, but hw queue
run from all the hctx context.
I noticed in my test hctx48 has queued all the IOs. No other hctx has queued
IO. But all the hctx is counting for "run".

# cat hctx48/queued
2087058

#cat hctx*/run
151318
30038
83110
50680
69907
60391
111239
18036
33935
91648
34582
22853
61286
19489

Below patch has fix - "Run the hctx queue for which request was completed
instead of running all the hardware queue."
If this looks valid fix, please include in V8 OR I can post separate patch
for this. Just want to have some level of review from this discussion.

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0652acd..f52118f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -554,6 +554,7 @@ static bool scsi_end_request(struct request *req,
blk_status_t error,
        struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
        struct scsi_device *sdev = cmd->device;
        struct request_queue *q = sdev->request_queue;
+       struct blk_mq_hw_ctx *mq_hctx = req->mq_hctx;

        if (blk_update_request(req, error, bytes))
                return true;
@@ -595,7 +596,8 @@ static bool scsi_end_request(struct request *req,
blk_status_t error,
            !list_empty(&sdev->host->starved_list))
                kblockd_schedule_work(&sdev->requeue_work);
        else
-               blk_mq_run_hw_queues(q, true);
+               blk_mq_run_hw_queue(mq_hctx, true);
+               //blk_mq_run_hw_queues(q, true);

        percpu_ref_put(&q->q_usage_counter);
        return false;


After above patch - Only kworker/13 is actively doing submission.

3858 root       0 -20       0      0      0 I  22.9  0.0   3:24.04
kworker/13:1H-k
16768 root      20   0  712008  14968   2180 R  21.6  0.0   0:03.27 fio
16769 root      20   0  712012  14968   2180 R  21.6  0.0   0:03.27 fio

Without above patch - 24 SSD driver can give 1.5M IOPS and after above patch
3.2M IOPS.

I will continue my testing.

Thanks, Kashyap

> >>
> >> A copy of the patches can be found here:
> >> https://github.com/hisilicon/kernel-dev/commits/private-topic-blk-mq-
> >> shared-tags-rfc-v7
> >>
> >> And to progress this series, we the the following to go in first, when
> >> ready:
> >> https://lore.kernel.org/linux-scsi/20200430131904.5847-1-hare@suse.de
> >> /
> > I'd suggest to add options to enable shared tags for null_blk &
> > scsi_debug in V8, so that it is easier to verify the changes without
> > real
> hardware.
> >
>
> ok, fine, I can look at including that. To stop the series getting too
> large, I
> might spin off the early patches, which are not strictly related.
>
> Thanks,
> John
