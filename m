From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Wed, 06 Dec 2006 15:34:03 -0600
Message-ID: <4577374B.9000204@cs.wisc.edu>
References: <Pine.LNX.4.44L0.0612051546250.6667-100000@iolanthe.rowland.org>	 <1165355432.2785.20.camel@mulgrave.il.steeleye.com>	 <4575f6c6.RvoLkLFpmxoSf6pC%Joerg.Schilling@fokus.fraunhofer.de>	 <1165359506.2785.37.camel@mulgrave.il.steeleye.com>	 <4575fd53.ja06l7+Yx9/C/OYS%Joerg.Schilling@fokus.fraunhofer.de> <1165421548.2810.17.camel@mulgrave.il.steeleye.com> <4576F661.2000802@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:35167 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937655AbWLFVfM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Dec 2006 16:35:12 -0500
In-Reply-To: <4576F661.2000802@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, stern@rowland.harvard.edu, schilling@fokus.fraunhofer.de, linux-scsi@vger.kernel.org, dgilbert@interlog.com

Douglas Gilbert wrote:
> James Bottomley wrote:
>> On Wed, 2006-12-06 at 00:14 +0100, Joerg Schilling wrote:
>>> Well, accept the patch if it works.
>> It's not about work/not work: it's about correctness.
>>
>>>  And in case that you don't like it, make sure that the _parameter_ is
>>> moved to where it belongs: to the low level transport layer.
>> It's not a low level property; it's a property of the generic queue,
>> namely the maximum request size.  It exists for devices independent of
>> SCSI (i.e. you'll want it for IDE and weirder transport attachment CDs
>> as well).
> 
> Too much smoke and mirrors.
> 
> That maximum request size comes from the transport ** and
> in many cases is a kludge between maximum, optimal and
> defensive. The block paradigm is wrong for a pass through
> because it requests transports to guess a "maximum",
> trying to head off errors that the block layer isn't
> particularly well equipped to handle at run time.
> 
> On the other hand a pass through gets layered error reporting.
> So if a host (and/or its LLD driver) doesn't like the
> size (or shape) of data to be sent/received with a


For iscsi, we could negotiate a value like MaxBurstLength which says
don't send commands with a payload larger than that size. I would guess
other transports have something similar. We have to check or make sure
we do not get commands larger than this somewhere. It is nice if some
common layer could do this for us. Cards have a scatterlist limits and
having them checked before they get to the driver for everyone is nice.
I agree using and being limited to SG_ALL is a little strange since it
is a odd size and having to recompile your kernel to get up to that
limit is a pain in the butt, but that is not a problem with using the
block layer. Those are scsi layer variables and I think those values can
be changed.

Is the main gripe over max sectors? I agree max sectors is odd because
we do not know what that value means in some cases for pass through and
what that real limit is for many drivers. Because the other values that
we check in the block layer to create the scatterlist and request, seem
worthwhile to check as early as possible and if we checked them at the
driver level for every driver how would the test or return value be
different? I think this is the part I do not fully understand when this
keeps popping up.

Currently the LLD cannot tell you that it cannot handle a command
because it was just too darn large any more than the block layer can.
One would return -EINVAL or -ENOMEM and the other would return lots of
different values because it depends on the driver and none of them tell
you that a specific limit was reached.

All we really want is the underlying mapping and scatterlist building
code but without some checks like max sectors and we want some new error
values. I will leave the debate over whether those should be checked to
you guys :) I only want to help on getting more info to the user and I
do not think we should have duplicated code doing the same thing except
one checks max_hw_sectors and the other does not. Oh yeah, but on that
note, in the original patches I did not check for values like max
sectors. I later changed this to checking for max hw sectors. You could
modify the REQ_TYPE_BLOCK_PC checks that I added to not test anything
instead of values like max_hw_sectors again (I am just saying it is
possible in the code not).

For the problem of sending error values that are not useful and leaving
the user in the dark we can still use the block layer helpers and not
have to add so many checks to the LLDs by modifying them to return
BLKERR values that are more descriptive like here:

http://kernel.org/git/?p=linux/kernel/git/mnc/linux-2.6-iscsi.git;a=blob;h=c8c20df124e58d04f90e74dea8d7880016f8a5df;hb=multipath;f=include/linux/blkdev.h

In that code that I am doing to move the dm hw_handlers to scsi we need
to return something more informative than -Exyz, so I added BLKERR
values and one day I will convert all the block driver again and
convince Jens we need it :) For something like using blk_rq_map_user to
map/copy the data, instead of returning -EINVAL when we hit a limit I
want to return BLKERR_TOO_MANY_SEGMENTS, BLKERR_TOO_MANY_SECTORS,
BLKERR_SEGMENT_TOO_LARGE, etc just like if the LLD was to return a new
DID_* error value to tell them the same thing.

Alternatively, if we do start not checking values like max sectors and
send requests down to the drivers, the block layer mapping functions can
be modified to not check certain values and LLDs/scsi-ml can return
these BLKERR values all the way up to sg/bsg/scsi_ioctl.c for values
that they need to check.
