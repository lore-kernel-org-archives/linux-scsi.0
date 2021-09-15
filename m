Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 966D5C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 17:55:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73BE761212
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 17:55:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbhIOR5C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Sep 2021 13:57:02 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:39124 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhIOR5C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Sep 2021 13:57:02 -0400
Received: from mp-mx11.ca.inter.net (mp-mx11.ca.inter.net [208.85.217.19])
        by mail-1.ca.inter.net (Postfix) with ESMTP id A4FA02EAA48;
        Wed, 15 Sep 2021 13:55:42 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by mp-mx11.ca.inter.net (mp-mx11.ca.inter.net [208.85.217.19]) (amavisd-new, port 10024)
        with ESMTP id C6Cre-q0h4_0; Wed, 15 Sep 2021 13:55:42 -0400 (EDT)
Received: from [192.168.48.23] (host-45-78-207-107.dyn.295.ca [45.78.207.107])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id DFE982EAA46;
        Wed, 15 Sep 2021 13:55:41 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH V3 1/1] scsi/ses: Saw "Failed to get diagnostic page 0x1"
To:     jejb@linux.ibm.com, wenxiong@linux.vnet.ibm.com
Cc:     linux-scsi@vger.kernel.org, brking1@linux.vnet.ibm.com,
        martin.petersen@oracle.com, wenxiong@us.ibm.com
References: <1631711048-6177-1-git-send-email-wenxiong@linux.vnet.ibm.com>
 <0912982133a254770a27b780cd2c5771739ced3b.camel@linux.ibm.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <1365506b-c31e-250e-e120-8fe54c94a068@interlog.com>
Date:   Wed, 15 Sep 2021 13:55:51 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0912982133a254770a27b780cd2c5771739ced3b.camel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-09-15 10:43 a.m., James Bottomley wrote:
> On Wed, 2021-09-15 at 08:04 -0500, wenxiong@linux.vnet.ibm.com wrote:
>> From: Wen Xiong <wenxiong@linux.vnet.ibm.com>
>>
>> Setting scsi logging level with error=3, we saw some errors from
>> enclosues:
>>
>> [108017.360833] ses 0:0:9:0: tag#641 Done: NEEDS_RETRY Result:
>> hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=0s
>> [108017.360838] ses 0:0:9:0: tag#641 CDB: Receive Diagnostic 1c 01 01
>> 00 20 00
>> [108017.427778] ses 0:0:9:0: Power-on or device reset occurred
>> [108017.427784] ses 0:0:9:0: tag#641 Done: SUCCESS Result:
>> hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
>> [108017.427788] ses 0:0:9:0: tag#641 CDB: Receive Diagnostic 1c 01 01
>> 00 20 00
>> [108017.427791] ses 0:0:9:0: tag#641 Sense Key : Unit Attention
>> [current]
>> [108017.427793] ses 0:0:9:0: tag#641 Add. Sense: Bus device reset
>> function occurred
>> [108017.427801] ses 0:0:9:0: Failed to get diagnostic page 0x1
>> [108017.427804] ses 0:0:9:0: Failed to bind enclosure -19
>> [108017.427895] ses 0:0:10:0: Attached Enclosure device
>> [108017.427942] ses 0:0:10:0: Attached scsi generic sg18 type 13
>>
>> As Martin's suggestion, the patch checks to retry on NOT_READY as
>> well as
>> UNIT_ATTENTION with ASC 0x29.
> 
> This looks fine to me.  I think the reason expecting_cc_ua doesn't work
> for you is that you're getting > 1 reset per command.  expecting_cc_ua
> automatically resets after eating the first unit attention.

Rather that simply consuming UAs, what do you think of a fixed length
FIFO, say 8 entries, that holds the asc,ascq of the last 8 UAs together
with a timestamp of when it was received (with a boot time epoch).
Then allow the user space to see that FIFO via sysfs (e.g. under
/sys/class/scsi_device/<hctl>). Remembering the previous UA may also be
useful for the mid-level UA processing. For example after a firmware
upgrade, there may be UAs for both INQUIRY data change and device reset.

Also the first device reset after a reboot (power cycle) is expected,
having one later, for example when part of a disk is mounted, is a bit
more suspicious.

Doug Gilbert


