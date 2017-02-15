From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [PATCH 00/10] mpt3sas: full mq support
Date: Wed, 15 Feb 2017 14:48:44 +0530
Message-ID: <01e426acae471cf8e599a5100bc8d409@mail.gmail.com>
References: <1485854760-122683-1-git-send-email-hare@suse.de>
 <20170131100243.GA1811@lst.de> <9a9d5acd-5f51-ad5b-7364-1d7549c040fd@suse.de>
 <e8d8dbf8dc2fa11b85a90211f2298b20@mail.gmail.com> <255dbb75-9ebd-0c7b-486e-e6fec772b8ca@suse.de>
 <41a4fdd78121e86e13dc874127b0b956@mail.gmail.com> <3e50cfdc-c330-4241-5ac3-a8f2ef5f77b4@suse.de>
 <CAK=zhgqjmpOS7M3WOsC+yUMRiw+y6H0sP2Hca9tuCyM19sAR8Q@mail.gmail.com>
 <1d7e8757-4b25-3f09-77ec-a286e83d3d73@suse.de> <CAK=zhgqBH3YJTo-PJF5nN9futQ-LWjVzAUji9xC_rWO5EA=_+g@mail.gmail.com>
 <4747beb1-0c16-171d-ab39-2e1a4692ba19@suse.de> <CAK=zhgqQ2x5d9Mzo89V95WS8SB0Xqyw4YtL4=cAr_PEv6GS1gQ@mail.gmail.com>
 <2770c802-b8b2-9035-c760-c5b970a9bd99@suse.de> <CAK=zhgqiCh+5tD+kHD15Xef5MnJM0SG=LaP=+cM-40VtMSH7Ew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:36826 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750922AbdBOJSr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Feb 2017 04:18:47 -0500
Received: by mail-qt0-f182.google.com with SMTP id k15so132457726qtg.3
        for <linux-scsi@vger.kernel.org>; Wed, 15 Feb 2017 01:18:47 -0800 (PST)
In-Reply-To: <CAK=zhgqiCh+5tD+kHD15Xef5MnJM0SG=LaP=+cM-40VtMSH7Ew@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>

>
>
> Hannes,
>
> Result I have posted last time is with merge operation enabled in block
> layer. If I disable merge operation then I don't see much improvement
> with
> multiple hw request queues. Here is the result,
>
> fio results when nr_hw_queues=1,
> 4k read when numjobs=24: io=248387MB, bw=1655.1MB/s, iops=423905,
> runt=150003msec
>
> fio results when nr_hw_queues=24,
> 4k read when numjobs=24: io=263904MB, bw=1759.4MB/s, iops=450393,
> runt=150001msec

Hannes -

 I worked with Sreekanth and also understand pros/cons of Patch #10.
" [PATCH 10/10] mpt3sas: scsi-mq interrupt steering"

In above patch, can_queue of HBA is divided based on logic CPU, it means we
want to mimic as if mpt3sas HBA support multi queue distributing actual
resources which is single Submission H/W Queue. This approach badly impact
many performance areas.

nr_hw_queues = 1 is what I observe as best performance approach since it
never throttle IO if sdev->queue_depth is set to HBA queue depth.
In case of nr_hw_queues = "CPUs" throttle IO at SCSI level since we never
allow more than "updated can_queue" in LLD.

Below code bring actual HBA can_queue very low ( Ea on 96 logical core CPU
new can_queue goes to 42, if HBA queue depth is 4K). It means we will see
lots of IO throttling in scsi mid layer due to shost->can_queue reach the
limit very soon if you have <fio> jobs with higher QD.

	if (ioc->shost->nr_hw_queues > 1) {
		ioc->shost->nr_hw_queues = ioc->msix_vector_count;
		ioc->shost->can_queue /= ioc->msix_vector_count;
	}
I observe negative performance if I have 8 SSD drives attached to Ventura
(latest IT controller). 16 fio jobs at QD=128 gives ~1600K IOPs and the
moment I switch to nr_hw_queues = "CPUs", it gave hardly ~850K IOPs. This is
mainly because of host_busy stuck at very low ~169 on my setup.

May be as Sreekanth mentioned, performance improvement you have observed is
due to nomerges=2 is not set and OS will attempt soft back/front merge.

I debug live machine and understood we never see parallel instance of
"scsi_dispatch_cmd" as we expect due to can_queue is less. If we really has
*very* large HBA QD, this patch #10 to expose multiple SQ may be useful.

For now, we are looking for updated version of patch which will only keep IT
HBA in SQ mode (like we are doing in <megaraid_sas> driver) and add
interface to use blk_tag in both scsi.mq and !scsi.mq mode.  Sreekanth has
already started working on it, but we may need to check full performance
test run to post the actual patch.
May be we can cherry pick few patches from this series and get blk_tag
support to improve performance of <mpt3sas> later which will not allow use
to choose nr_hw_queue to be tunable.

Thanks, Kashyap


>
> Thanks,
> Sreekanth
