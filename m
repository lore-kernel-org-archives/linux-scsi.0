From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [RFC] Remove of ISA pools, and Lazy sense allocation.
Date: Thu, 8 May 2008 00:43:30 +0900
Message-ID: <20080508004308U.tomof@acm.org>
References: <48218B24.4000507@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:35917 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752660AbYEGPru (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 May 2008 11:47:50 -0400
In-Reply-To: <48218B24.4000507@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: andi@firstfloor.org, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, bhalevy@panasas.com

On Wed, 07 May 2008 13:57:40 +0300
Boaz Harrosh <bharrosh@panasas.com> wrote:

> Let me please explain a bit on my sense_buffer patchset and where I was going 
> with these:
> 
> Currently every ULD/Initiator that pushes request to block devices puts a sense
> buffer of SCSI_SENSE_BUFFERSIZE size onto request->sense pointer. scsi-midlayer
> shadows that buffer, for what it thought as a DMAable buffer for drivers, and at
> completion of request copies the shadow buffer back into ULD's buffer.
> 
> I have observed three uses of sense_buffer handling in scsi drivers:

I just had a quick look at only some of patches, but where do you
allocate rq->sense for fs requests?


Here are some comments:

scsi_eh: Define API for driver private sense allocation

+struct scsi_sense_elem {
+       union {
+               struct scsi_sense_elem *next;
+               u8 sense_data[SCSI_SENSE_BUFFERSIZE] ____cacheline_aligned;
+       };
+} ____cacheline_aligned;


I think that this is wrong since all the architecutures don't have
such dma restriction. ARCH_KMALLOC_MINALIGN?

There is the same code in The libata patch at least. I guess there are
more.
