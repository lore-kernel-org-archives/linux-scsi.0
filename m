From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Stop using num_physpages in aacraid
Date: Fri, 09 May 2008 09:28:57 -0500
Message-ID: <1210343337.3069.9.camel@localhost.localdomain>
References: <20080502185227.GN14976@parisc-linux.org>
	 <CA69411A-909E-4161-A4E3-FC86246CDA22@adaptec.com>
	 <20080503105135.GY14976@parisc-linux.org>
	 <1210281511.3114.72.camel@localhost.localdomain>
	 <FD415073-DC5F-426F-8ADD-09CF96C6917D@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48423 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751089AbYEIO3B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 May 2008 10:29:01 -0400
In-Reply-To: <FD415073-DC5F-426F-8ADD-09CF96C6917D@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Cc: Matthew Wilcox <matthew@wil.cx>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2008-05-09 at 02:39 -0400, Mark Salyzyn wrote:
> ACK
> 
> with comment, I had chosen to perform the sizeof check as it optimized  
> out the code on the 32 bit platforms and could have merged the  
> aac_scsi_32_64 and aac_scsi_32 functions (such considerations are my  
> penance for writing peephole optimizers and BIOS code in C/C++). Never  
> sacrifice clarity/maintainability for optimization if you can afford it.

Yes ... I wish there were some way of getting the 

dma_get_required_mask() > DMA_32BIT_MASK

to compile out in the 32 bit case.  I'll think about it.


Another thing to note is that your problem could be solved if we could
adjust the queue mask per device (you want a 64 bit mask for the raid
devices and a 32 bit one for the physical ones).  This is analagous to
the ATA MDMA problem with ATA/ATAPI (the protocol can only do 32 bits
with ATAPI but the full 64 bits with ATA).  I'll see if we can use this
as a case to drive a fix for that.

James


