From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 2/7] libfc: Fixup disc_mutex handling
Date: Fri, 30 Sep 2016 09:25:04 +0200
Message-ID: <20160930072504.vqin77vzzfpwe663@linux-x5ow.site>
References: <1475219054-31241-1-git-send-email-hare@suse.de>
 <1475219054-31241-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56471 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752451AbcI3HZL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Sep 2016 03:25:11 -0400
Content-Disposition: inline
In-Reply-To: <1475219054-31241-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, Chad Dupuis <chad.dupuis@cavium.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Fri, Sep 30, 2016 at 09:04:09AM +0200, Hannes Reinecke wrote:
> The list of attached 'rdata' remote port structures is RCU
> protected, so there is no need to take the 'disc_mutex' when
> traversing it.
> Rather we should be using rcu_read_lock() and kref_get_unless_zero()
> to validate the entries.
> We need, however, take the disc_mutex when deleting an entry;
> otherwise we risk clashes with list_add.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---

Acked-by: Johannes Thumshirn <jth@kernel.org>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
