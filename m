From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/11] scsi/fcoe: lock online CPUs in fcoe_percpu_clean()
Date: Tue, 15 Mar 2016 01:19:40 -0700
Message-ID: <20160315081940.GB9136@infradead.org>
References: <1457710143-29182-1-git-send-email-bigeasy@linutronix.de>
 <1457710143-29182-2-git-send-email-bigeasy@linutronix.de>
 <20160311161704.GA5083@infradead.org>
 <56E2F30F.5030108@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.137.202.9] ([198.137.202.9]:59270 "EHLO
	bombadil.infradead.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932686AbcCOIU3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Mar 2016 04:20:29 -0400
Content-Disposition: inline
In-Reply-To: <56E2F30F.5030108@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, rt@linutronix.de, Vasu Dev <vasu.dev@intel.com>, fcoe-devel@open-fcoe.org

On Fri, Mar 11, 2016 at 05:32:15PM +0100, Sebastian Andrzej Siewior wrote:
> alloc_workqueue() in setup and then queue_work_on(cpu, , item)? item
> should be struct work_struct but all I have is a skb. Is there an easy
> way to get this attached?

Good question.  There is skb->cb, but it looks like it doesn't have
space for an additional work_item in the fcoe case.  Maybe have
a per-cpu work_struct and keep all the list handling as-is for now?
