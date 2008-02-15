From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: ips.c broken since 2.6.23 on x86_64?
Date: Fri, 15 Feb 2008 14:50:57 -0800
Message-ID: <20080215225057.GA3172@tpepper-t42p.dolavim.us>
References: <20080214235549.GA19591@tpepper-t42p.dolavim.us> <20080215091316H.fujita.tomonori@lab.ntt.co.jp> <20080215011636.GA21124@tpepper-t42p.dolavim.us> <20080216010954M.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:57864 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760337AbYBOWvD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Feb 2008 17:51:03 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1FMoxKp005539
	for <linux-scsi@vger.kernel.org>; Fri, 15 Feb 2008 17:50:59 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1FMoxcb266414
	for <linux-scsi@vger.kernel.org>; Fri, 15 Feb 2008 17:50:59 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1FMowD3023053
	for <linux-scsi@vger.kernel.org>; Fri, 15 Feb 2008 17:50:58 -0500
Content-Disposition: inline
In-Reply-To: <20080216010954M.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, Mark_Salyzyn@adaptec.com

On Sat 16 Feb at 01:09:43 +0900 tomof@acm.org said:
> 
> The first one is just reverting the data buffer accessors
> conversion. It would be nice if we could just revert it but we
> can't. These changes are necessary to compile the driver against post
> 2.6.24.

Fujita-san,

Unfortunately (and not too surprisingly given what we've tried so far) with
only the first of your series reverted the driver is working fine for me
again.

I saw (eg: replies to http://lkml.org/lkml/2007/5/11/132) some possibly
similar sounding issues with other drivers.  Could there be some memory
uninitialised?  I did try changing all the ips.c kmalloc's to kzalloc's,
but that didn't help.  Also that thread ties into pci gart.  The machines
we've been using are liable to getting pci calgary although given my
.config has:
    CONFIG_GART_IOMMU=y
    CONFIG_CALGARY_IOMMU=y
    # CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT is not set
and that when booting this mainline I don't see any Calgary related
messages like I get from eg: Ubuntu's 2.6.22-14-server...I'm probably not
actually running the calgary iommu code in these repros.

Anyway, I greatly appreciate your efforts so far in trying to find what
could be wrong here!

-- 
Tim Pepper  <lnxninja@linux.vnet.ibm.com>
IBM Linux Technology Center
