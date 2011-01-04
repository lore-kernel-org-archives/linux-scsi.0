From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [patch 1/2] [SCSI] target: remove an unused variable
Date: Tue, 04 Jan 2011 15:37:12 -0800
Message-ID: <1294184232.29002.21.camel@haakon2.linux-iscsi.org>
References: <20110103055735.GU1886@bicker>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110103055735.GU1886@bicker>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-01-03 at 08:57 +0300, Dan Carpenter wrote:
> We never use "fabric_cg" and also we leak it on the success path.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 

Hi Dan,

Thanks for catching this left over allocation from v3.x days before
target_core_register_fabric() accepted the fabric module's top level
struct config_group.

Committed as 7e7d89f6cf into lio-core-2.6.git.

Best Regards,

--nab

> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index 18d15ff..d7b977d 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -117,7 +117,6 @@ static struct config_group *target_core_register_fabric(
>  	struct config_group *group,
>  	const char *name)
>  {
> -	struct config_group *fabric_cg;
>  	struct target_fabric_configfs *tf;
>  	int ret;
>  
> @@ -131,9 +130,6 @@ static struct config_group *target_core_register_fabric(
>  	if (transport_subsystem_check_init() < 0)
>  		return ERR_PTR(-EINVAL);
>  
> -	fabric_cg = kzalloc(sizeof(struct config_group), GFP_KERNEL);
> -	if (!(fabric_cg))
> -		return ERR_PTR(-ENOMEM);
>  	/*
>  	 * Below are some hardcoded request_module() calls to automatically
>  	 * local fabric modules when the following is called:
> @@ -155,7 +151,6 @@ static struct config_group *target_core_register_fabric(
>  		if (ret < 0) {
>  			printk(KERN_ERR "request_module() failed for"
>  				" iscsi_target_mod.ko: %d\n", ret);
> -			kfree(fabric_cg);
>  			return ERR_PTR(-EINVAL);
>  		}
>  	} else if (!(strncmp(name, "loopback", 8))) {
> @@ -169,7 +164,6 @@ static struct config_group *target_core_register_fabric(
>  		if (ret < 0) {
>  			printk(KERN_ERR "request_module() failed for"
>  				" tcm_loop.ko: %d\n", ret);
> -			kfree(fabric_cg);
>  			return ERR_PTR(-EINVAL);
>  		}
>  	}
> @@ -178,7 +172,6 @@ static struct config_group *target_core_register_fabric(
>  	if (!(tf)) {
>  		printk(KERN_ERR "target_core_get_fabric() failed for %s\n",
>  			name);
> -		kfree(fabric_cg);
>  		return ERR_PTR(-EINVAL);
>  	}
>  	printk(KERN_INFO "Target_Core_ConfigFS: REGISTER -> Located fabric:"
