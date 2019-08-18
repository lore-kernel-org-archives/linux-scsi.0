Return-Path: <SRS0=iy+L=WO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93F94C3A589
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Aug 2019 07:50:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F81D20851
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Aug 2019 07:50:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QHx+hYqA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbfHRHu2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 18 Aug 2019 03:50:28 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40634 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfHRHu2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Aug 2019 03:50:28 -0400
Received: by mail-wr1-f68.google.com with SMTP id c3so5504144wrd.7;
        Sun, 18 Aug 2019 00:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f2ZGBfgqqDUpAuuY5Q2IQaqYJIGOtiaVgays+o/qt5c=;
        b=QHx+hYqAQZHeugkOFZHQPTwh4VWRcpWByvxtx5U+se+p2GTGKFSFewQhIpPsk9ZeEh
         ui7dH7I8dfveCagBR5JU9WHS/YtpKrjz+L3N72FanE+HVZsHd9uoL714bDPZaArRI8P4
         t9PSuWkZ9oX6ImNseRq8ZIU4dNrbmlHyfXAsU6oH3SqCMB8lEkjfuFAWLBidUrabtghX
         DkgJN8wkWZ3DlEOX9Ljigo4gsfdbGryYrg/z0d6jbAT7ox9S8N15jMb20wA99X2sQX9/
         C1EvOfb+KafNiEeFs9v5P/5aEzlOVOos21uO8XUTOJk3yTqcDBO4D6m1ClaqHenDWHqn
         K/9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f2ZGBfgqqDUpAuuY5Q2IQaqYJIGOtiaVgays+o/qt5c=;
        b=R7C+pNrVXtn0Os0Sk/uCy+xn7Pj2jPnQOyci1GzafvPzqiBTG+2+k/EJFqQ7czlBSZ
         hd2d6DUsimjaTOyv14h9cH19E0t7g70XLzfq6c5ymyQq66n0BaYzABz/5Ba+X1Cj23lv
         McL7RvHqLRC7nUl0QkNqXiY1blujPYRI+a2eXoXYVv/bdY7uktihdGAMR2Bg1y6QIN/b
         7aJAzA8H+gDMrbTLQXrTuM3qxircjAIetSpLkusfhVo+j85XvIqvSlRiuxlc1or1TKVv
         jftC8qZjhHlnvr0gw18X/xTJdWSqJObbnTHzZtuOZMaFBi21/M4teNrChx1qYKbRjzyW
         V1KQ==
X-Gm-Message-State: APjAAAUaYf9DFKlhbkpMr/bSdlLWjNmIPx69XzS1M3cpfAPAmJ+ajFpE
        YPpGfBPW01rkCni+c2jfpBVB7CJiQStgp/kGyF6U1qp1
X-Google-Smtp-Source: APXvYqzjsS1xGrvX3gSpf36vBUr/69YltkN9xxeN9gN3C0LOjiTc2VTfKjgvSERq0nUb0txGi1XnSJ1FNzq4nD9C/RY=
X-Received: by 2002:a5d:568e:: with SMTP id f14mr19213137wrv.167.1566114625077;
 Sun, 18 Aug 2019 00:50:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190815100050.3924-1-mbalant3@gmail.com>
In-Reply-To: <20190815100050.3924-1-mbalant3@gmail.com>
From:   Julian Calaby <julian.calaby@gmail.com>
Date:   Sun, 18 Aug 2019 17:50:13 +1000
Message-ID: <CAGRGNgUvZ0-GS=p8uVSEGA1Tca9HNg1W+Zrhc3ugxD2xqf0wBw@mail.gmail.com>
Subject: Re: [PATCH v3] lsilogic mpt fusion: mptctl: Fixed race condition
 around mptctl_id variable using mutexes
To:     Mark Balantzyan <mbalant3@gmail.com>
Cc:     sathya.prakash@broadcom.com, suganath-prabu.subramani@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Mark,

On Thu, Aug 15, 2019 at 8:02 PM Mark Balantzyan <mbalant3@gmail.com> wrote:
>
> Certain functions in the driver, such as mptctl_do_fw_download() and
> mptctl_do_mpt_command(), rely on the instance of mptctl_id, which does the
> id-ing. There is race condition possible when these functions operate in
> concurrency. Via, mutexes, the functions are mutually signalled to cooperate.
>
> Changelog v2
>
> Lacked a version number but added properly terminated else condition at
> (former) line 2300.
>
> Changelog v3
>
> Fixes "return -EAGAIN" lines which were erroneously tabbed as if to be guarded
> by "if" conditions lying above them.
>
> Signed-off-by: Mark Balantzyan <mbalant3@gmail.com>
>
> ---

