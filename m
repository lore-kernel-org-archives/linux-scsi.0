From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: libata: SATL error processing: unrecovered read error
Date: Fri, 17 Sep 2010 15:26:13 -0400
Message-ID: <4C93C0D5.2090402@interlog.com>
References: <4C83BDDC.3020201@interlog.com> <4C93B418.8040106@garzik.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:47615 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220Ab0IQT03 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Sep 2010 15:26:29 -0400
In-Reply-To: <4C93B418.8040106@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>

On 10-09-17 02:31 PM, Jeff Garzik wrote:
> On 09/05/2010 11:57 AM, Douglas Gilbert wrote:
>> While looking at an eSATA connected external disk with
>> a medium error, this sense data appeared:
>>
>> READ cdb: 28 00 96 4a 7a d1 00 00 01 00
>> duration=2816 ms
>> READ: Descriptor format, current; Sense key: Medium Error
>> Additional sense: Unrecovered read error - auto reallocate failed
>> Descriptor type: Information
>> 0x00000000964a7ad1
>> Raw sense data (in hex):
>> 72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
>> 96 4a 7a d1
>>
>> That is pretty close to what I was expecting to see. If anything
>> there is too much information. That "Unrecovered read error -
>> auto reallocate failed" [asc/asq: 11h/04h] should just be
>> "Unrecovered read error" [asc/asq: 11h/0h]. See sat2r09.pdf table
>> 105 or sat3r00.pdf table 105.
>
> If any auto-reallocate occurred on the drive's part, it definitely
> failed at that point. And auto-reallocate is a possibility.
>
> 11h/04h seems to more accurately describe the situation.

Usually if you are implementing a SCSI device (lu) there
is some latitude in asc/asq codes. However for a SAT layer
they state exactly how to translate ATA errors.

There is one published SAT standard (ANSI INCITS 431-2007)
and there will soon be another one (SAT-2). The compliant
response is asc/asq: 11h/0h since in t10 documents additional
sense matches by string which is shown in upper case.


BTW I never understood what asc/asq 11h/04h was about,
auto-reallocate is something that should be attempted
on a _recovered_ read error. And that in turn might fail
if the disk had run out of spare blocks. So in a contorted
sort of way, perhaps that is what "Unrecovered read error -
auto reallocate failed" means!?  If so, you are most
likely incorrect on that count as well.

Doug Gilbert
