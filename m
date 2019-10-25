Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 060ABCA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 21:53:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C723221D7F
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 21:53:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L/7Yk0g0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbfJYVxe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Oct 2019 17:53:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56916 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725801AbfJYVxe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Oct 2019 17:53:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572040412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R13Aq5mQXw58N3D4vW3pjtHSPs/znsITAphFQIKYKss=;
        b=L/7Yk0g0pU2BzzZ/1Gvt/3lb+0OJ24bvb8moggTiSs6wkQ2TgyUcxdQhfNX/YQnm1S7sMa
        lRhTMVvsr7TPteQAjh8AnnDDTNjImQbQ+TlNiLBm4G1qkeFIxDRIVuXpXePj3YO2ynckAj
        KAUEjbw4HjrGogdDEEE7PzspQFrk5/w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-gPXb_qexMJOjJzbQ5YUE2w-1; Fri, 25 Oct 2019 17:53:29 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 942451800DCB;
        Fri, 25 Oct 2019 21:53:27 +0000 (UTC)
Received: from ming.t460p (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 170D060C05;
        Fri, 25 Oct 2019 21:53:15 +0000 (UTC)
Date:   Sat, 26 Oct 2019 05:53:11 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Laurence Oberman <loberman@redhat.com>,
        Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [PATCH V4 1/2] scsi: core: avoid host-wide host_busy counter for
 scsi_mq
Message-ID: <20191025215311.GA7076@ming.t460p>
References: <20191009093241.21481-1-ming.lei@redhat.com>
 <20191009093241.21481-2-ming.lei@redhat.com>
 <7d95de12-6114-c0d7-8b21-d36b2ea020fc@huawei.com>
 <20191024005828.GB15426@ming.t460p>
 <19e73b4d-77c7-e776-fee4-8b9f078c2be5@huawei.com>
 <20191024212427.GA26168@ming.t460p>
 <fb0d3475-b9b9-bac2-ec44-5c4cff67a104@huawei.com>
 <20191025094315.GA6128@ming.t460p>
 <36eb068c-37ed-756f-17ef-113aa55a17d0@huawei.com>
MIME-Version: 1.0
In-Reply-To: <36eb068c-37ed-756f-17ef-113aa55a17d0@huawei.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: gPXb_qexMJOjJzbQ5YUE2w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 25, 2019 at 11:13:12AM +0100, John Garry wrote:
> On 25/10/2019 10:43, Ming Lei wrote:
> > On Fri, Oct 25, 2019 at 09:58:16AM +0100, John Garry wrote:
> > >=20
> > > > > In scsi_host.h, we have for scsi_host_template.can_queue: "It is =
set to the
> > > > > maximum number of simultaneous commands a given host adapter will=
 accept.",
> > > > > so that should be honoured.
> > > >=20
> > >=20
> > > Hi Ming,
> > >=20
> > > > That words should have been changed to:
> > > >=20
> > > > "It is set to the maximum number of simultaneous commands a given h=
ost adapter's
> > > > hw queue will accept."
> > >=20
>=20
> Hi Ming,
>=20
> > > I find this definition misleading. As you know, some MQ SAS HBAs can =
accept
> > > .can_queue commands on a given hw queue, but can still only accept
> > > .can_queue commands over all hw queues.
> >=20
> > I don't know there are such MQ HBA driver in tree,
>=20
> HiSilicon SAS HBA can accept 4096 commands on any given hw queue but can
> also only accept 4096 commands over all queues simultaneously.  In fact, =
the
> hw queue depth is configurable.
>=20
> That's why I think that the definition is misleading.

That is why we call HiSilicon SAS is SQ device, still from
blk-mq/scsi-mq viewpoint, :-)

