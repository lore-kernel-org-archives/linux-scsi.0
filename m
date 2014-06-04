From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 4/6] scsi_error: fix invalid setting of host byte
Date: Wed, 04 Jun 2014 08:33:14 +0200
Message-ID: <538EBDAA.7090709@acm.org>
References: <1401823998-29167-1-git-send-email-pbonzini@redhat.com> <1401823998-29167-5-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1401823998-29167-5-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, JBottomley@Parallels.com, venkateshs@google.com, Ulrich Obergfell <uobergfe@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 06/03/14 21:33, Paolo Bonzini wrote:
> From: Ulrich Obergfell <uobergfe@redhat.com>
> 
> After scsi_try_to_abort_cmd returns, the eh_abort_handler may have
> already found that the command has completed in the device, causing
> the host_byte to be nonzero (e.g. it could be DID_ABORT).  When
> this happens, ORing DID_TIME_OUT into the host byte will corrupt
> the result field and initiate an unwanted command retry.
> 
> Fix this by using set_host_byte instead, following the model of
> commit 2082ebc45af9c9c648383b8cde0dc1948eadbf31.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  drivers/scsi/scsi_error.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index f17aa7aa7879..ab06ef6fd726 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -131,7 +131,7 @@ scmd_eh_abort_handler(struct work_struct *work)
>  				    "aborting command %p\n", scmd));
>  		rtn = scsi_try_to_abort_cmd(sdev->host->hostt, scmd);
>  		if (rtn == SUCCESS) {
> -			scmd->result |= DID_TIME_OUT << 16;
> +			set_host_byte(scmd, DID_TIME_OUT);
>  			if (scsi_host_eh_past_deadline(sdev->host)) {
>  				SCSI_LOG_ERROR_RECOVERY(3,
>  					scmd_printk(KERN_INFO, scmd,

There are three other occurrences in scsi_error.c of "scmd->result |=
DID_TIME_OUT << 16". Please modify all occurrences to keep the error
handling code consistent.

Bart.
