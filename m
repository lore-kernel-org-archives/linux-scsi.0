From: Aboo Valappil <aboo@aboo.org>
Subject: Linux Virtual SCSI HBAs and Virtual disks
Date: Fri, 26 Jan 2007 09:02:54 +1100
Message-ID: <45B9290E.7020801@aboo.org>
References: <1e157f74d8578f24c762571c1016aab3@aboo.org>	<b43c8fc9882e65d397a6465e6cb7c998@aboo.org>	<45B4EAAC.5000008@s5r6.in-berlin.de>	<45B60993.9070508@aboo.org> <20070123083627.9b4ddfe3.randy.dunlap@oracle.com> <45B64465.7000507@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ppp245-155.static.internode.on.net ([59.167.245.155]:43183 "EHLO
	goobu.aboo.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030619AbXAYWDg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jan 2007 17:03:36 -0500
In-Reply-To: <45B64465.7000507@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, dougg@torque.net, linux-scsi@vger.kernel.org

Hi All,

Thanks for all your encouragement and help on this project. I like to 
take this project one step ahead. I hope you can help me on this.

As you may have noticed, I am doing a copy of buffers ( request_buffer) 
between user space and kernel space. What are my options these days to 
make a user buffer access inside the kernel space and vice versa? Please 
also not that request_buffer is not a linear buffer it is  a sg :)

One option I researched was mmap. I am facing an issue here. I will try 
to explain. Everything seems to be working, but a big page table 
manipulation issue is found.

When a SCSI read comes in for a device (For eg: dd if=/dev/sda 
of=/dev/null count=1). A read is always accompanied by a write (I do not 
do this, but the kernel does it!).

I think the pages of "request_buffer" will get mapped to virtual memory  
of "dd" process.When I memmap request_buffer (Through mmap_nopage 
method) to "user space SCSI target", the same page of "dd" process gets 
mapped to "user space SCSI target". Since the operation is a read, the 
"user space target" modifies the page making it dirty as far as "page 
cache" is concerned. Of course, "dd" gets what it wants from read. But 
as soon as "dd" closes "/dev/sda", page cache knows that one of the page 
belong to "/dev/sda" is dirty and needs to be flushed to disk!. Now, the 
page cache issues a SCSI write for the same page through the SCSI 
driver. This makes all the SCSI reads accompanied by a SCSI write.

This is the most closest explanation i can come up with for the 
behaviour. If this explanation is correct or not, it is happening (A 
SCSI read following by a SCSI write).

If this has to work properly, I need to find a way of "memmap/user space 
target" to modify the pages silently without letting the page cache know 
about it. There could be some ugly page table manipulation. But I am 
wondering if this can be achieve easily or through some other way. One 
of my friend also told me about the splice option.... Any thoughts on this?

Aboo



