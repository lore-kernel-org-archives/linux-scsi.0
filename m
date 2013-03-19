From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] block,scsi: verify return pointer from blk_get_request
Date: Tue, 19 Mar 2013 14:55:54 +0100
Message-ID: <51486E6A.4050907@acm.org>
References: <alpine.DEB.2.02.1303171328250.1736@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:46613 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab3CSNz5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Mar 2013 09:55:57 -0400
In-Reply-To: <alpine.DEB.2.02.1303171328250.1736@jlaw-desktop.mno.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <Joe.Lawrence@stratus.com>
Cc: linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Jiri Kosina <jkosina@suse.cz>, "James E.J. Bottomley" <JBottomley@parallels.com>

On 03/17/13 18:32, Joe Lawrence wrote:
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index c1b05a8..8f009c4 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1635,6 +1635,8 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
>   	 * request becomes available
>   	 */
>   	req = blk_get_request(sdev->request_queue, READ, GFP_KERNEL);
> +	if (!req)
> +		return -ENOMEM;
>
>   	req->cmd[0] = ALLOW_MEDIUM_REMOVAL;
>   	req->cmd[1] = 0;

scsi_eh_lock_door() doesn't return a value to it's caller so I think a 
plain "return" statement is sufficient here.

Bart.
