Return-Path: <SRS0=243Y=CE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3555AC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Aug 2020 16:23:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9FBD2074A
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Aug 2020 16:23:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Uangwkek"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbgHZQXd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Aug 2020 12:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbgHZQXc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Aug 2020 12:23:32 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31671C061574
        for <linux-scsi@vger.kernel.org>; Wed, 26 Aug 2020 09:23:32 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id j18so2021718oig.5
        for <linux-scsi@vger.kernel.org>; Wed, 26 Aug 2020 09:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=okg93lju0q1SfvfPe5TXu00v0yhqTFNXEnfOVSkc654=;
        b=UangwkekMdUxJy15TGgr44bJGeQbRN7MnBlnKehbjod/YvLkASQ/HPZBnD9DuDMMmU
         x3xEwOsidXI4NFJGWP9tiZNs/VcvsKuvrbmimYRJexn4jcYS7uxIxjjFIurs0v4mjuzk
         WjDFgtHQydlK3wcXRMcL11KQZ0Ud/5i58G8P4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=okg93lju0q1SfvfPe5TXu00v0yhqTFNXEnfOVSkc654=;
        b=rxxKyiR19NnDYrbY7cWdXBbC4iuDjNzGtS3/G+0x3JRG9JqiPDYeMj3Jj/CU6g9MMQ
         oY+1VSR5xqBvlEPuWcc55uOq7hWBfyel03yNE01eMhYEWCmF9CaOYG3XJvC+hbNAgV1U
         MZNXvGWcp+21KI6LxnFgICU0coSRBu6U4WLJJ9dI+oGb/Ljn+mUj8w4pLZ5F72leiXdD
         F5HbH6eEaXXD0rpTvbOZp+gL0tJyyT0RsawUGkt3F5bo5nT1MGuOWBaZKnk3mqjWnK2K
         WiVbU3qBSrtd97c8ZvNhLCPr4Tss+YtaGv9dhGK4SiADt6nmKabwI1CVd6W8F8qvv3bo
         nAvA==
X-Gm-Message-State: AOAM5335/i4aSjZ2T8SWiWXGAB4PYiCXFFSdd4t20IgBWj3VZ5x0hjf8
        grO10nJ5Xa7pWXYmnPH+xlkTeS4XRh2dKVx3gFmQAw==
X-Google-Smtp-Source: ABdhPJwch4QXZ2NmLrZjH62Dreh3jQK773ILmC3GL8pzNCZq7twDsL/PR+CmPLN/GYvCGT2099sU9cd3wLAeO3LhRNw=
X-Received: by 2002:aca:a887:: with SMTP id r129mr3490918oie.7.1598459011202;
 Wed, 26 Aug 2020 09:23:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200814130426.2741171-1-sreekanth.reddy@broadcom.com>
 <yq1a6yoviti.fsf@ca-mkp.ca.oracle.com> <CAK=zhgq-5CNQObiwDutLPGG3CbmpAbj+RbDGX-xGu6mVP_WZYw@mail.gmail.com>
 <yq1r1rvqxqe.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1r1rvqxqe.fsf@ca-mkp.ca.oracle.com>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Wed, 26 Aug 2020 21:53:19 +0530
Message-ID: <CAK=zhgpg754D6J6k3s+xmyxH+2MGWjuNb44Tfccq2z+gFuLPRA@mail.gmail.com>
Subject: Re: [PATCH v1] mpt3sas: Add support for Non-secure Aero and Sea PCI IDs
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 25, 2020 at 7:45 AM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Sreekanth,
>
> > As explained in description the purpose of disabling support for these
> > devices in the driver is to avoid interacting with any firmware which
> > is not secured/signed by Broadcom.
>
> I understand, but that should be a user decision.
>
> What are these devices you want to disable support for? Why is their
> firmware not signed?

The scenario that we are discussing here is a scenario where the
device is showing evidence that someone has attempted to physically
tamper with the device and has attempted to put it into a state where
security could be compromised.

Broadcom adapters participate in a Secure Boot process, where every
piece of FW is digitally signed by Broadcom and is checked for a valid
signature.  If any piece of our adapter FW fails this signature check,
it is possible the FW has been tampered with and the adapter should
not be used.  Our driver should not make any additional access to the
=E2=80=9Cinvalid/tampered=E2=80=9D adapter because the FW is not valid (cou=
ld be
malicious FW). This type of detection is added into latest Aero and
Sea family adapters h/w.

Thanks,
Sreekanth


>
> --
> Martin K. Petersen      Oracle Linux Engineering
