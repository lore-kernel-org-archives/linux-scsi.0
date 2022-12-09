Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91073C4167B
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 03:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiLIDij (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 22:38:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiLIDih (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 22:38:37 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3620E2F644
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 19:38:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670557115; x=1702093115;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fgESi8YQzZ0g91NBar7p1m7+FvQiZuq/HMZDT9kkcHk=;
  b=iz/7dzOv0Pa89upqWttFhVjclXKTBKxwseQTASyiRceJ+E7dcAAjs4Q7
   KXEGev7bEdxHTlenvV/QzO1xro3Xt+rM3l5nqT2ENfJ42Ig//gTSWM6lB
   0EADIEG3X+YJRxB0kwypU27NNbg6tPTTSEWzDDBFZYO2qpxL62BJ3/8+e
   TRwgq27IqO5jejTDZEc33+DlXz0zjl1KgxBWc+2lEnlfacK3EZi7vNVmb
   Pw00XBowPsFlO51K3obtGdX4Cx9+Om0I/rE4LruwErA/QpccojumDZEEU
   Hkqo1r397jyDfc+q6OH9vRntOaMzweeENofCWvG0TcLDbWeMcgLB0LWzs
   w==;
X-IronPort-AV: E=Sophos;i="5.96,230,1665417600"; 
   d="scan'208";a="218510335"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Dec 2022 11:31:22 +0800
IronPort-SDR: sr2zSkPl3SLTE1GJha450A/afXlvbuMAqbss/boH0llST3ONmOlxlaKlxzSbmXq/XmTKK2Liyj
 n4PFNk27euhM5/5tndKMD17y6rNxq1vuU4wylWlaQd/PJt8ei1UcTnJCYAYqEhkDcn9HP+Ml5R
 XLZwu1zqI8H3OQ6zzOdu2vhyVrOC5nHPBskfc2HWphC6YPVr+DBjkGUIITd+4r779moSR68tW8
 xCzz+BT4+by1r874h13fnVhgx7OjbmBLSduf93VH3vspbErj2wWLAa0SEijwvK9c+lfbwT8iI+
 11o=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Dec 2022 18:44:06 -0800
IronPort-SDR: grS1KzoritAaFoVT0IvLjH1/tqzwyu3DIV5LKK4TFUTFDmJ1ipi9iVz+uDSPXpR6v4vcz7/enn
 YfJ6Y9V79gbBgGDxJfqynEEBnZryO8pHQvm3IXsWV1aVdTUltP8tUgUH1ph7TGX4KgppXBtGgC
 u+l0s+DW0j+USXANoJiCkOSB4takJgKxX1rYoq/+nxtr4SVwsRnPWJaoHG+oZan7t9RamvIv1a
 z24PfcmMVoAir8lfDX+tsgOvl5T15SKFgHBaSP6IxzQuYbpMjRd/k9ENB4eiKs9r8dO9Pj5z+5
 +j8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Dec 2022 19:31:22 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4NSxQ231Szz1Rwrq
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 19:31:22 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1670556681; x=1673148682; bh=fgESi8YQzZ0g91NBar7p1m7+FvQiZuq/HMZ
        DT9kkcHk=; b=sacPalBbWsCn2gCH5JXjmi0YENJrLzlVNjITBsUplK5YwiGKIwX
        HT39G7sIR63+nkbUu15RjGEGkS/AA2RvO8GzTcfPiQGUr7X3dYv6CnxUrGSxzn8l
        ySGNEZJtrMjA0GqnCTs4v3NxO9//tPLxy/bSGo0LivaTX+p5iZPUyezR4TNj2tSZ
        EKKAu6GOW063gH7lar7i8/FOA64b3aiQkIBmQIEbaMX/PKSCacN1mnGqoljqeFLn
        0uOTw2LU3IkHTB5eJbKpfQu2yXsVLJD/Ota77o4iV6/y8DjTXCFe4hhQ6wVVFVLi
        tYrcgD7ludLJ2J1xyebzTgMHWwBMY/l196A==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id P-PvLJs08KoJ for <linux-scsi@vger.kernel.org>;
        Thu,  8 Dec 2022 19:31:21 -0800 (PST)
Received: from [10.225.163.85] (unknown [10.225.163.85])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4NSxQ10hzZz1RvLy;
        Thu,  8 Dec 2022 19:31:20 -0800 (PST)
Message-ID: <ad6c7534-14dc-d48a-f5f1-a35c649a42bd@opensource.wdc.com>
Date:   Fri, 9 Dec 2022 12:31:19 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 25/25] Documentation: sysfs-block-device: document command
 duration limits
Content-Language: en-US
To:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        linux-kernel@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
References: <20221208105947.2399894-1-niklas.cassel@wdc.com>
 <20221208105947.2399894-26-niklas.cassel@wdc.com>
 <Y5Kp/JhhwF1rjrdu@debian.me>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <Y5Kp/JhhwF1rjrdu@debian.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/9/22 12:22, Bagas Sanjaya wrote:
> On Thu, Dec 08, 2022 at 11:59:41AM +0100, Niklas Cassel wrote:
>> +What:		/sys/block/*/device/duration_limits/enable
>> +Date:		Dec, 2022
>> +KernelVersion:	v6.3
>> +Contact:	linux-scsi@vger.kernel.org
>> +Description:
>> +		(RW) For ATA and SCSI devices supporting the command duration
>> +		limits feature, write to the file to turn on or off the
>> +		feature. By default this feature is turned off. If the device
>> +		does not support the command duration limits feature, this
>> +		attribute does not exist (the directory
>> +		"/sys/block/*/device/duration_limits" does not exist).
>> +		Writing "1" to this file enables the use of command duration
>> +		limits for read and write commands in the kernel and turns on
>> +		the feature on the device. Writing "0" disables the feature.
> 
> Sphinx reported inline emphasis warning due to unescaped asterisk above:
> 
> Documentation/ABI/testing/sysfs-block-device:101: WARNING: Inline emphasis start-string without end-string.
> 
> I have applied the fixup:

[...]

>> <snipped>...
>> +		    Possible values are:
>> +
>> +		      - 0x0: The device will complete the command at the
>> +			     earliest possible time (i.e, do nothing based on
>> +			     the time limit not being met).
>> +		      - 0xD: The device will complete the command and an IO
>> +			     failure will be reported to the user with the ETIME
>> +			     error code.
>> +		      - 0xF: Same as 0xD.
>> +
> 
> The lists items above looks poorly indented in htmldocs (due to use of
> proportional fonts). The fix is to align to first character after bullet
> list marker, like:

Thanks for the hints. Will fix that in v2.


-- 
Damien Le Moal
Western Digital Research

