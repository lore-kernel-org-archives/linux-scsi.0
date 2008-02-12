From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: [Scst-devel] Integration of SCST in the mainstream Linux kernel
Date: Tue, 12 Feb 2008 17:05:20 +0100
Message-ID: <e2e108260802120805v4c8e07d6if59c881213c4ae97@mail.gmail.com>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org>
	 <1202151989.11265.576.camel@haakon2.linux-iscsi.org>
	 <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org>
	 <20080204224314.113afe7b@core> <47A79A10.4070706@garzik.org>
	 <47A8B29B.8050406@vlnb.net> <47A8B510.8000807@garzik.org>
	 <47A8B757.10101@vlnb.net>
	 <1202256667.2220.83.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.187]:24118 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223AbYBLQFX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Feb 2008 11:05:23 -0500
Received: by rn-out-0910.google.com with SMTP id i24so6699697rng.19
        for <linux-scsi@vger.kernel.org>; Tue, 12 Feb 2008 08:05:21 -0800 (PST)
In-Reply-To: <1202256667.2220.83.camel@haakon2.linux-iscsi.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, scst-devel@lists.sourceforge.net, Andrew Morton <akpm@linux-foundation.org>

On Feb 6, 2008 1:11 AM, Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
> I have always observed the case with LIO SE/iSCSI target mode ...

Hello Nicholas,

Are you sure that the LIO-SE kernel module source code is ready for
inclusion in the mainstream Linux kernel ? As you know I tried to test
the LIO-SE iSCSI target. Already while configuring the target I
encountered a kernel crash that froze the whole system. I can
reproduce this kernel crash easily, and I reported it 11 days ago on
the LIO-SE mailing list (February 4, 2008). One of the call stacks I
posted shows a crash in mempool_alloc() called from jbd. Or: the crash
is most likely the result of memory corruption caused by LIO-SE.

Because I was curious to know why it took so long to fix such a severe
crash, I started browsing through the LIO-SE source code. Analysis of
the LIO-SE kernel module source code learned me that this crash is not
a coincidence. Dynamic memory allocation (kmalloc()/kfree()) in the
LIO-SE kernel module is complex and hard to verify. There are 412
memory allocation/deallocation calls in the current version of the
LIO-SE kernel module source code, which is a lot. Additionally,
because of the complexity of the memory handling in LIO-SE, it is not
possible to verify the correctness of the memory handling by analyzing
a single function at a time. In my opinion this makes the LIO-SE
source code hard to maintain.
Furthermore, the LIO-SE kernel module source code does not follow
conventions that have proven their value in the past like grouping all
error handling at the end of a function. As could be expected, the
consequence is that error handling is not correct in several
functions, resulting in memory leaks in case of an error. Some
examples of functions in which error handling is clearly incorrect:
* transport_allocate_passthrough().
* iscsi_do_build_list().

Bart Van Assche.
