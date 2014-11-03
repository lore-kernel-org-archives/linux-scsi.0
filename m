From: Kashyap Desai <kashyap.desai@avagotech.com>
Subject: RE: [PATCH v2 10/12] IB/srp: Use block layer tags
Date: Mon, 3 Nov 2014 13:22:18 +0530
Message-ID: <0b1b37c7fe497160a80a1f5515d01534@mail.gmail.com>
References: <5433E43D.3010107@acm.org> <5433E557.3010505@acm.org>
 <94D0CD8314A33A4D9D801C0FE68B4029593212E0@G4W3296.americas.hpqcorp.net>
 <20141023084744.GA24965@infradead.org> <94D0CD8314A33A4D9D801C0FE68B402959324A17@G4W3296.americas.hpqcorp.net>
 <20141024064514.GA15654@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og109.obsmtp.com ([64.18.2.171]:53302 "EHLO
	exprod7og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbaKCH61 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Nov 2014 02:58:27 -0500
Received: by mail-la0-f50.google.com with SMTP id hz20so6579871lab.9
        for <linux-scsi@vger.kernel.org>; Sun, 02 Nov 2014 23:58:26 -0800 (PST)
In-Reply-To: <20141024064514.GA15654@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Ming Lei <ming.lei@canonical.com>, linux-scsi@vger.kernel.org, linux-rdma <linux-rdma@vger.kernel.org>, "Scales, Webb" <webb.scales@hp.com>, "Don Brace (PMC)" <Don.Brace@pmcs.com>

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Christoph Hellwig
> Sent: Friday, October 24, 2014 12:15 PM
> To: Elliott, Robert (Server Storage)
> Cc: Bart Van Assche; Jens Axboe; Sagi Grimberg; Sebastian Parschauer;
Ming
> Lei; linux-scsi@vger.kernel.org; linux-rdma; Scales, Webb; Don Brace
(PMC)
> Subject: Re: [PATCH v2 10/12] IB/srp: Use block layer tags
>
> On Fri, Oct 24, 2014 at 04:43:15AM +0000, Elliott, Robert (Server
Storage)
> wrote:
> > However, it was looking at scmd->tag, which is always 0xff (at least
> > in those early discovery commands).  scmd->request->tag looks like it
> > is the field that has the correct values.
> >
> > Also, I noticed that scmd->tag is just an 8 bit field, so it could
> > never represent a large number of tags.
>
> Yes, we need to get rid of scmd->tag.  Hannes had a patchset to get
started
> on it, and I hope either he or someone else will have time to get back
to it
> ASAP.
>
> > Just to confirm: After calling scsi_init_shared_tag_map() in non-mq
> > mode, will scmd->request->tag be based on controller-wide tag
> > allocation (never using the same value at the same time for the
> > request queues of multiple devices in that controller)?
>
> Yes.

Hi Everyone, I am doing similar code changes for megaraid_sas driver. I
found this thread more suitable to get help from you...

I also noticed that after using scsi_init_shared_tag_map() in driver, tags
are coming controller wide.
And that is a good for megaraid_sas driver to get-rid-off internal command
pool list and start using block layer tags.

As explained by Robert,
I also used below setting in slave_alloc(), so that first Inquiry command
received by driver also has valid Tag in (Non-MQ mode).
	sdev->tagged_supported = 1
Without above setting Inquiry command comes with 0xFF. If I see below code
in scsi_scan.c, it looks like tagged_supported value should be popped by
after actual value reported from Inquiry command.

        if ((sdev->scsi_level >= SCSI_2) && (inq_result[7] & 2) &&
            !(*bflags & BLIST_NOTQ))
                sdev->tagged_supported = 1;

Does it means what driver set in slave_alloc is OK to get Inquiry commands
with valid Tag  ?
What will happen if Target really does not support Tagged command queue
and driver overwrite it in slave_alloc ?

Thanks, Kashyap

> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
