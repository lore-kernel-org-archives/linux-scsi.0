From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [PATCH] scsi_lib: correctly retry failed zero length REQ_TYPE_FS commands
Date: Tue, 17 May 2016 11:29:58 +0200
Message-ID: <CAMGffEk_HCR9Pd_y1LTPPvTub7sDMRBJ1QfAh7agSFyM8cH_mA@mail.gmail.com>
References: <1463166246.2291.84.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:35486 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340AbcEQJaS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 May 2016 05:30:18 -0400
Received: by mail-oi0-f44.google.com with SMTP id x19so15640249oix.2
        for <linux-scsi@vger.kernel.org>; Tue, 17 May 2016 02:30:18 -0700 (PDT)
In-Reply-To: <1463166246.2291.84.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sebastian Parschauer <s.parschauer@gmx.de>, linux-scsi@vger.kernel.org

On Fri, May 13, 2016 at 9:04 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> When SCSI was written, all commands coming from the filesystem
> (REQ_TYPE_FS commands) had data.  This meant that our signal for
> needing to complete the command was the number of bytes completed bei=
ng
> equal to the number of bytes in the request.  Unfortunately, with the
> advent of flush barriers, we can now get zero length REQ_TYPE_FS
> commands, which confuse this logic because they satisfy the condition
> every time.  This means they never get retried even for retryable
> conditions, like UNIT ATTENTION because we complete them early assumi=
ng
> they're done.  Fix this by special casing the early completion
> condition to recognise zero length commands with errors and let them
> drop through to the retry code.
>
> Reported-by: Sebastian Parschauer <s.parschauer@gmx.de>
> Signed-off-by: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
>
> ---
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 8106515..f704d02 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -911,9 +911,12 @@ void scsi_io_completion(struct scsi_cmnd *cmd, u=
nsigned int good_bytes)
>         }
>
>         /*
> -        * If we finished all bytes in the request we are done now.
> +        * special case: failed zero length commands always need to
> +        * drop down into the retry code. Otherwise, if we finished
> +        * all bytes in the request we are done now.
>          */
> -       if (!scsi_end_request(req, error, good_bytes, 0))
> +       if (!(blk_rq_bytes(req) =3D=3D 0 && error) &&
> +           !scsi_end_request(req, error, good_bytes, 0))
>                 return;
>
>         /*

Hi James,

Thanks for your new patch. I tested on my environment, works fine.
You can add:
Tested-by: Jack Wang <jinpu.wang@profitbricks.com>
--=20
Mit freundlichen Gr=C3=BC=C3=9Fen,
Best Regards,

Jack Wang

Linux Kernel Developer Storage
ProfitBricks GmbH  The IaaS-Company.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
