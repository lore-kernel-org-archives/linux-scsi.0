From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] 2.6.9 aacraid: aac_count fix
Date: Wed, 15 Sep 2004 13:43:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <60807403EABEB443939A5A7AA8A7458B1AAB3A@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:15301 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S267184AbUIORnF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2004 13:43:05 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

The init phase of the driver required this field *before* the call to
scsi_add_host. I still have to search the fog to remember which system
service panick'd when called with this field uninitialized ...

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Mark Haverkamp [mailto:markh@osdl.org] 
Sent: Wednesday, September 15, 2004 10:25 AM
To: Salyzyn, Mark
Cc: Christoph Hellwig; James Bottomley; linux-scsi
Subject: RE: [PATCH] 2.6.9 aacraid: aac_count fix

On Wed, 2004-09-15 at 04:47, Salyzyn, Mark wrote:
> Christoph Hellwig writes:
> 
> > > +	scsi_set_device(shost, &pdev->dev);
> > 
> > This one is bogus.  scsi_add_host already sets the device.
> 
> Which path sets the device? I got an intermittent panic as a result of
> the device not being set in my unit test (of the kernel of the day at
> the time of this modification, can't remember which version of the
> kernel ...). Which version of this kernel sets it?

In the latest version at least, line 111 in hosts.c sets
shost->shost_gendev.parent = dev ? dev : &platform_bus which is
essentially what scsi_set_device does.


-- 
Mark Haverkamp <markh@osdl.org>

