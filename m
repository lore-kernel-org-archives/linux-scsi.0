From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/5] convert st to use scsi_execte_async
Date: Mon, 19 Sep 2005 14:22:53 -0500
Message-ID: <432F100D.7050007@cs.wisc.edu>
References: <1126845599.9276.44.camel@max>  <Pine.LNX.4.61.0509171428410.9258@kai.makisara.local>  <432C39BC.1030105@cs.wisc.edu>  <432C3C75.5090405@cs.wisc.edu>  <1126974325.10413.5.camel@max>  <Pine.LNX.4.61.0509181456370.14776@kai.makisara.local>  <432D81BD.9080803@cs.wisc.edu> <432D8515.9010809@cs.wisc.edu>  <Pine.LNX.4.61.0509182031090.15507@kai.makisara.local> <1127061365.800.1.camel@max> <432D97F2.5040508@cs.wisc.edu> <Pine.LNX.4.61.0509182155350.15507@kai.makisara.local> <432D9D53.3070706@cs.wisc.edu> <Pine.LNX.4.61.0509192040360.4404@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:61910 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932596AbVISTXB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Sep 2005 15:23:01 -0400
In-Reply-To: <Pine.LNX.4.61.0509192040360.4404@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

Kai Makisara wrote:
> 
> st sends the command using a buffer of one segment. The command is passed 
> to the HBA driver and it sees 8 segments. Clustering seems to work 
> properly (the maximum segment size is set to 65536 bytes by default). 
> 
> Here is what is seen when the block size is increased to 513 kB:
> dd if=tdata of=/dev/nst0 bs=513k count=1
> 
> The dd process hangs in device wait. It turns out that 
> scsi_execute_async() fails. This is an async write and the process later 
> waits for the failed write to finish. The patch at the end of this message 
> fixes this st bug (don't worry about the line shifts, I have some 
> debugging printks in this driver).
> 
> The real problem is that scsi_execute_async() fails. The 513 kB request is 
> 129 pages. Could the reason be related to these defaults in include/linux?
> #define MAX_PHYS_SEGMENTS 128
> #define MAX_HW_SEGMENTS 128
> 

Yeah I think this is due to the MAX_PHYS_SEGMENTS limit. The hw segments 
is set by scsi_lib in scsi_alloc_queue and is the sg_tablesize value on 
the host. Right now all I do is return a error when someone violates one 
of the limits, but I think the right thing to do is have the ULDs take 
some of these values into account when they build their lists. However 
if I do that we will not be able to make large requests since the 
MAX_PHYS_SEGMENTS/SCSI_MAX_PHYS_SEGMENTS will limit them. Umm let me 
rethink.
