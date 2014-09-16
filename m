From: Webb Scales <webbnh@hp.com>
Subject: Re: scsi: add support for a blk-mq based I/O path.
Date: Tue, 16 Sep 2014 14:30:53 -0400
Message-ID: <541881DD.9040805@hp.com>
References: <54184C09.70800@linuxbox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:46257 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221AbaIPSaz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Sep 2014 14:30:55 -0400
In-Reply-To: <54184C09.70800@linuxbox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Daniel Gryniewicz <dang@linuxbox.com>, linux-scsi@vger.kernel.org

On 9/16/14 10:41 AM, Daniel Gryniewicz wrote:
> Hi, Chris.
>
> I'm working with the OSD Initiator, which does bi-directional 
> requests, and this commit (d285203 scsi: add support for a blk-mq 
> based I/O path.) causes a use-after free panic for me.  The panic 
> itself follows, but the cause is that scsi_end_request() calls 
> blk_finish_request(), which frees the request, and then it calls 
> scsi_release_bidi_buffers() which tries to indirect through the 
> request to find it's own buffers.  This only affects bi-directional 
> requests, so it's unlikely to be hit very often. The following patch 
> fixes it for me, but it may not be the correct fix.
>
> Daniel
>
>
> From af61bb1f014bb1d034f4e7c3a18067ff3c9acedf Mon Sep 17 00:00:00 2001
> From: Daniel Gryniewicz <dang@linuxbox.com>
> Date: Tue, 16 Sep 2014 09:44:35 -0400
> Subject: [PATCH] Panic accesing freed memory during bidi SCSI
>
> When ending a bi-directionional SCSI request, blk_finish_request()
> cleans up and frees the request, but scsi_release_bidi_buffers() tries
> to indirect through the request to find it's data buffers.  This causes
> a panic due to a null pointer dereference.
>
> Move the call to scsi_release_bidi_buffers() before the call to
> blk_finish_request().
>
> Signed-off-by: Daniel Gryniewicz <dang@linuxbox.com>
> ---
>  drivers/scsi/scsi_lib.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index d837dc1..aaea4b9 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -733,12 +733,13 @@ static bool scsi_end_request(struct request 
> *req, int error,
>      } else {
>          unsigned long flags;
>
> +        if (bidi_bytes)
> +            scsi_release_bidi_buffers(cmd);
> +
>          spin_lock_irqsave(q->queue_lock, flags);
>          blk_finish_request(req, error);
>          spin_unlock_irqrestore(q->queue_lock, flags);
>
> -        if (bidi_bytes)
> -            scsi_release_bidi_buffers(cmd);
>          scsi_release_buffers(cmd);
>          scsi_next_command(cmd);
>      }

Looks reasonable to me.

Reviewed-by: Webb Scales <webbnh@hp.com>

