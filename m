From: Chris Gamache <cgg007@yahoo.com>
Subject: RE: Assistance with an upgraded scsi driver
Date: Thu, 1 Jul 2004 12:49:29 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040701194929.14255.qmail@web13811.mail.yahoo.com>
References: <0E3FA95632D6D047BA649F95DAB60E57033BC805@exa-atlanta>
Reply-To: cgg007@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web13811.mail.yahoo.com ([216.136.175.219]:26756 "HELO
	web13811.mail.yahoo.com") by vger.kernel.org with SMTP
	id S266242AbUGATtc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Jul 2004 15:49:32 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57033BC805@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>, linux-scsi@vger.kernel.org

--- "Mukker, Atul" <Atulm@lsil.com> wrote:
> > New tarball:
> > Makefile     mega_common.h  megaraid_mbox.c  megaraid_mm.c
> > Kconfig.megaraid    mbox_defs.h  megaraid_ioctl.h     
> > megaraid_mbox.h  megaraid_mm.h
> > 
> > ...
> > 
> > I've created a megaraid directory under /usr/src/linux/drivers/scsi
> > 
> > I modified the Makefile and Kconfig in /usr/src/linux/drivers/scsi
> > 
> > I cleaned out the old files
> > 
> > I re-configured to include the new options for compiling the 
> > MEGARAID_NEWGEN as
> > a module
> > 
> > I ran make all
> > 
> > ... ... ...
> > 
> > No new module code was generated. :(
> > 
> Try
> # make drivers/scsi/megaraid/
> 
> or
> # cd drivers/scsi/megaraid
> # make -C /usr/src/linux-.../ SUBDIRS=`pwd` clean
> # make -C /usr/src/linux-.../ SUBDIRS=`pwd` modules
> 
> Modules megaraid_mm.ko and megaraid_mbox.ko should now be available. Load
> megaraid_mm before loading megaraid_mbox
> 
> -Atul Mukker
> LSI Logic
> 

Thank you for the super-fast response. Those shortcuts saved me a bunch of
compile-time. Here was my /real/ problem:

After posting my message I took a little break. When I came back, I found that
I was including the configuration directives CONFIG_SCSI_MEGARAID_* instead of
CONFIG_MEGARAID_* which is what LSI intended! How silly of me! Once I changed
the config directives, everything worked as smooth as silk.

CG




		
__________________________________
Do you Yahoo!?
Take Yahoo! Mail with you! Get it on your mobile phone.
http://mobile.yahoo.com/maildemo 
