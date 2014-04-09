From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 1/6] virtio-scsi.h: Add virtio_scsi_cmd_req_pi +
 VIRTIO_SCSI_F_T10_PI bits
Date: Wed, 9 Apr 2014 16:22:39 +0300
Message-ID: <20140409132239.GE10874@redhat.com>
References: <1396819929-29687-1-git-send-email-nab@daterainc.com>
 <1396819929-29687-2-git-send-email-nab@daterainc.com>
 <20140407095505.GA14432@redhat.com>
 <53445C9E.2040003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53445C9E.2040003@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 08, 2014 at 04:31:26PM -0400, Paolo Bonzini wrote:
> Il 07/04/2014 05:55, Michael S. Tsirkin ha scritto:
> >>> +	u16 do_pi_niov;		/* DataOUT PI Number of iovecs */
> >>> +	u16 di_pi_niov;		/* DataIN PI Number of iovecs */
> >So this looks like a somewhat problematic interface to me in that
> >it talks in terms of iovecs not bytes.
> >So this perpetuates the assumption that header is in a separate
> >iov from data (and protection is separate from data).
> >Arguably virtio doesn't work in terms of iovecs on the guest side so
> >this naming looks strange.
> >Further host side, get_vq_descs can in theory split a buffer to multiple
> >iovecs if it crosses the boundary of a memory region.
> >
> >One solution is to use byte lengths here, but this does require
> >that vhost scsi gets rid of layout assumptions generally.
> >Not sure that's practical for -rc1.
> 
> Why does that require that vhost scsi gets rid of layout assumptions?
> 
> The interface uses bytes instead of iovecs as the unit, and
> vhost-scsi can add the (temporary...) requirement that do_pi_nbytes
> and di_pi_nbytes comprise an integer number of iovecs.
> 
> Paolo

That would be a reasonable intermediate step, but I'm worried there
are more assumptions lurking in tere.

In particular is it legal for PI to be in the same iov
entry as data? If not they really need to use a
separate buf entry.

-- 
MST
