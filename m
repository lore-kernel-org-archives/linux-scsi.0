From: Christian Roessner <info@roessner-net.com>
Subject: Re: tmscsim broken on amd64 with 2.6.5?
Date: Tue, 13 Apr 2004 14:16:31 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200404131416.32700.info@roessner-net.com>
References: <200404131025.43474.info@roessner-net.com> <17727.1081854306@www36.gmx.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p15112047.pureserver.info ([217.160.169.118]:40143 "EHLO
	mail.wim-media.de") by vger.kernel.org with ESMTP id S261685AbUDMMQV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Apr 2004 08:16:21 -0400
In-Reply-To: <17727.1081854306@www36.gmx.net>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Hi,

Am Dienstag, 13. April 2004 13:05 schrieben Sie:
> Hi
>
> > drivers/scsi/tmscsim.c: In function `dc390_pci_map':
> > drivers/scsi/tmscsim.c:1028: warning: unsigned int format, different type
> > arg
> > (arg 4)
> > drivers/scsi/tmscsim.c:1049: warning: unsigned int format, different type
> > arg
> > (arg 4)
> > drivers/scsi/tmscsim.c: In function `dc390_pci_unmap':
> > drivers/scsi/tmscsim.c:1066: warning: unsigned int format, different type
> > arg
> > (arg 3)
> > drivers/scsi/tmscsim.c:1076: warning: unsigned int format, different type
> > arg
> > (arg 3)
>
> Ok, just some printk's formats. Will fix that, thanks.
>
> > > kern.*                          -/var/log/tmscsim.log
> >
> > I use metalong and I have not spent time looking for the configuration. I
> > thin /var/log/everthing/current should also contain kern.*
>
> Doesn't look like that. I think, at least, KERN_DEBUG messages are missing.

Well, my mistake. KERN.* is written to /var/log/kernel/current.

> So, now you have both patches applied, right?

Yes

> Could you then uncomment 
> additionally DC390_DEBUG0 and DC390_DCBDEBUG, and also specify
> scsi_logging_level=0x1ff, when loading the scsi_mod module (which also
> means you need scsi-logging enabled in scsi configuration), or
> scsi_logging=0x1ff as a kernel boot-parameter. Of course, this is only
> feasible, if you can refrain from using SCSI for anything else during these
> tests.

I have enabled all these things. When trying to compile, the process stops:

drivers/scsi/tmscsim.c: In function `dc390_pci_map':
drivers/scsi/tmscsim.c:1028: warning: unsigned int format, different type arg 
(arg 4)
drivers/scsi/tmscsim.c:1049: warning: unsigned int format, different type arg 
(arg 4)
drivers/scsi/tmscsim.c: In function `dc390_pci_unmap':
drivers/scsi/tmscsim.c:1066: warning: unsigned int format, different type arg 
(arg 3)
drivers/scsi/tmscsim.c:1076: warning: unsigned int format, different type arg 
(arg 3)
In file included from drivers/scsi/tmscsim.c:1752:
drivers/scsi/scsiiom.c: In function `dc390_remove_dev':
drivers/scsi/scsiiom.c:1285: warning: cast from pointer to integer of 
different size
drivers/scsi/tmscsim.c: In function `dc390_initDCB':
drivers/scsi/tmscsim.c:1770: error: syntax error before "id"
drivers/scsi/tmscsim.c: In function `DC390_init':
drivers/scsi/tmscsim.c:2145: warning: cast from pointer to integer of 
different size
drivers/scsi/tmscsim.c:2153: warning: cast from pointer to integer of 
different size
drivers/scsi/tmscsim.c:2153: warning: cast from pointer to integer of 
different size
drivers/scsi/tmscsim.c:2153: warning: cast from pointer to integer of 
different size
drivers/scsi/tmscsim.c:2155: warning: unsigned int format, different type arg 
(arg 2)
drivers/scsi/tmscsim.c:2155: warning: unsigned int format, different type arg 
(arg 3)
drivers/scsi/tmscsim.c:2155: warning: unsigned int format, different type arg 
(arg 4)
make[2]: *** [drivers/scsi/tmscsim.o] Error 1
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2

When I applied the second patch, I first did not do make clean. But now I did

make clean && make && make modules_install

and I got the errors above.

So I think, some casts are missing?

Regards

Christian

