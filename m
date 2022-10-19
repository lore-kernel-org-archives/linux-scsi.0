Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 150F0C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Oct 2022 10:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbiJSKRE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Oct 2022 06:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbiJSKQX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Oct 2022 06:16:23 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC95F10CFAA
        for <linux-scsi@vger.kernel.org>; Wed, 19 Oct 2022 02:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666173458; x=1697709458;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nGvKGdMtTYn/kbWG8KiQUT5+/FEcbkGC9scQHWkBRZE=;
  b=Rz0/L9voD2k+j18B1DIUs16NLgyke7QXNZjvKF0SADpEnpXm2HfS2C7d
   Dt+vccTUeDuZOXowntjpVnHI9yMu1AfqWfbdwZCtxFUD7XSVqUFRhoUpE
   tfAbBbSpCuQxTmjdwj0+3v/ZM9RaHM+4JICeY6gVz2V3Rqlj9lGxJIowI
   AoYqSb6mKlErjcqUrRmtTaap/SE/iyoyW1yyADzcLNzrXzBSkXSlxYFlZ
   BDaRtmJEowQcAU5ZHf3In9zZOCesgT50E3AjrsLr6gkzEK2k9WVbeSqUE
   JaBqj4RhtZryP5CNVC08QLiqMvYrez2C+WgL5IsNjoE7SGVZ5psE/EZBI
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,195,1661788800"; 
   d="scan'208";a="214212854"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 Oct 2022 17:56:44 +0800
IronPort-SDR: trheaP3UpRozaT3IXYSkJeh2UlyYBOu50K4l3juVBqaQ0WMBCkW35tVdK8K1GxG+skRUx6KoTw
 eVEVq9sIV7zXbRj9BYU/Qhm7APIedJDHheiNH/jVvZ7zOTyLMAnvtdZebayWEcrIVW0t57Sh02
 Ll4omVegya4k7QmTqEs1Dj3vyfxkSkje0ruB5WDJ0Dg+VaHu4FU2F12bzATRtConbdzN1N20jN
 SgvOmy8d4dzS9LjFh4fpafPGsLDfgSN+GZhbyvgnksobzm5s7OQFh6BWlqO+tXbGJmbSQKAmOI
 AWnfURsQPRlpwRobLniGvwa8
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Oct 2022 02:10:35 -0700
IronPort-SDR: VIQ7yKsPAlRD459gu2IzvLgJSFg7QUAoNVMv///KEGkroL25oD2fpc5mAayfUG7SPlXnbr6GdV
 l1r0/Je1xNToyL6GxGPccofPfcSTDBYQepjM+y/Mbo/XNooicxAUPCf/3FssIGi2DSX/iu/IiW
 HDxodNmLneRQeN99g8AGuFOSirxX5x4HTH4FUIsWZ17bYay6v0AWppy3m3Nmj0CHpVk2pokQL8
 lffKpPdtjj3I+LDuf6pKdRyTk/2MpyN26XEJR7QLmZF7pAWaZeWXX2qQwzlJUmxLwpm9eictlr
 ya4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Oct 2022 02:56:45 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MsmND07rcz1RvTp
        for <linux-scsi@vger.kernel.org>; Wed, 19 Oct 2022 02:56:43 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1666173403; x=1668765404; bh=nGvKGdMtTYn/kbWG8KiQUT5+/FEcbkGC9sc
        QHWkBRZE=; b=WVz+Z/894Fp32yWP1H444/hegyeEaNvf2otWa9Z/q0a5+hbcm0l
        7yBYVsaDj6ZR7rqUh/jw0l8EeKaj0NAp7W4H6DBd9t+qxTviBnOJZdmgE7X/R+5r
        FO53HdmwX6pyuHahZGi6AHj2BFAPA9A8h+ErXc38ML04gjHpInsfvhgR66gGxYJB
        sGGkfa7iJ8O8r396KAZQ1zR1oYePb1o9LJZamttlDBmI8SFaG/NtFUDsbGfU7/TD
        hqsTka81JlpZXZrZ/pXH+IfQYCtItotNJtFJKAmBZQwSjP0pXQCfQX00/gnF2Igc
        hoiXCtmYhA8O9xMi75a0f+T97A1AlWlrMPw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 2dQGsC9g9uc3 for <linux-scsi@vger.kernel.org>;
        Wed, 19 Oct 2022 02:56:43 -0700 (PDT)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MsmNB1wxtz1RvLy;
        Wed, 19 Oct 2022 02:56:42 -0700 (PDT)
