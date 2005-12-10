From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Ang: Re: [Stgt-devel] Re: [Iscsitarget-devel] stgt a new
 version of iscsi target?
Date: Sat, 10 Dec 2005 17:46:58 +0900
Message-ID: <20051210174658I.fujita.tomonori@lab.ntt.co.jp>
References: <43987F75.2000301@vlnb.net>
	<4398850D.8070102@cs.wisc.edu>
	<4399A2BA.1070505@vlnb.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:36566 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP id S965087AbVLJItU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Dec 2005 03:49:20 -0500
In-Reply-To: <4399A2BA.1070505@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vst@vlnb.net
Cc: michaelc@cs.wisc.edu, johan@capvert.se, iscsitarget-devel@lists.sourceforge.net, mingz@ele.uri.edu, stgt-devel@lists.berlios.de, WRWHITEHEAD@novell.com, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, hch@infradead.org

From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Ang: Re: [Stgt-devel] Re: [Iscsitarget-devel] stgt a new version of iscsi target?
Date: Fri, 09 Dec 2005 18:28:58 +0300

> > Also is the page cache comment in reference to us using the page cache 
> > for our reads and writes or I am not sure why you wrote that if you do 
> > not do it right now.
> 
> Hm, at first, the page cache already used somehow in fileio dev handler 
> (though, with additional mem copy). At the second, fully utilize the 
> page cache is one of two major improvements that are pending in scst, 
> because it is required changing the kernel, which until some moment try 
> to avoid. Although I prepared what is necessary for that.
> 
> The idea basically is the following. When READ operation arrives, pages 
> for all requested blocks are at first searched in the page cache 
> (probably, in SIRQ context, because it isn't expensive operation) and if 
> all pages are found, they are referenced and the result will be sent to 
> the initiator. Then the pages will be dereferenced (so, no pages 
> allocation will be done at all). Otherwise, the missed pages will be 
> allocated and the command will be rescheduled to the thread, which will 
> read them. Then, after the response is sent, the pages will remain in 
> the page cache for future accesses. For WRITEs the processing is the 
> similar, the pages with the data will be put in the page cache.

The Ardis iSCSI target code does the same thing.
