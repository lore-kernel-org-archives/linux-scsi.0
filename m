From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: memcpy_toio/memcpy_fromio 64 bit safe?
Date: Wed, 16 Mar 2005 15:08:13 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458BED2483@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Received: from magic.adaptec.com ([216.52.22.17]:32965 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262778AbVCPUIQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Mar 2005 15:08:16 -0500
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id j2GK8Fr21394
	for <linux-scsi@vger.kernel.org>; Wed, 16 Mar 2005 12:08:15 -0800
Received: from otce2k01.adaptec.com (otce2k01.adaptec.com [10.12.1.83])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id j2GK8FD26330
	for <linux-scsi@vger.kernel.org>; Wed, 16 Mar 2005 12:08:15 -0800
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The dpt_i2o driver uses the function memcpy_toio to copy the message
frame to the adapter. Under arch/x86_64/lib/io.c, it's helper function
is defined as:

void __memcpy_toio(unsigned long dst,const void*src,unsigned len)
{
        __inline_memcpy((void *) dst,src,len);
}

The first argument should be 'volatile void __iomem * dst' I would have
expected. As such, the 64 bit virtual address representing the adapter
address passed in gets truncated (please correct me if I am wrong).

The writel and readl function do not have any similar problems.

Sincerely -- Mark Salyzyn
