From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 11/15] drivers: target: Drop unlikely before
 IS_ERR(_OR_NULL)
Date: Sun, 02 Aug 2015 22:45:45 -0700
Message-ID: <1438580745.16598.87.camel@haakon3.risingtidesystems.com>
References: <cover.1438331416.git.viresh.kumar@linaro.org>
	 <f45b26389ac65b23eb41b90da8680a98d433cd86.1438331416.git.viresh.kumar@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <f45b26389ac65b23eb41b90da8680a98d433cd86.1438331416.git.viresh.kumar@linaro.org>
Sender: target-devel-owner@vger.kernel.org
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: akpm@linux-foundation.org, linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <JBottomley@Odin.com>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, martin.petersen@oracle.com, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2015-07-31 at 14:08 +0530, Viresh Kumar wrote:
> IS_ERR(_OR_NULL) already contain an 'unlikely' compiler flag and there
> is no need to do that again from its callers. Drop it.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/target/tcm_fc/tfc_cmd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
> index 68031723e5be..aa3caca8bace 100644
> --- a/drivers/target/tcm_fc/tfc_cmd.c
> +++ b/drivers/target/tcm_fc/tfc_cmd.c
> @@ -255,7 +255,7 @@ static void ft_recv_seq(struct fc_seq *sp, struct fc_frame *fp, void *arg)
>  	struct ft_cmd *cmd = arg;
>  	struct fc_frame_header *fh;
>  
> -	if (unlikely(IS_ERR(fp))) {
> +	if (IS_ERR(fp)) {
>  		/* XXX need to find cmd if queued */
>  		cmd->seq = NULL;
>  		cmd->aborted = true;

Looks fine.  Applied to target-pending/for-next.

Thanks Viresh!
