From: Sergey Panov <sipan@sipan.org>
Subject: Re: What "transport attributes" are really for?
Date: Tue, 31 Aug 2004 20:50:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1093999828.21396.49.camel@sipan.org>
References: <1093842055.9886.57.camel@sipan.org>
	 <1093874370.2036.12.camel@mulgrave>  <1093927615.32024.119.camel@sipan.org>
	 <1093953002.2211.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc13.comcast.net ([204.127.198.39]:33233 "EHLO
	rwcrmhc13.comcast.net") by vger.kernel.org with ESMTP
	id S268795AbUIAAub (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Aug 2004 20:50:31 -0400
In-Reply-To: <1093953002.2211.8.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 2004-08-31 at 07:49, James Bottomley wrote:
> On Tue, 2004-08-31 at 00:46, Sergey Panov wrote:
> > As for the extra space in every SCSI
> > device, it might be a bit excessive -- an array with 256 LUNs is just
> > one target device (FC or iSCSI device) and there is no need to replicate
> > its properties 256 times. 
> 
> There is if the property is different.

It can not be different, because a target device is a transport (SPI,
FC, iSCSI) end point. LUNs are units inside that target device and can
not possibly have different transport attributes.
 
> > I can see a set of functions common to SPI LLDs. But those functions are
> > not aware of any SPI specific data (e.g. SPI transport attributes). I
> > also do not see there any support for keeping track of HBA transport
> > attributes.
> 
> They are in my copy ... you probably need a more up to date kernel.

Sorry, but I was looking at the most recent snapshot from BK and the
only transport attributes I could find there are per scsi_device (per
LUN) attributes. May be it is different in your private tree.

> It's not a transport extension of the mid-layer, it's a library of
> transport services to the LLD, so in that sense it *is* a transport
> specific extension for a class of LLDs

Then why transport specific data is stored in every scsi_device (mid
layer object) and not associated with Scsi_Host(still mid-layer object,
but closely associated with LLD)? 

> > E.g. it looks like both iSCSI and FC LLDs are aware of the target device
> > way before mid-layer queries its LUNs. It seems logical to replace
> > current "extra attributes per device" scheme with some primitive data
> > base of transport endpoints. It might even have common, transport
> > neutral API (add_node, remove_node, for_each). Mid-layer SCSI device
> > will lose its transport extension, but might get a pointer to a generic
> > node/port/target. Transport module then would extend nodes to store
> > transport specific attributes and may add function calls to search that
> > DB by some of of the attributes.
> 
> This was a perennial debate when sysfs and the generic driver model were
> first proposed.  To cope with this, SCSI actually has the ability to set
> arbitrary sysfs (not transport) attributes for LLDs.

Is that debate is archived somewhere? May I get a link?

 I was looking for relevant discussion in linux-scsi and did not find
anything prior to the first code submission. It could have been an
interesting discussion - while target device is not the final
destination for I/O, it an important player in the transport layer. 

It is target ID, which LLD (at least in case of FC and iSCSI) binds to
transport endpoint (port, node, ...). And, as a result of that binding,
it is a target device, which is can be discovered, lost, and
rediscovered again. I do not know how you can avoid target centric code
in the transport layer. 

-- 
Sergey Panov <sipan@sipan.org>
Home

