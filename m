From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [patch] [SCSI] bnx2fc: zero out sense buffer properly
Date: Sat, 18 Aug 2012 17:53:37 +0900 (JST)
Message-ID: <20120818.175337.1305564732068169507.fujita.tomonori@lab.ntt.co.jp>
References: <20120818084637.GA30592@elgon.mountain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120818084637.GA30592@elgon.mountain>
Sender: linux-kernel-owner@vger.kernel.org
To: dan.carpenter@oracle.com
Cc: bprakash@broadcom.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 18 Aug 2012 11:46:37 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> ->sense_buffer used to be an array but it changed to pointer in
> de25deb180 "[SCSI] use dynamically allocated sense buffer".  This call
> to memset() needs to be updated as well.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
> index 73f231c..8d4626c 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_io.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
> @@ -1807,7 +1807,7 @@ static void bnx2fc_parse_fcp_rsp(struct bnx2fc_cmd *io_req,
>  			fcp_sns_len = SCSI_SENSE_BUFFERSIZE;
>  		}
>  
> -		memset(sc_cmd->sense_buffer, 0, sizeof(sc_cmd->sense_buffer));
> +		memset(sc_cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);

I guess that you can remove the line instead. IIRC, scsi-ml does it
for LLDs.
