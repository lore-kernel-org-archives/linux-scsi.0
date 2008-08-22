From: "Chris Leech" <chris.leech@gmail.com>
Subject: Re: [RFC] pass through support in fc transport: via bsg (block SG)
Date: Fri, 22 Aug 2008 15:35:02 -0700
Message-ID: <41b516cb0808221535n1d009bdaxb6ae6136b1f68c18@mail.gmail.com>
References: <1283B1A7-A1A2-465A-A9E4-07A778BC3FE8@qlogic.com>
	 <423FD491-FCA2-4CBF-8411-B08E90243236@qlogic.com>
	 <7773BCE2-99A3-467D-B7AF-C182F2773A9C@qlogic.com>
	 <48AF3547.4040703@emulex.com> <20080822220956.GC9169@plap4-2.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:37928 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbYHVWfD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Aug 2008 18:35:03 -0400
Received: by yx-out-2324.google.com with SMTP id 8so417888yxm.1
        for <linux-scsi@vger.kernel.org>; Fri, 22 Aug 2008 15:35:02 -0700 (PDT)
In-Reply-To: <20080822220956.GC9169@plap4-2.local>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Smart <James.Smart@emulex.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Robert W Love <robert.w.love@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>, Mike Christie <michaelc@cs.wisc.edu>

On Fri, Aug 22, 2008 at 3:09 PM, Andrew Vasquez
<andrew.vasquez@qlogic.com> wrote:
> On Fri, 22 Aug 2008, James Smart wrote:
>
>> Nope - not forgotten, just a lot of different things to get to.
>>
>> I don't know of anything in the header that needs to be specified.
>> Everything is either fixed because it is an ELS/CT request, or what needs
>> to be specified (usually S_ID/D_ID) comes from the object the bsg reference
>> is to. CS_CTL is the only one that is a maybe - but that's a whole
>> different story, and we should just ignore it for now. So I'm against a
>> header.
>>
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

It's easy enough to provide software assists for lower level devices,
so I'd say focus on what will work for HBAs and we'll make software
FCoE work around that interface.  I don't see a reason to expose any
extra level of detail here, if you want to see the full frame data in
the software FCoE case you can always just capture the network
traffic.

- Chris
