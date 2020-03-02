Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AA3EC3F2D1
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 18:38:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D2972166E
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 18:38:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="XGROOcOZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbgCBSiM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 13:38:12 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:36568 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727234AbgCBSiM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Mar 2020 13:38:12 -0500
Received: by mail-ot1-f67.google.com with SMTP id j14so284392otq.3
        for <linux-scsi@vger.kernel.org>; Mon, 02 Mar 2020 10:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JF728VY/9odZQchiuYIX1SMEWalj7zW3r00nUkKmHSw=;
        b=XGROOcOZ9XsqKG1V2Yez15bWlmur2cYxHK7rHzjvgs9qfUxtpUfTP3wQXD4AtG7ZzS
         i2UPTXxVmLpdEQ674iVeu8E4IkZ9BMbGBluhU0gbmz6a1jOEcnk8TLCqmhvM8+OE0mkA
         Mzce1UZCX+deZeseHodZfrV7qFLpTkg5t5LIY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JF728VY/9odZQchiuYIX1SMEWalj7zW3r00nUkKmHSw=;
        b=nZ7oGRaQ6VoJ2PYnwmx0TPIlOqhYzZhHJFpKW6qgxQOuUVa+GYHeLiNJPbfhuAYOMY
         q4wR/dEjt0gyu4KL94w1h/YwGEWYnJ5+Kec+GRRnC3T88lF0NSg5Y0KOU+itGAm6viom
         1m6FctexIXvCL5WXwttp72Vxq0triws41EQPACy5+JuOwBO/w/S3lJKHGYAV1GiUHZtE
         M84+JsEUBIdpstJBrjBarmHENHTzCecvE2e5d5AqsPPExHucnyClP3hsLQA3mmFN4dib
         tTMeDiPkcmmJAZrMH5AMZD+Exlar3885/AVj345RueEc0jYt0MGmFKJUVUBUeVjdPPEb
         nhlQ==
X-Gm-Message-State: ANhLgQ1BtGCMzre5zD6XeOZ7vayGK0oVfrdwpxY4EXzDVW6IbmK7NEXX
        u4Byetq1pFkoUlH3mm7RU+JaCLaCznjFyZ/O0EzYsQ==
X-Google-Smtp-Source: ADFU+vuqLF6f4Ceh0bDNWjqootX8EJdKoXmZncw5SuLMaYVMOaJ7jRFs7Lzz2PAlOkRS5DiJ2pXjj8BERECt2JXhKfw=
X-Received: by 2002:a9d:6446:: with SMTP id m6mr416114otl.122.1583174291488;
 Mon, 02 Mar 2020 10:38:11 -0800 (PST)
MIME-Version: 1.0
References: <1579000882-20246-1-git-send-email-anand.lodnoor@broadcom.com>
 <1579000882-20246-11-git-send-email-anand.lodnoor@broadcom.com>
 <7ca1562c-7a7a-17c5-2429-9725d465a4a8@suse.de> <b5ab348d98b790578325140226f741c8@mail.gmail.com>
 <d7119a15-8be8-9fb2-3c50-8b0a6605982d@huawei.com> <CAAO+jF-P3MkB2mo6pmYH1ihjRGpfjkkgXZg9dAZ29nYmU6T2=A@mail.gmail.com>
 <93deab34-53a3-afcf-4862-6b168a9f60cc@huawei.com> <79fe7843-9d71-bdde-957c-32dde22437d9@suse.de>
 <5ac6fd4f-eef8-700b-89d2-c8b3cd6e12ca@huawei.com>
In-Reply-To: <5ac6fd4f-eef8-700b-89d2-c8b3cd6e12ca@huawei.com>
From:   Sumit Saxena <sumit.saxena@broadcom.com>
Date:   Tue, 3 Mar 2020 00:07:44 +0530
Message-ID: <CAL2rwxqfo1_Wnea=4xb1K+OQTQ4aMd0GjOQG9tkc+E7V-5toqw@mail.gmail.com>
Subject: Re: [PATCH v2 10/11] megaraid_sas: Use Block layer API to check SCSI
 device in-flight IO requests
