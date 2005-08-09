From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] shorten workqueue name length
Date: Tue, 9 Aug 2005 17:32:28 +0100
Message-ID: <20050809163228.GA21295@infradead.org>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AD19@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:53723 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S964829AbVHIQca (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Aug 2005 12:32:30 -0400
Content-Disposition: inline
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AD19@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Tue, Aug 09, 2005 at 12:07:12PM -0400, James.Smart@Emulex.Com wrote:
> A customer passed this fix to me...
> 
> In a system with double-digit adapter counts, after a few
> rmmod/insmod attempts, the system oops. It always occurs when
> the scsi host number reaches 100.
> 
> What is happening is that scsi_add_host() detects a transport that
> needs to allocate a workqueue, thus calls create_singlethread_workqueue().
> It hits a BUG_ON() in kernel/workqueue.c:__create_workqueue() which
> ensures the length of the name for the workqueue is 10 characters or less.
> As the name is "scsi_wq_100", we have exceeded the 10 character max.
> 
> I assume there's good reason for the name to be 10 or less. So what I've
> done is shorten the name for the workqueue. Should work until the host number
> reaches 10000.

I'd suggest just killing that limit in workqueue.c

