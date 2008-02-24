From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/1] [SCSI] gdth: misc cleanups, preparation for ISA/EISA hotplug API
Date: Sat, 23 Feb 2008 23:37:15 -0700
Message-ID: <20080224063715.GN16995@parisc-linux.org>
References: <017ac0b5a1e36b990eedfb7124c78d58f947f076.1203828195.git.jeff@garzik.org> <20080224045810.GA17051@infradead.org> <47C0FE1F.300@garzik.org> <20080224053117.GA13904@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:60073 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbYBXGhR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Feb 2008 01:37:17 -0500
Content-Disposition: inline
In-Reply-To: <20080224053117.GA13904@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, Feb 24, 2008 at 12:31:17AM -0500, Christoph Hellwig wrote:
> On Sun, Feb 24, 2008 at 12:18:23AM -0500, Jeff Garzik wrote:
> > hmmmmm.  We'll see how it plays out...  on the remove side, the above is 
> > exact what happens in gdth_remove_one() without my patch, thus 
> > consolidating two cases of the same code into one.  There is a less-strong 
> > argument for doing the allocation that way, but it may turn out to be 
> > useful anyway once the ISA/EISA API conversion is complete.
> 
> EISA ->remove has a different prototype from PCI ->remove from ISA
> ->remove, so gdth_remove_one will be split up eventually.  Having the
> scsi_host_put duplicated in each shouldn't be too much of a problem :)

Shouldn't need to duplicate it ... free bus-specific things in the
->remove method, and call a common helper.  See advansys_release() and
its callers in advansys.c for how I did it.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
