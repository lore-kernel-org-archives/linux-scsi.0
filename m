From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] ibmvscsi driver - sixth version
Date: Thu, 01 Apr 2004 02:13:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <406BC126.1030700@pobox.com>
References: <opr3u0ffo7l6e53g@us.ibm.com> <20040225134518.A4238@infradead.org> <opr3xta6gbl6e53g@us.ibm.com> <1079027038.2820.57.camel@mulgrave> <opr5qwiyw4l6e53g@us.ibm.com> <406B3FDA.9010507@pobox.com> <opr5q1enb6l6e53g@us.ibm.com> <406B5F4C.10000@pobox.com> <20040401060300.GA13819@praka.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:24219 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262454AbUDAHN4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Apr 2004 02:13:56 -0500
In-Reply-To: <20040401060300.GA13819@praka.local.home>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <praka@users.sourceforge.net>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Andrew Vasquez wrote:
> On Wed, 31 Mar 2004, Jeff Garzik wrote:
> 
> 
>>>>12) in ibmvscsi_probe(), you want to use TASK_UNINTERRUPTIBLE here:
>>>>
>>>>+            set_current_state(TASK_INTERRUPTIBLE);
>>>>+            schedule_timeout(5);
>>>>
>>>>13) in the code pasted in #12, you should pass a value calculated 
>>>>using the 'HZ' constant.
>>>
>>>Hmmm...above code copied from the qlogic driver...and it looked reasonable
>>>to me, but I'll tweak it.
>>
>>Well, qlogic is wrong too.  Do you want to submit a patch fixing qlogic 
>>while you're at it?  ;-)
>>
> 
> 
> Fair enough - the driver isn't checking the return value of
> schedule_timeout() in many cases.  How about the attached patch
> against scsi-misc-2.6.

Looks good to me...

but a question:  in the cases you left TASK_INTERRUPTIBLE, do you care 
at all about signals interrupting the wait?  What are the implications 
of signal delivery and a shorter schedule_timeout() on these remaining 
cases?

	Jeff