To:     John Garry <john.garry@huawei.com>
Cc:     Hannes Reinecke <hare@suse.de>,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Kiran Kumar Kasturi <kiran-kumar.kasturi@broadcom.com>,
        Sankar Patra <sankar.patra@broadcom.com>,
        Sasikumar PC <sasikumar.pc@broadcom.com>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 2, 2020 at 3:21 PM John Garry <john.garry@huawei.com> wrote:
>
>
> >> static inline void
> >> megasas_get_msix_index(struct megasas_instance *instance,
> >>                 struct scsi_cmnd *scmd,
> >>                 struct megasas_cmd_fusion *cmd,
> >>                 u8 data_arms)
> >> {
> >> ...
> >>
> >> sdev_busy = atomic_read(&hctx->nr_active);
> >>
> >> if (instance->perf_mode == MR_BALANCED_PERF_MODE &&
> >>      sdev_busy > (data_arms * MR_DEVICE_HIGH_IOPS_DEPTH))
> >>      cmd->request_desc->SCSIIO.MSIxIndex =
> >>              mega_mod64(...),
> >>      else if (instance->msix_load_balance)
> >>          cmd->request_desc->SCSIIO.MSIxIndex =
> >>              (mega_mod64(...),
> >>                  instance->msix_vectors));
> >>
> >> Will this make a difference? I am not sure. Maybe, on this basis,
> >> magaraid sas is not a good candidate to change to expose multiple queues.
> >>
> >> Ignoring that for a moment, since we no longer keep a host busy count,
> >> and I figure that we don't want to back to using
> >> scsi_device.device_busy, is the judgement of hctx->nr_active ok to use
> >> to decide whether to use these performance queues?
> >>
> > Personally, I wonder if the current implementation of high-IOPs queues
> > makes sense with multiqueue. > Thing is, the current high-IOPs queue mechanism of shifting I/O to
> > another internal queue doesn't align nicely with the blk-mq architecture.
>
> Right, we should not be hiding HW queues from blk-mq like this. This
> breaks the symmetry. Maybe we can move this functionality to blk-mq, but
> I doubt that this is a common use case.
We added this concept of extra queues for megraid_sas latest gen of controllers
for performance reasons. Here is some background-
https://lore.kernel.org/lkml/20180829084618.GA24765@ming.t460p/t/
We worked with the community to have such interface for managed(for
low latency queues) and non-managed(High IOPs queues)
interrupts co-existence.

>
> > What we _do_ have, though, is a 'poll' queue mechanism, allowing to
> > separate out one (or several) queues for polling, to allow for ..
> > indeed, high-IOPs.
>
> Any examples or references for this?
>
> > So it would be interesting to figure out if we don't get similar
> > performance by using the 'poll' queue implementation from blk-mq instead
> > of the current one.
>
> I thought that this driver/or mpt3sas already used a polling mode.
>
> And for these low-latency queues, I figure that the issue is not just
> polling vs interrupt, but indeed how fast the HW queue can consume SQEs.
> A HW queue may only be able to consume at a limited rate - that's why we
> segregate.
Yes, there is no polling in any of HW queues. High IOPs queues have
interrupt coalescing enabled whereas
low latency queues does not have interrupt coalescing. megaraid_sas
driver would choose which set of queues
among these two has to be used depending on workload. For latency
oriented workload, driver would use low
latency queues and for IOPs profile, driver would use High IOPs queues.
>
> As an aside, that is actually an issue for blk-mq. For 1 to many HW
> queue-to-CPU mapping, limiting many CPUs a single queue can limit IOPs
> since HW queues can only consume at a limited rate.
We were able to achieve performance target for MegaRAID latest gen
controller with this model of few set
 of HW queues mapped to local numa CPUs and low latency queues has one
to one mapping to CPUs.
This is default behavior of queues segregation in megaraid_sas driver
to satisfy our IOPs and latency requirements altogether.
However we have given module parameter- "perf_mode" to tune queues
behavior. i.e turning on/off interrupt
coalescing on all HW queues where this one to many queues to CPU
mapping would not happen.

Thanks,
Sumit
>
> >
> > Which would also have the benefit that we could support the io_uring
> > interface natively with megaraid_sas, which I think would be a benefit
> > on its own.
> >
>
> thanks,
> John
>
