From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: [RFC PATCH 2.6.9-rc2] Add sysfs queue depth override to qla2xxx
Date: Tue, 28 Sep 2004 09:52:55 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0012AD92B@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch01.qlogic.com ([198.70.193.200]:55696 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S267985AbUI1QxH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 12:53:07 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>, linux-scsi@vger.kernel.org
Cc: James.Bottomley@steeleye.com

On Tuesday, September 28, 2004 12:54 AM, Jeremy Higdon wrote:
> +static ssize_t
> +qla2xxx_store_queue_depth(struct device *dev, const char *buf,
> size_t count) +{
> +	int			 depth;
> +	struct scsi_device	*sdev = to_scsi_device(dev);
> +
> +	if (sdev->tagged_supported) {
> +		depth = simple_strtoul(buf, NULL, 0);
> +		if (depth > ql2xmaxqdepth)
> +			depth = ql2xmaxqdepth;

Any particular reason why the ql2xmaxqdepth module-parameter is
being used as a high-water limit?  The module-param is (was) used 
as a global setting of queue-depth for all luns (quite inflexible).
By overriding:

	/sys/class/scsi_device/22:0:0:0/device/queue_depth

with a writable value, a user should be allowed to update the
value to something higher (max(unsigned short)?) based on the 
back-end storage.

--
Andrew
