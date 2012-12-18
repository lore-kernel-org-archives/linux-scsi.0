From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 0/5] Multiqueue virtio-scsi,
	and API for piecewise buffer submission
Date: Tue, 18 Dec 2012 13:32:47 +0100
Message-ID: <1355833972-20319-1-git-send-email-pbonzini@redhat.com>
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
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, mst@redhat.com, hutao@cn.fujitsu.com, virtualization@lists.linux-foundation.org, stefanha@redhat.com
List-Id: linux-scsi@vger.kernel.org

Hi all,

this series adds multiqueue support to the virtio-scsi driver, based
on Jason Wang's work on virtio-net.  It uses a simple queue steering
algorithm that expects one queue per CPU.  LUNs in the same target always
use the same queue (so that commands are not reordered); queue switching
occurs when the request being queued is the only one for the target.
Also based on Jason's patches, the virtqueue affinity is set so that
each CPU is associated to one virtqueue.

I tested the patches with fio, using up to 32 virtio-scsi disks backed
by tmpfs on the host.  These numbers are with 1 LUN per target.

FIO configuration
-----------------
[global]
rw=read
bsrange=4k-64k
ioengine=libaio
direct=1
iodepth=4
loops=20

overall bandwidth (MB/s)
------------------------

# of targets    single-queue    multi-queue, 4 VCPUs    multi-queue, 8 VCPUs
1                  540               626                     599
2                  795               965                     925
4                  997              1376                    1500
8                 1136              2130                    2060
16                1440              2269                    2474
24                1408              2179                    2436
32                1515              1978                    2319

(These numbers for single-queue are with 4 VCPUs, but the impact of adding
more VCPUs is very limited).

avg bandwidth per LUN (MB/s)
----------------------------

# of targets    single-queue    multi-queue, 4 VCPUs    multi-queue, 8 VCPUs
1                  540               626                     599
2                  397               482                     462
4                  249               344                     375
8                  142               266                     257
16                  90               141                     154
24                  58                90                     101
32                  47                61                      72

Patch 1 adds a new API to add functions for piecewise addition for buffers,
which enables various simplifications in virtio-scsi (patches 2-3) and a
small performance improvement of 2-6%.  Patches 4 and 5 add multiqueuing.

I'm mostly looking for comments on the new API of patch 1 for inclusion
into the 3.9 kernel.

Thanks to Wao Ganlong for help rebasing and benchmarking these patches.

Paolo Bonzini (5):
  virtio: add functions for piecewise addition of buffers
  virtio-scsi: use functions for piecewise composition of buffers
  virtio-scsi: redo allocation of target data
  virtio-scsi: pass struct virtio_scsi to virtqueue completion function
  virtio-scsi: introduce multiqueue support

 drivers/scsi/virtio_scsi.c   |  374 +++++++++++++++++++++++++++++-------------
 drivers/virtio/virtio_ring.c |  205 ++++++++++++++++++++++++
 include/linux/virtio.h       |   21 +++
 3 files changed, 485 insertions(+), 115 deletions(-)
