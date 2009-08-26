From: Chris Webb <chris@arachsys.com>
Subject: Re: scsi_wait_scan not working (2.6.30.5)
Date: Wed, 26 Aug 2009 15:34:31 +0100
Message-ID: <20090826143431.GA4368@arachsys.com>
References: <200908252124.22562.a.miskiewicz@gmail.com> <1251228529.7539.8.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alpha.arachsys.com ([91.203.57.7]:47058 "EHLO
	alpha.arachsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbZHZOiy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Aug 2009 10:38:54 -0400
Content-Disposition: inline
In-Reply-To: <1251228529.7539.8.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>, linux-scsi@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>

James Bottomley <James.Bottomley@suse.de> writes:

> It's caused by the sd async patches.  What's happening is wait_scan is
> waiting until all the scans are complete, but now sd attachment may not
> be completed by the time that happens.  So, although you have a scanned
> disk, you can't mount it without and attached sd driver. Hopefully when
> all initrds are configured to wait until root appears, this problem will
> go away.

This change has been causing me some puzzlement working out the right way to do
things in our infrastructure management code. Imagine I want a shell function
which takes a host and target name and returns a device node name, ready to
use. (In practice the login and logout functions would do reference counting to
avoid multiple logins to the same target for different consumers, and set up
device mapper targets and so on, but we can ignore that here.)

Previously, because iscsiadm --login does the equivalent of

  echo - - -  > /sys/class/scsi_host/hostX/scan

it was sufficient for me to do udevadm settle and then something like

  shopt -s nullglob
  local SESSION TARGET SESSION BLOCK KERNEL
  for SESSION in /sys/class/scsi_host/host*/device/session*; do
    for TARGET in $SESSION/iscsi_session/*/targetname; do
      [ "`< "$TARGET"`" = "$1" ] || continue
      for BLOCK in "$SESSION"/target*/*/block/*; do
        KERNEL=${BLOCK##*/}
        echo /dev/$KERNEL
        return $SUCCESS
      done
    done
  done
  return $EMISSING

to find my block device. Now I can't do that, and it's not obvious what the
official way is to block until the outstanding async sd attachment has
completed. Maybe I'm going about this completely the wrong way? Polling in a
loop with a sleep isn't very nice, and clearly can't be how people are meant to
do this, but everything else I've come up with is worse or more intrusive to
the system.

Cheers,

Chris.
