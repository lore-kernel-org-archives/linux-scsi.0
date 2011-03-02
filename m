From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC 12/12] iscsi-target: Add Makefile/Kconfig and update TCM
	top level
Date: Wed, 02 Mar 2011 15:18:16 -0800
Message-ID: <1299107896.5401.333.camel@haakon2.linux-iscsi.org>
References: <1299036841-23677-1-git-send-email-nab@linux-iscsi.org>
	 <1299036841-23677-13-git-send-email-nab@linux-iscsi.org>
	 <20110301223251.11c95eed.rdunlap@xenotime.net>
	 <1299101531.5401.313.camel@haakon2.linux-iscsi.org>
	 <41502.137.254.4.9.1299105929.squirrel@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <41502.137.254.4.9.1299105929.squirrel@xenotime.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <james.bottomley@hansenpartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2011-03-02 at 14:45 -0800, Randy Dunlap wrote:
> On Wed, March 2, 2011 1:32 pm, Nicholas A. Bellinger wrote:
> > On Tue, 2011-03-01 at 22:32 -0800, Randy Dunlap wrote:
> >> On Tue,  1 Mar 2011 19:34:01 -0800 Nicholas A. Bellinger wrote:
> >>> From: Nicholas Bellinger <nab@linux-iscsi.org>

<SNIP>

> >>> --- /dev/null
> >>> +++ b/drivers/target/iscsi/Kconfig
> >>> @@ -0,0 +1,17 @@
> >>> +config ISCSI_TARGET
> >>> +	tristate "Linux-iSCSI.org iSCSI Target Mode Stack"
> >>> +	select CRYPTO
> >>> +	select CRYPTO_CRC32C
> >>> +	select CRYPTO_CRC32C_INTEL
> >>>
> >>
> >> CRYPTO_CRC32C_INTEL depends on X86.  so is ISCSI_TARGET only for X86,
> >> or is this kconfig just mucked up?
> >>
> >>
> >
> > Hi Randy,
> >
> >
> > The kernel code itself that is specific to using the SSE v4.2
> > instruction for CRC32C offload are using #ifdef CONFIG_X86 stubs in
> > iscsi_target_login.c:iscsi_login_setup_crypto(), and !CONFIG_X86 will
> > default to using the unoptimized 1x8 slicing soft CRC32C code.  This
> > particular piece of logic has been tested on powerpc and arm and is
> > funcitoning as expected from the kernel level using the arch independent
> > soft code.
> >
> > On the kbuild side, I do see the following warning on !CONFIG_X86:
> >
> >
> > warning: (LIO_TARGET) selects CRYPTO_CRC32C_INTEL which has unmet direct
> > dependencies (CRYPTO && X86)
> 
> Ah, good.
> 
> > I looking at trying to fix this at one point, but was unable to
> > determine a method for adding a CONFIG_$ARCH condition to an individual
> > 'select BAR' section of 'config FOO'..
> >
> >
> > How would you recommend handling this case..?
> 
> How about
> 
>         select CRYPTO_CRC32C_INTEL if X86
> 
> (with s/spaces/tab/)

Perfect, this resolves the kconfig warning on a nearby powerpc machine
running LIO upstream .38-rcX iSCSI target code..

Committed as c8bc93f107b into lio-core-2.6.git/lio-4.1, and I will make
sure this is included for the next iscsi-target RFC series rev.

Thanks for your review Randy!

--nab
