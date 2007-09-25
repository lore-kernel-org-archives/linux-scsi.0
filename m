From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [linux-usb-devel] question on flushing buffers and spinning down disk
Date: Tue, 25 Sep 2007 09:50:35 +0200
Message-ID: <200709250950.35933.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0709241532380.5920-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out001.kontent.com ([81.88.40.215]:40160 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbXIYHtn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Sep 2007 03:49:43 -0400
In-Reply-To: <Pine.LNX.4.44L0.0709241532380.5920-100000@iolanthe.rowland.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb-devel@lists.sourceforge.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Am Montag 24 September 2007 schrieb Alan Stern:
> On Mon, 24 Sep 2007, Oliver Neukum wrote:
> 
> > > subsystem implements its own form of runtime PM support, then you'll be
> > > able to use it properly.  But until then, there isn't anything much you
> > > can do.
> > 
> > Well, we can't simply cut power. Buffers must be flushed and the disk
> > spun down. The suspend() method of the storage driver will have to become
> > complex.
> 
> That's right, if the device is a real disk.  If it's a flash memory
> device then of course these issues don't arise.  Unfortunately the

With respect to buffers how sure are you about that?

> driver isn't able to tell one from the other; the user will have to
> do that for us.

Code for what we need is in sd_suspend(). The only trouble is locking.
We need to make sure no commands that dirty buffers are issued after
flushing the buffers.

	Regards
		Oliver


