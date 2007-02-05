From: Douglas Gilbert <dougg@torque.net>
Subject: Re: SG_IO weirdness
Date: Mon, 05 Feb 2007 16:19:21 -0500
Message-ID: <45C79F59.3090305@torque.net>
References: <558F4D473FD7FE419B019232BF2D37B40B22F2@G3W0634.americas.hpqcorp.net> <45C782CF.9030207@torque.net> <558F4D473FD7FE419B019232BF2D37B40B22F8@G3W0634.americas.hpqcorp.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:57864 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933458AbXBEVT2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Feb 2007 16:19:28 -0500
In-Reply-To: <558F4D473FD7FE419B019232BF2D37B40B22F8@G3W0634.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Cameron, Steve" <Steve.Cameron@hp.com>
Cc: linux-scsi@vger.kernel.org

Cameron, Steve wrote:
>> Steve,
>> Even though the SCSI status is CHECK CONDITION, the data-in
>> buffer may still be transferred. One obvious example
>> is a READ command when the sense key is RECOVERED ERROR.
> 
> Yep, of course.
> 
>> The sg driver and I suspect the block layer SG_IO do
>> not check the SCSI status to determine whether or not
>> to transfer the data-in buffer (or where it would have
>> been DMA-ed to if the command worked) back to user space.
>> If it was _direct_ IO then the block layer SG_IO and the
>> sg driver would have no control over the data-in transfer
>> (apart from setting it up).
>>
>> Both the sg driver and the block layer SG_IO could check
>> the resid field which a LLD should set after a DMA
>> (especially inbound). However LLDs are not compelled to
>> set resid properly.
>>
>> So a few questions:
>> - block layer SG_IO, the sg driver or both?
> 
> sg driver.
> 
>> - indirect IO (i.e. O_DIRECT not set)?
> 
> indirect IO, O_DIRECT was not set.
> 
>> - did the offending process have superuser permissions?
> Yes.
> 
>> - did the resid field indicate a short data-in transfer?
> 
> resid == 64, the requested buffer was 1088 bytes.
> (If I interpret that right, it means that all but 64 
> bytes were transferred, that is, 1024 bytes were 
> transferred?  Odd, considering the CDB was nonsense.)

Steve,
>From memory, between SPC-2 and SPC-3 the INQUIRY allocation
length field went from 8 bits to 16 bits. If you do the
above calculation modulo 256 it comes out correct :-)

The moral here is don't set INQUIRY lengths > 252
unless the target can handle it. There is no point
anyway for a "standard" INQUIRY (EVPD=0, CmdDt is
obsolete). With VPD pages you can do a double fetch,
the first one 4 bytes long to pick up "page length"
field.
But then again you said the cdb was nonsense.


Now it is still a bit fuzzy because there is the
allocation length field in some cdbs and the dxfer_len
given to sg_io_hdr. I would think that the LLD
should concentrate on the latter and set resid
accordingly. That makes me wonder about the LLD
involved (the sg driver just passes resid through).

>> As long as the SCSI status and sense buffer are conveyed
>> back properly _and_ this is only observed when the
>> process has superuser permissions, then I wouldn't
>> regard it as serious. Others may disagree.
> 
> I haven't tried it as non-superuser.  (And couldn't,
> unless I chmod'ed /dev/sg* )

The sg driver zeros out the scatter gather elements
for non-superusers.
chmod'ing is not always needed, for example a non-superuser
may well have permissions on a USB cd/dvd drive (including
the sg device node) in some distributions.

Doug Gilbert

