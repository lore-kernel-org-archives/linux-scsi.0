From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: [PATCH 3/8] scsi: megaraid_sas - add module param max_sectors, cmd_per_lun
Date: Tue, 6 Nov 2007 12:06:39 -0700
Message-ID: <9738BCBE884FDB42801FAD8A7769C26501CA1BB4@NAMAIL1.ad.lsil.com>
References: <20071030173858.GB16455@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:39708 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753750AbXKFTGy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Nov 2007 14:06:54 -0500
Content-class: urn:content-classes:message
In-Reply-To: <20071030173858.GB16455@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, akpm@osdl.org, linux-kernel@vger.kernel.org, "Patro, Sumant" <Sumant.Patro@lsi.com>

Re-Sending:

Christoph,

Here are the clarification for the design to implement the fast_load,
cmd_per_lun and max_sectors:

The fast_load parameter is for the user to decide at driver load time if
(s)he wants to skip scan of devices in PD channels. 
After driver is loaded the user cannot be permitted to modify this
value. If the user needs to see the devices in the PD channels, (s)he
may initiate a scan via sysfs/proc based on the kernel being used. Once
the user has done the scan, the fast_load value does not have any
significance and thus not exposed for reading.

cmd_per_lun & max_sectors are also intended to be provided by user only
at driver load time. In the current implementation both these do appear
as read-only values under host# in sysfs. The current design is not to
allow these values to be modified on the fly. 

Regards,

Bo Yang 

-----Original Message-----
From: Yang, Bo 
Sent: Wednesday, October 31, 2007 10:14 AM
To: Christoph Hellwig
Cc: linux-scsi@vger.kernel.org; James.Bottomley@SteelEye.com;
akpm@osdl.org; linux-kernel@vger.kernel.org; Patro, Sumant; Kolli, Neela
Subject: RE: [PATCH 3/8] scsi: megaraid_sas - add module param
max_sectors, cmd_per_lun


Christoph,

Here are the clarification for the design to implement the fast_load,
cmd_per_lun and max_sectors:

The fast_load parameter is for the user to decide at driver load time if
(s)he wants to skip scan of devices in PD channels. 
After driver is loaded the user cannot be permitted to modify this
value. If the user needs to see the devices in the PD channels, (s)he
may initiate a scan via sysfs/proc based on the kernel being used. Once
the user has done the scan, the fast_load value does not have any
significance and thus not exposed for reading.

cmd_per_lun & max_sectors are also intended to be provided by user only
at driver load time. In the current implementation both these do appear
as read-only values under host# in sysfs. The current design is not to
allow these values to be modified on the fly. 

Regards,

Bo Yang 

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 
Sent: Tuesday, October 30, 2007 1:39 PM
To: Yang, Bo
Cc: linux-scsi@vger.kernel.org; James.Bottomley@SteelEye.com;
akpm@osdl.org; linux-kernel@vger.kernel.org; Patro, Sumant
Subject: Re: [PATCH 3/8] scsi: megaraid_sas - add module param
max_sectors, cmd_per_lun

On Mon, Oct 01, 2007 at 11:51:48AM -0400, bo yang wrote:
> +/*
> + * Number of sectors per IO command will be set in megasas_init_mfi
> + * if user does not provide
> + */
> +static unsigned int max_sectors;
> +module_param_named(max_sectors, max_sectors, int, 0); 
> +MODULE_PARM_DESC(max_sectors,
> +	"Maximum number of sectors per IO command");
> +
> +/*
> + * Number of cmds per logical unit
> + */
> +static unsigned int cmd_per_lun = MEGASAS_DEFAULT_CMD_PER_LUN; 
> +module_param_named(cmd_per_lun, cmd_per_lun, int, 0); 
> +MODULE_PARM_DESC(cmd_per_lun,
> +	"Maximum number of commands per logical unit (default=128)");

I don't think this should be in drivers.  cmd_per_lun is a scsi_host
attribute already and you should change the mid-layer to add an optional
host template method that allows the sysfs file to be writeable.
max_sectors should be handled similar although we don't seem to have an
attribute for it yet (maybe the block layer does?)

