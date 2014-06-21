From: Theodore Ts'o <tytso@mit.edu>
Subject: 32-bit bug in iovec iterator changes
Date: Fri, 20 Jun 2014 23:51:44 -0400
Message-ID: <20140621035144.GA8526@thunk.org>
References: <20140619153550.GA12836@thunk.org>
 <53A308DE.7080000@fb.com>
 <20140619160801.GB4907@thunk.org>
 <20140619162144.GC4907@thunk.org>
 <20140619223820.GN4453@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50790 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754856AbaFUDvw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jun 2014 23:51:52 -0400
Content-Disposition: inline
In-Reply-To: <20140619223820.GN4453@dastard>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Jun 20, 2014 at 08:38:20AM +1000, Dave Chinner wrote:
> 
> Short reads are more likely a bug in all the iovec iterator stuff
> that got merged in from the vfs tree. ISTR a 32 bit-only bug in that
> stuff go past in to do with not being able to partition a 32GB block
> dev on a 32 bit system due to a 32 bit size_t overflow somewhere....

Dave Chinner called it.  

Al, I'm seeing a regression which shows up using a 32-bit x86 kernel.
The symptoms of the bug is when run under KVM, with a 5 GB /dev/vdc
virtual block device, a read at offset 2 ** 30 fails with a short
read:

# dd if=/dev/vdc of=/dev/null bs=4k skip=262144 count=1
0+0 records in
0+0 records out
0 bytes (0 B) copied, 0.0164144 s, 0.0 kB/s

On a 3.15 kernel, this command works:

# dd if=/dev/vdc of=/dev/null bs=4k skip=262144 count=1
1+0 records in
1+0 records out
4096 bytes (4.1 kB) copied, 0.0457984 s, 89.4 kB/s

