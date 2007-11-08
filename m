From: James Pearson <james-p@moving-picture.com>
Subject: Re: LTO-3 read performance issues
Date: Thu, 08 Nov 2007 15:10:07 +0000
Message-ID: <473326CF.8060102@moving-picture.com>
References: <4731D72D.5000404@moving-picture.com> <alpine.LSU.0.9999.0711072022370.7663@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mpc-26.sohonet.co.uk ([193.203.82.251]:37115 "EHLO
	moving-picture.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752087AbXKHPKJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Nov 2007 10:10:09 -0500
In-Reply-To: <alpine.LSU.0.9999.0711072022370.7663@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

Kai Makisara wrote:
>>
>>I am using the default st module options and not doing anything other than
>>using 'mt setblk 0'.
>>
>>Is there anything I can do to get a decent, sustained read rate from these
>>tapes?
>>
> 
> If your system can process the data fast enough and the tape blocks are of 
> the same size, you can try using fixed block mode and buffered transfers. 
> This allows the driver to use larger SCSI reads. You have to load the st 
> module with parameter buffer_kbs=xxx, where xxx is, for instance, 1024 (1 
> MB buffer). You also have to disable direct i/o with the module parameter
> try_direct_io=0 (otherwise buffered transfers are disabled).

Thanks, I tried that, but it makes no difference. I also tried 
increasing the buffer_kbs size by doubling it a few times, but that made 
no difference either

I have now found out that the tapes were written on an SGI system - 
using a fixed block device and the default options to tar. However, I 
have to either use 'mt setblk 0' or 'mt setblk 16384' to read anything 
from these tapes.

Just to check that nothing is wrong with my system, I can read an LTO-3 
tape previously written on my system, using the default options to tar 
and the st module - and I get over 40Mb/s on reads, compared with about 
400Kb/s I'm getting with these problematic tapes ...

Is there anything else I can do to read these tapes at a decent speed?

Thanks

James Pearson


