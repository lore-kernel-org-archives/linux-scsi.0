From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: Linux 2.6.8.1 + megaraid-2.20.3.0 == Oops
Date: Fri, 20 Aug 2004 16:08:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040820160802.7b74cfa3.rddunlap@osdl.org>
References: <s5g3c2hkcod.fsf@patl=users.sf.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:43972 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S268795AbUHTXJf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Aug 2004 19:09:35 -0400
In-Reply-To: <s5g3c2hkcod.fsf@patl=users.sf.net>
List-Id: linux-scsi@vger.kernel.org
To: "Patrick J. LoPresti" <patl@users.sourceforge.net>
Cc: Atul.Mukker@lsil.com, linux-scsi@vger.kernel.org

On 20 Aug 2004 12:22:26 -0400 Patrick J. LoPresti wrote:

| My hardware is a Dell PowerEdge 650 server with a PERC4/SC RAID
| controller.  I downloaded the 2.6.8.1 Linux kernel from kernel.org and
| applied this patch:
| 
|   ftp://ftp.lsil.com/pub/linux-megaraid/drivers/version-2.20.3.0/megaraid2.20.3.0-lk2.6.8.1.patch.gz
| 
| The system generates an Oops on boot.  I am attaching both my kernel
| .config and the console startup messages below.
| 
| Let me know if I can provide any other information.

Looks like mraid_mm_init() hasn't done the
	INIT_LIST_HEAD(&adapters_list_g);
yet.  You might be able to verify that by using
"initcall_debug" on the kernel boot/command line.
I don't see the expected "megaraid cmm:" message, e.g.

I expected to be able to build these drivers as modules, but that's
not allowed by their Kconfig.  Is that because of the module
inter-dependencies?


--
~Randy
