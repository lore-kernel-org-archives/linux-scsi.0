From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Mon, 31 May 2010 16:46:49 +0200
Message-ID: <20100531144648.GA19068@schmichrtp.mainz.de.ibm.com>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
 <yq1iq64kv9f.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1iq64kv9f.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, May 31, 2010 at 10:20:44AM -0400, Martin K. Petersen wrote:
> >>>>> "Christof" == Christof Schmitt <christof.schmitt@de.ibm.com> writes:
> 
> Christof> Since the guard tags are created in Linux, it seems that the
> Christof> data attached to the write request changes between the
> Christof> generation in bio_integrity_generate and the call to
> Christof> sd_prep_fn.
> 
> Yep, known bug.  Page writeback locking is messed up for buffer_head
> users.  The extNfs folks volunteered to look into this a while back but
> I don't think they have found the time yet.

Thanks for the info. This means that this bug appears with all
filesystems?

> 
> 
> Christof> Using ext3 or ext4 instead of ext2 does not show the problem.
> 
> Last I looked there were still code paths in ext3 and ext4 that
> permitted pages to be changed during flight.  I guess you've just been
> lucky.

ext3 looks good so far. I see the problem also with ext4, so i spoke
too early on that one. I will start a longer testrun with ext3 to see
if and when the problem appears with ext3 in my setup.

--
Christof Schmitt
