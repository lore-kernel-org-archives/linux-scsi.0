From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] libata: write cache and read ahead
Date: Wed, 24 Aug 2005 06:06:29 -0400
Message-ID: <430C46A5.1050702@pobox.com>
References: <43085209.50405@torque.net> <430914C2.8030301@pobox.com> <43095EB3.2020202@torque.net> <430BAFD3.9000702@adaptec.com> <20050824091641.GD26447@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:31890 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1750700AbVHXKGd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2005 06:06:33 -0400
In-Reply-To: <20050824091641.GD26447@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, dougg@torque.net, linux-scsi@vger.kernel.org, Tejun Heo <htejun@gmail.com>

Christoph Hellwig wrote:
> On Tue, Aug 23, 2005 at 07:22:59PM -0400, Luben Tuikov wrote:
> 
>>On 08/22/05 01:12, Douglas Gilbert wrote:
>>
>>>I was surprised how much code needed changing.
>>>With MODE SELECT's issues with libata addressed
>>>various other SAT "extras" should be much easier
>>>to implement. That should make libata more attractive
>>>as a SAT layer for SAS LLDDs (that don't do it already
>>>in firmware).
>>
>>Doug, how about never needing a SAT layer for SAS LLDDs
>>for ATA/ATAPI devices.
>>
>>Would you object if I "give" you a "domain device" to which
>>you can send FISes (+ the packet if ATAPI) through
>>a SAM-4 intefrace: Execute Task + TMFs?
> 
> 
> Personally I think that would be nice, but when I mentioned the basic idea
> (sending FISes through BLOCK_PC block later commands and let the scsi layer
> handle then as vendor-specific commands) Jeff didn't like that because
> then we'd need a non-sd upper driver although using the scsi midlayer.


That's something different than when Luben was talking about.

Addressing what you [Christoph] are talking about, the block layer needs 
to grow a generic method for submitting device commands, be they ATA, 
SCSI, SCSI w/ variable-length CDB, I2O, Promise SX8 message, whatever. 
Stuff that into the request_queue, and the transport driver handles it 
from there.

	Jeff


