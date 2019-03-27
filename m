From: David Howells <dhowells@redhat.com>
Subject: [RFC PATCH 00/68] VFS: Convert a bunch of filesystems to the new
	mount API
Date: Wed, 27 Mar 2019 23:40:00 +0000
Message-ID: <155372999953.7602.13784796495137723805.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: viro@zeniv.linux.org.uk
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, "Rafael J. Wysocki" <rafael@kernel.org>, dri-devel@lists.freedesktop.org, "J. Bruce Fields" <bfields@fieldses.org>, ceph-devel@vger.kernel.org, Mike Marshall <hubcap@omnibond.com>, xen-devel@lists.xenproject.org, devel@lists.orangefs.org, Felipe Balbi <balbi@kernel.org>, Uma Krishnan <ukrishn@linux.ibm.com>, "Manoj N. Kumar" <manoj@linux.ibm.com>, Joel Becker <jlbec@evilplan.org>, Trond Myklebust <trond.myklebust@hammerspace.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, Arve =?utf-8?b?SGrDuG5uZXbDpWc=?= <arve@android.com>, Frederic Barrat <fbarrat@linux.ibm.com>, Martin Brandenburg <martin@omnibond.com>, linux-ia64@vger.kernel.org, David Airlie <airlied@linux.ie>, virtualization@lists.linux-foundation.o
List-Id: linux-scsi@vger.kernel.org


Hi Al,

Here's a set of patches that converts a bunch (but not yet all!) to the new
mount API.  To this end, it makes the following changes:

 (1) Provides a convenience member in struct fs_context that is OR'd into
     sb->s_iflags by sget_fc().

 (2) Provides a convenience helper function, vfs_init_pseudo_fs_context(),
     for doing most of the work in mounting a pseudo filesystem.

 (3) Provides a convenience helper function, vfs_get_block_super(), for
     doing the work in setting up a block-based superblock.

 (4) Improves the handling of fd-type parameters.

 (5) Moves some of the subtype handling int fuse.

 (6) Provides a convenience helper function, vfs_get_mtd_super(), for
     doing the work in setting up an MTD device-based superblock.

 (7) Kills off mount_pseudo(), mount_pseudo_xattr(), mount_ns(),
     sget_userns(), mount_mtd(), mount_single().

 (8) Converts a slew of filesystems to use the mount API.

 (9) Fixes a bug in hypfs.

The patches can be found here also:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git

on branch:

	mount-api-viro

David
---
Andrew Price (1):
      gfs2: Convert gfs2 to fs_context

David Howells (66):
      vfs: Update mount API docs
      vfs: Fix refcounting of filenames in fs_parser
      vfs: Provide sb->s_iflags settings in fs_context struct
      vfs: Provide a mount_pseudo-replacement for the new mount API
      vfs: Convert aio to use the new mount API
      vfs: Convert anon_inodes to use the new mount API
      vfs: Convert bdev to use the new mount API
      vfs: Convert nsfs to use the new mount API
      vfs: Convert pipe to use the new mount API
      vfs: Convert zsmalloc to use the new mount API
      vfs: Convert sockfs to use the new mount API
      vfs: Convert dax to use the new mount API
      vfs: Convert drm to use the new mount API
      vfs: Convert ia64 perfmon to use the new mount API
      vfs: Convert cxl to use the new mount API
      vfs: Convert ocxlflash to use the new mount API
      vfs: Convert virtio_balloon to use the new mount API
      vfs: Convert btrfs_test to use the new mount API
      vfs: Kill off mount_pseudo() and mount_pseudo_xattr()
      vfs: Use sget_fc() for pseudo-filesystems
      vfs: Convert binderfs to use the new mount API
      vfs: Convert nfsctl to use the new mount API
      vfs: Convert rpc_pipefs to use the new mount API
      vfs: Kill mount_ns()
      vfs: Kill sget_userns()
      vfs: Convert binfmt_misc to use the new mount API
      vfs: Convert configfs to use the new mount API
      vfs: Convert efivarfs to use the new mount API
      vfs: Convert fusectl to use the new mount API
      vfs: Convert qib_fs/ipathfs to use the new mount API
      vfs: Convert ibmasmfs to use the new mount API
      vfs: Convert oprofilefs to use the new mount API
      vfs: Convert gadgetfs to use the new mount API
      vfs: Convert xenfs to use the new mount API
      vfs: Convert openpromfs to use the new mount API
      vfs: Convert apparmorfs to use the new mount API
      vfs: Convert securityfs to use the new mount API
      vfs: Convert selinuxfs to use the new mount API
      vfs: Convert smackfs to use the new mount API
      vfs: Convert ramfs, shmem, tmpfs, devtmpfs, rootfs to use the new mount API
      vfs: Create fs_context-aware mount_bdev() replacement
      vfs: Make fs_parse() handle fs_param_is_fd-type params better
      vfs: Convert fuse to use the new mount API
      vfs: Move the subtype parameter into fuse
      mtd: Provide fs_context-aware mount_mtd() replacement
      vfs: Convert romfs to use the new mount API
      vfs: Convert cramfs to use the new mount API
      vfs: Convert jffs2 to use the new mount API
      mtd: Kill mount_mtd()
      vfs: Convert squashfs to use the new mount API
      vfs: Convert ceph to use the new mount API
      vfs: Convert functionfs to use the new mount API
      vfs: Add a single-or-reconfig keying to vfs_get_super()
      vfs: Convert debugfs to use the new mount API
      vfs: Convert tracefs to use the new mount API
      vfs: Convert pstore to use the new mount API
      hypfs: Fix error number left in struct pointer member
      vfs: Convert hypfs to use the new mount API
      vfs: Convert spufs to use the new mount API
      vfs: Kill mount_single()
      vfs: Convert coda to use the new mount API
      vfs: Convert autofs to use the new mount API
      vfs: Convert devpts to use the new mount API
      vfs: Convert bpf to use the new mount API
      vfs: Convert ubifs to use the new mount API
      vfs: Convert orangefs to use the new mount API

