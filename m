From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [PATCH 00/10] mpt3sas: full mq support
Date: Tue, 31 Jan 2017 23:24:37 +0530
Message-ID: <e8d8dbf8dc2fa11b85a90211f2298b20@mail.gmail.com>
References: <1485854760-122683-1-git-send-email-hare@suse.de>
 <20170131100243.GA1811@lst.de> <9a9d5acd-5f51-ad5b-7364-1d7549c040fd@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:34500 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751017AbdAaSBz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jan 2017 13:01:55 -0500
Received: by mail-qk0-f174.google.com with SMTP id l126so39816270qkc.1
        for <linux-scsi@vger.kernel.org>; Tue, 31 Jan 2017 10:01:54 -0800 (PST)
In-Reply-To: <9a9d5acd-5f51-ad5b-7364-1d7549c040fd@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Tuesday, January 31, 2017 4:47 PM
> To: Christoph Hellwig
> Cc: Martin K. Petersen; James Bottomley; linux-scsi@vger.kernel.org;
Sathya
> Prakash; Kashyap Desai; mpt-fusionlinux.pdl@broadcom.com
> Subject: Re: [PATCH 00/10] mpt3sas: full mq support
>
> On 01/31/2017 11:02 AM, Christoph Hellwig wrote:
> > On Tue, Jan 31, 2017 at 10:25:50AM +0100, Hannes Reinecke wrote:
> >> Hi all,
> >>
> >> this is a patchset to enable full multiqueue support for the mpt3sas
> driver.
> >> While the HBA only has a single mailbox register for submitting
> >> commands, it does have individual receive queues per MSI-X interrupt
> >> and as such does benefit from converting it to full multiqueue
support.
> >
> > Explanation and numbers on why this would be beneficial, please.
> > We should not need multiple submissions queues for a single register
> > to benefit from multiple completion queues.
> >
> Well, the actual throughput very strongly depends on the blk-mq-sched
> patches from Jens.
> As this is barely finished I didn't post any numbers yet.
>
> However:
> With multiqueue support:
> 4k seq read : io=3D60573MB, bw=3D1009.2MB/s, iops=3D258353, runt=3D 60021=
msec
> With scsi-mq on 1 queue:
> 4k seq read : io=3D17369MB, bw=3D296291KB/s, iops=3D74072, runt=3D 60028m=
sec So
> yes, there _is_ a benefit.
>
> (Which is actually quite cool, as these tests were done on a SAS3 HBA,
so
> we're getting close to the theoretical maximum of 1.2GB/s).
> (Unlike the single-queue case :-)

Hannes -

Can you share detail about setup ? How many drives do you have and how is
connection (enclosure -> drives. ??) ?
To me it looks like current mpt3sas driver might be taking more hit in
spinlock operation (penalty on NUMA arch is more compare to single core
server) unlike we have in megaraid_sas driver use of shared blk tag.

I mean " [PATCH 08/10] mpt3sas: lockless command submission for scsi-mq"
patch is improving performance removing spinlock overhead and attempting
to get request using blk_tags.
Are you seeing performance improvement  if you hard code nr_hw_queues =3D 1
in below code changes part of "[PATCH 10/10] mpt3sas: scsi-mq interrupt
steering"

@@ -9054,6 +9071,8 @@ static void sas_device_make_active(struct
MPT3SAS_ADAPTER *ioc,
 	shost->max_lun =3D max_lun;
 	shost->transportt =3D mpt3sas_transport_template;
 	shost->unique_id =3D ioc->id;
+	if (shost->use_blk_mq)
+		shost->nr_hw_queues =3D num_online_cpus();


Thanks, Kashyap

>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke		   Teamlead Storage & Networking
> hare@suse.de			               +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton HRB
21284
> (AG N=C3=BCrnberg)
