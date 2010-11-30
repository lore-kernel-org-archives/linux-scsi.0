From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: After memory pressure: can't read from tape anymore
Date: Tue, 30 Nov 2010 21:53:33 +0200 (EET)
Message-ID: <alpine.LNX.2.00.1011302139460.9731@kai.makisara.local>
References: <1290971729.2814.13.camel@larosa>  <alpine.LNX.2.00.1011291857420.7923@kai.makisara.local> <1291123886.2181.1347.camel@quux.techfak.uni-bielefeld.de> <4CF521DE.7020800@panasas.com> <alpine.LNX.2.00.1011301821210.9731@kai.makisara.local>
 <4CF52A03.2000704@panasas.com> <alpine.LNX.2.00.1011301853300.9731@kai.makisara.local> <4CF53349.10509@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs12.mail.saunalahti.fi ([195.197.172.107]:39355 "EHLO
	vs12.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793Ab0K3Txo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2010 14:53:44 -0500
In-Reply-To: <4CF53349.10509@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Lukas Kolbe <lkolbe@techfak.uni-bielefeld.de>, linux-scsi@vger.kernel.org

On Tue, 30 Nov 2010, Boaz Harrosh wrote:

...
> I looked at enlarge_buffer() and it looks fragile and broken. If you really
> need a pointer eg:
> 	STbuffer->b_data = page_address(STbuffer->reserved_pages[0]);
> 
If you think it is broken, please fix it.

> Than way not use vmalloc() for buffers larger then PAGE_SIZE? But better yet
> avoid it by keeping a pages_array or sg-list and operate on an aio type
> operations.
> 
vmalloc() is not a solution here. Think about this from the HBA side. Each 
s/g segment must be contiguous in the address space the HBA uses. In many 
cases this is the physical memory address space. Any solution must make 
sure that the HBA can perform the requested data transfer.

> > Kai
> 
> But I understand this is a lot of work on an old driver. Perhaps pre-allocate
> something big at startup. specified by user?
> 
This used to be possible at some time and it could be made possible again. 
But I don't like this option because it means that the users must 
explicitly set the boot parameters.

And it is difficult for me to believe the modern SAS HBAs only support 128 
s/g segments.

Kai
