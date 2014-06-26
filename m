From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH v2] scsi: bnx2i: bnx2i_iscsi.c:  Cleaning up variable
 is set more than once
Date: Thu, 26 Jun 2014 14:14:26 +0200
Message-ID: <53AC0EA2.9060601@redhat.com>
References: <1403783689-10457-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1403783689-10457-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-kernel-owner@vger.kernel.org
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, Eddie Wai <eddie.wai@broadcom.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On 06/26/2014 01:54 PM, Rickard Strandqvist wrote:
> A struct member variable is set to different values without having used in between.

It is almost ok for me but I think you should mention that it also fixes a bug,
or the commit message will be misleading.

> 
> This was found using a static code analysis program called cppcheck
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/scsi/bnx2i/bnx2i_iscsi.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> index 166543f..4e17a7f 100644
> --- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> @@ -1643,12 +1643,11 @@ static void bnx2i_conn_get_stats(struct iscsi_cls_conn *cls_conn,
>  	stats->r2t_pdus = conn->r2t_pdus_cnt;
>  	stats->tmfcmd_pdus = conn->tmfcmd_pdus_cnt;
>  	stats->tmfrsp_pdus = conn->tmfrsp_pdus_cnt;
> -	stats->custom_length = 3;
>  	strcpy(stats->custom[2].desc, "eh_abort_cnt");
>  	stats->custom[2].value = conn->eh_abort_cnt;
>  	stats->digest_err = 0;
>  	stats->timeout_err = 0;
> -	stats->custom_length = 0;
> +	stats->custom_length = 3;
>  }
>  
>  
> 
