From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/11]  qla2xxx: Add ISP24xx definitions.
Date: Tue, 14 Jun 2005 22:50:30 +0100
Message-ID: <20050614215030.GA5849@infradead.org>
References: <20050614053136.12127.506.sendpatchset@plap.qlogic.com> <20050614053141.12127.35841.sendpatchset@plap.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:36819 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261359AbVFNVue (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jun 2005 17:50:34 -0400
Content-Disposition: inline
In-Reply-To: <20050614053141.12127.35841.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -62,6 +62,22 @@
>  #define PCI_DEVICE_ID_QLOGIC_ISP6322	0x6322
>  #endif
>  
> +#ifndef PCI_DEVICE_ID_QLOGIC_ISP2422
> +#define PCI_DEVICE_ID_QLOGIC_ISP2422	0x2422
> +#endif
> +
> +#ifndef PCI_DEVICE_ID_QLOGIC_ISP2432
> +#define PCI_DEVICE_ID_QLOGIC_ISP2432	0x2432
> +#endif
> +
> +#ifndef PCI_DEVICE_ID_QLOGIC_ISP2512
> +#define PCI_DEVICE_ID_QLOGIC_ISP2512	0x2512
> +#endif
> +
> +#ifndef PCI_DEVICE_ID_QLOGIC_ISP2522
> +#define PCI_DEVICE_ID_QLOGIC_ISP2522	0x2522
> +#endif

It's only an historic accident that the older ids are in here, care
to remove all and move them to pci_ids.h instead?

> +	int		(*start_scsi)(srb_t *);

umm, that's most of ->queuecommand, isn't it?  Shouldn't you define
a separate scsi_host_template for 24xx/25xx?

> +//ISP24xx

please try to avoid C++-style comments

> +	volatile uint16_t mailbox0;
> +	volatile uint16_t mailbox1;
> +	volatile uint16_t mailbox2;

never use volatile, always use proper kernel primitives to access
hardware or atomic_t for atomic in-kernel variables.

