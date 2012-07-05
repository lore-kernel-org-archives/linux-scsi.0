From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 0/6] tcm_vhost/virtio-scsi WIP code for-3.6
Date: Thu, 5 Jul 2012 20:26:57 +0300
Message-ID: <20120705172656.GF31257@redhat.com>
References: <20120704140259.GB26485@redhat.com> <4FF45890.6000205@redhat.com>
	<20120704150557.GA26951@redhat.com> <4FF4BFBD.2080000@us.ibm.com>
	<1341453135.23954.214.camel@haakon2.linux-iscsi.org>
	<4FF56AE9.9060201@redhat.com> <20120705135318.GG30572@redhat.com>
	<4FF59F6B.2000101@us.ibm.com> <20120705144001.GB31257@redhat.com>
	<4FF5A90F.5050902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <4FF5A90F.5050902@redhat.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Anthony Liguori <aliguori@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, target-devel <target-devel@vger.kernel.org>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Christoph Hellwig <hch@lst.de>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 05, 2012 at 04:47:43PM +0200, Paolo Bonzini wrote:
> Il 05/07/2012 16:40, Michael S. Tsirkin ha scritto:
> >> virtio-scsi is brand new.  It's not as if we've had any significant
> >> time to make virtio-scsi-qemu faster.  In fact, tcm_vhost existed
> >> before virtio-scsi-qemu did if I understand correctly.
> 
> Yes.
> 
> > Can't same can be said about virtio scsi - it seems to be
> > slower so we force a bad choice between blk and scsi at the user?
> 
> virtio-scsi supports multiple devices per PCI slot (or even function),
> can talk to tapes, has better passthrough support for disks, and does a
> bunch of other things that virtio-blk by design doesn't do.  This
> applies to both tcm_vhost and virtio-scsi-qemu.
> 
> So far, all that virtio-scsi vs. virtio-blk benchmarks say is that more
> benchmarking is needed.  Some people see it faster, some people see it
> slower.  In some sense, it's consistent with the expectation that the
> two should roughly be the same. :)

Anyway, all I was saying is new technology often lacks some features of
the old one. We are not forcing new inferior one on anyone, so we can
let it mature it tree.

> >> But guest/user facing decisions cannot be easily unmade and making
> >> the wrong technical choices because of premature concerns of "time
> >> to market" just result in a long term mess.
> >>
> >> There is no technical reason why tcm_vhost is going to be faster
> >> than doing it in userspace.
> > 
> > But doing what in userspace exactly?
> 
> Processing virtqueues in separate threads, switching the block and SCSI
> layer to fine-grained locking, adding some more fast paths.
> 
> >> Basically, the issue is that the kernel has more complete SCSI
> >> emulation that QEMU does right now.
> >>
> >> There are lots of ways to try to solve this--like try to reuse the
> >> kernel code in userspace or just improving the userspace code.  If
> >> we were able to make the two paths identical, then I strongly
> >> suspect there'd be no point in having tcm_vhost anyway.
> > 
> > However, a question we should ask ourselves is whether this will happen
> > in practice, and when.
> 
> It's already happening, but it takes a substantial amount of preparatory
> work before you can actually see results.
> 
> Paolo
