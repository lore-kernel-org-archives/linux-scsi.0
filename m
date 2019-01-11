From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH] target: fix a missing check for match_int
Date: Fri, 11 Jan 2019 14:06:03 -0600
Message-ID: <5C38F72B.5000203@redhat.com>
References: <20181226064818.75984-1-kjlu@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181226064818.75984-1-kjlu@umn.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Kangjie Lu <kjlu@umn.edu>
Cc: pakki001@umn.edu, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/26/2018 12:48 AM, Kangjie Lu wrote:
> When match_int fails, "arg" is left uninitialized and may contain random
> value, thus should not be used.
> The fix checks if match_int fails, and if so, break.
> 
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> ---
>  drivers/target/target_core_rd.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
> index a6e8106abd6f..3138123143e8 100644
> --- a/drivers/target/target_core_rd.c
> +++ b/drivers/target/target_core_rd.c
> @@ -573,7 +573,8 @@ static ssize_t rd_set_configfs_dev_params(struct se_device *dev,
>  		token = match_token(ptr, tokens, args);
>  		switch (token) {
>  		case Opt_rd_pages:
> -			match_int(args, &arg);
> +			if (match_int(args, &arg))
> +				break;

I think if this fails you would want to return an error.

Also, I think you want to add a similar check for the Opt_rd_nullio call
below this chunk because arg may initialized to junk.


>  			rd_dev->rd_page_count = arg;
>  			pr_debug("RAMDISK: Referencing Page"
>  				" Count: %u\n", rd_dev->rd_page_count);
> 
