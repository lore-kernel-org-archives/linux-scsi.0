Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0FCAC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Oct 2022 11:11:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbiJSLLa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Oct 2022 07:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231481AbiJSLKr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Oct 2022 07:10:47 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EF6181C81
        for <linux-scsi@vger.kernel.org>; Wed, 19 Oct 2022 03:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666175918; x=1697711918;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8gIdKAEX+/l9UdMrPWxgZ7i502R9ygDTYGF8a7WCDkk=;
  b=YPtO6XycSxHmbwkT0PrUHvaWOI/MZrV7Rox788zSYvH+1KUgZWejJIhb
   c0uL+Y/9235JRMMkyTb1kI/u+a47n1HShnI+9a3M+GaibBA9vgg3GWYoD
   oxCXirUI4DQ7p9JmBPf9XSwV0obMqr2N9MbDlAjxMUlaj21UqFVFkVdIY
   5ptXxzFqwPeqWK+2ZQwbsGIrj/rG1pJtlwtTvNf3TOOeDUKr+kplzwERr
   MDQSUi7LGeEyDJNNIOKpAyWRVZs1K3zpB+S2ra2AVHiwsGwppYOs4k+AB
   GQHKYiE3ED3sHeZniDyUzp5oD5Ti7kO+gsrEIHskCsf0UHG9hNMu3zCfh
   w==;
X-IronPort-AV: E=Sophos;i="5.95,195,1661788800"; 
   d="scan'208";a="219373024"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 Oct 2022 18:15:04 +0800
IronPort-SDR: DwW/cqoOm3OZYATdL/Q0Nlr/HKRk1oX6+SWdrkjNR6k9gs1ZQMyen1Wh2niDN6hqGmexAUHtrO
 Nl9BCAlOfo/XluBUS632PnEZ1y+0PeGJxq8H25ETnghQmHp/A/3GmUHApsdGp0MUQtFdja+t7w
 g8g33GkbI5piPNT1RV2/Wwu0xCOEYXQkxtVCROz4Lf7xfleVdRTnCIjoHNM4GXIOt22cthsMLl
 UFz21yiQlad8Lg20s2GGyHcPlmPdxCSjRaXxj75WcCJGnYl7+MX8oxttqDkDY9vHml38ZZuhJT
 IbnRjL4nwjbwtu7qmINOv6/y
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Oct 2022 02:28:55 -0700
IronPort-SDR: c7AAnYNnfIW9FPGqXootjB1SCWh9VOKAqAHfXkzd79ZBNmIv7H+3bMTAgNAdHIXz6lfxbiRlR2
 5GlcOiALk6OKajOq5T4h3veaiPCBoJFZn4dmnZDWqESGHRWSInQp4cihXh7mWBY4FUobiattE2
 6jC0T6ZH+pPo48R2VACHXqPgNRjoSWf3UyA0WxtbU9CdttTkm9Fq7vwobsWT+VeL2iEXUTOwT3
 C7crDy8UItYY3WBr5vwRYNh66vEz+mQSJxLvwWXQ9zgpO03NcYwdmhCdNJND+12uO+XdCKzpwF
 Daw=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Oct 2022 03:15:04 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MsmnM3CkLz1RvTr
        for <linux-scsi@vger.kernel.org>; Wed, 19 Oct 2022 03:15:03 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1666174502; x=1668766503; bh=8gIdKAEX+/l9UdMrPWxgZ7i502R9ygDTYGF
        8a7WCDkk=; b=nScoD0PcdgoUxosl9+CH+EHav1q/Jqqy+pATJD7tnJuUpxZbcrB
        2j/mke8mNV9lQcKlrYSlTQw0SIiuOQS1WHLLuD1OagWb7hypnnPBks6DifEPDyZ5
        FMfOuTX4R2pEvtUpW7EgoJ+uqaP3uzrzgPWWIhEnHh+eh2LlXcysmssawbK65j8e
        RdPGPHUcwvUxDQZfmj3pDQrhhmu3nXaXJOQQ4+Ks4U4ZuIg8ixV8WspxWKglht+x
        hioZC8KgLj/E/16Y9Fr22zFddtl5jXlSjSC8umQaH0LDQ5GkQTrt5hD2jzJUc8tj
        ohPR02x07ah/qa6BOVijJa3fDmt67cAkvNg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id fsgQkFKb3zeL for <linux-scsi@vger.kernel.org>;
        Wed, 19 Oct 2022 03:15:02 -0700 (PDT)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MsmnK6ppXz1RvLy;
        Wed, 19 Oct 2022 03:15:01 -0700 (PDT)
