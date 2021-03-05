Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 250E1C433DB
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 08:04:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5FC665005
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 08:04:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbhCEIEZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Mar 2021 03:04:25 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2620 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhCEIEM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Mar 2021 03:04:12 -0500
Received: from fraeml738-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DsKn34WzNz67qLC;
        Fri,  5 Mar 2021 15:56:23 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml738-chm.china.huawei.com (10.206.15.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 5 Mar 2021 09:04:10 +0100
Received: from [10.47.8.182] (10.47.8.182) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Fri, 5 Mar 2021
 08:04:09 +0000
Subject: Re: [PATCH 4/7] pm80xx: Add sysfs attribute to track iop1 count
To:     Viswas G <Viswas.G@microchip.com>, <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Ruksar.devadi@microchip.com>, <vishakhavc@google.com>,
        <radha@google.com>, <jinpu.wang@cloud.ionos.com>
References: <20210224155802.13292-1-Viswas.G@microchip.com>
 <20210224155802.13292-5-Viswas.G@microchip.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <1e46d305-a34b-ebda-7bcc-c4311b5405fb@huawei.com>
Date:   Fri, 5 Mar 2021 08:02:12 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20210224155802.13292-5-Viswas.G@microchip.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.8.182]
X-ClientProxiedBy: lhreml713-chm.china.huawei.com (10.201.108.64) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 24/02/2021 15:57, Viswas G wrote:
> From: Vishakha Channapattan <vishakhavc@google.com>
> 
> A new sysfs variable 'ctl_iop1_count' is being introduced that tells if
> the controller is alive by indicating controller ticks. If on subsequent
> run we see the ticks changing that indicates that controller is not
> dead.
> 

Some comments, if you don't mind:

> Tested: Using 'ctl_iop1_count' sysfs variable we can see ticks
> incrementing
> mvae14:~# cat  /sys/class/scsi_host/host*/ctl_iop1_count
> IOP1TCNT=0x00000069

why does this file not just hold the value, and rather print "IOP1TCNT=" 
as well?

> IOP1TCNT=0x0000006b
> IOP1TCNT=0x0000006d
> IOP1TCNT=0x00000072
> 
> Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
> Signed-off-by: Ashokkumar N <Ashokkumar.N@microchip.com>
> Signed-off-by: Radha Ramachandran <radha@google.com>
> ---
>   drivers/scsi/pm8001/pm8001_ctl.c | 25 +++++++++++++++++++++++++
>   1 file changed, 25 insertions(+)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
> index 8470bce2cee1..9bc9ef446801 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -967,6 +967,30 @@ static ssize_t ctl_iop0_count_show(struct device *cdev,
>   }
>   static DEVICE_ATTR_RO(ctl_iop0_count);
>   
> +/**
> + * ctl_iop1_count_show - controller iop1 count check
> + * @cdev: pointer to embedded class device
> + * @buf: the buffer returned
> + *
> + * A sysfs 'read-only' shost attribute.
> + */
> +
> +static ssize_t ctl_iop1_count_show(struct device *cdev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct Scsi_Host *shost = class_to_shost(cdev);
> +	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
> +	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
> +	unsigned int iop1cnt = 0;

no need to set an initial value

> +	int c;
> +
> +	pm8001_dbg(pm8001_ha, IOCTL, "%s\n", __func__);

strange that you require a debug message for something so simple

> +	iop1cnt = pm8001_mr32(pm8001_ha->general_stat_tbl_addr, 20);
> +	c = sprintf(buf, "IOP1TCNT=0x%08x\n", iop1cnt); > +	return c;
> +}
> +static DEVICE_ATTR_RO(ctl_iop1_count);

Seems like a lot of duplication in these functions

> +
>   struct device_attribute *pm8001_host_attrs[] = {
>   	&dev_attr_interface_rev,
>   	&dev_attr_controller_fatal_error,
> @@ -993,6 +1017,7 @@ struct device_attribute *pm8001_host_attrs[] = {
>   	&dev_attr_ctl_mpi_state,
>   	&dev_attr_ctl_raae_count,
>   	&dev_attr_ctl_iop0_count,
> +	&dev_attr_ctl_iop1_count,
>   	NULL,
>   };
>   
> 

