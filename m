From: jim owens <jowens@hp.com>
Subject: Re: thin provisioned LUN support & file system allocation policy
Date: Fri, 07 Nov 2008 11:23:08 -0500
Message-ID: <49146B6C.3070307@hp.com>
References: <1225984628.4703.80.camel@localhost.localdomain>	 <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26>	 <20081107120534.GO21867@kernel.dk> <49143142.4010809@redhat.com>	 <20081107121934.GP21867@kernel.dk> <49145029.4040900@redhat.com>	 <20081107144311.GE9543@mit.edu> <4914568A.7090307@redhat.com>	 <49145E0C.4030705@hp.com> <20081107153624.GG9543@mit.edu>	 <20081107154550.GH15439@parisc-linux.org>  <491467D5.8000502@hp.com> <1226074335.8030.40.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:20568 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbYKGQXO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Nov 2008 11:23:14 -0500
In-Reply-To: <1226074335.8030.40.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-fsdevel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, Chris Mason <chris.mason@oracle.com>, Dave Chinner <david@fromorbit.com>, David Woodhouse <dwmw2@infradead.org>, linux-scsi@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Eyal Shani <Eyal.Shani@sandisk.com>

James Bottomley wrote:
> On Fri, 2008-11-07 at 11:07 -0500, jim owens wrote:
>> We have become confused and combined 2 independent issues...
>>
>> UNMAP thin storage array provisioning is not SSD TRIM.
> 
> Actually, currently they are.

Sorry, I'm not being clear.  It may be the same code but
the "what is the design goal" is different.

The goal for SSD is to handle devices that are reasonably
small in size and have (we hope) reasonably small trim
chunk sizes.

The key here the size of the SSD device would keep any
merge bitmap you did in the block layer reasonable.

A 512-byte-per-block merge map for a 1,000 TB san array
is much uglier.

I'm saying that ugliness belongs to the array vendor.

Keep a common linux block layer discard/trim/unmap
that is good for reasonable devices - screw the rest!

jim


