From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/8] scsi: megaraid_sas - add module param max_sectors, cmd_per_lun
Date: Tue, 30 Oct 2007 17:38:58 +0000
Message-ID: <20071030173858.GB16455@infradead.org>
References: <1191253908.5850.12.camel@dhcp-75-534.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:36837 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbXJ3Ri7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Oct 2007 13:38:59 -0400
Content-Disposition: inline
In-Reply-To: <1191253908.5850.12.camel@dhcp-75-534.se.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bo yang <bo.yang@lsi.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, akpm@osdl.org, linux-kernel@vger.kernel.org, Sumant.patro@lsi.com

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
attribute already and you should change the mid-layer to add an
optional host template method that allows the sysfs file to be writeable.
max_sectors should be handled similar although we don't seem to have
an attribute for it yet (maybe the block layer does?)

