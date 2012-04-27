From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 5/6] qla4xxx: Capture minidump for ISP82XX on firmware
 failure
Date: Fri, 27 Apr 2012 11:05:15 -0500
Message-ID: <4F9AC3BB.2050708@cs.wisc.edu>
References: <1335245557-17169-1-git-send-email-vikas.chaudhary@qlogic.com> <1335245557-17169-6-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:49763 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758382Ab2D0QFY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Apr 2012 12:05:24 -0400
In-Reply-To: <1335245557-17169-6-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Tej Parkash <tej.parkash@qlogic.com>, Shyam Sundar <shyam.sundar@qlogic.com>

On 04/24/2012 12:32 AM, vikas.chaudhary@qlogic.com wrote:
> +
> +static ssize_t
> +qla4_8xxx_sysfs_write_fw_dump(struct file *filep, struct kobject *kobj,
> +			      struct bin_attribute *ba, char *buf, loff_t off,
> +			      size_t count)
> +{
> +	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
> +					       struct device, kobj)));
> +	uint32_t dev_state;
> +	int reading;
> +
> +	if (!is_qla8022(ha))
> +		return -EINVAL;
> +
> +	if (off != 0)
> +		return 0;
> +
> +	reading = simple_strtol(buf, NULL, 10);

I think we are supposed to be using kstrtol now.

