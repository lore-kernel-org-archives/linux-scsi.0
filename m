From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC-v2 0/4] tcm_vhost+cmwq fabric driver code for-3.6
Date: Tue, 17 Jul 2012 17:17:26 -0700
Message-ID: <1342570646.18004.549.camel@haakon2.linux-iscsi.org>
References: <1342041304-29728-1-git-send-email-nab@linux-iscsi.org>
	<20120717150548.GA11587@redhat.com>
	<1342559842.18004.440.camel@haakon2.linux-iscsi.org>
	<20120717213437.GC1868@redhat.com>
	<1342562528.18004.480.camel@haakon2.linux-iscsi.org>
	<20120717221814.GH1868@redhat.com>
	<1342564640.18004.492.camel@haakon2.linux-iscsi.org>
	<20120717231113.GA3004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20120717231113.GA3004@redhat.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm-devel <kvm@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, lf-virt <virtualization@lists.linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-07-18 at 02:11 +0300, Michael S. Tsirkin wrote:
> On Tue, Jul 17, 2012 at 03:37:20PM -0700, Nicholas A. Bellinger wrote:
> > On Wed, 2012-07-18 at 01:18 +0300, Michael S. Tsirkin wrote:
> > > On Tue, Jul 17, 2012 at 03:02:08PM -0700, Nicholas A. Bellinger wrote:
> > > > On Wed, 2012-07-18 at 00:34 +0300, Michael S. Tsirkin wrote:

<SNIP>

> > > 
> > > I don't see how it helps.  The driver is either a guaranteed ABI or not.
> > > I'd prefer not to have vhost users outside drivers/vhost/ since it is
> > > harder for me to keep track of them.
> > > 
> > > What's the problem with staging proposal? It's just another hoop to jump
> > > through to enable it?
> > > 
> > 
> > Yeah, I'm OK with just adding a CONFIG_STAGING tag is a reasonable step
> > forward for-3.6.
> > 
> > Adding the following patch into target-pending/for-next-merge now:
> > 
> > diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> > index ccbeb6f..2cd7135 100644
> > --- a/drivers/vhost/Kconfig
> > +++ b/drivers/vhost/Kconfig
> > @@ -11,7 +11,7 @@ config VHOST_NET
> >  
> >  config TCM_VHOST
> >         tristate "TCM_VHOST fabric module (EXPERIMENTAL)"
> > -       depends on TARGET_CORE && EVENTFD && EXPERIMENTAL && m
> > +       depends on TARGET_CORE && EVENTFD && EXPERIMENTAL && STAGING && m
> >         default n
> >         ---help---
> >         Say M here to enable the TCM_VHOST fabric module for use with virtio-scsi guests
> > 
> > 
> 
> Hmm that's not explicit enough, someone might enable CONFIG_STAGING for
> some other reason and won't notice the dependency.
> We need it to appear with other staging drivers in the menu,
> so there needs to be a Kconfig that is included from
> drivers/staging/Kconfig.
> 

Mmmmm, I am sensing a linux-next merge conflict with staging-next and/or
another for-next-merge rebase coming on..

> For example, we can create
> drivers/vhost/staging/Kconfig or drivers/vhost/tcm/Kconfig and include
> it from drivers/staging/Kconfig.  nouveau did something like this for a
> while, see f3c93cbde7eab38671ae085cb1027b08f5f36757.
> 
> No need to move the rest of the code.
> 

OK, lets use drivers/vhost/tcm/Kconfig and I'll post a incremental patch
to make it appear under staging it shortly.

(CC'ing Greg-KH for good measure.)
