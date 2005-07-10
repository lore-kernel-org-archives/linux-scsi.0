From: Ben Collins <bcollins@debian.org>
Subject: Re: sbp2: modprobe -r fails, module allegedly in use
Date: Sun, 10 Jul 2005 13:46:43 -0400
Message-ID: <20050710174643.GG14956@phunnypharm.org>
References: <42D133EE.9090204@s5r6.in-berlin.de> <20050710153126.GB14956@phunnypharm.org> <20050710174054.GA28623@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [206.246.247.150] ([206.246.247.150]:26852 "EHLO
	bristol.phunnypharm.org") by vger.kernel.org with ESMTP
	id S261943AbVGJRqp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Jul 2005 13:46:45 -0400
Content-Disposition: inline
In-Reply-To: <20050710174054.GA28623@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net

On Sun, Jul 10, 2005 at 06:40:54PM +0100, Christoph Hellwig wrote:
> On Sun, Jul 10, 2005 at 11:31:26AM -0400, Ben Collins wrote:
> > Yeah, seems like every two months we have to change sbp2 to accomodate
> > changes to the scsi layers whole reference scheme which never seems
> > simple, and never stays the same.
> 
> While the implementation has changed a little the exposed interface
> never changed at all since before 2.6.0.

The exposed implementation might not have, but atleast 3 times now, since
the driver model started being used, I've had to change the way I use the
exposed implementation in order to get bean counting right with the device
and host devices.

Prior, we were using one scsi host per ieee1394 host, with each sbp2
device being one device and even supporting real LUN's to make things as
close to looking like a real scsi host as possible.

Had to ditch all that and do one-host-per-device like USB does in order
save myself all the headache involved. This kind of sucks because the
plug/unplug can quickly increment the scsi-host counter to a point where
things like cdrecord don't work with firewire cd/dvd/rw devices anymore
(until a reboot or the scsi module is removed/inserted). But that's a
whole different issue :)

-- 
Debian     - http://www.debian.org/
Linux 1394 - http://www.linux1394.org/
Subversion - http://subversion.tigris.org/
SwissDisk  - http://www.swissdisk.com/
