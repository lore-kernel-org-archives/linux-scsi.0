From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v3 2/4] mpt3sas: Fix for Crusader to achieve product
 targets with SAS devices.
Date: Tue, 24 Jan 2017 13:02:38 +0100
Message-ID: <20170124120238.GB3609@linux-x5ow.site>
References: <1485165370-43401-1-git-send-email-chaitra.basappa@broadcom.com>
 <1485165370-43401-3-git-send-email-chaitra.basappa@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1485165370-43401-3-git-send-email-chaitra.basappa@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chaitra P B <chaitra.basappa@broadcom.com>
Cc: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, sreekanth.reddy@broadcom.com
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 23, 2017 at 03:26:08PM +0530, Chaitra P B wrote:
> Small glitch/degraded performance in Crusader is improved with SAS
> drives by removing unnecessary spinlocks while clearing scsi command
> in drivers internal lookup table.
> 
> Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
> Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c  |    1 +
>  drivers/scsi/mpt3sas/mpt3sas_base.h  |    1 +
>  drivers/scsi/mpt3sas/mpt3sas_ctl.c   |    4 +++-
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c |   31 ++++++++++++++++++++++++++++---
>  4 files changed, 33 insertions(+), 4 deletions(-)

[...]

> + * __scsih_scsi_lookup_get_clear - returns scmd entry without
> + *						holding any lock.
> + * @ioc: per adapter object
> + * @smid: system request message index
> + *
> + * Returns the smid stored scmd pointer.
> + * Then will dereference the stored scmd pointer.
> + */
> +static inline struct scsi_cmnd *
> +__scsih_scsi_lookup_get_clear(struct MPT3SAS_ADAPTER *ioc,
> +		u16 smid)
> +{
> +	struct scsi_cmnd *scmd = NULL;
> +
> +	swap(scmd, ioc->scsi_lookup[smid - 1].scmd);
> +
> +	return scmd;
> +}
> +
> +/**
>   * _scsih_scsi_lookup_get_clear - returns scmd entry

That's only 50% of what I've meant:

static inline struct scsi_cmnd *
_scsih_scsi_lookup_get_clear(struct MPT3SAS_ADAPTER *ioc, u16 smid)
{
	unsigned long flags;
	struct scsi_cmnd *scmnd;

	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	scmd = ioc->scsi_lookup[smid - 1].scmd;
-	ioc->scsi_lookup[smid - 1].scmd = NULL;
+	scmnd = __scsih_scsi_lookup_get_clear(ioc, smid);
	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);

	return scmnd;
}


[...]

Byte,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
