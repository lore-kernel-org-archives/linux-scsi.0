Return-Path: <SRS0=pZIS=2X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01931C2D0DC
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 12:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D28AB21734
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 12:33:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbgABMdN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jan 2020 07:33:13 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2220 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728274AbgABMdN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 2 Jan 2020 07:33:13 -0500
Received: from LHREML713-CAH.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id ADE727D5B2D47FF543D2;
        Thu,  2 Jan 2020 12:33:11 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 LHREML713-CAH.china.huawei.com (10.201.108.36) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 2 Jan 2020 12:33:11 +0000
Received: from [127.0.0.1] (10.202.226.43) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Thu, 2 Jan 2020
 12:33:11 +0000
Subject: Re: [PATCH 06/12] pm80xx : sysfs attribute for number of phys.
To:     Jinpu Wang <jinpu.wang@cloud.ionos.com>,
        Deepak Ukey <deepak.ukey@microchip.com>
CC:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        Viswas G <Viswas.G@microchip.com>,
        Jack Wang <jinpu.wang@profitbricks.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <dpf@google.com>, <yuuzheng@google.com>,
        Vikram Auradkar <auradkar@google.com>, <vishakhavc@google.com>,
        <bjashnani@google.com>, Radha Ramachandran <radha@google.com>,
        <akshatzen@google.com>
References: <20191224044143.8178-1-deepak.ukey@microchip.com>
 <20191224044143.8178-7-deepak.ukey@microchip.com>
 <CAMGffEkzAt4FrP2DbhZhGE20nFWPpuGkN83t7Tvw6+LsQg=m3Q@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <32f47ddd-72c5-7846-f0a7-cba3ad1e0c6b@huawei.com>
Date:   Thu, 2 Jan 2020 12:33:10 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <CAMGffEkzAt4FrP2DbhZhGE20nFWPpuGkN83t7Tvw6+LsQg=m3Q@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.43]
X-ClientProxiedBy: lhreml710-chm.china.huawei.com (10.201.108.61) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 02/01/2020 12:07, Jinpu Wang wrote:
> On Tue, Dec 24, 2019 at 5:41 AM Deepak Ukey <deepak.ukey@microchip.com> wrote:
>>
>> From: Viswas G <Viswas.G@microchip.com>
>>
>> Added sysfs attribute to show number of phys.
>>
>> Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
>> Signed-off-by: Viswas G <Viswas.G@microchip.com>
>> Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
>> Signed-off-by: Bhavesh Jashnani <bjashnani@google.com>
>> Signed-off-by: Radha Ramachandran <radha@google.com>
>> Signed-off-by: Akshat Jain <akshatzen@google.com>
>> Signed-off-by: Yu Zheng <yuuzheng@google.com>
>> ---
>>   drivers/scsi/pm8001/pm8001_ctl.c | 20 ++++++++++++++++++++
>>   1 file changed, 20 insertions(+)
>>
>> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
>> index 69458b318a20..704c0daa7937 100644
>> --- a/drivers/scsi/pm8001/pm8001_ctl.c
>> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
>> @@ -89,6 +89,25 @@ static ssize_t controller_fatal_error_show(struct device *cdev,
>>   }
>>   static DEVICE_ATTR_RO(controller_fatal_error);
>>
>> +/**
>> + * pm8001_ctl_num_phys_show - Number of phys
>> + * @cdev:pointer to embedded class device
>> + * @buf:the buffer returned
>> + * A sysfs 'read-only' shost attribute.
>> + */
>> +static ssize_t num_phys_show(struct device *cdev,
>> +               struct device_attribute *attr, char *buf)
> please use pm8001_ctl_num_phys_show as function name, so it follows
> same conversion as other functions.
> Better also rename controller_fatal_error too.

If you don't mind me saying, this info is already available in sysfs for 
any libsas or even SAS host (using scsi_transport_sas.c), like this:

john@ubuntu:/sys/class/sas_phy$ ls
phy-0:0     phy-0:0:12  phy-0:0:17  phy-0:0:21  phy-0:0:4  phy-0:0:9 
phy-0:5
phy-0:0:0   phy-0:0:13  phy-0:0:18  phy-0:0:22  phy-0:0:5  phy-0:1 
phy-0:6
phy-0:0:1   phy-0:0:14  phy-0:0:19  phy-0:0:23  phy-0:0:6  phy-0:2 
phy-0:7
phy-0:0:10  phy-0:0:15  phy-0:0:2   phy-0:0:24  phy-0:0:7  phy-0:3
phy-0:0:11  phy-0:0:16  phy-0:0:20  phy-0:0:3   phy-0:0:8  phy-0:4


Any phy-X:Y is a root phy, and X denotes the host index and Y is the phy 
index.

> 
> Thanks
>> +{
>> +       int ret;
>> +       struct Scsi_Host *shost = class_to_shost(cdev);
>> +       struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
>> +       struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
>> +
>> +       ret = sprintf(buf, "%d", pm8001_ha->chip->n_phy);
>> +       return ret;
>> +}
>> +static DEVICE_ATTR_RO(num_phys);
>> +
>>   /**
>>    * pm8001_ctl_fw_version_show - firmware version
>>    * @cdev: pointer to embedded class device
>> @@ -825,6 +844,7 @@ static DEVICE_ATTR(update_fw, S_IRUGO|S_IWUSR|S_IWGRP,
>>   struct device_attribute *pm8001_host_attrs[] = {
>>          &dev_attr_interface_rev,
>>          &dev_attr_controller_fatal_error,
>> +       &dev_attr_num_phys,
>>          &dev_attr_fw_version,
>>          &dev_attr_update_fw,
>>          &dev_attr_aap_log,
>> --
>> 2.16.3
>>
> .
> 

