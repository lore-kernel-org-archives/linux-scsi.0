From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/4] stex: fix id mapping issue
Date: Thu, 10 May 2007 17:03:21 -0400
Message-ID: <46438899.3020001@garzik.org>
References: <NONAMEB29nIvX6bxu8Y00001141@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:60337 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762157AbXEJVDY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 May 2007 17:03:24 -0400
In-Reply-To: <NONAMEB29nIvX6bxu8Y00001141@nonameb.ptu.promise.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ed Lin <ed.lin@promise.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "james.Bottomley" <james.Bottomley@SteelEye.com>, hch <hch@infradead.org>, promise_linux <promise_linux@promise.com>

Ed Lin wrote:
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

ACK patches 1-4, but some suggestions will follow


