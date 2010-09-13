From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/2] lio-target: Add support for libcrypto crc32c and
	crc32-intel offload
Date: Mon, 13 Sep 2010 12:50:32 -0700
Message-ID: <1284407432.8171.41.camel@haakon2.linux-iscsi.org>
References: <1284201076-22361-1-git-send-email-nab@linux-iscsi.org>
	 <4C8DED17.6080801@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C8DED17.6080801@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Boaz Harrosh <bharrosh@panasas.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Vasu Dev <vasu.dev@linux.intel.com>, Joe Eykholt <jeykholt@cisco.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2010-09-13 at 11:21 +0200, Hannes Reinecke wrote:
> Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Greetings all,
> > 
> > This patch series converts the LIO-Target fabric module from using a legacy
> > internal slicing by 1x CRC32C algorithm to the slicing by 1x CRC32C available in
> > crc32c.ko, as well as initial support for the Nehalem series crc32c-intel.ko
> > instruction offload available since v2.6.27 in late 2008.
> > 
> > So far this series has been lightly tested with a handful of Open-iSCSI client VMs
> > with the optimized crc32c-intel.ko offload case, and there appears to be some
> > HeaderDigest failures for one case with RHEL6 B2 x86_64, while Ubuntu i686 on
> > v2.6.27 and OpenSuse 11.2 x86_64 on v2.6.31 work as expected with HeaderDigest=CRC32C
> > and DataDigest=CRC32C using the offload on the LIO-Target side.
> > 
> > Currently this patch disables the new iSCSI TPG attribute crc32c_x86_offload
> > to force the crc32c.ko slicing by x1 CRC32C algorithm until these compatibility
> > issues with existing libcrc32c clients can be properly resolved with the Nehalem
> > CRC32C offload instructions running on the LIO-Target side.
> > 
> Due to a customer issue I had to revisit the CRC32 issue recently.
> And according to you the main reason for using your own CRC routines
> had been endianness issues.

Indeed, this has historically been the case for LIO-Target and
Core-iSCSI.  I noticed the issue with libcrypto while porting the latter
on a old G4 TI-book waaay back during v2.6.10-rc3 days.

> IE the in-kernel crc32c routines apparently weren't able to
> calculate the checksum in an endianness-independent manner.
> So a CRC calculated on a BE machine would fail to be validated by a
> LE machine and vice versa.
> 
> Has this been fixed / verified?
> 

>From taking a look at crypto/crc32c.c it still appears AFAICT to not be
big endian safe.  I was planning to test this patch on some powerpc/ppc
hardware with v2.6.36-rc4 in the next days, but it looks like
lio-core-2.6.git will need a seperate crypto/crc32c.c patch to function
properly on big endian arches.

Thanks for mentioning this point Hannes!

--nab