Changelog should be down here after the "---"

>  drivers/message/fusion/mptctl.c | 43 +++++++++++++++++++++++++--------
>  1 file changed, 33 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
> index 4470630d..3270843c 100644
> --- a/drivers/message/fusion/mptctl.c
> +++ b/drivers/message/fusion/mptctl.c
> @@ -816,12 +816,15 @@ mptctl_do_fw_download(int ioc, char __user *ufwbuf, size_t fwlen)
>
>                 /*  Valid device. Get a message frame and construct the FW download message.
>                 */
> +               mutex_lock(&mpctl_mutex);
>                 if ((mf = mpt_get_msg_frame(mptctl_id, iocp)) == NULL)
> -                       return -EAGAIN;
> +                       mutex_unlock(&mpctl_mutex);
> +               return -EAGAIN;

Are you sure this is right?

1. We're now exiting early with -EAGAIN regardless of the result of
mpt_get_msg_frame()
2. If the result of mpt_get_msg_frame() is not NULL, we don't unlock the mutex

Do you mean something like:

- - - - - -

mutex_lock(&mpctl_mutex);
mf = mpt_get_msg_frame(mptctl_id, iocp);
mutex_unlock(&mpctl_mutex);

if (mf == NULL) {

- - - - - -

> @@ -1889,8 +1894,10 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
>
>         /* Get a free request frame and save the message context.
>          */
> +       mutex_lock(&mpctl_mutex);
>          if ((mf = mpt_get_msg_frame(mptctl_id, ioc)) == NULL)
> -                return -EAGAIN;
> +               mutex_unlock(&mpctl_mutex);
> +        return -EAGAIN;

Same comments here.

> @@ -2563,7 +2576,9 @@ mptctl_hp_hostinfo(unsigned long arg, unsigned int data_size)
>         /*
>          * Gather ISTWI(Industry Standard Two Wire Interface) Data
>          */
> +       mutex_lock(&mpctl_mutex);
>         if ((mf = mpt_get_msg_frame(mptctl_id, ioc)) == NULL) {
> +       mutex_unlock(&mpctl_mutex);

This line needs to be indented to match the line below, also we don't
unlock the mutex if mpt_get_msg_frame() is not NULL.

> @@ -3010,9 +3027,11 @@ static int __init mptctl_init(void)
>          *  Install our handler
>          */
>         ++where;
> +       mutex_lock(&mpctl_mutex);
>         mptctl_id = mpt_register(mptctl_reply, MPTCTL_DRIVER,
>             "mptctl_reply");
>         if (!mptctl_id || mptctl_id >= MPT_MAX_PROTOCOL_DRIVERS) {
> +               mutex_unlock(&mpctl_mutex);

Why not use a local variable and only update the global variable if it's valid?

>                 printk(KERN_ERR MYNAM ": ERROR: Failed to register with Fusion MPT base driver\n");
>                 misc_deregister(&mptctl_miscdev);
>                 err = -EBUSY;
> @@ -3022,13 +3041,14 @@ static int __init mptctl_init(void)
>         mptctl_taskmgmt_id = mpt_register(mptctl_taskmgmt_reply, MPTCTL_DRIVER,
>             "mptctl_taskmgmt_reply");
>         if (!mptctl_taskmgmt_id || mptctl_taskmgmt_id >= MPT_MAX_PROTOCOL_DRIVERS) {
> +               mutex_unlock(&mpctl_mutex);

Same comment here.

> @@ -3044,13 +3064,14 @@ out_fail:
>  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
>  static void mptctl_exit(void)
>  {
> +       mutex_lock(&mpctl_mutex);
>         misc_deregister(&mptctl_miscdev);
>         printk(KERN_INFO MYNAM ": Deregistered /dev/%s @ (major,minor=%d,%d)\n",
>                          mptctl_miscdev.name, MISC_MAJOR, mptctl_miscdev.minor);
>
>         /* De-register event handler from base module */
>         mpt_event_deregister(mptctl_id);
> -
> +

Please don't add trailing whitespace.

Did you test this on real hardware? I'd expect it to deadlock and
crash almost immediately.

Also, it might be worthwhile creating accessor functions for the
mptctl variables or using atomics, that way the locking doesn't need
to be right every time they're used.

Finally, what's the exact race condition here? Are the functions you
reference changing the values of the mptctl variables while other code
is using them? These functions appear to be setup functions, so why
are those variables being used before the device is fully set up?
Single usages of those variables shouldn't be subject to race
conditions, so you shouldn't need mutexes around those.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
