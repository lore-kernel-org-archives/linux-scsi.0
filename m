From: Mike Christie <mchristi@redhat.com>
Subject: Re: [RESEND PATCH] target: fix potential memory leak in option
 parsing
Date: Wed, 13 Jun 2018 11:10:29 -0500
Message-ID: <5B2141F5.5080102@redhat.com>
References: <1528867646-138322-1-git-send-email-cgxu519@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1528867646-138322-1-git-send-email-cgxu519@gmx.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chengguang Xu <cgxu519@gmx.com>, nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/13/2018 12:27 AM, Chengguang Xu wrote:
> When specifying same string type option several times,
> current option parsing will cause memory leak. Hence,
> call kfree for previous one in this case.
> 
> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
> ---
>  drivers/target/target_core_configfs.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index 5ccef7d..5512432 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -1661,6 +1661,7 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
>  		token = match_token(ptr, tokens, args);
>  		switch (token) {
>  		case Opt_initiator_fabric:
> +			kfree(i_fabric);

You can probably just change this one and t_fabric so we do not even do
a match_strdup since they are not used. Just let them hit the default in
the switch so if apps are still passing them in then we maintain the
same behavior from their perspective.
