From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [RFC-v2 0/4] tcm_vhost+cmwq fabric driver code for-3.6
Date: Wed, 18 Jul 2012 01:18:14 +0300
Message-ID: <20120717221814.GH1868@redhat.com>
References: <1342041304-29728-1-git-send-email-nab@linux-iscsi.org>
 <20120717150548.GA11587@redhat.com>
 <1342559842.18004.440.camel@haakon2.linux-iscsi.org>
 <20120717213437.GC1868@redhat.com>
 <1342562528.18004.480.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab2GQWSB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jul 2012 18:18:01 -0400
Content-Disposition: inline
In-Reply-To: <1342562528.18004.480.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, kvm-devel <kvm@vger.kernel.org>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>

On Tue, Jul 17, 2012 at 03:02:08PM -0700, Nicholas A. Bellinger wrote:
> On Wed, 2012-07-18 at 00:34 +0300, Michael S. Tsirkin wrote:
> > On Tue, Jul 17, 2012 at 02:17:22PM -0700, Nicholas A. Bellinger wrote:
> > > On Tue, 2012-07-17 at 18:05 +0300, Michael S. Tsirkin wrote:
> > > > On Wed, Jul 11, 2012 at 09:15:00PM +0000, Nicholas A. Bellinger wrote:
> > > > > From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> <SNIP>
> 
> > > I'm happy to commit to working with QEMU + kvm-tool folks to get to a
> > > series that can (eventually) see vhost-scsi support merged into upstream
> > > userspace code.
> > > 
> > > It took roughly 2 years to get the megasas HBA emulation from Dr. Hannes
> > > merged, but certainly vhost-scsi has alot less moving pieces and
> > > hopefully alot less controversial bits than the buffer -> SGL
> > > conversion..  The key word being here 'hopefully'..  ;)
> > > 
> > > > I think a good idea for 3.6 would be to make it depend on CONFIG_STAGING.
> > > > Then we don't commit to an ABI.
> > > > For this, you can add a separate Kconfig and source it from drivers/staging/Kconfig.
> > > > Maybe it needs to be in a separate directory drivers/vhost/staging/Kconfig.
> > > > 
> > > 
> > > So tcm_vhost has been marked as Experimental following virtio-scsi.
> > > 
> > > Wrt to staging, I'd like to avoid mucking with staging because:
> > > 
> > > *) The code has been posted for review
> > > *) The code has been converted to use the latest target-core primitives
> > > *) The code does not require cleanups between staging -> merge
> > > *) The code has been stable the last 7 days since RFC-v2 with heavy 
> > 
> > staging is not just for code that needs cleanups.
> > It's for anything that does not guarantee ABI stability yet.
> > And I think it's a bit early to guarantee ABI stability - 7 days
> > is not all that long.
> > 
> 
> I was talking about the new I/O path has been running for 7 days.
> 
> > See for example Anthony's comments that raise exactly the ABI
> > issues.
> > 
> 
> As mentioned in the response to Anthony, we are using the same generic
> fabric ABI in drivers/target/target_core_fabric_configfs.c since .38.
> 
> That part is not going to change, and it has not changed for any of the
> other 7 target fabric modules we've merged into mainline since then.
> 
> > > Also, tcm_vhost has been marked as Experimental following virtio-scsi.
> > > I'd much rather leave it at Experimental until we merge upstream
> > > userspace support.   If userspace support never ends up materializing,
> > > I'm fine with dropping it all together.
> > 
> > Once it's in kernel you never know who will use this driver.
> > Experimental does not mean driver can be dropped, staging does.
> > 
> 
> Yes, that's the point of being in mainline.  People using the code,
> right..?

Exactly. I am just worried about in the end being no major users and we
are being stuck with a niche driver that as a result is very hard to test.
And the reason for the fear is the initial negative reaction from the
qemu side.  And no if it's there we can't just drop it.

> > > However at this point given that there is a 3x performance gap between
> > > virtio-scsi-raw + virtio-scsi+tcm_vhost for random mixed small block
> > > I/O, and we still need the latter to do proper SCSI CDB passthrough for
> > > non TYPE_DISK devices I'm hoping that we can agree on userspace bits
> > > once tcm_vhost is merged.
> > > 
> > > --nab
> > 
> > I do think upstream kernel would help you nail userspace issues too
> > but at this point it looks like either staging meterial or 3.6 is too
> > early.
> > 
> 
> I think for-3.6 is just the right time for this kernel code.  Seriously,
> The basic ABI fabric layout for /sys/kernel/config/target/vhost/ is
> going to be the same now for-3.6, the same for-3.7, and the same for .38
> code. 
> 
> I'd be happy to move tcm_vhost back to drivers/target/ for now, and we
> move it to drivers/vhost/ once the userspace bits are worked out..?
> 
> Would that be a reasonable compromise to move forward..?
> 
> --nab

I don't see how it helps.  The driver is either a guaranteed ABI or not.
I'd prefer not to have vhost users outside drivers/vhost/ since it is
harder for me to keep track of them.

What's the problem with staging proposal? It's just another hoop to jump
through to enable it?

-- 
MST
