From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] Sanitize PQ3 device handling
Date: Wed, 18 May 2005 13:06:10 -0400
Message-ID: <428B7602.2060201@adaptec.com>
References: <428B0E4D.50505@suse.de> <20050518140140.GA22570@infradead.org> <428B4BB0.9040306@suse.de> <20050518141459.GA22916@infradead.org> <428B5239.5090502@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:15514 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262377AbVERRGO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2005 13:06:14 -0400
In-Reply-To: <428B5239.5090502@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 05/18/05 10:33, Hannes Reinecke wrote:
> Christoph Hellwig wrote:
> 
>>On Wed, May 18, 2005 at 04:05:36PM +0200, Hannes Reinecke wrote:
>>
>>>>If scsi_probe_and_add_lun returns SCSI_SCAN_TARGET_PRESENT sdev isn't valid at
>>>>this point.  You should probably default to SCSI_2 for that case.
>>>>
>>>
>>>How so? This is exactly the behaviour I've removed. sdev is valid even
>>>for SCSI_SCAN_TARGET_PRESENT.
>>>If not please show me.
>>
>>Indeed, you replaced the check at the end of scsi_probe_and_add_lun.  I don't
>>think it makes a lot of sense to leave around the stale scsi_dev for PQ3, though.
> 
> Why not? sg connects to it and you can ask it to provide lots of useless
> information. Eg doing an report_luns by hand if the configuration of the
> SAN has changed; PQ3 only states that _this_ device will never have a
> LUN attached.
> 
>>Doing a REPORT_LUNS for SCSI_SCAN_TARGET_PRESENT does OTOH make a lot of sense,
>>there's nothing in the spec against it.  So what about dropping that device
>>after we're done with REPORT_LUNS?
>>
> 
> See above. I'd like to have them around to be able to send commands to it.

I like this (Hannes') patch.  It makes those targets "addressable".

We do not necessarily want to care only about "live sdevs" -- a quiet SCSI
target sitting in the domain should be addressable as Hannes points out.
We should be able to send commands to it and get back responses as it
may cater other services, not as apparent as a block device.

	Luben
