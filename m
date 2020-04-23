Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CFC6C2BA19
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 04:24:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3739B2075A
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 04:24:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance-com.20150623.gappssmtp.com header.i=@bytedance-com.20150623.gappssmtp.com header.b="uyZ024KU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbgDWEYn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Apr 2020 00:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726078AbgDWEYm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Apr 2020 00:24:42 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3BCC03C1AE
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 21:24:40 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x18so5150988wrq.2
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 21:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yoKoc1x3BmhWfv5xtnmkSfyZUB4n6vZHsSH2ElNirok=;
        b=uyZ024KU6rq0ZpfTCb+oFhzZK/QNTtyXSZ9f4b0dJWwzMNPSjsCkuRHE2ndsOFUBNA
         wz8qbs+XYwwYZCcyEtN1Cma2pogeMlS7MuBq/jc4AFDChaWvbpMLWvv9Zpf7MoFzjoc5
         pUJejdE+cNEqpo2GrxRShCrjQSHgthY5r2WQbH0ymnqQdk4XFVRpPC2vMdqcfKk0TR2V
         gzN1e2ErNg3KdqI7YE8HoBFfD0OkYYQJg2d8fLqBlZouu0JYCYZT3z6m6yzahGseDQnd
         8fOjH8Y3xRicNJ+AYKX3R8obLrE6bM89Okkj5//nyQvCt1Pl2lY7rxcBfGYKWyFI9JP9
         5exw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yoKoc1x3BmhWfv5xtnmkSfyZUB4n6vZHsSH2ElNirok=;
        b=hSj4NMWqf8A2uCombLdDmPaSkLVMl9OqCKcEtcCR9pdyD6QKfZOZePsIEQLptVpfSt
         2W17us6k6sD1MxgcRz63ATkCT49azKyMKA05c0Z6dpSCbtxk1ixXG1PvVev2JkZ+ufR/
         1N7CqU4Ho1RKP7tn5xGwARXqXj5afOaX2ezUo8SKIXEoXg4WTN9uqVmM0tpwPe2DtzIH
         oTagHdP0zU/t+J4EFPTwBWk3M+myrShQybVSEHfSlvp+e2dIMPZ+aojjsoTFlfEZoEXk
         BatuZpTmUGYyS1KlAnqPpOfAaWrjK2uyEtzV//8RpNdvoKxzZY66Qr7+ZXokLIBRuGKt
         c0Kg==
X-Gm-Message-State: AGi0PuYbzr9T15nHFUlQTaodjMshc6T93DY1/boAHAwcLpqPqSZ2ihc9
        yB0mGvvu0zdCPUZ77y1Vs+deXO6cX5SG8QF80S3/ag==
X-Google-Smtp-Source: APiQypK8FnYOyS/1mCFY0CAunNStVW+7O7ABY6wHWrqUOLY5jAEtYKr1g0x4rtqg/aTWAwIGDQRLXpI/r4ecJF1VlZY=
X-Received: by 2002:adf:ce0a:: with SMTP id p10mr2465532wrn.89.1587615879638;
 Wed, 22 Apr 2020 21:24:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200415080819.27327-1-houpu@bytedance.com> <20200415080819.27327-2-houpu@bytedance.com>
 <54e574b1-10b4-4385-11fb-773ef152fc2c@redhat.com>
In-Reply-To: <54e574b1-10b4-4385-11fb-773ef152fc2c@redhat.com>
From:   Hou Pu <houpu@bytedance.com>
Date:   Thu, 23 Apr 2020 12:24:28 +0800
Message-ID: <CAO9YExv2kWp=x+mMaWeOrYmu4c6gTu0PeBSkOwHgr7ZW9MywSg@mail.gmail.com>
Subject: Re: [External] Re: [PATCH 1/2] iscsi-target: fix login error when
 receiving is too fast
To:     Mike Christie <mchristi@redhat.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > +     /*
> > +      * LOGIN_FLAGS_READ_ACTIVE is cleared so that sk_data_ready
> > +      * could be trigger again after this.
> > +      *
> > +      * LOGIN_FLAGS_WRITE_ACTIVE is cleared after we successfully
> > +      * processing a login pdu. So that sk_state_chage could do login
>
> I think we need to drop "ing" from processing and do:
>
> process a login pdu, so that sk_state_chage could do login
>
Sure. Thanks for helping me with my language. ^-^
Will change this in v2.
>

> > diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
> > index 591cd9e4692c..0c2dfc81bf8b 100644
> > --- a/include/target/iscsi/iscsi_target_core.h
> > +++ b/include/target/iscsi/iscsi_target_core.h
> > @@ -570,6 +570,7 @@ struct iscsi_conn {
> >  #define LOGIN_FLAGS_CLOSED           2
> >  #define LOGIN_FLAGS_READY            4
> >  #define LOGIN_FLAGS_INITIAL_PDU              8
> > +#define LOGIN_FLAGS_WRITE_ACTIVE     12
>
> 12 works but seems odd. The current code uses test/set/clear_bit, so we
> want these to be:
>
> #define LOGIN_FLAGS_CLOSED 0
> #define LOGIN_FLAGS_READY 1
> #define LOGIN_FLAGS_INITIAL_PDU 2
> #define LOGIN_FLAGS_WRITE_ACTIVE 3
>
> right?
>
Yes, it is a little odd. What about this? I also changed the order of them
to be in sequence that happened.

--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -566,10 +566,11 @@ struct iscsi_conn {
        struct socket           *sock;
        void                    (*orig_data_ready)(struct sock *);
        void                    (*orig_state_change)(struct sock *);
-#define LOGIN_FLAGS_READ_ACTIVE                1
-#define LOGIN_FLAGS_CLOSED             2
-#define LOGIN_FLAGS_READY              4
-#define LOGIN_FLAGS_INITIAL_PDU                8
+#define LOGIN_FLAGS_READY              0
+#define LOGIN_FLAGS_INITIAL_PDU                1
+#define LOGIN_FLAGS_READ_ACTIVE                2
+#define LOGIN_FLAGS_WRITE_ACTIVE       3
+#define LOGIN_FLAGS_CLOSED             4

Thanks,
Hou

> 2, 4, 8 was probably from a time we set the bits our self like:
>
> login_flags |= LOGIN_FLAGS_CLOSED;
>
>
> >       unsigned long           login_flags;
> >       struct delayed_work     login_work;
> >       struct iscsi_login      *login;
> >
>
