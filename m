From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] sg version 3.5.28 for lk 2.5.64
Date: Wed, 12 Mar 2003 22:54:01 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E6F2DE9.5010000@torque.net>
References: <3E6B405B.3010509@torque.net> <20030311142836.A22992@infradead.org> <20030311081838.A9661@beaverton.ibm.com> <20030311200927.A967@lst.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Tue, Mar 11, 2003 at 08:18:38AM -0800, Patrick Mansfield wrote:
> 
>>Is there a patch for putting the aic or all scsi_hosts into the
>>shost_devclass class, like scsi_debug.c does for itself?
> 
> 
> You're right!  This is the snipplet I missed when sending out the
> aic7xxx hotplug changes (+ the same for aic79xx):
> 
> 
> --- 1.7/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	Wed Feb 26 18:14:16 2003
> +++ edited/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	Tue Mar 11 19:13:02 2003
> @@ -75,10 +75,13 @@
>  MODULE_DEVICE_TABLE(pci, ahc_linux_pci_id_table);
>  
>  struct pci_driver aic7xxx_pci_driver = {
> -	name:		"aic7xxx",
> -	probe:		ahc_linux_pci_dev_probe,
> -	remove:		ahc_linux_pci_dev_remove,
> -	id_table:	ahc_linux_pci_id_table
> +	.name		= "aic7xxx",
> +	.probe		= ahc_linux_pci_dev_probe,
> +	.remove		= ahc_linux_pci_dev_remove,
> +	.id_table	= ahc_linux_pci_id_table,
> +	.driver		= {
> +		.devclass	= &shost_devclass,
> +	},
>  };
>  
>  static void

The movement of scsi host information from sg to sysfs
is starting to look like an experiment that has failed.

Doug Gilbert


