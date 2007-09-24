From: Oliver Neukum <oliver@neukum.org>
Subject: Re: question on flushing buffers and spinning down disk
Date: Mon, 24 Sep 2007 17:21:50 +0200
Message-ID: <200709241721.50887.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0709241032180.4256-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:44392 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752701AbXIXPU6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Sep 2007 11:20:58 -0400
In-Reply-To: <Pine.LNX.4.44L0.0709241032180.4256-100000@iolanthe.rowland.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Am Montag 24 September 2007 schrieb Alan Stern:
> On Mon, 24 Sep 2007, Oliver Neukum wrote:
> 
> > Am Dienstag 18 September 2007 schrieb James Bottomley:
> > > On Tue, 2007-09-18 at 16:15 +0200, Oliver Neukum wrote:
> 
> > > > It is for runtime power management. We've gotten a bug report about
> > > > a drive enclosure that doesn't properly park heads if the usb device is
> > > > simply suspended. Apparently it simply cuts power so the cache can
> > > > be lost, too.
> > > 
> > > But even for runtime, if you want to suspend the device, shouldn't you
> > > be calling the suspend methods in the device tree?
> > 
> > Very good question. It seems to that yes indeed, we should. But we don't
> > in case of autosuspend. We simply suspend the interfaces:
> 
> It's a loaded question.  The fact is, the existing suspend methods in
> the device tree are intended for system-wide suspend, not for runtime

Unfortunately true.

> suspend.  The PM and driver cores don't include _any_ provision for
> runtime suspend; it has to be managed separately by each subsystem.

There we have a problem. We'd have to solve it for each subsystem transition.
Storage has this type of children, other devices will have to care for other
types of child devices. If we have a device tree, we should use it.
 
	Regards
		Oliver

