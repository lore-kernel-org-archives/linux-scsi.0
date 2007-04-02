From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: SMP pass through interface via bsg
Date: Tue, 3 Apr 2007 02:54:10 +0900 (JST)
Message-ID: <20070402221349L.fujita.tomonori@lab.ntt.co.jp>
References: <20070403012747O.fujita.tomonori@lab.ntt.co.jp>
	<20070403014349E.fujita.tomonori@lab.ntt.co.jp>
	<1175533302.3680.31.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:42318 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbXDBRyb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Apr 2007 13:54:31 -0400
In-Reply-To: <1175533302.3680.31.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: fujita.tomonori@lab.ntt.co.jp, hch@infradead.org, dougg@torque.net, James.Smart@Emulex.Com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: SMP pass through interface via bsg
Date: Mon, 02 Apr 2007 12:01:41 -0500

> On Tue, 2007-04-03 at 01:43 +0900, FUJITA Tomonori wrote:
> > OK. I found another bug in smp_test tool (sends bogus response buffer
> > len to kernel). I've uploaded a new patch:
> > 
> > http://zaal.org/bsg/smp-test2.diff
> 
> That sort of works; you have a final bug in that the manufacturer info
> response frame is 64 bytes, not 128 bytes, but with that corrected
> everything goes through and I get the result back:
> 
> hobholes:~# /home/jejb/git/sgv4-tools/smp_test /sys/class/bsg/expander-2\:0
>   SAS-1.1 format: 0
>   vendor identification: LSILOGIC
>   product identification: SASx12 A.0      
>   product revision level: 
> 
> So we can class this one as a success ... 
>
> Thanks!

Great! Thanks. I'll try to finish the mpt driver's hook
sometime. Finally, We have a bsg user (though it also needs proper
bidi support).

Jens, what remains to be done before bsg is merged into mainline?
