From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 3/7] libfc: Do not take rdata->rp_mutex when processing a
 -FC_EX_CLOSED ELS response.
Date: Fri, 30 Sep 2016 09:26:15 +0200
Message-ID: <20160930072615.qefysem3jdqs4tdh@linux-x5ow.site>
References: <1475219054-31241-1-git-send-email-hare@suse.de>
 <1475219054-31241-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56498 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755564AbcI3H0Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Sep 2016 03:26:16 -0400
Content-Disposition: inline
In-Reply-To: <1475219054-31241-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, Chad Dupuis <chad.dupuis@cavium.com>, linux-scsi@vger.kernel.org

On Fri, Sep 30, 2016 at 09:04:10AM +0200, Hannes Reinecke wrote:
> From: Chad Dupuis <chad.dupuis@cavium.com>
> 
> When an ELS response handler receives a -FC_EX_CLOSED, the rdata->rp_mutex is
> already held which can lead to a deadlock condition like the following stack trace:
> 
> [<ffffffffa04d8f18>] fc_rport_plogi_resp+0x28/0x200 [libfc]
> [<ffffffffa04cfa1a>] fc_invoke_resp+0x6a/0xe0 [libfc]
> [<ffffffffa04d0c08>] fc_exch_mgr_reset+0x1b8/0x280 [libfc]
> [<ffffffffa04d87b3>] fc_rport_logoff+0x43/0xd0 [libfc]
> [<ffffffffa04ce73d>] fc_disc_stop+0x6d/0xf0 [libfc]
> [<ffffffffa04ce7ce>] fc_disc_stop_final+0xe/0x20 [libfc]
> [<ffffffffa04d55f7>] fc_fabric_logoff+0x17/0x70 [libfc]
> 
> The other ELS handlers need to follow the FLOGI response handler and simply do
> a kref_put against the fc_rport_priv struct and exit when receving a
> -FC_EX_CLOSED response.
> 
> Signed-off-by: Chad Dupuis <chad.dupuis@cavium.com>
> ---
>  drivers/scsi/libfc/fc_rport.c | 32 ++++++++++++++++++++++++--------
>  1 file changed, 24 insertions(+), 8 deletions(-)

Acked-by: Johannes Thumshirn <jth@kernel.org>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
