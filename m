From: Martin Peschke3 <MPESCHKE@de.ibm.com>
Subject: Re: How to resurrect offlined SCSI devices?
Date: Thu, 27 May 2004 22:05:30 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFCAAABE43.C4E9DEF8-ONC1256EA1.0066CAF7@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:43489 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP id S265168AbUE0UFk
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 May 2004 16:05:40 -0400
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, "Infante, Jon" <Jon.Infante@Emulex.Com>, SCSI Mailing List <linux-scsi@vger.kernel.org>





> The general issue I believe Martin is investigating is in the context of
> device mapper multi-path (Martin correct me if I have this incorrect).

Right. If an lldd tries to accomodate multipathed I/O by returning
I/O promptly (instead of delaying, retrying, queueing, and working
around the threat of offlined devices and I/O errors), then the issue
is most appararent. Although, the subject question also applies to
non-multipathed I/O.

> In the failure transition of a path a scsi_device can be marked
> offline.  Until the device is restored path checking / re-enablement
> cannot proceed. One issue is that path testing tools need to have SCSI
> specific knowledge to know to change a device state.

Exacly. It would be ugly to have generic multipath tools care about
I/O subsystem specific flags. I am wondering why we need that special
offline bit in SCSI and how such matters are handled by other subsystems.
How does it fit into the generic device model and hotplug scheme?
If it fits well, then it could probably reside above SCSI. If it doesn't
fit, then it could be an indication that SCSI does it differently
(for historical reasons perhaps) and that there might be an alternative
which makes the offline bit dispensible.
I am not jeopardising 2.6 SCSI as it is. And I would be fine with
some user land helpers triggered by the kernel to get SCSI devices
back online. But perhaps there is something to think about for 2.7.

> The second issue is
> that while this could be done with a daemon it would appear a more
> efficient method would be some form of state / event notification of
> device and transport specific events.

Right, indications available to lower layers should not be dismissed,
regardless of whatever layer is finally doing the actual work.

Martin

