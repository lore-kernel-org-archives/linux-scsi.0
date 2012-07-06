From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: SCSI Performance regression [was Re: [PATCH 0/6]
	tcm_vhost/virtio-scsi WIP code for-3.6]
Date: Fri, 06 Jul 2012 02:13:17 -0700
Message-ID: <1341565997.23954.380.camel@haakon2.linux-iscsi.org>
References: <1341375846-27882-1-git-send-email-nab@linux-iscsi.org>
	<20120704140259.GB26485@redhat.com> <4FF45890.6000205@redhat.com>
	<20120704150557.GA26951@redhat.com> <4FF4BFBD.2080000@us.ibm.com>
	<1341453135.23954.214.camel@haakon2.linux-iscsi.org>
	<4FF56AE9.9060201@redhat.com> <20120705135318.GG30572@redhat.com>
	<4FF59F6B.2000101@us.ibm.com>
	<1341543672.23954.285.camel@haakon2.linux-iscsi.org>
	<1341553397.3023.16.camel@dabdike.hilton.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1341553397.3023.16.camel@dabdike.hilton.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>, Anthony Liguori <aliguori@us.ibm.com>, kvm-devel <kvm@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, lf-virt <virtualization@lists.linux-foundation.org>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, target-devel <target-devel@vger.kernel.org>, ksummit-2012-discuss <ksummit-2012-discuss@lists.linuxfoundation.org>, Paolo Bonzini <pbonzini@redhat.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Christoph Hellwig <hch@lst.de>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2012-07-06 at 09:43 +0400, James Bottomley wrote:
> On Thu, 2012-07-05 at 20:01 -0700, Nicholas A. Bellinger wrote:
> 
> > So I'm pretty sure this discrepancy is attributed to the small block
> > random I/O bottleneck currently present for all Linux/SCSI core LLDs
> > regardless of physical or virtual storage fabric.
> > 
> > The SCSI wide host-lock less conversion that happened in .38 code back
> > in 2010, and subsequently having LLDs like virtio-scsi convert to run in
> > host-lock-less mode have helped to some extent..  But it's still not
> > enough..
> > 
> > Another example where we've been able to prove this bottleneck recently
> > is with the following target setup:
> > 
> > *) Intel Romley production machines with 128 GB of DDR-3 memory
> > *) 4x FusionIO ioDrive 2 (1.5 TB @ PCI-e Gen2 x2)
> > *) Mellanox PCI-exress Gen3 HCA running at 56 gb/sec 
> > *) Infiniband SRP Target backported to RHEL 6.2 + latest OFED
> > 
> > In this setup using ib_srpt + IBLOCK w/ emulate_write_cache=1 +
> > iomemory_vsl export we end up avoiding SCSI core bottleneck on the
> > target machine, just as with the tcm_vhost example here for host kernel
> > side processing with vhost.
> > 
> > Using Linux IB SRP initiator + Windows Server 2008 R2 SCSI-miniport SRP
> > (OFED) Initiator connected to four ib_srpt LUNs, we've observed that
> > MSFT SCSI is currently outperforming RHEL 6.2 on the order of ~285K vs.
> > ~215K with heavy random 4k WRITE iometer / fio tests.  Note this with an
> > optimized queue_depth ib_srp client w/ noop I/O schedulering, but is
> > still lacking the host_lock-less patches on RHEL 6.2 OFED..
> > 
> > This bottleneck has been mentioned by various people (including myself)
> > on linux-scsi the last 18 months, and I've proposed that that it be
> > discussed at KS-2012 so we can start making some forward progress:
> 
> Well, no, it hasn't.  You randomly drop things like this into unrelated
> email (I suppose that is a mention in strict English construction) but
> it's not really enough to get anyone to pay attention since they mostly
> stopped reading at the top, if they got that far: most people just go by
> subject when wading through threads initially.
> 

It most certainly has been made clear to me, numerous times from many
people in the Linux/SCSI community that there is a bottleneck for small
block random I/O in SCSI core vs. raw Linux/Block, as well as vs. non
Linux based SCSI subsystems.

My apologies if mentioning this issue last year at LC 2011 to you
privately did not take a tone of a more serious nature, or that
proposing a topic for LSF-2012 this year was not a clear enough
indication of a problem with SCSI small block random I/O performance.

> But even if anyone noticed, a statement that RHEL6.2 (on a 2.6.32
> kernel, which is now nearly three years old) is 25% slower than W2k8R2
> on infiniband isn't really going to get anyone excited either
> (particularly when you mention OFED, which usually means a stack
> replacement on Linux anyway).
> 

The specific issue was first raised for .38 where we where able to get
most of the interesting high performance LLDs converted to using
internal locking methods so that host_lock did not have to be obtained
during each ->queuecommand() I/O dispatch, right..?

This has helped a good deal for large multi-lun scsi_host configs that
are now running in host-lock less mode, but there is still a large
discrepancy single LUN vs. raw struct block_device access even with LLD
host_lock less mode enabled.

Now I think the virtio-blk client performance is demonstrating this
issue pretty vividly, along with this week's tcm_vhost IBLOCK raw block
flash benchmarks that is demonstrate some other yet-to-be determined
limitations for virtio-scsi-raw vs. tcm_vhost for this particular fio
randrw workload.

> What people might pay attention to is evidence that there's a problem in
> 3.5-rc6 (without any OFED crap).  If you're not going to bother
> investigating, it has to be in an environment they can reproduce (so
> ordinary hardware, not infiniband) otherwise it gets ignored as an
> esoteric hardware issue.
> 

It's really quite simple for anyone to demonstrate the bottleneck
locally on any machine using tcm_loop with raw block flash.  Take a
struct block_device backend (like a Fusion IO /dev/fio*) and using
IBLOCK and export locally accessible SCSI LUNs via tcm_loop..

Using FIO there is a significant drop for randrw 4k performance between
tcm_loop <-> IBLOCK vs. raw struct block device backends.  And no, it's
not some type of target IBLOCK or tcm_loop bottleneck, it's a per SCSI
LUN limitation for small block random I/Os on the order of ~75K for each
SCSI LUN.

If anyone has gone actually gone faster than this with any single SCSI
LUN on any storage fabric, I would be interested in hearing about your
setup.

Thanks,

--nab
