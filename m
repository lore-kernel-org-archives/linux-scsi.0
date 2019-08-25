Return-Path: <SRS0=R+Dz=WV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5DE1C3A5A3
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Aug 2019 19:05:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85229206E0
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Aug 2019 19:05:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EC0pe1co"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbfHYTFa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Aug 2019 15:05:30 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43184 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728739AbfHYTF3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Aug 2019 15:05:29 -0400
Received: by mail-pg1-f195.google.com with SMTP id k3so9033490pgb.10;
        Sun, 25 Aug 2019 12:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=fuTUfhI7Fqzxw4aeJzSsrVVTQfUs6xEm0aOw/vEqo/I=;
        b=EC0pe1coTKL22YVt6uNl+ILz3GaztktEhYU0lS9MyhvDWfH+87qzbT2hQr2dQqu7kC
         PUJ03Th50KMUTyQQ8TkHimH91ti+w88DmIMiAdo4jcy+L9F+6PmDogGpgNGtT+4OgFil
         0BAg6OzahsBM1WJCAhWd6p+lAriVuFnEU+2oPEn4Mu6IHFjjThO+7UbNYJKPzuTu5E6V
         3jmjhWQ00n/eLUw5VEDdifcMJsortdllYcxltFhdqYBctgczf+p/BWdoYfBKAJisZQM8
         cpIhi+JmZpaNklR79GacKS/+uKgA8CUGWli4Ytn3T8tcx6szJXXEgfSiFLM+urV7ivNh
         FJzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=fuTUfhI7Fqzxw4aeJzSsrVVTQfUs6xEm0aOw/vEqo/I=;
        b=OM1kH3ThQ58xl1GHh/YE5QsB5efeCjyY2e4ckSgW6Pswe1L3+vv3RaZvVfQMnae+tu
         hqHfg1XifiodYcDUeV6suR8voRquKi6VzQeTqhEfe5kb1WqpEvVsNxGa9o8zlFFXXwJV
         lUo/luMsss7VvW7aveuGCGzYfNE8MI3PCWsF97M+U3WDLGUuIE5Nn6pJ5A7F8EXm6STP
         vTdMpngMaaFE/HWcH1+8vmXT4INHhFl/4jcFzjoe9fBVcuAPvSu/HQJYcsTIM3zA/d/n
         mqhORoi+KHyA6vWuZDpgnWt1P5N/ViQEO2dUu3IDEoSXEJ1zJyv26WyHFh3hPsanHHeU
         Z+vw==
X-Gm-Message-State: APjAAAVmbw/beKcbBuJ8Ls+EvN7cVTOlQ2ct+dM9uNHPztzcejm89lAr
        KXAaeazftcAAUBbL6/nf+uA=
X-Google-Smtp-Source: APXvYqwEOFj52RSFzoM4IrHCmf+WmmXISffDZGZONxicsR3YEEJyVUtjyG16tJHyY58xuWX6ZnGUlw==
X-Received: by 2002:a17:90a:22f0:: with SMTP id s103mr16784536pjc.56.1566759929088;
        Sun, 25 Aug 2019 12:05:29 -0700 (PDT)
Received: from mbalantz-desktop (d206-116-172-62.bchsia.telus.net. [206.116.172.62])
        by smtp.gmail.com with ESMTPSA id v21sm8542749pfe.131.2019.08.25.12.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2019 12:05:28 -0700 (PDT)
From:   Mark Balantzyan <mbalant3@gmail.com>
X-Google-Original-From: Mark Balantzyan <mbalantz@mbalantz-desktop>
Date:   Sun, 25 Aug 2019 12:05:21 -0700 (PDT)
To:     =?ISO-8859-15?Q?Mark_Balan=E7ian?= <mbalant3@gmail.com>
cc:     sathya.prakash@broadcom.com, julian.calaby@gmail.com,
        suganath-prabu.subramani@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com, andrianov@ispras.ru,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] lsilogic mpt fusion: mptctl: Fixed race condition
 around mptctl_id variable using mutexes
In-Reply-To: <d58d43b2-2434-e9db-b1e6-1a1b7b85773f@gmail.com>
Message-ID: <alpine.DEB.2.21.1908251202090.3457@mbalantz-desktop>
References: <20190815100050.3924-1-mbalant3@gmail.com> <CAGRGNgUvZ0-GS=p8uVSEGA1Tca9HNg1W+Zrhc3ugxD2xqf0wBw@mail.gmail.com> <alpine.DEB.2.21.1908200725340.18881@mbalantz-desktop> <d58d43b2-2434-e9db-b1e6-1a1b7b85773f@gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1310721244-1566759928=:3457"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1310721244-1566759928=:3457
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT

