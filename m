From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Bugme-new] [Bug 9405] New: iSCSI does not implement ordering
 guarantees required by e.g. journaling filesystems
Date: Wed, 21 Nov 2007 15:31:21 +0300
Message-ID: <47442519.5080108@vlnb.net>
References: <bug-9405-10286@http.bugzilla.kernel.org/>	 <20071119125040.9f6eb1e2.akpm@linux-foundation.org>	 <1195505766.3963.1.camel@localhost.localdomain>	 <4741FE89.4020307@cs.wisc.edu>	 <1195507720.3963.4.camel@localhost.localdomain> <4742F78B.8010004@vlnb.net>	 <1195572482.3131.28.camel@localhost.localdomain>	 <4743082D.7030302@vlnb.net>	 <1195577040.3131.48.camel@localhost.localdomain>	 <47431697.3080901@vlnb.net>	 <1195579841.3131.60.camel@localhost.localdomain>	 <47431D28.9020708@vlnb.net> <1195581426.3131.75.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-02.mailcluster.net ([77.221.130.214]:53679 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753633AbXKUMbt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2007 07:31:49 -0500
In-Reply-To: <1195581426.3131.75.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, bart.vanassche@gmail.com

James Bottomley wrote:
>>>>>if you specifically set TAS=1 you're giving up the right to know what
>>>>>caused the command termination.  With insufficient information, it's
>>>>>really unsafe to simply retry, which is why the mid layer just returns
>>>>>TASK ABORTED as an error.  If you set TAS=0 we'll get a check
>>>>>condition/unit attention explaining what happened (usually commands
>>>>>cleared by another initiator) and we'll explicitly do the right thing
>>>>>based on the sense data.

Actually, having TAS=1 has a considerably advantage over TAS=0 from 
error recovery point of view. With TAS=1 all aborted commands are 
supposed to be returned immediately to all affected initiators. With 
TAS=0 affected initiators will not receive any notification about 
aborted commands, only COMMANDS CLEARED BY ANOTHER INITIATOR UA will be 
established. So, they will know about that only after there will be 
timeout for their commands.

Thus, with TAS=1 almost immediate error recovery is possible, but with 
TAS=0 error recovery is possible after timeout, which for SSC devices 
can be hours.

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

After some digging in SAM/SPC I've figured out that TASK ABORTED status 
can be returned exactly in the same circumstances as COMMANDS CLEARED BY 
ANOTHER INITIATOR UA, it only depends from TAS bit, which way of the 
notification is used. So, TASK ABORTED status carries the same 
information as COMMANDS CLEARED BY ANOTHER INITIATOR UA and should be 
handled at the same way. I.e., if for COMMANDS CLEARED BY ANOTHER 
INITIATOR UA the affected commands are restarted, they should be 
restarted for TASK ABORTED status as well.

Vlad
