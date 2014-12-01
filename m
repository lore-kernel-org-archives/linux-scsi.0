From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v7 42/46] virtio_scsi: v1.0 support
Date: Mon, 1 Dec 2014 14:53:05 +0200
Message-ID: <20141201125305.GC18106@redhat.com>
References: <1417359787-10138-1-git-send-email-mst@redhat.com>
	<1417359787-10138-43-git-send-email-mst@redhat.com>
	<20141201135001.142bd29a.cornelia.huck@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <20141201135001.142bd29a.cornelia.huck@de.ibm.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: thuth@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, rusty@au1.ibm.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dahi@linux.vnet.ibm.com, "James E.J. Bottomley" <JBottomley@parallels.com>, pbonzini@redhat.com, David Miller <davem@davemloft.net>
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 01, 2014 at 01:50:01PM +0100, Cornelia Huck wrote:
> On Sun, 30 Nov 2014 17:12:47 +0200
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > Note: for consistency, and to avoid sparse errors,
> >   convert all fields, even those no longer in use
> >   for virtio v1.0.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  include/linux/virtio_scsi.h | 32 +++++++++++++++-------------
> >  drivers/scsi/virtio_scsi.c  | 51 ++++++++++++++++++++++++++++-----------------
> >  2 files changed, 49 insertions(+), 34 deletions(-)
> > 
> 
> > @@ -196,10 +196,13 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
> >  		break;
> >  	}
> > 
> > -	WARN_ON(resp->sense_len > VIRTIO_SCSI_SENSE_SIZE);
> > +	WARN_ON(virtio32_to_cpu(vscsi->vdev, resp->sense_len) >
> > +		VIRTIO_SCSI_SENSE_SIZE);
> 
> Introduce a local variable for this? Might make this statement and the
> min_t statement below easier to read.

I prefer 1:1 code conversions. We can do refactorings on top.
Since you mention this line as hard to read, I'll just make it > 80
chars for now, and trivial line splits can come later.
OK?

> >  	if (sc->sense_buffer) {
> >  		memcpy(sc->sense_buffer, resp->sense,
> > -		       min_t(u32, resp->sense_len, VIRTIO_SCSI_SENSE_SIZE));
> > +		       min_t(u32,
> > +			     virtio32_to_cpu(vscsi->vdev, resp->sense_len),
> > +			     VIRTIO_SCSI_SENSE_SIZE));
> >  		if (resp->sense_len)
> >  			set_driver_byte(sc, DRIVER_SENSE);
> >  	}
> 
> Otherwise looks good to me.
