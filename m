From: Hannes Reinecke <hare@suse.de>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC][LSF/MM ATTEND] blk-mq and I/O scheduling
Date: Mon, 29 Feb 2016 08:21:37 +0800
Message-ID: <56D38F11.1010003@suse.de>
References: <20160226161052.GA4089@suselix.suse.de>
 <20160228161343.GA22246@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43737 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbcB2AVr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Feb 2016 19:21:47 -0500
In-Reply-To: <20160228161343.GA22246@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Andreas Herrmann <aherrmann@suse.com>
Cc: lsf-pc@lists.linuxfoundation.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org

On 02/29/2016 12:13 AM, Christoph Hellwig wrote:
> I was still hoping we'd get your slicing patches in ASAP at least.
> But there are couple more topics here, so I think it would
> still be useful in that case.
>=20
Actually I have been pondering an alternative approach.
In most cases submit_bio() / submit_bh() is called in a loop, submittin=
g
several bios in one go.
These bios typically refer to a larger piece of memory, so merging
should be trivial here.
However, both submit_bh() and submit_bio() will never convey this
information, so they will be placed on the queue as individual bios.

If we manage to link the generated bios together we can trivially
implement merging, even for the mq case.
One idea here is to add plugging around the callers, or to allow for
linked bios to be submitted.

I see if I can make some tests here.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
