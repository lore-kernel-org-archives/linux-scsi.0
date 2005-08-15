From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] allow a transport to pre-initialize starget_data
Date: Mon, 15 Aug 2005 12:10:53 -0400
Message-ID: <4300BE8D.4070002@adaptec.com>
References: <20050815134210.GA19426@lst.de>  <4300B232.9000308@adaptec.com>	 <1124119431.5089.9.camel@mulgrave>  <4300B7C4.8060400@adaptec.com> <1124121234.5089.14.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:14303 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S964812AbVHOQK6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 12:10:58 -0400
In-Reply-To: <1124121234.5089.14.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 08/15/05 11:53, James Bottomley wrote:
> On Mon, 2005-08-15 at 11:41 -0400, Luben Tuikov wrote:
> 
>>Hmm, you've 
>>    "found an actual use for channel (exposing underlying physical discs
>>     of raid devices)".
>>
>>I'm completely befuddled James.
> 
> 
> For RAID cards in the SCSI subsystem that export RAID devices as SCSI
> devices, there's a need of a standard way to get at the underlying
> devices (for DV, parameter setting or configuration).  The idea is to
> expose these devices on a non zero channel.

Isn't DV an SPI paradigm?

If the whole point of the LLDD+controller is to _give_ you this,
"an LU which is actually RAID", abstraction, why does SCSI Core
need to get to the underlying devices?

What will SCSI Core do with the RAID members?  Why is SCSI Core
concerned with this information?  What kind of parameters will
it have to set, without the RAID device server knowing about it
(which is implemented on the chip if HW RAID)?

>>What if we didn't have "channel" (SPI leftover) in the first place?
>>Or, if an LU is implemented as a RAID device, how do you find out its
>>individual disks?
> 
> It's not a SPI leftover.  It's used by HBA's that have two channels that
> genuinely share resources.  Although most modern SCSI cards simply have
> two chips (and hence two separate HBAs) per channel, there are a few, of
> which the qlogic fc card is one, that still have this one chip per two
> channels model.

Ah, I see.

Please help me understand this:

You say that "channel" is not an SPI leftover but it is used
by SCSI Core because 

	"HBA's that have two channels that genuinely share resources".

Why is SCSI Core concerned with how HBAs are _built_?  Isn't this
the LLDD's job?

Is "channel" in SCSI Core used to _address_ SCSI devices?
How many of those "channel" will we need?

>>Is there a spec or standard that you're following in doing this?
> 
> It's an OS abstraction, so no.

Ah, ok.  So I cannot find any printed media describing
the "OS abstraction" which you're implementing?  Not even in
an Operating System book then, possibly storage related?

	Luben

