From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC 0/2] nvme/loop: Add support for controllers-per-port model
Date: Wed,  8 Jun 2016 03:34:19 +0000
Message-ID: <1465356861-4321-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-nvme <linux-nvme@lists.infradead.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@intel.com>, Jay Freyensee <james.p.freyensee@intel.com>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi again folks,

So building on the nvmet/configfs-ng WIP posted yesterday:

http://marc.info/?l=linux-scsi&m=146528147018404&w=2

This series adds support for nvme/loop to utilize a nvme host
controller per nvmet_port, instead of a single hardcoded entry
for nvmet_port pointer access in nvme_loop_queue_rq().

It uses a struct device model following what we've done in
drivers/target/loopback to allow multiple host controllers
to co-exist under configfs, and is driven by the nvmet_port
configfs enable attribute.

Which means that any arbitary number of nvme-loop controllers
can now exist, and each nvmet_subsystem->ports_group can
enable/disable it's own loopback controller!

Here is how it looks in action for controller id 1 + 2:

root@scsi-mq:/sys/kernel/config/nvmet/subsystems# tree -if .
./nqn.2003-01.org.linux-iscsi.NVMf.newsilicon
./nqn.2003-01.org.linux-iscsi.NVMf.newsilicon/namespaces
./nqn.2003-01.org.linux-iscsi.NVMf.newsilicon/namespaces/1
./nqn.2003-01.org.linux-iscsi.NVMf.newsilicon/namespaces/1/ramdisk1 -> ../../../../../target/core/rd_mcp_2/ramdisk1
./nqn.2003-01.org.linux-iscsi.NVMf.newsilicon/ports
./nqn.2003-01.org.linux-iscsi.NVMf.newsilicon/ports/loop
./nqn.2003-01.org.linux-iscsi.NVMf.newsilicon/ports/loop/addr_adrfam
./nqn.2003-01.org.linux-iscsi.NVMf.newsilicon/ports/loop/addr_portid
./nqn.2003-01.org.linux-iscsi.NVMf.newsilicon/ports/loop/addr_traddr
./nqn.2003-01.org.linux-iscsi.NVMf.newsilicon/ports/loop/addr_treq
./nqn.2003-01.org.linux-iscsi.NVMf.newsilicon/ports/loop/addr_trsvcid
./nqn.2003-01.org.linux-iscsi.NVMf.newsilicon/ports/loop/addr_trtype
./nqn.2003-01.org.linux-iscsi.NVMf.newsilicon/ports/loop/enable
./nqn.2003-01.org.linux-iscsi.NVMf.skylake-ep
./nqn.2003-01.org.linux-iscsi.NVMf.skylake-ep/namespaces
./nqn.2003-01.org.linux-iscsi.NVMf.skylake-ep/namespaces/1
./nqn.2003-01.org.linux-iscsi.NVMf.skylake-ep/namespaces/1/ramdisk0 -> ../../../../../target/core/rd_mcp_1/ramdisk0
./nqn.2003-01.org.linux-iscsi.NVMf.skylake-ep/ports
./nqn.2003-01.org.linux-iscsi.NVMf.skylake-ep/ports/loop
./nqn.2003-01.org.linux-iscsi.NVMf.skylake-ep/ports/loop/addr_adrfam
./nqn.2003-01.org.linux-iscsi.NVMf.skylake-ep/ports/loop/addr_portid
./nqn.2003-01.org.linux-iscsi.NVMf.skylake-ep/ports/loop/addr_traddr
./nqn.2003-01.org.linux-iscsi.NVMf.skylake-ep/ports/loop/addr_treq
./nqn.2003-01.org.linux-iscsi.NVMf.skylake-ep/ports/loop/addr_trsvcid
./nqn.2003-01.org.linux-iscsi.NVMf.skylake-ep/ports/loop/addr_trtype
./nqn.2003-01.org.linux-iscsi.NVMf.skylake-ep/ports/loop/enable

# cat /proc/partitions              
major minor  #blocks  name

 259        0    4194304 nvme0n1
 259        1      65535 nvme1n1
 259        2      65535 nvme2n1

Comments..?

--nab

Nicholas Bellinger (2):
  nvme-fabrics: Add nvmf_get_default_host helper
  nvme/loop: Add support for controller-per-port model

 drivers/nvme/host/fabrics.c |  13 +++-
 drivers/nvme/host/fabrics.h |   1 +
 drivers/nvme/target/loop.c  | 183 +++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 177 insertions(+), 20 deletions(-)

-- 
1.9.1
