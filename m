From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/6] tcm_vhost/virtio-scsi WIP code for-3.6
Date: Wed, 04 Jul 2012 18:52:15 -0700
Message-ID: <1341453135.23954.214.camel@haakon2.linux-iscsi.org>
References: <1341375846-27882-1-git-send-email-nab@linux-iscsi.org>
	<20120704140259.GB26485@redhat.com> <4FF45890.6000205@redhat.com>
	<20120704150557.GA26951@redhat.com>  <4FF4BFBD.2080000@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <4FF4BFBD.2080000@us.ibm.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Anthony Liguori <aliguori@us.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, lf-virt <virtualization@lists.linux-foundation.org>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, target-devel <target-devel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Christoph Hellwig <hch@lst.de>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Hi Anthony & Co,

On Wed, 2012-07-04 at 17:12 -0500, Anthony Liguori wrote:
> On 07/04/2012 10:05 AM, Michael S. Tsirkin wrote:
> > On Wed, Jul 04, 2012 at 04:52:00PM +0200, Paolo Bonzini wrote:
> >> Il 04/07/2012 16:02, Michael S. Tsirkin ha scritto:
> >>> On Wed, Jul 04, 2012 at 04:24:00AM +0000, Nicholas A. Bellinger wrote:
> >>>> From: Nicholas Bellinger<nab@linux-iscsi.org>
> >>>>
> >>>> Hi folks,
> >>>>
> >>>> This series contains patches required to update tcm_vhost<->  virtio-scsi
> >>>> connected hosts<->  guests to run on v3.5-rc2 mainline code.  This series is
> >>>> available on top of target-pending/auto-next here:
> >>>>
> >>>>     git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git tcm_vhost
> >>>>
> >>>> This includes the necessary vhost changes from Stefan to to get tcm_vhost
> >>>> functioning, along a virtio-scsi LUN scanning change to address a client bug
> >>>> with tcm_vhost I ran into..  Also, tcm_vhost driver has been merged into a single
> >>>> source + header file that is now living under /drivers/vhost/, along with latest
> >>>> tcm_vhost changes from Zhi's tcm_vhost tree.
> >>>>
> >>>> Here are a couple of screenshots of the code in action using raw IBLOCK
> >>>> backends provided by FusionIO ioDrive Duo:
> >>>>
> >>>>     http://linux-iscsi.org/images/Virtio-scsi-tcm-vhost-3.5-rc2-3.png
> >>>>     http://linux-iscsi.org/images/Virtio-scsi-tcm-vhost-3.5-rc2-4.png
> >>>>
> >>>> So the next steps on my end will be converting tcm_vhost to submit backend I/O from
> >>>> cmwq context, along with fio benchmark numbers between tcm_vhost/virtio-scsi and
> >>>> virtio-scsi-raw using raw IBLOCK iomemory_vsl flash.
> >>>
> >>> OK so this is an RFC, not for merge yet?
> >>
> >> Patch 6 definitely looks RFCish, but patch 5 should go in anyway.
> >>
> >> Paolo
> >
> > I was talking about 4/6 first of all.
> > Anyway, it's best to split, not to mix RFCs and fixes.
> 
> What is the use-case that we're targeting for this?
> 

The first use case is high performance small block random IO access into
KVM guest from IBLOCK/FILEIO + pSCSI passthrough backends.  (see below)

The second use case is shared storage access across multiple KVM guests
using TCM level SPC-3 persistent reservations + ALUA multipath logic.

The third use case is future DIF support within virtio-scsi supported
guests that we connect directly to tcm_vhost.

> I certainly think it's fine to merge this into the kernel...  maybe something 
> will use it.  But I'm pretty opposed to taking support for this into QEMU.  It's 
> going to create more problems than it solves specifically because I have no idea 
> what problem it actually solves.
> 

To give an idea of how things are looking on the performance side, here
some initial numbers for small block (4k) mixed random IOPs using the
following fio test setup:

[randrw]
rw=randrw
rwmixwrite=25
rwmixread=75
size=131072m
ioengine=libaio
direct=1
iodepth=64
blocksize=4k
filename=/dev/sdb

The backend is a single iomemory_vsl (FusionIO) raw flash block_device
using IBLOCK w/ emulate_write_cache=1 set.  Also note the noop scheduler
has been set with virtio-scsi LUNs.  Here are the QEMU cli opts for both
cases:

./x86_64-softmmu/qemu-system-x86_64 -enable-kvm -smp 2 -m 2048 -serial
file:/tmp/vhost-serial.txt -hda debian_squeeze_amd64_standard-old.qcow2
-vhost-scsi id=vhost-scsi0,wwpn=naa.600140579ad21088,tpgt=1 -device
virtio-scsi-pci,vhost-scsi=vhost-scsi0,event_idx=off

./x86_64-softmmu/qemu-system-x86_64 -enable-kvm -smp 4 -m 2048 -serial
file:/tmp/vhost-serial.txt -hda debian_squeeze_amd64_standard-old.qcow2
-drive file=/dev/fioa,format=raw,if=none,id=sdb,cache=none,aio=native
-device virtio-scsi-pci,id=mcbus -device scsi-disk,drive=sdb


fio randrw workload | virtio-scsi-raw | virtio-scsi+tcm_vhost | bare-metal raw block
------------------------------------------------------------------------------------
25 Write / 75 Read  |      ~15K       |         ~45K          |         ~70K
75 Write / 25 Read  |      ~20K       |         ~55K          |         ~60K


In the first case, virtio-scsi+tcm_vhost is out performing by 3x
compared to virtio-scsi-raw using QEMU SCSI emulation with the same raw
flash backend device.  For the second case heavier WRITE case, tcm_vhost
is nearing full bare-metal utilization (~55K vs. ~60K).

Also converting tcm_vhost to use proper cmwq process context I/O
submission will help to get even closer to bare metal speeds for both
work-loads.

> We cannot avoid doing better SCSI emulation in QEMU.  That cannot be a long term 
> strategy on our part and vhost-scsi isn't going to solve that problem for us.
> 

Yes, QEMU needs a sane level of host OS independent functional SCSI
emulation, I don't think that is the interesting point up for debate
here..  ;)

I think performance wise it's now pretty clear that vhost is
outperforming QEMU block with virtio-scsi for intestive small block
randrw workloads.  When connected to raw block flash backends where we
avoid the SCSI LLD bottleneck for small block random I/O on the KVM host
all-together, the difference between the two case is even larger based
upon these initial benchmarks.

Thanks for your comments!

--nab
