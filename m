From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH] aacraid updates for new proing APIs
Date: Fri, 21 Nov 2003 09:12:38 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069434758.12610.10.camel@markh1.pdx.osdl.net>
References: <20031118110110.A22400@infradead.org>
	 <1069190962.26419.29.camel@markh1.pdx.osdl.net>
	 <20031119124828.A11769@infradead.org> <20031121113019.A15853@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:27319 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S264373AbTKURMq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2003 12:12:46 -0500
In-Reply-To: <20031121113019.A15853@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2003-11-21 at 03:30, Christoph Hellwig wrote:
> On Wed, Nov 19, 2003 at 12:48:28PM +0000, Christoph Hellwig wrote:
> > On Tue, Nov 18, 2003 at 01:29:22PM -0800, Mark Haverkamp wrote:
> > > > +	pci_set_master(pdev);
> > > > +	pci_set_dma_mask(pdev, 0xFFFFFFFFULL);
> > > 
> > > I've been told that the return value of this should be checked as it is
> > > possible for it to fail.
> > 
> > Indeed.  This patches objective was to convert aacraid to the new-style
> > probing, not to fix bugs, but I'll add the fix to the next revision of
> > the patch anyway.
> 
> Ok here's a new patch.  Updates:
> 
>   - check pci_set_dma_mask return value
>   - fix leak in the HBA remove path
>   - fix leak in probe_one failure case
>   - remove unused list of hosts
>   - avoid scsi.h usage all over driver
>   - mention the updates in the README file

I built and tried this out this morning.  It seems to be working OK.
One thing, though, there is warning now in:

drivers/scsi/aacraid/aachba.c: In function `aac_send_srb_fib':
drivers/scsi/aacraid/aachba.c:1409: warning: `flag' might be used uninitialized in this function

Although it seems that the compiler should notice that all the enum
values are accounted for in the switch statement that sets flag.

Mark.
>  
-- 
Mark Haverkamp <markh@osdl.org>