I tried bisecting it, but unfortunately the iovec iterator changes are
not cleanly bisectable, since copy_page_from_iter() gets introduced
some two dozen patches before it gets defined.  :-(

However, the bisect leads quite squarely to to the iovec iterator
patches.

Al, I'd appreciate it if you could take a look?

Thanks!!

    		      	     	   	- Ted


% git bisect start
# good: [1860e379875dfe7271c649058aeddffe5afd9d0d] Linux 3.15
git bisect good 1860e379875dfe7271c649058aeddffe5afd9d0d
# bad: [7171511eaec5bf23fb06078f59784a3a0626b38f] Linux 3.16-rc1
git bisect bad 7171511eaec5bf23fb06078f59784a3a0626b38f
# good: [aaeb2554337217dfa4eac2fcc90da7be540b9a73] Merge branch 'v4l_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media into next
git bisect good aaeb2554337217dfa4eac2fcc90da7be540b9a73
# bad: [16b9057804c02e2d351e9c8f606e909b43cbd9e7] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
git bisect bad 16b9057804c02e2d351e9c8f606e909b43cbd9e7
# good: [82abb273d838318424644d8f02825db0fbbd400a] Merge branch 'upstream' of git://git.linux-mips.org/pub/scm/ralf/upstream-linus
git bisect good 82abb273d838318424644d8f02825db0fbbd400a
# good: [d1e1cda862c16252087374ac75949b0e89a5717e] Merge tag 'nfs-for-3.16-1' of git://git.linux-nfs.org/projects/trondmy/linux-nfs
git bisect good d1e1cda862c16252087374ac75949b0e89a5717e
# good: [23d4ed53b7342bf5999b3ea227d9f69e75e5a625] Merge branch 'for-linus' of git://git.kernel.dk/linux-block
git bisect good 23d4ed53b7342bf5999b3ea227d9f69e75e5a625
# good: [2840c566e95599cd60c7143762ca8b49d9395050] Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs
git bisect good 2840c566e95599cd60c7143762ca8b49d9395050
# good: [4251c2a67011801caecd63671f26dd8c9aedb24c] Merge tag 'modules-next-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux
git bisect good 4251c2a67011801caecd63671f26dd8c9aedb24c
# skip: [3dae8750c368f8ac11c3c8c2a28f56dcee865c01] cifs: switch to ->write_iter()
git bisect skip 3dae8750c368f8ac11c3c8c2a28f56dcee865c01
# good: [5c02c392cd2320e8d612376d6b72b6548a680923] Merge tag 'virtio-next-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux
git bisect good 5c02c392cd2320e8d612376d6b72b6548a680923
# bad: [5f073850602084fbcbb987948ff3e70ae273f7d2] kill generic_file_splice_write()
git bisect bad 5f073850602084fbcbb987948ff3e70ae273f7d2
# good: [38583f095c5a8138ae2a1c9173d0fd8a9f10e8aa] Merge branch 'akpm' (incoming from Andrew)
git bisect good 38583f095c5a8138ae2a1c9173d0fd8a9f10e8aa
# good: [f5ccfe1ddbaf9d923a3ebdadcb1e5e32d83e9c28] ext4: fix locking for O_APPEND writes
git bisect good f5ccfe1ddbaf9d923a3ebdadcb1e5e32d83e9c28
# bad: [f0d1bec9d58d4c038d0ac958c9af82be6eb18045] new helper: copy_page_from_iter()
git bisect bad f0d1bec9d58d4c038d0ac958c9af82be6eb18045


% (unset DISPLAY; git bisect visualize)
commit f0d1bec9d58d4c038d0ac958c9af82be6eb18045
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu Apr 3 15:05:18 2014 -0400

    new helper: copy_page_from_iter()
    
    parallel to copy_page_to_iter().  pipe_write() switched to it (and became
    ->write_iter()).
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 84c3d55cc474f9c234c023c92e2769f940d5548c
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu Apr 3 14:33:23 2014 -0400

    fuse: switch to ->write_iter()
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit b30ac0fc4109701fc122d41ee085c65b52dc44a3
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu Apr 3 14:29:04 2014 -0400

    btrfs: switch to ->write_iter()
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 3ef045c3d8ae8550abbfd44074efce6ff642cc86
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu Apr 3 14:25:22 2014 -0400

    ocfs2: switch to ->write_iter()
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit bf97f3bc0c32140c43fe5ca53d23514ea46a54ca
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu Apr 3 14:20:23 2014 -0400

    xfs: switch to ->write_iter()
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 50b5551d1719c8bce60c6d4027b814cfc72c2307
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu Apr 3 14:13:46 2014 -0400

    afs: switch to ->write_iter()
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit da56e45b6ee83b67a586c61819cd2b5cfd806eb8
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu Apr 3 14:11:01 2014 -0400

    gfs2: switch to ->write_iter()
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit edaf43694898c5d7deb9a394335c60e888039100
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu Apr 3 14:07:25 2014 -0400

    nfs: switch to ->write_iter()
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit f5674c31ee1f968606702e82c160d6ae11032ded
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu Apr 3 14:00:23 2014 -0400

    ubifs: switch to ->write_iter()
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit a8f3550cd228b6edc5d17fce1a9af8cc7004f185
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu Apr 3 03:32:25 2014 -0400

    bury __generic_file_aio_write()
    
    all users converted to __generic_file_write_iter() now
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 3dae8750c368f8ac11c3c8c2a28f56dcee865c01
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu Apr 3 12:05:17 2014 -0400

    cifs: switch to ->write_iter()
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit d4637bc18f3bf89bd63fe7b967043523aa3a6170
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu Apr 3 03:31:17 2014 -0400

    udf: switch to ->write_iter()
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 9b884164d59707216840159d45f6be68073fac6e
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu Apr 17 16:09:22 2014 -0400

    convert ext4 to ->write_iter()
    
    unfortunately, Ted's changes to ext4_file_write() are *still* an
    incomplete fix - playing with rlimits can let you smuggle an
    unaligned request past the checks.  So there almost certainly
    will be more merge PITA around that place...
    
    [fix from Peter Ujfalusi <peter.ujfalusi@ti.com> folded]
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit a8324754889c0a491b216bc0502ef9ba557eeac7
Merge: 1456c0a f5ccfe1
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Tue May 6 17:38:41 2014 -0400

    Merge ext4 changes in ext4_file_write() into for-next
    
    From ext4.git#dev, needed for switch of ext4 to ->write_iter() ;-/

commit 1456c0a87c4241d3a801651019e66983c69ad17d
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu Apr 3 03:21:50 2014 -0400

    blkdev_aio_write() - turn into blkdev_write_iter()
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 8174202b34c30e0c07231bf63f18ab29af634f0b
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu Apr 3 03:17:43 2014 -0400

    write_iter variants of {__,}generic_file_aio_write()
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 3644424dc6309439c4c8d97590cdac4100376255
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed Apr 2 20:28:01 2014 -0400

    ceph: switch to ->read_iter()
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 3aa2d199f8eb8149a88005e88736d583cbc39d31
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed Apr 2 20:14:12 2014 -0400

    nfs: switch to ->read_iter()
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit a886038baa48a17f2cf77fb5dcc204fd28659d8f
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed Apr 2 20:02:21 2014 -0400

    fs/block_dev.c: switch to ->read_iter()
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 2ba5bbed0cd7429dbd567fa885ae3bc7a76de3d4
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed Apr 2 20:00:02 2014 -0400

    shmem: switch to ->read_iter()
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit fb9096a344e2964c6a71520931c08abb1301248e
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed Apr 2 19:56:54 2014 -0400

    pipe: switch to ->read_iter()
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit e6a7bcb4c489e3e078ba3cc92ae6621b2b8bb9a7
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed Apr 2 19:53:36 2014 -0400

    cifs: switch to ->read_iter()
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 37c20f16e7a73e5fe34815e785ca6c5a46e4d260
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed Apr 2 14:47:09 2014 -0400

    fuse_file_aio_read(): convert to ->read_iter()
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 3cd9ad5a303a0d503492002c4af95becfa99af03
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed Apr 2 14:44:18 2014 -0400

    ocfs2: switch to ->read_iter()
    
    tracepoints are evil, exhibit #6969...
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 027978295d455b2fdff0cb36570f83ada7385ea6
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed Apr 2 14:40:38 2014 -0400

    ecryptfs: switch to ->read_iter()
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit b4f5d2c6d1f88c79e48f1296076b3a6a22f58c0f
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed Apr 2 14:37:59 2014 -0400

    xfs: switch to ->read_iter()
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit aad4f8bb42af06371aa0e85bf0cd9d52c0494985
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed Apr 2 14:33:16 2014 -0400

    switch simple generic_file_aio_read() users to ->read_iter()
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 293bc9822fa9b3c9d4b7893bcb241e085580771a
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Tue Feb 11 18:37:41 2014 -0500

    new methods: ->read_iter() and ->write_iter()
    
    Beginning to introduce those.  Just the callers for now, and it's
    clumsier than it'll eventually become; once we finish converting
    aio_read and aio_write instances, the things will get nicer.
    
    For now, these guys are in parallel to ->aio_read() and ->aio_write();
    they take iocb and iov_iter, with everything in iov_iter already
    validated.  File offset is passed in iocb->ki_pos, iov/nr_segs -
    in iov_iter.
    
    Main concerns in that series are stack footprint and ability to
    split the damn thing cleanly.
    
    [fix from Peter Ujfalusi <peter.ujfalusi@ti.com> folded]
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 7f7f25e82d54870df24d415a7007fbd327da027b
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Tue Feb 11 17:49:24 2014 -0500

    replace checking for ->read/->aio_read presence with check in ->f_mode
    
    Since we are about to introduce new methods (read_iter/write_iter), the
    tests in a bunch of places would have to grow inconveniently.  Check
    once (at open() time) and store results in ->f_mode as FMODE_CAN_READ
    and FMODE_CAN_WRITE resp.  It might end up being a temporary measure -
    once everything switches from ->aio_{read,write} to ->{read,write}_iter
    it might make sense to return to open-coded checks.  We'll see...
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit b318891929c2750055a4002bee3e7636ca3684de
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed Apr 2 07:06:30 2014 -0400

    xfs: trim the argument lists of xfs_file_{dio,buffered}_aio_write()
    
    pos is redundant (it's iocb->ki_pos), and iov/nr_segs/count are taken
    care of by lifting iov_iter into the caller.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 37938463540b075e9166cf774c59274379f7a8ca
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sat Mar 22 06:57:37 2014 -0400

    blkdev_aio_read(): switch to generic_file_read_iter(), get rid of iov_shorten()
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 0c949334a9e2581646c6ff0d1470a805b1e5be99
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sat Mar 22 06:51:37 2014 -0400

    iov_iter_truncate()
    
    Now It Can Be Done(tm) - we don't need to do iov_shorten() in
    generic_file_direct_write() anymore, now that all ->direct_IO()
    instances are converted to proper iov_iter methods and honour
    iter->count and iter->iov_offset properly.
    
    Get rid of count/ocount arguments of generic_file_direct_write(),
    while we are at it.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 28060d5d9b261da110afe48aae7a2aa6555f798f
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sat Mar 22 05:15:17 2014 -0400

    btrfs: switch check_direct_IO() to iov_iter
    
    ... and don't open-code iov_iter_alignment() there
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 91f79c43d1b54d7154b118860d81b39bad07dfff
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Fri Mar 21 04:58:33 2014 -0400

    new helper: iov_iter_get_pages_alloc()
    
    same as iov_iter_get_pages(), except that pages array is allocated
    (kmalloc if possible, vmalloc if that fails) and left for caller to
    free.  Lustre and NFS ->direct_IO() switched to it.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit f67da30c1d5fc9e341bc8121708874bfd7b31e45
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed Mar 19 01:16:16 2014 -0400

    new helper: iov_iter_npages()
    
    counts the pages covered by iov_iter, up to given limit.
    do_block_direct_io() and fuse_iter_npages() switched to
    it.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 5b46f25ddc6edf4adff1a137d453da542c27a640
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sun Mar 16 18:07:34 2014 -0400

    f2fs: switch to iov_iter_alignment()
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit c9c37e2e63786c595d704244cbb7d19dc5630493
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sun Mar 16 16:08:30 2014 -0400

    fuse: switch to iov_iter_get_pages()
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit d22a943f44c79c98ac7a93653fdd330378581741
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sun Mar 16 15:50:47 2014 -0400

    fuse: pull iov_iter initializations up
    
    ... to fuse_direct_{read,write}().  ->direct_IO() path uses the
    iov_iter passed by the caller instead.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 7b2c99d15559e285384c742db52316802e24b0bd
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sat Mar 15 04:05:57 2014 -0400

    new helper: iov_iter_get_pages()
    
    iov_iter_get_pages(iter, pages, maxsize, &start) grabs references pinning
    the pages of up to maxsize of (contiguous) data from iter.  Returns the
    amount of memory grabbed or -error.  In case of success, the requested
    area begins at offset start in pages[0] and runs through pages[1], etc.
    Less than requested amount might be returned - either because the contiguous
    area in the beginning of iterator is smaller than requested, or because
    the kernel failed to pin that many pages.
    
    direct-io.c switched to using iov_iter_get_pages()
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 3320c60b3a26d05666285c55ab08ee043c017ba3
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Mon Mar 10 02:30:55 2014 -0400

    dio: take updating ->result into do_direct_IO()
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 71d8e532b1549a478e6a6a8a44f309d050294d00
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed Mar 5 19:28:09 2014 -0500

    start adding the tag to iov_iter
    
    For now, just use the same thing we pass to ->direct_IO() - it's all
    iovec-based at the moment.  Pass it explicitly to iov_iter_init() and
    account for kvec vs. iovec in there, by the same kludge NFS ->direct_IO()
    uses.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit ed978a811ec528dbe40243605c3afab55892f722
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed Mar 5 22:53:04 2014 -0500

    new helper: generic_file_read_iter()
    
    iov_iter-using variant of generic_file_aio_read().  Some callers
    converted.  Note that it's still not quite there for use as ->read_iter() -
    we depend on having zero iter->iov_offset in O_DIRECT case.  Fortunately,
    that's true for all converted callers (and for generic_file_aio_read() itself).
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 23faa7b8db9be0be4f158cfc558460bb95d9b245
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed Mar 5 22:52:34 2014 -0500

    fuse_file_aio_write(): merge initializations of iov_iter
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 05bb2e0bc77cb005248be318d2b0ba369b8bbab3
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed Mar 5 19:22:23 2014 -0500

    ceph_aio_read(): keep iov_iter across retries
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 886a39115005ced8b15ab067c9c2a8d546b40a5e
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed Mar 5 13:50:45 2014 -0500

    new primitive: iov_iter_alignment()
    
    returns the value aligned as badly as the worst remaining segment
    in iov_iter is.  Use instead of open-coded equivalents.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 26978b8b4d83c46f4310b253db70fa9e65149e7c
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Mon Mar 10 14:08:45 2014 -0400

    give ->direct_IO() a copy of iov_iter
    
    the thing is, we want to advance what's given to ->direct_IO() as we
    are forming the request; however, the callers care about the amount
    of data actually transferred, not the amount we tried to transfer.
    It's more convenient to allow ->direct_IO() instances do use
    iov_iter_advance() on the copy of iov_iter, leaving the actual
    advancing of the original to caller.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 31b140398ce56ab41646eda7f02bcb78d6a4c916
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed Mar 5 01:33:16 2014 -0500

    switch {__,}blockdev_direct_IO() to iov_iter
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit a6cbcd4a4a85e2fdb0b3344b88df2e8b3d526b9e
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Tue Mar 4 22:38:00 2014 -0500

    get rid of pointless iov_length() in ->direct_IO()
    
    all callers have iov_length(iter->iov, iter->nr_segs) == iov_iter_count(iter)
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 16b1f05d7f5ab4ce570963aca5f3b2b5d21822fa
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Tue Mar 4 22:14:00 2014 -0500

    ext4: switch the guts of ->direct_IO() to iov_iter
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 619d30b4b8c488042b4a720ca79dccc346d1a516
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Tue Mar 4 21:53:33 2014 -0500

    convert the guts of nfs_direct_IO() to iov_iter
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit d8d3d94b80aa1a1c0ca75c58b8abdc7356f38418
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Tue Mar 4 21:27:34 2014 -0500

    pass iov_iter to ->direct_IO()
    
    unmodified, for now
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit cb66a7a1f149ff705fa37cad6d1252b046e0ad4f
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Tue Mar 4 15:24:06 2014 -0500

    kill generic_segment_checks()
    
    all callers of ->aio_read() and ->aio_write() have iov/nr_segs already
    checked - generic_segment_checks() done after that is just an odd way
    to spell iov_length().
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 0ae5e4d370599592eab845527b31708a4f3411be
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Mon Mar 3 22:09:39 2014 -0500

    __btrfs_direct_write(): switch to iov_iter
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit f8579f8673b7ecdb7a81d5d5bb1d981093d9aa94
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Mon Mar 3 22:03:20 2014 -0500

    generic_file_direct_write(): switch to iov_iter
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit e7c24607b5d68a4cdc56e09d70a3c8bae5f0519f
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu Apr 10 20:54:51 2014 -0400

    kill iov_iter_copy_from_user()
    
    all callers can use copy_page_from_iter() and it actually simplifies
    them.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit f6c0a1920e0180175bd5e8e4aff8ea5556f1895d
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed Apr 23 10:18:46 2014 -0400

    fs/file.c: don't open-code kvfree()
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
