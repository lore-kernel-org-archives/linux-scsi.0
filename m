From: Takayoshi Kochi <t-kochi@bq.jp.nec.com>
Subject: Re: [PATCH] qla1280.c /proc/scsi/qla1280/x reads garbage
Date: Mon, 07 Feb 2005 10:13:50 +0900 (JST)
Message-ID: <20050207.101350.21926396.t-kochi@bq.jp.nec.com>
References: <20050204.202110.59656828.t-kochi@bq.jp.nec.com>
	<20050204112730.GA18895@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Received: from TYO202.gate.nec.co.jp ([202.32.8.202]:217 "EHLO
	tyo202.gate.nec.co.jp") by vger.kernel.org with ESMTP
	id S261329AbVBGBOO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Feb 2005 20:14:14 -0500
In-Reply-To: <20050204112730.GA18895@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: jes@wildopensource.com, linux-scsi@vger.kernel.org

Hi,

From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] qla1280.c /proc/scsi/qla1280/x reads garbage
Date: Fri, 4 Feb 2005 11:27:30 +0000

> > In 2.6.11-rc3, reading /proc/scsi/qla1280/0 sometimes spits garbage.
> > This is because in qla1280_proc_info() the returned pointer to
> > the buffer isn't what the upper layer expects.
> > 
> > This problem seems already fixed in 2.4 series (I checked 2.4.28).
> > 
> > Why the fix is missing in 2.6?  This can be lead to a security
> > problem (random kernel memory leaks to userspace).
> > 
> > Patch attached. (compiled and worked for me)
> 
> What about killing qla1280_proc_info completely?  It doesn't
> return any useful information.

I agree with you; if anyone's depending on that info, the bug
should have been noticed earlier.  I'm not a serious
qla1280_proc_info user, either.

But as I was just sending the patch and scsi is not my primary working
area, I'd like to let the scsi maintainers decide whether taking in
the patch or remove the function completely.  I don't want the bug
to be left as is.

---
Takayoshi Kochi
