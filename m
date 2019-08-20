Return-Path: <SRS0=HqgQ=WQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4DF6C3A589
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Aug 2019 17:19:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B572C22CF7
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Aug 2019 17:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730553AbfHTRT1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Aug 2019 13:19:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49804 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbfHTRT1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Aug 2019 13:19:27 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DD5D26412B;
        Tue, 20 Aug 2019 17:19:26 +0000 (UTC)
Received: from [10.10.123.202] (ovpn-123-202.rdu2.redhat.com [10.10.123.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 165F45C298;
        Tue, 20 Aug 2019 17:19:25 +0000 (UTC)
Subject: Re: [PATCH v2 1/2] scsi: target/tcm_loop: ignore already deleted scsi
 device
To:     Bart Van Assche <bvanassche@acm.org>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20190820090429.1961085-1-naohiro.aota@wdc.com>
 <1973f310-ad00-ff88-fe08-a31f81dc5c33@acm.org> <5D5C1159.4030507@redhat.com>
 <737dd6be-a8c9-492c-8057-1f16b3d90519@acm.org>
Cc:     Nicholas Bellinger <nab@linux-iscsi.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
From:   Mike Christie <mchristi@redhat.com>
Message-ID: <5D5C2B9D.1070307@redhat.com>
Date:   Tue, 20 Aug 2019 12:19:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.6.0
MIME-Version: 1.0
In-Reply-To: <737dd6be-a8c9-492c-8057-1f16b3d90519@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Tue, 20 Aug 2019 17:19:26 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08/20/2019 10:43 AM, Bart Van Assche wrote:
> On 8/20/19 8:27 AM, Mike Christie wrote:
>> tcm loop does not take a reference to the scsi_device at creation/link
>> time then need to release at removal/unlink time. The above
>> scsi_device_put is for the successful scsi_device_lookup call. tcm loop
>> works like a scsi host driver that does its own scanning via
>> scsi_add_device (maybe similar to scsi drivers that are raid cards).
>> Like other host drivers it does not take a reference to the device when
>> it is added and relies on scsi-ml to handle all that for it before doing
>> operations like queuecommand.
>>
>> The leak is if you removed the scsi_device via the scsi ml sysfs
>> interface then there is no way to completely unlink the lio port because
>> if scsi_device_lookup fails we return from the function and do not do
>> not release our refcount on the tl_tpg_port_count.
> 
> Hi Mike,
> 
> Does this mean that you think that this patch is the right way to
> address the reported issue?
> 

It fixes that very specific issue, but it leaves others. Maybe it could
be used in a patchset that builds on it?

I think we could hit issues like:

1. tcm_loop_port_unlink runs and releases tl_tpg_port_count count.
2. userspace initiated scan commands were in progress and complete.
target_fabric_port_unlink->core_dev_del_lun->core_tpg_remove_lun was
waiting for those last IOs and now completes and deletes the mapped lun
from lio.
3. scsi-ml scan completed before the unmapping and so now we have a
scsi_device but no lio lun mapping.


The problem with this is that:

1. We can hit mismatched settings like this:

A. We now have this scsi_device at LUN0, but no lio mapping. User thinks
everything got cleaned up ok, so they decide to map another lio lun.
B. tcm_loop_port_link just does a scsi_add_device which does
scsi_probe_and_add_lun with rescan=true. So the original scsi_device is
returned. It is not reprobed so whatever settings the old device has
will be used. Maybe that scsi_device was for a disk and now the user was
adding a CD.

2. And hit races like:

A. tl_tpg_port_count might now be zero so the tpg and nexus can be removed.
B. That removal can race with IO being sent to the scsi_device. If a
command has passed tcm_loop_submission_work's NULL tl_nexus check then
we will hit a NULL pointer crash later in the function.


