From: "Duane Grigsby" <duane.grigsby@qlogic.com>
Subject: RE: setting maximum queue depth to 255 with sg driver
Date: Fri, 30 May 2003 10:38:12 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41EBA11203419D4CA8EB4C6140D8B40101021138@AVEXCH01.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.70.193.2] ([198.70.193.2]:26173 "EHLO AVEXCH01.qlogic.org")
	by vger.kernel.org with ESMTP id S263848AbTE3R1G convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 May 2003 13:27:06 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Tameen Khan <tameen@andiamo.com>, dougg@torque.net
Cc: linux-scsi@vger.kernel.org

The Qlogic driver has a default queue depth of 16 in some of the older versions. It currently set to 32. You can change it on the commandline: 

insmod qla2300.o ql2xmaxqdepth=xx

where xx is the queue depth you want.

Duane

>>-----Original Message-----
>>From: Tameen Khan [mailto:tameen@andiamo.com]
>>Sent: Friday, May 30, 2003 9:42 AM
>>To: dougg@torque.net
>>Cc: linux-scsi@vger.kernel.org
>>Subject: Re: setting maximum queue depth to 255 with sg driver
>>
>>
>>At 07:24 PM 5/30/2003 +1000, Douglas Gilbert wrote:
>>>Tameen Khan wrote:
>>>>goal is to achieve a max queue depth of 255 using qlogic 
>>hba qla2342 on a 
>>>>linux host (2.4.18)
>>>>I am using scsi generic driver to do IO. The queue depth 
>>bottleneck is 
>>>>SG_MAX_QUEUE as indicated in the documentation.
>>>>The SG_MAX_QUEUE value is 16
>>>>I've tried one way to bypass this limit (as suggested in 
>>>>http://tldp.org/HOWTO/SCSI-Generic-HOWTO/)
>>>>That is to do multiple open() to the same device, SG driver 
>>should allow 
>>>>queueing of 16
>>>>commands per device.
>>>
>>>.... commands per open file descriptor.
>>>
>>>>This does not work for me and I still see a maximum queue 
>>depth of 16.
>>>
>>>Tameen,
>>>In what sense doesn't it work; something wrong with the
>>>sg driver or doesn't fit your code?
>>
>>I was doing multiple open() to the same device. And then use 
>>write() to 
>>send out IO
>>on all the opened file descriptors in Nonblcoking  mode. I 
>>still see a 
>>maximum queue depth of 16. So doing multiple open() does not 
>>does not allow 
>>me to achieve more than the SG_MAX_QUEUE limit.
>>
>>I suspect that a lower level driver may be throttling the 
>>maximum queue 
>>depth to 16.
>>
>>
>>>>What could be the reason and what could be a workaround ?
>>>>What could be other ways to increase the queue depth beyond 16 ?
>>>
>>>You can of course change SG_MAX_QUEUE to 255 and recompile
>>>the sg driver. At the time that code was written (early lk 2.2
>>>series) there was often a shortage of RAM so the idea was
>>>to predefine resources at open() and if that succeeded reasonable
>>>guarantees could be given that subsequent operations would not
>>>fail with ENOMEM. This was (and still is) important to applications
>>>like cdrecord and its predecessor cdwrite.
>>>
>>>Doug Gilbert
>>>
>>>
>>
>>-
>>To unsubscribe from this list: send the line "unsubscribe 
>>linux-scsi" in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
