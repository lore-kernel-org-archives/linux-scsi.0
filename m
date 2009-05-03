From: Matthew Wilcox <matthew@wil.cx>
Subject: New TRIM/UNMAP tree published (2009-05-02)
Date: Sun, 3 May 2009 01:16:19 -0600
Message-ID: <20090503071619.GP8822@parisc-linux.org>
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <49D8A3D7.5070507@panasas.com> <20090503061150.GF10704@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090503061150.GF10704@linux.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@redhat.com, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, May 02, 2009 at 11:11:50PM -0700, Matthew Wilcox wrote:
> > blkdev_issue_discard() and blk_ioctl_discard() has half a page
> > of common (and changing) code, could be done to use a common
> > helper that sets policy about bio allocation sizes and such.
> > 
> > Just my $0.017
> 
> Yes, that works nicely.  Thanks for the suggestion.

I've pushed out a new git tree:

http://git.kernel.org/?p=linux/kernel/git/willy/ssd.git;a=shortlog;h=trim-20090502

Changes since the last version:

 - Based on 2.6.30-rc4.
 - Dropped the three patches which were already merged.
 - Shuffled 'Make DISCARD_BARRIER and DISCARD_NOBARRIER writes instead of
   reads' to the front of the queue since it's not controversial and could
   be merged earlier.
 - Inserted 'Unify blk_ioctl_discard and blkdev_issue_discard' as patch two.
 - Updated 'ide: Add support for TRIM' to compile with new IDE code.

Still to do:
 - Understand all the changes Bart made to the IDE code; I didn't make all
   the changes that he did.  I just made it compile for now.
 - Dave had some objections to the description of 'Make DISCARD_BARRIER and
   DISCARD_NOBARRIER writes instead of reads', but didn't propose replacement
   text.
 - Figure out what to do about memory allocation.
 - Handle error returns from discard_prep.
 - Test the new code still works.
 - Delve into the latest SCSI spec and see if anything changed in UNMAP

Given the extensive length of the todo list, I shan't send out the mailbomb.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
