From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/5] BNX2I: Added chip cleanup for the remove module path
Date: Wed, 11 Aug 2010 14:09:44 -0500
Message-ID: <4C62F578.3090607@cs.wisc.edu>
References: <Eddie Wai <eddie.wai@broadcom.com> <1281467374-6182-5-git-send-email-eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:57088 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783Ab0HKTF2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Aug 2010 15:05:28 -0400
In-Reply-To: <1281467374-6182-5-git-send-email-eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eddie Wai <eddie.wai@broadcom.com>
Cc: James Bottomley <JBottomley@novell.com>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>

On 08/10/2010 02:09 PM, Eddie Wai wrote:
> In the case when an ep_connect request is interrupted due to route
> request stall, if the iSCSI daemon is terminated by the user, the chip
> will be left in a state which will not get cleaned up upon module
> removal.  Upon module reload, when the same context id is used for a
> new connection, chip panic would occur.
>
> This patch adds chip cleanup in the module removal path.
>
> Signed-off-by: Eddie Wai<eddie.wai@broadcom.com>
> Acked-by: Benjamin Li<benli@broadcom.com>
> ---
>   drivers/scsi/bnx2i/bnx2i_init.c  |   53 +++++++++++++++++++++++--------------
>   drivers/scsi/bnx2i/bnx2i_iscsi.c |    3 ++
>   2 files changed, 36 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
> index a796f56..99b861b 100644
> --- a/drivers/scsi/bnx2i/bnx2i_init.c
> +++ b/drivers/scsi/bnx2i/bnx2i_init.c
> @@ -167,6 +167,37 @@ void bnx2i_start(void *handle)
>
>
>   /**
> + * bnx2i_chip_cleanup - local routine to handle chip cleanup

For docbook comments you need the argument info
@hba: driver's hba struct