Message-ID: <399805b2-d632-997b-5f90-c5e98357d53a@opensource.wdc.com>
Date:   Wed, 19 Oct 2022 19:15:00 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: libata and software reset
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Hannes Reinecke <hare@suse.de>
Cc:     "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>
References: <046e86d2-17e1-e85d-08a1-744ef975171c@huawei.com>
 <7e8ef4b4-928f-895f-05ef-df111a052e8e@opensource.wdc.com>
 <a5026aa0-2674-9b2d-1a0f-ed3847fa69cc@opensource.wdc.com>
 <28c7127f-f577-9a43-2f2f-80ef89d85a0e@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <28c7127f-f577-9a43-2f2f-80ef89d85a0e@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/19/22 18:42, John Garry wrote:
> On 19/10/2022 06:04, Damien Le Moal wrote:
>> On 10/19/22 14:03, Damien Le Moal wrote:
>>> On 10/18/22 22:24, John Garry wrote:
>>>> Hi guys,
>>>>
>>>> In the hisi_sas driver there are times in which we need to issue an ATA
>>>> software reset. For this we use hisi_sas_softreset_ata_disk() ->
>>>> sas_execute_ata_cmd() -> sas_execute_tmf(), which uses libsas "slow
>>>> task" mechanism to issue the command.
>>> Something is wrong here... The reset command sent by that function is
>>> for ATAPI (DEVICE RESET command). There is no device reset command for
>>> SATA disks following the ACS standard.
> 
> Yeah, that looks wrong.
> 
>>>
>>> So hisi_sas_softreset_ata_disk() seems totally bogus to me, unless you
>>> have a CD/DVD drive connected to the HBA:)
> 
> Sure
> 
>>>
>>> This is why the softreset function is a port operation defined by LLDs.
>>> How you reset the device depends on the adapter. E.g., for AHCI, you
>>> need to send a host2device FIS with the software reset bit set.
> 
> This would be quite a standard method, right?
> 
>> See: ahci_do_softreset() for AHCI.
> 
> For ahci_do_softreset(), do you just implicitly use ATA_CMD_NOP as the
> command?
> 
> For hisi_sas, maybe ATA_CMD_DEV_RESET is silently ignored when issued
> for a SATA disk, but having SRST set/unset still takes effect (and that
> is how it still works). I need to check on that.

Checked SATA-IO v3.5a. Software reset is explained in "11.4
Software reset protocol" and involves 2 things for the host to do:

DSR0: Software_reset_asserted, this state is entered if a Register Host
to Device FIS is received with the C bit in the FIS cleared to zero and
the SRST bit set to one in the Device Control register.
If in this state, the device begins its initialization and diagnostics
processing and awaits the clearing of the SRST bit.

DSR1: Execute_diagnostics, this state is entered if a Register Host to
Device FIS is received with the C bit in the FIS cleared to zero and the
SRST bit cleared to zero in the Device Control register.
If in this state, the device completes initialization and processing of
its diagnostics.

Which confirms what libahci is doing: essentially zeroing a tf with
ata_tf_init() and setting + resetting the SRST bit, sending the tf each
time.

-- 
Damien Le Moal
Western Digital Research

