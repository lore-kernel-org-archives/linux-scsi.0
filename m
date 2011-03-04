From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC 12/12] iscsi-target: Add Makefile/Kconfig and update TCM
 top level
Date: Fri, 04 Mar 2011 11:00:21 -0600
Message-ID: <1299258022.7041.64.camel@mulgrave.site>
References: <1299036841-23677-1-git-send-email-nab@linux-iscsi.org>
	 <1299036841-23677-13-git-send-email-nab@linux-iscsi.org>
	 <20110301223251.11c95eed.rdunlap@xenotime.net>
	 <1299101531.5401.313.camel@haakon2.linux-iscsi.org>
	 <20110303141928.GA25256@infradead.org>
	 <1299185905.5401.405.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1299185905.5401.405.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, Randy Dunlap <rdunlap@xenotime.net>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2011-03-03 at 12:58 -0800, Nicholas A. Bellinger wrote:
> On Thu, 2011-03-03 at 09:19 -0500, Christoph Hellwig wrote:
> > On Wed, Mar 02, 2011 at 01:32:11PM -0800, Nicholas A. Bellinger wrote:
> > > The kernel code itself that is specific to using the SSE v4.2
> > > instruction for CRC32C offload are using #ifdef CONFIG_X86 stubs in
> > > iscsi_target_login.c:iscsi_login_setup_crypto(), and !CONFIG_X86 will
> > > default to using the unoptimized 1x8 slicing soft CRC32C code.  This
> > > particular piece of logic has been tested on powerpc and arm and is
> > > funcitoning as expected from the kernel level using the arch independent
> > > soft code.
> > 
> > I don't think you need that code at all.  The crypto code is structured
> > to prefer the optimized implementation if it is present.  Just stripping
> > the x86-specific code out and always requesting the plain crc32c
> > algorithm should give you the optimized one if it is present on your
> > system.
> > 
> > Please give it a try.
> > 
> 
> This is what I originally thought as well, but this ended up not being
> the case when the logic was originally coded up.   I just tried again
> with .38-rc7 on a 5500 series machine and simply stubbing out the
> CONFIG_X86 part from iscsi_login_setup_crypto() and calling:
> 
>    crypto_alloc_hash("crc32c", 0, CRYPTO_ALG_ASYNC)
> 
> does not automatically load and use crc32c_intel.ko when only requesting
> plain crc32c.

It sounds like there might be a bug in the crypto layer, so the Linux
way is to make it work as intended.

It's absolutely not acceptable just to pull other layer workarounds into
drivers.

> The reason for the extra crypto_alloc_hash("crc32c-intel", ...) call in
> iscsi_login_setup_crypto() is to load crc32c_intel.ko on-demand for
> cpu_has_xmm4_2 capable machines.
> 
> I should mention this is with the following .config:
> 
> CONFIG_CRYPTO_CRC32C=y
> CONFIG_CRYPTO_CRC32C_INTEL=m
> 
> This would seem to indicate that CRC32C_INTEL needs to be compiled in
> (or at least manually loaded) for libcypto to use the optimized
> instructions when the plain crc32c is called, correct..?

That sounds right.  There's probably not an autoload for this on
recognising sse instructions.

James



James
