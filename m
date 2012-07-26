From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] tcm_vhost: Expose ABI version via
 VHOST_SCSI_GET_ABI_VERSION
Date: Wed, 25 Jul 2012 19:34:21 -0700
Message-ID: <1343270061.1813.181.camel@haakon2.linux-iscsi.org>
References: <1343093180-5598-1-git-send-email-nab@linux-iscsi.org>
	 <20120724015634.GD4093@kroah.com>
	 <1343162724.1813.111.camel@haakon2.linux-iscsi.org>
	 <20120725115552.GB11098@stefanha-thinkpad.localdomain>
	 <1343250890.1813.173.camel@haakon2.linux-iscsi.org>
	 <20120725223559.GA4786@stefanha-thinkpad.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20120725223559.GA4786@stefanha-thinkpad.localdomain>
Sender: target-devel-owner@vger.kernel.org
To: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, kvm-devel <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, Avi Kivity <avi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-07-25 at 23:35 +0100, Stefan Hajnoczi wrote:
> On Wed, Jul 25, 2012 at 02:14:50PM -0700, Nicholas A. Bellinger wrote:
> > On Wed, 2012-07-25 at 12:55 +0100, Stefan Hajnoczi wrote:
> > > On Tue, Jul 24, 2012 at 01:45:24PM -0700, Nicholas A. Bellinger wrote:
> > > > On Mon, 2012-07-23 at 18:56 -0700, Greg Kroah-Hartman wrote:
> > > > > On Tue, Jul 24, 2012 at 01:26:20AM +0000, Nicholas A. Bellinger wrote:
> > > > > > From: Nicholas Bellinger <nab@linux-iscsi.org>

<SNIP>

> > > > The intention of this patch is use ABI=1 as a starting point for
> > > > tcm_vhost moving forward, with no back-wards compat for the ABI=0
> > > > prototype userspace code because:
> > > > 
> > > > - It's based on a slightly older version of QEMU (updating the QEMU series now)
> > > > - It does not have an GET_ABI_VERSION ioctl cmd (that starts with ABI=1)
> > > > - It has a small user-base of target + virtio-scsi developers
> > > > 
> > > > So I did consider just starting from ABI=0, but figured this would help
> > > > reduce the confusion for QEMU userspace wrt to the vhost-scsi code
> > > > that's been floating around out-of-tree for the last 2 years.
> > > 
> > > There is no real user base beyond the handful of people who have hacked
> > > on this.  Adding the GET_ABI_VERSION ioctl() at this stage is fine,
> > > especially considering that the userspace code that talks to tcm_vhost
> > > isn't in mainline in userspace yet either.
> > 
> > 
> > Do you have a preference for a VHOST_SCSI_ABI_VERSION starting point
> > here..?
> > 
> > I thought that v1 would be helpful to avoid confusion with the older
> > userspace code, but don't really have a strong opinion either way..
> > 
> > Let me know what you'd prefer here, and I'll make the changes to
> > tcm_vhost + vhost-scsi patch series accordingly.
> 
> I don't think 0 for out-of-tree is needed.  I'd start at 0 but either
> way is okay.
> 

<nod>

In that case, respinning a -v5 for tcm_vhost to start from ABI=0 and
will post an updated patch shortly.

> The main thing I would like to confirm is that this only versions the
> tcm_vhost ioctls?  In that case a single version number works.
> 

Correct, the GET_ABI_VERSION call is only intended to identify the
changing of tcm_vhost ioctls.
