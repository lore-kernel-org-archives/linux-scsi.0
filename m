From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, RFC] hide EH backup data outside the scsi_cmnd
Date: Mon, 24 Jul 2006 21:29:54 +0200
Message-ID: <20060724192954.GA10475@lst.de>
References: <20060603112610.GB17018@lst.de> <12c511ca0607241027y39498f37le4e5f2b320e01e4a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:39854 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1751352AbWGXTaK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jul 2006 15:30:10 -0400
Content-Disposition: inline
In-Reply-To: <12c511ca0607241027y39498f37le4e5f2b320e01e4a@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Luck <tony.luck@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, fischer@norbit.de, linux-scsi@vger.kernel.org

On Mon, Jul 24, 2006 at 10:27:55AM -0700, Tony Luck wrote:
> On 6/3/06, Christoph Hellwig <hch@lst.de> wrote:
> >Currently struct scsi_cmnd has various fields that are used to backup
> >original data after the corresponding fields have been overridden for
> >EH commands.  This means drivers can easily get at it and misuse it.
> >Due to the old_ naming this doesn't happen for most of them, but two
> >that have different names have been used wrong a lot (see previous
> >patch).
> 
> I guess that I'm an abuser  :-(
> 
> >Index: scsi-misc-2.6/include/scsi/scsi_cmnd.h
> 
> >-       void *buffer;           /* Data buffer */
> 
> arch/ia64/hp/sim/simscsi.c is still using this (and so doesn't compile
> now that this change has hit mainline).  It seems that simscsi.c is
> expecting to find a "scatterlist" there ... but looking at the rest of
> the patch that removed this element, it isn't obvious where it went.

Just change it to access the request_buffer member instead.  buffer
and request_buffer have been synonymous 99% of the time, and a driver
never even wants to access buffer.
