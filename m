From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Tue, 01 Jun 2010 09:50:29 -0400
Message-ID: <yq1hblmkgka.fsf@sermon.lab.mkp.net>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
	<yq1iq64kv9f.fsf@sermon.lab.mkp.net>
	<1275318102.2823.47.camel@mulgrave.site>
	<4C03D5FD.3000202@panasas.com>
	<20100601103041.GA15922@schmichrtp.mainz.de.ibm.com>
	<1275398876.21962.6.camel@mulgrave.site> <20100601133341.GK8980@think>
	<1275399637.21962.11.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1275399637.21962.11.camel@mulgrave.site> (James Bottomley's
	message of "Tue, 01 Jun 2010 08:40:37 -0500")
Sender: linux-fsdevel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, Boaz Harrosh <bharrosh@panasas.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "James" == James Bottomley <James.Bottomley@suse.de> writes:

James> Would it be too much work in the fs to mark the page dirty before
James> you begin altering it (and again after you finish, just in case
James> some cleaner noticed and initiated a write)?  Or some other flag
James> that indicates page under modification?  All the process
James> controlling the writeout (which is pretty high up in the stack)
James> needs to know is if we triggered the check error by altering the
James> page while it was in flight.

James> I agree that a block based retry would close all the holes ... it
James> just doesn't look elegant to me that the fs will already be
James> repeating the I/O if it changed the page and so will block.

I experimented with this approach a while back.  However, I quickly got
into a situation where frequently updated blocks never made it to disk
because the page was constantly being updated.  And all writes failed
with a guard tag error.

-- 
Martin K. Petersen	Oracle Linux Engineering
