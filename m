From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: [PATCH] cciss: force ignore of responses to unsent scsi commands after kexec reboot
Date: Mon, 18 Jun 2007 16:39:28 -0000
Message-ID: <226E1C65E4F6164E8EA5FD3CC913AE8C015CF43A@G3W0639.americas.hpqcorp.net>
References: <20070614153119.GC32137@hmsreliant.homelinux.net> <226E1C65E4F6164E8EA5FD3CC913AE8C0156B740@G3W0639.americas.hpqcorp.net> <20070614192523.GB1110@hmsreliant.homelinux.net> <20070618043037.GA14758@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas04.cce.hp.com ([161.114.21.107]:39547 "EHLO
	ccerelbas04.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbXFRQjb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jun 2007 12:39:31 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070618043037.GA14758@in.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vgoyal@in.ibm.com, Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, ISS StorageDev <iss_storagedev@hp.com>, akpm@linux-foundation.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

Vivek wrote: 

> 
> I think this is not the right usage of reset_devices 
> parameter. This parameter instructs the driver to reset the 
> device before going ahead with rest of the initialization 
> before as underlying device might not be in a sane state. 
> kexec/kdump is one of the usages and this can also be useful 
> in the case of BIOS not doing its job.
> 
> When I had proposed crash_boot parameter for kexec/kdump 
> purposes, that time andrew had suggested that he is afraid 
> that driver authors will use this parameter to solve all kind 
> of problems. 
> 
> I think we should stick to the theme of the parameter and 
> implement the reset routine for cciss driver instead of 
> simply returning back. Consider the case of hypothetical 
> scenario where somebody booted the kernel with reset_device 
> parameter (because of unreliable bios) and if there is a 
> problem on kernel side that after it issues the command it 
> lost track of that (because of kernel bug) then driver will 
> never catch that bug as upon receiving the response it will 
> simply ignore that.
> 
> Mike, you know most about this device. Can you please help 
> out with implementing a reset routing for it?
> 
Vivek
I think I finally have an idea that will work. (`bout time!) We actually
have 2 different issues. One is that there may outstanding commands on
the controller when the kdump kernel initializes. Our SAS controllers
support the reset message defined in the open CISS spec which will
(hopefully) resolve this issue. The second problem is that I cannot
allocate my MSI-X vectors because I couldn't free the vectors then
disable MSI. So the cciss driver would most likely panic at that time.
My idea for this is to put the card into INTx mode rather than MSI or
MSI-X. That should the 2nd issue.
I haven't tested the 64xx series to see if they support the reset
message. I should to write the code today, maybe test by tomorrow and
then send something upstream.

mikem
