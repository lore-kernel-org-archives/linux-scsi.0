From: Aboo Valappil <aboo@aboo.org>
Subject: About sg_tablesize in 2.6 kernel
Date: Sun, 01 Oct 2006 21:22:42 +1000
Message-ID: <451FA502.1070207@aboo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ppp245-155.static.internode.on.net ([59.167.245.155]:24737 "EHLO
	localhost.localdomain") by vger.kernel.org with ESMTP
	id S1751728AbWJALWn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Oct 2006 07:22:43 -0400
Received: from [192.168.1.65] ([192.168.1.65])
	by localhost.localdomain (8.13.1/8.13.1) with ESMTP id k91BHxct029254
	for <linux-scsi@vger.kernel.org>; Sun, 1 Oct 2006 21:17:59 +1000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi All,

I am not sure if this is the right place to ask these questions. I am 
new to this list. Does this list offer any help to device driver 
developers? I appreciate if any one could give an answer to these 
questions.

1. In 2.6 kernel, even if I set the sg_tablesize to SG_NONE, the 
mid-layer is still queuing commands with use_sg=1. There is no way to 
disable this SG at all? I do not need a sg_table as I do not use any DMA 
or anything else. With SG_NONE, the use_sg is always set to 1 and the IO 
size queued by mid layer is only 512 bytes and decreases the throughput 
very badly.

2. One of the challenge I am facing is that the scatterlist structure is 
changed. There is no virtual address, but they replaced this with a page 
and offset fields. Since I need only the virtual addresses for the 
actual buffer (No DMA), I am using the following method to calculate the 
virtual address.

address=page_address(sg[i].page) + sg[i].offset;

Is this the right way? I am assuming that sg[i].page will be mapped in 
to kernel address space as this address is created by SCSI mid-layer. Is 
that right? Or do I have to use kmap? I tried replacing page_address 
with kmap/kunmap. But as soon as call kunmap to unmap, the kernal 
panics! Any thoughts?

3. Do I have to disable bottom halves before calling scsi_done()? It 
seems that the kernel panics when I call scsi_done if I use spin_lock 
instead of spin_lock_bh(). This is one of my spin_locks created for 
protecting a data structure.


Thanks in advance,

Aboo

