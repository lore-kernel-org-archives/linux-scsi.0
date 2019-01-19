From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH v2] target: fix a missing check of match_int
Date: Sat, 19 Jan 2019 13:06:31 -0600
Message-ID: <5C437537.8010304@redhat.com>
References: <5C38F72B.5000203@redhat.com>
 <20190112053159.99406-1-kjlu@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190112053159.99406-1-kjlu@umn.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Kangjie Lu <kjlu@umn.edu>
Cc: pakki001@umn.edu, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01/11/2019 11:31 PM, Kangjie Lu wrote:
> When match_int fails, "arg" is left uninitialized and may contain random
> value, thus should not be used.
> The fix checks if match_int fails, and if so, returns its error code.
> 
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> ---
>  drivers/target/target_core_rd.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
> index a6e8106abd6f..3b7657b2f2f1 100644
> --- a/drivers/target/target_core_rd.c
> +++ b/drivers/target/target_core_rd.c
> @@ -559,6 +559,7 @@ static ssize_t rd_set_configfs_dev_params(struct se_device *dev,
>  	char *orig, *ptr, *opts;
>  	substring_t args[MAX_OPT_ARGS];
>  	int arg, token;
> +	int ret;
>  
>  	opts = kstrdup(page, GFP_KERNEL);
>  	if (!opts)
> @@ -573,14 +574,24 @@ static ssize_t rd_set_configfs_dev_params(struct se_device *dev,
>  		token = match_token(ptr, tokens, args);
>  		switch (token) {
>  		case Opt_rd_pages:
> -			match_int(args, &arg);
> +			ret = match_int(args, &arg);
> +			if (ret) {
> +				kfree(orig);
> +				return ret;

Just set ret to the return value and then break, so all the error and
success paths are going through the same code path.
