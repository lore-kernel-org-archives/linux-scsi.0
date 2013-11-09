From: Todd E Brandt <todd.e.brandt@linux.intel.com>
Subject: Re: [PATCH/RESEND v2 0/2] SATA disk resume time optimization
Date: Fri, 8 Nov 2013 17:20:23 -0800
Message-ID: <20131109012023.GA8978@linux.intel.com>
References: <20131017193331.GA11747@linux.intel.com>
 <527AF287.7020700@ubuntu.com>
Reply-To: todd.e.brandt@linux.intel.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <527AF287.7020700@ubuntu.com>
Sender: linux-ide-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I tested your patches and they do function. We tried a similar approach
a few months back where instead of waking the scsi disks we just set 
them all to runtime_suspended and skipped the resume. Then we let
them be awakened later by read/write access just as you have. It's a really 
tempting approach, in theory, since you're saving both time and power 
by only waking those disks you know you need. But in practice I've found 
that userspace doesn't play nice.

In my experience the user layer almost always manages to wake up every
mounted disk after resume, even if you didn't deliberately use them
prior to suspend. The accesses can come from the file manager doing a 
scan after resume, or from any number of apps running on the system that 
decide they need to get even the smallest piece of information from the 
disks. A simple space check will wake them up.

Thus when you leave all the disks stopped, user space ends up triggering 
a traffic jam when the OS wakes back up, which makes disk access take even
longer.

My patch works very similarly to yours but just triggers an asynchronous 
wakeup to all the disks in anticipation of userspace's needs. We've 
tested it pretty heavily on ubuntu machines of all types and it's 
done well.

Ultimately I would be happy if either solution were accepted though, 
because this is a serious performance problem that needs to be addressed
in some way.

On Wed, Nov 06, 2013 at 08:53:11PM -0500, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
> 
> On 10/17/2013 03:33 PM, Todd E Brandt wrote:
> > The essential issue behind hard disks' lengthy resume time is the
> > ata port driver blocking until the ATA port hardware is finished
> > coming online. So the kernel isn't really doing anything during all
> > those seconds that the disks are resuming, it's just blocking until
> > the hardware says it's ready to accept commands. Applying this
> > patch set
> 
> I have been working in a similar direction and have patches to follow.
>  Instead of backgrounding the start in sd_resume, I have removed it
> entirely, and background the resume at the ata port layer, as well as
> avoid resuming Power on in Standby disks entirely.
> 
> 
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.14 (GNU/Linux)
> Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/
> 
> iQEcBAEBCgAGBQJSevKEAAoJEJrBOlT6nu75FFkIAL8mwXOuuNvY5GoppHVMcweC
> EOBz6t2Xmc/TsGYr9u4kRVXbf3G0trSM9dj/XSJ6p+Dj/su/vJ69yKxp7sUPidgz
> zqjfKlG+myMQIaAO+tPGXvMcmT74BXjgjobZw2lUyLyRPLD9elDGmrDA5ZXZ+hiz
> hzSx4gOC57j+sK/pmoZ7U/CWeWYEYQ+J9xBXm0hzbBbSTjpzVsR0T+7xU+WVkeX0
> Ox++FFBZp2b1xJgaREurRv1mORx/GJ+PfSETb49P5BWaWW+QVwOEhWOX/JQNc/Pp
> ANJmttP4WPvlRV0X3hD6FvAYSnu1qbwwGOiP/j5g7mklyfm5alA0jcuahc1w5tI=
> =9KhA
> -----END PGP SIGNATURE-----
