From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Bugme-new] [Bug 9405] New: iSCSI does not implement ordering
 guarantees required by e.g. journaling filesystems
Date: Tue, 20 Nov 2007 21:22:16 +0300
Message-ID: <474325D8.1080105@vlnb.net>
References: <bug-9405-10286@http.bugzilla.kernel.org/>	 <20071119125040.9f6eb1e2.akpm@linux-foundation.org>	 <1195505766.3963.1.camel@localhost.localdomain>	 <4741FE89.4020307@cs.wisc.edu>	 <1195507720.3963.4.camel@localhost.localdomain> <4742F78B.8010004@vlnb.net>	 <1195572482.3131.28.camel@localhost.localdomain>	 <4743082D.7030302@vlnb.net>	 <1195577040.3131.48.camel@localhost.localdomain>	 <47431697.3080901@vlnb.net>	 <1195579841.3131.60.camel@localhost.localdomain>	 <47431D28.9020708@vlnb.net> <1195581426.3131.75.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-01.mailcluster.net ([77.221.130.213]:46171 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755204AbXKTS2q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Nov 2007 13:28:46 -0500
In-Reply-To: <1195581426.3131.75.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, bart.vanassche@gmail.com

James Bottomley wrote:
>>>>>>>I'm not sure your conclusions necessarily follow your data.  What was
>>>>>>>the reason for the TASK ABORTED (I'd guess QErr settings, right)?
>>>>>>
>>>>>>It was my desire/curiosity during tests of SCST (http://scst.sf.net), 
>>>>>>when it working with several initiators with different transports over 
>>>>>>the same set of devices, each of them having with TAS bit in the control 
>>>>>>mode page set. According to SAM, in this case TASK ABORTED status can be 
>>>>>>returned at any time, similarly to QUEUE FULL, i.e. IMHO such command 
>>>>>>just should be retried. But QUEUE FULL status handled well, but TASK 
>>>>>>ABORTED leads to filesystem corruption.
>>>>>
>>>>>So this is with a soft target implementation ... so it could be an
>>>>>ordering issue inside the target that's causing the filesystem
>>>>>corruption on error.
>>>>
>>>>Target offers no ordering guarantees for SIMPLE commands and frankly 
>>>>says that to initiator via QUEUE ALGORITHM MODIFIER value 1 in the 
>>>>control mode page. As we know, initiator doesn't use ORDERED tags (and 
>>>>it really doesn't use them according to the logs), so if it's an 
>>>>ordering issue, it's at the initiator's side.
>>>>
>>>>>if you specifically set TAS=1 you're giving up the right to know what
>>>>>caused the command termination.  With insufficient information, it's
>>>>>really unsafe to simply retry, which is why the mid layer just returns
>>>>>TASK ABORTED as an error.  If you set TAS=0 we'll get a check
>>>>>condition/unit attention explaining what happened (usually commands
>>>>>cleared by another initiator) and we'll explicitly do the right thing
>>>>>based on the sense data.
>>>>
>>>>But having TAS=1 is legal, right? So it should be handled well. If 
>>>>TAS=0, TASK ABORTED can't be returned, it would be illegal. So, TASK 
>>>>ABORTED status can only be returned with TAS=1.
>>>
>>>Driving with your handbrake on is legal too ... that doesn't mean you
>>>should do it ... and it certainly doesn't give you a legitimate
>>>complaint against the manufacturer of your car for excessive brake pad
>>>wear.
>>>
>>>We handle TASK ABORTED as well as we can (by failing it).  For better
>>>handling set TAS=0 and we'll handle the individual cases according to
>>>the sense codes.
>>
>>So, should I consider your words as you think that it's perfectly fine 
>>to corrupt file system for devices with TAS=1? Absolutely legal devices, 
>>repeat. Hence, in your opinion, no further investigation should be done?
> 
> Logic wouldn't support such a conclusion.

Sorry, lately I've got too many "I won't bother, this is your problem" 
style answers

> You have intertwined two issues
> 
>      1. How should the mid layer handle TASK ABORTED.  I think we've
>         reached the point where returning I/O error is the best we can
>         do, but if TAS=0 we could have used the sense data to do better.
>      2. Should a request I/O error cause corruption in ext3 that can't
>         be recovered by a journal replay. I think the answer here is
>         no, so there needs to be an easily reproducible test case to
>         pass to the filesystem people.

OK, I see you point. As I already wrote, I can assist only in testing here.

> James
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

