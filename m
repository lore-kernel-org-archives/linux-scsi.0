From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [RFC] pass through support in fc transport: via bsg (block SG)
Date: Fri, 22 Aug 2008 17:53:11 -0400
Message-ID: <48AF3547.4040703@emulex.com>
References: <1283B1A7-A1A2-465A-A9E4-07A778BC3FE8@qlogic.com> <423FD491-FCA2-4CBF-8411-B08E90243236@qlogic.com> <7773BCE2-99A3-467D-B7AF-C182F2773A9C@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:39122 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757028AbYHVVxf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Aug 2008 17:53:35 -0400
In-Reply-To: <7773BCE2-99A3-467D-B7AF-C182F2773A9C@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: Robert W Love <robert.w.love@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Boaz Harrosh <bharrosh@panasas.com>, Mike Christie <michaelc@cs.wisc.edu>

Nope - not forgotten, just a lot of different things to get to.

I don't know of anything in the header that needs to be specified. 
Everything is either fixed because it is an ELS/CT request, or what 
needs to be specified (usually S_ID/D_ID) comes from the object the bsg 
reference is to. CS_CTL is the only one that is a maybe - but that's a 
whole different story, and we should just ignore it for now. So I'm 
against a header.

Additionally, we have to be careful about what kind of interface we 
believe the LLD's support. If they expected a raw frame transmit, I 
don't know how many support that, especially as adapters very much 
control XID's, etc. Create Exchange, w/ Send/Receive, sequence is 
prefered, but even that might be too low.  At best, there is explicit 
els or ct assist interfaces - which means the LLD/adapter is likely 
handling all the header and segmentation, and the interface is just 
passing payload buffers.

So in general it's a request, w/ xmt payload, buffer for response, and a 
  completion status (which I would assume is more than just an int and a 
couple of #defines - we have to cover the F_RJT/P_RJT/ABORT cases..)

-- james s

Seokmann Ju wrote:
> I just want to re-stroke this thread to make sure it is not skipped.
> 
> One question came to me while testing qla2xxx module with the changes.
> When the application issues ELS/CT packet, should the packet include
> the FC frame header?
> And if the answer is 'yes', should the driver also include the FC
> frame header when it returns response to the application (just like
> any other frame exchanges in between two ports on the FC)?
> The FC frame header has type field that identifies what type of the
> payload (ELS / CT / etc.) the frame contains and the type field is
> being checked by the FC transport layer before it calls LLDD's handler.
> 
> Thank you,
> Seokmann
