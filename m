From: James.Smart@Emulex.Com
Subject: RE: [Patch RFC] Add FC transport host statistics
Date: Thu, 14 Oct 2004 16:14:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0B1E13B586976742A7599D71A6AC733C0866E0@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:13291 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S267508AbUJNUOd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Oct 2004 16:14:33 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, michaelc@cs.wisc.edu

All reasonable things....  The offset stuff I had stolen from the net statistics code.

-- james

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Thursday, October 14, 2004 2:43 PM
> To: Smart, James
> Cc: linux-scsi@vger.kernel.org; andrew.vasquez@qlogic.com;
> michaelc@cs.wisc.edu
> Subject: Re: [Patch RFC] Add FC transport host statistics
> 
> 
> +	if (offset > sizeof(struct fc_host_statistics) ||
> +	    offset % sizeof(uint64_t) != 0)
> 
> please always use u64 in core code - uint64_t is acceptable 
> for drivers
> but we want to keep the core code in a coherent style.
> 
> +	if (i->f->get_fc_host_stats) {
> +		stats = (i->f->get_fc_host_stats)(shost);
> 
> superflous parenthes around the method invocation.
> 
> +		if (stats)
> +			ret = snprintf(buf, 20, "0x%llx\n",
> +			      *(uint64_t *)(((u8 *) stats) + offset));
> 
> shouldn't we instead pass an offset in terms of sizeof(u64) 
> so we can do
> simple pointer arithmetics like
> 
> 			ret = snprintf(buf, 20, "0x%llx\n", 
> stats + idx);
> 
> here?
> 
> 
