From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC-v2 00/11] nvmet: Add support for multi-tenant configfs
Date: Tue, 14 Jun 2016 04:35:35 +0000
Message-ID: <1465878946-26556-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:38464 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235AbcFNEgs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jun 2016 00:36:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-nvme <linux-nvme@lists.infradead.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@intel.com>, Jay Freyensee <james.p.freyensee@intel.com>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>

=46rom: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

Here's the second pass of a nvmet multi-tenant configfs layout,
following what we've learned in target_core_fabric_configfs.c
wrt to independent operation of storage endpoints.

Namely, it allows existing /sys/kernel/config/target/core/ backends
to be configfs symlinked into ../nvmet/subsystems/$SUBSYS_NQN/
as nvme namespaces.

Here is how the running RFC-v2 code currently looks:

/sys/kernel/config/nvmet/subsystems/
=E2=94=94=E2=94=80=E2=94=80 nqn.2003-01.org.linux-iscsi.NVMf.skylake-ep
    =E2=94=9C=E2=94=80=E2=94=80 hosts
    =E2=94=9C=E2=94=80=E2=94=80 namespaces
    =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 1
    =E2=94=82       =E2=94=94=E2=94=80=E2=94=80 ramdisk0 -> ../../../..=
/../target/core/rd_mcp_1/ramdisk0
    =E2=94=94=E2=94=80=E2=94=80 ports
        =E2=94=94=E2=94=80=E2=94=80 loop
            =E2=94=9C=E2=94=80=E2=94=80 addr_adrfam
            =E2=94=9C=E2=94=80=E2=94=80 addr_portid
            =E2=94=9C=E2=94=80=E2=94=80 addr_traddr
            =E2=94=9C=E2=94=80=E2=94=80 addr_treq
            =E2=94=9C=E2=94=80=E2=94=80 addr_trsvcid
            =E2=94=9C=E2=94=80=E2=94=80 addr_trtype
            =E2=94=94=E2=94=80=E2=94=80 enable

The series exposes T10-PI from /sys/kernel/config/target/core/ as
ID_NS.ms + ID_NS.dps feature bits, and enables block integrity
support with nvmet/loop driver.

Note this series depends upon the following prerequisites of
target-core:

  http://marc.info/?l=3Dlinux-scsi&m=3D146527281416606&w=3D2

and of course, last week's earlier release of nvmet + friends:

  http://lists.infradead.org/pipermail/linux-nvme/2016-June/004754.html

Note the full set of patches is available from:

  https://git.kernel.org/cgit/linux/kernel/git/nab/target-pending.git/l=
og/?h=3Dnvmet-configfs-ng

v2 changes:

  - Introduce struct nvmet_port_binding in configfs-ng.c, in order
    to support 1:N mappings.
  - Convert nvmet_find_get_subsys() + discovery.c logic to use
    nvmet_port->port_binding_list.
  - Convert nvmet/loop to use nvmet_port_binding. (1:1 mapping)
  - Convert nvmet/rdma to use nvmet_port_binding + nvmet_rdma_ports.
    (1:N mapping)
  - Export nvmf_host_add + generate hostnqn if necessary. (HCH)
  - Make nvmet/loop multi-controller allocate it's own nvmf_host
    per controller. (HCH)
  - Change nvmet_fabric_ops get/put to use nvmf_disc_rsp_page_entry.
  - Convert nvmet_genctr to atomic_long_t.
  - Enable ../nvmet/subsystems/$NQN/hosts/$HOSTNQN group usage
    in configfs-ng.c.

Comments..?

--nab

Nicholas Bellinger (11):
  nvme-fabrics: Export nvmf_host_add + generate hostnqn if necessary
  nvmet: Add nvmet_fabric_ops get/put transport helpers
  nvmet: Add support for configfs-ng multi-tenant logic
  nvmet: Hookup nvmet_ns->dev to nvmet_ns_enable
  nvmet/loop: Add support for controller-per-port model +
    nvmet_port_binding
  nvmet/rdma: Convert to struct nvmet_port_binding
  nvmet/io-cmd: Hookup sbc_ops->execute_rw backend ops
  nvmet/io-cmd: Hookup sbc_ops->execute_sync_cache backend ops
  nvmet/io-cmd: Hookup sbc_ops->execute_unmap backend ops
  nvmet/admin-cmd: Hookup T10-PI to ID_NS.ms + ID_NS.dps feature bits
  nvmet/loop: Add support for bio integrity handling

 drivers/nvme/host/fabrics.c       |  18 +-
 drivers/nvme/host/fabrics.h       |   1 +
 drivers/nvme/target/Makefile      |   2 +-
 drivers/nvme/target/admin-cmd.c   |  17 +
 drivers/nvme/target/configfs-ng.c | 661 ++++++++++++++++++++++++++++++=
++++++++
 drivers/nvme/target/configfs.c    |  12 +-
 drivers/nvme/target/core.c        | 153 ++++++---
 drivers/nvme/target/discovery.c   |  31 +-
 drivers/nvme/target/io-cmd.c      | 169 ++++++----
 drivers/nvme/target/loop.c        | 223 +++++++++++--
 drivers/nvme/target/nvmet.h       |  67 +++-
 drivers/nvme/target/rdma.c        | 127 +++++++-
 12 files changed, 1317 insertions(+), 164 deletions(-)
 create mode 100644 drivers/nvme/target/configfs-ng.c

--=20
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
