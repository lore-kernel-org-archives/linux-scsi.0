From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation
	problem
Date: Fri, 11 Mar 2011 10:51:18 -0800
Message-ID: <20110311185118.GB1110@tux1.beaverton.ibm.com>
References: <20110223202446.GG4020@noexit> <1298493173-sup-8301@think> <20110224164758.GH23042@quack.suse.cz> <1298566775-sup-730@think> <20110224182732.GV27190@tux1.beaverton.ibm.com> <1298897186-sup-9394@think> <20110304210724.GF27190@tux1.beaverton.ibm.com> <20110308045626.GD1956@dastard> <20110310235722.GA1110@tux1.beaverton.ibm.com> <1299860233-sup-4443@think>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1299860233-sup-4443@think>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Joel Becker <jlbec@evilplan.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Mingming Cao <mcao@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 11, 2011 at 11:34:05AM -0500, Chris Mason wrote:
> Excerpts from Darrick J. Wong's message of 2011-03-10 18:57:22 -0500:
> > On Tue, Mar 08, 2011 at 03:56:26PM +1100, Dave Chinner wrote:
> > 
> > > On Fri, Mar 04, 2011 at 01:07:24PM -0800, Darrick J. Wong wrote:
> > > > On Mon, Feb 28, 2011 at 07:54:05AM -0500, Chris Mason wrote:
> > > > > Excerpts from Darrick J. Wong's message of 2011-02-24 13:27:32 -0500:
> > > > > > On Thu, Feb 24, 2011 at 12:37:53PM -0500, Chris Mason wrote:
> > > > > > > Excerpts from Jan Kara's message of 2011-02-24 11:47:58 -0500:
> > > > > > > > On Wed 23-02-11 15:35:11, Chris Mason wrote:
> > > > > > > > > Excerpts from Joel Becker's message of 2011-02-23 15:24:47 -0500:
> > > > > > > > > > On Tue, Feb 22, 2011 at 11:45:44AM -0500, Martin K. Petersen wrote:
> > > > > > > > > > > Also, DIX is only the tip of the iceberg. Many other impending
> > > > > > > > > > > technologies feature checksums and require pages to be stable during I/O
> > > > > > > > > > > due to checksumming, encryption and so on.
> > > > > > > > > > > 
> > > > > > > > > > > The VM is already trying to do the right thing. We just need the
> > > > > > > > > > > relevant filesystems to catch up.
> > > > > > > > > > 
> > > > > > > > > >     ocfs2 handles stable metadata for its checksums when feeding
> > > > > > > > > > things to the journal.  If we're doing pagecache-based I/O, is the
> > > > > > > > > > pagecache going to help here for data?
> > > > > > > > > 
> > > > > > > > > Data is much easier than metadata.  All you really need is to wait on
> > > > > > > > > writeback in file_write, wait on writeback in page_mkwrite, and make
> > 
> > Hrm... I've been looking for a file_write in ext4; was the aio_write function
> > pointer what you had in mind here?
> 
> Your change to grab_cache_page_write_begin looks good to me, at least
> for ext4.  For ext3 you have to actually go in and wait for each of the
> buffer heads in the page, since ext3 (and reiserfs) will write the buffer heads
> directly without using writepage.

Heh, I hadn't really given much thought to ext2/3 yet.  I'm still trying to
figure out what causes the occasional ext4 failures. :)

> Have you confirmed by looking at the block mapping that your crc errors
> are from data blocks?

Yes, debugfs confirms that they are data blocks.

--D
