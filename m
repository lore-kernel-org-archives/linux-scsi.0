Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77A5FC433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Oct 2022 22:57:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbiJFW5R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Oct 2022 18:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232169AbiJFW5P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Oct 2022 18:57:15 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A29BB041
        for <linux-scsi@vger.kernel.org>; Thu,  6 Oct 2022 15:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1665097034; x=1696633034;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LwClfZbzR0TpVsgrkzGgItOdvQ+OZDNgNqpEqYtDLV8=;
  b=RZNl0l2XfVT4kBCTzeHU9grXd0vhBdBL6ZM/OsJzX7xbJjnTvcY3GpbN
   Enj5iI+bWFcIUputrFYTV39xgrMXqerJFKCwIUykInVuhZu+zlykANzhO
   SIQcne28ip/god6csNcHyi5HJ1MVYm2chx9dGMuVPI2+TZTYX3knY09xG
   NFpxOtpXO9wj1H13ciWu0ZZ8nspJ+Pz+88xgv+pRpfU+nNRmU7+oBMtdT
   63Xw2OKWv5wBOnik2WAR3kpQJZCJfDoa84L9XdEThYGv8fuWZGGyPk5Bn
   cKvuFLIgANsRc0LIldol1oyuoXT8ZORC1xDMHEA6X3JeCN9Rd0u0niXmt
   w==;
X-IronPort-AV: E=Sophos;i="5.95,164,1661788800"; 
   d="scan'208";a="218363291"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Oct 2022 06:57:14 +0800
IronPort-SDR: rVJ6mdzmp7QzKKV+hVQOXpyQwCcJS0yT0NuQAIhtumKlDmDIr4ivSbf0vFGk7Obdd3Hx5MYW7b
 fZGsZxJ/KEqsThusXc3EZBsNlCYU7xy/U5MziJAElYyJo0HSIgX9qSKcutOU6DVOIoOcEEleQs
 HqbjlH49cgGHPYCofp005e1yDSJMdkLYyQ1eddhPjGVji6cXBZihrmSIAcEKHpy3NRovJk4r82
 UmfgSJjOvGZelPmTzhG2rR+RGkA0wmt7Ro3cIgYfKDWcC1O6sNTPefyIcRhDvdxSrv36iAXkAI
 hEgb6FegSSprjPAKJx9zAq5h
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Oct 2022 15:17:00 -0700
IronPort-SDR: G6DVwaqNwXqMcYoXBiwnkS1Vv9aH9BJyO7Rfsvn1xcnDposZ4Zp6wWu+14rJ1Y/bAvAqJ0PsPd
 IhYY8HYl3pNlEnrHkstuyUQZiyKLziuX86rGxQWURlfjT96YX1gilSyT3rx0quBAsL3U99sE+n
 cMfWd3DcQbk0LWFdxeNYN5lnTCnsAcuhRS11cadqOOVMwgm1suXUc7n2GqhuThkInBPZTsariX
 guVqq49BWgz8q65FFY8WCuqFHVQq042QMDQgQ4n6ZHR4EipdRkJJUU0BHEd7/pEu15hTEHWxhc
 yh0=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Oct 2022 15:57:15 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Mk6Jn75SMz1RvTp
        for <linux-scsi@vger.kernel.org>; Thu,  6 Oct 2022 15:57:13 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1665097032; x=1667689033; bh=LwClfZbzR0TpVsgrkzGgItOdvQ+OZDNgNqp
        EqYtDLV8=; b=BMN+KLY/bouLeLU9bZB//3GL75vLKBxICZqZAfD10O7T9ktk2TW
        EuO5a1i43L0ZZ3XcNtWfQCN3kjkYAiTP3b5ytwHjTg9GIjRgipLRO11QgPgiGErS
        DGAmriYpGQNhFXWaFEWJc2TXpx6h9wILLqqdwlpt8xsWIoQiu4p4z1GcD0M3cSNB
        l6iupwmPl2S8h6IIJq+pv1MUzWySdS9S/Y+4LN7+7FWR4fdV19QfCbTUxupmVVC6
        ZUPxdmBSYqlgkoTRGeQkHxxczdPLozfHZHWpDpy3RRKOkns99uytpsxIYP19IZOI
        e4/NrT+zQZ5mxJttp5SgiBP1YnvFYIcwKvg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id RSrK0R40Sl7t for <linux-scsi@vger.kernel.org>;
        Thu,  6 Oct 2022 15:57:12 -0700 (PDT)
