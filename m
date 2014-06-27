From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 4/4] scsi_scan: Fixup scsilun_to_int()
Date: Fri, 27 Jun 2014 14:49:13 +0200
Message-ID: <53AD6849.5080601@acm.org>
References: <1403702859-74437-1-git-send-email-hare@suse.de> <1403702859-74437-5-git-send-email-hare@suse.de> <53AD1960.70703@acm.org> <53AD1DA5.1040605@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from michel.telenet-ops.be ([195.130.137.88]:38820 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbaF0MtP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jun 2014 08:49:15 -0400
In-Reply-To: <53AD1DA5.1040605@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On 06/27/14 09:30, Hannes Reinecke wrote:
> On 06/27/2014 09:12 AM, Bart Van Assche wrote:
>> On 06/25/14 15:27, Hannes Reinecke wrote:
>>> scsilun_to_int() has an error which prevents it from generating
>>> correct LUN numbers for 64bit values.
>>> Also we should remove the misleading comment about portions of
>>> the LUN being ignored; the initiator should treat the LUN as
>>> an opaque value.
>>> And, finally, the example given should use the correct
>>> prefix (here: extended flat space addressing scheme).
>>
>> I'm still not enthusiast about the byte reordering by scsilun_to_int()
>> for extended logical unit addressing. But I can confirm that this patch
>> passed the test that failed with the previous version of the 64-bit LUN
>> patch series. So if you want you can add "Tested-by: Bart van Assche
>> <bvanassche@acm.org>".
>>
> I can somewhat agree with your sentiment.
> 
> It should be possible eg to keep the LUN in native format (as now both
> have the same length) and only use scsilun_to_int() when
> displaying the LUN number.
> 
> But this needs a careful review, as occasionally the code might want to
> traverse the LUN numbers by simply incrementing it, which of course
> won't work anymore then.
> Which was the main reason why I didn't do so in the first place.
> 
> Now, however, the necessary bits are done, so we should have a look at
> that. Let's see ...

The first two bits of a SCSI LUN indicate the addressing method. Has it
been considered to make the LUN encoding and decoding scheme dependent
on the addressing method, e.g. keeping the current approach for
multi-level simple LUNs (16 bits each) and preserving the (big endian)
byte order for the extended logical unit addressing format ? For the
extended logical unit addressing format the first two bits (ADDRESS
METHOD) are both equal to one and the subsequent two bits indicate the
LUN length. As you most likely know more details can be found in SAM-5
paragraph 4.7.7.5.

Bart.
