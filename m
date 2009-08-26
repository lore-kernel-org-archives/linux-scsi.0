From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: scsi_wait_scan not working (2.6.30.5)
Date: Wed, 26 Aug 2009 10:40:26 -0500
Message-ID: <1251301226.4205.10.camel@mulgrave.site>
References: <200908252124.22562.a.miskiewicz@gmail.com>
	 <1251228529.7539.8.camel@mulgrave.site>
	 <20090826143431.GA4368@arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:38982 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbZHZPkc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Aug 2009 11:40:32 -0400
In-Reply-To: <20090826143431.GA4368@arachsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Webb <chris@arachsys.com>
Cc: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>, linux-scsi@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>

[resending with cc list this time]

On Wed, 2009-08-26 at 15:34 +0100, Chris Webb wrote:
> James Bottomley <James.Bottomley@suse.de> writes:
> 
> > It's caused by the sd async patches.  What's happening is wait_scan is
> > waiting until all the scans are complete, but now sd attachment may not
> > be completed by the time that happens.  So, although you have a scanned
> > disk, you can't mount it without and attached sd driver. Hopefully when
> > all initrds are configured to wait until root appears, this problem will
> > go away.
> 
> This change has been causing me some puzzlement working out the right way to do
> things in our infrastructure management code. Imagine I want a shell function
> which takes a host and target name and returns a device node name, ready to
> use. (In practice the login and logout functions would do reference counting to
> avoid multiple logins to the same target for different consumers, and set up
> device mapper targets and so on, but we can ignore that here.)
> 
> Previously, because iscsiadm --login does the equivalent of
> 
>   echo - - -  > /sys/class/scsi_host/hostX/scan
> 
> it was sufficient for me to do udevadm settle and then something like
> 
>   shopt -s nullglob
>   local SESSION TARGET SESSION BLOCK KERNEL
>   for SESSION in /sys/class/scsi_host/host*/device/session*; do
>     for TARGET in $SESSION/iscsi_session/*/targetname; do
>       [ "`< "$TARGET"`" = "$1" ] || continue
>       for BLOCK in "$SESSION"/target*/*/block/*; do
>         KERNEL=${BLOCK##*/}
>         echo /dev/$KERNEL
>         return $SUCCESS
>       done
>     done
>   done
>   return $EMISSING
> 
> to find my block device. Now I can't do that, and it's not obvious what the
> official way is to block until the outstanding async sd attachment has
> completed. Maybe I'm going about this completely the wrong way? Polling in a
> loop with a sleep isn't very nice, and clearly can't be how people are meant to
> do this, but everything else I've come up with is worse or more intrusive to
> the system.

Right, polling isn't desirable.

The way it's supposed to work is that you listen for the uevent that
signals the sd binding is complete, so you actually get notice
asynchronously.  The event carries device information with it.  udev
uses the node information to send VPD inquiries, which is how it does
the by-id and by-uuid mappings.

James


