Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D41EFC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Jan 2022 16:33:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbiAFQda (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Jan 2022 11:33:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46608 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230168AbiAFQda (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jan 2022 11:33:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641486809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ze42arU5bQVcYtb1c/tnKRMpZHPg8kUMfotWmxjwT6A=;
        b=U6ToPcwRl1wlkOGEa1mQXfmlXB76BHLcTOHbkbylPDUSWC7CLMnnkF55B0gWRiEgdxFcJJ
        9dXU6glKNXCEMH7j/f4psbZ0TFMsubhOuqfAhCVJen2IyZts3mkzUVS8+6mA4Tp7ukmK0s
        d3sRH+bmAVr4PzdQbV/EJl7LJ4CfKDg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-537-heNnJkT2PHG_gmxrilukdA-1; Thu, 06 Jan 2022 11:33:26 -0500
X-MC-Unique: heNnJkT2PHG_gmxrilukdA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D700F107B0EF;
        Thu,  6 Jan 2022 16:33:24 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3023A7E666;
        Thu,  6 Jan 2022 16:33:09 +0000 (UTC)
Date:   Fri, 7 Jan 2022 00:33:05 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Martin Wilck <martin.wilck@suse.com>
Cc:     "bart.vanassche@sandisk.com" <bart.vanassche@sandisk.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>,
        "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>,
        "suganath-prabu.subramani@broadcom.com" 
        <suganath-prabu.subramani@broadcom.com>,
        "hare@suse.de" <hare@suse.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: Re: mpt3sas fails to allocate budget_map and detects no devices
Message-ID: <YdcZwVUFGUPgkbLn@T590>
References: <be78dc2cfeecaafd171060fbebda2d268d2a94e5.camel@suse.com>
 <YdZcABq/pxMMh3X0@T590>
 <5a450cdadbffed9c5ce39bc7d58bcf4e541f3b53.camel@suse.com>
 <YdcEJngPYrZk691Q@T590>
 <97be83524e1ee6776a4c1261bf4c1b17a8b75f12.camel@suse.com>
 <YdcNrSJJGllQzWOB@T590>
 <5fffbc9191d1f1b3db1d51ce991591c9c6d91785.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5fffbc9191d1f1b3db1d51ce991591c9c6d91785.camel@suse.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jan 06, 2022 at 04:19:03PM +0000, Martin Wilck wrote:
> On Thu, 2022-01-06 at 23:41 +0800, Ming Lei wrote:
> > On Thu, Jan 06, 2022 at 03:22:53PM +0000, Martin Wilck wrote:
> > > > 
> > > > I'd suggest to fix mpt3sas for avoiding this memory waste.
> > > 
> > > Let's wait for Sreekanth's comment on that.
> > > 
> > > mpt3sas is not the only driver using a low value. Qlogic drivers
> > > set
> > > cmd_per_lun=3, for example (with 3, our logic would use shift=6, so
> > > the
> > > issue I observed wouldn't occur - but it would be prone to cache
> > > line
> > > bouncing).
> > 
> > But qlogic has smaller .can_queue which looks at most 512, .can_queue
> > is
> > the depth for allocating sbitmap, since each sdev->queue_depth is <=
> > .can_queue.
> 
> I'm seeing here (on an old kernel, admittedly) cmd_per_lun=3 and
> can_queue=2038 for qla2xxx and cmd_per_lun=3 and can_queue=5884 for
> lpfc. Both drivers change the queue depth for devices to 64 in their
> slave_configure() methods.
> 
> Many drivers do this, as it's recommended in scsi_host.h. That's quite
> bad in view of the current bitmap allocation logic - we lay out the
> bitmap assuming the depth used will be cmd_per_lun, but that doesn't
> match the actual depth when the device comes online. For qla2xxx, it
> means that we'd allocate the sbitmap with shift=6 (64 bits per word),
> thus using just a single cache line for 64 requests. Shift=4 (16 bits
> per word) would be the default shift for depth 64.
> 
> Am I misreading the code? Perhaps we should only allocate a preliminary
> sbitmap in scsi_alloc_sdev, and reallocate it after slave_configure()
> has been called, to get the shift right for the driver's default
> settings?

That looks fine to reallocate it after ->slave_configure() returns,
but we need to freeze the request queue for avoiding any in-flight
scsi command. At that time, freeze should be quick enough.


Thanks,
Ming

