From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: What "tarnsport attributes" are really for?
Date: 31 Aug 2004 07:49:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1093953002.2211.8.camel@mulgrave>
References: <1093842055.9886.57.camel@sipan.org>
	<1093874370.2036.12.camel@mulgrave>  <1093927615.32024.119.camel@sipan.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:37267 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267961AbUHaLuL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Aug 2004 07:50:11 -0400
In-Reply-To: <1093927615.32024.119.camel@sipan.org>
List-Id: linux-scsi@vger.kernel.org
To: Sergey Panov <sipan@sipan.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 2004-08-31 at 00:46, Sergey Panov wrote:
> If I am not mistaken, mid-layer is responsible only for adding extra
> storage space in every new SCSI device and for initializing it 
> by calling shost->transportt->setup(). The second tasks is trivial
> enough to be delegated to LLD.

But it would be another thing for LLD writers to forget.  Having it
where it is is the correct place for it.

> As for the extra space in every SCSI
> device, it might be a bit excessive -- an array with 256 LUNs is just
> one target device (FC or iSCSI device) and there is no need to replicate
> its properties 256 times. 

There is if the property is different.

> > The FC transport class is pretty vestigial at the moment, if you want to
> > see the capabilities of doing this, look at the SPI one.here we've been
> > moving the fairly complex DV code out of the drivers and into the
> > transport class.
> 
> I can see a set of functions common to SPI LLDs. But those functions are
> not aware of any SPI specific data (e.g. SPI transport attributes). I
> also do not see there any support for keeping track of HBA transport
> attributes.

They are in my copy ... you probably need a more up to date kernel.

> When I asked my original question, I meant to ask if that transport
> module would ever stop being a transport specific extension of the
> mid-layer(extra attributes in every scsi_device) and turn into transport
> specific extension of the LLD?

It's not a transport extension of the mid-layer, it's a library of
transport services to the LLD, so in that sense it *is* a transport
specific extension for a class of LLDs

> E.g. it looks like both iSCSI and FC LLDs are aware of the target device
> way before mid-layer queries its LUNs. It seems logical to replace
> current "extra attributes per device" scheme with some primitive data
> base of transport endpoints. It might even have common, transport
> neutral API (add_node, remove_node, for_each). Mid-layer SCSI device
> will lose its transport extension, but might get a pointer to a generic
> node/port/target. Transport module then would extend nodes to store
> transport specific attributes and may add function calls to search that
> DB by some of of the attributes.

This was a perennial debate when sysfs and the generic driver model were
first proposed.  To cope with this, SCSI actually has the ability to set
arbitrary sysfs (not transport) attributes for LLDs.

James


