From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: Linux 2.6.8.1 + megaraid-2.20.3.0 == Oops
Date: Sat, 21 Aug 2004 11:07:53 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040821110753.0cbcbf74.rddunlap@osdl.org>
References: <s5g3c2hkcod.fsf@patl=users.sf.net>
	<20040820160802.7b74cfa3.rddunlap@osdl.org>
	<s5gr7q0sa2w.fsf@patl=users.sf.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:57220 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S267554AbUHUSSV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Aug 2004 14:18:21 -0400
In-Reply-To: <s5gr7q0sa2w.fsf@patl=users.sf.net>
List-Id: linux-scsi@vger.kernel.org
To: "Patrick J. LoPresti" <patl@users.sourceforge.net>
Cc: Atul.Mukker@lsil.com, linux-scsi@vger.kernel.org

On 21 Aug 2004 13:00:21 -0400 Patrick J. LoPresti wrote:

| "Randy.Dunlap" <rddunlap@osdl.org> writes:
| 
| > Looks like mraid_mm_init() hasn't done the
| > 	INIT_LIST_HEAD(&adapters_list_g);
| > yet.  You might be able to verify that by using
| > "initcall_debug" on the kernel boot/command line.
| 
| Oh, I see now.  Yes, the initicall_debug trace shows that
| mraid_mm_init() is not being called.  But megaraid_init() is, which
| ultimately leads to the crash.
| 
| Is there some way to tell Linux about this dependency when the drivers
| are non-modular?

First (simplest), try reversing the order in scsi/megaraid/Makefile.
That may work.  (put megaraid_mm.o before megaraid_mbox.o)
If that isn't sufficient, it will probably have to be done with initcall
levels (in place of module_init).  See include/linux/init.h for details.
Example:  use:

device_initcall(mraid_mm_init);
and
late_initcall(megaraid_init);



and earlier I wrote:
> I expected to be able to build these drivers as modules, but that's
> not allowed by their Kconfig.  Is that because of the module
> inter-dependencies?

and Pat replied:
| I do not understand.  The first thing I did was to build these as
| modules against the Fedora Core 2 kernel, but that resulted in a
| different failure.  So I thought I would try them non-modular on a
| vanilla kernel, which is how I ended up with this Oops.

The megaraid Kconfig file does not allow these drivers to be built
as loadable modules.  I was asking why not.

--
~Randy
