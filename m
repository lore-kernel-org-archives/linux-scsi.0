From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH] sg_cmd_done - another oops
Date: Wed, 09 Jun 2004 09:44:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40C7224C.1070900@us.ibm.com>
References: <40C0968E.4090309@us.ibm.com> <40C3D988.3090709@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:6616 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266145AbUFIOpF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2004 10:45:05 -0400
In-Reply-To: <40C3D988.3090709@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> Brian,
> Thanks for this analysis; I'm still trying to get my head
> around it :-) These "spurious wakeups" are a worry. Does
> your testing produce them or do they occur randomly?

They occur randomly.

> The critical part of your patch seems to be the write
> lock in sg_cmd_done() making sure srp->done is set _and_
> wake_up_interruptible() gets executed before the
> __wait_event_interruptible macro in sg_read() or
> sg_remove(_sfp) can proceed.

That is correct.

> The attached patch merges Brian patches with those proposed
> by Patrick. The patch is against lk 2.6.7-rc2 (and sg hasn't
> changed between rc2 and rc2-bk5).

The patch looks good.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

