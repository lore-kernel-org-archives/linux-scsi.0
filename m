From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v2 0/5] Multiqueue virtio-scsi, and API for piecewise
	buffer submission
Date: Wed, 19 Dec 2012 13:32:02 +0200
Message-ID: <20121219113202.GD7742@redhat.com>
References: <1355833972-20319-1-git-send-email-pbonzini@redhat.com>
	<96853954.7ghLePd55F@donald.sf-tec.de>
	<50D1806B.7030603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <50D1806B.7030603@redhat.com>
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
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, hutao@cn.fujitsu.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, stefanha@redhat.com, Rolf Eike Beer <eike-kernel@sf-tec.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 19, 2012 at 09:52:59AM +0100, Paolo Bonzini wrote:
> Il 18/12/2012 23:18, Rolf Eike Beer ha scritto:
> > Paolo Bonzini wrote:
> >> Hi all,
> >>
> >> this series adds multiqueue support to the virtio-scsi driver, based
> >> on Jason Wang's work on virtio-net.  It uses a simple queue steering
> >> algorithm that expects one queue per CPU.  LUNs in the same target always
> >> use the same queue (so that commands are not reordered); queue switching
> >> occurs when the request being queued is the only one for the target.
> >> Also based on Jason's patches, the virtqueue affinity is set so that
> >> each CPU is associated to one virtqueue.
> >>
> >> I tested the patches with fio, using up to 32 virtio-scsi disks backed
> >> by tmpfs on the host.  These numbers are with 1 LUN per target.
> >>
> >> FIO configuration
> >> -----------------
> >> [global]
> >> rw=read
> >> bsrange=4k-64k
> >> ioengine=libaio
> >> direct=1
> >> iodepth=4
> >> loops=20
> >>
> >> overall bandwidth (MB/s)
> >> ------------------------
> >>
> >> # of targets    single-queue    multi-queue, 4 VCPUs    multi-queue, 8 VCPUs
> >> 1                  540               626                     599
> >> 2                  795               965                     925
> >> 4                  997              1376                    1500
> >> 8                 1136              2130                    2060
> >> 16                1440              2269                    2474
> >> 24                1408              2179                    2436
> >> 32                1515              1978                    2319
> >>
> >> (These numbers for single-queue are with 4 VCPUs, but the impact of adding
> >> more VCPUs is very limited).
> >>
> >> avg bandwidth per LUN (MB/s)
> >> ----------------------------
> >>
> >> # of targets    single-queue    multi-queue, 4 VCPUs    multi-queue, 8 VCPUs
> >> 1                  540               626                     599
> >> 2                  397               482                     462
> >> 4                  249               344                     375
> >> 8                  142               266                     257
> >> 16                  90               141                     154
> >> 24                  58                90                     101
> >> 32                  47                61                      72
> > 
> > Is there an explanation why 8x8 is slower then 4x8 in both cases?
> 
> Regarding the "in both cases" part, it's because the second table has
> the same data as the first, but divided by the first column.
> 
> In general, the "strangenesses" you find are probably within statistical
> noise or due to other effects such as host CPU utilization or contention
> on the big QEMU lock.
> 
> Paolo
> 

That's exactly what bothers me. If the IOPS divided by host CPU
goes down, then the win on lightly loaded host will become a regression
on a loaded host.

Need to measure that.

>  8x1 and 8x2
> > being slower than 4x1 and 4x2 is more or less expected, but 8x8 loses against 
> > 4x8 while 8x4 wins against 4x4 and 8x16 against 4x16.
> > 
> > Eike
> > 
