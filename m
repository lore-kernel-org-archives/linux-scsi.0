From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] allow a transport to pre-initialize starget_data
Date: Mon, 15 Aug 2005 11:41:56 -0400
Message-ID: <4300B7C4.8060400@adaptec.com>
References: <20050815134210.GA19426@lst.de>  <4300B232.9000308@adaptec.com> <1124119431.5089.9.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:38869 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S964807AbVHOPmB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 11:42:01 -0400
In-Reply-To: <1124119431.5089.9.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi guys, :-)

That's a lot of email. :-)

On 08/15/05 11:23, James Bottomley wrote:
> On Mon, 2005-08-15 at 11:18 -0400, Luben Tuikov wrote:
> 
>>While you're at it, rip out the extremely broken "channel" and "id",
>>and leave only the opaque token.
> 
> 
> Unfortunately, I just found an actual use for channel (exposing
> underlying physical discs of raid devices) and, unfortunately, we're
> still not yet at the point where we can use an opaque token for ID, but
> if someone wants to look into what it would take to convert the rest of
> SCSI ...

Hmm, you've 
    "found an actual use for channel (exposing underlying physical discs
     of raid devices)".

I'm completely befuddled James.

What if we didn't have "channel" (SPI leftover) in the first place?
Or, if an LU is implemented as a RAID device, how do you find out its
individual disks?

Is there a spec or standard that you're following in doing this?

On 08/15/05 11:25, Christoph Hellwig wrote:
> On Mon, Aug 15, 2005 at 11:18:10AM -0400, Luben Tuikov wrote:
> 
>>On 08/15/05 09:42, Christoph Hellwig wrote:
>>
>>>Add a new void *transport_data argument to scsi_scan_target so that a
>>>transport-class can fill in known information before actually scanning
>>>the target.  This is needed by the upcoming SAS transport class patch.
>>
>>Hmm, yes, this has been due for 5 years now.
>>
>>While you're at it, rip out the extremely broken "channel" and "id",
>>and leave only the opaque token.
> 
> Well, it's not a token but pre-initialized data.  The problem with
> ripping out channel and id is that userland would break all over,
> else we'd have done it already.

Ah, ok.

Is it possible to figure out which parts of userland rely on
HCIL tuples, as opposed to "scsi device I can send commands to"?

Than we can fix those userland programs and we can move into
the future.

	Luben







