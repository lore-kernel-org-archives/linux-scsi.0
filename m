From: Brian King <brking@us.ibm.com>
Subject: Re: error handling in 2.6.x
Date: Wed, 01 Sep 2004 16:50:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4136442C.2090303@us.ibm.com>
References: <1094069889.4883.652.camel@tinny.home.foo>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:49369 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S268177AbUIAVvJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Sep 2004 17:51:09 -0400
In-Reply-To: <1094069889.4883.652.camel@tinny.home.foo>
List-Id: linux-scsi@vger.kernel.org
To: "Scott T. Smith" <scott@gelatinous.com>
Cc: linux-scsi@vger.kernel.org

They are called from a kernel thread, so they can sleep if necessary. 
They are called with the host_lock held, so make sure to drop the lock 
before you sleep.

-Brian

Scott T. Smith wrote:
> I'm modifying an error handler for a 2.6.x driver
> (eh_device_reset_handler and eh_bus_reset_handler) and am wondering if I
> can use semaphores... is it called from a user context, or is it called
> from a "bottom half"?  Given that I see scsi_eh_%d processes on my
> machine, I assume it's called from a user context, but I just wanted to
> be sure first.
> 
> 	Scott
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

