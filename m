From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/11] scsi/fcoe: lock online CPUs in fcoe_percpu_clean()
Date: Fri, 11 Mar 2016 08:17:04 -0800
Message-ID: <20160311161704.GA5083@infradead.org>
References: <1457710143-29182-1-git-send-email-bigeasy@linutronix.de>
 <1457710143-29182-2-git-send-email-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55578 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153AbcCKQRG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Mar 2016 11:17:06 -0500
Content-Disposition: inline
In-Reply-To: <1457710143-29182-2-git-send-email-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, rt@linutronix.de, Vasu Dev <vasu.dev@intel.com>, Christoph Hellwig <hch@lst.de>, fcoe-devel@open-fcoe.org

On Fri, Mar 11, 2016 at 04:28:53PM +0100, Sebastian Andrzej Siewior wrote:
> for_each_possible_cpu() with a cpu_online() + `thread' check possibly does
> the job. But there is a tiny race: Say CPU5 is reported online but is
> going down. And after fcoe_percpu_clean() saw that CPU5 is online it
> decided to enqueue a packet. After dev_alloc_skb() returned a skb
> that CPU is offline (or say the notifier destroyed the kthread). So we
> would OOps because `thread' is NULL.
> An alternative would be to lock the CPUs during our loop (so no CPU is
> going away) and then we iterate over the online mask.

I've looked over this and the following patches, and I suspect
the right thing to do for fcoe and bnx2 is to convert them to use the
generic workqueue code instead of reinventing it poorly.
