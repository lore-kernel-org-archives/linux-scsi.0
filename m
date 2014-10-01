From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 7/8] scsi: split error handling slow path out of scsi_io_completion
Date: Wed, 01 Oct 2014 14:46:35 +0200
Message-ID: <542BF7AB.2050503@acm.org>
References: <1410107469-896-1-git-send-email-hch@lst.de> <1410107469-896-8-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from michel.telenet-ops.be ([195.130.137.88]:37312 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaJAMqj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2014 08:46:39 -0400
In-Reply-To: <1410107469-896-8-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 09/07/14 18:31, Christoph Hellwig wrote:
> Move the error handling path out of scsi_io_completion and into an
> out of line helper.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/scsi_lib.c | 263 +++++++++++++++++++++++++-----------------------
>   1 file changed, 136 insertions(+), 127 deletions(-)
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 2221bf1..cc5d404 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -742,6 +742,132 @@ static int __scsi_error_from_host_byte(struct scsi_cmnd *cmd, int result)
>   	return error;
>   }
>
> +static noinline bool
> +scsi_handle_ioerror(struct scsi_cmnd *cmd, int result,
> +		struct scsi_sense_hdr *sshdr)

Please document the meaning of the return value of this function and 
also why it has been marked noinline. Otherwise I'm fine with this patch.

Bart.