Received: from [10.225.163.106] (unknown [10.225.163.106])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Mk6Jk6k7qz1RvLy;
        Thu,  6 Oct 2022 15:57:10 -0700 (PDT)
Message-ID: <932dd4a0-e713-c5da-ebf5-1566a3d4a327@opensource.wdc.com>
Date:   Fri, 7 Oct 2022 07:57:09 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v5 0/7] libsas and drivers: NCQ error handling
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        John Garry <john.garry@huawei.com>
Cc:     "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jinpu.wang@cloud.ionos.com" <jinpu.wang@cloud.ionos.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>,
        yangxingui <yangxingui@huawei.com>,
        yanaijie <yanaijie@huawei.com>
References: <1664262298-239952-1-git-send-email-john.garry@huawei.com>
 <YzwvpUUftX6Ziurt@x1-carbon>
 <cfa52b91-db81-a179-76c2-8a61266c099d@huawei.com>
 <27148ec5-d1ae-d9a2-1b00-a4c34d2da198@huawei.com>
 <Yz33FGwd3YvQUAqT@x1-carbon>
 <5db6a7bc-dfeb-76e1-6899-7041daa934cf@opensource.wdc.com>
 <Yz4BLTPkXqyjW4a4@x1-carbon>
 <64ab35a7-f1ff-92ee-890e-89a5aee935a4@opensource.wdc.com>
 <f190f19e-34b2-611c-1cf4-f8f34d12fe74@huawei.com>
 <Yz7qD+gpmI1bdw16@x1-carbon>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <Yz7qD+gpmI1bdw16@x1-carbon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/6/22 23:45, Niklas Cassel wrote:
