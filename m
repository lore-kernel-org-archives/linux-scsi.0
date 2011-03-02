From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC 12/12] iscsi-target: Add Makefile/Kconfig and update TCM
	top level
Date: Wed, 02 Mar 2011 13:32:11 -0800
Message-ID: <1299101531.5401.313.camel@haakon2.linux-iscsi.org>
References: <1299036841-23677-1-git-send-email-nab@linux-iscsi.org>
	 <1299036841-23677-13-git-send-email-nab@linux-iscsi.org>
	 <20110301223251.11c95eed.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110301223251.11c95eed.rdunlap@xenotime.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2011-03-01 at 22:32 -0800, Randy Dunlap wrote:
> On Tue,  1 Mar 2011 19:34:01 -0800 Nicholas A. Bellinger wrote:
> 
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Add Makefile/Kconfig and update drivers/target/[Makefile,Kconfig]
> > to include the fabric module.
> > 
> > igned-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/target/Kconfig        |    1 +
> >  drivers/target/Makefile       |    1 +
> >  drivers/target/iscsi/Kconfig  |   17 +++++++++++++++++
> >  drivers/target/iscsi/Makefile |   20 ++++++++++++++++++++
> >  4 files changed, 39 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/target/iscsi/Kconfig
> >  create mode 100644 drivers/target/iscsi/Makefile
> > 
> > diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
> > index 387d293..798749a 100644
> > --- a/drivers/target/Kconfig
> > +++ b/drivers/target/Kconfig
> > @@ -30,5 +30,6 @@ config TCM_PSCSI
> >  	passthrough access to Linux/SCSI device
> >  
> >  source "drivers/target/tcm_loop/Kconfig"
> > +source "drivers/target/iscsi/Kconfig"
> >  
> >  endif
> > diff --git a/drivers/target/Makefile b/drivers/target/Makefile
> > index 60028fe..b038b7d 100644
> > --- a/drivers/target/Makefile
> > +++ b/drivers/target/Makefile
> > @@ -24,3 +24,4 @@ obj-$(CONFIG_TCM_PSCSI)		+= target_core_pscsi.o
> >  
> >  # Fabric modules
> >  obj-$(CONFIG_TCM_LOOP_FABRIC)	+= tcm_loop/
> > +obj-$(CONFIG_ISCSI_TARGET)	+= iscsi/
> > diff --git a/drivers/target/iscsi/Kconfig b/drivers/target/iscsi/Kconfig
> > new file mode 100644
> > index 0000000..d1eaec4
> > --- /dev/null
> > +++ b/drivers/target/iscsi/Kconfig
> > @@ -0,0 +1,17 @@
> > +config ISCSI_TARGET
> > +	tristate "Linux-iSCSI.org iSCSI Target Mode Stack"
> > +	select CRYPTO
> > +	select CRYPTO_CRC32C
> > +	select CRYPTO_CRC32C_INTEL
> 
>   CRYPTO_CRC32C_INTEL depends on X86.  so is ISCSI_TARGET only for X86,
> or is this kconfig just mucked up?
> 
> 

Hi Randy,

The kernel code itself that is specific to using the SSE v4.2
instruction for CRC32C offload are using #ifdef CONFIG_X86 stubs in
iscsi_target_login.c:iscsi_login_setup_crypto(), and !CONFIG_X86 will
default to using the unoptimized 1x8 slicing soft CRC32C code.  This
particular piece of logic has been tested on powerpc and arm and is
funcitoning as expected from the kernel level using the arch independent
soft code.

On the kbuild side, I do see the following warning on !CONFIG_X86:

warning: (LIO_TARGET) selects CRYPTO_CRC32C_INTEL which has unmet direct dependencies (CRYPTO && X86)

I looking at trying to fix this at one point, but was unable to
determine a method for adding a CONFIG_$ARCH condition to an individual
'select BAR' section of 'config FOO'..

How would you recommend handling this case..?

Thanks,

--nab
