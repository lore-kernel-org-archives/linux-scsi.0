From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH 1/5] sd: configure ZBC devices
Date: Mon, 25 Jul 2016 09:24:41 -0400
Message-ID: <1469453081.4042.36.camel@localhost.localdomain>
References: <1468934710-93876-1-git-send-email-hare@suse.de>
	 <1468934710-93876-2-git-send-email-hare@suse.de>
	 <1469224578.4042.34.camel@localhost.localdomain>
	 <a3d658d8-ad55-2888-aca5-d30476767526@suse.com>
	 <71c26e2a-98d6-ce14-6147-4b7a29c2cbd5@sandisk.com>
	 <301cd944-24a2-cfe8-50d3-4472df20bca8@suse.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbcGYNYo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2016 09:24:44 -0400
In-Reply-To: <301cd944-24a2-cfe8-50d3-4472df20bca8@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Damien Le Moal <damien.lemoal@hgst.com>

On Mon, 2016-07-25 at 08:00 +0200, Hannes Reinecke wrote:
> On 07/24/2016 12:04 AM, Bart Van Assche wrote:
> > On 07/23/16 13:31, Hannes Reinecke wrote:
> >> On 07/22/2016 11:56 PM, Ewan D. Milne wrote:
> >>>
> >>> So, blk_queue_chunk_sectors() has:
> >>>
> >>> void blk_queue_chunk_sectors(struct request_queue *q, unsigned int
> >>> chunk_sectors)
> >>> {
> >>>         BUG_ON(!is_power_of_2(chunk_sectors));
> >>>         q->limits.chunk_sectors = chunk_sectors;
> >>> }
> >>>
> >>> and it seems like if some device reports a non-power-of-2 zone_len
> >>> then we
> >>> will BUG_ON().  Probably would be better if we reported an error
> >>> instead?
> >>>
> >> The ZBC spec mandates that the zone size must be a power of 2.
> >> So I don't have problems with triggering a BUG_ON for non-compliant
> >> drives.
> > 
> > Triggering BUG_ON() if zone_len is not a power of two is completely
> > unacceptable. No matter what zone information a ZBC drive exports that
> > shouldn't result in a kernel oops.
> > 
> Ok, will be fixing this.
> 
> Cheers,
> 
> Hannes

Yes, unfortunately we have too much history with non-compliant devices.
And, I much prefer to avoid crashing the kernel if it is not necessary.

Thanks.

-Ewan


