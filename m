Return-Path: <SRS0=NWCA=WH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 387B6C433FF
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Aug 2019 19:22:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09B5B20820
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Aug 2019 19:22:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbfHKTWA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Aug 2019 15:22:00 -0400
Received: from smtp.infotech.no ([82.134.31.41]:34773 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725847AbfHKTWA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 11 Aug 2019 15:22:00 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 0350A20423F;
        Sun, 11 Aug 2019 21:21:57 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id FTO1TA8PN3yW; Sun, 11 Aug 2019 21:21:50 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 76AC720415B;
        Sun, 11 Aug 2019 21:21:49 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v3 13/20] sg: add sg v4 interface support
Reply-To: dgilbert@interlog.com
To:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, bvanassche@acm.org
References: <20190807114252.2565-1-dgilbert@interlog.com>
 <20190807114252.2565-14-dgilbert@interlog.com>
 <1565392352.17449.15.camel@linux.vnet.ibm.com>
Message-ID: <9741913d-c0fc-ce74-3234-ebc89dd30cb5@interlog.com>
Date:   Sun, 11 Aug 2019 15:21:46 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1565392352.17449.15.camel@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-08-10 1:12 a.m., James Bottomley wrote:
> On Wed, 2019-08-07 at 13:42 +0200, Douglas Gilbert wrote:
>> Add support for the sg v4 interface based on struct sg_io_v4 found
>> in include/uapi/linux/bsg.h and only previously supported by the
>> bsg driver. Add ioctl(SG_IOSUBMIT) and ioctl(SG_IORECEIVE) for
>> async (non-blocking) usage of the sg v4 interface. Do not accept
>> the v3 interface with these ioctls. Do not accept the v4
>> interface with this driver's existing write() and read()
>> system calls.
>>
>> For sync (blocking) usage expand the existing ioctl(SG_IO)
>> to additionally accept the sg v4 interface object.
> 
> First the meta comments:
> 
> Since this is effectively a new interface for sg, we're not constrained
> by what happened before.  Specifically, we don't want to support the
> read/write interface for v4, that should remain only for legacy v3.

Yes, and I don't want to support the bsg sync v4 interface which I
consider to be a subset of the existing sg v3 interface (and
its implementation). See further details below.

> We're already discussing what the correct async interface should look
> like, I won't comment on the IOSUBMIT/IORECEIVE parts.

If the kernel had an API mapping layer that was sensitive file
descriptors of a "special file" (e.g. "/dev/bsg/0:0:0:1") then it
could map:
     write(bsg_fd, &sg_io_v4_obj, sizeof(sg_io_v4_obj))
to
     ioctl(corresponding_sg_fd, SG_IOSUBMIT, &sg_io_v4_obj)

Plus a similar mapping for read() to ioctl(SG_IORECEIVE).
Obviously a pipe dream, but useful IMO for what I am trying to
achieve.

