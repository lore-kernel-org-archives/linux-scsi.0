From: Christoph Hellwig <hch@lst.de>
Subject: READ_META semantics, was Re: [RFC] relaxed barrier semantics
Date: Wed, 28 Jul 2010 11:35:32 +0200
Message-ID: <20100728093532.GA11862@lst.de>
References: <20100727175418.GF6820@quack.suse.cz> <20100727183546.GG7347@redhat.com> <4C4FE58C.8080403@kernel.org> <20100728082447.GA7668@lst.de> <4C4FECFE.9040509@kernel.org> <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de> <4C4FF42C.1050701@suse.de> <1280309335.2502.14.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1280309335.2502.14.camel@localhost>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Steven Whitehouse <steve@chygwyn.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 28, 2010 at 10:28:55AM +0100, Steven Whitehouse wrote:
> The META tag is used in GFS2 for tagging all metadata whether to the
> journal or otherwise. Is there some reason why this isn't correct? My
> understanding was that it was more or less an informational hint to
> those watching blktrace,

Unfortunately the META flag is overloaded in the CFQ I/O scheduler.
It gives META requests a boost over other, including synchronous
request.  From all I could gather so far it's intended to give
desktops better interactivity by boosting some metadata reads, while
it should in that form never be used for writes.

So far I failed badly in getting a clarification of which read requests
need to be tagged and if we should not apply this boost to write request
marked META so that they can be used for blktrace tagging.  Unless
we really want to boost all reads separating the META from the BOOST
flag might be a good option, but I really need to understand better
how it's supposed to use.

Except for gfs2 big hammer tagging it's used in ext3/ext4 for all
reads on directories, the quota file and for reading the actual inode
structure.  It's not used for indirect blocks, symlinks, the superblock
and allocation bitmaps.

XFS appears to set the META flag for both reads and writes, but that
code is unreachable currently.  I haven't removed it yet as I'm still
wondering if it could be used correctly instead.
