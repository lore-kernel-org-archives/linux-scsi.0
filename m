From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH/RFC 2/2] 3ware 9000 SATA-RAID driver
Date: Sun, 23 May 2004 13:02:48 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040523110248.GB10790@lst.de>
References: <HY4ODS03.B9L@hadar.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:63638 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262574AbUEWLCx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 May 2004 07:02:53 -0400
Content-Disposition: inline
In-Reply-To: <HY4ODS03.B9L@hadar.amcc.com>
List-Id: linux-scsi@vger.kernel.org
To: Adam Radford <aradford@amcc.com>
Cc: linux-scsi@vger.kernel.org

> +#include <linux/version.h>

what do you need this one for?

> +#define TW_VENDOR_ID (0x13C1)	/* 3ware */
> +#define TW_DEVICE_ID_9000 (0x1002)  /* 9000 series controller */

Should be in include/linux/pci_ids.h
 
> +/* Function prototypes */
> +static int twa_aen_complete(TW_Device_Extension *tw_dev, int request_id);
> +static int twa_aen_drain_queue(TW_Device_Extension *tw_dev, int check_reset);
> +static void twa_aen_queue_event(TW_Device_Extension *tw_dev, TW_Command_Apache_Header *header);

please don't put prototypes into a header if they're used only in a
single file.  try to reorder the .c file that additiona prototype
declarations aren't needed as much as possible and put everything else
in the .c file.

