From: Dongli Zhang <dongli.zhang@oracle.com>
Subject: [PATCH 0/2] Limit number of hw queues by nr_cpu_ids for virtio-blk
	and virtio-scsi
Date: Wed, 27 Mar 2019 18:36:33 +0800
Message-ID: <1553682995-5682-1-git-send-email-dongli.zhang@oracle.com>
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
To: linux-scsi@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-block@vger.kernel.org
Cc: axboe@kernel.dk, martin.petersen@oracle.com, mst@redhat.com, cohuck@redhat.com, linux-kernel@vger.kernel.org, jejb@linux.ibm.com
List-Id: linux-scsi@vger.kernel.org

When tag_set->nr_maps is 1, the block layer limits the number of hw queues
by nr_cpu_ids. No matter how many hw queues are use by
virtio-blk/virtio-scsi, as they both have (tag_set->nr_maps == 1), they
can use at most nr_cpu_ids hw queues.

In addition, specifically for pci scenario, when the 'num-queues' specified
by qemu is more than maxcpus, virtio-blk/virtio-scsi would not be able to
allocate more than maxcpus vectors in order to have a vector for each
queue. As a result, they fall back into MSI-X with one vector for config
and one shared for queues.

Considering above reasons, this patch set limits the number of hw queues
used by nr_cpu_ids for both virtio-blk and virtio-scsi.

-------------------------------------------------------------

Here is test result of virtio-scsi:

qemu cmdline:

-smp 2,maxcpus=4, \
-device virtio-scsi-pci,id=scsi0,num_queues=8, \
-device scsi-hd,drive=drive0,bus=scsi0.0,channel=0,scsi-id=0,lun=0, \
-drive file=test.img,if=none,id=drive0

Although maxcpus=4 and num_queues=8, 4 queues are used while 2 interrupts
are allocated.

# cat /proc/interrupts
... ...
 24:          0          0   PCI-MSI 65536-edge      virtio0-config
 25:          0        369   PCI-MSI 65537-edge      virtio0-virtqueues
... ...

# /sys/block/sda/mq/
0  1  2  3   ------> 4 queues although qemu sets num_queues=8


With the patch set, there is per-queue interrupt.

# cat /proc/interrupts
 24:          0          0   PCI-MSI 65536-edge      virtio0-config
 25:          0          0   PCI-MSI 65537-edge      virtio0-control
 26:          0          0   PCI-MSI 65538-edge      virtio0-event
 27:        296          0   PCI-MSI 65539-edge      virtio0-request
 28:          0        139   PCI-MSI 65540-edge      virtio0-request
 29:          0          0   PCI-MSI 65541-edge      virtio0-request
 30:          0          0   PCI-MSI 65542-edge      virtio0-request

# ls /sys/block/sda/mq
0  1  2  3

-------------------------------------------------------------

Here is test result of virtio-blk:

qemu cmdline:

-smp 2,maxcpus=4,
-device virtio-blk-pci,drive=drive-virtio-disk0,id=virtio-disk0,num-queues=8
-drive test.img,format=raw,if=none,id=drive-virtio-disk0

Although maxcpus=4 and num-queues=8, 4 queues are used while 2 interrupts
are allocated.

# cat /proc/interrupts
... ...
 24:          0          0   PCI-MSI 65536-edge      virtio0-config
 25:          0         65   PCI-MSI 65537-edge      virtio0-virtqueues
... ...

# ls /sys/block/vda/mq
0  1  2  3    -------> 4 queues although qemu sets num_queues=8


With the patch set, there is per-queue interrupt.

# cat /proc/interrupts
 24:          0          0   PCI-MSI 65536-edge      virtio0-config
 25:         64          0   PCI-MSI 65537-edge      virtio0-req.0
 26:          0      10290   PCI-MSI 65538-edge      virtio0-req.1
 27:          0          0   PCI-MSI 65539-edge      virtio0-req.2
 28:          0          0   PCI-MSI 65540-edge      virtio0-req.3

# ls /sys/block/vda/mq/
0  1  2  3


Reference: https://lore.kernel.org/lkml/e4afe4c5-0262-4500-aeec-60f30734b4fc@default/

Thank you very much!

Dongli Zhang
