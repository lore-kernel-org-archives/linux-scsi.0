Return-Path: <SRS0=HqgQ=WQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58549C3A59D
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Aug 2019 14:46:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2423122DA9
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Aug 2019 14:46:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eLqaZ9NB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730002AbfHTOqn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Aug 2019 10:46:43 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38900 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729810AbfHTOqm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Aug 2019 10:46:42 -0400
Received: by mail-pf1-f195.google.com with SMTP id o70so3528026pfg.5;
        Tue, 20 Aug 2019 07:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=UrzJtR8JMVHP1TlAT8mApd+wrF+JrOxiBnpPc/9y0io=;
        b=eLqaZ9NBxbhhMhUVT+HsHYNu0HVL0X+VAs3JFVJef9YllVkDHi7kl1sW/JH78IwNCF
         GNFMdH/eI3A3GjtT9PGMy74HiGE/a2Qzn2gXS6CfMU/q6h9BRa232Y94gW26lBVv54Xc
         KnvWgPZIylYS79sBG/Pnb9GxxP5mJp75zt0PSP707jowZHVtwzbw3uqpsp5+qVaj2Iko
         LjsMR4uETEHfT0dMBSF1XS4CVmwHnv+HVxnthVRW6fB+z+ffGAEp5xf8nlRGdan7v5/3
         GtOUXo8MRRV1jQuV03YoFIYfKOVs+oNcdLU9qLTaeX4om1ZMWonzh0UMl6DTipuXiV3t
         iZXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=UrzJtR8JMVHP1TlAT8mApd+wrF+JrOxiBnpPc/9y0io=;
        b=phj46ZRJBckv+OuMXOtlujHfqyX21YMFGLxqr1CUKiC9LxfNYT3IHWxzpX4FBMu+Wu
         mbXlbOeXD72P7GgTTyAjwgDhzw46DzNXQr7BpMy5tvQa2axC+sOr+ePfbtHaTnRDgJGD
         MKfvbezuBQCVjjII0cm83XzE71ckQgnC052Iy5vzHd2WKoLLNt68TOsPTnJ0E8Zj+Fm1
         pp0MdRQnzYKUtRgRU48+5F/3ZRDfwrI62MY3LXwkeqiEn2jTOzPZWAva89U0D5KDcL+M
         OX/v4TbAM3OVVzw4+ThjssQBo+sJ/7gr4ZnIjELhBRdGhcspZgv1WGUdP5sXFynYhEhX
         9YXA==
X-Gm-Message-State: APjAAAUX0dh79jWxXKdAdyRViblhkVZLrioKgYHTOcbHqdVSx5bkACPJ
        hV7LL9xGlgT4EBqQCLOG1io=
X-Google-Smtp-Source: APXvYqxgpCsr32f8kxFLn6hBHvKtbZZS4ETJJc7KdJ4s8sVqWG6zh/FPjhiPCQtwi1cKNC9k+ORHGQ==
X-Received: by 2002:aa7:9682:: with SMTP id f2mr30161883pfk.256.1566312401956;
        Tue, 20 Aug 2019 07:46:41 -0700 (PDT)
Received: from mbalantz-desktop (d206-116-172-62.bchsia.telus.net. [206.116.172.62])
        by smtp.gmail.com with ESMTPSA id 195sm25043629pfu.75.2019.08.20.07.46.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 07:46:41 -0700 (PDT)
From:   Mark Balantzyan <mbalant3@gmail.com>
X-Google-Original-From: Mark Balantzyan <mbalantz@mbalantz-desktop>
Date:   Tue, 20 Aug 2019 07:46:37 -0700 (PDT)
To:     sathya.prakash@broadcom.com
cc:     Mark Balantzyan <mbalant3@gmail.com>, julian.calaby@gmail.com,
        suganath-prabu.subramani@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com, andrianov@ispras.ru,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] lsilogic mpt fusion: mptctl: Fixed race condition
 around mptctl_id variable using mutexes
In-Reply-To: <CAGRGNgUvZ0-GS=p8uVSEGA1Tca9HNg1W+Zrhc3ugxD2xqf0wBw@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.1908200725340.18881@mbalantz-desktop>
References: <20190815100050.3924-1-mbalant3@gmail.com> <CAGRGNgUvZ0-GS=p8uVSEGA1Tca9HNg1W+Zrhc3ugxD2xqf0wBw@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

The race condition in the mptctl driver I'm wishing to have 
confirmed is evidenced by the pair of call chains:

compat_mpctl_ioctl -> compat_mpt_command -> mptctl_do_mpt_command which 
calls mpt_get_msg_frame(mptctl_id, ioc)

and

__mptctl_ioctl -> mpt_fw_download -> mptctl_do_fw_download which calls 
mpt_put_msg_frame(mptctl_id, iocp, mf) and calls 
mpt_get_msg_frame(mptctl_id, iocp)

Since ioctl can be called at any time, accessing of mptctl_id occurs 
concurrently between threads causing a race.

I realize in past messages I've tried to patch by surrounding all 
instances of mptctl_id with mutexes but I'm focusing this time on one 
clear instance of the race condition involving the variable mptctl_id, 
since Julian asks what the exact race condition is with respect to the 
case.

Please let me know the confirmation or not confirmation of this race 
possibility.

Thank you,
Mark

On Sun, 18 Aug 2019, Julian Calaby wrote:

