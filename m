Return-Path: <SRS0=RMqd=ZO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 208C7C43141
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 22:05:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8FC22071C
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 22:05:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HhRyN5eO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfKVWFO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Nov 2019 17:05:14 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:58299 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbfKVWFN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Nov 2019 17:05:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574460312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kK4893Bx+RXp+QXy6r1ai6/vMQ89ZOHnbhqTt0I3kKo=;
        b=HhRyN5eOoNhIQLG0+RT1hj+eP4B5dX0mPgk5nh/bYEH3hSUeHGzUPXfl7NFqoG84IHsn8+
        4q/1m0cpgiSqdbJByZDQKrqkX79Fs3S8XGiVLJl0ZM3G3xaVcBY8LlcF6XMB9Faw9K41nR
        ZxWCd3xDz8z7cfdvikcfUwnyei9EUno=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-FazToxEOMxCYH-MlkF5OkQ-1; Fri, 22 Nov 2019 17:05:09 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5147280268C;
        Fri, 22 Nov 2019 22:05:06 +0000 (UTC)
Received: from ming.t460p (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 169E95D6A0;
        Fri, 22 Nov 2019 22:04:53 +0000 (UTC)
Date:   Sat, 23 Nov 2019 06:04:49 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     James Smart <james.smart@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
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
Message-ID: <20191122220449.GD8700@ming.t460p>
References: <20191118103117.978-1-ming.lei@redhat.com>
 <20191118103117.978-5-ming.lei@redhat.com>
 <1081145f-3e17-9bc1-2332-50a4b5621ef7@suse.de>
 <20191121005323.GB24548@ming.t460p>
 <336f35fc-2e22-c615-9405-50297b9737ea@suse.de>
 <20191122080959.GC903@ming.t460p>
 <5f84476f-95b4-79b6-f72d-4e2de447065c@acm.org>
 <7e44d961-a089-e073-1e35-5890e75b0ba7@broadcom.com>
 <1963d16a-a390-6a25-ec20-53c4b01dc98f@acm.org>
MIME-Version: 1.0
In-Reply-To: <1963d16a-a390-6a25-ec20-53c4b01dc98f@acm.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: FazToxEOMxCYH-MlkF5OkQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Nov 22, 2019 at 12:46:48PM -0800, Bart Van Assche wrote:
> On 11/22/19 10:26 AM, James Smart wrote:
> > On 11/22/2019 10:14 AM, Bart Van Assche wrote:
> > > Thanks for having shared these numbers. I think this is very useful
> > > information. Do these results show the performance drop that happens
> > > if /sys/block/.../device/queue_depth exceeds .can_queue? What I am
> > > wondering about is how important these results are in the context of
> > > this discussion. Are there any modern SCSI devices for which a SCSI
> > > LLD sets scsi_host->can_queue and scsi_host->cmd_per_lun such that
> > > the device responds with BUSY? What surprised me is that only three
> > > SCSI LLDs call scsi_track_queue_full() (mptsas, bfa, esp_scsi). Does
> > > that mean that BUSY responses from a SCSI device or HBA are rare?
> >=20
> > That's because most of the drivers, which had queue full ramp up/ramp
> > down in them and would have called scsi_track_queue_full() converted
> > over to the moved-queue-full-handling-in-the-mid-layer, indicated by
> > sht->track_queue_depth =3D 1.
> >=20
> > Yes - it is still hit a lot!
>=20
> Hi James,
>=20
> In the systems that I have been working on myself I made sure that the BU=
SY
> condition is rarely or never encountered. Anyway, since there are setups =
in
> which this condition is hit frequently we need to make sure that these
> setups keep performing well. I'm wondering now whether we should try to c=
ome
> up with an algorithm for maintaining sdev->device_busy only if it improve=
s
> performance and for not maintaining sdev->device_busy for devices/HBAs th=
at
> don't need it.

The simplest policy could be to only maintain sdev->device_busy for HDD.


Thanks,
Ming

