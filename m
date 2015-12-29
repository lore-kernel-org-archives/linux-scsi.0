From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH RESEND] csiostor:Fix locking issues in the function
 csio_scsim_cleanup_io_lnode
Date: Tue, 29 Dec 2015 11:27:42 -0700
Message-ID: <5682D09E.2070700@kernel.dk>
References: <1451413394-21278-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:36442 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612AbbL2S1o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Dec 2015 13:27:44 -0500
Received: by mail-ob0-f172.google.com with SMTP id ba1so164131034obb.3
        for <linux-scsi@vger.kernel.org>; Tue, 29 Dec 2015 10:27:44 -0800 (PST)
In-Reply-To: <1451413394-21278-1-git-send-email-xerofoify@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nicholas Krause <xerofoify@gmail.com>, JBottomley@odin.com
Cc: martin.petersen@oracle.com, anish@chelsio.com, hare@suse.de, davem@davemloft.net, hariprasad@chelsio.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 12/29/2015 11:23 AM, Nicholas Krause wrote:
> This fixes locking issues in the function csio_scsim_cleanup_io_lnode
> by locking around the call to the function csio_csci_gather_active_ios
> with the function pair spin_lock_irq/spin_unlock_irq as any function
> calling this particular function must do in order to avoid concurrent
> threads of execution on the passed structure pointer of type csio_hw
> as this structure pointer can be shared across mutliple threads in the
> kernel.
>
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>   drivers/scsi/csiostor/csio_scsi.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
> index 2c4562d..c318855 100644
> --- a/drivers/scsi/csiostor/csio_scsi.c
> +++ b/drivers/scsi/csiostor/csio_scsi.c
> @@ -1327,7 +1327,9 @@ csio_scsim_cleanup_io_lnode(struct csio_scsim *scm, struct csio_lnode *ln)
>   	sld.level = CSIO_LEV_LNODE;
>   	sld.lnode = ln;
>   	INIT_LIST_HEAD(&ln->cmpl_q);
> +	spin_lock_irq(&hw->lock);
>   	csio_scsi_gather_active_ios(scm, &sld, &ln->cmpl_q);
> +	spin_unlock_irq(&hw->lock);

All the callers grab that lock, you've just added a deadlock instead.

Nick, I've said this before and I'll say this again. Stop sending me 
patches. They are all untested and broken, you are wasting peoples time.

-- 
Jens Axboe

