From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [RFC] pass through support in fc transport: via bsg (block SG)
Date: Sat, 23 Aug 2008 10:43:38 -0400
Message-ID: <48B0221A.6000606@emulex.com>
References: <1283B1A7-A1A2-465A-A9E4-07A778BC3FE8@qlogic.com> <423FD491-FCA2-4CBF-8411-B08E90243236@qlogic.com> <7773BCE2-99A3-467D-B7AF-C182F2773A9C@qlogic.com> <48AF3547.4040703@emulex.com> <20080822220956.GC9169@plap4-2.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:59428 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbYHWOoF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Aug 2008 10:44:05 -0400
In-Reply-To: <20080822220956.GC9169@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Seokmann Ju <seokmann.ju@qlogic.com>, Robert W Love <robert.w.love@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>, Mike Christie <michaelc@cs.wisc.edu>



Andrew Vasquez wrote:
>> Additionally, we have to be careful about what kind of interface we believe
>> the LLD's support. If they expected a raw frame transmit, I don't know how
>> many support that, especially as adapters very much control XID's, etc.
>> Create Exchange, w/ Send/Receive, sequence is prefered, but even that might
>> be too low.  At best, there is explicit els or ct assist interfaces - which
>> means the LLD/adapter is likely handling all the header and segmentation,
>> and the interface is just passing payload buffers.
> 
> That's essentially what prompted this inquiry.  Sure, for hardware
> CNA/HBA solutions, access to something like a raw-frame header seems
> unnecessary.  What about software FCoE?  Would the openfcoe want this
> export/expose these raw-frame data?

Well - if it's an interface that really needs to be supported by 
everything, we should focus on the common denominator.  CT/ELS passthru, 
in so much as needed by HBAAPI (or whatever generic tools we create like 
fcping), is one of those "by everything" cases.

We can always have additional interfaces, which are similar, and less 
supported by definition, that can go lower in the stack. I would also 
justify the separate interfaces as it's ambiguous to have an interface 
that says "sometimes this information is relevant, and sometimes its 
not, depending on who receives it". The consumer of the interface can't 
depend on it.

-- james
