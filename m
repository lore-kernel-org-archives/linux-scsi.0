From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Subject: Re: [PATCH] tcm_vhost: Expose ABI version via
	VHOST_SCSI_GET_ABI_VERSION
Date: Wed, 25 Jul 2012 12:55:52 +0100
Message-ID: <20120725115552.GB11098@stefanha-thinkpad.localdomain>
References: <1343093180-5598-1-git-send-email-nab@linux-iscsi.org>
	<20120724015634.GD4093@kroah.com>
	<1343162724.1813.111.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1343162724.1813.111.camel@haakon2.linux-iscsi.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, qemu-devel <qemu-devel@nongnu.org>, lf-virt <virtualization@lists.linux-foundation.org>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, target-devel <target-devel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Christoph Hellwig <hch@lst.de>, Avi Kivity <avi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 24, 2012 at 01:45:24PM -0700, Nicholas A. Bellinger wrote:
> On Mon, 2012-07-23 at 18:56 -0700, Greg Kroah-Hartman wrote:
> > On Tue, Jul 24, 2012 at 01:26:20AM +0000, Nicholas A. Bellinger wrote:
> > > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > > 
> > > As requested by Anthony, here is a patch against target-pending/for-next-merge
> > > to expose an ABI version to userspace via a new VHOST_SCSI_GET_ABI_VERSION
> > > ioctl operation.
> > > 
> > > As mentioned in the comment, ABI Rev 0 is for pre 2012 out-of-tree code, and
> > > ABI Rev 1 (the current rev) is for current WIP v3.6 kernel merge candiate code.
> > > 
> > > I think this is what you had in mind, and hopefully it will make MST happy too.
> > > The incremental vhost-scsi patches against Zhi's QEMU are going out shortly ahead
> > > of cutting a new vhost-scsi RFC over the next days.
> > > 
> > > Please have a look and let me know if you have any concerns here.
> > > 
> > > Thanks!
> > > 
> > > Reported-by: Anthony Liguori <aliguori@us.ibm.com>
> > > Cc: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
> > > Cc: Michael S. Tsirkin <mst@redhat.com>
> > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> > > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > > ---
> > >  drivers/vhost/tcm_vhost.c |    9 +++++++++
> > >  drivers/vhost/tcm_vhost.h |   11 +++++++++++
> > >  2 files changed, 20 insertions(+), 0 deletions(-)
> > > 
> 
> <SNIP>
> 
> > > diff --git a/drivers/vhost/tcm_vhost.h b/drivers/vhost/tcm_vhost.h
> > > index e942df9..3d5378f 100644
> > > --- a/drivers/vhost/tcm_vhost.h
> > > +++ b/drivers/vhost/tcm_vhost.h
> > > @@ -80,7 +80,17 @@ struct tcm_vhost_tport {
> > >  
> > >  #include <linux/vhost.h>
> > >  
> > > +/*
> > > + * Used by QEMU userspace to ensure a consistent vhost-scsi ABI.
> > > + *
> > > + * ABI Rev 0: All pre 2012 revisions used by prototype out-of-tree code
> > > + * ABI Rev 1: 2012 version for v3.6 kernel merge candiate
> > > + */
> > > +
> > > +#define VHOST_SCSI_ABI_VERSION	1
> > > +
> > >  struct vhost_scsi_target {
> > > +	int abi_version;
> > >  	unsigned char vhost_wwpn[TRANSPORT_IQN_LEN];
> > >  	unsigned short vhost_tpgt;
> > >  };
> > > @@ -88,3 +98,4 @@ struct vhost_scsi_target {
> > >  /* VHOST_SCSI specific defines */
> > >  #define VHOST_SCSI_SET_ENDPOINT _IOW(VHOST_VIRTIO, 0x40, struct vhost_scsi_target)
> > >  #define VHOST_SCSI_CLEAR_ENDPOINT _IOW(VHOST_VIRTIO, 0x41, struct vhost_scsi_target)
> > > +#define VHOST_SCSI_GET_ABI_VERSION _IOW(VHOST_VIRTIO, 0x42, struct vhost_scsi_target)
> > 
> > No, you just broke the ABI for version "0" here, that's not how you do
> > this at all.
> > 
> 
> The intention of this patch is use ABI=1 as a starting point for
> tcm_vhost moving forward, with no back-wards compat for the ABI=0
> prototype userspace code because:
> 
> - It's based on a slightly older version of QEMU (updating the QEMU series now)
> - It does not have an GET_ABI_VERSION ioctl cmd (that starts with ABI=1)
> - It has a small user-base of target + virtio-scsi developers
> 
> So I did consider just starting from ABI=0, but figured this would help
> reduce the confusion for QEMU userspace wrt to the vhost-scsi code
> that's been floating around out-of-tree for the last 2 years.

There is no real user base beyond the handful of people who have hacked
on this.  Adding the GET_ABI_VERSION ioctl() at this stage is fine,
especially considering that the userspace code that talks to tcm_vhost
isn't in mainline in userspace yet either.

Stefan
