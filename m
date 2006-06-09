From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: fc transport creates second set of targets for devices in an
	"md"
Date: Thu, 08 Jun 2006 19:43:56 -0500
Message-ID: <1149813836.3276.3.camel@mulgrave.il.steeleye.com>
References: <448876C8.3090303@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:55699 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S965119AbWFIDtd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jun 2006 23:49:33 -0400
In-Reply-To: <448876C8.3090303@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: James.Smart@Emulex.Com, Jeremy Higdon <jeremy@sgi.com>, Gary Hagensen <gwh@sgi.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2006-06-08 at 14:13 -0500, Michael Reed wrote:
> I created an md device on two fibre channel disks, sde and sdf.
> I then disabled the switch port to which the hba is connected.
> After the remote port time out messages, I re-enabled the switch
> port.  Three things happen that are weird.  First, two unexpected
> responses while scanning.  Second, the creation of sdm and
> sdn.  Third, the md device remains inaccessible.

This is sort of as expected.  What you did was wait out the reconnection
timer, so the mid layer failed and offlined the devices.  Thus, when
they come back, they get new instances.  If you'd done a remove-device
after they went offline, they'd have come back to the same location (as
long as nothing had them open).  But this is user level stuff.
Basically, when a path goes dead it's up to the multi-path user level to
remove it an wait for udev to inform it that another SCSI node has
appeared and has the correct signature to be another path to the device.

> I don't think this is working the way it's intended to.  I
> suspect it will cause big problems for multi-path volume managers
> in a fail back situation.

James