> Hi Mark,
>
> On Thu, Aug 15, 2019 at 8:02 PM Mark Balantzyan <mbalant3@gmail.com> wrote:
>>
>> Certain functions in the driver, such as mptctl_do_fw_download() and
>> mptctl_do_mpt_command(), rely on the instance of mptctl_id, which does the
>> id-ing. There is race condition possible when these functions operate in
>> concurrency. Via, mutexes, the functions are mutually signalled to cooperate.
>>
>> Changelog v2
>>
>> Lacked a version number but added properly terminated else condition at
>> (former) line 2300.
>>
>> Changelog v3
>>
>> Fixes "return -EAGAIN" lines which were erroneously tabbed as if to be guarded
>> by "if" conditions lying above them.
>>
>> Signed-off-by: Mark Balantzyan <mbalant3@gmail.com>
>>
>> ---
>
> Changelog should be down here after the "---"
>
>>  drivers/message/fusion/mptctl.c | 43 +++++++++++++++++++++++++--------
>>  1 file changed, 33 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
>> index 4470630d..3270843c 100644
>> --- a/drivers/message/fusion/mptctl.c
>> +++ b/drivers/message/fusion/mptctl.c
>> @@ -816,12 +816,15 @@ mptctl_do_fw_download(int ioc, char __user *ufwbuf, size_t fwlen)
>>
>>                 /*  Valid device. Get a message frame and construct the FW download message.
>>                 */
>> +               mutex_lock(&mpctl_mutex);
>>                 if ((mf = mpt_get_msg_frame(mptctl_id, iocp)) == NULL)
>> -                       return -EAGAIN;
>> +                       mutex_unlock(&mpctl_mutex);
>> +               return -EAGAIN;
>
> Are you sure this is right?
>
> 1. We're now exiting early with -EAGAIN regardless of the result of
> mpt_get_msg_frame()
> 2. If the result of mpt_get_msg_frame() is not NULL, we don't unlock the mutex
>
> Do you mean something like:
>
> - - - - - -
>
> mutex_lock(&mpctl_mutex);
> mf = mpt_get_msg_frame(mptctl_id, iocp);
> mutex_unlock(&mpctl_mutex);
>
> if (mf == NULL) {
>
> - - - - - -
>
>> @@ -1889,8 +1894,10 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
>>
>>         /* Get a free request frame and save the message context.
>>          */
>> +       mutex_lock(&mpctl_mutex);
>>          if ((mf = mpt_get_msg_frame(mptctl_id, ioc)) == NULL)
>> -                return -EAGAIN;
>> +               mutex_unlock(&mpctl_mutex);
>> +        return -EAGAIN;
>
> Same comments here.
>
>> @@ -2563,7 +2576,9 @@ mptctl_hp_hostinfo(unsigned long arg, unsigned int data_size)
>>         /*
>>          * Gather ISTWI(Industry Standard Two Wire Interface) Data
>>          */
>> +       mutex_lock(&mpctl_mutex);
>>         if ((mf = mpt_get_msg_frame(mptctl_id, ioc)) == NULL) {
>> +       mutex_unlock(&mpctl_mutex);
>
> This line needs to be indented to match the line below, also we don't
> unlock the mutex if mpt_get_msg_frame() is not NULL.
>
>> @@ -3010,9 +3027,11 @@ static int __init mptctl_init(void)
>>          *  Install our handler
>>          */
>>         ++where;
>> +       mutex_lock(&mpctl_mutex);
>>         mptctl_id = mpt_register(mptctl_reply, MPTCTL_DRIVER,
>>             "mptctl_reply");
>>         if (!mptctl_id || mptctl_id >= MPT_MAX_PROTOCOL_DRIVERS) {
>> +               mutex_unlock(&mpctl_mutex);
>
> Why not use a local variable and only update the global variable if it's valid?
>
>>                 printk(KERN_ERR MYNAM ": ERROR: Failed to register with Fusion MPT base driver\n");
>>                 misc_deregister(&mptctl_miscdev);
>>                 err = -EBUSY;
>> @@ -3022,13 +3041,14 @@ static int __init mptctl_init(void)
>>         mptctl_taskmgmt_id = mpt_register(mptctl_taskmgmt_reply, MPTCTL_DRIVER,
>>             "mptctl_taskmgmt_reply");
>>         if (!mptctl_taskmgmt_id || mptctl_taskmgmt_id >= MPT_MAX_PROTOCOL_DRIVERS) {
>> +               mutex_unlock(&mpctl_mutex);
>
> Same comment here.
>
>> @@ -3044,13 +3064,14 @@ out_fail:
>>  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
>>  static void mptctl_exit(void)
>>  {
>> +       mutex_lock(&mpctl_mutex);
>>         misc_deregister(&mptctl_miscdev);
>>         printk(KERN_INFO MYNAM ": Deregistered /dev/%s @ (major,minor=%d,%d)\n",
>>                          mptctl_miscdev.name, MISC_MAJOR, mptctl_miscdev.minor);
>>
>>         /* De-register event handler from base module */
>>         mpt_event_deregister(mptctl_id);
>> -
>> +
>
> Please don't add trailing whitespace.
>
> Did you test this on real hardware? I'd expect it to deadlock and
> crash almost immediately.
>
> Also, it might be worthwhile creating accessor functions for the
> mptctl variables or using atomics, that way the locking doesn't need
> to be right every time they're used.
>
> Finally, what's the exact race condition here? Are the functions you
> reference changing the values of the mptctl variables while other code
> is using them? These functions appear to be setup functions, so why
> are those variables being used before the device is fully set up?
> Single usages of those variables shouldn't be subject to race
> conditions, so you shouldn't need mutexes around those.
>
> Thanks,
>
> -- 
> Julian Calaby
>
> Email: julian.calaby@gmail.com
> Profile: http://www.google.com/profiles/julian.calaby/
>
