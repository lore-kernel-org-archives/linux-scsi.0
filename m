From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC-v2 0/4] tcm_vhost+cmwq fabric driver code for-3.6
Date: Tue, 17 Jul 2012 14:17:22 -0700
Message-ID: <1342559842.18004.440.camel@haakon2.linux-iscsi.org>
References: <1342041304-29728-1-git-send-email-nab@linux-iscsi.org>
	 <20120717150548.GA11587@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20120717150548.GA11587@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, kvm-devel <kvm@vger.kernel.org>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2012-07-17 at 18:05 +0300, Michael S. Tsirkin wrote:
> On Wed, Jul 11, 2012 at 09:15:00PM +0000, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Hi folks,
> > 
> > The following is a RFC-v2 series of tcm_vhost target fabric driver code
> > currently in-flight for-3.6 mainline code.
> > 
> > After last week's developments along with the help of some new folks, the
> > changelog v1 -> v2 so far looks like:
> > 
> > *) Fix drivers/vhost/test.c to use VHOST_NET_FEATURES in patch #1 (Asias He)
> > *) Fix tv_cmd completion -> release SGL memory leak (nab)
> > *) Fix sparse warnings for static variable usage (Fengguang Wu)
> > *) Fix sparse warnings for min() typing + printk format specs (Fengguang Wu)
> > *) Convert to cmwq submission for I/O dispatch (nab + hch)
> > 
> > Also following Paolo's request, a patch for hw/virtio-scsi.c that sets
> > scsi_host->max_target=0 that removes the need for virtio-scsi LLD to hardcode
> > VirtIOSCSIConfig->max_id=1 in order to function with tcm_vhost.
> > 
> > Note this series has been pushed into target-pending.git/for-next-merge, and
> > should be getting picked up for tomorrow's linux-next build.
> > 
> > Please let us know if you have any concerns and/or additional review feedback.
> > 
> > Thank you!
> 
> 
> It still seems not 100% clear whether this driver will have major
> userspace using it. And if not, it would be very hard to support a driver
> when recent userspace does not use it in the end.
> 

I'm happy to commit to working with QEMU + kvm-tool folks to get to a
series that can (eventually) see vhost-scsi support merged into upstream
userspace code.

It took roughly 2 years to get the megasas HBA emulation from Dr. Hannes
merged, but certainly vhost-scsi has alot less moving pieces and
hopefully alot less controversial bits than the buffer -> SGL
conversion..  The key word being here 'hopefully'..  ;)

> I think a good idea for 3.6 would be to make it depend on CONFIG_STAGING.
> Then we don't commit to an ABI.
> For this, you can add a separate Kconfig and source it from drivers/staging/Kconfig.
> Maybe it needs to be in a separate directory drivers/vhost/staging/Kconfig.
> 

So tcm_vhost has been marked as Experimental following virtio-scsi.

Wrt to staging, I'd like to avoid mucking with staging because:

*) The code has been posted for review
*) The code has been converted to use the latest target-core primitives
*) The code does not require cleanups between staging -> merge
*) The code has been stable the last 7 days since RFC-v2 with heavy 

Also, tcm_vhost has been marked as Experimental following virtio-scsi.
I'd much rather leave it at Experimental until we merge upstream
userspace support.   If userspace support never ends up materializing,
I'm fine with dropping it all together.

However at this point given that there is a 3x performance gap between
virtio-scsi-raw + virtio-scsi+tcm_vhost for random mixed small block
I/O, and we still need the latter to do proper SCSI CDB passthrough for
non TYPE_DISK devices I'm hoping that we can agree on userspace bits
once tcm_vhost is merged.

--nab
