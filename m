From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [PATCHSET v3.1 0/7] data integrity: Stabilize pages during writeback for various fses
Date: Wed, 11 May 2011 00:24:58 +0900
Message-ID: <87aaeur31x.fsf@devron.myhome.or.jp>
References: <20110509230318.19566.66202.stgit@elm3c44.beaverton.ibm.com>
	<87tyd31fkc.fsf@devron.myhome.or.jp>
	<20110510133603.GA5823@infradead.org>
	<874o524q9h.fsf@devron.myhome.or.jp>
	<20110510144939.GI4402@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <20110510144939.GI4402@quack.suse.cz> (Jan Kara's message of
	"Tue, 10 May 2011 16:49:39 +0200")
Sender: linux-ext4-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <djwong@us.ibm.com>, Theodore Tso <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jeff Layton <jlayton@redhat.com>, Dave Chinner <david@fromorbit.com>, linux-kernel <linux-kernel@vger.kernel.org>, Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org, Chris Mason <chris.mason@oracle.com>, Joel Becker <jlbec@evilplan.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org, Mingming Cao <mcao@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>> Isn't it reallocated blocks too, and metadata too?
>   Reallocated blocks - not really. For a block to be freed it cannot be
> under writeback and when it's freed no writeback is started.

Sure for data -> data reallocated case. metadata -> data/metadata is
still there.

> For metadata - yes. But ext3, ext4, xfs, btrfs have to avoid modifying
> metadata under writeback anyway (because of journalling / COW
> constraints) and thus they don't care.

Yes. Those would use better way than just blocking.

> For ext2 or vfat it's a different story. But as I wrote to Darrick,
> I'm not sure about vfat but for ext2 and similar legacy filesystems,
> I'd rather let them live with their unstable pages under IO ;) because
> I see a limited use for that.

If this patches was not going to tackle it, I have no argument here ;)
It would be simply FS specific approach/fixes anymore like journal.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
