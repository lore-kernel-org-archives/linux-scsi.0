From: Paul Wagland <paul@kungfoocoder.org>
Subject: Re: *solved* megaraid /proc under kernel 2.6.2
Date: Tue, 17 Feb 2004 00:04:33 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076972673.2259.56.camel@morsel.kungfoocoder.org>
References: <1076884890.2943.265.camel@morsel.kungfoocoder.org>
	 <1076890712.2943.276.camel@morsel.kungfoocoder.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out5.xs4all.nl ([194.109.24.6]:9 "EHLO smtp-out5.xs4all.nl")
	by vger.kernel.org with ESMTP id S265933AbUBPXEp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Feb 2004 18:04:45 -0500
In-Reply-To: <1076890712.2943.276.camel@morsel.kungfoocoder.org>
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI mailing list <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jgarzik@pobox.com>

Hi all,

OK, I now know what the problem is with the /proc entries and the
megaraid driver.

It turns out that pci_driver.probe member (in this case
megaraid_probe_one()) is called before the module_init() declared
function, in this case megaraid_init().

The problem is as follows: megaraid_probe_one calls
mega_create_proc_entry() which relies on the fact that megaraid_init()
has already been called. Except, that this fact isn't :-)

So, now that I know what the problem is, does anyone know where the bug
really lies? I.e;

Should megaraid_init() be called before megaraid_probe_one() is called?
That would make this a "kernel bug", for some suitable value of kernel.

or

Should megaraid_probe_one() not rely on megaraid_init() having been
previously called? This would then turn it into a driver bug.


If the latter, when I go in to fix this code, can I assume that
megaraid_probe_one() will only be called once at a time, i.e. that there
is a lock somewhere outside of me that guarantees that I don't have to
worry about re-entrancy issues. Please note that the code already
assumes this!

Should this be asked on linux-kernel?

Thanks in advance for all replies,
Paul

