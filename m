Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4345DC47095
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 09:46:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 204A161073
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 09:46:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234529AbhFIJsn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 05:48:43 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3182 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234017AbhFIJsn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 05:48:43 -0400
Received: from fraeml739-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4G0MTC3np1z6K5VZ;
        Wed,  9 Jun 2021 17:37:19 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml739-chm.china.huawei.com (10.206.15.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 9 Jun 2021 11:46:39 +0200
Received: from [10.47.80.201] (10.47.80.201) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 9 Jun 2021
 10:46:37 +0100
Subject: Re: [PATCH v2] scsi: libsas: add lun number check in .slave_alloc
 callback
To:     Yufen Yu <yuyufen@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <yanaijie@huawei.com>,
        <wubo40@huawei.com>
References: <20210609093631.2557822-1-yuyufen@huawei.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <9c67a92d-b9df-0e0c-5dda-e9dbeffec48f@huawei.com>
Date:   Wed, 9 Jun 2021 10:40:45 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20210609093631.2557822-1-yuyufen@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.80.201]
X-ClientProxiedBy: lhreml749-chm.china.huawei.com (10.201.108.199) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/06/2021 10:36, Yufen Yu wrote:
> We found that offline a ata device on hisi sas control and then
> scanning the host can probe 255 not exist devices into system.
> It can be reproduced easily as following:
> 
> Some ata devices on hisi sas v3 control:
>    [root@localhost ~]# lsscsi
>    [2:0:0:0]    disk    ATA      Samsung SSD 860  2B6Q  /dev/sda
>    [2:0:1:0]    disk    ATA      WDC WD2003FYYS-3 1D01  /dev/sdb
>    [2:0:2:0]    disk    SEAGATE  ST600MM0006      B001  /dev/sdc
> 
>   1) echo "offline" > /sys/block/sdb/device/state
>   2) echo "- - -" > /sys/class/scsi_host/host2/scan
> 
> Then, we can see another 255 not exist devices in system:
>    [root@localhost ~]# lsscsi
>    [2:0:0:0]    disk    ATA      Samsung SSD 860  2B6Q  /dev/sda
>    [2:0:1:0]    disk    ATA      WDC WD2003FYYS-3 1D01  /dev/sdb
>    [2:0:1:1]    disk    ATA      WDC WD2003FYYS-3 1D01  /dev/sdh
>    ...
>    [2:0:1:255]  disk    ATA      WDC WD2003FYYS-3 1D01  /dev/sdjb
> 
> After REPORT LUN command issued to the offline device fail, it tries
> to do a sequential scan and probe all devices whose lun is not 0
> successfully.
> 
> To fix the problem, we try to do same things as commit 2fc62e2ac350
> ("[SCSI] libsas: disable scanning lun > 0 on ata devices"), which
> will prevent the device whose lun number is not zero probe into system.
> 
> Reported-by: Wu Bo <wubo40@huawei.com>
> Suggested-by: John Garry <john.garry@huawei.com>
> Signed-off-by: Yufen Yu <yuyufen@huawei.com>
> ---
>   drivers/scsi/aic94xx/aic94xx_init.c    | 1 +
>   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 1 +
>   drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 1 +
>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 1 +
>   drivers/scsi/isci/init.c               | 1 +
>   drivers/scsi/libsas/sas_scsi_host.c    | 9 +++++++++
>   drivers/scsi/mvsas/mv_init.c           | 1 +
>   drivers/scsi/pm8001/pm8001_init.c      | 1 +

Do we also need to modify aix79xx in a similar fashion?

I just noticed that libsas.h already has a prototype for 
sas_slave_alloc() - any idea why?

