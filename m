From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC 0/8] nvmet: Add support for multi-tenant configfs
Date: Tue,  7 Jun 2016 06:36:48 +0000
Message-ID: <1465281416-28355-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:47857 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbcFGGhq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2016 02:37:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-nvme <linux-nvme@lists.infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>

=46rom: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

Here's the first pass of a nvmet multi-tenant configfs layout,
following what we've learned in target_core_fabric_configfs.c
wrt to independent operation of storage endpoints.

Here is how the running RFC-v1 code currently looks:

/sys/kernel/config/nvmet/subsystems/
=E2=94=94=E2=94=80=E2=94=80 nqn.2003-01.org.linux-iscsi.NVMf.skylake-ep
    =E2=94=9C=E2=94=80=E2=94=80 namespaces
    =E2=94=82=C2=A0=C2=A0 =E2=94=94=E2=94=80=E2=94=80 1
    =E2=94=82=C2=A0=C2=A0     =E2=94=94=E2=94=80=E2=94=80 ramdisk0 -> .=
=2E/../../../../target/core/rd_mcp_1/ramdisk0
    =E2=94=94=E2=94=80=E2=94=80 ports
        =E2=94=94=E2=94=80=E2=94=80 loop
            =E2=94=9C=E2=94=80=E2=94=80 addr_adrfam
            =E2=94=9C=E2=94=80=E2=94=80 addr_portid
            =E2=94=9C=E2=94=80=E2=94=80 addr_traddr
            =E2=94=9C=E2=94=80=E2=94=80 addr_treq
            =E2=94=9C=E2=94=80=E2=94=80 addr_trsvcid
            =E2=94=9C=E2=94=80=E2=94=80 addr_trtype
            =E2=94=94=E2=94=80=E2=94=80 enable

Namely, it allows existing /sys/kernel/config/target/core/ backends
to be configfs symlinked into ../nvmet/subsystems/$SUBSYS_NQN/
as nvme namespaces.

The series exposes T10-PI from /sys/kernel/config/target/core/ as
ID_NS.ms + ID_NS.dps feature bits, and enables block integrity
support with nvme/loop driver.

Note this series depends upon the following prerequisites of
target-core:

  http://marc.info/?l=3Dlinux-scsi&m=3D146527281416606&w=3D2

and of course, today's earlier release of nvmet + friends:

  http://lists.infradead.org/pipermail/linux-nvme/2016-June/004754.html

Note the full set of patches is available from:

  https://git.kernel.org/cgit/linux/kernel/git/nab/target-pending.git/l=
og/?h=3Dnvmet-configfs-ng

Comments..?

--nab

Nicholas Bellinger (8):
  nvmet: Add nvmet_fabric_ops get/put transport helpers
  nvmet: Add support for configfs-ng multi-tenant logic
  nvmet: Hookup nvmet_ns->dev to nvmet_ns_enable
  nvmet/io-cmd: Hookup sbc_ops->execute_rw backend ops
  nvmet/io-cmd: Hookup sbc_ops->execute_sync_cache backend ops
  nvmet/io-cmd: Hookup sbc_ops->execute_unmap backend ops
  nvmet/admin-cmd: Hookup T10-PI to ID_NS.ms + ID_NS.dps feature bits
  nvme/loop: Add support for bio integrity handling

 drivers/nvme/target/Makefile      |   2 +-
 drivers/nvme/target/admin-cmd.c   |  17 ++
 drivers/nvme/target/configfs-ng.c | 585 ++++++++++++++++++++++++++++++=
++++++++
 drivers/nvme/target/configfs.c    |   5 +-
 drivers/nvme/target/core.c        |  83 +++---
 drivers/nvme/target/io-cmd.c      | 169 ++++++-----
 drivers/nvme/target/loop.c        |  19 ++
 drivers/nvme/target/nvmet.h       |  27 +-
 8 files changed, 799 insertions(+), 108 deletions(-)
 create mode 100644 drivers/nvme/target/configfs-ng.c

--=20
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
