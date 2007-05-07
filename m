From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 25/30] scsi: fix CONFIG_SCSI_WAIT_SCAN=m
Date: Mon, 07 May 2007 14:49:35 -0500
Message-ID: <1178567375.3729.42.camel@mulgrave.il.steeleye.com>
References: <200704260735.l3Q7ZSG5024284@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:43280 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754875AbXEGTuJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 May 2007 15:50:09 -0400
In-Reply-To: <200704260735.l3Q7ZSG5024284@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, hugh@veritas.com

On Thu, 2007-04-26 at 00:35 -0700, akpm@linux-foundation.org wrote:
> From: Hugh Dickins <hugh@veritas.com>
> 
> CONFIG_MODULES=y
> CONFIG_SCSI=y
> CONFIG_SCSI_SCAN_ASYNC=y
> CONFIG_SCSI_WAIT_SCAN=m
> 
> 2.6.21-rc5-mm2 VFS panics unable to find my root on /dev/sda2, but boots
> okay if I change drivers/scsi/Kconfig to "default y" instead of "default m"
> for SCSI_WAIT_SCAN.
> 
> Make sure there's a late_initcall to scsi_complete_async_scans when it's
> built in, so a monolithic SCSI_SCAN_ASYNC kernel can rely on the scans
> being completed before trying to mount root, even if they're slow.

This isn't the right fix ... this has to be invoked last in the call
sequence ... I can't see another way of doing this except yet another
file added as a final component to the link.

James


