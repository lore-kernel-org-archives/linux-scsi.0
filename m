From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Mon, 31 May 2010 10:01:42 -0500
Message-ID: <1275318102.2823.47.camel@mulgrave.site>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
	 <yq1iq64kv9f.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1iq64kv9f.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2010-05-31 at 10:20 -0400, Martin K. Petersen wrote:
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
> 
> 
> Christof> Using ext3 or ext4 instead of ext2 does not show the problem.
> 
> Last I looked there were still code paths in ext3 and ext4 that
> permitted pages to be changed during flight.  I guess you've just been
> lucky.

Pages have always been modifiable in flight.  The OS guarantees they'll
be rewritten, so the drivers can drop them if it detects the problem.
This is identical to the iscsi checksum issue (iscsi adds a checksum
because it doesn't trust TCP/IP and if the checksum is generated in
software, there's time between generation and page transmission for the
alteration to occur).  The solution in the iscsi case was not to
complain if the page is still marked dirty.

James
