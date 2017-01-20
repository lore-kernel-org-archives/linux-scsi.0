From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 3/4] mpt3sas: Fix Firmware fault state 0x2100 during
 heavy 4K RR FIO stress test.
Date: Fri, 20 Jan 2017 16:10:36 +0100
Message-ID: <20170120151036.GD9315@linux-x5ow.site>
References: <1484923333-8509-1-git-send-email-chaitra.basappa@broadcom.com>
 <1484923333-8509-4-git-send-email-chaitra.basappa@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35048 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751276AbdATPNE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Jan 2017 10:13:04 -0500
Content-Disposition: inline
In-Reply-To: <1484923333-8509-4-git-send-email-chaitra.basappa@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chaitra P B <chaitra.basappa@broadcom.com>
Cc: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, sreekanth.reddy@broadcom.com

On Fri, Jan 20, 2017 at 08:12:12PM +0530, Chaitra P B wrote:
> Due existence of loop in the IO path our HBA will receive heavy IOs and
> also as driver is not updating the Reply Post Host Index frequently, So
> there will be a high chance that our Firmware unable to find any free entry
> in the Reply Post Descriptor Queue (i.e. Queue overflow occurs) and can
> observe 0x2100 firmware fault.
> So to fix this, we have defined a thresh hold value. After continuously
> processing this thresh hold number of reply descriptors driver will update
> the Reply Descriptor Host Index so that this thresh hold number of reply
> descriptors entries will be freed and these entries will be available for
> firmware and we won't observe this Firmware fault. We have defined this
> threshold value as 1/3rd of the hba queue depth.
> 
> Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
> Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c |   19 +++++++++++++++++++
>  1 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 722fab9..a3fe1fb 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -1040,6 +1040,25 @@ _base_interrupt(int irq, void *bus_id)
>  		    reply_q->reply_post_free[reply_q->reply_post_host_index].
>  		    Default.ReplyFlags & MPI2_RPY_DESCRIPT_FLAGS_TYPE_MASK;
>  		completed_cmds++;
> +		/* Update the reply post host index after continuously
> +		 * processing the threshold number of Reply Descriptors.
> +		 * So that FW can find enough entries to post the Reply
> +		 * Descriptors in the reply descriptor post queue.
> +		 */
> +		if (completed_cmds > ioc->hba_queue_depth/3) {
> +			if (ioc->combined_reply_queue) {
> +				writel(reply_q->reply_post_host_index |
> +						((msix_index  & 7) <<
> +						 MPI2_RPHI_MSIX_INDEX_SHIFT),
> +				    ioc->replyPostRegisterIndex[msix_index/8]);
> +			} else {
> +				writel(reply_q->reply_post_host_index |
> +						(msix_index <<
> +						 MPI2_RPHI_MSIX_INDEX_SHIFT),
> +						&ioc->chip->ReplyPostHostIndex);
> +			}
> +			completed_cmds = 1;
> +		}
>  		if (request_desript_type == MPI2_RPY_DESCRIPT_FLAGS_UNUSED)
>  			goto out;
>  		if (!reply_q->reply_post_host_index)

Do I understand it correctly that you fill the HBA's internal queue up to a
3rd and then kick it to start processing?

Thanks,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
