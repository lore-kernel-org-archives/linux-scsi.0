From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: Re: [PATCH] [SCSI] bnx2fc: fix NULL checking in
 bnx2fc_initiate_tmf()
Date: Mon, 5 Nov 2012 13:35:59 -0800
Message-ID: <5098313F.2060903@broadcom.com>
References: <1352096153-18211-1-git-send-email-xi.wang@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1352096153-18211-1-git-send-email-xi.wang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Xi Wang <xi.wang@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/04/2012 10:15 PM, Xi Wang wrote:
> The dereference rport->data should come after the NULL check of rport.
>
> Signed-off-by: Xi Wang <xi.wang@gmail.com>
> ---
>   drivers/scsi/bnx2fc/bnx2fc_io.c |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
> index 8d4626c..eebe93c 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_io.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
> @@ -686,7 +686,7 @@ static int bnx2fc_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
>   {
>   	struct fc_lport *lport;
>   	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
> -	struct fc_rport_libfc_priv *rp = rport->dd_data;
> +	struct fc_rport_libfc_priv *rp;
>   	struct fcoe_port *port;
>   	struct bnx2fc_interface *interface;
>   	struct bnx2fc_rport *tgt;
> @@ -712,6 +712,7 @@ static int bnx2fc_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
>   		rc = FAILED;
>   		goto tmf_err;
>   	}
> +	rp = rport->dd_data;
>   
>   	rc = fc_block_scsi_eh(sc_cmd);
>   	if (rc)
I thought I acked similar patch sometime back, but this did not make it 
to the tree yet.

doing it again. Thanks!

Acked-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
