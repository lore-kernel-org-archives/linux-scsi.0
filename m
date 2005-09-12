From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH 5/8] aacraid: error return checking
Date: Mon, 12 Sep 2005 07:19:56 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F01919BC0@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:49376 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1750742AbVILLUC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Sep 2005 07:20:02 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Christoph Hellwig [mailto:hch@infradead.org] writes:
>> @@ -929,9 +932,14 @@
>>  	printk(KERN_INFO "Adaptec %s driver (%s)\n",
>>  	  AAC_DRIVERNAME, aac_driver_version);
>>  
>> -	error = pci_module_init(&aac_pci_driver);
>> -	if (error)
>> +	error = pci_register_driver(&aac_pci_driver);
>> +	if (error < 0 || list_empty(&aac_devices)) {
>> +		if (error >= 0) {
>> +			pci_unregister_driver(&aac_pci_driver);
>> +			error = -ENODEV;
>> +		}
>>  		return error;
>The list_empty check is wrong.  I driver should stay loaded even if no
devices have been found.

We get complains about a driver module loaded with no associated
hardware. There are system configurations that probe for installed
hardware by loading modules, they expect only the functional driver
modules to load. What purpose is there in a driver module that is loaded
with no hardware?

Sincerely -- Mark Salyzyn

