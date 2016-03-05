From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [patch] tcm_loop: use after free on error
Date: Fri, 04 Mar 2016 23:21:15 -0800
Message-ID: <1457162475.19657.278.camel@haakon3.risingtidesystems.com>
References: <20160302100941.GE5533@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160302100941.GE5533@mwanda>
Sender: target-devel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Sheng Yang <sheng@yasker.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2016-03-02 at 13:09 +0300, Dan Carpenter wrote:
> We dereference "tl_nexus" to get the error code.
> 
> Fixes: 1b418a8fcbc0 ('target: Convert demo-mode only drivers to target_alloc_session')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
> index 0216c75..e0ffb03 100644
> --- a/drivers/target/loopback/tcm_loop.c
> +++ b/drivers/target/loopback/tcm_loop.c
> @@ -808,6 +808,7 @@ static int tcm_loop_make_nexus(
>  {
>  	struct tcm_loop_hba *tl_hba = tl_tpg->tl_hba;
>  	struct tcm_loop_nexus *tl_nexus;
> +	int ret;
>  
>  	if (tl_tpg->tl_nexus) {
>  		pr_debug("tl_tpg->tl_nexus already exists\n");
> @@ -824,8 +825,9 @@ static int tcm_loop_make_nexus(
>  					TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS,
>  					name, tl_nexus, NULL);
>  	if (IS_ERR(tl_nexus->se_sess)) {
> +		ret = PTR_ERR(tl_nexus->se_sess);
>  		kfree(tl_nexus);
> -		return PTR_ERR(tl_nexus->se_sess);
> +		return ret;
>  	}
>  
>  	tl_tpg->tl_nexus = tl_nexus;

Also fixed + squashed into HCH's original patch.
