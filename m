From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC]: new LSI MegaRAID driver implementation
Date: Tue, 16 Feb 2010 09:45:37 -0700
Message-ID: <20100216164537.GL11239@parisc-linux.org>
References: <6C678488C5CEE74F813A4D1948FD2DC7B7668C0E@cosmail02.lsi.com> <20100215181823.GA25776@infradead.org> <6C678488C5CEE74F813A4D1948FD2DC7B79724D5@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:40189 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932265Ab0BPQpi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Feb 2010 11:45:38 -0500
Content-Disposition: inline
In-Reply-To: <6C678488C5CEE74F813A4D1948FD2DC7B79724D5@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atul.Mukker@lsi.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Tue, Feb 16, 2010 at 09:37:14AM -0700, Mukker, Atul wrote:
> Thanks for the inputs Christoph.
> 
> We sort of had an idea for this possible route. What are your biggest concerns for a single driver model?

My biggest concern is that you'll do something to fix a bug in the new
hardware and inadvertently create a bug for some old piece of hardware.

> The split model has implications for LSI RAID management applications and we want to make sure that decision is made with a thorough analysis.

I'm not sure I see the downside to having a second driver.

One interesting possibility, if you feel you really must have a single driver that handles both sets of hardware is to do this:

------
a.c:

struct pci_driver a_pci_driver { ... };

b.c:

struct pci_driver b_pci_driver { ... };

common.c:

static int __init my_init(void)
{
	error = pci_register_driver(&a_pci_driver);
	if (error)
		return error;
	error = pci_register_driver(&b_pci_driver);
	if (error)
		pci_unregister_driver(&a_pci_driver);
	return error;
}

module_init(my_init);

------

Now you have two completely separated drivers which are bound together
into a single object file.  Bit wasteful, but might make your management
happier.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