> On Thu, Oct 06, 2022 at 09:33:23AM +0100, John Garry wrote:
>> On 05/10/2022 23:42, Damien Le Moal wrote:
>>>> Hello Damien,
>>>>
>>>> John explained that he got a timeout from EH when reading the log:
>>>> [  350.281581] ata1: failed to read log page 10h (errno=-5)
>>>> [  350.577181] ata1.00: exception Emask 0x1 SAct 0xffffffff SErr 0x0 action 0x6 frozen
>>>>
>>>> ata_eh_read_log_10h() uses ata_read_log_page(), which will first try to read
>>>> the log using READ LOG DMA EXT. If that fails, it will retry using READ LOG EXT.
>>>>
>>>> Therefore, to see if this is a driver specific bug, I suggested to try to read
>>>> the NCQ Command Error log using ATA16 passthrough commands:
>>>>
>>>> $ sudo sg_sat_read_gplog -d --log=0x10 /dev/sdc
>>>> will read the log using READ LOG DMA EXT.
>>>>
>>>> $ sudo sg_sat_read_gplog --log=0x10 /dev/sdc
>>>> will read the log using READ LOG EXT.
>>
>> Note that I can't get a distro to boot on this system from the HDD for the
>> same timeout problem (so no tools easily available).
>>
>>>>
>>>> Neither of these two suggested commands are NCQ commands.
>>>> (Neither command is encapsulated in a RECEIVE FPDMA QUEUED,
>>>> so I'm not sure what you mean.)
>>>>
>>>>
>>>> Garry, I now see that:
>>>> [  350.577181] ata1.00: exception Emask 0x1 SAct 0xffffffff SErr 0x0 action 0x6 frozen
>>>> Your port is frozen.
>>>>
>>>> ata_read_log_page() calls ata_exec_internal() which calls ata_exec_internal_sg(),
>>>> which will simply return an error without sending down the command to the drive,
>>>> if the port is frozen.
>>>>
>>>> Not sure why your port is frozen, mine is obviously not.
>>
>> I think that it gets frozen when the internal command for read log ext times
>> out. More below about that timeout.
> 
> ata_read_log_page() will first try to read using READ LOG DMA EXT.
> If that fails it will retry with READ LOG EXT.
> 
> Your log has this:
> [  350.257870] ata1.00: qc timeout (cmd 0x47)
> 
> So it is definitely ATA_CMD_READ_LOG_DMA_EXT that times out.
> 
> On timeout, ata_exec_internal_sg() will freeze the port:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/ata/libata-core.c?h=v6.0#n1577
> 
> When ata_read_log_page() retries with the port frozen,
> READ LOG EXT will obviously fail (since the port is frozen).
> 
> Not sure why READ LOG DMA EXT would timeout for you...
> Perhaps your drive does not implement this command,
> and incorrectly reports supporting this command via
> ata_id_has_read_log_dma_ext().
> 
> Perhaps you could try boot your kernel with libata.force=nodmalog
> on the kernel command line, so that ata_read_log_page() will use
> READ LOG EXT on the first try.
> 
> 
> Damien, it seems that there is no use in retrying if the port
> is frozen/we got a timeout, so perhaps:
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index e74ab6c0f1a0..1aa628332c8e 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -2035,7 +2035,8 @@ unsigned int ata_read_log_page(struct ata_device *dev, u8 log,
>         if (err_mask) {
>                 if (dma) {
>                         dev->horkage |= ATA_HORKAGE_NO_DMA_LOG;
> -                       goto retry;
> +                       if (err_mask != AC_ERR_TIMEOUT)
> +                               goto retry;
>                 }
> 
> or:
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index e74ab6c0f1a0..2fa03b7573ac 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -2035,7 +2035,8 @@ unsigned int ata_read_log_page(struct ata_device *dev, u8 log,
>         if (err_mask) {
>                 if (dma) {
>                         dev->horkage |= ATA_HORKAGE_NO_DMA_LOG;
> -                       goto retry;
> +                       if (!(dev->link->ap->pflags & ATA_PFLAG_FROZEN))
> +                               goto retry;

Yes, something like this is needed. Though I would prefer having a little
ata_port_frozen() helper for the condition.

>                 }
> 
> would be in order, so that we actually print the real error, instead of a bogus
> AC_ERR_SYSTEM (returned by ata_exec_internal_sg()) when the port is frozen.

yep.

>>
>>>>
>>>> ata_do_link_abort() calls ata_eh_set_pending() without activating fast drain:
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/ata/libata-eh.c?h=v6.0#n989
>>>>
>>>> So I'm not sure why your port is frozen.
>>>> (The fast drain timer does freeze the port, but it shouldn't be enabled.)
>>>> It might be worthwhile to see who freezes the port in your case.
>>> Might come from the command timeout. John has had many problems with the
>>> pm80xx HBA in his Arm machine from a while back. Likely not a driver issue
>>> but a hw one... No-one seems to be able to recreate the same problem.
>>>
>>> We need to try the HBA on our Arm board to see what happens.
>>>
>>
>> Yeah, it just looks to be the longstanding issue of using this card on my
>> arm64 machine - that is that I get IO timeouts quite regularly. I should
>> have mentioned that yesterday. This just seems to be a driver issue.
> 
> Out of curiosity, which arm64 SoC is this?
> 
> While it is very unlikely that this is your problem, but I've encountered
> an issue on an ARM board before, where the PCIe controller was incorrectly
> configured in device tree, causing the controller to miss interrrupts,
> which presented itself to the user as timeouts in the WiFi driver:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=97131f85c08e024df49480ed499aae8fb754067f
> 
> 
> Kind regards,
> Niklas

-- 
Damien Le Moal
Western Digital Research

