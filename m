From: Douglas Gilbert <dougg@torque.net>
Subject: Re: sense visible despite ide-floppy in 2.6 maybe
Date: Mon, 14 Jun 2004 16:39:23 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40CD481B.2070305@torque.net>
References: <1086710016.3647.4.camel@patibmrh9><40C8FB79.1050706@torque.net> <1087153573.3172.24.camel@patibmrh9>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:58641 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S261987AbUFNGjk
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jun 2004 02:39:40 -0400
In-Reply-To: <1087153573.3172.24.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

Pat LaVarre wrote:
> Doug G:
<snip/>
> 
>>>			int vn = 0;
>>>			if (0 <= ioctl(fd, SG_GET_VERSION_NUM, &vn)) {
>>>				if (vn < 30000) {
>>>					perror("ioctl SG_GET_VERSION_NUM");
>>>					continue;
>>>				}
>>
>>Note: I have started to drop this SG_GET_VERSION_NUM ioctl()
>>check. It is still needed in the special case where the sg
>>driver is working asynchronously (i.e. sending commands with
>>write() and receiving the response with read() ).
> 
> 
> Help?
> 
> I thought the purpose of ioctl SG_GET_VERSION_NUM was to avoid sending
> ioctl SG_IO on a Linux so old that ioctl SG_IO meant something
> different.
> 
> Is that wrong?  Can I expect Linux to behave reasonably whenever I
> assault it with a root-privileged ioctl SG_IO, no matter what the ioctl
> SG_GET_VERSION_NUM results are?

To the best of my knowledge the SG_IO ioctl (request id
0x2285) does not clash with any other ioctl in linux.
With version 2 of the sg driver and earlier ( <= lk 2.2)
the SG_IO ioctl didn't exist. The problem arises when the
asynchronous sg driver interface (i.e. write() a SCSI command
the read() the response when it arrives) is very dangerous
to do on anything other than an sg device! I crunched the
partition table on one of my disks when the SG_IO ioctl was
first introduced to the block layer. This is because I
used a utility in the sg3_utils package that used the
async interface (i.e. write()/read() ) on a block device :-)

>>>	sih->dxferp = static_data;
>>>	sih->dxfer_len = 0x24;
>>>	sih->dxfer_direction = SG_DXFER_NONE;
>>>	sih->dxfer_direction = SG_DXFER_TO_DEV;
>>>	sih->dxfer_direction = SG_DXFER_FROM_DEV;
>>
>>The three above lines look a bit strange :-)
> 
> 
> Help?  Why strange?
> 
> These three lines exist because I can easily reorder them to change
> quickly among the three main options of expecting data in, data out, or
> no data.  Commenting out the two lines that have no effect would
> actually make that edit more difficult.
> 
> Maybe your ":-)" means you understood that?

Well I think the janitors go over the top sometimes
(especially if they hound driver maintainers out of
their support roles) but ...
there is the smaller matter of efficiency and code size.
How about:

// dxfer_direction is one of SG_DXFER_NONE,
//  SG_DXFER_TO_DEV, or  SG_DXFER_FROM_DEV
     sih->dxfer_direction = SG_DXFER_FROM_DEV;

>>Perhaps you could sent me the "strace" of this failure so
>>I can have a closer look at what is going on.
> 
> 
> I will try to remember to strace next time I report a failing ioctl.
> 
> I will believe the progress of this thread has obsoleted that specific
> request unless you say different.

Yes, it seems as though Jens is close to, or has solved
this problem.

>>>Can ioctl SG_IO fetch the offset 7 Additional Length field of op x03
>>>"REQUEST SENSE" data?
>>>
>>>Naively I thought yes of course, I know that works with /dev/scd$n.
>>>
>>>But then I tried a /dev/hd$v ide-floppy.  No joy.  perror tells me ioctl
>>>SG_IO fails via "Invalid argument", ...
>>
>>My method with the SG_IO ioctl was to yield errnos
>>if the SCSI command could not be sent (or was rejected
>>at the point of transmission). So if there is an errno
>>there will be no sense buffer (or any other valid
>>response data).
> 
> 
> This much I did understand correctly from the doc.
> 
> I did eventually write:
> 
> 	ii = ioctl(fd, SG_IO, sih);
> 	if (ii < 0) {
> 		perror("ioctl SG_IO");
> 		... die ...
> 	} else {
> 		fwrite(sih->dxferp, sih->dxfer_len, 1, stdout);

If this fwrite() is outputting something that has be read from
the device then it shouldn't be done _before_ the following
status/warning/error checks.

> 		if ((sih->info & SG_INFO_OK_MASK) != SG_INFO_OK) {
> 			... die ...
> 		} else if (sih->resid != 0) {
> 			... die ...
> 		}
> 		...
> 	}
> 
> The case that falls thru without "die"ing is my guess of when SG_IO
> actually has reported complete success.

It is not quite that simple. There are some statuses like the
sense key of RECOVERED ERROR that imply the operation worked
but "I thought you would like to know that your disk might be
dying ...". Then there are UNIT ATTENTIONs to inform you that
the device has been reset or the reservation you had has been
cleared by someone else. If that information isn't relevant
to your application then executing the command again will most
likely succeed. There can also be deferred errors (i.e. that
write you did earlier failed which can happen when write
caching is employed).

So I'm trying to encourage you and others to check the returned
SCSI status (and other statuses that could flag a command timeout
for example) and if necessary decode the sense buffer. sg_err.[hc]
in sg3_utils does a lot of this work.

Doug Gilbert


