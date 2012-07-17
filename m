From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC-v2 0/4] tcm_vhost+cmwq fabric driver code for-3.6
Date: Tue, 17 Jul 2012 15:37:20 -0700
Message-ID: <1342564640.18004.492.camel@haakon2.linux-iscsi.org>
References: <1342041304-29728-1-git-send-email-nab@linux-iscsi.org>
	<20120717150548.GA11587@redhat.com>
	<1342559842.18004.440.camel@haakon2.linux-iscsi.org>
	<20120717213437.GC1868@redhat.com>
	<1342562528.18004.480.camel@haakon2.linux-iscsi.org>
	<20120717221814.GH1868@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20120717221814.GH1868@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm-devel <kvm@vger.kernel.org>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, lf-virt <virtualization@lists.linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-07-18 at 01:18 +0300, Michael S. Tsirkin wrote:
> On Tue, Jul 17, 2012 at 03:02:08PM -0700, Nicholas A. Bellinger wrote:
> > On Wed, 2012-07-18 at 00:34 +0300, Michael S. Tsirkin wrote:
> > > On Tue, Jul 17, 2012 at 02:17:22PM -0700, Nicholas A. Bellinger wrote:
> > > > On Tue, 2012-07-17 at 18:05 +0300, Michael S. Tsirkin wrote:
> > > > > On Wed, Jul 11, 2012 at 09:15:00PM +0000, Nicholas A. Bellinger wrote:
> > > > > > From: Nicholas Bellinger <nab@linux-iscsi.org>

<SNIP>

> > As mentioned in the response to Anthony, we are using the same generic
> > fabric ABI in drivers/target/target_core_fabric_configfs.c since .38.
> > 
> > That part is not going to change, and it has not changed for any of the
> > other 7 target fabric modules we've merged into mainline since then.
> > 
> > > > Also, tcm_vhost has been marked as Experimental following virtio-scsi.
> > > > I'd much rather leave it at Experimental until we merge upstream
> > > > userspace support.   If userspace support never ends up materializing,
> > > > I'm fine with dropping it all together.
> > > 
> > > Once it's in kernel you never know who will use this driver.
> > > Experimental does not mean driver can be dropped, staging does.
> > > 
> > 
> > Yes, that's the point of being in mainline.  People using the code,
> > right..?
> 
> Exactly. I am just worried about in the end being no major users and we
> are being stuck with a niche driver that as a result is very hard to test.
> And the reason for the fear is the initial negative reaction from the
> qemu side.  And no if it's there we can't just drop it.
> 

That is certainly a reasonable concern.. 

> > > > However at this point given that there is a 3x performance gap between
> > > > virtio-scsi-raw + virtio-scsi+tcm_vhost for random mixed small block
> > > > I/O, and we still need the latter to do proper SCSI CDB passthrough for
> > > > non TYPE_DISK devices I'm hoping that we can agree on userspace bits
> > > > once tcm_vhost is merged.
> > > > 
> > > > --nab
> > > 
> > > I do think upstream kernel would help you nail userspace issues too
> > > but at this point it looks like either staging meterial or 3.6 is too
> > > early.
> > > 
> > 
> > I think for-3.6 is just the right time for this kernel code.  Seriously,
> > The basic ABI fabric layout for /sys/kernel/config/target/vhost/ is
> > going to be the same now for-3.6, the same for-3.7, and the same for .38
> > code. 
> > 
> > I'd be happy to move tcm_vhost back to drivers/target/ for now, and we
> > move it to drivers/vhost/ once the userspace bits are worked out..?
> > 
> > Would that be a reasonable compromise to move forward..?
> > 
> > --nab
> 
> I don't see how it helps.  The driver is either a guaranteed ABI or not.
> I'd prefer not to have vhost users outside drivers/vhost/ since it is
> harder for me to keep track of them.
> 
> What's the problem with staging proposal? It's just another hoop to jump
> through to enable it?
> 

Yeah, I'm OK with just adding a CONFIG_STAGING tag is a reasonable step
forward for-3.6.

Adding the following patch into target-pending/for-next-merge now:

diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index ccbeb6f..2cd7135 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -11,7 +11,7 @@ config VHOST_NET
 
 config TCM_VHOST
        tristate "TCM_VHOST fabric module (EXPERIMENTAL)"
-       depends on TARGET_CORE && EVENTFD && EXPERIMENTAL && m
+       depends on TARGET_CORE && EVENTFD && EXPERIMENTAL && STAGING && m
        default n
        ---help---
        Say M here to enable the TCM_VHOST fabric module for use with virtio-scsi guests
