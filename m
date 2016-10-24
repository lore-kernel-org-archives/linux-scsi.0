From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH 1/1] libfc: don't have fc_exch_find log errors on a new
 exchange
Date: Mon, 24 Oct 2016 09:35:48 -0400
Message-ID: <1477316148.17595.5.camel@localhost.localdomain>
References: <1477084253-1742-1-git-send-email-cleech@redhat.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32870 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934306AbcJXNft (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Oct 2016 09:35:49 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 30AAF2DC34C
        for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2016 13:35:49 +0000 (UTC)
In-Reply-To: <1477084253-1742-1-git-send-email-cleech@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Leech <cleech@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2016-10-21 at 14:10 -0700, Chris Leech wrote:
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

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


