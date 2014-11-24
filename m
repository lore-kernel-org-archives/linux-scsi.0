From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] megaraid_sas: Enable shared host tag map
Date: Mon, 24 Nov 2014 16:51:14 +0100
Message-ID: <547353F2.1040005@suse.de>
References: <1416843235-35947-1-git-send-email-hare@suse.de> <20141124153558.GA27364@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48369 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbaKXPvP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2014 10:51:15 -0500
In-Reply-To: <20141124153558.GA27364@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <jbottomley@parallels.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Kashyap Desai <kashyap.desai@avagotech.com>, linux-scsi@vger.kernel.org

On 11/24/2014 04:35 PM, Christoph Hellwig wrote:
> On Mon, Nov 24, 2014 at 04:33:55PM +0100, Hannes Reinecke wrote:
>> The megaraid SAS driver uses a shared host tag map internally,
>> so we should be telling the block layer about it.
>=20
> But it doesn't make use of request->tag yet.  This would only be
> useful if you got rid of the internal tag allocator.
>=20
It is useful as is, as we'll be getting prefixed logging output :-)

But yeah, it would be good to get rid of the internal tag allocator.

Which I didn't do yet as the driver is using a larger tag map than
that one announced to the block layer.
This is to facilitate internal command submission, which should
always work independent on any tag starvation issues from the
upper layers.

So when moving to the generic tag allocation code I'd need:
- an block-layer helper for allocating a tag without a request
  (basically separating the existing blk-tag functionality, easy)
- introducing 'emergency pools' for the tag map, allowing to
  allocate a tag even under I/O pressure.

What I did was to:
- Split off blk_reserve_tag() functionality from blk_start_tag()
  (and similar with blk_end_tag)
- registered the overall size of the shared tag map
- called blk_resize_tags() to shrink it to ->can_queue
- Implemented a 'force' attribute to blk_reserve_tag() to
  allow it to dip into the excess size.

But then I didn't really like this mis-use of the blk_resize_tag()
operation; I'd rather have it marked explicitly.

However, I'm sure megasas isn't the only driver requiring such a
feature (libata eg would benefit from this, too).

Ideas?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
