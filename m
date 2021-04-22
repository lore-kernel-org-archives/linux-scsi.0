Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D4C5C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 15:46:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E19046140F
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 15:46:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236547AbhDVPq5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 11:46:57 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:32988 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236586AbhDVPqw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Apr 2021 11:46:52 -0400
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id C13772EA476;
        Thu, 22 Apr 2021 11:46:16 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id x2WCZTn+7qkU; Thu, 22 Apr 2021 11:26:27 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 2B76E2EA477;
        Thu, 22 Apr 2021 11:46:16 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH 07/42] scsi: Kill DRIVER_SENSE
To:     Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210421174749.11221-1-hare@suse.de>
 <20210421174749.11221-8-hare@suse.de>
 <b365b179-c82c-57fc-1b4c-32bfbe003672@acm.org>
 <df94d8e2-67de-f613-3a89-2754aaad4038@suse.de>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <b716b3b7-8a1e-ebb2-49a7-5aab18af8524@interlog.com>
Date:   Thu, 22 Apr 2021 11:46:15 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <df94d8e2-67de-f613-3a89-2754aaad4038@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-04-22 2:31 a.m., Hannes Reinecke wrote:
> On 4/21/21 11:06 PM, Bart Van Assche wrote:
>> On 4/21/21 10:47 AM, Hannes Reinecke wrote:
>>> diff --git a/drivers/scsi/megaraid/megaraid_mbox.c 
>>> b/drivers/scsi/megaraid/megaraid_mbox.c
>>> index 6a5b844a8499..2b6138a7c71f 100644
>>> --- a/drivers/scsi/megaraid/megaraid_mbox.c
>>> +++ b/drivers/scsi/megaraid/megaraid_mbox.c
>>> @@ -2299,8 +2299,7 @@ megaraid_mbox_dpc(unsigned long devp)
>>>                   memcpy(scp->sense_buffer, pthru->reqsensearea,
>>>                           14);
>>> -                scp->result = DRIVER_SENSE << 24 |
>>> -                    DID_OK << 16 | CHECK_CONDITION << 1;
>>> +                scp->result = DID_OK << 16 | SAM_STAT_CHECK_CONDITION;
>>>               }
>>>               else {
>>>                   if (mbox->cmd == MBOXCMD_EXTPTHRU) {
>>> @@ -2308,9 +2307,8 @@ megaraid_mbox_dpc(unsigned long devp)
>>>                       memcpy(scp->sense_buffer,
>>>                           epthru->reqsensearea, 14);
>>> -                    scp->result = DRIVER_SENSE << 24 |
>>> -                        DID_OK << 16 |
>>> -                        CHECK_CONDITION << 1;
>>> +                    scp->result = DID_OK << 16 |
>>> +                        SAM_STAT_CHECK_CONDITION;
>>>                   } else
>>>                       scsi_build_sense(scp, 0,
>>>                                ABORTED_COMMAND, 0, 0);
>>
>> Since DID_OK == 0 I prefer to leave out the 'DID_OK << 16' expressions from 
>> code that is modified.
>>
> Okay, will do.
> 

If DID_OK << 16 (and the extra bitwise OR) does not generate any code
then I think it is pretty good inline documentation to show LLDs how
to build the "compound" 32 bit integer in error situations.

If there is no runtime penalty, I would prefer to keep it :-)

Doug Gilbert
