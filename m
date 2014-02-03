From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: Fix missing length check in
 spc_emulate_evpd_83()
Date: Mon, 03 Feb 2014 10:30:23 -0800
Message-ID: <1391452223.31316.0.camel@haakon3.risingtidesystems.com>
References: <1391416503-22022-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1391416503-22022-1-git-send-email-roland@kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2014-02-03 at 00:35 -0800, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> Commit fbfe858fea2a ("target_core_spc: Include target device
> descriptor in VPD page 83") added a new length variable, but (due to a
> cut and paste mistake?) just checks scsi_name_len against 256 twice.
> Fix this to check scsi_target_len for overflow too.
> 
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---

Applied.

Thanks Roland!

--nab

>  drivers/target/target_core_spc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
> index 43c5ca9878bc..3bebc71ea033 100644
> --- a/drivers/target/target_core_spc.c
> +++ b/drivers/target/target_core_spc.c
> @@ -440,8 +440,8 @@ check_scsi_name:
>  		padding = ((-scsi_target_len) & 3);
>  		if (padding)
>  			scsi_target_len += padding;
> -		if (scsi_name_len > 256)
> -			scsi_name_len = 256;
> +		if (scsi_target_len > 256)
> +			scsi_target_len = 256;
>  
>  		buf[off-1] = scsi_target_len;
>  		off += scsi_target_len;
