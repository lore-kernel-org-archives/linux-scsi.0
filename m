From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Integrated Unit Attention handling
Date: Wed, 17 Dec 2014 01:31:28 -0800
Message-ID: <20141217093128.GB13198@infradead.org>
References: <548EFB97.2080501@suse.de>
 <20141216083245.GA29219@infradead.org>
 <5490501A.2020706@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52566 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbaLQJb2 (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Wed, 17 Dec 2014 04:31:28 -0500
Content-Disposition: inline
In-Reply-To: <5490501A.2020706@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>

On Tue, Dec 16, 2014 at 04:30:34PM +0100, Hannes Reinecke wrote:
> On 12/16/2014 09:32 AM, Christoph Hellwig wrote:
> > Sounds like a good topic, altough I hope we'll see considerable
> > progress before LSF on this item..
> > 
> Full integration requires a change of the SCSI device model;
> currently struct scsi_device has a fixed type and inquiry data, so
> rescan is essentially a no-op.
> So the current model requires the complete removal of the device and
> a rescan on the host.
> Doing that from within the SCSI stack will open quite some
> interesting race conditions, let alone interesting userspace
> interactions.
> Alternatively we can change the model to allow for a change of the
> inquiry data, but that should be discussed.

For now we can just react to new LUNs or size changes, which would be
what most people want, and offline devices for anything else.

That alone would be a gigantic improvement.
