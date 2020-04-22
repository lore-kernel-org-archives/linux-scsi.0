Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4CF2C5518A
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 10:07:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE9C020575
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 10:07:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbgDVKHS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 06:07:18 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2078 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728503AbgDVKHR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Apr 2020 06:07:17 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id DC0B5A2E4850B7686D55;
        Wed, 22 Apr 2020 11:07:15 +0100 (IST)
Received: from [127.0.0.1] (10.47.10.232) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1913.5; Wed, 22 Apr
 2020 11:07:15 +0100
Subject: Re: [PATCH V2] scsi: put hot fields of scsi_host_template into one
 cacheline
To:     Ming Lei <ming.lei@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>
References: <20200422095425.319674-1-ming.lei@redhat.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <63626a9b-2871-bc97-d65b-2aa0c5c5811c@huawei.com>
Date:   Wed, 22 Apr 2020 11:06:40 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200422095425.319674-1-ming.lei@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.10.232]
X-ClientProxiedBy: lhreml709-chm.china.huawei.com (10.201.108.58) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 22/04/2020 10:54, Ming Lei wrote:
> The following three fields of scsi_host_template are referenced in
> scsi IO submission path, so put them together into one cacheline:
> 
> - cmd_size
> - queuecommand
> - commit_rqs
> 
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: John Garry <john.garry@huawei.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

FWIW,
Reviewed-by: John Garry <john.garry@huawei.com>

> ---
> V2:
> 	- move the 3 fields at the beginning of scsi_host_template
> 	- comment why we do this way
> 
>   include/scsi/scsi_host.h | 72 ++++++++++++++++++++++------------------
>   1 file changed, 39 insertions(+), 33 deletions(-)
> 
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 822e8cda8d9b..eae5b9f52dfe 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -30,40 +30,15 @@ struct scsi_transport_template;
>   #define MODE_TARGET 0x02
>   
>   struct scsi_host_template {
> -	struct module *module;
> -	const char *name;
> -
>   	/*
> -	 * The info function will return whatever useful information the
> -	 * developer sees fit.  If not provided, then the name field will
> -	 * be used instead.
> -	 *
> -	 * Status: OPTIONAL
> +	 * Put fields referenced in IO submission path together in
> +	 * same cacheline
>   	 */
> -	const char *(* info)(struct Scsi_Host *);
>   
>   	/*
> -	 * Ioctl interface
> -	 *
> -	 * Status: OPTIONAL
> -	 */
> -	int (*ioctl)(struct scsi_device *dev, unsigned int cmd,
> -		     void __user *arg);
> -
> -
> -#ifdef CONFIG_COMPAT
> -	/*
> -	 * Compat handler. Handle 32bit ABI.
> -	 * When unknown ioctl is passed return -ENOIOCTLCMD.
> -	 *
> -	 * Status: OPTIONAL
> +	 * Additional per-command data allocated for the driver.
>   	 */
> -	int (*compat_ioctl)(struct scsi_device *dev, unsigned int cmd,
> -			    void __user *arg);
> -#endif
> -
> -	int (*init_cmd_priv)(struct Scsi_Host *shost, struct scsi_cmnd *cmd);
> -	int (*exit_cmd_priv)(struct Scsi_Host *shost, struct scsi_cmnd *cmd);
> +	unsigned int cmd_size;
>   
>   	/*
>   	 * The queuecommand function is used to queue up a scsi
> @@ -111,6 +86,41 @@ struct scsi_host_template {
>   	 */
>   	void (*commit_rqs)(struct Scsi_Host *, u16);
>   
> +	struct module *module;
> +	const char *name;
> +
> +	/*
> +	 * The info function will return whatever useful information the
> +	 * developer sees fit.  If not provided, then the name field will
> +	 * be used instead.
> +	 *
> +	 * Status: OPTIONAL
> +	 */
> +	const char *(* info)(struct Scsi_Host *);
> +
> +	/*
> +	 * Ioctl interface
> +	 *
> +	 * Status: OPTIONAL
> +	 */
> +	int (*ioctl)(struct scsi_device *dev, unsigned int cmd,
> +		     void __user *arg);
> +
> +
> +#ifdef CONFIG_COMPAT
> +	/*
> +	 * Compat handler. Handle 32bit ABI.
> +	 * When unknown ioctl is passed return -ENOIOCTLCMD.
> +	 *
> +	 * Status: OPTIONAL
> +	 */
> +	int (*compat_ioctl)(struct scsi_device *dev, unsigned int cmd,
> +			    void __user *arg);
> +#endif
> +
> +	int (*init_cmd_priv)(struct Scsi_Host *shost, struct scsi_cmnd *cmd);
> +	int (*exit_cmd_priv)(struct Scsi_Host *shost, struct scsi_cmnd *cmd);
> +
>   	/*
>   	 * This is an error handling strategy routine.  You don't need to
>   	 * define one of these if you don't want to - there is a default
> @@ -468,10 +478,6 @@ struct scsi_host_template {
>   	 */
>   	u64 vendor_id;
>   
> -	/*
> -	 * Additional per-command data allocated for the driver.
> -	 */
> -	unsigned int cmd_size;
>   	struct scsi_host_cmd_pool *cmd_pool;
>   
>   	/* Delay for runtime autosuspend */
> 

