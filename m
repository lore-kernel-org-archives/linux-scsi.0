From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [patch] [SCSI] target: return -ENOMEM instead of -1 in
	target_core_rd.c
Date: Wed, 26 Jan 2011 14:41:58 -0800
Message-ID: <1296081718.14831.57.camel@haakon2.linux-iscsi.org>
References: <20110126085122.GL2721@bicker>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:33252 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564Ab1AZWmH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jan 2011 17:42:07 -0500
In-Reply-To: <20110126085122.GL2721@bicker>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On Wed, 2011-01-26 at 11:51 +0300, Dan Carpenter wrote:
> -1 is -EPERM but -ENOMEM is more appropriate for allocation errors.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 

Hi Dan,

> diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
> index 979aebf..e7fc512 100644
> --- a/drivers/target/target_core_rd.c
> +++ b/drivers/target/target_core_rd.c
> @@ -161,7 +161,7 @@ static int rd_build_device_space(struct rd_dev *rd_dev)
>  	if (!(sg_table)) {
>  		printk(KERN_ERR "Unable to allocate memory for Ramdisk"
>  			" scatterlist tables\n");
> -		return -1;
> +		return -ENOMEM;
>  	}
>  
>  	rd_dev->sg_table_array = sg_table;
> @@ -176,7 +176,7 @@ static int rd_build_device_space(struct rd_dev *rd_dev)
>  		if (!(sg)) {
>  			printk(KERN_ERR "Unable to allocate scatterlist array"
>  				" for struct rd_dev\n");
> -			return -1;
> +			return -ENOMEM;
>  		}
>  
>  		sg_init_table((struct scatterlist *)&sg[0], sg_per_table);
> @@ -192,7 +192,7 @@ static int rd_build_device_space(struct rd_dev *rd_dev)
>  			if (!(pg)) {
>  				printk(KERN_ERR "Unable to allocate scatterlist"
>  					" pages for struct rd_dev_sg_table\n");
> -				return -1;
> +				return -ENOMEM;
>  			}
>  			sg_assign_page(&sg[j], pg);
>  			sg[j].length = PAGE_SIZE;

Ok, these first three are fine for propigating up the proper errno in
configfs attribute context from within rd_build_device_space() ->
rd_create_virtdevice()

> @@ -780,7 +780,7 @@ static int rd_DIRECT_without_offset(
>  		se_mem = kmem_cache_zalloc(se_mem_cache, GFP_KERNEL);
>  		if (!(se_mem)) {
>  			printk(KERN_ERR "Unable to allocate struct se_mem\n");
> -			return -1;
> +			return -ENOMEM;
>  		}
>  		INIT_LIST_HEAD(&se_mem->se_list);
>  

This one is actually within TCM backend struct
se_subsystem_api->do_task() execution context, and should be using the
PYX_TRANSPORT_* failure codes from target_core_transport.h.  I think
this needs to be returning PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES or
PYX_TRANSPORT_LU_COMM_FAILURE, which is then converted up to SCSI status
+sense for struct se_cmd in transport_generic_request_failure().

How about the following patch to address rd_build_device_space() with
errno.., and we address the rd_DIRECT_*_offset() allocation failure
cases in a seperate patch..?

Thanks!

--nab

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 0d0a583..663177e 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -151,7 +151,7 @@ static int rd_build_device_space(struct rd_dev *rd_dev)
        if (rd_dev->rd_page_count <= 0) {
                printk(KERN_ERR "Illegal page count: %u for Ramdisk device\n",
                        rd_dev->rd_page_count);
-               return -1;
+               return -EINVAL;
        }
        total_sg_needed = rd_dev->rd_page_count;
 
@@ -161,7 +161,7 @@ static int rd_build_device_space(struct rd_dev *rd_dev)
        if (!(sg_table)) {
                printk(KERN_ERR "Unable to allocate memory for Ramdisk"
                        " scatterlist tables\n");
-               return -1;
+               return -ENOMEM;
        }
 
        rd_dev->sg_table_array = sg_table;
@@ -176,7 +176,7 @@ static int rd_build_device_space(struct rd_dev *rd_dev)
                if (!(sg)) {
                        printk(KERN_ERR "Unable to allocate scatterlist array"
                                " for struct rd_dev\n");
-                       return -1;
+                       return -ENOMEM;
                }
 
                sg_init_table((struct scatterlist *)&sg[0], sg_per_table);
@@ -192,7 +192,7 @@ static int rd_build_device_space(struct rd_dev *rd_dev)
                        if (!(pg)) {
                                printk(KERN_ERR "Unable to allocate scatterlist"
                                        " pages for struct rd_dev_sg_table\n");
-                               return -1;
+                               return -ENOMEM;
                        }
                        sg_assign_page(&sg[j], pg);
                        sg[j].length = PAGE_SIZE;
@@ -254,15 +254,14 @@ static struct se_device *rd_create_virtdevice(
        struct se_dev_limits dev_limits;
        struct rd_dev *rd_dev = p;
        struct rd_host *rd_host = hba->hba_ptr;
-       int dev_flags = 0, ret = -EINVAL;
+       int dev_flags = 0, ret;
        char prod[16], rev[4];
 
        memset(&dev_limits, 0, sizeof(struct se_dev_limits));
 
-       if (rd_build_device_space(rd_dev) < 0) {
-               ret = -ENOMEM;
+       ret = rd_build_device_space(rd_dev);
+       if (ret < 0)
                goto fail;
-       }
 
        snprintf(prod, 16, "RAMDISK-%s", (rd_dev->rd_direct) ? "DR" : "MCP");
        snprintf(rev, 4, "%s", (rd_dev->rd_direct) ? RD_DR_VERSION :


