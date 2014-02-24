From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC 0/6] vhost/scsi: Add T10 PI SGL passthrough support
Date: Mon, 24 Feb 2014 11:23:43 +0100
Message-ID: <530B1DAF.7010702@redhat.com>
References: <1393219950-18613-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1393219950-18613-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

Il 24/02/2014 06:32, Nicholas A. Bellinger ha scritto:
> AFAICT up until this point the ->prio field has been unused, but
> I'm certainly open to better ways of signaling (to vhost) that some
> number of metadata iovs are to be expected..  Any thoughts..?

Hi nab,

the virtio-scsi side of the patch is nice and readable.  As requested, 
here are my thoughts on how to add it to the standard.

The ->prio field is there to mimic SAM's command priority field (8.7 in 
my copy of the standard).  I'd rather leave it alone; I understand this 
is the main reason why this patch is RFC.

Since we have a new feature bit, we can add a new element before the 
cdb.  It could be a count of scatter/gather list like you did here, or 
it could be a byte count.  Even better, we can add _two_ new fields, one 
for protection data out and one for protection data in.

Also, do we need an equivalent of the residual field, but for metadata?

Finally, any reason why you put the data sg elements before the metadata 
sg elements?  I would have thought that processing is a bit simpler if 
either the metadata comes first, or you store in the command header the 
data count (either sg or byte).  Because the virtio buffers form a 
linked list, it's a bit backwards to put metadata last, and store 
metadata count in the command header; it prevents you from processing 
the buffers online because you don't know when the metadata starts. 
Even though the Linux virtio layer always gives you a buffer count, this 
need not be the case in general.

Paolo
