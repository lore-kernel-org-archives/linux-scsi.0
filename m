From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: remove-single-device removes mounted HDDs (kernel 2.6)
Date: Thu, 11 Aug 2005 11:51:04 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F01684D52@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:21398 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932295AbVHKPxW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2005 11:53:22 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Harald Seipp <SEIPP@de.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

The problem with pushing this policy to the user is that software
applications have no means to determine that a device is currently
in-use. For instance, the net result of pulling a device on a mounted
filesystem is an eventual kernel panic.

There needs to be a means to reasonably *predict* the behavior of the
operating system and keep away from doing harm to oneself.

Yes, this is an old discussion, usually turned away as something that
can not be solved because of race conditions. There are users out there
that would appreciate a race condition that reduces the possibility of a
kernel panic.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of James Bottomley
Sent: Thursday, August 11, 2005 10:51 AM
To: Harald Seipp
Cc: SCSI Mailing List
Subject: Re: remove-single-device removes mounted HDDs (kernel 2.6)

On Thu, 2005-08-11 at 16:32 +0200, Harald Seipp wrote:
> Ok - but shouldn't the behavior that devices that have mounted
partitions
> can be removed be considered as a bug?

Not really.  We remove as much as we can and leave it up to the hotplug
scripts to detach the mount point (any further I/O's will error).

If there's a reattachment udev should identify the device (even if it's
on a different node) and do the right thing.

Essentially in 2.6 resolution of this problem is pushed up to the user
as a policy decision.

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
