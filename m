From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: Error handling on FC devices
Date: Mon, 3 Dec 2012 11:19:54 -0600
Message-ID: <50BCDF3A.6040608@tributary.com>
References: <50AA290F.8000105@suse.de>  <50B3EDEA.40008@emulex.com> <1354046601.4420.14.camel@localhost.localdomain> <94D0CD8314A33A4D9D801C0FE68B40294CCFD463@G9W0745.americas.hpqcorp.net> <50B5B8C4.1040503@suse.de> <50B78715.2060109@emulex.com> <50B89C2D.8030108@suse.de> <50B8E4AC.8@cs.wisc.edu> <50BC517E.4090208@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.52]:3774 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277Ab2LCRZI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Dec 2012 12:25:08 -0500
In-Reply-To: <50BC517E.4090208@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Linux Scsi <linux-scsi@vger.kernel.org>

On 12/3/2012 1:15 AM, Hannes Reinecke wrote:
> Well, looking at QLogic and Emulex both emulate a bus reset with a loop
> over each target and invoke a target reset there. I somewhat fail to see
> the rationale behind it, other than emulating the bus reset behaviour on
> SPI.

	It is actually a _VERY_ bad idea in multiple initiator tape environments with
switched fibre where the resets can affect devices that are visible but not
owned/controlled by the machine broadcasting resets. Many tape environments
operate this way as the physical drives are assigned dynamically to initiators
as necessary. In some cases (ACSLS) the machine/OS/backup applications aren't
even homogenous.

	The rewind and loss of PR/etc, which if not handled properly by all the other
machines on the SAN can be quite disastrous.

	Its also somewhat problematic even in single initiator environments as the
reset can affect devices not having problems, and the 6/2900's can get eaten
by the logic attempting the reset, which leaves the user of a functional
device in the dark that it was reset/rewound.

	I was told last time I brought this up, that it was impossible for a single
device's failure to result in that bus reset path being called. Which was
patently false as the problem was only tracked down because of a repeatable
case of a single device failing in a manner which triggered progressively more
aggressive recovery culminating in the bus-reset being called.

	The result was a single device cascading a failure to a bunch of functional
devices and interrupting their operation.






