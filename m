Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2507C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 20:21:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7266423A53
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 20:21:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbhANUVr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 15:21:47 -0500
Received: from mail-1.ca.inter.net ([208.85.220.69]:54627 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbhANUVr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2021 15:21:47 -0500
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 751DE2EA3FF;
        Thu, 14 Jan 2021 15:21:06 -0500 (EST)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id 9mYsTDTFDIxU; Thu, 14 Jan 2021 15:07:46 -0500 (EST)
Received: from [192.168.48.23] (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id A97472EA095;
        Thu, 14 Jan 2021 15:21:05 -0500 (EST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v13 28/45] sg: rework debug info
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com,
        kashyap.desai@broadcom.com
References: <20210113224526.861000-1-dgilbert@interlog.com>
 <20210113224526.861000-29-dgilbert@interlog.com>
 <d9337b54-6d27-b109-9667-5a913f82797f@suse.de>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <790d2d71-4777-a66a-cdd6-edd1369c7113@interlog.com>
Date:   Thu, 14 Jan 2021 15:21:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d9337b54-6d27-b109-9667-5a913f82797f@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-01-14 2:12 a.m., Hannes Reinecke wrote:
> On 1/13/21 11:45 PM, Douglas Gilbert wrote:
>> Since the version 2 driver, the state of the driver can be found
>> with 'cat /proc/scsi/sg/debug'. As the driver becomes more
>> threaded and IO faster (e.g. scsi_debug with a command timer
>> of 5 microseconds), the existing state dump can become
>> misleading as the state can change during the "snapshot". The
>> new approach in this patch is to allocate a buffer of
>> SG_PROC_DEBUG_SZ bytes and use scnprintf() to populate it. Only
>> when the whole state is captured (or the buffer fills) is the
>> output to the caller's terminal performed. The previous
>> approach was line based: assemble a line of information and
>> then output it.
>>
> Hmm. The whole '/proc' business is considered deprecated, and new
> (or updated) drivers should be moving to debugfs.
> Wouldn't it be better to do that, and deprecate /proc/sg, seeing that
> you are rewriting the entire driver anyway?

Well '/proc/scsi/sg/*' is in the public interface, so to remove it
represents a breakage. Like many developers I run lots of virtual
terminals with as few as possible logged in as 'root'. So I consider
it a definite advantage that cat /proc/scsi/sg/debug does not need
elevated permissions like the debugfs equivalent does. The security
folks would probably take the opposite view.

It is in debugfs: cat /sys/kernel/debug/scsi_generic/snapshot
is equivalent to cat /proc/scsi/sg/debug.

So currently we have both. Well not quite as this first series
hasn't been accepted after more than a year of attempts. IMO it
is a bit early to deprecate before the replacement is even in place.


New features are only being placed in debugfs. For example, there
is a new feature in patch 59 of series 2 using the new
ioctl(SG_SET_GET_EXTENDED) and the SG_CTL_FLAGM_SNAP_DEV flag to
programmatically send a snapshot of the sg object tree to
/sys/kernel/debug/scsi_generic/snapped .

Doug Gilbert



