From: "Grant Grundler" <grundler@google.com>
Subject: Re: Intel IOMMU (and IOMMU for Virtualization) performances
Date: Fri, 6 Jun 2008 14:51:17 -0700
Message-ID: <da824cf30806061451p4005a4ecoa9af8687e3ec51e5@mail.gmail.com>
References: <20080604235053K.fujita.tomonori@lab.ntt.co.jp>
	 <da824cf30806041106p1de2355fg38594fcb9dcbf203@mail.gmail.com>
	 <20080606202119.GQ15085@il.ibm.com>
	 <da824cf30806061428t4b7ed816i74d961946d77c88b@mail.gmail.com>
	 <20080606213659.GC15085@il.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:53314 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933498AbYFFVvd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2008 17:51:33 -0400
Received: from spaceape9.eur.corp.google.com (spaceape9.eur.corp.google.com [172.28.16.143])
	by smtp-out.google.com with ESMTP id m56LpJnl020947
	for <linux-scsi@vger.kernel.org>; Fri, 6 Jun 2008 22:51:19 +0100
Received: from wf-out-1314.google.com (wfg24.prod.google.com [10.142.7.24])
	by spaceape9.eur.corp.google.com with ESMTP id m56Losjv032579
	for <linux-scsi@vger.kernel.org>; Fri, 6 Jun 2008 22:51:18 +0100
Received: by wf-out-1314.google.com with SMTP id 24so1156375wfg.2
        for <linux-scsi@vger.kernel.org>; Fri, 06 Jun 2008 14:51:18 -0700 (PDT)
In-Reply-To: <20080606213659.GC15085@il.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, mgross@linux.intel.com, linux-scsi@vger.kernel.org

On Fri, Jun 6, 2008 at 2:36 PM, Muli Ben-Yehuda <muli@il.ibm.com> wrote:
...
> The logic seems pretty simple to me, all we need to do is keep track
> of how many entries are currently allocated in the bitmap vs. the size
> of the bitmap. Once we get to the half-way point, double the size of
> the bitmap.

"half-full" would be one hueristic but others might be more suitable
(e.g. wait until it's
nearly full or bitmap search fails).

> Having said that, I'm not sure it's worth it, and have no
> plans to implement it :-)

The historical DMA mapping "failure mode" is a kernel panic.  Resizing or
creating  a new IOMMU page table would avoid a panic, my guess is people
would prefer _anything_ that avoids a panic. :) Especially in the context of
Virtual Machines and multiply guests.

And I'm not exposed to this problem (yet)...I expect Mark Gross
(Intel) is on the
hook for this and has access to all the documentation.

I'll let him thank you for suggesting more work. :P

thanks,
grant
