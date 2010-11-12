From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 02/11] libata: Convert to host_lock less w/ interrupts
 disabled internally
Date: Thu, 11 Nov 2010 22:47:13 -0500
Message-ID: <4CDCB8C1.6000303@garzik.org>
References: <1289520817-16458-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60984 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab0KLDrT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2010 22:47:19 -0500
Received: by vws13 with SMTP id 13so769984vws.19
        for <linux-scsi@vger.kernel.org>; Thu, 11 Nov 2010 19:47:18 -0800 (PST)
In-Reply-To: <1289520817-16458-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Tejun Heo <tj@kernel.org>, Mike Anderson <andmike@linux.vnet.ibm.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>

On 11/11/2010 07:13 PM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger<nab@linux-iscsi.org>
>
> This patch changes ata_scsi_queuecmd_lck() to a host lock less
> ata_scsi_queuecmd() that will disable interrupts internally using
> ap->lock and drops the now legacy host_lock unlock.
>
> Signed-off-by: Nicholas A. Bellinger<nab@linux-iscsi.org>
> ---
>   drivers/ata/libata-scsi.c |   14 ++++----------
>   1 files changed, 4 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index a007c36..9614758 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -3173,25 +3173,22 @@ static inline int __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
>    *	SCSI commands.  This creates the overall effect of
>    *	ATA and ATAPI devices appearing as SCSI devices.
>    *
> - *	LOCKING:
> - *	Releases scsi-layer-held lock, and obtains host lock.
> - *

The code appears correct but the comment removal is not.

Locking has not disappeared, and the ATA host lock continues to be obtained.


