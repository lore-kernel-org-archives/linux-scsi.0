From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 00/10] mpt3sas: full mq support
Date: Wed, 15 Feb 2017 11:05:14 +0100
Message-ID: <e34535df-ab24-bf52-579f-faeca8c9c9d4@suse.de>
References: <1485854760-122683-1-git-send-email-hare@suse.de>
 <20170131100243.GA1811@lst.de> <9a9d5acd-5f51-ad5b-7364-1d7549c040fd@suse.de>
 <e8d8dbf8dc2fa11b85a90211f2298b20@mail.gmail.com>
 <255dbb75-9ebd-0c7b-486e-e6fec772b8ca@suse.de>
 <41a4fdd78121e86e13dc874127b0b956@mail.gmail.com>
 <3e50cfdc-c330-4241-5ac3-a8f2ef5f77b4@suse.de>
 <CAK=zhgqjmpOS7M3WOsC+yUMRiw+y6H0sP2Hca9tuCyM19sAR8Q@mail.gmail.com>
 <1d7e8757-4b25-3f09-77ec-a286e83d3d73@suse.de>
 <CAK=zhgqBH3YJTo-PJF5nN9futQ-LWjVzAUji9xC_rWO5EA=_+g@mail.gmail.com>
 <4747beb1-0c16-171d-ab39-2e1a4692ba19@suse.de>
 <CAK=zhgqQ2x5d9Mzo89V95WS8SB0Xqyw4YtL4=cAr_PEv6GS1gQ@mail.gmail.com>
 <2770c802-b8b2-9035-c760-c5b970a9bd99@suse.de>
 <CAK=zhgqiCh+5tD+kHD15Xef5MnJM0SG=LaP=+cM-40VtMSH7Ew@mail.gmail.com>
 <01e426acae471cf8e599a5100bc8d409@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------F9BB7553CDD75A584E6F07D7"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35206 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751421AbdBOKFR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Feb 2017 05:05:17 -0500
In-Reply-To: <01e426acae471cf8e599a5100bc8d409@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>

This is a multi-part message in MIME format.
--------------F9BB7553CDD75A584E6F07D7
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On 02/15/2017 10:18 AM, Kashyap Desai wrote:
>>
>>
>> Hannes,
>>
>> Result I have posted last time is with merge operation enabled in block
>> layer. If I disable merge operation then I don't see much improvement
>> with
>> multiple hw request queues. Here is the result,
>>
>> fio results when nr_hw_queues=1,
>> 4k read when numjobs=24: io=248387MB, bw=1655.1MB/s, iops=423905,
>> runt=150003msec
>>
>> fio results when nr_hw_queues=24,
>> 4k read when numjobs=24: io=263904MB, bw=1759.4MB/s, iops=450393,
>> runt=150001msec
> 
> Hannes -
> 
>  I worked with Sreekanth and also understand pros/cons of Patch #10.
> " [PATCH 10/10] mpt3sas: scsi-mq interrupt steering"
> 
> In above patch, can_queue of HBA is divided based on logic CPU, it means we
> want to mimic as if mpt3sas HBA support multi queue distributing actual
> resources which is single Submission H/W Queue. This approach badly impact
> many performance areas.
> 
> nr_hw_queues = 1 is what I observe as best performance approach since it
> never throttle IO if sdev->queue_depth is set to HBA queue depth.
> In case of nr_hw_queues = "CPUs" throttle IO at SCSI level since we never
> allow more than "updated can_queue" in LLD.
> 
True.
And this was actually one of the things I wanted to demonstrate with
this patchset :-)
ATM blk-mq really works best when having a distinct tag space per
port/device. As soon as the hardware provides a _shared_ tag space you
end up with tag starvation issues as blk-mq only allows you to do a
static split of the available tagspace.
While this patchset demonstrates that the HBA itself _does_ benefit from
using block-mq (especially on highly parallel loads), it also
demonstrates that _block-mq_ has issues with singlethreaded loads on
this HBA (or, rather, type of HBA, as I doubt this issue is affecting
mpt3sas only).

> Below code bring actual HBA can_queue very low ( Ea on 96 logical core CPU
> new can_queue goes to 42, if HBA queue depth is 4K). It means we will see
> lots of IO throttling in scsi mid layer due to shost->can_queue reach the
> limit very soon if you have <fio> jobs with higher QD.
> 
> 	if (ioc->shost->nr_hw_queues > 1) {
> 		ioc->shost->nr_hw_queues = ioc->msix_vector_count;
> 		ioc->shost->can_queue /= ioc->msix_vector_count;
> 	}
> I observe negative performance if I have 8 SSD drives attached to Ventura
> (latest IT controller). 16 fio jobs at QD=128 gives ~1600K IOPs and the
> moment I switch to nr_hw_queues = "CPUs", it gave hardly ~850K IOPs. This is
> mainly because of host_busy stuck at very low ~169 on my setup.
> 
Which actually might be an issue with the way scsi is hooked into blk-mq.
The SCSI stack is using 'can_queue' as a check for 'host_busy', ie if
the host is capable of accepting more commands.
As we're limiting can_queue (to get the per-queue command depth
correctly) we should be using the _overall_ command depth for the
can_queue value itself to make the host_busy check work correctly.

