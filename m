From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC 0/6] vhost/scsi: Add T10 PI SGL passthrough support
Date: Mon, 24 Feb 2014 22:05:11 -0800
Message-ID: <1393308311.12334.14.camel@haakon3.risingtidesystems.com>
References: <1393219950-18613-1-git-send-email-nab@daterainc.com>
	 <530B1DAF.7010702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <530B1DAF.7010702@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2014-02-24 at 11:23 +0100, Paolo Bonzini wrote:
> Il 24/02/2014 06:32, Nicholas A. Bellinger ha scritto:
> > AFAICT up until this point the ->prio field has been unused, but
> > I'm certainly open to better ways of signaling (to vhost) that some
> > number of metadata iovs are to be expected..  Any thoughts..?
> 
> Hi nab,
> 
> the virtio-scsi side of the patch is nice and readable.  As requested, 
> here are my thoughts on how to add it to the standard.
> 
> The ->prio field is there to mimic SAM's command priority field (8.7 in 
> my copy of the standard).  I'd rather leave it alone; I understand this 
> is the main reason why this patch is RFC.

Yes.  ;)

> 
> Since we have a new feature bit, we can add a new element before the 
> cdb.  It could be a count of scatter/gather list like you did here, or 
> it could be a byte count.  Even better, we can add _two_ new fields, one 
> for protection data out and one for protection data in.
> 

Having two 16-bit fields for data out / data in protection count in the
command header should be fine.

So that said, adding a new virtio_scsi_cmd_req_pi definition per your
recommendation, and will update the series to use this when the
VIRTIO_SCSI_F_T10_PI feature bit has been negotiated on both ends.

> Also, do we need an equivalent of the residual field, but for metadata?
> 

Mmm, at least for PI I don't think a residual field is necessary.

Any time the metadata is not fully read on outgoing WRITEs, or written
on incoming READs the next hop performing a VERIFY operation will end up
failing with a GUARD or REFERENCE TAG failure.

MKP..?

> Finally, any reason why you put the data sg elements before the metadata 
> sg elements?

Nope, no particular reason for this.

>  I would have thought that processing is a bit simpler if 
> either the metadata comes first, or you store in the command header the 
> data count (either sg or byte).  Because the virtio buffers form a 
> linked list, it's a bit backwards to put metadata last, and store 
> metadata count in the command header; it prevents you from processing 
> the buffers online because you don't know when the metadata starts. 
> Even though the Linux virtio layer always gives you a buffer count, this 
> need not be the case in general.
> 

No objection here.  Updating the patch series to place protection
information ahead of the actual data payload.

--nab
