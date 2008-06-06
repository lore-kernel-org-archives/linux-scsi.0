From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0 of 3] [RFC] I/O Hints
Date: Thu, 05 Jun 2008 21:03:09 -0400
Message-ID: <yq1od6fml2q.fsf@sermon.lab.mkp.net>
References: <patchbomb.1212643369@sermon.lab.mkp.net>
	<20080605062754.GQ2961@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20080605062754.GQ2961@webber.adilger.int> (Andreas Dilger's message of "Thu\, 05 Jun 2008 00\:27\:54 -0600")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Andreas" == Andreas Dilger <adilger@sun.com> writes:

Andreas> Having an ioctl() that can be called on the block device
Andreas> (getting the right device regardless of its name) seems a lot
Andreas> more useful to applications in my experience, unless you are
Andreas> using a script.

The reason I didn't do it that way is that I only exported the bare
bones required for userland to deal with the layout intelligently.

The problem of the ioctl is that you lose information about the
subdevices and in particular about their physical alignment.  The
phys_off value I export for the MD device is the offset for the first
device.  But that does not imply that the other devices in the stripe
have the same alignment.

I considered taking an approach similar to blk_queue_stack_limits()
where you clamp using the existing values as you add more devices.
The downside to that is that you really want to let the user know that
there's a potential problem.  And requiring the user to scrounge
through syslog to look for complaints isn't so happening.  I'd much
rather do that in libdisk where it's easy to print a message about
"Suboptimal layout, proceed with caution".

IOW, the idea is (for better and for worse) to let libdisk traverse
sysfs to ensure that all things line up nicely before mkfs actually
starts writing.

-- 
Martin K. Petersen	Oracle Linux Engineering

