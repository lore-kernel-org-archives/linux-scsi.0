From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [patch,v3 04/10] scsi: allocate scsi_cmnd-s from the device's local numa node
Date: Mon, 12 Nov 2012 09:25:05 -0500
Message-ID: <x49zk2mkif2.fsf@segfault.boston.devel.redhat.com>
References: <1352488687-19935-1-git-send-email-jmoyer@redhat.com>
	<1352488687-19935-5-git-send-email-jmoyer@redhat.com>
	<509E178B.6090601@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <509E178B.6090601@acm.org> (Bart Van Assche's message of "Sat, 10
	Nov 2012 09:59:55 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

Bart Van Assche <bvanassche@acm.org> writes:

> On 11/09/12 20:18, Jeff Moyer wrote:
>> -	cmd = kmem_cache_zalloc(pool->cmd_slab, gfp_mask | pool->gfp_mask);
>> +	cmd = kmem_cache_alloc_node(pool->cmd_slab,
>> +				    gfp_mask | pool->gfp_mask | __GFP_ZERO,
>> +				    node);
>
> Hello Jeff,
>
> Is it necessary to add __GFP_ZERO here ? And if so, why ?

Hi, Bart,

The code used to do zeroing, so I just kept that aspect the same.  There
is no kmem_cache_zalloc_node, and it didn't seem worth adding one.

Cheers,
Jeff
