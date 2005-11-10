From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3]  qla2xxx: Add full firmware(-request) hotplug support for all ISPs.
Date: Thu, 10 Nov 2005 10:58:46 +0000
Message-ID: <20051110105846.GA9222@infradead.org>
References: <20051109234846.4868.25487.sendpatchset@andrew-vasquezs-powerbook-g4-15.local> <20051109234901.4868.27256.sendpatchset@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:4790 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750782AbVKJK6s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Nov 2005 05:58:48 -0500
Content-Disposition: inline
In-Reply-To: <20051109234901.4868.27256.sendpatchset@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

this patchkit looks good.  one thing we discussed and should go in ontop is a
scsi-wide option the firmware depends on, with
a clear deprecation date for the builtin firmware.  that way we can enforce
that all new drivers support request_firmware, but can have in-kernel firmware
for until that deprecation date.

> +config SCSI_QLA21XX
> +	tristate "  Build QLogic ISP2100 firmware-module"
> +	depends on SCSI_QLA2XXX_EMBEDDED_FIRMWARE
>  	---help---
>  	This driver supports the QLogic 21xx (ISP2100) host adapter family.

don't the help-text need some update?

> +#if defined(CONFIG_SCSI_QLA2XXX_EMBEDDED_FIRMWARE)
>  #if defined(CONFIG_SCSI_QLA21XX) || defined(CONFIG_SCSI_QLA21XX_MODULE)
>  #define IS_QLA2100(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2100)
>  #else
> @@ -79,9 +81,23 @@
>  #define IS_QLA2522(ha)	0
>  #endif
>  
> +#else	/* !defined(CONFIG_SCSI_QLA2XXX_EMBEDDED_FIRMWARE) */
> +
> +#define IS_QLA2100(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2100)

I'd say just use this else clause unconditionally.  no need to optimize for
the 1% users using the deprecated builtin-firmware and compile just for
a subsystet of the supported cards.

