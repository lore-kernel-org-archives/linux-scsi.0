From: Luben Tuikov <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] minimal SAS transport class
Date: Tue, 23 Aug 2005 20:02:39 -0400
Message-ID: <430BB91F.7000406@vger.kernel.org>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A4B@xbl3.ma.emulex.com> <430B5CDB.9070204@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:1490 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932498AbVHXACl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Aug 2005 20:02:41 -0400
In-Reply-To: <430B5CDB.9070204@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org

On 08/23/05 13:28, Stefan Richter wrote:
> James.Smart@Emulex.Com wrote:
> 
>>>As others stated, id is already a tag/label. You should be 
>>>able to pass
>>>whatever id you want to scsi_scan_target, like the FC ID 
>>>(port_id),
> 
> [...]
> 
>>If the port id changes during run time, what are you to do ?
> 
> [...]
> 
>>This approach only works as long as the transport's id fits within
>>the target id (an int). How would the SAS address(8byte wwn) utilize
>>such a scheme ?
> 
> 
> I don't understand exactly what is being discussed here. But if 
> anybody's intention is to extend the concept of target ID to also 
> provide the concept of transport specific, persistent, globally unique 
> identifiers*, then the datatype of target ID needs to be extended 
> accordingly.

Hi Stefan,

No, no, no -- this is exactly what we DO NOT WANT TO DO.

Why?  Because it is the same mistake that was done when HCIL crept
up into SCSI Core 13 years ago.

Device addressing done by LLDD is completely not the business
of SCSI Core and vice versa.  They should be *completely* separate.

In effect, a native support for targets (I know... a poor choice of
words, but not everyone reads specs), has been in need for SCSI Core
since one of the first iSCSI Target and Initiator for Linux was developed
5 years ago.

In effect FC tells SCSI Core: here is a device I do not know anything
about, other than the fact that it is on the fabric and it has
a SCSI Target (or Initiator) Port: how you get to is is _my_ business,
what is done with or to the device is _your_ business.

Then SCSI Core does LU discovery using SPC and SAM on the device
using Execute Task.

All this _completely_ eliminates the need for HCIL.

How the FC layer identifies the device is the FC's layer problem.
How SCSI Core identifies the device is SCSI Core's problem.

HCIL should have never been available to SCSI Core in the first place,
but then again SAM didn't exist back then.
 
> Otherwise the LLDs have to implement a mapping between target IDs and 

LLDD should not have to invent HCIL just because SCSI Core hasn't
seen any inovation and advancement for the last 13 years.

Currently they do.

Target ID should NOT be extended to cover whatever new transport
protocols comes up.  SCSI Core whould follow SAM if it wants to
transparently cover FC, iSCSI, SAS, etc.

> these unique identifiers. This mapping does not need to be persistent. 
> Persistent mappings for whatever purpose can and should be implemented 
> in userspace. (This is how it has always been e.g. with SBP-2.)
> 
> 
> *) examples of transport specific, persistent, globally unique 
> identifiers: obviously 8 Byte address from SAS, 8 Byte EUI from SBP-2/ 
> IEEE 1394/ ISO/IEC 13213, or maybe 88 bit GUI from ISO/IEC 13213

Yes, you're right.

And if would be nice if all those IDs are just another label tacked
onto the domain device, opaque label.  SCSI Core can add labels
on its own (e.g. HCIL ;-) ).

	Luben



