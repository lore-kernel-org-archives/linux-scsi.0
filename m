From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] fcoe: Reduce max_sectors to 1024
Date: Wed, 09 Jul 2014 08:40:30 +0200
Message-ID: <53BCE3DE.6000605@suse.de>
References: <1404886581-3218-1-git-send-email-hare@suse.de> <20140709061838.GA28335@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37078 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbaGIGkd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jul 2014 02:40:33 -0400
In-Reply-To: <20140709061838.GA28335@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Vasu Dev <vasu.dev@linux.intel.com>

On 07/09/2014 08:18 AM, Christoph Hellwig wrote:
> On Wed, Jul 09, 2014 at 08:16:21AM +0200, Hannes Reinecke wrote:
>> The DDP offload on ixgbe is only capable of handling requests up
>> to 1024 sectors. So we should be exposing this to avoid spurious
>> messages about 'not enough user buffers'.
>
> Shouldn't the network driver be able to communicate it's offload
> capabilities to the fcoe core?  I'd be happy to take this as an iteri=
m
> fix if there's a comment explaining it, but long-term it should be
> driver specific.
>
ixgbe can handle up to 256 sgl elements, but the maximum single I/O=20
size is 256 pages. This translates into 1024 sectors.

And seeing that the 'fcoe' driver is effectively tied to ixgbe ATM I=20
doubt it's worth investing in yet another callout here.
Intel, can you clarify on i40e? Is it FCoE capable?
If so it might be worth adding a configuration knob here.
Unless i40e has the same limitations as ixgbe ...

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
