From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] libata: Report zeroed read after Trim and max
	discard size
Date: Tue, 24 Nov 2009 09:35:08 -0500
Message-ID: <20091124143508.GB21629@infradead.org>
References: <1258771524-26673-1-git-send-email-martin.petersen@oracle.com> <1258771524-26673-4-git-send-email-martin.petersen@oracle.com> <20091121104923.GB30153@infradead.org> <yq11vjrskfu.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47293 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932987AbZKXOfW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2009 09:35:22 -0500
Content-Disposition: inline
In-Reply-To: <yq11vjrskfu.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, jens.axboe@oracle.com, james.bottomley@hansenpartnership.com, willy@wil.cx, jgarzik@pobox.com, sandeen@redhat.com, rwheeler@redhat.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Sat, Nov 21, 2009 at 03:16:05PM -0500, Martin K. Petersen wrote:
> I was trying to help Eric figure out why his drive pooped on big Trim
> requests.  For WRITE SAME the limit is inherent in the arguments,
> whereas our SATL implementation is limited by the 512-byte WRITE SAME
> payload.  So I needed a way to convey this up the stack.
> 
> Since you already return a B0 VPD page I thought it would be a
> convenient place to communicate the max without having to tweak the
> queue limits directly from within libata.
> 
> You are right that I'm relying on fuzziness in SBC which requires both
> the max LBA count and the descriptor count to be specified for UNMAP.

I think the better way is to make sure we can support any TRIM that
can be sent down.  Given that TRIM is not NCQ-capable we can just
allocate one buffer for the TRIM ranges per TRIM capable device.

