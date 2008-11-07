From: jim owens <jowens@hp.com>
Subject: Re: thin provisioned LUN support & file system allocation policy
Date: Fri, 07 Nov 2008 11:07:49 -0500
Message-ID: <491467D5.8000502@hp.com>
References: <1225984628.4703.80.camel@localhost.localdomain> <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26> <20081107120534.GO21867@kernel.dk> <49143142.4010809@redhat.com> <20081107121934.GP21867@kernel.dk> <49145029.4040900@redhat.com> <20081107144311.GE9543@mit.edu> <4914568A.7090307@redhat.com> <49145E0C.4030705@hp.com> <20081107153624.GG9543@mit.edu> <20081107154550.GH15439@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:14808 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbYKGQHy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Nov 2008 11:07:54 -0500
In-Reply-To: <20081107154550.GH15439@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, Chris Mason <chris.mason@oracle.com>, Dave Chinner <david@fromorbit.com>, David Woodhouse <dwmw2@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Eyal Shani <Eyal.Shani@sandisk.com>

We have become confused and combined 2 independent issues...

UNMAP thin storage array provisioning is not SSD TRIM.

AFAIK the SSD trim will be handled just fine by sending the
small size (merged when appropriate) trim command.

The UNMAP is a big JBOD array problem and the solution(s)
are different.  As I said to one of Ric's early posts,
my opinion is

- expensive array vendors need to do this themselves
   because their whole thin provisioning thing is all
   about sharing on different host types with existing
   filesystems that use small blocks.

- linux filesystems that can do large allocation blocks
   would be able to be tuned at mkfs to the array geometry
   if the vendors give us the data... and we should only
   optimize those filesystems and forget about trying to
   fix it in the block layer or fix it with some kind of
   defrag/scanner.

jim

