From: Christoph Hellwig <hch@infradead.org>
Subject: Re: hosts resets in SRP and the rest of the world, was: Re: [PATCH
 01/12] scsi_transport_srp: Introduce srp_wait_for_queuecommand()
Date: Mon, 11 May 2015 02:31:30 -0700
Message-ID: <20150511093130.GA30217@infradead.org>
References: <5541EE21.3050809@sandisk.com>
 <5541EE4A.30803@sandisk.com>
 <20150430093719.GA23486@infradead.org>
 <5542034D.5010300@sandisk.com>
 <554204D7.9050204@dev.mellanox.co.il>
 <55420AEA.10108@sandisk.com>
 <20150430172516.GA19200@infradead.org>
 <5549E600.9050208@sandisk.com>
 <20150511075058.GA18483@infradead.org>
 <55506E46.2060103@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33476 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbbEKJbi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2015 05:31:38 -0400
Content-Disposition: inline
In-Reply-To: <55506E46.2060103@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Doug Ledford <dledford@redhat.com>, James Bottomley <jbottomley@odin.com>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Jens Axboe <axboe@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

On Mon, May 11, 2015 at 10:54:30AM +0200, Bart Van Assche wrote:
> Hello Christoph,
> 
> There are multiple events that can cause the SRP initiator driver to
> initiate a reconnect:
> 1. The SCSI core invoking eh_host_reset_handler().
> 2. An error reported by the IB HCA or by the IB core, e.g. an RDMA
>    transmit timeout or a transport layer disconnect reported by the
>    IB/CM.

Right, I missed the srp_reconnect_work case.  But even with that I
think what I wrote above still stands.  srp_reconnect_work in that
case would just directly trigger the abort all commands and
reconnect operation.

The main point I was trying to make is that instead of having a sequence
of:

 1) block new queuecommand instances
 2) flush out pending queuecommand instances
 3) do part of the disconnect
 4) fail all in-flight commands
 5) reconnect

we should aim for:

 1) block new queuecommand instances
 2) fail all in-flight commands
 3) disconnect and reconnect

to avoid the need to keep track of pending queuecommand instances,
and instead re-use the existing infrastructure to fail all in-flight
commands, which we have the infrastructure for, and which we need
to do anyway.
