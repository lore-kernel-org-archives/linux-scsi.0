From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] updated: suspending I/Os to a device
Date: Wed, 11 Aug 2004 23:11:37 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040811231137.A1038@infradead.org>
References: <0B1E13B586976742A7599D71A6AC733C02D7D3@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:783 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S268265AbUHKWLn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Aug 2004 18:11:43 -0400
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C02D7D3@xbl3.ma.emulex.com>; from James.Smart@Emulex.Com on Tue, Aug 10, 2004 at 05:00:40PM -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Tue, Aug 10, 2004 at 05:00:40PM -0400, James.Smart@Emulex.Com wrote:
> Well - it's not necessarily fc-specific, as I would assume USB, iSCSI, etc also would like to do the same thing. But, as far as just putting it in the device structure - I had the same thoughts. One thing that influenced this was JamesB's comments on not wanting all devices to have the structure, just those being on LLDD's that need to deal with this.  Note - "recovery" as a name was just randomly picked based on this 1 element. Are there perhaps other things that may fit this same definition (cross transport, but optional) ?  If so - is it better to rename this template ?

I don't like the complexitly this adds and would prefer it in scsi_device
over this.  Seems like James and me disagree on this.

> Also - does it really make sense to have the midlayer own the timer and calling cancel when it expires ? Or is it better to have the LLDD own it, calling continue when it expires, and letting the subsequent i/o failures take the device offline ?  The midlayer owning the timer seems more protectionist, but is it better ?

Sounds like we could start by having this in the driver and when we see that
lots of drivers use it we can still move it to the midlayer.

