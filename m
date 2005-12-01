From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] aacraid: simplify non-dasd support
Date: Thu, 1 Dec 2005 17:55:09 +0000
Message-ID: <20051201175509.GA13470@infradead.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F01E3E138@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:44459 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932374AbVLARzN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Dec 2005 12:55:13 -0500
Content-Disposition: inline
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F01E3E138@otce2k03.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mark Haverkamp <markh@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Nov 30, 2005 at 02:29:10PM -0500, Salyzyn, Mark wrote:
> Christoph Hellwig [mailto:hch@infradead.org] writes:
> > NACK on the write filter.  If we can agree on it beeing 
> > useful (and I must
> > admit I tend to the contrary opinion) it should be done in 
> > higher layers.
> 
> Our customers won't stand still if we do not write (and read) protect
> the raid components. So you propose the introduction of an
> sdev->io_protect flag?

write a patch to do it and argue for it.  in the driver it's in the
wrong place for certain and not acceptable by any means.

> > Also why do we need the !sdev->no_uld_attach && !sdev->channel checks?
> 
> This is additional insurance, the fact that channel 0 is the array
> channel. We do not want the no_uld_attach to be part of the array
> channel.

But again the invariant is that no_uld_attach is never going to be set
for channel 0.  Just checking for channel 0 is fine with me, although
a 

#define AAC_RAID_CHANNEL	0

would be even better to explain what's going on.  Similar issue is
the tagged_supported check, it's totally magic to me and at least needs
a very good comment.
