From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] add spi attributes to qla1280
Date: Wed, 11 Aug 2004 08:11:18 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040811081118.A26256@infradead.org>
References: <20040810230552.GA26569@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:26894 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267850AbUHKHLU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Aug 2004 03:11:20 -0400
Content-Disposition: inline
In-Reply-To: <20040810230552.GA26569@sgi.com>; from jeremy@sgi.com on Tue, Aug 10, 2004 at 04:05:52PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: linux-scsi@vger.kernel.org

> +	if (ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP12160 ||
> +	    ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP10160)
> +		is1x160 = 1;
> +	else
> +		is1x160 = 0;

The driver in James' tree has most of my 1040-support patches merged,
sp please use the apporpinquate IS_ISP* macros like the rest of the drivers
does, and please handle the 1040 aswell in that code.

> +static struct scsi_transport_template *qla1280_transport_template = NULL;

No need to initialize to NULL here.

>  static int __devinit
>  qla1280_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
>  {
> @@ -4758,6 +4778,7 @@
>  	host->max_id = MAX_TARGETS;
>  	host->max_sectors = 1024;
>  	host->unique_id = host->host_no;
> +	host->transportt = qla1280_transport_template;
>  
>  #if LINUX_VERSION_CODE < 0x020545
>  	host->select_queue_depths = qla1280_select_queue_depth;
> @@ -4890,6 +4911,12 @@
>  	.remove		= __devexit_p(qla1280_remove_one),
>  };
>  
> +static struct spi_function_template qla1280_transport_functions = {
> +	.show_period = 1,
> +	.show_offset = 1,
> +};

Any chance you could declare this just below the host template?  that keeps
the code better organized.

