From: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Subject: Re: tmscsim broken on amd64 with 2.6.5?
Date: Tue, 13 Apr 2004 13:05:06 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <17727.1081854306@www36.gmx.net>
References: <200404131025.43474.info@roessner-net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:23009 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S263544AbUDMLFI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Apr 2004 07:05:08 -0400
List-Id: linux-scsi@vger.kernel.org
To: Christian Roessner <info@roessner-net.com>
Cc: linux-scsi@vger.kernel.org

Hi

> drivers/scsi/tmscsim.c: In function `dc390_pci_map':
> drivers/scsi/tmscsim.c:1028: warning: unsigned int format, different type
> arg
> (arg 4)
> drivers/scsi/tmscsim.c:1049: warning: unsigned int format, different type
> arg
> (arg 4)
> drivers/scsi/tmscsim.c: In function `dc390_pci_unmap':
> drivers/scsi/tmscsim.c:1066: warning: unsigned int format, different type
> arg
> (arg 3)
> drivers/scsi/tmscsim.c:1076: warning: unsigned int format, different type
> arg
> (arg 3)

Ok, just some printk's formats. Will fix that, thanks.

> > kern.*                          -/var/log/tmscsim.log
> 
> I use metalong and I have not spent time looking for the configuration. I
> thin /var/log/everthing/current should also contain kern.*

Doesn't look like that. I think, at least, KERN_DEBUG messages are missing.
So, now you have both patches applied, right? Could you then uncomment
additionally DC390_DEBUG0 and DC390_DCBDEBUG, and also specify
scsi_logging_level=0x1ff, when loading the scsi_mod module (which also means
you need scsi-logging enabled in scsi configuration), or scsi_logging=0x1ff
as a kernel boot-parameter. Of course, this is only feasible, if you can
refrain from using SCSI for anything else during these tests.

Thanks
Guennadi

