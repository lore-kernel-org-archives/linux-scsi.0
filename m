From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: [PATCH] dc395x: Fix support for highmem
Date: Wed, 16 Mar 2005 10:44:50 -0800
Message-ID: <42387EA2.5020106@us.ibm.com>
References: <200503160209.j2G29cAf010870@hera.kernel.org> <20050316075839.GC7842@suse.de> <1110986016.5771.3.camel@mulgrave> <20050316160447.GU7842@suse.de> <20050316164806.GO21986@parcelfarce.linux.theplanet.co.uk> <20050316165338.GX7842@suse.de> <20050316170259.GA25056@infradead.org> <20050316170417.GY7842@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from e31.co.us.ibm.com ([32.97.110.129]:31685 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S262747AbVCPSo4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Mar 2005 13:44:56 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e31.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j2GIipua397588
	for <linux-scsi@vger.kernel.org>; Wed, 16 Mar 2005 13:44:52 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j2GIipc3236784
	for <linux-scsi@vger.kernel.org>; Wed, 16 Mar 2005 11:44:51 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j2GIiotw007791
	for <linux-scsi@vger.kernel.org>; Wed, 16 Mar 2005 11:44:51 -0700
In-Reply-To: <20050316170417.GY7842@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, g.liakhovetski@gmx.de

Jens Axboe wrote:
> On Wed, Mar 16 2005, Christoph Hellwig wrote:
> 
>>On Wed, Mar 16, 2005 at 05:53:39PM +0100, Jens Axboe wrote:
>>
>>>The list doesn't really need dma mapping at that point, the problem here
>>>is that the driver needs to punt to pio mode because of foo. So calling
>>>pci/dma_map_* is pointless, since the CPU will have to do the transfer
>>>anyways. What the driver is really looking for at this point, is a way
>>>to map the pages in the sglist to a virtual address.
>>
>>Given that there's quite a few cases of this "problem" it would be nice
>>to have common helpers for it.  Especially as it's really difficult when
>>we allow merging of sg list entries
> 
> 
> I thought about that when writing the above, but is there really more
> than one case for SCSI drivers? If there is, sure lets add the helpers.
> But I would consider it a quite rare occurence, I've never seen it
> before.
> 

I got lost here. If you are talking about the need to kmap a sglist then 
software iscsi has it. iscsi-sfnet used to do

while (...)
	kmap()

but I fixed that (I think I need to use kmap_atomic though, is that 
correct or is it just a performance improvement - I am calling kmap from 
a thread too so). I just added kmap_atomic to open-iscsi and I believe 
pyx does something similar to the loop above.

