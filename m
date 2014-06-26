From: Steven Haber <steven@qumulo.com>
Subject: Re: SCSI eats error from flush failure during hot plug
Date: Thu, 26 Jun 2014 11:13:46 -0700
Message-ID: <CAPK7rjcvn007mCaCRrsc5q5om8PRoh6vvDbLDs0ztfThRFdqMw@mail.gmail.com>
References: <CAPK7rjcrBuQgoiAxZ9ZASAGugtyHTsHB3ssZegKtuzRdo9TMNQ@mail.gmail.com>
	<20140626150208.GA14887@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:62893 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbaFZSNr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jun 2014 14:13:47 -0400
Received: by mail-oa0-f47.google.com with SMTP id n16so4347020oag.34
        for <linux-scsi@vger.kernel.org>; Thu, 26 Jun 2014 11:13:46 -0700 (PDT)
In-Reply-To: <20140626150208.GA14887@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Sure, I'll run it overnight.

On Thu, Jun 26, 2014 at 8:02 AM, Christoph Hellwig <hch@infradead.org> wrote:
> Hi Steven,
>
> can you test the patch below?
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index f7e3163..9b56e48 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -733,6 +733,14 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>                         scsi_next_command(cmd);
>                         return;
>                 }
> +       } else if (req->cmd_flags & REQ_FLUSH) {
> +               /*
> +                * Flush request don't transfer data, so we can't try
> +                * to complete the good bytes first before checking
> +                * the error.
> +                */
> +               if (result && !sense_deferred)
> +                       error = __scsi_error_from_host_byte(cmd, result);
>         }
>
>         /* no bidi support for !REQ_TYPE_BLOCK_PC yet */
