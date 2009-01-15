From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: export bsg.h header to user-mode
Date: Thu, 15 Jan 2009 17:21:21 +0900
Message-ID: <20090115172127T.fujita.tomonori@lab.ntt.co.jp>
References: <496E11D6.20705@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:52138 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921AbZAOIVe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jan 2009 03:21:34 -0500
In-Reply-To: <496E11D6.20705@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, osd-dev@open-osd.org, linux-scsi@vger.kernel.org

On Wed, 14 Jan 2009 18:24:54 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> Hi TOMO.
> 
> I'm using bsg.ko to submit SG_IO version-4 commands to scsi devices
> from user-mode application. (version-4 for use of bidi and varlen).
> 
> I have not found a bsg.h header in my fedora-10 distribution. Is
> bsg.h exported in kernel-headers-package in latest Kernels? If not
> should we, and how to do it?

I think that we need to export struct sg_io_v4, BSG_PROTOCOL_SCSI, and
BSG_SUB_PROTOCOL_SCSI_*.

We don't install any files in include/scsi/* to userspace.

fujita@viola:~/git/linux-2.6$ cat include/Kbuild
# Top-level Makefile calls into asm-$(ARCH)
# List only non-arch directories below

header-y += asm-generic/
header-y += linux/
header-y += sound/
header-y += mtd/
header-y += rdma/
header-y += video/
header-y += drm/

I guess that SCSI header files for userspace
(/usr/include/scsi/scsi.h, sg.h, etc) come from glibc (but I'm not
sure). They are different from those in kernel.


> Meanwhile I will manually copy it to /usr/include/linux/bsg.h and see
> if I need to fix any thing so it can be compiled from user-mode.
> 
> Also do you have a small libbsg or something to make it easier for
> use by application? should we maintain such a package?
> 
> Pete from the OSC osd project has his set of headers and library
> which I used now. Should I clean it up and send it? Or should I just 
> keep it as part of the osd project for now? what are the sas and fc
> guys using?

Doug copies bsg.h to his smp_utils. I do the same thing for my own bsg
programs. We need glibc (or someone) to install bsg.h properly.
