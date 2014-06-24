From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv2 RESENDv2 2/9] target: Don't unlock/relock
	tpg_lun_lock in loop in add_node_to_devs
Date: Tue, 24 Jun 2014 14:24:48 +0200
Message-ID: <20140624122448.GA9444@lst.de>
References: <1403567738-13310-1-git-send-email-agrover@redhat.com> <1403567738-13310-3-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1403567738-13310-3-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org
List-Id: linux-scsi@vger.kernel.org

> - *
> + * Called with tpg_lun_lock held & irqs off
>   */

Instead of writing this down the code should assert the pre-conditions, e.g.

	assert_spin_locked(&tpg->tpg_lun_lock);
	WARN_ON_ONCE(!irqs_disabled());

>  	if (core_enable_device_list_for_node(lun, lacl, lacl->mapped_lun,
>  			lun_access, nacl, tpg) < 0)
> -		return -EINVAL;
> +	{

Wrong brace placement.

Also I can't see that anything ensures disabled irqs here.
