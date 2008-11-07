From: jim owens <jowens@hp.com>
Subject: Re: thin provisioned LUN support
Date: Fri, 07 Nov 2008 14:44:08 -0500
Message-ID: <49149A88.4060902@hp.com>
References: <1225984628.4703.80.camel@localhost.localdomain> <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26> <20081107120534.GO21867@kernel.dk> <1226072970.15281.46.camel@think.oraclecorp.com> <yq1r65na5ll.fsf@sermon.lab.mkp.net> <1226074002.8030.33.camel@localhost.localdomain> <1226074270.15281.50.camel@think.oraclecorp.com> <1226074710.8030.43.camel@localhost.localdomain> <1226078535.15281.63.camel@think.oraclecorp.com> <4914846C.5060103@redhat.com> <20081107183636.GB29717@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:19799 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbYKGToM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Nov 2008 14:44:12 -0500
In-Reply-To: <20081107183636.GB29717@mit.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Cc: Ric Wheeler <rwheeler@redhat.com>, Chris Mason <chris.mason@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <jens.axboe@oracle.com>, David Woodhouse <dwmw2@infradead.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>

Theodore Tso wrote:
> On Fri, Nov 07, 2008 at 01:09:48PM -0500, Ric Wheeler wrote:
>> I don't think that trim bugs should be that common - we just have to be  
>> very careful never to send down a trim for any uncommitted block.
>>
> 
> The trim code probably deserves a very aggressive unit test to make
> sure it works correctly, but yeah, we should be able to control any
> trim bugs.
> 
>> Simple is always good, but I still think that the coalescing (even basic  
>> coalescing) will be a critical performance feature.
> 
> Will we be able to query the device and find out its TRIM/UNMAP
> alignment requirements?  There is also a balanace between performance
> (at least if the concern is sending too many separate TRIM commands)
> and giving the SSD more flexibility in its wear-leveling allocation
> decisions by sending TRIM commands sooner rather than later.

This is all good if the design is bounded by the requirements
of trim for flash devices.  Because AFAIK the use of trim for
flash ssd is a performance optimization.  The ssd won't loose
functionality if the trim is less than the chunk size.  It may
run slower and wear out faster, but that is all.

If I understand correctly, with thin provisioning, unmapping
less than the chunk will not release that chunk for other use.
So you have lost the thin provision feature of the array.

The concern (Chris I think) and I have is that doing a design
to handle thin provision arrays *when chunk > fs_block_size*
that guarantees you will *always* release on chunk boundaries
is a lot more complicated.

To do that you kind of have to build a filesystem into the
block layer to persistently store "mapped/unmapped blocks
in chunk" and then do the "unmap-this-chunk" when a region
is all unmapped.

250 MB per 1TiB 512b sector disk for a simple 1-bit-per-sector
state.  And that assumes you don't replicate it for safety.
That is what the array vendors are trying to avoid by pushing
it off to the OS.

Whoever supports thin provisioning better get their unmapping
correct because those big customers will be looking for who
to blame if they don't get all the features.

jim
