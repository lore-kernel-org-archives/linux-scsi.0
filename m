From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: thin provisioned LUN support & file system allocation policy
Date: Fri, 07 Nov 2008 10:12:15 -0600
Message-ID: <1226074335.8030.40.camel@localhost.localdomain>
References: <1225984628.4703.80.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26>
	 <20081107120534.GO21867@kernel.dk> <49143142.4010809@redhat.com>
	 <20081107121934.GP21867@kernel.dk> <49145029.4040900@redhat.com>
	 <20081107144311.GE9543@mit.edu> <4914568A.7090307@redhat.com>
	 <49145E0C.4030705@hp.com> <20081107153624.GG9543@mit.edu>
	 <20081107154550.GH15439@parisc-linux.org>  <491467D5.8000502@hp.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53814 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752344AbYKGQMW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Nov 2008 11:12:22 -0500
In-Reply-To: <491467D5.8000502@hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jim owens <jowens@hp.com>
Cc: linux-fsdevel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, Chris Mason <chris.mason@oracle.com>, Dave Chinner <david@fromorbit.com>, David Woodhouse <dwmw2@infradead.org>, linux-scsi@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Eyal Shani <Eyal.Shani@sandisk.com>

On Fri, 2008-11-07 at 11:07 -0500, jim owens wrote:
> We have become confused and combined 2 independent issues...
> 
> UNMAP thin storage array provisioning is not SSD TRIM.

Actually, currently they are.

The primary reason is that we handle current SATA devices through SCSI
via SAT, so we're going to have to do UNMAP for both arrays and SSDs
until such time as SATA is ejected from the SCSI mid-layer and it can do
trim on its own.

The other reason, of course, is that we're mapping the Block layer
discard statement for both as well.  If that needs to change to two
separate instructions, I don't think that's on our current radar.

So, currently we're approaching this problem as one and I don't see any
way we could logically separate the two cases (except by distinguishing
between them with device parametrisation).

James


