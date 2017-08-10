From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: [PATCH 1/2] virtio: Reduce BUG if total_sg > virtqueue size to
 WARN.
Date: Thu, 10 Aug 2017 22:50:12 +0100
Message-ID: <20170810215012.GD20914@redhat.com>
References: <20170810164035.19963-1-rjones@redhat.com>
 <20170810164035.19963-2-rjones@redhat.com>
 <20170811001447-mutt-send-email-mst@kernel.org>
 <20170810213038.GC20914@redhat.com>
 <20170811003107-mutt-send-email-mst@kernel.org>
 <20170810213511.GB10017@redhat.com>
 <20170811003621-mutt-send-email-mst@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170811003621-mutt-send-email-mst@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, jasowang@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, hch@lst.de, pbonzini@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 11, 2017 at 12:41:47AM +0300, Michael S. Tsirkin wrote:
> On Thu, Aug 10, 2017 at 10:35:11PM +0100, Richard W.M. Jones wrote:
> > On Fri, Aug 11, 2017 at 12:31:44AM +0300, Michael S. Tsirkin wrote:
> > > Then we probably should fail probe if vq size is too small.
> > 
> > What does this mean?
> > 
> > Rich.
> 
> We must prevent driver from submitting s/g lists > vq size to device.

Fair point.  I would have thought (not knowing anything about how this
works in the kernel) that the driver should be able to split up
scatter-gather lists if they are larger than what the driver supports?

Anyway the commit message is derived from what Paolo told me on IRC,
so let's see what he says.

Rich.

> Either tell linux to avoid s/g lists that are too long, or
> simply fail request if this happens, or refuse to attach driver to device.
> 
> Later option would look something like this within probe:
> 
>         for (i = VIRTIO_SCSI_VQ_BASE; i < num_vqs; i++)
> 		if (vqs[i]->num < MAX_SG_USED_BY_LINUX)
> 			goto err;
> 
> 
> I don't know what's MAX_SG_USED_BY_LINUX though.
> 
> > -- 
> > Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
> > Read my programming and virtualization blog: http://rwmj.wordpress.com
> > virt-builder quickly builds VMs from scratch
> > http://libguestfs.org/virt-builder.1.html

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-builder quickly builds VMs from scratch
http://libguestfs.org/virt-builder.1.html
