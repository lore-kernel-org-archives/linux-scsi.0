From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target_core_mib.h move
Date: Tue, 18 Jan 2011 13:02:24 -0800
Message-ID: <1295384544.22813.446.camel@haakon2.linux-iscsi.org>
References: <AANLkTim-KKyOt_U2cDvfW3cav9F29mSvzAcV9H2mJqbT@mail.gmail.com>
	 <20110117205130.GA22532@infradead.org>
	 <AANLkTinNiohS+9WDcCP4P=0beRRE53x4iFC9u7iXBOy2@mail.gmail.com>
	 <1295381563.22813.429.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:53345 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab1ARVC2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Jan 2011 16:02:28 -0500
In-Reply-To: <1295381563.22813.429.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fubo Chen <fubo.chen@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2011-01-18 at 12:12 -0800, Nicholas A. Bellinger wrote:
> On Tue, 2011-01-18 at 17:58 +0100, Fubo Chen wrote:
> > On Mon, Jan 17, 2011 at 9:51 PM, Christoph Hellwig <hch@infradead.org> wrote:
> > > On Mon, Jan 17, 2011 at 09:00:02PM +0100, Fubo Chen wrote:
> > >> target_core_mib.h move from drivers/target to include/target.
> > >> Otherwise my driver not build.
> > >>
> > >> Signed-off-by: Fubo Chen <fubo.chen@gmail.com>
> > >
> > > Why does the driver need to poke into the target MIB code directly?
> > 
> > I should ask you why.
> > 
> > > Can you post the driver?
> > 
> > Compiler says:
> > 
> > $ make M=drivers/target modules
> >   CC [M]  drivers/target/tcm_mvsas_tgt/tcm_mvsas_tgt_fabric.o
> > In file included from drivers/target/tcm_mvsas_tgt/tcm_mvsas_tgt_fabric.c:15:0:
> > include/target/target_core_base.h:11:29: fatal error:
> > target_core_mib.h: No such file or directory
> > compilation terminated.
> > make[2]: *** [drivers/target/tcm_mvsas_tgt/tcm_mvsas_tgt_fabric.o] Error 1
> > make[1]: *** [drivers/target/tcm_mvsas_tgt] Error 2
> > make: *** [_module_drivers/target] Error 2
> > 
> > for this driver:
> > 
> > ---
> >  drivers/target/Kbuild                              |    1 +
> >  drivers/target/Kconfig                             |    2 +
> >  drivers/target/tcm_mvsas_tgt/Kbuild                |    3 +
> >  drivers/target/tcm_mvsas_tgt/Kconfig               |    6 +
> >  drivers/target/tcm_mvsas_tgt/tcm_mvsas_tgt_base.h  |   31 ++
> >  .../target/tcm_mvsas_tgt/tcm_mvsas_tgt_configfs.c  |  298 ++++++++++++++++++++
> >  .../target/tcm_mvsas_tgt/tcm_mvsas_tgt_fabric.c    |  272 ++++++++++++++++++
> >  .../target/tcm_mvsas_tgt/tcm_mvsas_tgt_fabric.h    |   39 +++
> >  8 files changed, 652 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/target/Kbuild
> >  create mode 100644 drivers/target/tcm_mvsas_tgt/Kbuild
> >  create mode 100644 drivers/target/tcm_mvsas_tgt/Kconfig
> >  create mode 100644 drivers/target/tcm_mvsas_tgt/tcm_mvsas_tgt_base.h
> >  create mode 100644 drivers/target/tcm_mvsas_tgt/tcm_mvsas_tgt_configfs.c
> >  create mode 100644 drivers/target/tcm_mvsas_tgt/tcm_mvsas_tgt_fabric.c
> >  create mode 100644 drivers/target/tcm_mvsas_tgt/tcm_mvsas_tgt_fabric.h
> > 
> > diff --git a/drivers/target/Kbuild b/drivers/target/Kbuild
> > new file mode 100644
> > index 0000000..a997c81
> > --- /dev/null
> > +++ b/drivers/target/Kbuild
> > @@ -0,0 +1 @@
> > +obj-$(CONFIG_TCM_MVSAS_TGT)	+= tcm_mvsas_tgt/
> > diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
> > index 2fac3be..85dcc60 100644
> > --- a/drivers/target/Kconfig
> > +++ b/drivers/target/Kconfig
> > @@ -29,4 +29,6 @@ config TCM_PSCSI
> >  	Say Y here to enable the TCM/pSCSI subsystem plugin for non-buffered
> >  	passthrough access to Linux/SCSI device
> > 
> > +source drivers/target/mvsas_tgt/Kconfig
> > +
> >  endif
> > diff --git a/drivers/target/tcm_mvsas_tgt/Kbuild
> > b/drivers/target/tcm_mvsas_tgt/Kbuild
> > new file mode 100644
> > index 0000000..1c179d7
> > --- /dev/null
> > +++ b/drivers/target/tcm_mvsas_tgt/Kbuild
> > @@ -0,0 +1,3 @@
> > +tcm_mvsas_tgt-objs			:= tcm_mvsas_tgt_fabric.o \
> > +					   tcm_mvsas_tgt_configfs.o
> > +obj-$(CONFIG_TCM_MVSAS_TGT)		+= tcm_mvsas_tgt.o
> 
> I think this fabric module was generated with an older version of
> Documentation/target/tcm_mod_builder.py, right..?
> 
> After doing a quick 'tcm_mod_builder.py -m tcm_mvsas_tgt -p SAS' with
> mainline code, the newly generated tcm_mvsas_tgt.ko builds as expected..
> 
> [nab@hera lio-core-2.6.git]$ make
> drivers/target/tcm_mvsas_tgt/tcm_mvsas_tgt.ko
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CC [M]  drivers/target/tcm_mvsas_tgt/tcm_mvsas_tgt_fabric.o
>   CC [M]  drivers/target/tcm_mvsas_tgt/tcm_mvsas_tgt_configfs.o
>   LD [M]  drivers/target/tcm_mvsas_tgt/tcm_mvsas_tgt.o
>   MODPOST 2 modules
>   CC      drivers/target/tcm_mvsas_tgt/tcm_mvsas_tgt.mod.o
>   LD [M]  drivers/target/tcm_mvsas_tgt/tcm_mvsas_tgt.ko
> 
> The bit missing from the top of your Kbuild is:
> 
> EXTRA_CFLAGS += -I$(srctree)/drivers/target/ -I$(srctree)/include/ -I$(srctree)/drivers/scsi/ -I$(srctree)/include/scsi/ -I$(srctree)/drivers/target/tcm_mvsas_tgt
> 
> FYI, depending upon the age of the tcm_mod_builder.py in question , you
> may want to consider re-generating the fabric module skeleton with the
> latest code.
> 

Hi again Fubo,

If you want to re-generate your driver, please make sure to grab the
patch for tcm_mod_builder.py merged into lio-core-2.6.git that
uses /Makefile instead of /Kbuild filenames here:

target: Convert tcm_mod_builder.py from Kbuild -> Makefile
http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commitdiff;h=3103722a1cf759d475b9ecd9cdb0df523dbf09ab

Thanks!

--nab


