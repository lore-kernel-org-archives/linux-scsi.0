From: Christoph Hellwig <hch@infradead.org>
Subject: Re: PATCH [2/8] scsi: megaraid_sas - add module param fast_load
Date: Tue, 30 Oct 2007 17:36:45 +0000
Message-ID: <20071030173645.GA16455@infradead.org>
References: <1191253611.5850.8.camel@dhcp-75-534.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:51324 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbXJ3Rgs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Oct 2007 13:36:48 -0400
Content-Disposition: inline
In-Reply-To: <1191253611.5850.8.camel@dhcp-75-534.se.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bo yang <bo.yang@lsi.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, akpm@osdl.org, linux-kernel@vger.kernel.org, Sumant.patro@lsi.com

On Mon, Oct 01, 2007 at 11:46:51AM -0400, bo yang wrote:
> +/*
> + * Fast driver load option, skip scanning for physical devices during
> + * load.  This would result in physical devices being skipped during
> + * driver load time. These can be later added though,
> + * using /proc/scsi/scsi
> + */

/proc/scsi/scsi is deprecated, so please don't recommend it here.
The proper way is the scan attribute of the scsi host.

> +static unsigned int fast_load;
> +module_param_named(fast_load, fast_load, int, 0);
> +MODULE_PARM_DESC(fast_load,
> +	"megasas: Faster loading of the driver, skips physical devices! "\
> +	"(default = 0)");

This should show up in sysfs.

> +static struct megasas_instance *megasas_lookup_instance(u16 host_no)
> +{
> +	int i;
> +
> +	for (i = 0; i < megasas_mgmt_info.max_index; i++) {
> +		if ((megasas_mgmt_info.instance[i]) &&
> +			(megasas_mgmt_info.instance[i]->host->host_no
> +			== host_no))

no need for the braces here.  This should be:

		if (megasas_mgmt_info.instance[i] &&
		    megasas_mgmt_info.instance[i]->host->host_no == host_no)

> +static int megasas_slave_alloc(struct scsi_device *sdev)
> +{
> +	struct megasas_instance *instance;
> +	int tmp_fastload = fast_load;
> +
> +	instance = megasas_lookup_instance(sdev->host->host_no);
> +
> +	if (tmp_fastload && sdev->channel < MEGASAS_MAX_PD_CHANNELS) {
> +		if ((sdev->id == MEGASAS_MAX_DEV_PER_CHANNEL -1) &&
> +			(sdev->channel == MEGASAS_MAX_PD_CHANNELS - 1)) {
> +
> +		/*
> +		 * If fast load option was set and scan for last device is
> +		 * over, reset the fast_load flag so that during a possible
> +		 * next scan, devices can be made available
> +		 */
> +			fast_load = 0;
> +		}
> +		return -ENXIO;
> +	}
> +
> +	return 0;
> +}

This is a rather complicated and fragile way to implement this feature.

I'd recomment to change the call to scsi_scan_host in megasas_io_attach
to something like:

	if (fast_load) {
		int channel;

		for (channel = 0; channel < MEGASAS_MAX_PD_CHANNELS;
		     channel++) {
			scsi_scan_host_selected(host, channel, SCAN_WILD_CARD,
						SCAN_WILD_CARD, 0);
		}
	} else {
		scsi_scan_host(host);
	}

