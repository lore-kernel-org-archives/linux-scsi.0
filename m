Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ED8CC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 08:15:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 326C9615A7
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 08:15:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348977AbhI3IQo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 04:16:44 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3893 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348991AbhI3IQn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Sep 2021 04:16:43 -0400
Received: from fraeml703-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HKmDN6K3Vz6F95B;
        Thu, 30 Sep 2021 16:11:48 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml703-chm.china.huawei.com (10.206.15.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Thu, 30 Sep 2021 10:14:59 +0200
Received: from [10.47.26.77] (10.47.26.77) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Thu, 30 Sep
 2021 09:14:58 +0100
Subject: Re: [PATCH v2 2/3] acornscsi: remove tagged queuing vestiges
To:     Arnd Bergmann <arnd@kernel.org>
CC:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1631696835-136198-1-git-send-email-john.garry@huawei.com>
 <1631696835-136198-3-git-send-email-john.garry@huawei.com>
 <CAK8P3a3U+yaRe+P68DMQy_37jog=9gz7-dkHT10Vev3FrvMYyg@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <327ae6c3-a64a-66b4-a2ec-ce66d5a39eeb@huawei.com>
Date:   Thu, 30 Sep 2021 09:17:52 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CAK8P3a3U+yaRe+P68DMQy_37jog=9gz7-dkHT10Vev3FrvMYyg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.26.77]
X-ClientProxiedBy: lhreml714-chm.china.huawei.com (10.201.108.65) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 30/09/2021 08:21, Arnd Bergmann wrote:
> On Wed, Sep 15, 2021 at 11:16 AM John Garry<john.garry@huawei.com>  wrote:
>> From: Hannes Reinecke<hare@suse.de>
>>
>> The acornscsi driver has a config option to enable tagged queuing,
>> but this option gets disabled in the driver itself with the comment
>> 'needs to be debugged'.
>> As this is a_really_  old driver I doubt anyone will be wanting to
>> invest time here, so remove the tagged queue vestiges and make
>> our live easier.
>>
>> Signed-off-by: Hannes Reinecke<hare@suse.de>
>> jpg: Use scsi_cmd_to_rq()
>> Signed-off-by: John Garry<john.garry@huawei.com>
> A few thousand randconfig builds later, I actually came across
> building this driver.
> 
>> @@ -1821,7 +1776,7 @@ int acornscsi_reconnect_finish(AS_Host *host)
>>          host->scsi.disconnectable = 0;
>>          if (host->SCpnt->device->id  == host->scsi.reconnected.target &&
>>              host->SCpnt->device->lun == host->scsi.reconnected.lun &&
>> -           host->SCpnt->tag         == host->scsi.reconnected.tag) {
>> +           scsi_cmd_to_tag(host->SCpnt) == host->scsi.reconnected.tag) {
>>   #if (DEBUG & (DEBUG_QUEUES|DEBUG_DISCON))
>>              DBG(host->SCpnt, printk("scsi%d.%c: reconnected",
>>                      host->host->host_no, acornscsi_target(host)));
> drivers/scsi/arm/acornscsi.c: In function 'acornscsi_reconnect_finish':
> drivers/scsi/arm/acornscsi.c:1779:6: error: implicit declaration of
> function 'scsi_cmd_to_tag'; did you mean 'scsi_cmd_to_rq'?
> [-Werror=implicit-function-declaration]
>        scsi_cmd_to_tag(host->SCpnt) == host->scsi.reconnected.tag) {
>        ^~~~~~~~~~~~~~~
>        scsi_cmd_to_rq
> 
> I have no idea what this is meant to do instead, but scsi_cmd_to_tag()
> does not appear to be defined in any kernel I can find.

Hannes added new function scsi_cmd_to_tag() in v1 series, but I removed 
it when I reposted the v2 series. But then missed this reference.

I think the build fix should be as follows:

--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -1776,7 +1776,7 @@ int acornscsi_reconnect_finish(AS_Host *host)
        host->scsi.disconnectable = 0;
        if (host->SCpnt->device->id  == host->scsi.reconnected.target &&
            host->SCpnt->device->lun == host->scsi.reconnected.lun &&
-           scsi_cmd_to_tag(host->SCpnt) == host->scsi.reconnected.tag) {
+           scsi_cmd_to_rq(host->SCpnt)->tag == 
host->scsi.reconnected.tag) {

Let me know if you want us to post a patch for this.

Thanks,
John


