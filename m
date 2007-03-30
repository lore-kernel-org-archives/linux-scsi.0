From: Vivek Goyal <vgoyal@in.ibm.com>
Subject: Re: [Fastboot] Panics for AACRAID driver during 'insmod' for kexec test.
Date: Fri, 30 Mar 2007 11:35:45 +0530
Message-ID: <20070330060545.GA16248@in.ibm.com>
References: <20070329031156.GA9582@in.ibm.com> <AE4F746F2AECFC4DA4AADD66A1DFEF017A9C85@otce2k301.adaptec.com>
Reply-To: vgoyal@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:56571 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552AbXC3GGv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Mar 2007 02:06:51 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2U66nM6014006
	for <linux-scsi@vger.kernel.org>; Fri, 30 Mar 2007 02:06:49 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2U66nb6260336
	for <linux-scsi@vger.kernel.org>; Fri, 30 Mar 2007 02:06:49 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2U66m6W004034
	for <linux-scsi@vger.kernel.org>; Fri, 30 Mar 2007 02:06:49 -0400
Content-Disposition: inline
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF017A9C85@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Judith Lebzelter <judith@linux-foundation.org>, linux-scsi@vger.kernel.org, AACRAID <aacraid@adaptec.com>, fastboot@lists.osdl.org

On Thu, Mar 29, 2007 at 10:17:18AM -0400, Salyzyn, Mark wrote:
> I have been working on a patch to the driver to do just this, reset the
> adapter during init if necessary. We want to limit the adapter's reset
> as it takes time (an additional 45 seconds or longer) for the Firmware
> to cycle... I will bump the priority of the testing for this patch.
> 
Hi,

Thanks for looking into this. You can make device reset conditional. Now
one command line parameter "reset_devices" has been defined for the kernel.
You can reset the device only if the user has passed reset_devices command
line option otherwise you can continue to boot normaly.

I have introduced this parameter to handle the concern that in normal
BIOS boot total boot time will increase.

kexec/kdump will pass this parameter to second kernel so that device will
be reset during initialization and normal BIOS boot will reamin unaffected.

Thanks
Vivek
