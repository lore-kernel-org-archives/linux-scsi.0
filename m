From: Sergey Panov <sipan@sipan.org>
Subject: Re: What "tarnsport attributes" are really for?
Date: Tue, 31 Aug 2004 00:46:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1093927615.32024.119.camel@sipan.org>
References: <1093842055.9886.57.camel@sipan.org>
	 <1093874370.2036.12.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc11.comcast.net ([204.127.198.35]:10390 "EHLO
	rwcrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S266513AbUHaEq6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Aug 2004 00:46:58 -0400
In-Reply-To: <1093874370.2036.12.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 2004-08-30 at 09:59, James Bottomley wrote:
>  ... The goal is to create
> a library that encapsulates the service delivery subsystem (transport)
> part of SAM. ...

Then current scheme does not look sufficient. Does it mean we should
expect drastic changes in the near future? 

>   The ideal is not to have a transport API between the
> mid-layer and the transport classes but instead have the transport class
> provide autonomous services to the drivers, but I still don't know if
> this is possible.

If I am not mistaken, mid-layer is responsible only for adding extra
storage space in every new SCSI device and for initializing it 
by calling shost->transportt->setup(). The second tasks is trivial
enough to be delegated to LLD. As for the extra space in every SCSI
device, it might be a bit excessive -- an array with 256 LUNs is just
one target device (FC or iSCSI device) and there is no need to replicate
its properties 256 times. 
 

> The FC transport class is pretty vestigial at the moment, if you want to
> see the capabilities of doing this, look at the SPI one.here we've been
> moving the fairly complex DV code out of the drivers and into the
> transport class.

I can see a set of functions common to SPI LLDs. But those functions are
not aware of any SPI specific data (e.g. SPI transport attributes). I
also do not see there any support for keeping track of HBA transport
attributes.

When I asked my original question, I meant to ask if that transport
module would ever stop being a transport specific extension of the
mid-layer(extra attributes in every scsi_device) and turn into transport
specific extension of the LLD?

E.g. it looks like both iSCSI and FC LLDs are aware of the target device
way before mid-layer queries its LUNs. It seems logical to replace
current "extra attributes per device" scheme with some primitive data
base of transport endpoints. It might even have common, transport
neutral API (add_node, remove_node, for_each). Mid-layer SCSI device
will lose its transport extension, but might get a pointer to a generic
node/port/target. Transport module then would extend nodes to store
transport specific attributes and may add function calls to search that
DB by some of of the attributes.

I wonder, if change like one described above is too disruptive to make
its way into the kernel any time soon? 

-- 
Sergey Panov <sipan@sipan.org>
Home

