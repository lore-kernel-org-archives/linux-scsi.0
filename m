From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: [PATCH 2.6.12-rc4-mm1 4/4] megaraid_sas: updating the driver
Date: Mon, 16 May 2005 15:55:16 +0100
Message-ID: <20050516145516.GB25156@infradead.org>
References: <0E3FA95632D6D047BA649F95DAB60E57060CCE7D@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:943 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261676AbVEPOzU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2005 10:55:20 -0400
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57060CCE7D@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'Matt_Domsch@Dell.com'" <Matt_Domsch@Dell.com>, Andrew Morton <akpm@osdl.org>, 'Christoph Hellwig' <hch@infradead.org>, 'James Bottomley' <James.Bottomley@SteelEye.com>

On Mon, May 16, 2005 at 02:59:44AM -0400, Bagalkote, Sreenivas wrote:
> +#include <linux/ioctl32.h>

this isn't needed in any driver these days.

> +/*
> + * All MFI register set macros accept megasas_register_set*
> + */
> +#define RD_OB_MSG_0(regs)	readl((void*)(&(regs)->outbound_msg_0))
> +#define WR_IN_MSG_0(v, regs)	writel((v),(void*)(&(regs)->inbound_msg_0))
> +#define WR_IN_DOORBELL(v, regs)
> writel((v),(void*)(&(regs)->inbound_doorbell))
> +#define WR_IN_QPORT(v, regs)
> writel((v),(void*)(&(regs)->inbound_queue_port))
> +
> +#define RD_OB_INTR_STATUS(regs)
> readl((void*)(&(regs)->outbound_intr_status))
> +#define WR_OB_INTR_STATUS(v, regs)
> writel((v),(&(regs)->outbound_intr_status))

The void * casats are not okay.  Please make sure all your variable
holding the I/O address are of type void __iomem * and use sparse to check
it.  I would have sent you sparse output if your mailer didn't mangle
the patch so it couldn't be applied..

Also the driver might be a lot more readable if you just removed this
macros.

> +#define SCP2HOST(scp)		(scp)->device->host	// to host
> +#define SCP2HOSTDATA(scp)	SCP2HOST(scp)->hostdata	// to soft state
> +#define SCP2CHANNEL(scp)	(scp)->device->channel	// to channel
> +#define SCP2TARGET(scp)		(scp)->device->id	// to target
> +#define SCP2LUN(scp)		(scp)->device->lun	// to LUN

Please remove all these macros.

> +#define SCSIHOST2ADAP(host)	(((caddr_t *)(host->hostdata))[0])
> +#define SCP2ADAPTER(scp)	(struct
> megasas_instance*)SCSIHOST2ADAP(SCP2HOST(scp))

please don't use caddr_t.


Also I can't find any endianess handling.  You should probably declare
all hardware structures __le* and use proper le*_to_cpu/cpu_to_le* when
accessing them.  sparse -Wbitwise helps finding errors in endianess handling
