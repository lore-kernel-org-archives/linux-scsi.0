From: Luben Tuikov <tluben@rogers.com>
Subject: Re: [PATCH] scsi-misc-2.5 user per-device spare command
Date: Fri, 25 Apr 2003 10:12:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EA94263.1020902@rogers.com>
References: <20030424100229.A32098@beaverton.ibm.com> <20030424100317.A32134@beaverton.ibm.com> <20030425111227.B28577@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep01-mail.bloor.is.net.cable.rogers.com ([66.185.86.71]:59913
	"EHLO fep01-mail.bloor.is.net.cable.rogers.com") by vger.kernel.org
	with ESMTP id S263212AbTDYOAq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Apr 2003 10:00:46 -0400
In-Reply-To: <20030425111227.B28577@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Patrick Mansfield <patmans@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Thu, Apr 24, 2003 at 10:03:17AM -0700, Patrick Mansfield wrote:
> 
> 
>>+	/*
>>+	 * Use any spare command first.
>>+	 */
>>+	cmd = sdev->spare_cmd;
>>+	if (cmd != NULL)
>>+		sdev->spare_cmd = NULL;
>>+	else 
>>+		cmd = kmem_cache_alloc(sdev->host->cmd_pool->slab,
>>+				gfp_mask | sdev->host->cmd_pool->gfp_mask);
> 
> 
> This logical is flawed.  We don't need a spare command if we always use
> it first.  In addition the sdev->spare_cmd access is racy.

Good call Christoph!

I was going to comment on this last night, but it was too late
and I only marked the messages for this morning.

Patrick, take a look at how the logic now works, and if you're
doing something similar, try to at least emulate it, as if not
improve on it (although Christoph has already done this).

Here are a few pointers:

1. Use the cache *first*, and if it's depleted, *then*
use the spare command struct.

2. Why spare_cmd is a pointer? Why? Why?
Wouldn't it be much more *flexible* to be a list_head,
so that maybe we can hook up more commands in the future?
I.e. keep your options open...

3. As Christoph pointed out, access to your spare is racy.

4. Why are you using list_del()???? You should use list_del_init()!
I can easily envision a hard to catch bug (and quite rare), when
some LLDD gets the spare and does a check on the list_head...

Furthermore, cannot you see the infrastructure to which we've
tried to get closer to?  More specifically a command struct travels
list_heads as it comes out of the cache/spare_list and comes
back to the cache/spare_list.

-- 
Luben


