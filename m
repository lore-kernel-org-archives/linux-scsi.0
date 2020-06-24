Return-Path: <SRS0=oFF2=AF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4DFDC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 17:07:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD6A720836
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 17:07:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405228AbgFXRHp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Jun 2020 13:07:45 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2360 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404209AbgFXRHp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Jun 2020 13:07:45 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 6244E95D90D6EF8468AA;
        Wed, 24 Jun 2020 18:07:43 +0100 (IST)
Received: from [127.0.0.1] (10.210.166.251) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Wed, 24 Jun
 2020 18:07:41 +0100
Subject: Re: [PATCH V2 3/3] pm80xx : Wait for PHY startup before draining
 libsas queue.
To:     Deepak Ukey <deepak.ukey@microchip.com>,
        <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <jinpu.wang@profitbricks.com>,
        <martin.petersen@oracle.com>, <dpf@google.com>,
        <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
References: <20200624120322.6265-1-deepak.ukey@microchip.com>
 <20200624120322.6265-4-deepak.ukey@microchip.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <858e1af3-6ce6-e827-d24e-02d56459959b@huawei.com>
Date:   Wed, 24 Jun 2020 18:06:12 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200624120322.6265-4-deepak.ukey@microchip.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.166.251]
X-ClientProxiedBy: lhreml716-chm.china.huawei.com (10.201.108.67) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 24/06/2020 13:03, Deepak Ukey wrote:


> From: peter chang <dpf@google.com>
> 
> The host's scan finish waits for the libsas queue to drain. However,
> if the PHYs are still in the process of starting then the queue will
> be empty. This means that we declare the scan finished before it has
> even started. Here we wait for various events from the firmware-side.

But we still report the phy up even to libsas later, so should 
revalidate the domain and discover the device.

> 
> The wait behavior can be configured using the module parameter
> "wait_for_phy_startup", if the parameter is enabled, the driver will wait
> for the phy event from the firmware, before proceeding with load.

If this is to circumvent a deficiency in udev (which you mentioned in 
the v1 in this series, but fail to mention here), then better to fix udev.

> 
> Signed-off-by: Viswas G <Viswas.G@microchip.com>

Author != first Signed-off-by

> Signed-off-by: peter chang <dpf@google.com>
> Signed-off-by: Radha Ramachandran <radha@google.com>
> Signed-off-by: Deepak Ukey <Deepak.Ukey@microchip.com>
> ---
>   drivers/scsi/pm8001/pm8001_ctl.c  | 36 +++++++++++++++++++++
>   drivers/scsi/pm8001/pm8001_defs.h |  6 ++--
>   drivers/scsi/pm8001/pm8001_init.c | 22 +++++++++++++
>   drivers/scsi/pm8001/pm8001_sas.c  | 67 +++++++++++++++++++++++++++++++++++++--
>   drivers/scsi/pm8001/pm8001_sas.h  |  4 +++
>   drivers/scsi/pm8001/pm80xx_hwi.c  | 67 ++++++++++++++++++++++++++++++++-------
>   6 files changed, 185 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
> index 3c9f42779dd0..eae629610a5f 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -88,6 +88,41 @@ static ssize_t controller_fatal_error_show(struct device *cdev,
>   }
>   static DEVICE_ATTR_RO(controller_fatal_error);
>   
> +/**
> + * phy_startup_timeout_show - per-phy discovery timeout
> + * @cdev: pointer to embedded class device
> + * @buf: the buffer returned
> + *
> + * A sysfs 'read/write' shost attribute.
> + */
> +static ssize_t phy_startup_timeout_show(struct device *cdev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct Scsi_Host *shost = class_to_shost(cdev);
> +	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
> +	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
> +
> +	return snprintf(buf, PAGE_SIZE, "%08xh\n",
> +		pm8001_ha->phy_startup_timeout / HZ);
> +}
> +
> +static ssize_t phy_startup_timeout_store(struct device *cdev,
> +	struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	struct Scsi_Host *shost = class_to_shost(cdev);
> +	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
> +	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
> +	int val = 0;
> +
> +	if (kstrtoint(buf, 0, &val) < 0)
> +		return -EINVAL;
> +
> +	pm8001_ha->phy_startup_timeout = val * HZ;
> +	return strlen(buf);

I don't see how this can be used.

> +}
> +
> +static DEVICE_ATTR_RW(phy_startup_timeout);
> +

 >
 >   	case HW_EVENT_SAS_PHY_UP:
 > @@ -4975,6 +5015,9 @@ pm80xx_chip_phy_start_req(struct 
pm8001_hba_info *pm8001_ha, u8 phy_id)
 >
 >   	PM8001_INIT_DBG(pm8001_ha,
 >   		pm8001_printk("PHY START REQ for phy_id %d\n", phy_id));
 > +	set_bit(phy_id, &pm8001_ha->phy_mask);
 > +	pm8001_ha->phy[phy_id].start_timeout =
 > +		jiffies + pm8001_ha->phy_startup_timeout;
 >
 >   	payload.ase_sh_lm_slr_phyid = cpu_to_le32(SPINHOLD_ENABLE |
 >   			LINKMODE_AUTO | pm8001_ha->link_rate | phy_id);
 > --

If there is nothing attached to the phy, then it would never come up, 
right? If so, how do you handle this?

Thanks,
john

