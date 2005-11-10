From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/10] remove scsi_request usage from sg and st
Date: Thu, 10 Nov 2005 06:51:21 -0600
Message-ID: <43734249.3030800@cs.wisc.edu>
References: <1131444389.23111.56.camel@max> <20051110105513.GA9118@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:63150 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1750816AbVKJMvX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Nov 2005 07:51:23 -0500
In-Reply-To: <20051110105513.GA9118@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: axboe@suse.de, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Tue, Nov 08, 2005 at 04:06:29AM -0600, Mike Christie wrote:
> 
>>The following patches, made against scsi-misc, remove the scsi_request
>>usage from st and sg, do some tiny cleanup on sg, and make sg and st
>>always perform scatterlist IO.
>>
>>I have tested against libata and scsi_debug for disks. There are slight
>>changes, so someone with a tape device should test the patches, but Kai
>>since Kai did all the debugging last round I have not made many changes.
>>We will probably hit many problems with LLDs using low max_hw_sectors,
>>because they have not been converted to export their real values on the
>>host template so I think these patches should sit in scsi-misc for a
>>good deal of time.
> 
> 
> looks like linus is closing the big merge window for 2.6.15, so we won't
> be able to get this in fully.  What do you thing about getting in the
> infrastructure at least, that is patches: 1,3,6,7 for 2.6.15 and the rest
> afterwards, after the max_sectors thing has settled a little?
> 

If you merge #3 you need the late #11 
http://marc.theaimsgroup.com/?l=linux-scsi&m=113149038422831&w=2

It is up to Jens though since I am really digging deep into the block 
layer code in #3 and #6 may need to be fixed for SG_IO sr commands. I 
can rediff them if you they do not merge correctly. I noticed the block 
layer move code is now merge in scsi-misc.

Oh yeah was my last max_sectors close
http://marc.theaimsgroup.com/?l=linux-scsi&m=113147482216587&w=2
or did it need work, or do I just need to get LLD writers to set their 
sht->max_sectors correctly?
