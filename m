From: Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: Re: Request for moving Sg_request into sg.h
Date: Tue, 08 Mar 2005 13:10:56 +0100
Message-ID: <422D9650.8070701@shadowconnect.com>
References: <422D771E.6070104@shadowconnect.com> <422D912F.6020505@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from s0003.shadowconnect.net ([213.239.201.226]:59841 "EHLO
	mail.shadowconnect.com") by vger.kernel.org with ESMTP
	id S262019AbVCHMLR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Mar 2005 07:11:17 -0500
In-Reply-To: <422D912F.6020505@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hello,

Douglas Gilbert wrote:
> Markus Lidel wrote:
>> i wanted to ask if it is possible to put the typedef "Sg_request" into 
>> sg.h?
> A surprising question. I would have though Sg_request was
> private to the sg driver but ...

Yep i know it's not the best way, but the only way to get some data from 
an application to the driver beside the SCSI command itself... Of course 
it could be also solved by using separate sg devices, but on an I2O 
controller with two harddisks and a RAID-1 this would be 16 sg devices...

> It is possible. Seems as though "#if __KERNEL__" conditional
> blocks are still acceptable in kernel headers and scsi/sg,h
> already has such a block.
> If Sg_request moved to sg.h then that would require Sg_scatter_hold
> to move as well.

Hmmm your're right... Probably a new header file would be better suited 
because only kernel drivers need access to Sg_request at all...

>> The reason i'm asking is, i need to pass data through SG_IO from an 
>> application to the driver. At the moment the problem is solved by 
>> copying code of the SG_IO driver into i2o_config (the passthru 
>> function). I'm working on removing the passthru function and instead 
>> using the SG_IO interface, but therefore i need to pass some 
>> additional data to the driver. I could use the use the "flags" and 
>> "usr_ptr" fields in sg_io_hdr_t, but i need to get access to them 
>> through "Sg_request".
>> Any comments appreciated.
> Let's see what the style police say :-)

Of course if there is a better way, i would be glad to hear about it :-D

But because nobody else seems to need access to sg_io_hdr_t from within 
the driver it's probably the easiest way...

Thanks for your help...



Best regards,


Markus Lidel
------------------------------------------
Markus Lidel (Senior IT Consultant)

Shadow Connect GmbH
Carl-Reisch-Weg 12
D-86381 Krumbach
Germany

Phone:  +49 82 82/99 51-0
Fax:    +49 82 82/99 51-11

E-Mail: Markus.Lidel@shadowconnect.com
URL:    http://www.shadowconnect.com
