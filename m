From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: Re: [PATCH 20/20] scsi_error: format abort error message
Date: Fri, 05 Sep 2014 13:23:28 +0900
Message-ID: <54093AC0.1000808@hitachi.com>
References: <1409738775-80876-1-git-send-email-hare@suse.de> <1409738775-80876-21-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail9.hitachi.co.jp ([133.145.228.44]:51950 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaIEEXa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Sep 2014 00:23:30 -0400
In-Reply-To: <1409738775-80876-21-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org

(2014/09/03 19:06), Hannes Reinecke wrote:
> Decode the return value if the command abort failed.
> 
> Suggested-by: Robert Elliot <elliot@hp.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/scsi/scsi_error.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 8a6d382..eca63b2 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -157,8 +157,8 @@ scmd_eh_abort_handler(struct work_struct *work)
>   		} else {
>   			SCSI_LOG_ERROR_RECOVERY(3,
>   				scmd_printk(KERN_INFO, scmd,
> -					    "scmd %p abort failed, rtn %d\n",
> -					    scmd, rtn));
> +					    "scmd %p abort failed, rtn %s\n",
> +					    scmd, scsi_retval_string(rtn)));

If CONFIG_SCSI_CONSTANTS is disabled, scsi_retval_string() returns NULL.
So, if so, we had better output the raw value here.

Thanks,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


