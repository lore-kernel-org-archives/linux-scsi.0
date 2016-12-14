From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH RESEND v2 2/2] blk-mq: Avoid memory reclaim when remapping
 queues
Date: Wed, 14 Dec 2016 08:14:26 -0700
Message-ID: <d0e0367d-de9f-dd0c-7316-ccde65ac194b@kernel.dk>
References: <1481038304-22502-1-git-send-email-krisman@linux.vnet.ibm.com>
 <1481038304-22502-2-git-send-email-krisman@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1481038304-22502-2-git-send-email-krisman@linux.vnet.ibm.com>
Sender: linux-block-owner@vger.kernel.org
To: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Cc: wenxiong@linux.vnet.ibm.com, gpiccoli@linux.vnet.ibm.com, hch@infradead.org, Brian King <brking@linux.vnet.ibm.com>, Douglas Miller <dougmill@linux.vnet.ibm.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/06/2016 08:31 AM, Gabriel Krisman Bertazi wrote:
> While stressing memory and IO at the same time we changed SMT settings,
> we were able to consistently trigger deadlocks in the mm system, which
> froze the entire machine.
> 
> I think that under memory stress conditions, the large allocations
> performed by blk_mq_init_rq_map may trigger a reclaim, which stalls
> waiting on the block layer remmaping completion, thus deadlocking the
> system.  The trace below was collected after the machine stalled,
> waiting for the hotplug event completion.
> 
> The simplest fix for this is to make allocations in this path
> non-reclaimable, with GFP_NOIO.  With this patch, We couldn't hit the
> issue anymore.

This looks fine.

-- 
Jens Axboe

