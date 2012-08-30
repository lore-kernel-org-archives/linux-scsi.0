From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 0/5] Multiqueue virtio-scsi
Date: Thu, 30 Aug 2012 17:53:52 +0300
Message-ID: <20120830145352.GA21724@redhat.com>
References: <1346154857-12487-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1346154857-12487-1-git-send-email-pbonzini@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kvm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 28, 2012 at 01:54:12PM +0200, Paolo Bonzini wrote:
> Hi all,
> 
> this series adds multiqueue support to the virtio-scsi driver, based
> on Jason Wang's work on virtio-net.  It uses a simple queue steering
> algorithm that expects one queue per CPU.  LUNs in the same target always
> use the same queue (so that commands are not reordered); queue switching
> occurs when the request being queued is the only one for the target.
> Also based on Jason's patches, the virtqueue affinity is set so that
> each CPU is associated to one virtqueue.

Is there a spec patch? I did not see one.

> I tested the patches with fio, using up to 32 virtio-scsi disks backed
> by tmpfs on the host, and 1 LUN per target.
> 
> FIO configuration
> -----------------
> [global]
> rw=read
> bsrange=4k-64k
> ioengine=libaio
> direct=1
> iodepth=4
> loops=20
> 
> overall bandwidth (MB/s)
> -----------------
> 
> # of targets    single-queue    multi-queue, 4 VCPUs    multi-queue, 8 VCPUs
> 1                  540               626                     599
> 2                  795               965                     925
> 4                  997              1376                    1500
> 8                 1136              2130                    2060
> 16                1440              2269                    2474
> 24                1408              2179                    2436
> 32                1515              1978                    2319
> 
> (These numbers for single-queue are with 4 VCPUs, but the impact of adding
> more VCPUs is very limited).
> 
> avg bandwidth per LUN (MB/s)
> ---------------------
> 
> # of targets    single-queue    multi-queue, 4 VCPUs    multi-queue, 8 VCPUs
> 1                  540               626                     599
> 2                  397               482                     462
> 4                  249               344                     375
> 8                  142               266                     257
> 16                  90               141                     154
> 24                  58                90                     101
> 32                  47                61                      72
> 
> Testing this may require an irqbalance daemon that is built from git,
> due to http://code.google.com/p/irqbalance/issues/detail?id=37.
> Alternatively you can just set the affinity manually in /proc.
> 
> Rusty, can you please give your Acked-by to the first two patches?
> 
> Jason Wang (2):
>   virtio-ring: move queue_index to vring_virtqueue
>   virtio: introduce an API to set affinity for a virtqueue
> 
> Paolo Bonzini (3):
>   virtio-scsi: allocate target pointers in a separate memory block
>   virtio-scsi: pass struct virtio_scsi to virtqueue completion function
>   virtio-scsi: introduce multiqueue support
> 
>  drivers/lguest/lguest_device.c         |    1 +
>  drivers/remoteproc/remoteproc_virtio.c |    1 +
>  drivers/s390/kvm/kvm_virtio.c          |    1 +
>  drivers/scsi/virtio_scsi.c             |  200 ++++++++++++++++++++++++--------
>  drivers/virtio/virtio_mmio.c           |   11 +-
>  drivers/virtio/virtio_pci.c            |   58 ++++++++-
>  drivers/virtio/virtio_ring.c           |   17 +++
>  include/linux/virtio.h                 |    4 +
>  include/linux/virtio_config.h          |   21 ++++
>  9 files changed, 253 insertions(+), 61 deletions(-)
> 
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
