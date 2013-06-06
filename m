From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: Re: [PATCH 1/3] scsi: Document enhanced error codes
Date: Thu, 06 Jun 2013 13:49:44 +0800
Message-ID: <51B022F8.4000200@cn.fujitsu.com>
References: <1370416261-57005-1-git-send-email-hare@suse.de> <1370416261-57005-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:13773 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753319Ab3FFFqj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jun 2013 01:46:39 -0400
In-Reply-To: <1370416261-57005-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Theodore T'so <tytso@mit.edu>, linux-fsdevel@vger.kernel.org

Hi, Hannes:

I have two questions about the comments:

On 06/05/2013 03:10 PM, Hannes Reinecke wrote:
> Document the various error codes returned on I/O failure.
>
> Signed-off-by: Hannes Reinecke<hare@suse.de>
> ---
>   drivers/scsi/scsi_error.c |  7 +++++--
>   drivers/scsi/scsi_lib.c   | 11 +++++++++++
>   2 files changed, 16 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index f43de1e..443b0e3 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -229,8 +229,11 @@ static inline void scsi_eh_prt_fail_stats(struct Scsi_Host *shost,
>    * scsi_check_sense - Examine scsi cmd sense
>    * @scmd:	Cmd to have sense checked.
>    *
> - * Return value:
> - *	SUCCESS or FAILED or NEEDS_RETRY or TARGET_ERROR
> + * Possible return values:
> + *	SUCCESS
> + *	FAILED
> + *	NEEDS_RETRY
> + *	TARGET_ERROR

This is more likely to be a historical non-update issue -
there is another possible return value 'ADD_TO_MLQUEUE' which may be
returned by the handler check_sense() or the case of this
scsi_check_sense() below, right?

     switch (sshdr.sense_key) {
     case HARDWARE_ERROR:
         if (scmd->device->retry_hwerror)
             return ADD_TO_MLQUEUE;

>
>    *
>    * Notes:
>    *	When a deferred error is detected the current command has
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 86d5220..12bfa73 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -700,6 +700,17 @@ void scsi_release_buffers(struct scsi_cmnd *cmd)
>   }
>   EXPORT_SYMBOL(scsi_release_buffers);
>
> +/**
> + * __scsi_error_from_host_byte - translate SCSI error code into errno
> + * @cmd:	SCSI command (unused)
> + * @result:	scsi error code
> + *
> + * Translate SCSI error code into standard UNIX errno.
> + * Return values:
> + * -ENOLINK	temporary transport failure
> + * -EREMOTEIO	permanent target failure, do not retry
> + * -EBADE	permanent nexus failure, retry on other path

Sorry, I'm afraid that I'm not clear why '-EIO' is not listed here...

Perhaps some of them are not necessary to document for some reasons?

Thanks,
Ren

> + */
>   static int __scsi_error_from_host_byte(struct scsi_cmnd *cmd, int result)
>   {
>   	int error = 0;