>=20
> I think I sound like a broken record now :)
>=20
> at least that is the
> > current blk-mq/scsi-mq model: each hw queue has its own independent
> > tags, so there can't be the limit for MQ HBA, which should allow to
> > accept (.can_queue * nr_hw_queues) commands. And I did hear people
> > complains bad performance caused by the atomic .host_busy counter.
> >=20
>=20
> ok, seems reasonable for now.
>=20
> > If you are talking about the current SQ(from blk-mq or scsi-mq viewpoin=
t) HBA
> > which has multiple reply queue(HPSA, hisilicon SAS, mpt3sas, and megara=
id_sas),
> > they are just the special type. According to scsi-mq's model, they shou=
ld
> > belong to SQ HBA.
> >=20
> > >=20
> > > >=20
> > > > >=20
> > > > > And Scsi_host.nr_hw_queues: "it is assumed that each hardware que=
ue has a
> > > > > queue depth of can_queue. In other words, the total queue depth p=
er host is
> > > > > nr_hw_queues * can_queue."
> > > >=20
> > > > The above is correct.
> > > >=20
> > > > >=20
> > > > > I don't read "total queue depth per host" same as "maximum number=
 of
> > > > > simultaneous commands a given host adapter will accept". If anyth=
ing, the
> > > > > nr_hw_queues comment is ambiguous.
> > > > >=20
> > > > > >=20
> > > > > > The point is simple, because each hw queue has its own independ=
ent tags,
> > > > > > that is why I mentioned your Hisilicon SAS can't be converted t=
o MQ
> > > > > > easily cause this hardware has only single shared tags.
> > > > >=20
> > > > > Please be aware that HiSilicon SAS HW would not be unique for SCS=
I HBAs in
> > > > > this regard, in that the unique hostwide tag is not just for HBA =
HW IO
> > > > > management, but also is used as the tag for SCSI TMFs.
> > > >=20
> > > > Right.
> > > >=20
> > > > >=20
> > > > > Just checking mpt3sas seems similar:
> > > > >=20
> > > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.gi=
t/tree/drivers/scsi/mpt3sas/mpt3sas_scsih.c#n2918
> > > > >=20
> > > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.gi=
t/tree/drivers/scsi/mpt3sas/mpt3sas_base.c#n3546
> > > >=20
> > > > Not only mpt3sas, there are also HPSA and more. And these drivers h=
ave to
> > > > support single hw queue of blk-mq, instead of real MQ. And the reas=
on is that
> > > > these HBA has single tags.
> > >=20
> > > We should be able to do better than that.
> > >=20
> > > For a start, at least doesn't the check you remove in scsi_host_is_bu=
sy()
> > > limit commands the HBA accepts to .can_queue?
> >=20
> > As I mentioned above, that is current blk-mq/scsi-mq's model, each hw
> > queue has its own independent tags, so the check really doesn't make
> > sense. >
> > >=20
> > > And if you make the change in this patch, then the changes to improve=
 blk-mq
> > > for CPU hotplug are pointless, as we can't change the SAS HBAs to exp=
ose
> > > multiple queues.
> >=20
> > No, just the small number of special type SCSI HBAs with multiple reply=
 queue
> > and single tags can't benefit from the patchset of 'improve blk-mq for =
CPU hotplug',
> > and all other normal MQ device/drivers do get improved wrt. CPU hotplug=
.
> >=20
>=20
> TBH, I'm not sure on the group of SCSI drivers which could benefit then.
>=20
> As I see, only qla2xxx driver sets Scsi_host.nr_hw_queues and also uses
> pci_alloc_irq_vectors_affinity().

Other non-SCSI drivers can benefit from that patchset too, such as NVMe.

Except for qla2xxx, there are also lpfc, virtio-scsi and smartpqi, and
there will be more since I heard that new version of one other popular
SCSI HBA will support real MQ.

>=20
> > We have tried hosttags approach for the several drivers, but looks it i=
s
> > too messy. Given there are only 3 or 4 such device, we still can improv=
e
> > them via driver private approach in future if no generic way is doable.
>=20
> ok, I'd rather not go on this path - you may say I'm digging my head in t=
he
> sand. Anyway, I'll continue to support the 'improve blk-mq for CPU hotplu=
g'
> effort.

I meant that way is the last straw, :-)


Thanks,
Ming