I've attached a patch for that; can you test if it makes a difference?

> May be as Sreekanth mentioned, performance improvement you have observed is
> due to nomerges=2 is not set and OS will attempt soft back/front merge.
> 
> I debug live machine and understood we never see parallel instance of
> "scsi_dispatch_cmd" as we expect due to can_queue is less. If we really has
> *very* large HBA QD, this patch #10 to expose multiple SQ may be useful.
> 
As mentioned, the above patch might help here.
The patch actually _reduced_ throughput on my end, as the requests never
stayed long enough in the queue to be merged. Hence I've refrained from
posting it.
But as you're able to test with SSDs this patch really should make a
difference, and certainly should remove the arbitrary stalls due to
host_busy.

> For now, we are looking for updated version of patch which will only keep IT
> HBA in SQ mode (like we are doing in <megaraid_sas> driver) and add
> interface to use blk_tag in both scsi.mq and !scsi.mq mode.  Sreekanth has
> already started working on it, but we may need to check full performance
> test run to post the actual patch.
> May be we can cherry pick few patches from this series and get blk_tag
> support to improve performance of <mpt3sas> later which will not allow use
> to choose nr_hw_queue to be tunable.
> 
Sure, no problem with that.
I'll be preparing another submission round, and we can discuss how we go
from there.

Cheers,

Hannes
> Thanks, Kashyap
> 
> 
>>
>> Thanks,
>> Sreekanth


-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)

--------------F9BB7553CDD75A584E6F07D7
Content-Type: text/x-patch;
 name="0001-mpt3sas-implement-shared_tags-SCSI-host-flag.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="0001-mpt3sas-implement-shared_tags-SCSI-host-flag.patch"

=46rom df424c8618e0b06ded2d978818e6d3df4a54a61d Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.de>
Date: Wed, 15 Feb 2017 10:58:01 +0100
Subject: [PATCH] mpt3sas: implement 'shared_tags' SCSI host flag

If the HBA implements a host-wide tagspace we should be signalling
this to the SCSI layer to avoid 'can_queue' being reduced, thereby
inducing I/O stalls.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  | 5 ++---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 2 ++
 drivers/scsi/scsi_lib.c              | 2 ++
 include/scsi/scsi_host.h             | 5 +++++
 4 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/m=
pt3sas_base.c
index 9e31cae..520aee4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3544,10 +3544,9 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER =
*ioc,
 	 */
 	ioc->shost->reserved_cmds =3D INTERNAL_SCSIIO_CMDS_COUNT;
 	ioc->shost->can_queue =3D ioc->scsiio_depth - ioc->shost->reserved_cmds=
;
-	if (ioc->shost->nr_hw_queues > 1) {
+	if (ioc->shost->nr_hw_queues > 1)
 		ioc->shost->nr_hw_queues =3D ioc->msix_vector_count;
-		ioc->shost->can_queue /=3D ioc->msix_vector_count;
-	}
+
 	dinitprintk(ioc, pr_info(MPT3SAS_FMT
 		"scsi host: can_queue depth (%d), nr_hw_queues (%d)\n",
 		ioc->name, ioc->shost->can_queue, ioc->shost->nr_hw_queues));
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/=
mpt3sas_scsih.c
index 14f7a9d..4088e1a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -8585,6 +8585,7 @@ static int scsih_map_queues(struct Scsi_Host *shost=
)
 	.shost_attrs			=3D mpt3sas_host_attrs,
 	.sdev_attrs			=3D mpt3sas_dev_attrs,
 	.track_queue_depth		=3D 1,
+	.shared_tags			=3D 1,
 	.cmd_size			=3D sizeof(struct scsiio_tracker),
 };
=20
@@ -8624,6 +8625,7 @@ static int scsih_map_queues(struct Scsi_Host *shost=
)
 	.shost_attrs			=3D mpt3sas_host_attrs,
 	.sdev_attrs			=3D mpt3sas_dev_attrs,
 	.track_queue_depth		=3D 1,
+	.shared_tags			=3D 1,
 	.cmd_size			=3D sizeof(struct scsiio_tracker),
 };
=20
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7100aaa..6bb06ed 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2143,6 +2143,8 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 	shost->tag_set.ops =3D &scsi_mq_ops;
 	shost->tag_set.nr_hw_queues =3D shost->nr_hw_queues ? : 1;
 	shost->tag_set.queue_depth =3D shost->can_queue;
+	if (shost->hostt->shared_tags)
+		shost->tag_set.queue_depth /=3D shost->nr_hw_queues;
 	shost->tag_set.reserved_tags =3D shost->reserved_cmds;
 	shost->tag_set.cmd_size =3D cmd_size;
 	shost->tag_set.numa_node =3D NUMA_NO_NODE;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index cc83dd6..d344803 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -457,6 +457,11 @@ struct scsi_host_template {
 	unsigned no_async_abort:1;
=20
 	/*
+	 * True if the host uses a shared tag space
+	 */
+	unsigned shared_tags:1;
+
+	/*
 	 * Countdown for host blocking with no commands outstanding.
 	 */
 	unsigned int max_host_blocked;
--=20
1.8.5.6


--------------F9BB7553CDD75A584E6F07D7--
