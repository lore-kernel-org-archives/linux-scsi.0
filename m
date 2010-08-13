From: Sage Weil <sage@newdream.net>
Subject: [PATCH 0/8] rados block device and ceph refactor
Date: Fri, 13 Aug 2010 10:40:32 -0700
Message-ID: <1281721240-26130-1-git-send-email-sage@newdream.net>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: ceph-devel@vger.kernel.org, hch@lst.de, akpm@linux-foundation.org, yehuda@hq.newdream.net, Sage Weil <sage@newdream.net>
List-Id: linux-scsi@vger.kernel.org

Hi,

The rados block device (rbd) implements a network block device backed by 
the Ceph distributed object store (think nbd/iSCSI, but distributed and 
fault tolerant).  At the suggestion of Christoph and James, this version 
of the patchset factors out the common Ceph bits (the network protocol, 
cluster membership, and object storage parts) into a libceph module 
(currently in net/ceph/ and include/linux/ceph/) that is shared by the 
file system component (fs/ceph) and rbd (drivers/block/rbd.c). The first 
few patches lay some groundwork, #7 moves does the ceph -> libceph+ceph 
split, and #8 adds the block device driver.

The block device code has been in linux-next for a while, but it could 
use some review by someone more familiar with the block layer. The rbd 
code is originally based on osdblk, and has a similar sysfs interface 
(rbd also supports snapshots, so there are a few more knobs for that).

Two questions --

1- Are net/ceph/ and include/linux/ceph/ appropriate locations for the 
libceph code?  (It seemed more similar to other net/ residents than the 
stuff in lib/.)

2- Do I need an explicit ACK from any block people before sending this 
to Linus?  Carrying/rebasing the refactoring patch out of tree will be 
tedious, so I would like to push it sooner rather than later.

Thanks!
sage

PS This code is also available in git at

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git rbd

---

Sage Weil (1):
  ceph: factor out libceph from Ceph file system

