From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: PATCH [2/8] scsi: megaraid_sas - add module param fast_load
Date: Tue, 6 Nov 2007 12:04:31 -0700
Message-ID: <9738BCBE884FDB42801FAD8A7769C26501CA1BB0@NAMAIL1.ad.lsil.com>
References: <20071030173645.GA16455@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:39540 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045AbXKFTFD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Nov 2007 14:05:03 -0500
Content-class: urn:content-classes:message
In-Reply-To: <20071030173645.GA16455@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, akpm@osdl.org, linux-kernel@vger.kernel.org


Re-Sending:

Christoph,

The e-mail I sent out on Oct. 31st was bounced back, I re-send it again.
 
I see that scsi_scan_host_selected is in scsi_priv.h and currently is
not used by any other driver. The scsi_priv.h is not part of the include
dir (/include/scsi). One of the major Linux distro's don't even include
this file in /usr/src/kernels. Also it looks like at this time this
function may not be available (not exported?) for driver modules to use.
Even if I include scsi_priv.h I get "unknown symbol" for this function
while loading.
May be in the long run we can solve all these issues to call
scsi_scan_host_selected. However, the current implementation works fine
and has been tested by LSI and others. This implementation doesn't break
any protocol nor does it adversely affect any driver functionality.

In a future update soon I will modify the comment on proc/scsi and
remove the extra braces you have pointed out. Please accept the current
implementation/patches. 

Regards, 
 
Bo Yang
------------------------------------------------------------------------
------------------------ 
From: Yang, Bo 
Sent: Wednesday, October 31, 2007 9:46 AM
To: Christoph Hellwig
Cc: linux-scsi@vger.kernel.org; James.Bottomley@SteelEye.com;
akpm@osdl.org; linux-kernel@vger.kernel.org; Patro, Sumant; Kolli, Neela
Subject: RE: PATCH [2/8] scsi: megaraid_sas - add module param fast_load


Christoph,

I see that scsi_scan_host_selected is in scsi_priv.h and currently is
not used by any other driver. The scsi_priv.h is not part of the include
dir (/include/scsi). One of the major Linux distro's don't even include
this file in /usr/src/kernels. Also it looks like at this time this
function may not be available (not exported?) for driver modules to use.
Even if I include scsi_priv.h I get "unknown symbol" for this function
while loading.
May be in the long run we can solve all these issues to call
scsi_scan_host_selected. However, the current implementation works fine
and has been tested by LSI and others. This implementation doesn't break
any protocol nor does it adversely affect any driver functionality.

In a future update soon I will modify the comment on proc/scsi and
remove the extra braces you have pointed out. Please accept the current
implementation/patches. 

Regards, 

Bo Yang

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 
Sent: Tuesday, October 30, 2007 1:37 PM
To: Yang, Bo
Cc: linux-scsi@vger.kernel.org; James.Bottomley@SteelEye.com;
akpm@osdl.org; linux-kernel@vger.kernel.org; Patro, Sumant
Subject: Re: PATCH [2/8] scsi: megaraid_sas - add module param fast_load

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
> +	"megasas: Faster loading of the driver, skips physical devices!
"\
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
		    megasas_mgmt_info.instance[i]->host->host_no ==
host_no)

> +static int megasas_slave_alloc(struct scsi_device *sdev) {
> +	struct megasas_instance *instance;
> +	int tmp_fastload = fast_load;
> +
> +	instance = megasas_lookup_instance(sdev->host->host_no);
> +
> +	if (tmp_fastload && sdev->channel < MEGASAS_MAX_PD_CHANNELS) {
> +		if ((sdev->id == MEGASAS_MAX_DEV_PER_CHANNEL -1) &&
> +			(sdev->channel == MEGASAS_MAX_PD_CHANNELS - 1))
{
> +
> +		/*
> +		 * If fast load option was set and scan for last device
is
> +		 * over, reset the fast_load flag so that during a
possible
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
			scsi_scan_host_selected(host, channel,
SCAN_WILD_CARD,
						SCAN_WILD_CARD, 0);
		}
	} else {
		scsi_scan_host(host);
	}

