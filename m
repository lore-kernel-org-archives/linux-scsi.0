From: "Seymour, Shane M" <shane.seymour@hp.com>
Subject: RE: [PATCH RFC 1/2] cxlflash: Base support for IBM CXL Flash Adapter
Date: Thu, 2 Jul 2015 08:08:08 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB44430703@G9W0766.americas.hpqcorp.net>
References: <1430110220-13268-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t5009.houston.hp.com ([15.240.92.67]:40840 "EHLO
	g9t5009.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbbGBIJk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jul 2015 04:09:40 -0400
In-Reply-To: <1430110220-13268-1-git-send-email-mrochs@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>
Cc: "mikey@neuling.org" <mikey@neuling.org>, "imunsie@au1.ibm.com" <imunsie@au1.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Matthew R. Ochs
Sent: Monday, April 27, 2015 2:50 PM
To: linux-scsi@vger.kernel.org; James.Bottomley@HansenPartnership.com; nab@linux-iscsi.org; brking@linux.vnet.ibm.com
Cc: mikey@neuling.org; imunsie@au1.ibm.com; Manoj N. Kumar
Subject: [PATCH RFC 1/2] cxlflash: Base support for IBM CXL Flash Adapter

> +static ssize_t cxlflash_show_port_status(struct device *dev,
> +					 struct device_attribute *attr,
> +					 char *buf)
> +{
> +	struct Scsi_Host *shost = class_to_shost(dev);
> +	struct cxlflash *cxlflash = (struct cxlflash *)shost->hostdata;
> +	struct afu *afu = cxlflash->afu;
> +
> +	char *disp_status;
> +	int rc;
> +	u32 port;
> +	u64 status;
> +	volatile u64 *fc_regs;
> +
> +	rc = kstrtouint((attr->attr.name + 4), 10, &port);
> +	if (rc || (port > NUM_FC_PORTS))
> +		return 0;
> +
> +	fc_regs = &afu->afu_map->global.fc_regs[port][0];
> +	status =
> +	    (readq_be(&fc_regs[FC_MTIP_STATUS / 8]) & FC_MTIP_STATUS_MASK);
> +
> +	if (status == FC_MTIP_STATUS_ONLINE)
> +		disp_status = "online";
> +	else if (status == FC_MTIP_STATUS_OFFLINE)
> +		disp_status = "offline";
> +	else
> +		disp_status = "unknown";
> +
> +	return snprintf(buf, PAGE_SIZE, "%s\n", disp_status);

You need to use scnprintf() instead of snprintf() here

> +static ssize_t cxlflash_show_lun_mode(struct device *dev,
> +				      struct device_attribute *attr, char *buf)
> +{
> +	struct Scsi_Host *shost = class_to_shost(dev);
> +	struct cxlflash *cxlflash = (struct cxlflash *)shost->hostdata;
> +	struct afu *afu = cxlflash->afu;
> +
> +	return snprintf(buf, PAGE_SIZE, "%u\n", afu->internal_lun);

See above about snprintf()

+static DEVICE_ATTR(port0, S_IRUGO, cxlflash_show_port_status, NULL);
+static DEVICE_ATTR(port1, S_IRUGO, cxlflash_show_port_status, NULL);
+static DEVICE_ATTR(lun_mode, S_IRUGO | S_IWUSR, cxlflash_show_lun_mode,
+		   cxlflash_store_lun_mode);

Please use DEVICE_ATTR_RO and DEVICE_ATTR_RW as appropriate if you can, you will need to change the show/store function names. The main reason I know for doing this is (using DEVICE_ATTR_RO as an example) if someone sees a sysfs attribute called port0 or port1 they should be able to search the kernel source to find a function called port0_show or port1_show without having to spend any extra time searching to find out what the driver is and then look at the driver source to find that they need to look at cxlflash_show_port_status. Using DEVICE_ATTR_RO for port0 and port1 would probably change the code to looking something like this:

static ssize_t cxlflash_show_port_status(u32 port,
	struct afu *afu, char *buf)
{
	char *disp_status;
	u64 status;
	volatile u64 *fc_regs;

	fc_regs = &afu->afu_map->global.fc_regs[port][0];
	/* I split this line into two because I had to really look at where
	 * the brackets were and this made it more obvious to me
	 * what it was doing but that could just be me. */
	status = readq_be(&fc_regs[FC_MTIP_STATUS / 8]);
	status &= FC_MTIP_STATUS_MASK;

	if (status == FC_MTIP_STATUS_ONLINE)
		disp_status = "online";
	else if (status == FC_MTIP_STATUS_OFFLINE)
		disp_status = "offline";
	else
		disp_status = "unknown";

	return scnprintf(buf, PAGE_SIZE, "%s\n", disp_status);
}

Since you have fixed values you could use also sprintf here (although the documentation currently says to only use scnprintf) and that would make port0_show and port1_show to be:

static ssize_t port0_show(struct device *dev,
	struct device_attribute *attr,
	char *buf)
{
	struct Scsi_Host *shost = class_to_shost(dev);
	struct cxlflash *cxlflash = (struct cxlflash *)shost->hostdata;
	struct afu *afu = cxlflash->afu;

	return cxlflash_show_port_status(0, afu, buf);
}

static ssize_t port1_show(struct device *dev,
	struct device_attribute *attr,
	char *buf)
{
	struct Scsi_Host *shost = class_to_shost(dev);
	struct cxlflash *cxlflash = (struct cxlflash *)shost->hostdata;
	struct afu *afu = cxlflash->afu;

	return cxlflash_show_port_status(1, afu, buf);
}

I'm assuming that 0 and 1 are always valid for port number and don't need to be checked against NUM_FC_PORTS. That's just a suggestion and I haven't attempted to compile the above example and you'd need to test it to make sure that they still work as expected.

Shane