Masahiro Yamada (1):
      kbuild: skip sub-make for in-tree build with GNU Make 4.x


 Documentation/filesystems/mount_api.txt   |  367 ++++++++-------
 Documentation/filesystems/vfs.txt         |    4 
 Makefile                                  |   31 +
 arch/ia64/kernel/perfmon.c                |   14 -
 arch/powerpc/platforms/cell/spufs/inode.c |  207 +++++----
 arch/s390/hypfs/inode.c                   |  137 +++---
 drivers/android/binderfs.c                |  173 ++++---
 drivers/base/devtmpfs.c                   |   16 -
 drivers/block/rbd.c                       |  363 ++++++++-------
 drivers/dax/super.c                       |   13 -
 drivers/gpu/drm/drm_drv.c                 |   14 -
 drivers/infiniband/hw/qib/qib_fs.c        |   26 +
 drivers/misc/cxl/api.c                    |   10 
 drivers/misc/ibmasm/ibmasmfs.c            |   21 +
 drivers/mtd/mtdcore.h                     |    1 
 drivers/mtd/mtdsuper.c                    |  181 ++++----
 drivers/oprofile/oprofilefs.c             |   20 +
 drivers/scsi/cxlflash/ocxl_hw.c           |   21 -
 drivers/usb/gadget/function/f_fs.c        |  233 +++++-----
 drivers/usb/gadget/legacy/inode.c         |   21 +
 drivers/virtio/virtio_balloon.c           |   19 -
 drivers/xen/xenfs/super.c                 |   21 +
 fs/aio.c                                  |   15 -
 fs/anon_inodes.c                          |   12 
 fs/autofs/autofs_i.h                      |   13 -
 fs/autofs/init.c                          |    9 
 fs/autofs/inode.c                         |  429 ++++++++++--------
 fs/binfmt_misc.c                          |   20 +
 fs/block_dev.c                            |   14 -
 fs/btrfs/tests/btrfs-tests.c              |   13 -
 fs/ceph/cache.c                           |    9 
 fs/ceph/cache.h                           |    5 
 fs/ceph/super.c                           |  697 ++++++++++++++---------------
 fs/ceph/super.h                           |    1 
 fs/coda/inode.c                           |  171 +++++--
 fs/configfs/mount.c                       |   20 +
 fs/cramfs/inode.c                         |   69 ++-
 fs/debugfs/inode.c                        |  186 ++++----
 fs/devpts/inode.c                         |  265 +++++------
 fs/efivarfs/super.c                       |   20 +
 fs/fs_context.c                           |   16 -
 fs/fs_parser.c                            |   18 +
 fs/fuse/control.c                         |   20 +
 fs/fuse/inode.c                           |  291 +++++++-----
 fs/gfs2/incore.h                          |    8 
 fs/gfs2/ops_fstype.c                      |  495 ++++++++++++++++-----
 fs/gfs2/super.c                           |  335 --------------
 fs/gfs2/super.h                           |    3 
 fs/jffs2/fs.c                             |   21 -
 fs/jffs2/os-linux.h                       |    4 
 fs/jffs2/super.c                          |  172 +++----
 fs/libfs.c                                |   91 +++-
 fs/nfsd/nfsctl.c                          |   33 +
 fs/nsfs.c                                 |   13 -
 fs/openpromfs/inode.c                     |   20 +
 fs/orangefs/orangefs-kernel.h             |    8 
 fs/orangefs/orangefs-mod.c                |    3 
 fs/orangefs/super.c                       |  186 ++++----
 fs/pipe.c                                 |   12 
 fs/pstore/inode.c                         |  109 +++--
 fs/ramfs/inode.c                          |  104 +++-
 fs/romfs/super.c                          |   46 +-
 fs/squashfs/super.c                       |  100 ++--
 fs/super.c                                |  301 ++++++-------
 fs/tracefs/inode.c                        |  180 +++----
 fs/ubifs/super.c                          |  447 ++++++++-----------
 include/linux/ceph/ceph_debug.h           |    1 
 include/linux/ceph/libceph.h              |   17 +
 include/linux/fs.h                        |   24 -
 include/linux/fs_context.h                |   20 +
 include/linux/mtd/super.h                 |    6 
 include/linux/ramfs.h                     |    6 
 include/linux/shmem_fs.h                  |    4 
 init/do_mounts.c                          |   12 
 kernel/bpf/inode.c                        |   92 ++--
 mm/shmem.c                                |  396 +++++++++++-----
 mm/zsmalloc.c                             |   19 -
 net/ceph/ceph_common.c                    |  410 +++++++----------
 net/socket.c                              |   14 -
 net/sunrpc/rpc_pipe.c                     |   34 +
 security/apparmor/apparmorfs.c            |   20 +
 security/inode.c                          |   21 +
 security/selinux/selinuxfs.c              |   20 +
 security/smack/smackfs.c                  |   34 +
 84 files changed, 4257 insertions(+), 3810 deletions(-)
