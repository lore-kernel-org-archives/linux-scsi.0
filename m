From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH] 2.6 aacraid: endian cleanup
Date: Tue, 29 Mar 2005 08:49:33 -0800
Message-ID: <1112114974.16948.13.camel@markh1.pdx.osdl.net>
References: <1111430484.9918.9.camel@markh1.pdx.osdl.net>
	 <20050328215931.GB14148@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:47837 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261229AbVC2Qtn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Mar 2005 11:49:43 -0500
In-Reply-To: <20050328215931.GB14148@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Mon, 2005-03-28 at 22:59 +0100, Christoph Hellwig wrote:
> On Mon, Mar 21, 2005 at 10:41:23AM -0800, Mark Haverkamp wrote:
> > A patch from Adaptec with byte order changes:
> >  - drop byte swapping on all 0's and all 1's content
> >  - fix up missing swapping directives
> >  - ensure swapping on 16 bit values does not use 32 bit swap
> >  - reconcile the readl/writel auto-swapping in only most of the
> > configurations.
> 
> that last bit is bogus.  readl/writel are defined to swap bytes on
> big endian systems.  Whatever broken Mvista/Windriver or whatever port
> doesn't do that should be fixed.
> 
> Also please remove unrelated changes like the new cardtypes from the patch,
> follow normal kernel codingstyle (e.g. ||, && at the end of the line) and
> switch to __le* types for harware structures and make sure it's passing
> sparse -Wbitwise.

I ran sparse on the driver and without the -Wbitwise, it only has 7
warnings such as:

CHECK   drivers/scsi/aacraid/linit.c
drivers/scsi/aacraid/linit.c:218:12: warning: symbol 'aac_info' was not declared. Should it be static?

With -Wbitwise there are about 200 warnings of this sort:
drivers/scsi/aacraid/aachba.c:180:18: warning: incorrect type in assignment (different base types)
drivers/scsi/aacraid/aachba.c:180:18:    expected unsigned int [unsigned] [usertype] command
drivers/scsi/aacraid/aachba.c:180:18:    got restricted unsigned int [usertype] [force] <noident>

What is your preference,  I could clean up the existing patch and re-
submit and then address the sparse warnings with a follow-up patch.  Or
try to fix everything in one patch.

Thanks,
Mark.

-- 
Mark Haverkamp <markh@osdl.org>

