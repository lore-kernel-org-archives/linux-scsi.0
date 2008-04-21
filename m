From: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Subject: Re: PATCH: 64 bit support for dpt_i2o driver (take 2)
Date: Mon, 21 Apr 2008 14:47:27 -0400
Message-ID: <C4F0B40B-F679-45EE-9153-543FAAB2E909@adaptec.com>
References: <xs4all.20080418215937.GA15199@xs4all.net> <E1JnKNB-00049W-OY@n2o.xs4all.nl>
Mime-Version: 1.0 (Apple Message framework v919.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:59723 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381AbYDUSr3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Apr 2008 14:47:29 -0400
In-Reply-To: <E1JnKNB-00049W-OY@n2o.xs4all.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-Scsi <linux-scsi@vger.kernel.org>
Cc: Miquel van Smoorenburg <miquels@cistron.nl>

Good catch on round two,

ACK

-- Mark Salyzyn

On Apr 19, 2008, at 5:13 PM, Miquel van Smoorenburg wrote:

> This is an update for the patch I sent two days ago. It appears
> that on some hardware the debug registers are not mapped into
> the same range as the standard registers, so we need an
> extra ioremap() call for them.
>
> Please consider this for 2.6.26.
>
> # --
>
> I've been running supermicro hardware with the Adaptec 2005/2010/2015
> zero channel raid controllers for a long while. The dpt_i2o driver
> in the kernel doesn't support 64-bit mode, yet I wanted to run
> a 64-bit system. The i2o_block driver wasn't 64-bit capable either.
> Mark Salyzyn from Adaptec kindly provided me with a 64-bit version
> of the dpt_i2o driver, unfortunately it never made its way to
> the upstream kernel.
>
> In my experience, the dpt_i2o driver is rock-stable for the
> Adaptec ZCR hardware, while the i2o_block driver isn't.
> Because the dpt_i2o driver is still in the kernel and actively
> being used, I decided to merge the essential 64 bits parts
> of the alternative driver into the current kernel dpt_i2o driver.
>
> # --------- dpt_i2o-64bit-2.6.25.patch ----------------
>
> This patch is an update for drivers/scsi/dpt_i2o.c.
> It applies to both 2.6.24.4 and 2.6.25
>
> It contains the following changes:
>
> * 64 bit code based on unofficial Adaptec 64 bit driver
> * removes scsi_module.c dependency, adds module_init / module_exit
>  this is needed because we need to pass the proper device to
>  scsi_add_host(), and the scsi_module.c passes NULL. With NULL,
>  code like arch/x64/kernel/pci-gart_64.c::need_iommu() crashes
>  because the dev pointer it is passed is NULL.
> * adds sysfs entry for /sys/class/dpt_i2o/dptiX so that udev
>  can create /dev/dptiX dynamically
>
> Obviously there are more cleanups that can be done to this code,
> but we need to start somewhere. Patch has been tested heavily on
> both 32 and 64 bit x86 platforms.
>
> Signed-off-by: Miquel van Smoorenburg <miquels@cistron.nl>
>

