From: Tameen Khan <tameen@andiamo.com>
Subject: Re: setting maximum queue depth to 255 with sg driver
Date: Fri, 30 May 2003 09:41:44 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4.3.2.7.2.20030530092235.029d1198@andiamo.com>
References: <4.3.2.7.2.20030529235329.029e0740@andiamo.com>
 <4.3.2.7.2.20030529235329.029e0740@andiamo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtp-core-1.cisco.com ([64.102.124.12]:35775 "EHLO
	rtp-core-1.cisco.com") by vger.kernel.org with ESMTP
	id S263791AbTE3QbN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 May 2003 12:31:13 -0400
In-Reply-To: <3ED72359.9020202@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

At 07:24 PM 5/30/2003 +1000, Douglas Gilbert wrote:
>Tameen Khan wrote:
>>goal is to achieve a max queue depth of 255 using qlogic hba qla2342 on a 
>>linux host (2.4.18)
>>I am using scsi generic driver to do IO. The queue depth bottleneck is 
>>SG_MAX_QUEUE as indicated in the documentation.
>>The SG_MAX_QUEUE value is 16
>>I've tried one way to bypass this limit (as suggested in 
>>http://tldp.org/HOWTO/SCSI-Generic-HOWTO/)
>>That is to do multiple open() to the same device, SG driver should allow 
>>queueing of 16
>>commands per device.
>
>.... commands per open file descriptor.
>
>>This does not work for me and I still see a maximum queue depth of 16.
>
>Tameen,
>In what sense doesn't it work; something wrong with the
>sg driver or doesn't fit your code?

I was doing multiple open() to the same device. And then use write() to 
send out IO
on all the opened file descriptors in Nonblcoking  mode. I still see a 
maximum queue depth of 16. So doing multiple open() does not does not allow 
me to achieve more than the SG_MAX_QUEUE limit.

I suspect that a lower level driver may be throttling the maximum queue 
depth to 16.


>>What could be the reason and what could be a workaround ?
>>What could be other ways to increase the queue depth beyond 16 ?
>
>You can of course change SG_MAX_QUEUE to 255 and recompile
>the sg driver. At the time that code was written (early lk 2.2
>series) there was often a shortage of RAM so the idea was
>to predefine resources at open() and if that succeeded reasonable
>guarantees could be given that subsequent operations would not
>fail with ENOMEM. This was (and still is) important to applications
>like cdrecord and its predecessor cdwrite.
>
>Doug Gilbert
>
>

