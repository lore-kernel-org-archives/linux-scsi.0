From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] virtio-scsi: Add vdrv->scan for post
	VIRTIO_CONFIG_S_DRIVER_OK LUN scanning
Date: Wed, 11 Jul 2012 14:26:32 -0700
Message-ID: <1342041992.18004.20.camel@haakon2.linux-iscsi.org>
References: <1341605705-13114-1-git-send-email-nab@linux-iscsi.org>
	<1342031856.3522.41.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1342031856.3522.41.camel@dabdike.int.hansenpartnership.com>
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
Cc: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm-devel <kvm@vger.kernel.org>, "Michael
	S. Tsirkin" <mst@redhat.com>, stable@vger.kernel.org, Zhi Yong Wu <wuzhy@cn.ibm.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, lf-virt <virtualization@lists.linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-07-11 at 19:37 +0100, James Bottomley wrote:
> On Fri, 2012-07-06 at 20:15 +0000, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch changes virtio-scsi to use a new virtio_driver->scan() callback
> > so that scsi_scan_host() can be properly invoked once virtio_dev_probe() has
> > set add_status(dev, VIRTIO_CONFIG_S_DRIVER_OK) to signal active virtio-ring
> > operation, instead of from within virtscsi_probe().
> > 
> > This fixes a bug where SCSI LUN scanning for both virtio-scsi-raw and
> > virtio-scsi/tcm_vhost setups was happening before VIRTIO_CONFIG_S_DRIVER_OK
> > had been set, causing VIRTIO_SCSI_S_BAD_TARGET to occur.  This fixes a bug
> > with virtio-scsi/tcm_vhost where LUN scan was not detecting LUNs.
> > 
> > Tested with virtio-scsi-raw + virtio-scsi/tcm_vhost w/ IBLOCK on 3.5-rc2 code.
> > 
> > Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
> > Cc: Zhi Yong Wu <wuzhy@cn.ibm.com>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Hannes Reinecke <hare@suse.de>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/scsi/virtio_scsi.c |   15 ++++++++++++---
> >  drivers/virtio/virtio.c    |    5 ++++-
> >  include/linux/virtio.h     |    1 +
> >  3 files changed, 17 insertions(+), 4 deletions(-)
> 
> This doesn't apply:
> 
> patching file drivers/scsi/virtio_scsi.c
> Hunk #1 succeeded at 677 (offset 196 lines).
> Hunk #2 FAILED at 494.
> Hunk #3 succeeded at 736 (offset 198 lines).
> 1 out of 3 hunks FAILED -- saving rejects to file
> drivers/scsi/virtio_scsi.c.rej
> 
> could you respin against scsi-misc head?
> 

The updated patch is on it's way rebased against scsi.git/misc.

Thanks James!