>   8 files changed, 16 insertions(+)
> 
> diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
> index a195bfe9eccc..7a78606598c4 100644
> --- a/drivers/scsi/aic94xx/aic94xx_init.c
> +++ b/drivers/scsi/aic94xx/aic94xx_init.c
> @@ -53,6 +53,7 @@ static struct scsi_host_template aic94xx_sht = {
>   	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
>   	.eh_device_reset_handler	= sas_eh_device_reset_handler,
>   	.eh_target_reset_handler	= sas_eh_target_reset_handler,
> +	.slave_alloc		= sas_slave_alloc,
>   	.target_destroy		= sas_target_destroy,
>   	.ioctl			= sas_ioctl,
>   #ifdef CONFIG_COMPAT
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
> index 3e359ac752fd..15eaac3a4eb6 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
> @@ -1771,6 +1771,7 @@ static struct scsi_host_template sht_v1_hw = {
>   	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
>   	.eh_device_reset_handler = sas_eh_device_reset_handler,
>   	.eh_target_reset_handler = sas_eh_target_reset_handler,
> +	.slave_alloc		= sas_slave_alloc,
>   	.target_destroy		= sas_target_destroy,
>   	.ioctl			= sas_ioctl,
>   #ifdef CONFIG_COMPAT
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> index 46f60fc2a069..9df1639ffa65 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> @@ -3584,6 +3584,7 @@ static struct scsi_host_template sht_v2_hw = {
>   	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
>   	.eh_device_reset_handler = sas_eh_device_reset_handler,
>   	.eh_target_reset_handler = sas_eh_target_reset_handler,
> +	.slave_alloc		= sas_slave_alloc,
>   	.target_destroy		= sas_target_destroy,
>   	.ioctl			= sas_ioctl,
>   #ifdef CONFIG_COMPAT
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> index e95408314078..36ec3901cfd4 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> @@ -3155,6 +3155,7 @@ static struct scsi_host_template sht_v3_hw = {
>   	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
>   	.eh_device_reset_handler = sas_eh_device_reset_handler,
>   	.eh_target_reset_handler = sas_eh_target_reset_handler,
> +	.slave_alloc		= sas_slave_alloc,
>   	.target_destroy		= sas_target_destroy,
>   	.ioctl			= sas_ioctl,
>   #ifdef CONFIG_COMPAT
> diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
> index c452849e7bb4..ffd33e5decae 100644
> --- a/drivers/scsi/isci/init.c
> +++ b/drivers/scsi/isci/init.c
> @@ -167,6 +167,7 @@ static struct scsi_host_template isci_sht = {
>   	.eh_abort_handler		= sas_eh_abort_handler,
>   	.eh_device_reset_handler        = sas_eh_device_reset_handler,
>   	.eh_target_reset_handler        = sas_eh_target_reset_handler,
> +	.slave_alloc			= sas_slave_alloc,
>   	.target_destroy			= sas_target_destroy,
>   	.ioctl				= sas_ioctl,
>   #ifdef CONFIG_COMPAT
> diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
> index 1bf939818c98..ee44a0d7730b 100644
> --- a/drivers/scsi/libsas/sas_scsi_host.c
> +++ b/drivers/scsi/libsas/sas_scsi_host.c
> @@ -911,6 +911,14 @@ void sas_task_abort(struct sas_task *task)
>   		blk_abort_request(sc->request);
>   }
>   
> +int sas_slave_alloc(struct scsi_device *sdev)
> +{
> +	if (dev_is_sata(sdev_to_domain_dev(sdev)) && sdev->lun)
> +		return -ENXIO;
> +
> +	return 0;
> +}
> +
>   void sas_target_destroy(struct scsi_target *starget)
>   {
>   	struct domain_device *found_dev = starget->hostdata;
> @@ -957,5 +965,6 @@ EXPORT_SYMBOL_GPL(sas_task_abort);
>   EXPORT_SYMBOL_GPL(sas_phy_reset);
>   EXPORT_SYMBOL_GPL(sas_eh_device_reset_handler);
>   EXPORT_SYMBOL_GPL(sas_eh_target_reset_handler);
> +EXPORT_SYMBOL_GPL(sas_slave_alloc);
>   EXPORT_SYMBOL_GPL(sas_target_destroy);
>   EXPORT_SYMBOL_GPL(sas_ioctl);

hmmm... apart from this patchset, it's standard to put the export beside 
the function. Maybe we can change that later.


> diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
> index 6aa2697c4a15..b03c0f35d7b0 100644
> --- a/drivers/scsi/mvsas/mv_init.c
> +++ b/drivers/scsi/mvsas/mv_init.c
> @@ -46,6 +46,7 @@ static struct scsi_host_template mvs_sht = {
>   	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
>   	.eh_device_reset_handler = sas_eh_device_reset_handler,
>   	.eh_target_reset_handler = sas_eh_target_reset_handler,
> +	.slave_alloc		= sas_slave_alloc,
>   	.target_destroy		= sas_target_destroy,
>   	.ioctl			= sas_ioctl,
>   #ifdef CONFIG_COMPAT
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index af09bd282cb9..313248c7bab9 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -101,6 +101,7 @@ static struct scsi_host_template pm8001_sht = {
>   	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
>   	.eh_device_reset_handler = sas_eh_device_reset_handler,
>   	.eh_target_reset_handler = sas_eh_target_reset_handler,
> +	.slave_alloc		= sas_slave_alloc,
>   	.target_destroy		= sas_target_destroy,
>   	.ioctl			= sas_ioctl,
>   #ifdef CONFIG_COMPAT
> 

