From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] - MPT FUSION - SPLITTING SCSI HOST DRIVERS
Date: Mon, 28 Mar 2005 12:34:42 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C01C2B134@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:15513 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262024AbVC1TfQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Mar 2005 14:35:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Saturday, March 26, 2005 4:21 AM, Christoph Hellwig wrote:
> I took a quick look an a here's a few comments:
> 
>  - I don't think renaming mptscsih.c to mpt_core.c makes sense.
>    the new name is confusing at best, and keeping the old name allows
>    to keep SCCS history aswell.  That means the new SPI stub 
> driver should
>    be called mptspi or something like that.

Ok fine.
I was wondering whether I should be providing a patch 
for all the defconfig files down in the arch branch with
CONFIG_FUSION=m , so our new drivers(mptspi and mptfc) 
would be getting compiled into default configurations?  

>  - please don't link mpt_core.o into both mptfch.ko and 
> mptscsih.ko but
>    make it a module of it's own

I'm not clear on this request.  Do you want me to add 
the mptscsih.ko module back, with module_init and module_exit
functions?  Thus when someone is either loading 
mptspi.ko/mptfc.ko, then they would need to 
load mptscsih.ko as well as mptbase.ko?  Bottom line,
three drivers loaded for either FC or SPI.  Just wondering
whether keeping the naming of mptscsih.ko driver would cause 
any problems.


>  - the new driver shoild use module_param, not MODULE_PARM

I'll fix it.

>  - why does the fc driver set ioc->spi_data.mpt_pq_filter?

Yes - this appplies to fiber.  It was requested by engenio, 
to prevent seeing a dummy Lun.  I probably confused you when I saved
this command line options in the spi_data member. Fine, I 
will save mpt_pq_filter somewhere else.

>  - no need to forward-declare the module_init/module_exit handlers
> 

Fine
