From: David Chinner <dgc@sgi.com>
Subject: Re: some hard numbers on ext3 & batching performance issue
Date: Thu, 6 Mar 2008 11:28:04 +1100
Message-ID: <20080306002804.GE155407@sgi.com>
References: <47C6A46D.8020700@emc.com> <200802281005.13068.jbacik@redhat.com> <200802281041.01411.jbacik@redhat.com> <47C6B2A5.4030609@emc.com> <20080228175422.GU155259@sgi.com> <47CEF254.2090208@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47CEF254.2090208@emc.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ric Wheeler <ric@emc.com>
Cc: David Chinner <dgc@sgi.com>, Josef Bacik <jbacik@redhat.com>, Theodore Ts'o <tytso@mit.edu>, adilger@sun.com, jack@ucw.cz, "Feld, Andy" <Feld_Andy@emc.com>, linux-fsdevel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 05, 2008 at 02:19:48PM -0500, Ric Wheeler wrote:
> The work load is generated using fs_mark 
> (http://sourceforge.net/projects/fsmark/) which is basically a write 
> workload with small files, each file gets fsync'ed before close. The 
> metric is "files/sec".

.......

> It would be really interesting to rerun some of these tests on xfs which 
> Dave explained in the thread last week has a more self tuning way to 
> batch up transactions....

Ok, so XFS numbers. note these are all on a CONFIG_XFS_DEBUG=y kernel, so
there's lots of extra checks in the code as compared to a normal production
kernel.

Local disk (15krpm SCSI, WCD, CONFIG_XFS_DEBUG=y):

threads		files/s
  1		  97
  2		 117
  4		 109
  8		 110
 10		 113
 20		 116

Local disk (15krpm SCSI, WCE, nobarrier, CONFIG_XFS_DEBUG=y):

threads		files/s
  1		 203
  2		 216
  4		 243
  8		 332
 10		 405
 20		 424

Ramdisk (nobarrier, CONFIG_XFS_DEBUG=y):

	       agcount=4	agcount=16
threads		files/s		 files/s
  1		 1298		  1298
  2		 2073             2394
  4		 3296             3321
  8		 3464             4199
 10		 3394             3937
 20		 3251             3691

Note the difference the amount of parallel allocation in the
filesystem makes - agcount=4 only allows up to 4 parallel allocations
at once, so even if they are all aggregated into the one log I/O,
no further allocation can take place until that log I/O is complete.

And at about 4000 files/s the system (4p ia64) is becoming CPU bound
due to all the debug checks in XFS.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
