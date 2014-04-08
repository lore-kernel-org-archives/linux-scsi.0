From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/6] virtio-scsi.h: Add virtio_scsi_cmd_req_pi + VIRTIO_SCSI_F_T10_PI
 bits
Date: Tue, 08 Apr 2014 16:31:26 -0400
Message-ID: <53445C9E.2040003@redhat.com>
References: <1396819929-29687-1-git-send-email-nab@daterainc.com> <1396819929-29687-2-git-send-email-nab@daterainc.com> <20140407095505.GA14432@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20140407095505.GA14432@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>, "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>
List-Id: linux-scsi@vger.kernel.org

Il 07/04/2014 05:55, Michael S. Tsirkin ha scritto:
>> > +	u16 do_pi_niov;		/* DataOUT PI Number of iovecs */
>> > +	u16 di_pi_niov;		/* DataIN PI Number of iovecs */
> So this looks like a somewhat problematic interface to me in that
> it talks in terms of iovecs not bytes.
> So this perpetuates the assumption that header is in a separate
> iov from data (and protection is separate from data).
> Arguably virtio doesn't work in terms of iovecs on the guest side so
> this naming looks strange.
> Further host side, get_vq_descs can in theory split a buffer to multiple
> iovecs if it crosses the boundary of a memory region.
>
> One solution is to use byte lengths here, but this does require
> that vhost scsi gets rid of layout assumptions generally.
> Not sure that's practical for -rc1.

Why does that require that vhost scsi gets rid of layout assumptions?

The interface uses bytes instead of iovecs as the unit, and vhost-scsi 
can add the (temporary...) requirement that do_pi_nbytes and 
di_pi_nbytes comprise an integer number of iovecs.

Paolo
