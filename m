From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH] [SCSI] Make scsi_transfer_length take a scsi_data_buffer
 argument
Date: Wed, 06 Aug 2014 15:12:23 +0300
Message-ID: <53E21BA7.5000703@dev.mellanox.co.il>
References: <20140713113715.GA26031@infradead.org> <1406318419-7273-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:47375 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaHFMM0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Aug 2014 08:12:26 -0400
Received: by mail-we0-f173.google.com with SMTP id q58so2603626wes.4
        for <linux-scsi@vger.kernel.org>; Wed, 06 Aug 2014 05:12:25 -0700 (PDT)
In-Reply-To: <1406318419-7273-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@infradead.org>

On 7/25/2014 11:00 PM, Martin K. Petersen wrote:
> For bidirectional commands we need to be able to distinguish between the
> in and out scsi_data_buffers when calculating the wire transfer length.
> Make scsi_transfer_length() take a scsi_data_buffer argument so the
> caller can choose which I/O direction the calculation should apply to.
>

Hey Martin, Christoph,

Sorry for the late response, I was on vacation.
Some comments below.

> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> ---
>   drivers/scsi/libiscsi.c            | 2 +-
>   drivers/target/loopback/tcm_loop.c | 2 +-
>   include/scsi/scsi_cmnd.h           | 5 +++--
>   3 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index f2db82beb646..fdea8c1527d4 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -391,7 +391,7 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
>   	if (scsi_get_prot_op(sc) != SCSI_PROT_NORMAL)
>   		task->protected = true;
>
> -	transfer_length = scsi_transfer_length(sc);
> +	transfer_length = scsi_transfer_length(sc, scsi_out(sc));

If we go down this road we should return to the in_len/out_len
approach that was used before since taking scsi_out(sc) doesn't make
sense for READs (although it would work).

>   	hdr->data_length = cpu_to_be32(transfer_length);
>   	if (sc->sc_data_direction == DMA_TO_DEVICE) {
>   		struct iscsi_r2t_info *r2t = &task->unsol_r2t;
> diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
> index 340de9d92b15..c50453df555a 100644
> --- a/drivers/target/loopback/tcm_loop.c
> +++ b/drivers/target/loopback/tcm_loop.c
> @@ -213,7 +213,7 @@ static void tcm_loop_submission_work(struct work_struct *work)
>
>   	}
>
> -	transfer_length = scsi_transfer_length(sc);
> +	transfer_length = scsi_transfer_length(sc, scsi_out(sc));

Again, this will work but it implies out direction.

Sagi.
