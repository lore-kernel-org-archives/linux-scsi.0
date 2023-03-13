Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAF0AC61DA4
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Mar 2023 09:01:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbjCMJBU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Mar 2023 05:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjCMJBB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Mar 2023 05:01:01 -0400
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A95FB48E02
        for <linux-scsi@vger.kernel.org>; Mon, 13 Mar 2023 01:57:21 -0700 (PDT)
Received: from submission (posteo.de [185.67.36.169]) 
        by mout01.posteo.de (Postfix) with ESMTPS id 1CA482401FA
        for <linux-scsi@vger.kernel.org>; Mon, 13 Mar 2023 09:57:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1678697840; bh=Xogzb4/sWEPr9eGuFX02FXsCmyUAvw12H0hK+tdOhsQ=;
        h=Subject:To:From:Date:From;
        b=W4lVLheBFx9KckeHVc97VQSRwvQy+EQu3wXejd8AVbF0CM7Ofmy7i1x0ZbjHF7JN5
         PJp84USBZ5OBQ4idsk+V6KZtJRo8I/eeohSY1yKzT9WWhzJYpvAsOHorQXWYIfhjSj
         /dhKOhhkAn1bAaKtZRRCSEX7ehQc67ZMfgyBSLFtScWs5gCPpR42N11K2YwoYeQ7s5
         FNv7sL10ei+9SwnMpJJjlq74MhniMlcjuYqmYI4xs86Zh+qJLGbYz0jingY9QOs3mR
         ml2+okE2AYSbAcOFW7kizTQzLLECSIDlJy1qTj9kzpThs61FmKUbpnrJXDBs/Lt/de
         W6IRBCm/YBXFw==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4PZrBl4Wlrz9rxG
        for <linux-scsi@vger.kernel.org>; Mon, 13 Mar 2023 09:57:19 +0100 (CET)
Subject: Re: Force ignore LBPME bit by using quirks?
To:     linux-scsi@vger.kernel.org
References: <2162608f-7515-bfa7-9a5f-047495713eed@posteo.de>
From:   darkpenguin <darkpenguin@posteo.de>
Message-ID: <d12671d8-c6e8-32c6-000d-8c28e9a0b71e@posteo.de>
Date:   Mon, 13 Mar 2023 08:57:19 +0000
MIME-Version: 1.0
In-Reply-To: <2162608f-7515-bfa7-9a5f-047495713eed@posteo.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13/03/23 11:55, darkpenguin wrote:
> Hello,
> 
> Short version: is it possible to force ignore the LBPME bit and use
> UNMAP anyway? Maybe via quirks?
> 
> Long version: I've got a JMS567-based DAS from Sabrent (DS-4SSD) that
> has an, um, "weird" firmware (they've tweaked it for their reasons, and
> now it even refuses to reflash). It identifies as 152d:1561 (JMS561),
> and does not have the LBPME bit set. However, they say that Windows
> ignores this bit, and works just fine, which is why they never noticed
> the problem. So it's definitely actually supported.
> 
> I've seen a proposed patch that enables the same behaviour, but it was
> rejected for obvious reasons:
> https://www.spinics.net/lists/linux-scsi/msg95062.html
> But in the bottom, it was suggested that this might be better
> implemented via quirking.
> 
> Is there currently a way to force UNMAP on this device regardless of the
> LBPME bit? Was it implemented by quirking? I would prefer to avoid using
> a patched kernel, and I'm not even sure if that patch would still be
> (correctly) applicable to a modern kernel.
> 
> (Please CC me, I'm not on the list.)


Followup: judging by this
https://wiki.archlinux.org/title/Solid_state_drive#External_SSD_with_TRIM_support
,
my problem actually goes even deeper. I see that you can override the
wrongly-set LBPME bit by switching provisioning_mode manually. In my
case though, the LBPU bit is also 0. Argh...

My assumption is that the Windows driver is also made by the chip
manufacturer, so it ignores all the bits as long as it knows what the
identified device should be capable of.

I can switch provisioning_mode, but after that, if I issue a blkdiscard
command of any size, I get an error, and provisioning_mode goes to
"disabled".

Maybe it's because the kernel treats this device as JMS561 (as
advertised by the device), which does not support UNMAP? This is what
gives me this idea:


$ sudo sg_vpd -a /dev/sdc

Supported VPD pages VPD page:
  Supported VPD pages [sv]
  Unit serial number [sn]
  Device identification [di]
  Block limits (SBC) [bl]
  Logical block provisioning (SBC) [lbpv]
  0xde
  0xdf

Unit serial number VPD page:
  Unit serial number: DB98765432146

Device Identification VPD page:
  Addressed logical unit:
    designator type: NAA,  code set: Binary
      0x3042987654321460
    designator type: T10 vendor identification,  code set: ASCII
      vendor id: SABRENT
      vendor specific:  DISK03

Block limits VPD page (SBC):
  Write same non-zero (WSNZ): 0
  Maximum compare and write length: 0 blocks [Command not implemented]
  Optimal transfer length granularity: 1 blocks
  Maximum transfer length: 65535 blocks
  Optimal transfer length: 65535 blocks
  Maximum prefetch transfer length: 65535 blocks
  Maximum unmap LBA count: 0 [Unmap command not implemented]
  Maximum unmap block descriptor count: 0 [Unmap command not implemented]
  Optimal unmap granularity: 0 blocks [not reported]
  Unmap granularity alignment valid: false
  Unmap granularity alignment: 0 [invalid]
  Maximum write same length: 0 blocks [not reported]
  Maximum atomic transfer length: 0 blocks [not reported]
  Atomic alignment: 0 [unaligned atomic writes permitted]
  Atomic transfer length granularity: 0 [no granularity requirement
  Maximum atomic transfer length with atomic boundary: 0 blocks [not
reported]
  Maximum atomic boundary size: 0 blocks [can only write atomic 1 block]

Logical block provisioning VPD page (SBC):
  Unmap command supported (LBPU): 0
  Write same (16) with unmap bit supported (LBPWS): 0
  Write same (10) with unmap bit supported (LBPWS10): 0
  Logical block provisioning read zeros (LBPRZ): 0
  Anchored LBAs supported (ANC_SUP): 0
  Threshold exponent: 1
  Descriptor present (DP): 0
  Minimum percentage: 0 [not reported]
  Provisioning type: 0 (not known or fully provisioned)
  Threshold percentage: 0 [percentages not supported]

Only hex output supported
VPD page code=0xde:
 00     00 de 00 0c 4a 4d 00 00  00 00 00 00 00 00 00 00    ....JM..........

Only hex output supported
VPD page code=0xdf:
 00     00 df 00 11 4a 4d 00 00  00 00 00 00 00 00 00 00    ....JM..........
 10     00 00 00 00 00


So... anything I can try in this situation?..