Yehuda Sadeh (7):
  ceph-rbd: lookup pool in osdmap by name
  ceph-rbd: refactor osdc requests creation functions
  ceph-rbd: messenger and osdc changes for rbd
  ceph-rbd: enable creation of clients that don't need mds
  ceph-rbd: refactor mount related functions, add helpers
  ceph-rbd: osdc support for osd call and rollback operations
  rbd: introduce rados block device (rbd), based on libceph

 MAINTAINERS                       |   11 +
 drivers/block/Kconfig             |   13 +
 drivers/block/Makefile            |    1 +
 drivers/block/rbd.c               | 1844 ++++++++++++++++++++++++++++
 drivers/block/rbd_types.h         |   73 ++
 fs/ceph/Kconfig                   |   14 +-
 fs/ceph/Makefile                  |   11 +-
 fs/ceph/README                    |   20 -
 fs/ceph/addr.c                    |   65 +-
 fs/ceph/armor.c                   |  103 --
 fs/ceph/auth.c                    |  259 ----
 fs/ceph/auth.h                    |   92 --
 fs/ceph/auth_none.c               |  131 --
 fs/ceph/auth_none.h               |   30 -
 fs/ceph/auth_x.c                  |  684 -----------
 fs/ceph/auth_x.h                  |   49 -
 fs/ceph/auth_x_protocol.h         |   90 --
 fs/ceph/buffer.c                  |   65 -
 fs/ceph/buffer.h                  |   39 -
 fs/ceph/caps.c                    |   35 +-
 fs/ceph/ceph_debug.h              |   37 -
 fs/ceph/ceph_frag.c               |    3 +-
 fs/ceph/ceph_frag.h               |  109 --
 fs/ceph/ceph_fs.c                 |   72 --
 fs/ceph/ceph_fs.h                 |  728 -----------
 fs/ceph/ceph_hash.c               |  118 --
 fs/ceph/ceph_hash.h               |   13 -
 fs/ceph/ceph_strings.c            |  193 ---
 fs/ceph/crush/crush.c             |  151 ---
 fs/ceph/crush/crush.h             |  180 ---
 fs/ceph/crush/hash.c              |  149 ---
 fs/ceph/crush/hash.h              |   17 -
 fs/ceph/crush/mapper.c            |  609 ---------
 fs/ceph/crush/mapper.h            |   20 -
 fs/ceph/crypto.c                  |  412 -------
 fs/ceph/crypto.h                  |   48 -
 fs/ceph/debugfs.c                 |  407 ++-----
 fs/ceph/decode.h                  |  196 ---
 fs/ceph/dir.c                     |   55 +-
 fs/ceph/export.c                  |    5 +-
 fs/ceph/file.c                    |  207 +---
 fs/ceph/inode.c                   |   19 +-
 fs/ceph/ioctl.c                   |   11 +-
 fs/ceph/locks.c                   |    6 +-
 fs/ceph/mds_client.c              |   85 +-
 fs/ceph/mds_client.h              |   20 +-
 fs/ceph/mdsmap.c                  |   11 +-
 fs/ceph/mdsmap.h                  |   62 -
 fs/ceph/messenger.c               | 2277 ----------------------------------
 fs/ceph/messenger.h               |  253 ----
 fs/ceph/mon_client.c              | 1018 ---------------
 fs/ceph/mon_client.h              |  121 --
 fs/ceph/msgpool.c                 |   64 -
 fs/ceph/msgpool.h                 |   25 -
 fs/ceph/msgr.h                    |  175 ---
 fs/ceph/osd_client.c              | 1539 -----------------------
 fs/ceph/osd_client.h              |  167 ---
 fs/ceph/osdmap.c                  | 1110 -----------------
 fs/ceph/osdmap.h                  |  128 --
 fs/ceph/pagelist.c                |   55 -
 fs/ceph/pagelist.h                |   54 -
 fs/ceph/rados.h                   |  405 ------
 fs/ceph/snap.c                    |   10 +-
 fs/ceph/strings.c                 |  117 ++
 fs/ceph/super.c                   | 1154 +++++++----------
 fs/ceph/super.h                   |  397 +++----
 fs/ceph/types.h                   |   29 -
 fs/ceph/xattr.c                   |   15 +-
 include/linux/ceph/auth.h         |   92 ++
 include/linux/ceph/buffer.h       |   39 +
 include/linux/ceph/ceph_debug.h   |   37 +
 include/linux/ceph/ceph_frag.h    |  109 ++
 include/linux/ceph/ceph_fs.h      |  728 +++++++++++
 include/linux/ceph/ceph_hash.h    |   13 +
 include/linux/ceph/crush/crush.h  |  180 +++
 include/linux/ceph/crush/hash.h   |   17 +
 include/linux/ceph/crush/mapper.h |   20 +
 include/linux/ceph/debugfs.h      |   33 +
 include/linux/ceph/decode.h       |  201 +++
 include/linux/ceph/libceph.h      |  249 ++++
 include/linux/ceph/mdsmap.h       |   62 +
 include/linux/ceph/messenger.h    |  261 ++++
 include/linux/ceph/mon_client.h   |  122 ++
 include/linux/ceph/msgpool.h      |   25 +
 include/linux/ceph/msgr.h         |  175 +++
 include/linux/ceph/osd_client.h   |  234 ++++
 include/linux/ceph/osdmap.h       |  130 ++
 include/linux/ceph/pagelist.h     |   54 +
 include/linux/ceph/rados.h        |  405 ++++++
 include/linux/ceph/types.h        |   29 +
 net/Kconfig                       |    1 +
 net/Makefile                      |    1 +
 net/ceph/Kconfig                  |   27 +
 net/ceph/Makefile                 |   37 +
 net/ceph/armor.c                  |  103 ++
 net/ceph/auth.c                   |  259 ++++
 net/ceph/auth_none.c              |  132 ++
 net/ceph/auth_none.h              |   29 +
 net/ceph/auth_x.c                 |  685 +++++++++++
 net/ceph/auth_x.h                 |   50 +
 net/ceph/auth_x_protocol.h        |   90 ++
 net/ceph/buffer.c                 |   68 +
 net/ceph/ceph_common.c            |  529 ++++++++
 net/ceph/ceph_fs.c                |   75 ++
 net/ceph/ceph_hash.c              |  118 ++
 net/ceph/ceph_strings.c           |   84 ++
 net/ceph/crush/crush.c            |  151 +++
 net/ceph/crush/hash.c             |  149 +++
 net/ceph/crush/mapper.c           |  609 +++++++++
 net/ceph/crypto.c                 |  412 +++++++
 net/ceph/crypto.h                 |   48 +
 net/ceph/debugfs.c                |  268 ++++
 net/ceph/messenger.c              | 2453 +++++++++++++++++++++++++++++++++++++
 net/ceph/mon_client.c             | 1027 ++++++++++++++++
 net/ceph/msgpool.c                |   64 +
 net/ceph/osd_client.c             | 1773 +++++++++++++++++++++++++++
 net/ceph/osdmap.c                 | 1128 +++++++++++++++++
 net/ceph/pagelist.c               |   57 +
 net/ceph/pagevec.c                |  223 ++++
 119 files changed, 16847 insertions(+), 13703 deletions(-)
 create mode 100644 drivers/block/rbd.c
 create mode 100644 drivers/block/rbd_types.h
 delete mode 100644 fs/ceph/README
 delete mode 100644 fs/ceph/armor.c
 delete mode 100644 fs/ceph/auth.c
 delete mode 100644 fs/ceph/auth.h
 delete mode 100644 fs/ceph/auth_none.c
 delete mode 100644 fs/ceph/auth_none.h
 delete mode 100644 fs/ceph/auth_x.c
 delete mode 100644 fs/ceph/auth_x.h
 delete mode 100644 fs/ceph/auth_x_protocol.h
 delete mode 100644 fs/ceph/buffer.c
 delete mode 100644 fs/ceph/buffer.h
 delete mode 100644 fs/ceph/ceph_debug.h
 delete mode 100644 fs/ceph/ceph_frag.h
 delete mode 100644 fs/ceph/ceph_fs.c
 delete mode 100644 fs/ceph/ceph_fs.h
 delete mode 100644 fs/ceph/ceph_hash.c
 delete mode 100644 fs/ceph/ceph_hash.h
 delete mode 100644 fs/ceph/ceph_strings.c
 delete mode 100644 fs/ceph/crush/crush.c
 delete mode 100644 fs/ceph/crush/crush.h
 delete mode 100644 fs/ceph/crush/hash.c
 delete mode 100644 fs/ceph/crush/hash.h
 delete mode 100644 fs/ceph/crush/mapper.c
 delete mode 100644 fs/ceph/crush/mapper.h
 delete mode 100644 fs/ceph/crypto.c
 delete mode 100644 fs/ceph/crypto.h
 delete mode 100644 fs/ceph/decode.h
 delete mode 100644 fs/ceph/mdsmap.h
 delete mode 100644 fs/ceph/messenger.c
 delete mode 100644 fs/ceph/messenger.h
 delete mode 100644 fs/ceph/mon_client.c
 delete mode 100644 fs/ceph/mon_client.h
 delete mode 100644 fs/ceph/msgpool.c
 delete mode 100644 fs/ceph/msgpool.h
 delete mode 100644 fs/ceph/msgr.h
 delete mode 100644 fs/ceph/osd_client.c
 delete mode 100644 fs/ceph/osd_client.h
 delete mode 100644 fs/ceph/osdmap.c
 delete mode 100644 fs/ceph/osdmap.h
 delete mode 100644 fs/ceph/pagelist.c
 delete mode 100644 fs/ceph/pagelist.h
 delete mode 100644 fs/ceph/rados.h
 create mode 100644 fs/ceph/strings.c
 delete mode 100644 fs/ceph/types.h
 create mode 100644 include/linux/ceph/auth.h
 create mode 100644 include/linux/ceph/buffer.h
 create mode 100644 include/linux/ceph/ceph_debug.h
 create mode 100644 include/linux/ceph/ceph_frag.h
 create mode 100644 include/linux/ceph/ceph_fs.h
 create mode 100644 include/linux/ceph/ceph_hash.h
 create mode 100644 include/linux/ceph/crush/crush.h
 create mode 100644 include/linux/ceph/crush/hash.h
 create mode 100644 include/linux/ceph/crush/mapper.h
 create mode 100644 include/linux/ceph/debugfs.h
 create mode 100644 include/linux/ceph/decode.h
 create mode 100644 include/linux/ceph/libceph.h
 create mode 100644 include/linux/ceph/mdsmap.h
 create mode 100644 include/linux/ceph/messenger.h
 create mode 100644 include/linux/ceph/mon_client.h
 create mode 100644 include/linux/ceph/msgpool.h
 create mode 100644 include/linux/ceph/msgr.h
 create mode 100644 include/linux/ceph/osd_client.h
 create mode 100644 include/linux/ceph/osdmap.h
 create mode 100644 include/linux/ceph/pagelist.h
 create mode 100644 include/linux/ceph/rados.h
 create mode 100644 include/linux/ceph/types.h
 create mode 100644 net/ceph/Kconfig
 create mode 100644 net/ceph/Makefile
 create mode 100644 net/ceph/armor.c
 create mode 100644 net/ceph/auth.c
 create mode 100644 net/ceph/auth_none.c
 create mode 100644 net/ceph/auth_none.h
 create mode 100644 net/ceph/auth_x.c
 create mode 100644 net/ceph/auth_x.h
 create mode 100644 net/ceph/auth_x_protocol.h
 create mode 100644 net/ceph/buffer.c
 create mode 100644 net/ceph/ceph_common.c
 create mode 100644 net/ceph/ceph_fs.c
 create mode 100644 net/ceph/ceph_hash.c
 create mode 100644 net/ceph/ceph_strings.c
 create mode 100644 net/ceph/crush/crush.c
 create mode 100644 net/ceph/crush/hash.c
 create mode 100644 net/ceph/crush/mapper.c
 create mode 100644 net/ceph/crypto.c
 create mode 100644 net/ceph/crypto.h
 create mode 100644 net/ceph/debugfs.c
 create mode 100644 net/ceph/messenger.c
 create mode 100644 net/ceph/mon_client.c
 create mode 100644 net/ceph/msgpool.c
 create mode 100644 net/ceph/osd_client.c
 create mode 100644 net/ceph/osdmap.c
 create mode 100644 net/ceph/pagelist.c
 create mode 100644 net/ceph/pagevec.c

