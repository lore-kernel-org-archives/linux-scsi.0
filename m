From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/10] zfcp: fix D_ID field with actual value on tracing
 SAN responses
Date: Thu, 11 Aug 2016 13:24:11 +0200
Message-ID: <a2c7603d-8766-ffde-792e-32e09613e51a@suse.de>
References: <1470846653-90691-1-git-send-email-maier@linux.vnet.ibm.com>
 <1470846653-90691-9-git-send-email-maier@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32939 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbcHKLYN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2016 07:24:13 -0400
In-Reply-To: <1470846653-90691-9-git-send-email-maier@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, "#2 . 6 . 38+" <stable@vger.kernel.org>

On 08/10/2016 06:30 PM, Steffen Maier wrote:
> With commit 2c55b750a884b86dea8b4cc5f15e1484cc47a25c
> ("[SCSI] zfcp: Redesign of the debug tracing for SAN records.")
> we lost the N_Port-ID where an ELS response comes from.
> With commit 7c7dc196814b9e1d5cc254dc579a5fa78ae524f7
> ("[SCSI] zfcp: Simplify handling of ct and els requests")
> we lost the N_Port-ID where a CT response comes from.
> It's especially useful if the request SAN trace record
> with D_ID was already lost due to trace buffer wrap.
> 
> GS uses an open WKA port handle and ELS just a D_ID, and
> only for ELS we could get D_ID from QTCB bottom via zfcp_fsf_req.
> To cover both cases, add a new field to zfcp_fsf_ct_els
> and fill it in on request to use in SAN response trace.
> Strictly speaking the D_ID on SAN response is the FC frame's S_ID.
> We don't need a field for the other end which is always us.
> 
> Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
> Fixes: 2c55b750a884 ("[SCSI] zfcp: Redesign of the debug tracing for SAN records.")
> Fixes: 7c7dc196814b ("[SCSI] zfcp: Simplify handling of ct and els requests")
> Cc: <stable@vger.kernel.org> #2.6.38+
> Reviewed-by: Benjamin Block <bblock@linux.vnet.ibm.com>
> ---
>  drivers/s390/scsi/zfcp_dbf.c | 2 +-
>  drivers/s390/scsi/zfcp_fsf.c | 2 ++
>  drivers/s390/scsi/zfcp_fsf.h | 4 +++-
>  3 files changed, 6 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
