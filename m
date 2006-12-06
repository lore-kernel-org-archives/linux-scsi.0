From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Wed, 06 Dec 2006 16:50:15 -0600
Message-ID: <45774927.8090204@cs.wisc.edu>
References: <Pine.LNX.4.44L0.0612051546250.6667-100000@iolanthe.rowland.org>	 <1165355432.2785.20.camel@mulgrave.il.steeleye.com>	 <4575f6c6.RvoLkLFpmxoSf6pC%Joerg.Schilling@fokus.fraunhofer.de>	 <1165359506.2785.37.camel@mulgrave.il.steeleye.com>	 <4575fd53.ja06l7+Yx9/C/OYS%Joerg.Schilling@fokus.fraunhofer.de> <1165421548.2810.17.camel@mulgrave.il.steeleye.com> <4576F661.2000802@torque.net> <4577374B.9000204@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:35331 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937762AbWLFWva (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Dec 2006 17:51:30 -0500
In-Reply-To: <4577374B.9000204@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, stern@rowland.harvard.edu, schilling@fokus.fraunhofer.de, linux-scsi@vger.kernel.org, dgilbert@interlog.com

Mike Christie wrote:
> Douglas Gilbert wrote:
>> James Bottomley wrote:
>>> On Wed, 2006-12-06 at 00:14 +0100, Joerg Schilling wrote:
>>>> Well, accept the patch if it works.
>>> It's not about work/not work: it's about correctness.
>>>
>>>>  And in case that you don't like it, make sure that the _parameter_ is
>>>> moved to where it belongs: to the low level transport layer.
>>> It's not a low level property; it's a property of the generic queue,
>>> namely the maximum request size.  It exists for devices independent of
>>> SCSI (i.e. you'll want it for IDE and weirder transport attachment CDs
>>> as well).
>> Too much smoke and mirrors.
>>
>> That maximum request size comes from the transport ** and
>> in many cases is a kludge between maximum, optimal and
>> defensive. The block paradigm is wrong for a pass through
>> because it requests transports to guess a "maximum",
>> trying to head off errors that the block layer isn't
>> particularly well equipped to handle at run time.
>>
>> On the other hand a pass through gets layered error reporting.
>> So if a host (and/or its LLD driver) doesn't like the
>> size (or shape) of data to be sent/received with a
> 
> 
> For iscsi, we could negotiate a value like MaxBurstLength which says
> don't send commands with a payload larger than that size. I would guess
> other transports have something similar. We have to check or make sure
> we do not get commands larger than this somewhere. It is nice if some
> common layer could do this for us. Cards have a scatterlist limits and
> having them checked before they get to the driver for everyone is nice.
> I agree using and being limited to SG_ALL is a little strange since it
> is a odd size and having to recompile your kernel to get up to that
> limit is a pain in the butt, but that is not a problem with using the
> block layer. Those are scsi layer variables and I think those values can
> be changed.
> 
> Is the main gripe over max sectors? I agree max sectors is odd because
> we do not know what that value means in some cases for pass through and
> what that real limit is for many drivers. Because the other values that
> we check in the block layer to create the scatterlist and request, seem
> worthwhile to check as early as possible and if we checked them at the
> driver level for every driver how would the test or return value be
> different? I think this is the part I do not fully understand when this
> keeps popping up.
> 

Oh yeah the exception I am thinking about may not be max sectors exactly
but something close like iscsi's MaxBurstLength limit. Maybe iscsi LLDs
are supposed to be translating that iscsi limit to max_sectors in which
case we are talking about the same thing. For this limit we do not want
a FS or pass through request with more data than MaxBurstLength bytes.
If it is different than max_hw_sectors, we could add q->max_request_size
and check this in the block mapping and request building functions, but
the error value would be generic like maybe BLKERR_REQUEST_TOO_LARGE.
You would not be able to tell the user that specifically the request was
larger than the iscsi MaxBurstLength.

I am not sure how this fits into the argument, since there is no
guessing with it. The block layer handles this nicely for FS requests by
breaking up requests into the correct size. The limit also applies to
pass through requests and we can get a error indicating it is too large.
The draw back is of course lack of information to the user or upper
layer and it seems you guys are arguing where this type check belongs.
