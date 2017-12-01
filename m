From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/2] Ensure that the SCSI error handler gets woken up
Date: Fri, 01 Dec 2017 09:45:47 +0100
Message-ID: <mqd609q4z0k.fsf@linux-x5ow.site>
References: <20171130224456.23100-1-bart.vanassche@wdc.com>
        <20171130224456.23100-2-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38659 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750994AbdLAIps (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 1 Dec 2017 03:45:48 -0500
In-Reply-To: <20171130224456.23100-2-bart.vanassche@wdc.com> (Bart Van
        Assche's message of "Thu, 30 Nov 2017 14:44:55 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>, Stuart Hayes <stuart.w.hayes@gmail.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, stable@vger.kernel.org

Hi Bart,

Bart Van Assche <bart.vanassche@wdc.com> writes:
[...]

> +	if (shost_state != shost->shost_state) {
> +		spin_unlock_irqrestore(shost->host_lock, flags);
> +		synchronize_rcu();
> +		spin_lock_irqsave(shost->host_lock, flags);
> +	}

Plese correct me if I'm wrong, but once you drop the host lock all
assumptions about states it protects are void, aren't they? 

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
