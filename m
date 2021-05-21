Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 185A5C04FF3
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 21:56:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE7E0613F5
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 21:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbhEUV5t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 May 2021 17:57:49 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:35224 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhEUV5p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 May 2021 17:57:45 -0400
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id B5CB22EA2F1;
        Fri, 21 May 2021 17:56:20 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id 65WCzJyE3B32; Fri, 21 May 2021 17:34:34 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 1049F2EA0B0;
        Fri, 21 May 2021 17:56:20 -0400 (EDT)
Reply-To: dgilbert@interlog.com
To:     linux-scsi <linux-scsi@vger.kernel.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Subject: REQ_HIPRI and SCSI mid-level
Cc:     Hannes Reinecke <hare@suse.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Ming Lei <ming.lei@redhat.com>
Message-ID: <8c490b4a-aac0-7451-8755-e05bb3ee3d32@interlog.com>
Date:   Fri, 21 May 2021 17:56:19 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The REQ_HIPRI flag on requests is associated with blk_poll() (aka iopoll)
and assumes the user space (or some higher level) will be calling
blk_poll() on requests marked with REQ_HIPRI and that will lead to their
completion.

In lk 5.13-rc1 the megaraid and scsi_debug LLDs support blk_poll() [seen
by searching for 'mq_poll'] with more to follow, I assume. I have tested
blk_poll() on the scsi_debug driver using both fio and the new sg driver.
It works well with one caveat: as long as there isn't an error.
After fighting with that error processing from the ULD side (i.e. the
new sg driver) and the LLD side I am concluding that the glue that
holds them together, that is, the mid-level is not as REQ_HIPRI aware
as it should be.

Yes REQ_HIPRI is there in scsi_lib.c but it is missing from scsi_error.c
How can scsi_error.c re-issue requests _without_ taking into account
that the original was issued with REQ_HIPRI ? Well I don't know but I'm
pretty sure that is close to the area that I see causing problems
(mainly lockups).

As an example the scsi_debug driver has an in-use bitmap that when a new
request arrives the code looks for an empty slot. Due to (incorrect)
parameter setup that may fail. If the driver returns:
     device_qfull_result = (DID_OK << 16) | SAM_STAT_TASK_SET_FULL;
then I see lock-ups if the request in question has REQ_HIPRI set.

If that is changed to:
     device_qfull_result = (DID_ABORT << 16) | SAM_STAT_TASK_SET_FULL;
then my user space test program sees that error and aborts showing the
TASK SET FULL SCSI status. That is much better than a lockup ...

Having played around with variants of the above for a few weeks, I'd
like to throw this problem into the open :-)


Suggestion: perhaps the eh could give up immediately on any request
with REQ_HIPRI set (i.e. make it a higher level layer's problem).

Doug Gilbert
