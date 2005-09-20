From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH 1/7] aacraid: Greater than 2TB capacity support
Date: Tue, 20 Sep 2005 16:37:16 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F019B0BDC@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:42723 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S965116AbVITUhR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Sep 2005 16:37:17 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

From: Christoph Hellwig [mailto:hch@infradead.org] sez:

>> -
>> +			if (scsicmd->request->rq_disk)
>> +				strlcpy(fsa_dev_ptr[cid].devname,
>> +				scsicmd->request->rq_disk->disk_name,
>> +			  	min(sizeof(fsa_dev_ptr[cid].devname),
>> +
sizeof(scsicmd->request->rq_disk->disk_name) + 1));
>
>do we really need this?  A driver really shouldn't look at ->rq_disk

This is not changing the code, it is in all versions of the driver. It
is merely replacing a constant (8) with a sizeof operator. This code is
in support of an existing ioctl used by the management software to track
the naming of the devices. Removing this will break the management
software.

-- Mark

