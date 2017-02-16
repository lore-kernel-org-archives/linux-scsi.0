From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [PATCH 00/10] mpt3sas: full mq support
Date: Thu, 16 Feb 2017 15:18:11 +0530
Message-ID: <3d257aa567a9a3e0081ca342aaf7c354@mail.gmail.com>
References: <1485854760-122683-1-git-send-email-hare@suse.de>
 <20170131100243.GA1811@lst.de> <9a9d5acd-5f51-ad5b-7364-1d7549c040fd@suse.de>
 <e8d8dbf8dc2fa11b85a90211f2298b20@mail.gmail.com> <255dbb75-9ebd-0c7b-486e-e6fec772b8ca@suse.de>
 <41a4fdd78121e86e13dc874127b0b956@mail.gmail.com> <3e50cfdc-c330-4241-5ac3-a8f2ef5f77b4@suse.de>
 <CAK=zhgqjmpOS7M3WOsC+yUMRiw+y6H0sP2Hca9tuCyM19sAR8Q@mail.gmail.com>
 <1d7e8757-4b25-3f09-77ec-a286e83d3d73@suse.de> <CAK=zhgqBH3YJTo-PJF5nN9futQ-LWjVzAUji9xC_rWO5EA=_+g@mail.gmail.com>
 <4747beb1-0c16-171d-ab39-2e1a4692ba19@suse.de> <CAK=zhgqQ2x5d9Mzo89V95WS8SB0Xqyw4YtL4=cAr_PEv6GS1gQ@mail.gmail.com>
 <2770c802-b8b2-9035-c760-c5b970a9bd99@suse.de> <CAK=zhgqiCh+5tD+kHD15Xef5MnJM0SG=LaP=+cM-40VtMSH7Ew@mail.gmail.com>
 <01e426acae471cf8e599a5100bc8d409@mail.gmail.com> <e34535df-ab24-bf52-579f-faeca8c9c9d4@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:33009 "EHLO
        mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753747AbdBPJsO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Feb 2017 04:48:14 -0500
Received: by mail-qt0-f178.google.com with SMTP id v23so9582375qtb.0
        for <linux-scsi@vger.kernel.org>; Thu, 16 Feb 2017 01:48:13 -0800 (PST)
In-Reply-To: <e34535df-ab24-bf52-579f-faeca8c9c9d4@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Wednesday, February 15, 2017 3:35 PM
> To: Kashyap Desai; Sreekanth Reddy
> Cc: Christoph Hellwig; Martin K. Petersen; James Bottomley; linux-
> scsi@vger.kernel.org; Sathya Prakash Veerichetty; PDL-MPT-FUSIONLINUX
> Subject: Re: [PATCH 00/10] mpt3sas: full mq support
>
> On 02/15/2017 10:18 AM, Kashyap Desai wrote:
> >>
> >>
> >> Hannes,
> >>
> >> Result I have posted last time is with merge operation enabled in
> >> block layer. If I disable merge operation then I don't see much
> >> improvement with multiple hw request queues. Here is the result,
> >>
> >> fio results when nr_hw_queues=3D1,
> >> 4k read when numjobs=3D24: io=3D248387MB, bw=3D1655.1MB/s, iops=3D4239=
05,
> >> runt=3D150003msec
> >>
> >> fio results when nr_hw_queues=3D24,
> >> 4k read when numjobs=3D24: io=3D263904MB, bw=3D1759.4MB/s, iops=3D4503=
93,
> >> runt=3D150001msec
> >
> > Hannes -
> >
> >  I worked with Sreekanth and also understand pros/cons of Patch #10.
> > " [PATCH 10/10] mpt3sas: scsi-mq interrupt steering"
> >
> > In above patch, can_queue of HBA is divided based on logic CPU, it
> > means we want to mimic as if mpt3sas HBA support multi queue
> > distributing actual resources which is single Submission H/W Queue.
> > This approach badly impact many performance areas.
> >
> > nr_hw_queues =3D 1 is what I observe as best performance approach since
> > it never throttle IO if sdev->queue_depth is set to HBA queue depth.
> > In case of nr_hw_queues =3D "CPUs" throttle IO at SCSI level since we
> > never allow more than "updated can_queue" in LLD.
> >
> True.
> And this was actually one of the things I wanted to demonstrate with this
> patchset :-) ATM blk-mq really works best when having a distinct tag spac=
e
> per port/device. As soon as the hardware provides a _shared_ tag space yo=
u
> end up with tag starvation issues as blk-mq only allows you to do a stati=
c
> split of the available tagspace.
> While this patchset demonstrates that the HBA itself _does_ benefit from
> using block-mq (especially on highly parallel loads), it also demonstrate=
s
> that
> _block-mq_ has issues with singlethreaded loads on this HBA (or, rather,
> type of HBA, as I doubt this issue is affecting mpt3sas only).
>
> > Below code bring actual HBA can_queue very low ( Ea on 96 logical core
> > CPU new can_queue goes to 42, if HBA queue depth is 4K). It means we
> > will see lots of IO throttling in scsi mid layer due to
> > shost->can_queue reach the limit very soon if you have <fio> jobs with
> higher QD.
> >
> > 	if (ioc->shost->nr_hw_queues > 1) {
> > 		ioc->shost->nr_hw_queues =3D ioc->msix_vector_count;
> > 		ioc->shost->can_queue /=3D ioc->msix_vector_count;
> > 	}
> > I observe negative performance if I have 8 SSD drives attached to
> > Ventura (latest IT controller). 16 fio jobs at QD=3D128 gives ~1600K
> > IOPs and the moment I switch to nr_hw_queues =3D "CPUs", it gave hardly
> > ~850K IOPs. This is mainly because of host_busy stuck at very low ~169
> > on
> my setup.
> >
> Which actually might be an issue with the way scsi is hooked into blk-mq.
> The SCSI stack is using 'can_queue' as a check for 'host_busy', ie if the
> host is
> capable of accepting more commands.
> As we're limiting can_queue (to get the per-queue command depth
> correctly) we should be using the _overall_ command depth for the
> can_queue value itself to make the host_busy check work correctly.
>
> I've attached a patch for that; can you test if it makes a difference?
Hannes -
Attached patch works fine for me. FYI -  We need to set device queue depth
to can_queue as we are currently not doing in mpt3sas driver.

