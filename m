Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 905F0C10DCE
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 03:58:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68B16208E4
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 03:58:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgCJD60 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Mar 2020 23:58:26 -0400
Received: from smtp.infotech.no ([82.134.31.41]:36368 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgCJD60 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 9 Mar 2020 23:58:26 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id BCF58204172;
        Tue, 10 Mar 2020 04:58:23 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id RVoUUmr2VBe3; Tue, 10 Mar 2020 04:58:22 +0100 (CET)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 725EB204154;
        Tue, 10 Mar 2020 04:58:20 +0100 (CET)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH] scsi: avoid repetitive logging of device offline messages
To:     "Ewan D. Milne" <emilne@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org
References: <20200309181416.10665-1-emilne@redhat.com>
 <1583780754.3429.26.camel@HansenPartnership.com>
 <9407d2f1dd538d2b5eb8663a44bab049eb6917dd.camel@redhat.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <56744a31-6053-f79b-0794-bdfec52fee52@interlog.com>
Date:   Mon, 9 Mar 2020 23:58:19 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <9407d2f1dd538d2b5eb8663a44bab049eb6917dd.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-03-09 4:49 p.m., Ewan D. Milne wrote:
> On Mon, 2020-03-09 at 12:05 -0700, James Bottomley wrote:
>> On Mon, 2020-03-09 at 14:14 -0400, Ewan D. Milne wrote:
>>> Large queues of I/O to offline devices that are eventually
>>> submitted when devices are unblocked result in a many repeated
>>> "rejecting I/O to offline device" messages.  These messages
>>> can fill up the dmesg buffer in crash dumps so no useful
>>> prior messages remain.  In addition, if a serial console
>>> is used, the flood of messages can cause a hard lockup in
>>> the console code.
>>>
>>> Introduce a flag indicating the message has already been logged
>>> for the device, and reset the flag when scsi_device_set_state()
>>> changes the device state.
>>>
>>> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
>>> ---
>>>   drivers/scsi/scsi_lib.c    | 8 ++++++--
>>>   include/scsi/scsi_device.h | 2 ++
>>>   2 files changed, 8 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>>> index 610ee41..d3a6d97 100644
>>> --- a/drivers/scsi/scsi_lib.c
>>> +++ b/drivers/scsi/scsi_lib.c
>>> @@ -1240,8 +1240,11 @@ scsi_prep_state_check(struct scsi_device
>>> *sdev, struct request *req)
>>>   		 * commands.  The device must be brought online
>>>   		 * before trying any recovery commands.
>>>   		 */
>>> -		sdev_printk(KERN_ERR, sdev,
>>> -			    "rejecting I/O to offline device\n");
>>> +		if (!sdev->offline_already) {
>>> +			sdev->offline_already = 1;
>>> +			sdev_printk(KERN_ERR, sdev,
>>> +				    "rejecting I/O to offline
>>> device\n");
>>> +		}
>>
>> Offline->online is a legal transition, so you'll need to clear this
>> flag when that happens so we get another offline message if it goes
>> offline again.
>>
>> James
>>
> 
> That's what resetting the flag in scsi_device_set_state() does.
> The only thing that worries me is if some driver manipulates the
> sdev->sdev_state value directly.

Perhaps they could sneak in some c++isms and allow the definition
of struct fields to be preceded by [[protected]]. The idea would be
to complain loudly if that field is directly accessed. The accessor
functions might need something similar (or the same decoration) to
defeat that noise.

In the meantime:

Reviewed-by: Douglas Gilbert <dgilbert@interlog.com>

