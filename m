From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH 1/6] mpt fusion - fibre channel target discovery	prematurely
 terminates
Date: Mon, 22 May 2006 12:34:38 -0500
Message-ID: <4471F62E.10608@sgi.com>
References: <446CD224.6060806@sgi.com> <1148139217.3529.19.camel@mulgrave.il.steeleye.com> <4471F560.8050709@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:659 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1751085AbWEVRem (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 May 2006 13:34:42 -0400
In-Reply-To: <4471F560.8050709@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Michael Reed <mdr@sgi.com>, linux-scsi <linux-scsi@vger.kernel.org>



Michael Reed wrote:
> 
> James Bottomley wrote:
>> On Thu, 2006-05-18 at 14:59 -0500, Michael Reed wrote:
>>> mpt_config() can return EAGAIN.  When this happens, fibre channel target
>>> discovery can prematurely terminate with fewer than the total number of
>>> targets discovered.  This patch detects EAGAIN and reschedules the scan
>>> work.
>>>
>>> Generally, this situation only occurs when the lsiutil program is being
>>> used to reset the board.
>> mpt_config() only returns EAGAIN when it's out of message frames.  That
>> should be a very transient condition, so if this rarely occurs anyway,
>> why not just put an msleep(10) on the condition and then retry?  It
>> would save all the requeue logic.
> 
> It's not so transient during reset processing.  I've measured 10 to
> 15 seconds of elapsed time.  But, it always eventually succeeds.

Well, I should have said that the event occurs with some regularity
during reset processing.  And that the duration of the EAGAIN response
is 10 to 15 seconds.  I'd rather reschedule than msleep.

Mike

> 
> Mike
> 
>> James
>>
>>
> 
