From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [patch 2/2] [SCSI] target: unlock on error path in configfs
Date: Tue, 04 Jan 2011 15:40:37 -0800
Message-ID: <1294184437.29002.24.camel@haakon2.linux-iscsi.org>
References: <20110103055920.GV1886@bicker>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110103055920.GV1886@bicker>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-01-03 at 08:59 +0300, Dan Carpenter wrote:
> If the user wrote a wrong value to the file the it would lead to a dead
> lock eventually.
> 

Good catch on this one.  Commited as 827447968 and pushed into
lio-core-2.6.git.

Thanks!

--nab

> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index d7b977d..2764510 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -660,6 +660,7 @@ static ssize_t target_core_dev_store_attr_##_name(			\
>  	}								\
>  	ret = strict_strtoul(page, 0, &val);				\
>  	if (ret < 0) {							\
> +		spin_unlock(&se_dev->se_dev_lock);                      \
>  		printk(KERN_ERR "strict_strtoul() failed with"		\
>  			" ret: %d\n", ret);				\
>  		return -EINVAL;						\
