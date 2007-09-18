From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: question on flushing buffers and spinning down disk
Date: Tue, 18 Sep 2007 09:26:06 -0500
Message-ID: <1190125566.3375.9.camel@localhost.localdomain>
References: <200709181032.29864.oliver@neukum.org>
	 <1190124061.3375.5.camel@localhost.localdomain>
	 <200709181615.46537.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:34268 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755677AbXIRO0I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Sep 2007 10:26:08 -0400
In-Reply-To: <200709181615.46537.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-scsi@vger.kernel.org

On Tue, 2007-09-18 at 16:15 +0200, Oliver Neukum wrote:
> Am Dienstag 18 September 2007 schrieb James Bottomley:
> > On Tue, 2007-09-18 at 10:32 +0200, Oliver Neukum wrote:
> > > which function should a lldd call to make the scsi layer flush
> > > a device's buffers and spin it down? Which kind of locking is
> > > required?
> > 
> > Depends on the context. Is this for suspend? If so it's done
> > automatically by the sd driver, but the device has to be marked for it
> > in the manage_start_stop attributes.
> 
> It is for runtime power management. We've gotten a bug report about
> a drive enclosure that doesn't properly park heads if the usb device is
> simply suspended. Apparently it simply cuts power so the cache can
> be lost, too.

But even for runtime, if you want to suspend the device, shouldn't you
be calling the suspend methods in the device tree?

James


