From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs  directories.
Date: Wed, 27 May 2009 17:38:50 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0905271736460.2669-100000@iolanthe.rowland.org>
References: <m1hbz69zfd.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:54878 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751170AbZE0Vis (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2009 17:38:48 -0400
In-Reply-To: <m1hbz69zfd.fsf@fess.ebiederm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, Kernel development list <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@aristanetworks.com>

On Wed, 27 May 2009, Eric W. Biederman wrote:

> Alan Stern <stern@rowland.harvard.edu> writes:
> 
> >
> > As fas as I know, they can't.  Instead, they can cause the SCSI layer 
> > to unregister a sysfs directory containing a child directory.  :-)
> >
> > Basically, a user program can delay removal of the child (i.e., the
> > target) directory indefinitely, because currently the target isn't
> > unregistered when all its children are removed -- it's unregistered
> > when all its children are _released_.
> 
> Ok.  Is this opens of /dev/sda1 and the like that are being held open by
> userspace that are potentially causing problems?

Yes, plus any other mechanism for preventing a struct device's refcount 
from going to 0.

> I think I have the fix to that...

The fix is to delete the target when its children are deleted, and not
wait until the children are released.

Alan Stern

