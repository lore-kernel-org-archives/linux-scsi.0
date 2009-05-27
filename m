From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs  directories.
Date: Wed, 27 May 2009 15:06:09 -0700
Message-ID: <m1ljoi6w1a.fsf@fess.ebiederm.org>
References: <Pine.LNX.4.44L0.0905271736460.2669-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0905271736460.2669-100000@iolanthe.rowland.org> (Alan Stern's message of "Wed\, 27 May 2009 17\:38\:50 -0400 \(EDT\)")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kay Sievers <kay.sievers@vrfy.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, Kernel development list <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@aristanetworks.com>
List-Id: linux-scsi@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

> On Wed, 27 May 2009, Eric W. Biederman wrote:
>
>> Alan Stern <stern@rowland.harvard.edu> writes:
>> 
>> >
>> > As fas as I know, they can't.  Instead, they can cause the SCSI layer 
>> > to unregister a sysfs directory containing a child directory.  :-)
>> >
>> > Basically, a user program can delay removal of the child (i.e., the
>> > target) directory indefinitely, because currently the target isn't
>> > unregistered when all its children are removed -- it's unregistered
>> > when all its children are _released_.
>> 
>> Ok.  Is this opens of /dev/sda1 and the like that are being held open by
>> userspace that are potentially causing problems?
>
> Yes, plus any other mechanism for preventing a struct device's refcount 
> from going to 0.

Thanks.  The discussion makes sense now.

>> I think I have the fix to that...
>
> The fix is to delete the target when its children are deleted, and not
> wait until the children are released.

I think I can do both.

I am currently working on a patchset which at the VFS layer disconnects a
fd from an underlying device.  It does the necessary use count tracking
and when the disconnect is done it returns.  As part of the disconnect it
calls the release method.

We already do this in at least sysfs, proc, sysctl, and sound.  So I
figure it is time to move this into some generic code so we don't need
to duplicate the bugs and the insanities.

Once merged it would take just a few lines of code to use this functionality.

Eric
