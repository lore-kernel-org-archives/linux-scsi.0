From: "Patrick J. LoPresti" <patl@users.sourceforge.net>
Subject: Re: Linux 2.6.8.1 + megaraid-2.20.3.0 == Oops
Date: 22 Aug 2004 15:12:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <s5g3c2fm1t4.fsf@patl=users.sf.net>
References: <s5g3c2hkcod.fsf@patl=users.sf.net>
	<20040820160802.7b74cfa3.rddunlap@osdl.org>
	<s5gr7q0sa2w.fsf@patl=users.sf.net>
	<20040821110753.0cbcbf74.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ext.curl.com ([66.228.88.132]:43791 "HELO
	mail-ext.curl.com") by vger.kernel.org with SMTP id S268072AbUHVTM5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Aug 2004 15:12:57 -0400
In-Reply-To: <20040821110753.0cbcbf74.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: Atul.Mukker@lsil.com, linux-scsi@vger.kernel.org

"Randy.Dunlap" <rddunlap@osdl.org> writes:

> First (simplest), try reversing the order in scsi/megaraid/Makefile.
> That may work.  (put megaraid_mm.o before megaraid_mbox.o)

That works.

Megaraid developers, I suggest the following (trivial) patch to allow
your driver to work when compiled non-modular:


--- linux-megaraid-2.6.8.1/drivers/scsi/megaraid/Makefile~  2004-08-20 12:05:27.000000000 -0400
+++ linux-megaraid-2.6.8.1/drivers/scsi/megaraid/Makefile   2004-08-22 11:18:18.441805789 -0400
@@ -1,2 +1,2 @@
-obj-$(CONFIG_MEGARAID_MAILBOX) += megaraid_mbox.o
 obj-$(CONFIG_MEGARAID_MM)      += megaraid_mm.o
+obj-$(CONFIG_MEGARAID_MAILBOX) += megaraid_mbox.o


> and earlier I wrote:
> > I expected to be able to build these drivers as modules, but that's
> > not allowed by their Kconfig.  Is that because of the module
> > inter-dependencies?
> 
> and Pat replied:
> | I do not understand.  The first thing I did was to build these as
> | modules against the Fedora Core 2 kernel, but that resulted in a
> | different failure.  So I thought I would try them non-modular on a
> | vanilla kernel, which is how I ended up with this Oops.
> 
> The megaraid Kconfig file does not allow these drivers to be built
> as loadable modules.  I was asking why not.

And I was saying that I do not understand :-).  I have now just
finished running "make gconfig", and I was able to configure both
megaraid_mm and megaraid_mbox to compile as modules.  I installed both
on the initrd and the system boots fine.  So my earlier problem must
have been some incompatibility between the driver and FC2, or a
mistake on my part when building the module out-of-tree.

Stress testing is next.  We can crash the stock 2.6.x megaraid driver
consistently, but it takes around 12 hours of hammering.  I look
forward to finding out how the new driver fares.

Thank you for your help, Randy!

 - Pat
