From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: READ CAPACITY 16
Date: Thu, 18 Dec 2008 11:05:54 +0200
Message-ID: <494A1272.8040008@panasas.com>
References: <20081217164210.GC19967@parisc-linux.org> <da824cf30812170950p393be2fq729e98e93edef5dc@mail.gmail.com> <20081217180640.GE19967@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:4190 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751438AbYLRJF6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Dec 2008 04:05:58 -0500
In-Reply-To: <20081217180640.GE19967@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@google.com>, linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Wed, Dec 17, 2008 at 09:50:52AM -0800, Grant Grundler wrote:
>>> Algorithm A (a perfect world):
>>>
>>>
>>> Algorithm B:
>>>
>>> Issue RC10
>>> Issue RC16
>>>  -> If it succeeds, use its results in preference to those from RC10
>>>  -> If it fails, carry on with the results from RC10
>>>  -> If it times out, reset the device, carry on with the results from RC10
>> I fail to see an effective difference between Algo A and B.
> 
> Whether to issue an RC10 before issuing an RC16 or not.  It matches what
> we currently do better (we currently issue an RC10 and then issue an
> RC16 if RC10 reports we have 0xffffffff LBAs).
> 

Sorry to barge in but I think this is the most practical solution and the one
to go to T10 with.

If a (new) device supports RC16 it should return LBAs==0xffffffff for RC10 even
if it's capacity is smaller, to indicate an RC16 request.
If LBAs!=0xffffffff and !SCSI_3 then do not risk RC16 unless a white list
or load parameter.

Since you are going to T10 with this the white list should be, as you said
in other mail, zero length.

>> The question really is one you already asked:
>>> ...The question is what to do about devices that either
>>> hang or take a long time to respond to an RC16 command.
>> A few ideas:
>> 1) maintain a blacklist
> 
> Which is obviously what we're trying to avoid doing.
> 

If you are going to T10 with this a white list should be much shorter

>> 2) anything in RC10 or IDENTIFY that would clue us about RC16 functionality?
>>     If so, then something like B or C would make sense.
> 
> RC10 only returns number of LBAs and how many bytes per LBA.  I don't
> see anything in the INQUIRY data (other than the protection bit, which
> we already use to know that RC16 is supported).  We could maybe key off
> scsi_level > SCSI_2 like scsi_device_protection() does.  This would work
> for ATA SSDs because libata reports SCSI ANSI revision 05, but it won't
> work for USB devices because they get mangled down to SCSI_2, no matter
> what they support.
> 
<snip>

This is certainly a bug in the standard, draft as you say. It must be fixed in
a backward compatible way. Practical matters aside, the standard can not stay
as it is.

Thanks
Boaz
