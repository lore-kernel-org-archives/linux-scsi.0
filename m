From: Andrew Morton <akpm@osdl.org>
Subject: Re: About ARECA RAID driver for Linux i386/x86-64
Date: Fri, 11 Mar 2005 14:27:30 -0800
Message-ID: <20050311142730.10d3c616.akpm@osdl.org>
References: <000001c524bc$d3c546a0$0b02a8c0@kw.de>
	<000c01c52626$32bae8d0$9300a8c0@erich2003>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Received: from fire.osdl.org ([65.172.181.4]:31943 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261799AbVCKW1n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2005 17:27:43 -0500
In-Reply-To: <000c01c52626$32bae8d0$9300a8c0@erich2003>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: erich <erich@areca.com.tw>
Cc: e0815w@onlinehome.de, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, hch@infradead.org, arjan@infradead.org

"erich" <erich@areca.com.tw> wrote:
>
> Thanks for your kindness comment.
> I had modify "arcmsr" as your mention and ran it at 2.6.11 kernel.

A few points on this patch:

a) Please don't use full pathnames in the patch headers:

--- /usr/src/linux-2.6.11/drivers/scsi/Makefile.org	2005-03-11 10:20:49.000000000 +0800
+++ /usr/src/linux-2.6.11/drivers/scsi/Makefile	2005-03-11 11:32:07.000000000 +0800

   Because not everyone places their kernel tree in /usr/src/linux-2.6.11.
   See http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt

b) Please trim off all trailing whitespace.  Here's a script which you
   run against a patch to prevent it from introducing new trailing
   whitespace.  (I swear that this script has shrunk the kernel tree by a
   megabyte over the past few years)

#!/bin/sh

strip1()
{
	TMP=$(mktemp /tmp/XXXXXX)
	cp $1 $TMP
	sed -e '/^+/s/[ 	]*$//' < $TMP > $1
	rm $TMP
}

for i in $*
do
	strip1 $i
done

c) You cannot use absolute pathnames for include files.  Here's a fix:



Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 25-akpm/drivers/scsi/arcmsr/arcmsr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/arcmsr/arcmsr.c~areca-raid-linux-scsi-driver-fix drivers/scsi/arcmsr/arcmsr.c
--- 25/drivers/scsi/arcmsr/arcmsr.c~areca-raid-linux-scsi-driver-fix	Fri Mar 11 14:22:23 2005
+++ 25-akpm/drivers/scsi/arcmsr/arcmsr.c	Fri Mar 11 14:22:23 2005
@@ -107,8 +107,8 @@
 #include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
-#include "/usr/src/linux/drivers/scsi/scsi.h"
-#include "/usr/src/linux/include/scsi/scsi_host.h"
+#include "../scsi.h"
+#include <scsi/scsi_host.h>
 
 #include "arcmsr.h"
 #endif
_

