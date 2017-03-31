From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0/3] Improve block device testing coverage
Date: Fri, 31 Mar 2017 09:08:35 -0700
Message-ID: <20170331160835.GA10881@birch.djwong.org>
References: <1490879944-26240-1-git-send-email-dmonakhov@openvz.org>
 <20170331065702.GA17435@infradead.org>
 <8760ip28o8.fsf@dmlp.sw.ru>
 <20170331093801.GK22845@eguan.usersys.redhat.com>
 <8737dt228x.fsf@dmlp.sw.ru>
 <1490973067.2587.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1490973067.2587.1.camel@sandisk.com>
Sender: fstests-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "eguan@redhat.com" <eguan@redhat.com>, "dmonakhov@openvz.org" <dmonakhov@openvz.org>, "fstests@vger.kernel.org" <fstests@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 31, 2017 at 03:11:28PM +0000, Bart Van Assche wrote:
> On Fri, 2017-03-31 at 13:02 +0300, Dmitry Monakhov wrote:
> > Another good example may be a bug with dirty page cache after blkdiscard
> > https://lkml.org/lkml/2017/3/22/789 . This simple bug  result in crappy
> > fsimage if mkfs relay on discard_zeroes_data behaviour.
> > So IMHO basic blkdev test coverage is important filesystem testing. i.e.
> > important for xfstests.
> 
> Mixing up filesystem tests and block layer / block driver tests in the same
> directory is completely wrong. Block driver developers will be primarily
> interested in the block tests and may want to skip the filesystem tests.
> Filesystem developers will probably run the block tests only once and will
> likely run the filesystem tests repeatedly. Mixing up different kinds of
> tests in the same directory makes it unnecessarily hard to run block and
> filesystem tests separately.

During LSF I had started to wonder if we should just create a new
FSTYP=blockdev fs type with a no-op mkfs & mount.  "_require_fs generic"
could be taught to ignore FSTYP=blockdev; blockdev tests that should
work on all block devices can stay in tests/generic, and blockdev tests
that require specific features or complicated setup can go in
tests/blockdev.

The benefit (for the fs developers, anyway) of having complex block
device setup code helper functions in common/ is that then we can also
start writing tests to see how the fs reacts with more complex storage
setups.  We already have some of that for dm_{thin,flakey,delay,error}.

That way we keep the tests together and make it easy to run them (when
applicable) as part of regular fs testing, and avoid the situation where
bdevtests and xfstests slowly drift apart in terms of behaviors and
command line switches.

The downside ofc is the potential for bloat. :)

(The blockdev fallocate tests fit the fs/block split awkwardly --
they call what is nominally a fs feature on something that isn't itself
a filesystem...)

<shrug> Just my 5c.

--D

> 
> Bart.--
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
