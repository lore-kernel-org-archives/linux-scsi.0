Return-Path: <SRS0=c2qj=BW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 094F8C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 12:16:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DECEB20855
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 12:16:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="LDGeFBnW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727871AbgHLMQ4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 08:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbgHLMQz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2020 08:16:55 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4603C061787
        for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2020 05:16:55 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id x24so1741158otp.3
        for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2020 05:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HtTUL4nNsElQLTbbRqmNno/usEQ2WZWXtzv03bulQN8=;
        b=LDGeFBnW5rdu6GwSJzOWDDfNm6Yf8pJLkrjSBoUNblFidc8r0eo0Ma3zJ5L++HbG1C
         VI4o6/QZ67SsDXPykr2E3QOfNobVdGXWQG9ARkVrl8+V4HBsYrvQUGbUwbay11PHFUG9
         NAuS+UlYl6rxBSkGmSlmpsSHnWUK4vaSIChAE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=HtTUL4nNsElQLTbbRqmNno/usEQ2WZWXtzv03bulQN8=;
        b=C0BbP0ufu303mv9cUns51yPw2cpOedo8wcTVKZeyADUWpqB1c25Ot7Toah98JojIjH
         pOqGp+jpoSAW0IEBBZwsPxrCdBJvn6zqJmhXjtq3byBdj6pAc3iB5Oc6+mXMdTV9yPIC
         sUG9xcQbzYK1ozwITepj3QWOMRYL/CDlAuoNndoOnnmu7zGTNsJCIgGsyJXxg7gxuPU6
         Lh+ucB88B4SaJPsyKyAP9cF/PMWuaD+AojbkDfZl/FPv2z2f4vSoFIWueALrmtLprNFM
         isajMYx+A3CP/14aubs7Dso1FyW42m/3PFR1O4ADxF+p2Muzf2/VREI4Oo3JMeTGd0nO
         oEpg==
X-Gm-Message-State: AOAM532RjsqKjMLMvYwV+asGStbnUclgQ3tcgkTAQuGsaKXJeKvs2N6c
        dJgHdJMHbyMCmPC4oUs4xt6ymlVnuGRgB64AKSY8cg==
X-Google-Smtp-Source: ABdhPJx46uM94ViEYE8Di9+fo0dpKCwJObkdb91bSAqgqgb3DiFi4jU0ZRPdFIFBl6MIyLIMsZZY91LtZ8UL2AdHmDY=
X-Received: by 2002:a9d:3c6:: with SMTP id f64mr9234877otf.364.1597234614828;
 Wed, 12 Aug 2020 05:16:54 -0700 (PDT)
From:   Muneendra Kumar M <muneendra.kumar@broadcom.com>
References: <1596507196-27417-1-git-send-email-muneendra.kumar@broadcom.com>
 <1596507196-27417-17-git-send-email-muneendra.kumar@broadcom.com>
 <61d2fd75-84ea-798b-aee9-b07957ac8f1b@suse.de> <08b9825b-6abb-c077-ac0d-bd63f10f2ac2@broadcom.com>
 <aa595605c2f776148e03a8e5dd69168a@mail.gmail.com> <227c5ba1-8a9c-3ec9-5a0f-662a4736c66f@redhat.com>
 <b3350b999d5500ddef49a25aafee2ea6@mail.gmail.com> <eec84df0-1cee-e386-c18e-73ac8e0b89a3@redhat.com>
 <e76b12c664057adb51c14bf0663bb2f7@mail.gmail.com> <b471b84f-25e9-39cb-41e0-1cc1af409a8a@redhat.com>
 <7e76e1464e794a79861ea9846e0a5370@mail.gmail.com> <053466c4-7786-38aa-012f-926b68c85c8c@redhat.com>
 <05697e72c1981838c5471e503b28dfc2@mail.gmail.com> <a4bf914b-c0ff-5876-890d-f1889308f6ea@redhat.com>
In-Reply-To: <a4bf914b-c0ff-5876-890d-f1889308f6ea@redhat.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQIDyhmBPqdmqCKUdNTZliBUbPkt/AI5BKetAom9APICL6c0jAMHD3TmAjtZC5MBe/Ed2QIv9leoAyMPjxIBrC+2XAGG5LXBAnT4Ng8CRdBEeAH6rm1zp/JJiLA=
Date:   Wed, 12 Aug 2020 17:46:51 +0530
Message-ID: <747480d2533f28e44dcd9a02f6398a60@mail.gmail.com>
Subject: RE: [RFC 16/16] lpfc: vmid: Introducing vmid in io path.
To:     Paolo Bonzini <pbonzini@redhat.com>,
        James Smart <james.smart@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     emilne@redhat.com, mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        Ming Lei <tom.leiming@gmail.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Paolo/Tejun,
From the overall conversation the approach will be as below.
Please let me know if I miss anything or any issue with the same.

1)      blkcg will have a new field fc_app_id to store UUID /driver specifi=
c
information.
2)      scsi transport will provide a new interface(sysfs) as
register_vm_fabric
3)      As part of this interface user will provide the details of UUID and
the  open fd (cgroup associated
 info with VM) to the new interface.
4)      With VM provided cgroup info we need to find the associated blkcg
and needs to
update the UUID info in the fc_app_id.
5)      Once we update the fc_app_id  all the io=E2=80=99s issued from VM w=
ill have
the UUID info as part of blkcg.

If this approach is fine then I will make the necessary changes in my next
version.

Regards,
Muneendra.


-----Original Message-----
From: Paolo Bonzini [mailto:pbonzini@redhat.com]
Sent: Wednesday, August 12, 2020 1:25 PM
To: Muneendra Kumar M <muneendra.kumar@broadcom.com>; James Smart
<james.smart@broadcom.com>; Hannes Reinecke <hare@suse.de>;
linux-block@vger.kernel.org; linux-scsi@vger.kernel.org
Cc: emilne@redhat.com; mkumar@redhat.com; Gaurav Srivastava
<gaurav.srivastava@broadcom.com>; James Smart <jsmart2021@gmail.com>; Ming
Lei <tom.leiming@gmail.com>; Tejun Heo <tj@kernel.org>
Subject: Re: [RFC 16/16] lpfc: vmid: Introducing vmid in io path.


On 10/08/20 14:13, Muneendra Kumar M wrote:
> Agreed:
> So from the user we need to provide UUID and the cgroup associated
> info with VM to the kernel interface. Is this correct?

Yes.

> There is no issues with UUID  passing as one of the arg.
> Coming to the other cgroup associated VM here are the options which we
> can send
>
> 1)openfd:
> We need a utility which opens the cgroup path and pass the fd details
> to the interface.
> And we can use the cgroup_get_from_fd() utility to get the associated
> cgroup in the kernel.
> Dependent on utilty.

This looks good to me.

Paolo
