From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: iSCSI device naming issues
Date: Thu, 1 Jul 2004 08:57:14 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040701155714.GA7172@us.ibm.com>
References: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAANoIxZIFzbEaqwjJgytz2AeKAAAAQAAAAXdSfMOoTnU6X86O4sbqWzAEAAAAA@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:60596 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S265928AbUGAP5o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2004 11:57:44 -0400
Content-Disposition: inline
In-Reply-To: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAANoIxZIFzbEaqwjJgytz2AeKAAAAQAAAAXdSfMOoTnU6X86O4sbqWzAEAAAAA@cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: "Surekha.PC" <surekhap@cisco.com>
Cc: 'SCSI Mailing List' <linux-scsi@vger.kernel.org>

Surekha.PC [surekhap@cisco.com] wrote:
> 1) Having an iSCSI pseudo bus.
> This will create a fake iscsi bus as "/sys/bus/iscsi" and all devices
> will be under this pseudo bus. This can be used to lookup iSCSI
> devices. I don't see any other use of this fake bus. Is it still
> ok to pursue with this approach?
>  

This sounds like the wrong approach.

> 2) Having an attribute for iSCSI host which displays the name of
> iSCSI driver as shown:
> 
> $cat /sys/class/scsi_host/hostX/hostname
> "iSCSI SFnet Driver"

If you set proc_name in your template this value will show up under
/sys/class/scsi_host/host<n>/proc_name.

> 3) Make use of scsi_id.
> scsi_id can be used to get unique name instead of parsing sysfs
> path for device name creation. However scsi_id is helpful only
> for block devices, and there is no way to handle unique naming
> for tape devices. So this will not make a complete solution.

Well you can still setup a udev rule to use scsi_id for you block
devices and then use location naming for the tapes ( some newer
generation tape drives also support serial numbers).

-andmike
--
Michael Anderson
andmike@us.ibm.com

