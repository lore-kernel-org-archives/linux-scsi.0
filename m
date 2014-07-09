From: Vasu Dev <vasu.dev@linux.intel.com>
Subject: Re: [PATCH] fcoe: Reduce max_sectors to 1024
Date: Wed, 09 Jul 2014 11:58:33 -0700
Message-ID: <1404932313.12914.36.camel@vfc0>
References: <1404886581-3218-1-git-send-email-hare@suse.de>
	 <20140709061838.GA28335@infradead.org>  <53BCE3DE.6000605@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24356 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbaGIS6i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jul 2014 14:58:38 -0400
In-Reply-To: <53BCE3DE.6000605@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, fcoe-devel@open-fcoe.org

On Wed, 2014-07-09 at 08:40 +0200, Hannes Reinecke wrote:
> On 07/09/2014 08:18 AM, Christoph Hellwig wrote:
> > On Wed, Jul 09, 2014 at 08:16:21AM +0200, Hannes Reinecke wrote:
> >> The DDP offload on ixgbe is only capable of handling requests up
> >> to 1024 sectors. So we should be exposing this to avoid spurious
> >> messages about 'not enough user buffers'.
> >
> > Shouldn't the network driver be able to communicate it's offload
> > capabilities to the fcoe core? 

Yes network driver can and that is the best way to go to allow HW/driver
specific max sectors limit but that would require new fcoe netdev
capability exposed since currently none to indicate fcoe IO size limit.

>  I'd be happy to take this as an iterim
> > fix if there's a comment explaining it, but long-term it should be
> > driver specific.
> >

I agree with all and for now comments make sense until long term fix
implemented as suggested by Christoph and that would require new netdev
capability.

> ixgbe can handle up to 256 sgl elements, but the maximum single I/O 
> size is 256 pages. This translates into 1024 sectors.
> 
> And seeing that the 'fcoe' driver is effectively tied to ixgbe ATM I 
> doubt it's worth investing in yet another callout here.
> Intel, can you clarify on i40e? Is it FCoE capable?
> If so it might be worth adding a configuration knob here.
> Unless i40e has the same limitations as ixgbe ...

Well within ixgbe some silicon could do lot more elements than 256 and
even first DDP silicon it could do more 256 elements with each could be
either 4K, 8K, 16K or 64K in size, it means largest IO size as 256*64K.
However current implementation limited to 512K IO size max (1024 max
sector) and this wasn't issue in most typically work loads with the
exception in some case SuSe work loads issuing larger than 512K IO size
and due to that SuSe already had it reduced to max_sector = 1024 with
this patch https://bugzilla.novell.com/show_bug.cgi?id=695898#c11 and
I'm fine with doing same limit for all in upsteam kernel in case IO
merging could lead to larger than 512K IO size for all fcoe network
drivers.

Does it limit IO size for pass through IO not through block layer ? 
 
Thanks,
Vasu

> 
> Cheers,
> 
> Hannes


