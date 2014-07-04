From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: break from queue depth adjusting loops when device
 found
Date: Fri, 04 Jul 2014 12:53:00 +0200
Message-ID: <53B6878C.502@suse.de>
References: <20140703150557.21608.37072.stgit@beardog.cce.hp.com> <20140703171106.GA16788@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51860 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901AbaGDKxF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Jul 2014 06:53:05 -0400
In-Reply-To: <20140703171106.GA16788@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: james.bottomley@parallels.com, elliott@hp.com, stephenmcameron@gmail.com, linux-scsi@vger.kernel.org, Vasu Dev <vasu.dev@linux.intel.com>, Mike Christie <michaelc@cs.wisc.edu>

On 07/03/2014 07:11 PM, Christoph Hellwig wrote:
> On Thu, Jul 03, 2014 at 10:05:57AM -0500, Stephen M. Cameron wrote:
>> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>>
>> Don't loop through all the devices even after
>> finding the one we're looking for
>
> The comments in the code seem to indicate that we want to modify
> the queue depth for all LUNs on a given target.
>
> Ccing Mike and Vasu as they wrote this code.
>
Indeed, that was the idea.
This piece of code tries to keep track of the remote port queue=20
depth, which isn't represented at all.
Thing is, each remote target has a target queue depth which can hold=20
only so many outstanding SCSI requests. If that is full it'll return=20
BUSY for _all_ LUNs served from that port.
And the very _next_ command after the one which filled the target=20
queue will get the BUSY status.
So we need to decrease the queue depth on _all_ LUNs here to avoid=20
starvation of individual devices.

Hence I guess this is not the correct fix.

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
