From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [RFC] pass through support in fc transport: via bsg (block SG)
Date: Fri, 22 Aug 2008 15:09:56 -0700
Message-ID: <20080822220956.GC9169@plap4-2.local>
References: <1283B1A7-A1A2-465A-A9E4-07A778BC3FE8@qlogic.com> <423FD491-FCA2-4CBF-8411-B08E90243236@qlogic.com> <7773BCE2-99A3-467D-B7AF-C182F2773A9C@qlogic.com> <48AF3547.4040703@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:57361 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbYHVWJ5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Aug 2008 18:09:57 -0400
Content-Disposition: inline
In-Reply-To: <48AF3547.4040703@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: Seokmann Ju <seokmann.ju@qlogic.com>, Robert W Love <robert.w.love@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>, Mike Christie <michaelc@cs.wisc.edu>

On Fri, 22 Aug 2008, James Smart wrote:

> Nope - not forgotten, just a lot of different things to get to.
>
> I don't know of anything in the header that needs to be specified. 
> Everything is either fixed because it is an ELS/CT request, or what needs 
> to be specified (usually S_ID/D_ID) comes from the object the bsg reference 
> is to. CS_CTL is the only one that is a maybe - but that's a whole 
> different story, and we should just ignore it for now. So I'm against a 
> header.
>
> Additionally, we have to be careful about what kind of interface we believe 
> the LLD's support. If they expected a raw frame transmit, I don't know how 
> many support that, especially as adapters very much control XID's, etc. 
> Create Exchange, w/ Send/Receive, sequence is prefered, but even that might 
> be too low.  At best, there is explicit els or ct assist interfaces - which 
> means the LLD/adapter is likely handling all the header and segmentation, 
> and the interface is just passing payload buffers.

That's essentially what prompted this inquiry.  Sure, for hardware
CNA/HBA solutions, access to something like a raw-frame header seems
unnecessary.  What about software FCoE?  Would the openfcoe want this
export/expose these raw-frame data?

> So in general it's a request, w/ xmt payload, buffer for response, and a  
> completion status (which I would assume is more than just an int and a 
> couple of #defines - we have to cover the F_RJT/P_RJT/ABORT cases..)

--
av
