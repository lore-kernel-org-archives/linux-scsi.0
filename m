From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] 2.6 aacraid: Add sysfs files for aacraid adapter information (re-diff)
Date: Mon, 23 May 2005 07:56:58 -0400
Message-ID: <60807403EABEB443939A5A7AA8A7458B0132B6EC@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:39096 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261249AbVEWL5C convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 May 2005 07:57:02 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Christoph Hellwig [mailto:hch@infradead.org] writes:

>> +static ssize_t aac_show_kernel_version(struct class_device
*class_dev,
>> +		char *buf)
>> +{
>> +	struct aac_dev *dev = (struct
aac_dev*)class_to_shost(class_dev)->>hostdata;
>> +	int len, tmp;
>> +
>> +	tmp = le32_to_cpu(dev->adapter_info.kernelrev);
>> +	len = snprintf(buf, PAGE_SIZE, "kernel: %d.%d-%d[%d]\n", 
>> +	  tmp >> 24, (tmp >> 16) & 0xff, tmp & 0xff,
>> +	  le32_to_cpu(dev->adapter_info.kernelbuild));
>> +	return len;
>> +}

>Again please remove the prefix.  Also what does kernel version mean in
>this context?

This is the kernel running in the Firmware of the Adapter.

I would be concerned about "kernel_version" confusion in the namespace
of the /sys/ filesystem. Dropping the prefix is not an issue, but do we
have documented naming standards for driver & firmware specific details?

-- Mark Salyzyn
