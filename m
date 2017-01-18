From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 03/17] lpfc: NVME Initiator: Base modifications Part B
Date: Wed, 18 Jan 2017 11:11:12 +0100
Message-ID: <20170118101112.GC3514@linux-x5ow.site>
References: <587ec2ee.01djIfQsSlhQj6k1%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44986 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752203AbdARKZb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Jan 2017 05:25:31 -0500
Content-Disposition: inline
In-Reply-To: <587ec2ee.01djIfQsSlhQj6k1%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On Tue, Jan 17, 2017 at 05:20:46PM -0800, James Smart wrote:
> 
> NVME Initiator: Base modifications
> 
> This is part B of parts A..F.
> 
> Part B is limited to lpfc_attr.c: lpfc attribute modifications
> 
> *********
> 
> Refer to Part A for a description of base modifications
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---

[...]

> +	len += snprintf(buf + len, PAGE_SIZE - len,
> +			"%s%d WWPN x%llx WWNN x%llx DID x%06x %s\n",
> +			"NVME LPORT lpfc",

Is it the lack of coffee or should it be 
			"NVME LPORT lpfc%d WWPN x%llx WWNN x%llx DID x%06x %s\n"

I think you're doing it to not hit the 80 chars limit, but then there are
way more offenders than that one, so...


> +			phba->brd_no,
> +			wwn_to_u64(vport->fc_portname.u.wwn),
> +			wwn_to_u64(vport->fc_nodename.u.wwn),
> +			localport->port_id, statep);

[...]

> +int
> +lpfc_emptyq_wait(struct lpfc_hba *phba, struct list_head *q, spinlock_t *lock)
> +{
> +	int cnt = 0;
> +
> +	spin_lock_irq(lock);
> +	while (!list_empty(q)) {
> +		spin_unlock_irq(lock);
> +		msleep(20);
> +		if (cnt++ > 250) {  /* 5 secs */
> +			lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
> +					"0466 %s %s\n",
> +					"Outstanding IO when ",
> +					"bringing Adapter offline\n");
> +				return 0;
> +		}
> +		spin_lock_irq(lock);
> +	}
> +	spin_unlock_irq(lock);
> +	return 1;
> +}
> +

Aren't you using lpc_emptyq_wait() in patches prior to that already? This
breaks git bisect. Pleas test-build (ideally + checkpatch and sparse/smatch)
each patch in the series individually.

[...]

Thanks,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
