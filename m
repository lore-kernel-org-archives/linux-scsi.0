From: Matthew Wilcox <willy@debian.org>
Subject: Re: *solved* megaraid /proc under kernel 2.6.2
Date: Tue, 17 Feb 2004 16:57:39 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040217165739.GV31168@parcelfarce.linux.theplanet.co.uk>
References: <1076884890.2943.265.camel@morsel.kungfoocoder.org> <1076890712.2943.276.camel@morsel.kungfoocoder.org> <1076972673.2259.56.camel@morsel.kungfoocoder.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:11183 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S266293AbUBQQ5m
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2004 11:57:42 -0500
Content-Disposition: inline
In-Reply-To: <1076972673.2259.56.camel@morsel.kungfoocoder.org>
List-Id: linux-scsi@vger.kernel.org
To: Paul Wagland <paul@kungfoocoder.org>
Cc: Linux SCSI mailing list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jgarzik@pobox.com>

On Tue, Feb 17, 2004 at 12:04:33AM +0100, Paul Wagland wrote:
> Hi all,
> 
> OK, I now know what the problem is with the /proc entries and the
> megaraid driver.
> 
> It turns out that pci_driver.probe member (in this case
> megaraid_probe_one()) is called before the module_init() declared
> function, in this case megaraid_init().

Hang on.  The pci_driver isn't registered magically, it happens by an
explicit call.  Oh look, here's the problem:

        error = pci_module_init(&megaraid_pci_driver);
        if (error) 
                return error;
        
#ifdef CONFIG_PROC_FS
        mega_proc_dir_entry = proc_mkdir("megaraid", &proc_root);
        if (!mega_proc_dir_entry) {
                printk(KERN_WARNING
                                "megaraid: failed to create megaraid root\n");
        }
#endif

Just swap these two stanzas and everything will happen in the right order.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
