From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: scsi_debug issues
Date: 16 Oct 2004 08:12:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1097932370.1962.4.camel@mulgrave>
References: <20041015190154.GA3073@us.ibm.com>
	<4170C505.3000805@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:27873 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268728AbUJPNNX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Oct 2004 09:13:23 -0400
In-Reply-To: <4170C505.3000805@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2004-10-16 at 01:51, Douglas Gilbert wrote:
> So this problem seems related to highmem.
> 
> The attachment is against the current scsi_debug driver
> (at least in lk 2.6.9-rc4). It uses dma_map_sg() and friends
> together with phys_to_virt() which comes highly recommended:
> "in almost all conceivable cases a device driver should not be
> using this function" :-) Could you try the patch.
> 
> Perhaps others my be able to answer this: is setting
> scsi_host_template::dma_boundary (to some figure other
> than 0xffffffff) going to help in this case?

No, the problem is with highmem as you correctly point out, but the
issue is that your driver cannot see beyond it.  On x86, highmem begins
at about 900Mb.  The kernel has no page tables for any memory beyond
this.  In order to see the memory you need to kmap it (i.e. ask the
kernel to create a temporary page table for it); so the virtual address
sg uses should be got by kmapping the pages in the sg list:

kaddr = kmap(sg[i].page) + sg[i].offset

If you make sure clustering is disabled, you should never get multiple
pages in the initial sg list.

When you've finished you need to release the mapping with kunmap().

There are also atomic versions of these depending on where you are.

James


