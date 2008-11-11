From: Christoph Hellwig <hch@infradead.org>
Subject: Re: thin provisioned LUN support
Date: Tue, 11 Nov 2008 12:33:27 -0500
Message-ID: <20081111173327.GA11080@infradead.org>
References: <4913028B.6010405@redhat.com> <20081111164028.GA29902@infradead.org> <4919BBC5.20809@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4919BBC5.20809@hp.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: jim owens <jowens@hp.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ric Wheeler <rwheeler@redhat.com>, David Woodhouse <dwmw2@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 11, 2008 at 12:07:17PM -0500, jim owens wrote:
> I agree with you. Thus my earlier assertion:
>
> - trim/unmap for SSD garbage collection has a different goal
>   than trim/unmap for thin provisioning.

Yes, I agree.

> In the Thin Provision mode, we want to delay them as you said:
>
>> So I think not actually doing these on every alloc/free is a good idea.
>> Instead the filesystem would free bits when big enough regions happen,
>
> to be filesystem friendly.
>
> But this won't change the block layer.  This is a per-filesystem
> coding issue to decide when to send the discard.

Yes.  But for this latter case large (or less so odd) unmap size aren't
that bothersome.  For the SSD use case they would be.  Note that
filesystems will need some SSD-awareness ayway, e.g. I have a local
hack for XFS that never bothers to look for extents in the by-bno
indexed, and I'm currently prototype a version that doesn't even update
it (could be converted back to a regular one using repair)

>
> jim
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
