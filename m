From: "Rangankar, Manish" <Manish.Rangankar@cavium.com>
Subject: Re: [PATCH 1/5] scsi: bnx2i: convert to workqueue
Date: Tue, 9 May 2017 09:30:13 +0000
Message-ID: <D537890B.39BA0%manish.rangankar@cavium.com>
References: <20170410171254.30367-1-bigeasy@linutronix.de>
 <20170410171254.30367-2-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0052.outbound.protection.outlook.com ([104.47.33.52]:48386
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750883AbdEIJaQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 9 May 2017 05:30:16 -0400
In-Reply-To: <20170410171254.30367-2-bigeasy@linutronix.de>
Content-Language: en-US
Content-ID: <5DAE4B8B7D3BC644B9B08E8D2735D66D@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "rt@linutronix.de" <rt@linutronix.de>, Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, "Dupuis, Chad" <Chad.Dupuis@cavium.com>, Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@cavium.com>, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>


On 10/04/17 10:42 PM, "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>
wrote:

>The driver creates its own per-CPU threads which are updated based on CPU
>hotplug events. It is also possible to use kworkers and remove some of the
>infrastructure get the same job done while saving a few lines of code.
>
>The DECLARE_PER_CPU() definition is moved into the header file where it
>belongs. bnx2i_percpu_io_thread() becomes bnx2i_percpu_io_work() which is
>mostly the same code. The outer loop (kthread_should_stop()) gets removed
>and
>the remaining code is shifted to the left.
>bnx2i_queue_scsi_cmd_resp() is mostly the same. The code checked
>->iothread to
>decide if there is an active per-CPU thread. With the kworkers this is no
>longer possible nor required.
>The allocation of struct bnx2i_work does not happen with ->p_work_lock
>held
>which is not required. I am unsure about the call-stack so I can't say
>if this qualifies it for the allocation with GFP_KERNEL instead of
>GFP_ATOMIC (it is not _bh lock but as I said, I don't know the context).
>The allocation case has been reversed so the inner if case is called on
>!bnx2i_work and is just the invocation one function since the lock is not
>held during allocation. The init of the new bnx2i_work struct is now
>done also without the ->p_work_lock held: it is a new object, nobody
>knows about it yet. It should be enough to hold the lock while adding
>this item to the list. I am unsure about that atomic_inc() so I keep
>things as they were.
>
>The remaining part is the removal CPU hotplug notifier since it is taken
>care by the workqueue code.
>
>This patch was only compile-tested due to -ENODEV.
>
>Cc: QLogic-Storage-Upstream@qlogic.com
>Cc: Christoph Hellwig <hch@lst.de>
>Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>---

Didn't seen any issue with regression testing. Thanks Sebastian.

Acked-by: Manish Rangankar <Manish.Rangankar@cavium.com>