> Given that we want to unify the v4 code paths, I think this:
>   
>> @@ -1293,15 +1528,25 @@ sg_ctl_sg_io(struct file *filp, struct
>> sg_device *sdp, struct sg_fd *sfp,
>>   		return res;
>>   	if (copy_from_user(h3p, p, SZ_SG_IO_HDR))
>>   		return -EFAULT;
>> -	if (h3p->interface_id == 'S')
>> -		res = sg_submit(filp, sfp, h3p, true, &srp);
>> -	else
>> +	if (h3p->interface_id == 'Q') {
>> +		/* copy in rest of sg_io_v4 object */
>> +		if (copy_from_user(hu8arr + SZ_SG_IO_HDR,
>> +				   ((u8 __user *)p) + SZ_SG_IO_HDR,
>> +				   SZ_SG_IO_V4 - SZ_SG_IO_HDR))
>> +			return -EFAULT;
>> +		res = sg_v4_submit(filp, sfp, p, h4p, true, &srp);
> 
> Can simply become
> 
> if (h3p->interface_id == 'Q')
> 	return bsg_sg_io(sdp->request_queue, filp->file_mode, p);
> 
> And all the duplicate code could then be eliminated.  Of course, we
> have to export bsg_sg_io, but that should be a trivial addition.

Interesting idea. As always, the devil is in the detail, and in this
case, in the interface.

First, when I defined the sg v4 interface it was a superset of
the existing sg v3 interface (and implementation). This meant that
the sg v4 interface supported the flags and info fields of the
existing sg v3 driver interface according to my design document. There
are also SG_* ioctls that effectively hold metadata at file descriptor,
device and, in some cases, driver scope. The bsg implementation of the
sg v4 interface either ignores or dummies out all of the above.
Amongst other things this led to the fatal flaw in the bsg async
implementation in which two SCSI commands issued through the bsg
driver in different processes on the same device (i.e. independent
operations from the users' point of view) could receive one another's
responses. Reason: no effective file scope.
Incredible, but that has been solved by removing the async interface
from the bsg driver!

The bsg v4 interface implementation did introduce two flags:
BSG_FLAG_Q_AT_TAIL and BSG_FLAG_Q_AT_HEAD and they were duly
backported into the sg driver over 5 years ago. No backporting
of pre-existing sg characteristics was ever done on the bsg driver
that I am aware of, certainly not recently, say the last 10 years.
And when you also remove bidi support from the whole kernel, and
thus from the bsg driver, why have a SCSI command interface in
the bsg driver at all??

After all, one can already issue sync SCSI commands with
ioctl(SG_IO, &sg_v3_obj) on all SCSI devices via /dev/sd<letter*>,
/dev/sr, etc. This would turn your suggestion on its head. Don't
call bsg_sg_io(), instead get rid of the bsg _sync_ SCSI interface!

If your suggestion was implemented the sg v4 interface in the sg
driver would become a significant regression on what the sg driver
offers at the moment. IMO that would be perverse. In my
documentation at http://sg.danny.cz/sg/sg_v40.html the flags
and info fields are now listed in sections 2.2 and 2.3 . I would
need to add on almost all entries: "not implemented in the
v4 sync interface but available in the v4 async interface". A
diligent reader might wonder what the author was smoking?

And the reserve buffer: originally added in the late nineties
when the sg driver could fail to get RAM during a CD write.
Complete crap, so the bsg driver implementation threw it
out (and dummied out the ioctl()s that supported it). Now
look at sections 6 and 8 (request sharing) in the above document
and specifically the diagram in section 8. The data carrier
between the READ and the WRITE is the master side's reserve
buffer. So new life for the reserve buffer concept. Notice
also in that diagram both the READ and WRITE invocations
use ioctl(SG_IO) (i.e. they are sync) and thus would not work
with your suggestion in the case of the v4 interface (but would
work with the v3 interface).

And while on the the subject of request sharing I challenge Bart
to show us how his better API (hinted at but not presented) would
be faster than request sharing for a disk to disk copy.

ioctl(SG_IO) can also be used for a multiple requests invocation
in my proposed second patchset. See "ordered blocking" in the
second table of section 10 on Multiple requests. That would need
some "smoke and mirrors" to work as defined in the presence
of your suggestion.
Also notice that "variable blocking" in that table would give the
user a very simple and fast READ GATHERED capability. [READ GATHERED
is the non-existent t10.org SCSI command that would pair with one
they have defined: WRITE SCATTERED command.] This could have been
done with the multiple submission capability of write() in the bsg
driver, that is before it was removed. That "variable blocking" is
slightly better because it is "sync" seen from the user's
perspective.

Finally I don't regard the sg v3 interface as legacy. Without my
two proposed patchsets *** the bsg driver is well on the way to
making the v4 interface legacy, at least in terms of the number
of users. The removal of bidi also partially undermines the
argument of why the v4 interface was better than the v3 interface.
I want to, and am prepared to do the associated work, to support
both the v3 and v4 interfaces in the sg driver. That said, some
completely new proposals, such as multiple request invocations,
are only supported with the v4 interface. All proposed (new)
ioctls comply with the spirit and the letter of what the _IOR(W)
macros are trying to achieve: (somewhat) structured ioctls.

Doug Gilbert

*** This tarball (http://sg.danny.cz/sg/p/sgv4_20190808.tgz) contains
     a 36 part patchset where patches 1 through 20 are the same as sent
     to this list on 20190807, the first of which was titled:
         [PATCH v3 00/20] sg: add v4 interface
     The remaining 16 patches implement the extra features and bring the
     driver implementation into line with the description in:
         http://sg.danny.cz/sg/sg_v40.html
     So that 36 part patchset rolls the two patchsets I have been
     referring to, into one.

