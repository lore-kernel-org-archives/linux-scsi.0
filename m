From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Wed, 25 Jun 2014 02:17:23 -0700
Message-ID: <20140625091723.GB5360@infradead.org>
References: <1402477799-24610-2-git-send-email-sagig@mellanox.com>
 <53A920B2.9060503@cs.wisc.edu>
 <yq1mwd2h3ju.fsf@sermon.lab.mkp.net>
 <28678EBD-1AE9-48F9-B9E2-E6A61B042BB1@cs.wisc.edu>
 <53A9A702.8050503@dev.mellanox.co.il>
 <20140624163040.GA11499@infradead.org>
 <53A9AEB8.4040104@cs.wisc.edu>
 <53A9B0A0.6000103@cs.wisc.edu>
 <53AA42E6.3090101@cs.wisc.edu>
 <53AA8CF7.8050102@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53AA8CF7.8050102@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, nab@linux-iscsi.org, roland@kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> >Sagi's patch was not correct because scsi_in was hardcoded to the transfer
> >len when bidi was used.
> 
> Right, should have condition that in the direction. something like:
> 
> transfer_length = sc->sc_data_direction == DMA_TO_DEVICE ?
> scsi_out(sc)->length : scsi_in(sc)->length;
> 
> would probably hit that in testing before sending out a patch.

We could also pass the dma direction indeed.  Compared to my suggestion
of passing thr scsi_data_buffer this makes life a lot easier for drivers
that don't try to support the bidi madness.

> >There is one issue/question though. Is this working ok with LIO? I left
> >scsi_transfer_length() with the same behavior as before assuming LIO was
> >ok and only the iscsi initiator had suffered a regression.
> 
> I think that if we go with scsi_in/out_transfer_length then
> scsi_transfer_length should be removed
> and LIO can be modified to use scsi_in/out_transfer_length.

drivers/target/loopback/tcm_loop.c doesn't (and absolutely shouldn't!)
use scsi_transfer_length in target context, it uses it in it's initiator
side in the same way as iscsi, so the same semantics apply.
