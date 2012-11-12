From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] USB enclosures seem to require read(16) with >2TB drives
Date: Mon, 12 Nov 2012 15:28:19 +0000
Message-ID: <1352734099.2449.36.camel@dabdike.int.hansenpartnership.com>
References: <1352477289-8133-1-git-send-email-hernejj@gmail.com>
	 <1352719990.2449.23.camel@dabdike.int.hansenpartnership.com>
	 <50A10856.6090009@redhat.com>
	 <CAJiM5SY+j-KK2WbFcvi9ij4L6qeJG4a9Q+971d37Cmyo0-hBog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46589 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752004Ab2KLP2Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Nov 2012 10:28:25 -0500
In-Reply-To: <CAJiM5SY+j-KK2WbFcvi9ij4L6qeJG4a9Q+971d37Cmyo0-hBog@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Jason J. Herne" <hernejj@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>

On Mon, 2012-11-12 at 10:01 -0500, Jason J. Herne wrote:
> > Any reason not to do this always on >2TB drives, which basically means
> > changing this:
> >
> > -       } else if (block > 0xffffffff) {
> > +       } else if (sdkp->capacity > 0xffffffff) {
> >
> > and nothing else?
> 
> This was the intent of my patch, except I wanted to *only* affect USB based
> drives as my drive was functioning perfecting when connected to an internal
> Sata port.  I was adopting the "Do not fix what isn't broke" mentality.

There's a subtlety here: block is in units of the disk sector size,
sdkp->capacity is in units of 512 bytes (the linux native sector size),
so it would need shifting before doing the determination.

James


