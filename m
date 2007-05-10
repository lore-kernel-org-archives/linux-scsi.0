From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/4] stex: fix id mapping issue
Date: Thu, 10 May 2007 15:59:45 -0500
Message-ID: <1178830785.3712.15.camel@mulgrave.il.steeleye.com>
References: <NONAMEB29nIvX6bxu8Y00001141@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:45154 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758179AbXEJU7v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 May 2007 16:59:51 -0400
In-Reply-To: <NONAMEB29nIvX6bxu8Y00001141@nonameb.ptu.promise.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ed Lin <ed.lin@promise.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, jeff <jeff@garzik.org>, hch <hch@infradead.org>, promise_linux <promise_linux@promise.com>

On Wed, 2007-05-09 at 20:50 -0800, Ed Lin wrote:
> The correct internal mapping of stex controllers should be:
> id:0~15, lun:0~7 (st_shasta)
> id:0, lun:0~127 (st_yosemite)
> id:0~127, lun:0 (st_vsc and st_vsc1)
> 
> This patch reports the internal mapping to scsi mid layer,  eliminating
> the translation between scsi mid layer and firmware. To achieve this
> goal, we also need to:
> -- fail the REPORT_LUNS command for st_shasta because the
>    firmware is known to not report all actual luns
> -- add an entry in scsi_devindo.c to force sequential lun scan
>    (for st_shasta controllers)
> -- fail the REPORT_LUNS command for console device
> -- remove special handling of REPORT_LUNS command for
>    st_yosemite, as there is no translation mapping now
> 
> Signed-off-by: Ed Lin <ed.lin@promise.com>

This looks great, thanks for doing it.  I think it can be slid nicely
into -rc1.

James


