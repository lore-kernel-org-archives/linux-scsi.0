From: Chris Clayton <chris2553@googlemail.com>
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
Date: Wed, 11 Jun 2008 19:51:09 +0000
Message-ID: <200806111951.09275.chris2553@googlemail.com>
References: <200806010415.05290.chris2553@googlemail.com> <200806111858.05114.chris2553@googlemail.com> <20080611191533.GA6189@kroah.com>
Reply-To: chris2553@googlemail.com
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:30972 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756295AbYFKTxr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2008 15:53:47 -0400
Received: by ug-out-1314.google.com with SMTP id h2so183357ugf.16
        for <linux-scsi@vger.kernel.org>; Wed, 11 Jun 2008 12:53:44 -0700 (PDT)
In-Reply-To: <20080611191533.GA6189@kroah.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>, linux-usb@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>

On Wednesday 11 June 2008, Greg KH wrote:
> On Wed, Jun 11, 2008 at 06:58:05PM +0000, Chris Clayton wrote:
> > Jun 11 17:48:13 upstairs udevd-event[1457]: wait_for_sysfs: wait for
> > '/sys/devices/pci0000:00/0000:00:1e.0/0000:02:0a.2/usb11/11-2/11-2:1.0/ho
> >st4/ioerr_cnt' for 20 mseconds Jun 11 17:48:18 upstairs last message
> > repeated 236 times
>
> This doesn't look good.  It looks like a udev rule in your system is
> looking for a file that will never show up.  That's a short way to a
> long delay time :)
>
> Try commenting out the rule that does this and see if things are fixed.
>

Yes, that's it. It's this rule, which appears as the second rule in the 
slackware rules file that's distributed with udev (and it's been there since 
udev-97 in August 2006):

ACTION=="add", SUBSYSTEM=="scsi", WAIT_FOR_SYSFS="ioerr_cnt"

Commenting that rule out eliminates the pause in the boot and in the appearance 
of icons on my desktop.

Thanks,

Chris

> thanks,
>
> greg k-h


-- 
Beauty is in the eye of the beerholder.
