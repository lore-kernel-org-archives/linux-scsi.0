From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] pull scsi_scan_host out of scsi_add_host
Date: Tue, 8 Jul 2003 08:56:45 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030708155645.GA4379@beaverton.ibm.com>
References: <20030707143056.GA1177@lst.de> <20030708080334.GA2451@beaverton.ibm.com> <200307081103.17131.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:38119 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S267450AbTGHPj4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Jul 2003 11:39:56 -0400
Content-Disposition: inline
In-Reply-To: <200307081103.17131.oliver@neukum.org>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: Christoph Hellwig <hch@lst.de>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Oliver Neukum [oliver@neukum.org] wrote:
> Am Dienstag, 8. Juli 2003 10:03 schrieb Mike Anderson:
> > Christoph Hellwig [hch@lst.de] wrote:
> > > As Douglas mentioned on this list a while ago there's hardware these
> > > days where we don't want to automatically perform an initial bus scan
> > > in scsi_add_host.  Currently we only have ieee1394 in the tree but
> > > I can imagine more uses like iscsi or certain fc setups.
> > > 
> > > This patch removes the call to scsi_scan_host from scsi_add_host
> > > and moves it into the drivers that want in.
> > 
> > Would we want to make a symmetric interface and pull the
> > unscan out of scsi_remove_host also?
> 
> Unless you are talking about multipath, you have to forget
> all devices connected to a controller, so what sense would
> it make?

Probably not much sense. I was thinking of a progression to user assisted
scanning. In that a driver could never call scsi_scan_host directly and
conversely never call scsi_forget_host directly. 

But in the removal case there is not much response a user space hotplug
handler could make besides a delayed call to scsi_remove_device.

> 
> Philosophically speaking, scanning is an operation that cannot
> be simply undone. You can undo device/driver bindings but you
> cannot undo a bus scan.

Maybe it was a confusing choice of words. The operation I was describing
was to undo the binding.

-andmike
--
Michael Anderson
andmike@us.ibm.com

