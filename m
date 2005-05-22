From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] 2.6 aacraid: Add sysfs files for aacraid adapter information (re-diff)
Date: Sun, 22 May 2005 17:54:43 +0100
Message-ID: <20050522165443.GA31638@infradead.org>
References: <1116362098.5838.2.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:63195 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261830AbVEVQys (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 May 2005 12:54:48 -0400
Content-Disposition: inline
In-Reply-To: <1116362098.5838.2.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Tue, May 17, 2005 at 01:34:57PM -0700, Mark Haverkamp wrote:
> Re-send of the patch diffed against the latest scsi-misc-2.6 git tree.
> 
> This patch adds some files into the /sys/class/scsi_host/hostN
> directories for aacraid adapters.  The file names are pretty much self-
> explanitory:
> 
> aac_driver_version: Driver version and date
> aac_bios_version: Adapter's bios version
> aac_kernel_version: Adapter's kernel version
> aac_monitor_version: Adapter's monitor version
> aac_model: Adapter's model name/number
> aac_serial_number: Adapter's serial number

Can you remove all those aac_ prefixes?

> +static ssize_t aac_show_host_version(struct class_device *class_dev,
> +		char *buf)
> +{
> +	int len;
> +
> +	len = snprintf(buf, PAGE_SIZE, "Adaptec Raid Controller: %s %s\n",
> +		  AAC_DRIVER_VERSION,
> +		  AAC_DRIVER_BUILD_DATE);
> +	return len;
> +}

the "Adaptec Raid Controller:" doesn't belong in here.  The driver build
data and version neither, use MODULE_VERSION instead.

> +
> +static ssize_t aac_show_model(struct class_device *class_dev,
> +		char *buf)
> +{
> +	struct aac_dev *dev = (struct aac_dev*)class_to_shost(class_dev)->hostdata;

No need to cast.

> +	int len;
> +
> +	len = snprintf(buf, PAGE_SIZE, "Vendor: %s Model: %s\n",
> +		  aac_drivers[dev->cardtype].vname,
> +		  aac_drivers[dev->cardtype].model);
> +	return len;

please use two different attributes and remove the prefix.

> +static ssize_t aac_show_kernel_version(struct class_device *class_dev,
> +		char *buf)
> +{
> +	struct aac_dev *dev = (struct aac_dev*)class_to_shost(class_dev)->hostdata;
> +	int len, tmp;
> +
> +	tmp = le32_to_cpu(dev->adapter_info.kernelrev);
> +	len = snprintf(buf, PAGE_SIZE, "kernel: %d.%d-%d[%d]\n", 
> +	  tmp >> 24, (tmp >> 16) & 0xff, tmp & 0xff,
> +	  le32_to_cpu(dev->adapter_info.kernelbuild));
> +	return len;
> +}

Again please remove the prefix.  Also what does kernel version mean in
this context?

> +static ssize_t aac_show_monitor_version(struct class_device *class_dev,
> +		char *buf)
> +{
> +	struct aac_dev *dev = (struct aac_dev*)class_to_shost(class_dev)->hostdata;
> +	int len, tmp;
> +
> +	tmp = le32_to_cpu(dev->adapter_info.monitorrev);
> +	len = snprintf(buf, PAGE_SIZE, "monitor: %d.%d-%d[%d]\n", 
> +	  tmp >> 24, (tmp >> 16) & 0xff, tmp & 0xff,
> +	  le32_to_cpu(dev->adapter_info.monitorbuild));
> +	return len;

Again no prefix please.

> +}
> +
> +static ssize_t aac_show_bios_version(struct class_device *class_dev,
> +		char *buf)
> +{
> +	struct aac_dev *dev = (struct aac_dev*)class_to_shost(class_dev)->hostdata;
> +	int len, tmp;
> +
> +	tmp = le32_to_cpu(dev->adapter_info.biosrev);
> +	len = snprintf(buf, PAGE_SIZE, "bios: %d.%d-%d[%d]\n", 
> +	  tmp >> 24, (tmp >> 16) & 0xff, tmp & 0xff,
> +	  le32_to_cpu(dev->adapter_info.biosbuild));
> +	return len;
> +}

dito

> +
> +static ssize_t aac_show_serial_number(struct class_device *class_dev,
> +		char *buf)
> +{
> +	struct aac_dev *dev = (struct aac_dev*)class_to_shost(class_dev)->hostdata;
> +	int len = 0;
> +
> +	if (le32_to_cpu(dev->adapter_info.serial[0]) != 0xBAD0)
> +		len = snprintf(buf, PAGE_SIZE, "serial: %x\n",
> +		  le32_to_cpu(dev->adapter_info.serial[0]));
> +	return len;
> +}

dito

