From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC 12/12] iscsi-target: Add Makefile/Kconfig and update TCM
 top level
Date: Thu, 3 Mar 2011 09:19:28 -0500
Message-ID: <20110303141928.GA25256@infradead.org>
References: <1299036841-23677-1-git-send-email-nab@linux-iscsi.org>
 <1299036841-23677-13-git-send-email-nab@linux-iscsi.org>
 <20110301223251.11c95eed.rdunlap@xenotime.net>
 <1299101531.5401.313.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37411 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758424Ab1CCOTb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Mar 2011 09:19:31 -0500
Content-Disposition: inline
In-Reply-To: <1299101531.5401.313.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>

On Wed, Mar 02, 2011 at 01:32:11PM -0800, Nicholas A. Bellinger wrote:
> The kernel code itself that is specific to using the SSE v4.2
> instruction for CRC32C offload are using #ifdef CONFIG_X86 stubs in
> iscsi_target_login.c:iscsi_login_setup_crypto(), and !CONFIG_X86 will
> default to using the unoptimized 1x8 slicing soft CRC32C code.  This
> particular piece of logic has been tested on powerpc and arm and is
> funcitoning as expected from the kernel level using the arch independent
> soft code.

I don't think you need that code at all.  The crypto code is structured
to prefer the optimized implementation if it is present.  Just stripping
the x86-specific code out and always requesting the plain crc32c
algorithm should give you the optimized one if it is present on your
system.

Please give it a try.

