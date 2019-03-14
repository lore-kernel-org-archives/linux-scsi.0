From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 00/38] VFS: Convert trivial filesystems and more
Date: Thu, 14 Mar 2019 16:08:44 +0000
Message-ID: <155257972443.13720.11743171471060355965.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
Cc: Uma Krishnan <ukrishn-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, linux-aio-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Jason Wang <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, "Manoj N. Kumar" <manoj-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Stefano Stabellini <sstabellini-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Arve =?utf-8?b?SGrDuG5uZXbDpWc=?= <arve@androi>
List-Id: linux-scsi@vger.kernel.org


Hi Al,

Here's a set of patches that:

 (1) Provides a convenience member in struct fs_context that is OR'd into
     sb->s_iflags by sget_fc().

 (2) Provides a convenience vfs_init_pseudo_fs_context() helper function
     for doing most of the work in mounting a pseudo filesystem.

 (3) Converts all the trivial filesystems that have no arguments to
     fs_context.

 (4) Converts binderfs (which was trivial before January).

 (5) Converts ramfs, tmpfs, rootfs and devtmpfs.

 (6) Kills off mount_pseudo(), mount_pseudo_xattr(), mount_ns(),
     sget_userns().

The patches can be found here also:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git

on branch:

	mount-api-viro

David
---
David Howells (38):
      vfs: Provide sb->s_iflags settings in fs_context struct
      vfs: Provide a mount_pseudo-replacement for fs_context
      vfs: Convert aio to fs_context
      vfs: Convert anon_inodes to fs_context
      vfs: Convert bdev to fs_context
      vfs: Convert nsfs to fs_context
      vfs: Convert pipe to fs_context
      vfs: Convert zsmalloc to fs_context
      vfs: Convert sockfs to fs_context
      vfs: Convert dax to fs_context
      vfs: Convert drm to fs_context
      vfs: Convert ia64 perfmon to fs_context
      vfs: Convert cxl to fs_context
      vfs: Convert ocxlflash to fs_context
      vfs: Convert virtio_balloon to fs_context
      vfs: Convert btrfs_test to fs_context
      vfs: Kill off mount_pseudo() and mount_pseudo_xattr()
      vfs: Use sget_fc() for pseudo-filesystems
      vfs: Convert binderfs to fs_context
      vfs: Convert nfsctl to fs_context
      vfs: Convert rpc_pipefs to fs_context
      vfs: Kill off mount_ns()
      vfs: Kill sget_userns()
      vfs: Convert binfmt_misc to fs_context
      vfs: Convert configfs to fs_context
      vfs: Convert efivarfs to fs_context
      vfs: Convert fusectl to fs_context
      vfs: Convert qib_fs/ipathfs to fs_context
      vfs: Convert ibmasmfs to fs_context
      vfs: Convert oprofilefs to fs_context
      vfs: Convert gadgetfs to fs_context
      vfs: Convert xenfs to fs_context
      vfs: Convert openpromfs to fs_context
      vfs: Convert apparmorfs to fs_context
      vfs: Convert securityfs to fs_context
      vfs: Convert selinuxfs to fs_context
      vfs: Convert smackfs to fs_context
      tmpfs, devtmpfs, ramfs, rootfs: Convert to fs_context


 arch/ia64/kernel/perfmon.c         |   14 +
 drivers/android/binderfs.c         |  173 +++++++++-------
 drivers/base/devtmpfs.c            |   16 +
 drivers/dax/super.c                |   13 +
 drivers/gpu/drm/drm_drv.c          |   14 +
 drivers/infiniband/hw/qib/qib_fs.c |   26 ++
 drivers/misc/cxl/api.c             |   10 -
 drivers/misc/ibmasm/ibmasmfs.c     |   21 +-
 drivers/oprofile/oprofilefs.c      |   20 +-
 drivers/scsi/cxlflash/ocxl_hw.c    |   21 +-
 drivers/usb/gadget/legacy/inode.c  |   21 +-
 drivers/virtio/virtio_balloon.c    |   19 +-
 drivers/xen/xenfs/super.c          |   21 +-
 fs/aio.c                           |   15 +
 fs/anon_inodes.c                   |   12 +
 fs/binfmt_misc.c                   |   20 +-
 fs/block_dev.c                     |   14 +
 fs/btrfs/tests/btrfs-tests.c       |   13 +
 fs/configfs/mount.c                |   20 +-
 fs/efivarfs/super.c                |   20 +-
 fs/fuse/control.c                  |   20 +-
 fs/libfs.c                         |   91 ++++++--
 fs/nfsd/nfsctl.c                   |   33 ++-
 fs/nsfs.c                          |   13 +
 fs/openpromfs/inode.c              |   20 +-
 fs/pipe.c                          |   12 +
 fs/ramfs/inode.c                   |  104 ++++++---
 fs/super.c                         |  106 ++--------
 include/linux/fs.h                 |   21 --
 include/linux/fs_context.h         |    8 +
 include/linux/ramfs.h              |    6 -
 include/linux/shmem_fs.h           |    4 
 init/do_mounts.c                   |   12 -
 mm/shmem.c                         |  396 ++++++++++++++++++++++++------------
 mm/zsmalloc.c                      |   19 +-
 net/socket.c                       |   14 +
 net/sunrpc/rpc_pipe.c              |   34 ++-
 security/apparmor/apparmorfs.c     |   20 +-
 security/inode.c                   |   21 +-
 security/selinux/selinuxfs.c       |   20 +-
 security/smack/smackfs.c           |   34 ++-
 41 files changed, 902 insertions(+), 609 deletions(-)
