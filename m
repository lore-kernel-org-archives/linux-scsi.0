From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] sg.c to set direction more reliably  (was Re: [PATCH]
 fusion update to current APIs)
Date: Sat, 28 Aug 2004 15:08:09 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41301339.1020108@torque.net>
References: <20040612052003.GR24864@parcelfarce.linux.theplanet.co.uk> <20040615060811.GA178857@sgi.com> <40CE9B6F.8000301@torque.net> <20040615074137.GA179379@sgi.com> <40CF10AA.3050509@pobox.com> <20040615213458.GC182050@sgi.com> <20040615221558.GA181797@sgi.com> <20040826070935.GA126538@sgi.com> <412DA2F8.8080607@torque.net> <20040827011252.GA131916@sgi.com> <20040827081024.GA133749@sgi.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:16049 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S268174AbUH1FI5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Aug 2004 01:08:57 -0400
In-Reply-To: <20040827081024.GA133749@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: linux-scsi@vger.kernel.org, james.bottomley@steeleye.com

Jeremy Higdon wrote:
> On Thu, Aug 26, 2004 at 06:12:53PM -0700, Jeremy Higdon wrote:
> 
>>On Thu, Aug 26, 2004 at 06:44:40PM +1000, Douglas Gilbert wrote:
>>
>>>Jeremy,
>>>Perhaps the first argument of printk() could be prefixed with
>>>KERN_WARNING to make it a bit more syslog friendly.
>>>Otherwise ok.
>>>
>>>Doug Gilbert
>>
>>You're right.  It's fixed in this patch.
>>James, if you're satisfied, please apply.
> 
> 
> This is one of those days when I seem to be working against myself.
> It turns out that our RAID vendor modified their agent to trim
> the "reply_len" field for write commands, but did not trim the
> "count" field for read commands.  So in this case, sg actually
> guesses correctly when it needs to, and the app works.  Only with
> this patch, /var/log/messages gets filled with this new error
> message.
> 
> Doug, what do you think is the right thing to do?

Jeremy,
You could use a (block scope) static and only print out
the warning the first time it is detected.

Doug Gilbert
