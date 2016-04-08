From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH 01/11] scsi/fcoe: lock online CPUs in fcoe_percpu_clean()
Date: Fri, 8 Apr 2016 20:14:50 +0200
Message-ID: <5707F51A.8010700@linutronix.de>
References: <1457710143-29182-1-git-send-email-bigeasy@linutronix.de>
 <1457710143-29182-2-git-send-email-bigeasy@linutronix.de>
 <20160311161704.GA5083@infradead.org> <56E2F30F.5030108@linutronix.de>
 <20160315081940.GB9136@infradead.org> <5707B270.3080006@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:52718 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbcDHSPE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2016 14:15:04 -0400
In-Reply-To: <5707B270.3080006@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, rt@linutronix.de, Vasu Dev <vasu.dev@intel.com>, fcoe-devel@open-fcoe.org

On 04/08/2016 03:30 PM, Sebastian Andrzej Siewior wrote:
> On 03/15/2016 09:19 AM, Christoph Hellwig wrote:
>> On Fri, Mar 11, 2016 at 05:32:15PM +0100, Sebastian Andrzej Siewior wrote:
>>> alloc_workqueue() in setup and then queue_work_on(cpu, , item)? item
>>> should be struct work_struct but all I have is a skb. Is there an easy
>>> way to get this attached?
>>
>> Good question.  There is skb->cb, but it looks like it doesn't have
>> space for an additional work_item in the fcoe case.  Maybe have
>> a per-cpu work_struct and keep all the list handling as-is for now?
> 
> Okay. Let me try this. What about the few fixes from the series (which
> apply before the rework to smbboot theads)?

okay kworker. This does not look good. I have it converted what I miss
flushing work when CPU goes down and ensuring not to queue work while
the CPU is down.

- cpu_online(x) is racy. In DOWN_PREPARE the worker is deactivated /
  stopped. However slightly later the bit from the CPU mask is removed.

- Whatever is queued and did not make it before the CPU went down seems
  to be delayed until the CPU comes back online.

- if the worker keeps running while the CPU is going down the worker
  continues running on a different CPU.

So I don't see how the former two points can be solved without keeping
track of CPUs in a CPU notifier. Getting pushed to a different CPU be
probably less of an issue if we would have a work-item and would not
need to rely on the per-CPU list.

Sebastian