Message-ID: <01229332-aa52-0952-5ef5-a223d726a369@opensource.wdc.com>
Date:   Wed, 19 Oct 2022 18:56:41 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: libata and software reset
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     Hannes Reinecke <hare@suse.de>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>
References: <046e86d2-17e1-e85d-08a1-744ef975171c@huawei.com>
 <Y07AmUoyq8+HVzQU@x1-carbon>
 <4011744f-d6b5-acab-4efa-95465df4e98b@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <4011744f-d6b5-acab-4efa-95465df4e98b@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/19/22 18:32, John Garry wrote:
> On 18/10/2022 16:04, Niklas Cassel wrote:
>>> Hi guys,
>>>
>>> In the hisi_sas driver there are times in which we need to issue an A=
TA
>>> software reset. For this we use hisi_sas_softreset_ata_disk() ->
>>> sas_execute_ata_cmd() -> sas_execute_tmf(), which uses libsas "slow
>>> task"
>>> mechanism to issue the command.
>>>
>>> I would like if libata provided such a function to issue a software
>>> reset,
>>> such that we can send the command as an ATA queued command.
>>>
>>> The problem is that often when we would want to issue this software
>>> reset
>>> the associated ata port is frozen, like in ATA EH, and so we cannot
>>> issue
>>> ATA queued commands - internal or normal - at that time.
>>>
>>> Is there any way to solve this? Or I am just misunderstanding how and
>>> when
>>> ATA queued commands can and should be used?
>>>
>> Hello John,
>=20
> Hi Niklas,
>=20
>>
>> See the kdoc above __ata_port_freeze():
>> "This function is called when HSM violation or some other
>> condition disrupts normal operation of the port.=C2=A0 Frozen port
>> is not allowed to perform any operation until the port is
>> thawed, which usually follows a successful reset.
>=20
> ok, I see.
>=20
>>
>> ap->ops->freeze() callback can be used for freezing the port
>> hardware-wise (e.g. mask interrupt and stop DMA engine).=C2=A0 If a
>> port cannot be frozen hardware-wise, the interrupt handler
>> must ack and clear interrupts unconditionally while the port
>> is frozen."
>>
>>
>> ata_port_operations.qc_issue() is obviously an operation on the port,
>> so it makes sense that it is not allowed.
>=20
> hmmm..ok, then.
>=20
>=20
>> Interrupts are also usually masked or disabled at this time, so we
>> won't get an IRQ with the completion.
>=20
> Doesn't this policy really just depend on the host controller driver?
>=20
>>
>> Perhaps one could argue that there could be an API to execute a polled
>> command. But if the port is in a bad state,
> =C2=A0e.g. a HSM error (RDY bit
>> is not set), issuing a command would likely fail anyway, regardless if
>> using polling or IRQs.
>>
>>
>>> I assume that ata_port_operations.softreset callback requires a
>>> method to be
>>> able to issue the softreset directly from the driver, like
>>> ahci_softreset()
>>> -> ahci_do_softreset() -> ahci_exec_polled_cmd().
>> Yes, looking .softreset in a few ata drivers, they all seem issue the
>> softreset directly from the driver.
>> (e.g. ahci_do_softreset() calls ahci_exec_polled_cmd() which just alwa=
ys
>> uses bit 0 in PORT_CMD_ISSUE, so it ignores hw_tag.)
>>
>> But I don't think that I fully understand your problem.
>>
>> hisi_sas_softreset_ata_disk() -> sas_execute_ata_cmd() ->
>> sas_execute_tmf()
>> calls lldd_execute_task() (hisi_sas_queue_command()) and then calls
>> waits for completion.
>>
>> How is this different from e.g. the libahci case?
>=20
> The difference really comes down to the controller programming interfac=
e.
>=20
> For ahci we have a MMIO interface to issue the software reset command.
>=20
> For my SAS controller of interest, there is no such MMIO interface. To
> issue the reset we build a h2d fis with a SRST set, and send on the
> controller ring buffer like any other IO.
>=20
> As I mentioned, we can set the SRST for the h2d fis on the HW interface
> without issue, and it works fine. The problem for me is that the comman=
d
> comes via libsas/driver, and I would like it to come from libata such
> that it has a ATA queued command associated. But then we have the
> problem that the port is frozen at such times that we want to issue thi=
s
> command.

Yeah, qc is too high level for this to work. But we could probably do
something generic at TF or FIS level. libata-sata.c has already some
code in that area, something for a "reset TF/FIS" would fit in that file
too. libahci could also use that too.

>=20
>> Doesn't this end up being the same as resetting the port directly from
>> the
>> driver? (if we ignore all the callbacks)
>> Or do you actually get stuck on a ata_port_is_frozen() check somewhere=
?
>=20
>=20
> Thanks,
> John

--=20
Damien Le Moal
Western Digital Research

