Return-Path: <SRS0=hRFu=4U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6010EC3F2C6
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Mar 2020 17:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3672720842
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Mar 2020 17:04:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="VF+ShkYj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730436AbgCCREk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Mar 2020 12:04:40 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:46166 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729000AbgCCREk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Mar 2020 12:04:40 -0500
Received: by mail-oi1-f194.google.com with SMTP id a22so3689247oid.13
        for <linux-scsi@vger.kernel.org>; Tue, 03 Mar 2020 09:04:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nDi7A+gkYL7OoFq32eYl6bafxazQzCG7Rv7c8V0YjuI=;
        b=VF+ShkYj2EVYnWWrU2Eai/I96nziUKshOIPoV+t8bOtixtbmegmb5ysn7/YYEbZOjB
         VGjHIOiK8TlAXnvzYh5ACWkVLlF/XXRfnJzg7bLs1YPBiMEJYT036CgAp1rzwlMPplML
         ztFi/G1Y2AVfevnXsCtCQvtPTZ2+RwHktG8rY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nDi7A+gkYL7OoFq32eYl6bafxazQzCG7Rv7c8V0YjuI=;
        b=NmxrO9KunF94cO6KCijfLiBcoHLV686EbkbLZ0fhf5gdIkTdwh7wz8vCplxASKxGdT
         Ptp+yrvPb/BLQNDLmcZ0lVt5WUbcLXp53FtPha7gCwoLhi1JACiBO1ERcrp4vrxV2I8o
         pPYlIV7J+Oc03RtKWi4i9O6+AWfy+co0LRuwIL/jQKe3DisckFKwJI/zDi8F1zIjIyic
         W/rP8fW7xDW5yef7B5ePQgx8xsEUG8uouYPivT043bMW5o7SbR8RzdJPq6dI07z6dPV9
         jzU6U0l0LSJYPFY0gRG3e8QNKGz8oNvLHgfiNC7gmfXTqY6Haq/DPwKNGAz3TvXexDVp
         /6Ag==
X-Gm-Message-State: ANhLgQ1g/1+4WKkyajD3fVoDQd1Z3Qjc1bvJ1uuX2gerie6HIFahq3zw
        QsN/vkI9xEl1lwkhVxHeBhTFYJISrQGR7ipghL9Jpg==
X-Google-Smtp-Source: ADFU+vvhoG4SzGAyv2ocipIApdBPfttPa6O32dOwPdgnCLSk5xAuAf2x4SNeFH7c5TC3fCZp22fKU+jSmuD/gPOrwdk=
X-Received: by 2002:aca:4c02:: with SMTP id z2mr3189379oia.9.1583255079634;
 Tue, 03 Mar 2020 09:04:39 -0800 (PST)
MIME-Version: 1.0
References: <1579000882-20246-1-git-send-email-anand.lodnoor@broadcom.com>
 <1579000882-20246-11-git-send-email-anand.lodnoor@broadcom.com>
 <7ca1562c-7a7a-17c5-2429-9725d465a4a8@suse.de> <b5ab348d98b790578325140226f741c8@mail.gmail.com>
 <d7119a15-8be8-9fb2-3c50-8b0a6605982d@huawei.com> <CAAO+jF-P3MkB2mo6pmYH1ihjRGpfjkkgXZg9dAZ29nYmU6T2=A@mail.gmail.com>
 <93deab34-53a3-afcf-4862-6b168a9f60cc@huawei.com> <79fe7843-9d71-bdde-957c-32dde22437d9@suse.de>
 <5ac6fd4f-eef8-700b-89d2-c8b3cd6e12ca@huawei.com> <CAL2rwxqfo1_Wnea=4xb1K+OQTQ4aMd0GjOQG9tkc+E7V-5toqw@mail.gmail.com>
 <aa0d2c4c-b54b-8d68-1a18-d7449f46962b@huawei.com>
In-Reply-To: <aa0d2c4c-b54b-8d68-1a18-d7449f46962b@huawei.com>
From:   Sumit Saxena <sumit.saxena@broadcom.com>
Date:   Tue, 3 Mar 2020 22:34:12 +0530
Message-ID: <CAL2rwxrS8Ebud0ZYwC6vcGi0Pv-PA12s-mHdJfkGaEmkqRDVDA@mail.gmail.com>
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

On Tue, Mar 3, 2020 at 5:23 PM John Garry <john.garry@huawei.com> wrote:
>
> >> And for these low-latency queues, I figure that the issue is not just
> >> polling vs interrupt, but indeed how fast the HW queue can consume SQEs.
> >> A HW queue may only be able to consume at a limited rate - that's why we
> >> segregate.
> > Yes, there is no polling in any of HW queues. High IOPs queues have
> > interrupt coalescing enabled whereas
> > low latency queues does not have interrupt coalescing. megaraid_sas
> > driver would choose which set of queues
> > among these two has to be used depending on workload. For latency
> > oriented workload, driver would use low
> > latency queues and for IOPs profile, driver would use High IOPs queues.
> >>
> >> As an aside, that is actually an issue for blk-mq. For 1 to many HW
> >> queue-to-CPU mapping, limiting many CPUs a single queue can limit IOPs
> >> since HW queues can only consume at a limited rate.
> > We were able to achieve performance target for MegaRAID latest gen
> > controller with this model of few set
> >   of HW queues mapped to local numa CPUs and low latency queues has one
> > to one mapping to CPUs.
> > This is default behavior of queues segregation in megaraid_sas driver
> > to satisfy our IOPs and latency requirements altogether.
> > However we have given module parameter- "perf_mode" to tune queues
> > behavior. i.e turning on/off interrupt
> > coalescing on all HW queues where this one to many queues to CPU
> > mapping would not happen.
>
> Hi Sumit,
Hi John,
>
> OK, I have a rough idea of the concept. And again I'd say megaraid sas
> may not be a good candidate to expose > 1 HW queues, as we hide HW
> queues and don't maintain the symmetry with blk-mq layer.
Sorry, my last response was not very clear. I was referring to reply
queues as HW queues
not submission queues. I agree with you, since megaraid_sas HW has
single submission
queue so >1 HW queue would not help to improve performance. Testing
done by us on shared
tagset patches worked by you/Hannes was to ensure no performance drop
from single HW
submission queue based driver.
>
> Indeed, I do not even expect a performance increase in exposing > 1 HW
> queues since the driver already uses the reply map + managed interrupts.
>
> The main reason for that change in some drivers - apart from losing the
> duplicated ugliness of the reply map - is to leverage the blk-mq feature
> to drain a hctx for CPU hotplug [0] - is this something which megaraid
> sas is vulnerable to and would benefit from?
"megaraid_sas" driver would be benefited with draining of IO
completions directed to
hotplugged(offlined) CPU. With current driver IO completion would
hang, if CPU on which IO is to be
completed goes offline.

Thanks,
Sumit
>
> Thanks,
> John
>
> [0]
> https://lore.kernel.org/linux-block/20200115114409.28895-1-ming.lei@redhat.com/
