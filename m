From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Calling sd_shutdown when in state SDEV_DEL
Date: Wed, 24 Mar 2004 17:48:59 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040325014859.GA3040@beaverton.ibm.com>
References: <200403241603.23269.heiko.carstens@de.ibm.com> <1080142505.2706.25.camel@mulgrave> <20040324170452.GB1679@beaverton.ibm.com> <1080158975.1783.26.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:63152 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S263114AbUCYBtE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Mar 2004 20:49:04 -0500
Content-Disposition: inline
In-Reply-To: <1080158975.1783.26.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley [James.Bottomley@SteelEye.com] wrote:
> On Wed, 2004-03-24 at 12:04, Mike Anderson wrote:
> > Why setting CANCEL on the device? Future plans for the CANCEL state?
> > You are setting the state to cancel, but not going through
> > scsi_device_cancel as you want IO to still flow.
> 
> Mainly because it was there.  Using CANCEL instead of DEL is appealing
> since it will still allow special I/O.  Would there be an issue with
> refusing new device references in the CANCEL state?

I think this should be ok as this is our (scsi core) own internal
solution to keep ref counts from increasing for the purpose of
eventually allowing everything to cleanup. 

> 
> > While this will solve the problem for removing a single device, this
> > same error will show up when you remove a host unless you remove all
> > devices first through the sysfs interface. Is this ok?
> 
> Sigh, that's a symptom of the host not having a state model ... I need
> to think about adding that.

Well this is my mess. We really have two usages models here but only one
scsi_remove_host interface. One usage calls scsi_remove_host when the
transport is dead and does not want anymore IO to flow through
queuecommand.  The other usage calls during a clean removal (i.e., rmmod
or hotplug) while there are still scsi_device children of the host
adapter as this is easier than deleting the children first.


-andmike
--
Michael Anderson
andmike@us.ibm.com

