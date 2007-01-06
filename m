From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 2/5] fusion: vmware bug fix prevent inifinite retries
Date: Sat, 6 Jan 2007 09:10:18 -0700
Message-ID: <20070106161017.GI24620@parisc-linux.org>
References: <20070105034613.GA14118@lsil.com> <1168097445.2792.53.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:49130 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbXAFQKT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Jan 2007 11:10:19 -0500
Content-Disposition: inline
In-Reply-To: <1168097445.2792.53.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Eric Moore <eric.moore@lsil.com>, linux-scsi@vger.kernel.org

On Sat, Jan 06, 2007 at 09:30:45AM -0600, James Bottomley wrote:
> On Thu, 2007-01-04 at 20:46 -0700, Eric Moore wrote:
> > -			if (scsi_status == MPI_SCSI_STATUS_BUSY)
> > +			if (ioc->bus_type != SPI && scsi_status == MPI_SCSI_STATUS_BUSY)
> >  				sc->result = (DID_BUS_BUSY << 16) | scsi_status;
> >  			else
> >  				sc->result = (DID_OK << 16) | scsi_status;
> 
> DID_BUS_BUSY causes an immediate retry, but it does debit the retry
> count, so it shouldn't cause "infinite retries" ... if it does, there's
> something else wrong here.

I wonder if this is the same bug I'm chasing (on ia64 machines,
reproduced with both Montecito and Madison).  

The symptom is a stack overflow caused by this infinite loop:

generic_unplug_device
__generic_unplug_device
  scsi_request_fn [1]
  blk_requeue_request
  elv_requeue_request
  __elv_add_request
__generic_unplug_device
  scsi_request_fn [2]
  blk_requeue_request
  elv_requeue_request
  __elv_add_request
__generic_unplug_device
  scsi_request_fn [3]
  scsi_dispatch_cmd
  scsi_queue_insert
  blk_insert_request
  scsi_request_fn [4]
  blk_plug_device

(stack dump courtesy of incrementing a counter each time through
__generic_unplug_device and checking it in blk_plug_device() and
__generic_unplug_device)

I don't see how it happens; as far as I can tell, by the time we're
going to call blk_plug_device() in scsi_request_fn [4], there's no way
to unplug the queue again before it gets back to scsi_request_fn [3]
... and from the point where we call scsi_dispatch_cmd(), we immediately
either break or test blk_queue_plugged() and exit.  There should be no
way for it to call blk_requeue_request() again.

