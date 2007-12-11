From: Steven Pratt <slpratt@austin.ibm.com>
Subject: Re: MPTSAS Driver and scatter gather lists
Date: Tue, 11 Dec 2007 08:49:56 -0600
Message-ID: <475EA394.2080504@austin.ibm.com>
References: <47557600.5040902@austin.ibm.com> <ac8af0be0712110018s647b0d04o5dc96dbe318a9759@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:34207 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbXLKOuc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Dec 2007 09:50:32 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id lBBEq0aT028137
	for <linux-scsi@vger.kernel.org>; Tue, 11 Dec 2007 09:52:00 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lBBEoHfv140158
	for <linux-scsi@vger.kernel.org>; Tue, 11 Dec 2007 09:50:17 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lBBEoGPB020779
	for <linux-scsi@vger.kernel.org>; Tue, 11 Dec 2007 09:50:17 -0500
In-Reply-To: <ac8af0be0712110018s647b0d04o5dc96dbe318a9759@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zhao Forrest <forrest.zhao@gmail.com>
Cc: linux-scsi@vger.kernel.org

Zhao Forrest wrote:
> Steve,
> Do you use a 10k RPM SAS hard drive? Could you share that what test
> tools(or test cases) are you using to do the block IO test? We have a
> LSI SAS1068E chip and 10k RPM SAS hard drive in our lab. I'll find
> some time to reproduce the issue and do some investigation.
>   
I've been using 10k and 15k drives (although these particular tests were 
from 15k).  I've been mostly using an internal IO tool, but this is 
easily reproducible with dd using the iflag=direct to force ODIRECT. 

Steve

> Thanks,
> Forrest
>
> On 12/4/07, Steven Pratt <slpratt@austin.ibm.com> wrote:
>   
>> I was doing some performance comparisons between the aic94xx sas adapter
>> and the mptsas (lsi1078 chip) and saw that performance was slightly
>> lower on lsi using the same drive. One thing I noticed the mptsas driver
>> was only setting sg_tablesize to 40 which restricts the maximum size of
>> the IO to 160kb.  This is inefficient and so I changed it to 255 (max
>> value) for testing purposes.  The results were not what I expected.
>> While CPU efficiency was improved at the larger block sizes (like I had
>> hopped), there were drastic improvements at small (<16k) block sizes
>> which is completely surprising).  So I decided to see where all the time
>> was being spent.  When doing oprofile, loss of idle ticks was confusing
>> things so I booted with idle=poll, and magically the original mptsas
>> driver now performs like the modified version at the small block sizes.
>> My suspicion is that we have some some sleep delay which is minimized by
>> going into poll mode, but I have no idea why changing the sg_tablesize
>> gives the same results regardless of poll mode.  I should reiterate that
>> I am not talking about small difference. This is 2x performance at 1/3 cpu.
>>
>> Also, is there any reason we can't increase sg_tablesize for mptsas?
>>
>> Any thoughts or experiments to try are welcome.
>> Steve
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>     

