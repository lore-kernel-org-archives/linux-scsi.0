From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] SCSI Core patches
Date: Wed, 15 Jan 2003 10:52:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200301151552.h0FFqp402401@localhost.localdomain>
References: <MPESCHKE@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id HAA13093
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jan 2003 07:52:56 -0800
In-Reply-To: Message from "Martin Peschke3" <MPESCHKE@de.ibm.com>
   of "Wed, 15 Jan 2003 16:35:35 +0100." <OFD72246CF.E2385102-ONC1256CAF.0050D1E1@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke3 <MPESCHKE@de.ibm.com>
Cc: patmans@us.ibm.com, Luben Tuikov <luben@splentec.com>, linux-scsi@vger.kernel.org

MPESCHKE@de.ibm.com said:
> If anybody on the list has objections against 64 bit LUNs, it is now
> time to speak out. 

I don't have any objections, but I do have a suggestion:

It would be nice to be able to use opaque quantites for target and LUN so that 
the FC devices don't have to do this mapping dance between targed and internal 
name.  i.e. if a FC driver wants to use the WWN or port for the target there 
should be nothing preventing it.

All that really matters is that the target and LUN can be rendered to and from 
a string (for printing out and for accepting from add/remove-single-device).  
While we're in the middle of pulling these fields out of Scsi_Cmnd is a good 
point to start on this.

Most of the mid-layer uses Scsi_Device and doesn't care what the values are, 
the only piece that will need careful thought is the legacy scanning code.

James


