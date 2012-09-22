From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: fix return value check in
 sbp_register_configfs()
Date: Sat, 22 Sep 2012 16:55:45 -0700
Message-ID: <1348358145.8016.3.camel@haakon2.linux-iscsi.org>
References: <CAPgLHd-Ts0ABMCb0Y6Do_ovMVd20_i+XETkm7v17Thc7wR9-fg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAPgLHd-Ts0ABMCb0Y6Do_ovMVd20_i+XETkm7v17Thc7wR9-fg@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: bootc@bootc.net, yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On Fri, 2012-09-21 at 13:57 +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> In case of error, the function target_fabric_configfs_init() returns
> ERR_PTR() not NULL pointer. The NULL test in the return value check
> should be replaced with IS_ERR().
> 
> dpatch engine is used to auto generated this patch.
> (https://github.com/weiyj/dpatch)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/target/sbp/sbp_target.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
> index 39ddba5..773303e 100644
> --- a/drivers/target/sbp/sbp_target.c
> +++ b/drivers/target/sbp/sbp_target.c
> @@ -2556,9 +2556,9 @@ static int sbp_register_configfs(void)
>  	int ret;
>  
>  	fabric = target_fabric_configfs_init(THIS_MODULE, "sbp");
> -	if (!fabric) {
> +	if (IS_ERR(fabric)) {
>  		pr_err("target_fabric_configfs_init() failed\n");
> -		return -ENOMEM;
> +		return PTR_ERR(fabric);
>  	}
>  
>  	fabric->tf_ops = sbp_ops;
> 
> 

Good catch.  Applied to target-pending/for-next for the v3.7-rc1
target-updates PULL.

Thanks Wei !
