From: Nishanth Aravamudan <nacc@us.ibm.com>
Subject: Re: [Kernel-janitors] [PATCH] Re: no set_current_state() before schedule_timeout()
 (OSST)
Date: Tue, 13 Jul 2004 23:56:41 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40F476B9.4090101@us.ibm.com>
References: <40F41EA6.9000900@us.ibm.com> <1089760052l.26949l.0l@serve.riede.org> <29495f1d04071316362e782433@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:59060 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S267253AbUGMX5C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jul 2004 19:57:02 -0400
In-Reply-To: <29495f1d04071316362e782433@mail.gmail.com>
List-Id: linux-scsi@vger.kernel.org
To: Nish Aravamudan <nish.aravamudan@gmail.com>
Cc: Willem Riede <osst@riede.org>, kernel-janitors@lists.osdl.org, osst-users@lists.sourceforge.net, linux-scsi@vger.kernel.org

Nish Aravamudan wrote:
> On Tue, 13 Jul 2004 23:07:32 +0000, Willem Riede <osst@riede.org> wrote:
> 
>>
>>On 07/13/2004 01:40:54 PM, Nishanth Aravamudan wrote:
> 
> 
> <snip>
> 
>>>If someone could tell me which state (TASK_INTERRUPTIBLE or
>>>TASK_UNINTERRUPTIBLE) is desired, I can fix this and perhaps replace the
>>>calls with msleep().
>>
>>You're right, there is a set_current_state(TASK_INTERRUPTIBLE) missing.
>>I don't know why we would want to change to use msleep() though.
> 
> 
> <snip>
> 
> The main reason I see for using msleep() instead is if the task should
> sleep for at least 100 ms. Using TASK_INTERRUPTIBLE (or really
> anything other than msleep()) is not guaranteed to sleep as long as
> requested. If that's ok / desired, then I won't convert it, of course.

To be clear, the 100 ms I mention above is specific to this example. In 
general, if the time you want to sleep (and you really want to *sleep* 
for that time) is measureable in msecs, then msleep() is the way to go.

-Nish

