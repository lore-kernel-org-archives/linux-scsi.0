From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] [scsi] Remove __GFP_DMA
Date: Wed, 23 May 2007 23:28:50 -0600
Message-ID: <46552292.3090207@shaw.ca>
References: <fa.6bUV4KR+za7HW4tT2WBlccqvoq0@ifi.uio.no>
 <fa.NYl60pD1cwd1ESdKNCPaOwSz1WA@ifi.uio.no>
 <fa.hW9tQQfgwmXj0gAKQoWXOxVzpvk@ifi.uio.no>
 <fa.xLFpJ54sTvGq6YIol2Ew31Rrq2s@ifi.uio.no>
 <fa.JZsPKKyEKOAfxp6reMY5ZwSNjQU@ifi.uio.no>
 <fa.txrEcCPLxIukzeVBv7UG39WubcI@ifi.uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:42384 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758447AbXEXF2x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 May 2007 01:28:53 -0400
In-reply-to: <fa.txrEcCPLxIukzeVBv7UG39WubcI@ifi.uio.no>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, James Bottomley <James.Bottomley@SteelEye.com>, Aubrey Li <aubreylee@gmail.com>, Christoph Lameter <clameter@sgi.com>, Bernhard Walle <bwalle@suse.de>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Wed, 23 May 2007 15:17:08 -0400
> "Salyzyn, Mark" <mark_salyzyn@adaptec.com> wrote:
> 
>> The 31 bit limit for some of these cards is a problem, we currently only
>> do __GFP_DMA for bounce buffer sg elements allocated for user supplied
>> references in ioctls.
>>
>> I figure we should be using pci_alloc_consistent calls for these
>> allocations to more accurately acquire memory within the 31 bit limit if
>> necessary, we could switch to these to remove the need for the __GFP_DMA
>> flag in the aacraid driver?
> 
> That didn't used to work right on the AMD boards when I tried it last as
> we ended up with a buffer that was mapped by the IOMMU for some reason
> and that was not below 2GB.

The physical address you mean? If that is still happening then it needs 
to get fixed. The allocation should not succeed if it can't provide 
memory that's inside the DMA mask for the device..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

