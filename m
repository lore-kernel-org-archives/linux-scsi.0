From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/4] SCSI, classes, mpt2sas: have
 scsi_internal_device_unblock take new state
Date: Thu, 17 May 2012 10:21:19 +0100
Message-ID: <1337246479.30498.8.camel@dabdike.int.hansenpartnership.com>
References: <1336127004-2358-1-git-send-email-michaelc@cs.wisc.edu>
	 <1336127004-2358-3-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59853 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761464Ab2EQJVY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 May 2012 05:21:24 -0400
In-Reply-To: <1336127004-2358-3-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org

On Fri, 2012-05-04 at 05:23 -0500, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> This has scsi_internal_device_unblock/scsi_target_unblock take
> the new state to set the devices as an argument instead of
> always setting to running. The patch also converts users of these
> functions.
> 
> This allows the FC and iSCSI class to transition devices from blocked
> to transport-offline, so that when fast_io_fail/replacement_timeout
> has fired we do not set the devices back to running. Instead, we
> set them to SDEV_TRANSPORT_OFFLINE.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  drivers/scsi/mpt2sas/mpt2sas_base.h  |    3 +-
>  drivers/scsi/mpt2sas/mpt2sas_scsih.c |    4 +-
>  drivers/scsi/scsi_lib.c              |   40 +++++++++++++++++++--------------
>  drivers/scsi/scsi_priv.h             |    4 ++-
>  drivers/scsi/scsi_transport_fc.c     |   15 ++++++------
>  drivers/scsi/scsi_transport_iscsi.c  |    6 ++--
>  include/scsi/scsi_device.h           |    2 +-
>  7 files changed, 41 insertions(+), 33 deletions(-)

This is failing to apply:

patching file drivers/scsi/mpt2sas/mpt2sas_base.h
patching file drivers/scsi/mpt2sas/mpt2sas_scsih.c
patching file drivers/scsi/scsi_lib.c
Hunk #1 succeeded at 2441 (offset 4 lines).
Hunk #2 succeeded at 2451 (offset 4 lines).
Hunk #3 succeeded at 2515 (offset 4 lines).
patching file drivers/scsi/scsi_priv.h
Hunk #2 succeeded at 173 (offset 2 lines).
patching file drivers/scsi/scsi_transport_fc.c
Hunk #2 FAILED at 2813.
Hunk #3 FAILED at 2880.
Hunk #4 FAILED at 3086.
Hunk #5 succeeded at 3129 (offset 4 lines).
3 out of 5 hunks FAILED -- saving rejects to file
drivers/scsi/scsi_transport_fc.c.rej

Could you rebase?

Thanks,

James


