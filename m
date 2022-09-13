Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C602C54EE9
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Sep 2022 14:05:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbiIMOFl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Sep 2022 10:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232421AbiIMOFi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Sep 2022 10:05:38 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509CF50191
        for <linux-scsi@vger.kernel.org>; Tue, 13 Sep 2022 07:05:33 -0700 (PDT)
Received: from fraeml736-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MRlVr5sYsz688JH;
        Tue, 13 Sep 2022 22:01:08 +0800 (CST)
Received: from lhrpeml500003.china.huawei.com (7.191.162.67) by
 fraeml736-chm.china.huawei.com (10.206.15.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 13 Sep 2022 16:05:30 +0200
Received: from [10.48.155.86] (10.48.155.86) by lhrpeml500003.china.huawei.com
 (7.191.162.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 13 Sep
 2022 15:05:27 +0100
Message-ID: <87148874-6fc4-2423-b442-3ccf3a53787b@huawei.com>
Date:   Tue, 13 Sep 2022 15:05:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v3 1/3] scsi: esas2r: Introduce scsi_template_proc_dir()
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        Bradley Grove <linuxdrivers@attotech.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "Hannes Reinecke" <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220908233600.3043271-1-bvanassche@acm.org>
 <20220908233600.3043271-2-bvanassche@acm.org>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220908233600.3043271-2-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.48.155.86]
X-ClientProxiedBy: lhrpeml100003.china.huawei.com (7.191.160.210) To
 lhrpeml500003.china.huawei.com (7.191.162.67)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/09/2022 00:35, Bart Van Assche wrote:
> Prepare for removing the 'proc_dir' and 'present' members from the SCSI
> host template. This patch does not change any functionality.
> 
> Cc: Bradley Grove <linuxdrivers@attotech.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/esas2r/esas2r_main.c | 18 +++++++++++-------
>   drivers/scsi/scsi_proc.c          | 11 +++++++++++
>   include/scsi/scsi_host.h          |  6 ++++++
>   3 files changed, 28 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
> index 7a4eadad23d7..fbf7fdb3b52a 100644
> --- a/drivers/scsi/esas2r/esas2r_main.c
> +++ b/drivers/scsi/esas2r/esas2r_main.c
> @@ -248,7 +248,6 @@ static struct scsi_host_template driver_template = {
>   	.sg_tablesize			= SG_CHUNK_SIZE,
>   	.cmd_per_lun			=
>   		ESAS2R_DEFAULT_CMD_PER_LUN,
> -	.present			= 0,

nit: this really could be a separate change. It's not really strictly 
related to introducing scsi_template_proc_dir()

>   	.emulated			= 0,
>   	.proc_name			= ESAS2R_DRVR_NAME,
>   	.change_queue_depth		= scsi_change_queue_depth,
> @@ -637,10 +636,13 @@ static void __exit esas2r_exit(void)
>   	esas2r_log(ESAS2R_LOG_INFO, "%s called", __func__);
>   
>   	if (esas2r_proc_major > 0) {
> +		struct proc_dir_entry *proc_dir;
> +
>   		esas2r_log(ESAS2R_LOG_INFO, "unregister proc");
>   
> -		remove_proc_entry(ATTONODE_NAME,
> -				  esas2r_proc_host->hostt->proc_dir);
> +		proc_dir = scsi_template_proc_dir(esas2r_proc_host->hostt);
> +		if (proc_dir)
> +			remove_proc_entry(ATTONODE_NAME, proc_dir);
>   		unregister_chrdev(esas2r_proc_major, ESAS2R_DRVR_NAME);
>   
>   		esas2r_proc_major = 0;
> @@ -730,11 +732,13 @@ const char *esas2r_info(struct Scsi_Host *sh)
>   			       esas2r_proc_major);
>   
>   		if (esas2r_proc_major > 0) {
> -			struct proc_dir_entry *pde;
> +			struct proc_dir_entry *proc_dir;
> +			struct proc_dir_entry *pde = NULL;
>   
> -			pde = proc_create(ATTONODE_NAME, 0,
> -					  sh->hostt->proc_dir,
> -					  &esas2r_proc_ops);
> +			proc_dir = scsi_template_proc_dir(sh->hostt); > +			if (proc_dir)
> +				pde = proc_create(ATTONODE_NAME, 0, proc_dir,
> +						  &esas2r_proc_ops);
>   
>   			if (!pde) {
>   				esas2r_log_dev(ESAS2R_LOG_WARN,
> diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
> index 95aee1ad1383..eeb9261c93f7 100644
> --- a/drivers/scsi/scsi_proc.c
> +++ b/drivers/scsi/scsi_proc.c

Again, seems it should be a separate change - this is not esas2r code now

> @@ -83,6 +83,17 @@ static int proc_scsi_host_open(struct inode *inode, struct file *file)
>   				4 * PAGE_SIZE);
>   }
>   
> +/**
> + * scsi_template_proc_dir() - returns the procfs dir for a SCSI host template
> + * @sht: SCSI host template pointer.
> + */
> +struct proc_dir_entry *
> +scsi_template_proc_dir(const struct scsi_host_template *sht)
> +{
> +	return sht->proc_dir;
> +}
> +EXPORT_SYMBOL(scsi_template_proc_dir);

Don't we encourage EXPORT_SYMBOL_GPL? The core code seems a mishmash.

> +
>   static const struct proc_ops proc_scsi_ops = {
>   	.proc_open	= proc_scsi_host_open,
>   	.proc_release	= single_release,
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 9b0a028bf053..030faca947d2 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -751,6 +751,12 @@ extern struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *, int);
>   extern int __must_check scsi_add_host_with_dma(struct Scsi_Host *,
>   					       struct device *,
>   					       struct device *);
> +#if defined(CONFIG_SCSI_PROC_FS)
> +struct proc_dir_entry *


I don't feel too strongly about this, but elsewhere we have extern and I 
thought that consistency trumps coding standards.

> +scsi_template_proc_dir(const struct scsi_host_template *sht); > +#else
> +#define scsi_template_proc_dir(sht) NULL
> +#endif
>   extern void scsi_scan_host(struct Scsi_Host *);
>   extern void scsi_rescan_device(struct device *);
>   extern void scsi_remove_host(struct Scsi_Host *);
> .

