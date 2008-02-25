From: Daniel Drake <dsd@gentoo.org>
Subject: Re: Patch added to scsi-rc-fixes-2.6:  [SCSI] arcmsr: fix message
 allocation
Date: Mon, 25 Feb 2008 10:14:30 +0000
Message-ID: <47C29506.4000609@gentoo.org>
References: <001401c87753$3edf4670$8800a8c0@Nick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from probity.mcc.ac.uk ([130.88.200.94]:60505 "EHLO
	probity.mcc.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbYBYKMK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Feb 2008 05:12:10 -0500
In-Reply-To: <001401c87753$3edf4670$8800a8c0@Nick>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nick.cheng@areca.com.tw
Cc: 'James Bottomley' <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

nickcheng wrote:
> Hi,
> I definitely agree it is in atomic context but why is the memory not for
> DMA?
> Would you please show me why?

It would probably be easier if you could explain where you believe the 
memory IS used for DMA :)

Anyway, looking at ARCMSR_MESSAGE_READ_RQBUFFER
current code does this:
		ver_addr = kmalloc(1032, GFP_ATOMIC);

Here are the cases when that buffer is used:

checking for successful malloc: not DMA
		if (!ver_addr) {

copying the address: not DMA
		ptmpQbuffer = ver_addr;

memcpying 1 byte into the buffer: not DMA
			memcpy(ptmpQbuffer, pQbuffer, 1);

incrementing address: not DMA
			ptmpQbuffer++;

memcpying from the buffer: not DMA
		memcpy(pcmdmessagefld->messagedatabuffer, ver_addr, allxfer_len);

freeing the buffer: not DMA
		kfree(ver_addr);

Daniel
