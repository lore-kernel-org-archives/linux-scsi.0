From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 6/6] [SCSI] sd: Implement copy offload support
Date: Mon, 02 Jun 2014 13:46:45 -0700
Message-ID: <1401742005.32085.6.camel@haakon3.risingtidesystems.com>
References: <1401335565-29865-1-git-send-email-martin.petersen@oracle.com>
	 <1401335565-29865-7-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:45455 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbaFBUqr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 16:46:47 -0400
In-Reply-To: <1401335565-29865-7-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: axboe@fb.com, nab@daterainc.com, linux-scsi@vger.kernel.org

On Wed, 2014-05-28 at 23:52 -0400, Martin K. Petersen wrote:
> Implement support for hardware copy offload. This initial implementation
> only supports EXTENDED COPY(LID1). If need be we can add support for
> LID4 or token copy at a later date.
> 
> If a device has the 3PC flag set in the standard INQUIRY response we'll
> issue a RECEIVE COPY OPERATION PARAMETERS command. We require the device
> to support two copy source/copy destination descriptors and one block to
> block (0x02) segment descriptor. The device must support the NAA
> identification descriptor (0xE4). If the device is capable we'll set the
> queue limits to indicate that the device supports copy offload.
> 
> The copy block range limit can be overridden in scsi_disk's
> max_copy_block sysfs attribute.
> 
> sd_setup_copy_command() is used to prepare any REQ_COPY requests. The
> relevant descriptors are placed in a payload page akin to REQ_DISCARD.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  drivers/scsi/sd.c          | 254 ++++++++++++++++++++++++++++++++++++++++++++-
>  drivers/scsi/sd.h          |   4 +
>  include/scsi/scsi_device.h |   1 +
>  3 files changed, 257 insertions(+), 2 deletions(-)
> 

Looks good.  Nice work.  ;)

Reviewed-by: Nicholas Bellinger <nab@linux-iscsi.org>