Hi all,
 

Please note I took the call chains in my secondmost previous message for
the race condition from mtpctl.c in kernel 4.18.20.

 
Thank you,

Mark


On Tue, 20 Aug 2019, Mark Balançian wrote:

> Hello Mister Prakash, Calaby, and Subramani,
>
> I also please request your reply to my previous message before the end of 
> this Thursday the latest, as I am partaking in an evaluation period from the 
> organization I am working for with a deadline very close to that time.
>
> Thank you,
>
> Mark
>
> On 2019-08-20 7:46 a.m., Mark Balantzyan wrote:
>> Hi all,
>> 
>> The race condition in the mptctl driver I'm wishing to have confirmed is 
>> evidenced by the pair of call chains:
>> 
>> compat_mpctl_ioctl -> compat_mpt_command -> mptctl_do_mpt_command which 
>> calls mpt_get_msg_frame(mptctl_id, ioc)
>> 
>> and
>> 
>> __mptctl_ioctl -> mpt_fw_download -> mptctl_do_fw_download which calls 
>> mpt_put_msg_frame(mptctl_id, iocp, mf) and calls 
>> mpt_get_msg_frame(mptctl_id, iocp)
>> 
>> Since ioctl can be called at any time, accessing of mptctl_id occurs 
>> concurrently between threads causing a race.
>> 
>> I realize in past messages I've tried to patch by surrounding all instances 
>> of mptctl_id with mutexes but I'm focusing this time on one clear instance 
>> of the race condition involving the variable mptctl_id, since Julian asks 
>> what the exact race condition is with respect to the case.
>> 
>> Please let me know the confirmation or not confirmation of this race 
>> possibility.
>> 
>> Thank you,
>> Mark
>> 
>> On Sun, 18 Aug 2019, Julian Calaby wrote:
>> 
>>> Hi Mark,
>>> 
>>> On Thu, Aug 15, 2019 at 8:02 PM Mark Balantzyan <mbalant3@gmail.com> 
>>> wrote:
>>>> 
>>>> Certain functions in the driver, such as mptctl_do_fw_download() and
>>>> mptctl_do_mpt_command(), rely on the instance of mptctl_id, which does 
>>>> the
>>>> id-ing. There is race condition possible when these functions operate in
>>>> concurrency. Via, mutexes, the functions are mutually signalled to 
>>>> cooperate.
>>>> 
>>>> Changelog v2
>>>> 
>>>> Lacked a version number but added properly terminated else condition at
>>>> (former) line 2300.
>>>> 
>>>> Changelog v3
>>>> 
>>>> Fixes "return -EAGAIN" lines which were erroneously tabbed as if to be 
>>>> guarded
>>>> by "if" conditions lying above them.
>>>> 
>>>> Signed-off-by: Mark Balantzyan <mbalant3@gmail.com>
>>>> 
>>>> ---
>>> 
>>> Changelog should be down here after the "---"
>>> 
>>>>  drivers/message/fusion/mptctl.c | 43 +++++++++++++++++++++++++--------
>>>>  1 file changed, 33 insertions(+), 10 deletions(-)
>>>> 
>>>> diff --git a/drivers/message/fusion/mptctl.c 
>>>> b/drivers/message/fusion/mptctl.c
>>>> index 4470630d..3270843c 100644
>>>> --- a/drivers/message/fusion/mptctl.c
>>>> +++ b/drivers/message/fusion/mptctl.c
>>>> @@ -816,12 +816,15 @@ mptctl_do_fw_download(int ioc, char __user *ufwbuf, 
>>>> size_t fwlen)
>>>> 
>>>>                 /*  Valid device. Get a message frame and construct the 
>>>> FW download message.
>>>>                 */
>>>> +               mutex_lock(&mpctl_mutex);
>>>>                 if ((mf = mpt_get_msg_frame(mptctl_id, iocp)) == NULL)
>>>> -                       return -EAGAIN;
>>>> +                       mutex_unlock(&mpctl_mutex);
>>>> +               return -EAGAIN;
>>> 
>>> Are you sure this is right?
>>> 
>>> 1. We're now exiting early with -EAGAIN regardless of the result of
>>> mpt_get_msg_frame()
>>> 2. If the result of mpt_get_msg_frame() is not NULL, we don't unlock the 
>>> mutex
>>> 
>>> Do you mean something like:
>>> 
>>> - - - - - -
>>> 
>>> mutex_lock(&mpctl_mutex);
>>> mf = mpt_get_msg_frame(mptctl_id, iocp);
>>> mutex_unlock(&mpctl_mutex);
>>> 
>>> if (mf == NULL) {
>>> 
>>> - - - - - -
>>> 
>>>> @@ -1889,8 +1894,10 @@ mptctl_do_mpt_command (struct mpt_ioctl_command 
>>>> karg, void __user *mfPtr)
>>>> 
>>>>         /* Get a free request frame and save the message context.
>>>>          */
>>>> +       mutex_lock(&mpctl_mutex);
>>>>          if ((mf = mpt_get_msg_frame(mptctl_id, ioc)) == NULL)
>>>> -                return -EAGAIN;
>>>> +               mutex_unlock(&mpctl_mutex);
>>>> +        return -EAGAIN;
>>> 
>>> Same comments here.
>>> 
>>>> @@ -2563,7 +2576,9 @@ mptctl_hp_hostinfo(unsigned long arg, unsigned int 
>>>> data_size)
>>>>         /*
>>>>          * Gather ISTWI(Industry Standard Two Wire Interface) Data
>>>>          */
>>>> +       mutex_lock(&mpctl_mutex);
>>>>         if ((mf = mpt_get_msg_frame(mptctl_id, ioc)) == NULL) {
>>>> +       mutex_unlock(&mpctl_mutex);
>>> 
>>> This line needs to be indented to match the line below, also we don't
>>> unlock the mutex if mpt_get_msg_frame() is not NULL.
>>> 
>>>> @@ -3010,9 +3027,11 @@ static int __init mptctl_init(void)
>>>>          *  Install our handler
>>>>          */
>>>>         ++where;
>>>> +       mutex_lock(&mpctl_mutex);
>>>>         mptctl_id = mpt_register(mptctl_reply, MPTCTL_DRIVER,
>>>>             "mptctl_reply");
>>>>         if (!mptctl_id || mptctl_id >= MPT_MAX_PROTOCOL_DRIVERS) {
>>>> +               mutex_unlock(&mpctl_mutex);
>>> 
>>> Why not use a local variable and only update the global variable if it's 
>>> valid?
>>> 
>>>>                 printk(KERN_ERR MYNAM ": ERROR: Failed to register with 
>>>> Fusion MPT base driver\n");
>>>>                 misc_deregister(&mptctl_miscdev);
>>>>                 err = -EBUSY;
>>>> @@ -3022,13 +3041,14 @@ static int __init mptctl_init(void)
>>>>         mptctl_taskmgmt_id = mpt_register(mptctl_taskmgmt_reply, 
>>>> MPTCTL_DRIVER,
>>>>             "mptctl_taskmgmt_reply");
>>>>         if (!mptctl_taskmgmt_id || mptctl_taskmgmt_id >= 
>>>> MPT_MAX_PROTOCOL_DRIVERS) {
>>>> +               mutex_unlock(&mpctl_mutex);
>>> 
>>> Same comment here.
>>> 
>>>> @@ -3044,13 +3064,14 @@ out_fail:
>>>>  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/ 
>>>>  static void mptctl_exit(void)
>>>>  {
>>>> +       mutex_lock(&mpctl_mutex);
>>>>         misc_deregister(&mptctl_miscdev);
>>>>         printk(KERN_INFO MYNAM ": Deregistered /dev/%s @ 
>>>> (major,minor=%d,%d)\n",
>>>>                          mptctl_miscdev.name, MISC_MAJOR, 
>>>> mptctl_miscdev.minor);
>>>> 
>>>>         /* De-register event handler from base module */
>>>>         mpt_event_deregister(mptctl_id);
>>>> -
>>>> +
>>> 
>>> Please don't add trailing whitespace.
>>> 
>>> Did you test this on real hardware? I'd expect it to deadlock and
>>> crash almost immediately.
>>> 
>>> Also, it might be worthwhile creating accessor functions for the
>>> mptctl variables or using atomics, that way the locking doesn't need
>>> to be right every time they're used.
>>> 
>>> Finally, what's the exact race condition here? Are the functions you
>>> reference changing the values of the mptctl variables while other code
>>> is using them? These functions appear to be setup functions, so why
>>> are those variables being used before the device is fully set up?
>>> Single usages of those variables shouldn't be subject to race
>>> conditions, so you shouldn't need mutexes around those.
>>> 
>>> Thanks,
>>> 
>>> -- 
>>> Julian Calaby
>>> 
>>> Email: julian.calaby@gmail.com
>>> Profile: http://www.google.com/profiles/julian.calaby/
>>> 
>
--8323329-1310721244-1566759928=:3457--
