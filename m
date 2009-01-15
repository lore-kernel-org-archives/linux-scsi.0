From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: export bsg.h header to user-mode
Date: Thu, 15 Jan 2009 10:57:13 +0200
Message-ID: <496EFA69.3050007@panasas.com>
References: <496E11D6.20705@panasas.com> <20090115172127T.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:21504 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762013AbZAOI5U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jan 2009 03:57:20 -0500
In-Reply-To: <20090115172127T.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: osd-dev@open-osd.org, linux-scsi@vger.kernel.org, Douglas Gilbert <dougg@torque.net>

FUJITA Tomonori wrote:
> On Wed, 14 Jan 2009 18:24:54 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> Hi TOMO.
>>
>> I'm using bsg.ko to submit SG_IO version-4 commands to scsi devices
>> from user-mode application. (version-4 for use of bidi and varlen).
>>
>> I have not found a bsg.h header in my fedora-10 distribution. Is
>> bsg.h exported in kernel-headers-package in latest Kernels? If not
>> should we, and how to do it?
> 
> I think that we need to export struct sg_io_v4, BSG_PROTOCOL_SCSI, and
> BSG_SUB_PROTOCOL_SCSI_*.
> 

I've tested and linux/bsg.h is perfect for user-mode consumption. It
has a few kernel declarations protected by ifdef __KERNEL__ and exactly
what you have above. I did not change anything

> We don't install any files in include/scsi/* to userspace.
> 
> fujita@viola:~/git/linux-2.6$ cat include/Kbuild
> # Top-level Makefile calls into asm-$(ARCH)
> # List only non-arch directories below
> 
> header-y += asm-generic/
> header-y += linux/
> header-y += sound/
> header-y += mtd/
> header-y += rdma/
> header-y += video/
> header-y += drm/
> 

But that's fine then since bsg.h is in <linux/bsg.h>
not <scsi/bsg.h> what is the problem?

OK But you just explained how to do it patch below ...

> I guess that SCSI header files for userspace
> (/usr/include/scsi/scsi.h, sg.h, etc) come from glibc (but I'm not
> sure). They are different from those in kernel.
> 
> 
>> Meanwhile I will manually copy it to /usr/include/linux/bsg.h and see
>> if I need to fix any thing so it can be compiled from user-mode.
>>
>> Also do you have a small libbsg or something to make it easier for
>> use by application? should we maintain such a package?
>>
>> Pete from the OSC osd project has his set of headers and library
>> which I used now. Should I clean it up and send it? Or should I just 
>> keep it as part of the osd project for now? what are the sas and fc
>> guys using?
> 
> Doug copies bsg.h to his smp_utils. I do the same thing for my own bsg
> programs. We need glibc (or someone) to install bsg.h properly.

That is not acceptable for me since I will need to provide an open-osd-devel
package to distros and I might need bsg.h, which I cannot supply with my
package, what if someone else will need it too then we have a conflict.

I'm sending a patch, please ACK?
Thanks
Boaz

---
From: Boaz Harrosh <bharrosh@panasas.com>
Date: Thu, 15 Jan 2009 10:43:17 +0200
Subject: [PATCH] include/linux: Add bsg.h to the Kernel exported headers

bsg.h in current form is perfectly suitable for user-mode
consumption. It is needed together with scsi/sg.h for applications
that want to interface with the bsg driver.

Currently the few projects that use it would copy it over into
the projects. But that is not acceptable for projects that need
to provide a libxxx-devel package for distros.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 include/linux/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 12e9a29..2124c06 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -41,6 +41,7 @@ header-y += baycom.h
 header-y += bfs_fs.h
 header-y += blkpg.h
 header-y += bpqether.h
+header-y += bsg.h
 header-y += can.h
 header-y += cdk.h
 header-y += chio.h
-- 
1.6.0.1

 




