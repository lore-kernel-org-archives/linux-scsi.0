From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] scsi: ->queue_rq can't sleep
Date: Fri, 9 Jan 2015 12:41:07 +0000
Message-ID: <5EE87F5E6631894E80EB1A63198F964D040A672C@SACMBXIP03.sdcorp.global.sandisk.com>
References: <1420640453-3493-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0070.outbound.protection.outlook.com ([207.46.100.70]:34225
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756968AbbAIOOi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jan 2015 09:14:38 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 01/07/15 15:20, Christoph Hellwig wrote:
> The blk-mq ->queue_rq method is always called from process context,
> but might have preemption disabled.  This means we still always
> have to use GFP_ATOMIC for memory allocations, and thus need to
> revert part of commit 3c356bde1 ("scsi: stop passing a gfp_mask
> argument down the command setup path").
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>   drivers/scsi/scsi_lib.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 9ea95dd..6d5c0b8 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -591,7 +591,6 @@ static void scsi_free_sgtable(struct scsi_data_buffer *sdb, bool mq)
>   static int scsi_alloc_sgtable(struct scsi_data_buffer *sdb, int nents, bool mq)
>   {
>       struct scatterlist *first_chunk = NULL;
> -     gfp_t gfp_mask = mq ? GFP_NOIO : GFP_ATOMIC;
>       int ret;
>
>       BUG_ON(!nents);
> @@ -606,7 +605,7 @@ static int scsi_alloc_sgtable(struct scsi_data_buffer *sdb, int nents, bool mq)
>       }
>
>       ret = __sg_alloc_table(&sdb->table, nents, SCSI_MAX_SG_SEGMENTS,
> -                            first_chunk, gfp_mask, scsi_sg_alloc);
> +                            first_chunk, GFP_ATOMIC, scsi_sg_alloc);
>       if (unlikely(ret))
>               scsi_free_sgtable(sdb, mq);
>       return ret;
>

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>

(note: I have been asked to use my company e-mail address for kernel
related work)

________________________________

PLEASE NOTE: The information contained in this electronic mail message is intended only for the use of the designated recipient(s) named above. If the reader of this message is not the intended recipient, you are hereby notified that you have received this message in error and that any review, dissemination, distribution, or copying of this message is strictly prohibited. If you have received this communication in error, please notify the sender by telephone or e-mail (as shown above) immediately and destroy any and all copies of this message in your possession (whether hard copies or electronically stored copies).

