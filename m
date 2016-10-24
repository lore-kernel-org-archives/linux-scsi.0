From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/1] libfc: don't have fc_exch_find log errors on a new
 exchange
Date: Mon, 24 Oct 2016 16:37:59 +0200
Message-ID: <c31a1481-75d0-a350-2ef5-1910e9270691@suse.de>
References: <1477084253-1742-1-git-send-email-cleech@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54608 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754975AbcJXOiC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Oct 2016 10:38:02 -0400
In-Reply-To: <1477084253-1742-1-git-send-email-cleech@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Leech <cleech@redhat.com>, linux-scsi@vger.kernel.org

On 10/21/2016 11:10 PM, Chris Leech wrote:
> With the error message I added in "libfc: sanity check cpu number
> extracted from xid" I didn't account for the fact that fc_exch_find is
> called with FC_XID_UNKNOWN at the start of a new exchange if we are the
> responder.
>
> It doesn't come up with the initiator much, but that's basically every
> exchange for a target.  By checking the xid for FC_XID_UNKNOWN first, we
> not only prevent the erroneous error message, but skip the unnecessary
> lookup attempt as well.
>
> Signed-off-by: Chris Leech <cleech@redhat.com>
> ---
>  drivers/scsi/libfc/fc_exch.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
> index 16ca31a..42cc403 100644
> --- a/drivers/scsi/libfc/fc_exch.c
> +++ b/drivers/scsi/libfc/fc_exch.c
> @@ -910,6 +910,9 @@ static struct fc_exch *fc_exch_find(struct fc_exch_mgr *mp, u16 xid)
>  	struct fc_exch *ep = NULL;
>  	u16 cpu = xid & fc_cpu_mask;
>
> +	if (xid == FC_XID_UNKNOWN)
> +		return NULL;
> +
>  	if (cpu >= nr_cpu_ids || !cpu_possible(cpu)) {
>  		printk_ratelimited(KERN_ERR
>  			"libfc: lookup request for XID = %d, "
>
Does that still apply with my libfc patchset?
I was under the impression I've fixed it already ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
