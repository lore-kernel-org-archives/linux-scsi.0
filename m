Return-Path: <SRS0=RMqd=ZO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A48BC432C3
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 22:00:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CB5A2071C
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 22:00:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QwPbMJo3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfKVWAy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Nov 2019 17:00:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36994 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726089AbfKVWAy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Nov 2019 17:00:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574460052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JUdh3+BVNJkD1BNvDteKCIbyDW371v24TssgI9WsSxs=;
        b=QwPbMJo3h5gGX2txSCxML92OUJcH/fWqvShG9S4W7vhJzIu9E8Hls2rhzlTlh9/Af1L+r/
        ZqdFVWB6u2yXLLyRLaopoTSlpyAjCw8uosv40R6NFPUscGXT3dnN5w6zuaZDD6n/9D+5Ab
        JIKqBwXXP8lAkNJJj5IU4M5V9LlYnZk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-lyqP7poSPlqVc5scUM3niw-1; Fri, 22 Nov 2019 17:00:48 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B383CDB20;
        Fri, 22 Nov 2019 22:00:46 +0000 (UTC)
Received: from ming.t460p (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C5FFE10013A7;
        Fri, 22 Nov 2019 22:00:36 +0000 (UTC)
Date:   Sat, 23 Nov 2019 06:00:31 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [PATCH 4/4] scsi: core: don't limit per-LUN queue depth for SSD
Message-ID: <20191122220031.GC8700@ming.t460p>
References: <20191118103117.978-1-ming.lei@redhat.com>
 <20191118103117.978-5-ming.lei@redhat.com>
 <1081145f-3e17-9bc1-2332-50a4b5621ef7@suse.de>
 <20191121005323.GB24548@ming.t460p>
 <336f35fc-2e22-c615-9405-50297b9737ea@suse.de>
 <20191122080959.GC903@ming.t460p>
 <5f84476f-95b4-79b6-f72d-4e2de447065c@acm.org>
MIME-Version: 1.0
In-Reply-To: <5f84476f-95b4-79b6-f72d-4e2de447065c@acm.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: lyqP7poSPlqVc5scUM3niw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Nov 22, 2019 at 10:14:51AM -0800, Bart Van Assche wrote:
> On 11/22/19 12:09 AM, Ming Lei wrote:
> > On Thu, Nov 21, 2019 at 04:45:48PM +0100, Hannes Reinecke wrote:
> > > On 11/21/19 1:53 AM, Ming Lei wrote:
> > > > On Wed, Nov 20, 2019 at 11:05:24AM +0100, Hannes Reinecke wrote:
> > > > > I would far prefer if we could delegate any queueing decision to =
the
> > > > > elevators, and completely drop the device_busy flag for all devic=
es.
> > > >=20
> > > > If you drop it, you may create big sequential IO performance drop
> > > > on HDD., that is why this patch only bypasses sdev->queue_depth on
> > > > SSD. NVMe bypasses it because no one uses HDD. via NVMe.
> > > >=20
> > > I still wonder how much performance drop we actually see; what seems =
to
> > > happen is that device_busy just arbitrary pushes back to the block
> > > layer, giving it more time to do merging.
> > > I do think we can do better then that...
> >=20
> > For example, running the following script[1] on 4-core VM:
> >=20
> > ------------------------------------------
> >                      | QD:255    | QD: 32  |
> > ------------------------------------------
> > fio read throughput | 825MB/s   | 1432MB/s|
> > ------------------------------------------
> >=20
> > [ ... ]
>=20
> Hi Ming,
>=20
> Thanks for having shared these numbers. I think this is very useful
> information. Do these results show the performance drop that happens if
> /sys/block/.../device/queue_depth exceeds .can_queue? What I am wondering

The above test just shows that IO merge plays important role here, and
one important point for triggering IO merge is that .get_budget returns
false.

If sdev->queue_depth is too big, .get_budget may never return false.

That is why this patch just bypasses .device_busy for SSD.

> about is how important these results are in the context of this discussio=
n.
> Are there any modern SCSI devices for which a SCSI LLD sets
> scsi_host->can_queue and scsi_host->cmd_per_lun such that the device
> responds with BUSY? What surprised me is that only three SCSI LLDs call

There are many such HBAs, for which sdev->queue_depth is smaller than
.can_queue, especially in case of small number of LUNs.

> scsi_track_queue_full() (mptsas, bfa, esp_scsi). Does that mean that BUSY
> responses from a SCSI device or HBA are rare?

It is only true for some HBAs.

thanks,
Ming