With attached patch when I tried, I see ~2-3% improvement running multiple
jobs. Single job profile no difference.

So looks like we are good to reach performance with single nr_hw_queues.

We have some patches to be send so want to know how to rebase this patch
series as few patches coming from Broadcom. Can we consider below as plan ?

- Patches from 1-7 will be reposted. Also Sreekanth will complete review on
existing patch 1-7.
- We need blk_tag support only for nr_hw_queue =3D 1.

With that say, we will have many code changes/function without "
shost_use_blk_mq" check and assume it is single nr_hw_queue supported
<mpt3sas> driver.

Ea - Below function can be simplify - just refer tag from scmd->request and
don't need check of shost_use_blk_mq + nr_hw_queue etc..

u16
mpt3sas_base_get_smid_scsiio(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx,
        struct scsi_cmnd *scmd)
{
        struct scsiio_tracker *request;
        u16 smid =3D scmd->request->tag +  1;
         ...
         return request->smid;
}

- Later we can explore if nr_hw_queue more than one really add benefit.
>From current limited testing, I don't see major performance boost if we hav=
e
nr_hw_queue more than one.

>
> > May be as Sreekanth mentioned, performance improvement you have
> > observed is due to nomerges=3D2 is not set and OS will attempt soft
> back/front merge.
> >
> > I debug live machine and understood we never see parallel instance of
> > "scsi_dispatch_cmd" as we expect due to can_queue is less. If we
> > really has
> > *very* large HBA QD, this patch #10 to expose multiple SQ may be useful=
.
> >
> As mentioned, the above patch might help here.
> The patch actually _reduced_ throughput on my end, as the requests never
> stayed long enough in the queue to be merged. Hence I've refrained from
> posting it.
> But as you're able to test with SSDs this patch really should make a
> difference, and certainly should remove the arbitrary stalls due to
> host_busy.
>
> > For now, we are looking for updated version of patch which will only
> > keep IT HBA in SQ mode (like we are doing in <megaraid_sas> driver)
> > and add interface to use blk_tag in both scsi.mq and !scsi.mq mode.
> > Sreekanth has already started working on it, but we may need to check
> > full performance test run to post the actual patch.
> > May be we can cherry pick few patches from this series and get blk_tag
> > support to improve performance of <mpt3sas> later which will not allow
> > use to choose nr_hw_queue to be tunable.
> >
> Sure, no problem with that.
> I'll be preparing another submission round, and we can discuss how we go
> from there.
>
> Cheers,
>
> Hannes
> > Thanks, Kashyap
> >
> >
> >>
> >> Thanks,
> >> Sreekanth
>
>
> --
> Dr. Hannes Reinecke		   Teamlead Storage & Networking
> hare@suse.de			               +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton HRB=
 21284
> (AG N=C3=BCrnberg)
