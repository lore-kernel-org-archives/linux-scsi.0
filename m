From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCHv8 20/23] scsi: Add 'access_state' attribute
Date: Tue, 23 Feb 2016 09:12:32 -0500
Message-ID: <1456236752.16707.12.camel@localhost.localdomain>
References: <1455869840-122786-1-git-send-email-hare@suse.de>
	 <1455869840-122786-21-git-send-email-hare@suse.de>
	 <56C7688A.2050608@sandisk.com> <56C81DB5.7070102@suse.de>
	 <56C8834F.50304@sandisk.com> <56C9750B.9010200@suse.de>
	 <56CA9252.8030007@sandisk.com> <56CAB1E4.9060809@suse.de>
	 <56CB2AA2.9090505@sandisk.com>  <56CC341F.2000407@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbcBWOMf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Feb 2016 09:12:35 -0500
In-Reply-To: <56CC341F.2000407@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2016-02-23 at 18:27 +0800, Hannes Reinecke wrote:
> On 02/22/2016 11:34 PM, Bart Van Assche wrote:
> > On 02/21/16 22:59, Hannes Reinecke wrote:
> >> The main reason why I need the 'access_state' attribute is to decouple
> >> the multipath daemon; at the moment the multipath daemon has to issue
> >> REPORT TARGET PORT GROUPS frequently to figure out the status, which is
> >> causing quite some load on the target. When using the 'access_state'
> >> attribute we would avoid doing I/O for that and have a consistent view,
> >> both on the kernel and the multipath daemon side.
> >>
> >> But it's actually a good thing to have the 'access_state' patch in a
> >> different series; I've got some more patches converting the remaining
> >> device_handler to also supply the 'access_state' values.
> > 
> > Hello Hannes,
> > 
> > The above sounds very interesting to me. Will multipathd recognize at
> > run-time whether or not the kernel supports the sysfs ALUA state
> > attribute ?
> That was the plan.
> (Not that I've got any idea _how_ to do this ATM :-)
> 
> > Will ALUA state changes be reported through udev or will
> > multipathd poll the sysfs ALUA state attributes ? 
> Polling. udev events will be too unreliable here, as each uevent
> potentially causes I/O during uevent processing which might stall as the
> path might be down.
> So we might never get events for failed/transitioning paths, however,
> these are precisely the cases which we're interested in ...

And, in fact, if paths go down due to e.g. an FC switch failure, it is
common for a large number of paths to go down at once, causing a large
number of uevents to be queued.

> 
> > And if the netlink
> > buffer that is used in multipathd to receive udev events overflows
> > (ENOBUFS), will multipathd resynchronize its state ? As far as I can see
> > in source file libmultipath/uevent.c today multipathd ignores netlink
> > buffer overflows.
> > 
> Which, thankfully, doesn't apply as multipathd will be polling the sysfs
> attribute directly :-)
> 
> Cheers,
> 
> Hannes


