From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] [SCSI] scsi_debug: Do not respond to INQUIRY commands
 with CHECK CONDITION when sense pending
Date: Thu, 14 Feb 2013 16:46:54 -0500
Message-ID: <511D5B4E.8020606@interlog.com>
References: <1360859795-30448-1-git-send-email-emilne@redhat.com> <1360859795-30448-2-git-send-email-emilne@redhat.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:37157 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934909Ab3BNVq6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Feb 2013 16:46:58 -0500
In-Reply-To: <1360859795-30448-2-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org

On 13-02-14 11:36 AM, Ewan D. Milne wrote:
> From: "Ewan D. Milne" <emilne@redhat.com>
>
> According to SPC, INQUIRY commands are not supposed to respond
> with a CHECK CONDITION due to a pending UNIT ATTENTION.  This
> was causing failures when re-scanning a scsi_debug target.

Good pick up. Reference: sam5r12.pdf section 5.14 on
Unit Attentions. And please add REPORT LUNS to your patch.

Doug Gilbert

> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>   drivers/scsi/scsi_debug.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 8a6bf31..68f13be 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -4060,7 +4060,7 @@ write:
>   		errsts = check_condition_result;
>   		break;
>   	}
> -	if (!errsts && devip->sense_pending) {
> +	if (!errsts && devip->sense_pending && (*cmd != INQUIRY)) {
>   		devip->sense_pending = 0;
>   		errsts = check_condition_result;
>   	}
>

