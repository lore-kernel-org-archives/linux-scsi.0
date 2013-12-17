From: Bradley Grove <bgrove@attotech.com>
Subject: Re: [RESEND][PATCH] scsi: esas2r: fix potential format string flaw
Date: Tue, 17 Dec 2013 16:45:00 -0500
Message-ID: <52B0C5DC.3000407@attotech.com>
References: <20131217182733.GA16202@www.outflux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:21159 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751219Ab3LQWAK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Dec 2013 17:00:10 -0500
In-Reply-To: <20131217182733.GA16202@www.outflux.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, Bradley Grove <linuxdrivers@attotech.com>, linux-scsi@vger.kernel.org

Acked-by: Bradley Grove <bgrove@attotech.com>


On 12/17/2013 01:27 PM, Kees Cook wrote:
> This makes sure format strings cannot leak into the printk call via the
> constructed buffer.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>   drivers/scsi/esas2r/esas2r_log.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/esas2r/esas2r_log.c b/drivers/scsi/esas2r/esas2r_log.c
> index 9bf285df58dd..61fc19d296bd 100644
> --- a/drivers/scsi/esas2r/esas2r_log.c
> +++ b/drivers/scsi/esas2r/esas2r_log.c
> @@ -171,7 +171,7 @@ static int esas2r_log_master(const long level,
>   		if (strlen(event_buffer) < buflen)
>   			strcat(buffer, "\n");
>
> -		printk(event_buffer);
> +		printk("%s", event_buffer);
>
>   		spin_unlock_irqrestore(&event_buffer_lock, flags);
>   	}
>

