From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/4] stex: fix id mapping issue(v3)
Date: Wed, 04 Apr 2007 20:05:59 -0500
Message-ID: <1175735159.3693.55.camel@mulgrave.il.steeleye.com>
References: <NONAMEB8v5DkoQ4qcm500000733@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:59732 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752988AbXDEBGD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Apr 2007 21:06:03 -0400
In-Reply-To: <NONAMEB8v5DkoQ4qcm500000733@nonameb.ptu.promise.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ed Lin <ed.lin@promise.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, jeff <jeff@garzik.org>, promise_linux <promise_linux@promise.com>

On Wed, 2007-04-04 at 16:56 -0700, Ed Lin wrote:
> The correct internal mapping of stex controllers should be:
> id:0~15, lun:0~7 (st_shasta)
> id:0, lun:0~127 (st_yosemite)
> id:0~127, lun:0 (st_vsc and st_vsc1)
> 
> Unfortunately we can not use the internal id/lun as scsi
> mid layer id/lun. The Linux kernel has a config option
> CONFIG_SCSI_MULTI_LUN. This option is not selected
> in some major Linux releases. If it is not selected,
> then st_shasta can expose 16 LDs(logical drive)
> at most, while st_yosemite can expose only one LD.
> This is clearly unacceptable.

Erm, there's a simple way out of this:  That's the BLIST_FORCELUN
option.  This is why most of the RAID devices have entries in
scsi_devinfo.c like:

        {"ADAPTEC", "AACRAID", NULL, BLIST_FORCELUN},

Which overrides the CONFIG_SCSI_MULTI_LUN setting for the particular
device.  We can easily add an entry for stex as well.

James


