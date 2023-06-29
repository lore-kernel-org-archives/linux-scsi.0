Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD97DEB64D7
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jun 2023 00:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbjF2ACk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jun 2023 20:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbjF2ACN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2023 20:02:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFC2ED
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2023 17:02:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 446D1614A3
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jun 2023 00:02:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C56FC433C9;
        Thu, 29 Jun 2023 00:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687996930;
        bh=4FIqSfkn/x7PHdQvk4Z/mXdFRPvN0Nis/BEaK6UZWEA=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=uQVh5IRRyQ+acSZM0D9WPYlLvLVPGOps/hxBJSW01ydnXI+lHxyfVLv6od5w/MMqW
         gzOmMNHEhF10m0G3qQIphUZgjF1PF4JMlBLoW+LIq5sYxH3NKoiul6BPRLmfwX/2Lp
         S+O84xgZLrdyWJuigVMpa8YKDXN5l3YIIMYW0c0wC8McAGqTsw8nCSeFMhg7zjqBCN
         UStn6vSyL/yAeWkdMvaLGgjJY523RmqvODawP3gBHhaIZbK/eDOb0kNQyt55l6BxtW
         CX2jh+zR5tJYL/ApW6Z9miBbAITAvouxReRp7lR6QBStjchuQt2ikDYsyx4dmBzIaT
         JjplbCbVWUmuQ==
Message-ID: <f6e5e9d2-3446-ef52-a090-4eef1bd2daa3@kernel.org>
Date:   Thu, 29 Jun 2023 09:02:09 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [RFC] Support for Write-and-Verify only drives
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_Rozsny=c3=b3?= <daniel@rozsnyo.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <c6499ed7-d049-5714-f827-734cff3f6305@rozsnyo.com>
 <eca63b83-1cf4-40ac-114d-f23acc7cadea@acm.org>
 <97f19b02-045a-825c-6a30-18fc3dcb35cd@rozsnyo.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <97f19b02-045a-825c-6a30-18fc3dcb35cd@rozsnyo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/29/23 08:40, Daniel Rozsnyó wrote:

Please wrap your emails lines to under 80 chars.

> 
> On 6/29/23 00:54, Bart Van Assche wrote:
>> On 6/26/23 13:35, Daniel Rozsnyó wrote:
>>> There are some drives, or more precisely - normal drives with a custom
>>> firmware, that simply reject a regular Write - likely as not being good
>>> enough for the intended high-rel application - which I can understand,
>>> but even after reformatting the drive to no-PI and going to "poor" 512B
>>> sector size, they still refuse to do an easy Write operation. I had
>>> verified that by using the sg_write_verify (that uses an ioctl) I can
>>> really write data to these drives. The reading path is working okay and
>>> both dd and hdparm works at expected speeds.
>> 
>> To me the above sounds like the drive firmware is broken. Please fix the
>> drive firmware and make sure that WRITE commands are accepted.
> 
> 
> It is not broken - it is by design. Or call it a feature (although it would
> be nice to have a configurable flag that controls the rejection on the drive
> side).
> 
> 
> Same principle as is in place for more than a decade with server BIOSes (eg
> from Supermicro) insisting on using ECC equipped memory - otherwise a
> specific POST code happens and the machine wont start, even that non-ECC one
> would be fine on the given CPU/IMC (and indeed does run on other brands).
> 
> 
> (IRONY ON) If your approach is so "simple" - could you just "simply" ban from
> Linux a complete lineup of 2 major hard drive vendors (Seagate, HGST), until
> they do fix my particular firmware? Sure we do not want to support these
> incompetent drive makers that ship drives with a potentially "broken" fw.
> (IRONY OFF)
> 
> 
> I could contact the vendors, but the firmware is not made for me - so I have
> naturally no control over it. And the drive does not accept a firmware flash
> to its own generic firmware family (now that I would say that went a bit too
> far).
> 
> 
> So could we at least find any reference from a T10 committee - how they
> classify the WRITE command?
> 
> - is it being a mandatory operation? Is that written in any SPC/SBC spec?
> 
> 
> Oh - I did it: https://www.t10.org/lists/op-alph.htm and you wont be happy:
> 
> The WRITE(10) is *OPTIONAL* for a Direct Access Block Device (SBC-4)

All write commands are optional in SBC.

> - so nope, the firmware which has no WRITE command is NOT broken according to
> the T10 standards.
> 
> 
> Lets get back to the original request/question then. What is the proper
> approach to handle such command variation?

When scanning the drive, you need to poke it using scsi_report_opcode() to
determine which write operation is supported. Then sd.c need to be modified to
generate the proper write command if the regular WRITE 10/16/32 are not
supported. You will also need to make sure that this does not break ATA drives
managed with libata, so check libata-scsi translation.

Not saying this can all be accepted though. But that is what is needed.

Martin ?

> 
> Daniel
> 

-- 
Damien Le Moal
Western Digital Research

