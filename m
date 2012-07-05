From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 6/6] virtio-scsi: Set shost->max_id=1 for tcm_vhost WWPNs
Date: Wed, 04 Jul 2012 19:05:40 -0700
Message-ID: <1341453940.23954.229.camel@haakon2.linux-iscsi.org>
References: <1341375846-27882-1-git-send-email-nab@linux-iscsi.org>
	<1341375846-27882-7-git-send-email-nab@linux-iscsi.org>
	<4FF45850.20501@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <4FF45850.20501@redhat.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm-devel <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-07-04 at 16:50 +0200, Paolo Bonzini wrote:
> Il 04/07/2012 06:24, Nicholas A. Bellinger ha scritto:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This is currently required for connecting to tcm_vhost in order to prevent
> > the client LUN scan from detecting the same tcm_vhost WWPN on multiple target
> > IDs.
> 
> But that's what the config field is for... why can't tcm_vhost (or QEMU)
> set max_id to 0?
> 

So this patch was carried forward from Stefan's original code that I
thought was required due to other limitations..

If that's not the case anymore I'm happy to drop it for now and look
into a proper fix outside of virtio-scsi.

> Paolo
> 
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
> > Cc: Zhi Yong Wu <wuzhy@cn.ibm.com>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Hannes Reinecke <hare@suse.de>
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/scsi/virtio_scsi.c |    5 ++++-
> >  1 files changed, 4 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> > index 391b30d..8711951 100644
> > --- a/drivers/scsi/virtio_scsi.c
> > +++ b/drivers/scsi/virtio_scsi.c
> > @@ -475,7 +475,10 @@ static int __devinit virtscsi_probe(struct virtio_device *vdev)
> >  	shost->cmd_per_lun = min_t(u32, cmd_per_lun, shost->can_queue);
> >  	shost->max_sectors = virtscsi_config_get(vdev, max_sectors) ?: 0xFFFF;
> >  	shost->max_lun = virtscsi_config_get(vdev, max_lun) + 1;
> > -	shost->max_id = virtscsi_config_get(vdev, max_target) + 1;
> > +	/*
> > +	 * Currently required for tcm_vhost to function..
> > +	 */
> > +	shost->max_id = 1;
> >  	shost->max_channel = 0;
> >  	shost->max_cmd_len = VIRTIO_SCSI_CDB_SIZE;
> >  	err = scsi_add_host(shost, &vdev->dev);
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
