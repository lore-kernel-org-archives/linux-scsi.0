Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5396C433E2
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 14:59:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5652F206D4
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 14:59:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="RV0vJUNr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729177AbgICO7q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Sep 2020 10:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729099AbgICOHH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2020 10:07:07 -0400
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DCEC061A13
        for <linux-scsi@vger.kernel.org>; Thu,  3 Sep 2020 06:41:17 -0700 (PDT)
Received: by mail-oo1-xc44.google.com with SMTP id h9so774796ooo.10
        for <linux-scsi@vger.kernel.org>; Thu, 03 Sep 2020 06:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BYd1e7plEfuVWHk5Mnj4Dk6gPp06w9u8HuR0WjfqFkU=;
        b=RV0vJUNrCHi8aGQU4IlN0yt7dNivxu6UmywIqbn6ua/v6/GY+anD68thjzbqpYbQw2
         aIpRR7uxdYJOZkwmolYuq1d1sCSQp9GDDMpugVeaG8/NGIhVByL1PdHLJabP8l9KEhgL
         wr6qTbFFxLEvbAGzUf0E9rHOv+G1+wSg9bTAg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BYd1e7plEfuVWHk5Mnj4Dk6gPp06w9u8HuR0WjfqFkU=;
        b=VfPtGVCfw5yI4nmkIHUOjQ3mXmo7A6Q/HYDIiAFX2rnc2rYls5+s9XElbnBCtsY5JA
         OX2/Yx3aI3eQOA2PCj7tXGQXX0Z4uHsHLK6jgTc+gdQtb7egoco2nT31nAHOFNZSs7M6
         C1HB48z3aBK+foaoUcV/4IaEvisoDRBBOUULBwijKI9lR74dCILhvcu18dc6ITFNNt7G
         ok/3yTPa0GLQHlrjl8c56xfL0hyBrk2mX2dCJl78IgMoeddXyn3GZSmGhs023UL3jAjM
         PjLgoFvnnBrfA7192CB489YUzqRFNo75u9CwrT7kCj8QVxAtYV9bYkrFltci/XNlEsOC
         uW3A==
X-Gm-Message-State: AOAM531mmgKjEaqAj5ubyA02eBbXCGiyltQB/7CfH7i8kcLbPAw+Cz9+
        Tl7KMqC/GJ2/SBxDSietj1Y7zarD/LK0KzengJvvpQ==
X-Google-Smtp-Source: ABdhPJz76QY1XeBApAZUQ2ICaxVQP4fv1BrDtYSAUSKnNRXQCTlNRl7oK6rft2cq3RxpRATF1aO27iVoTuMOUvwkS/Y=
X-Received: by 2002:a4a:315b:: with SMTP id v27mr1833886oog.20.1599140474907;
 Thu, 03 Sep 2020 06:41:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200814130426.2741171-1-sreekanth.reddy@broadcom.com>
 <yq1a6yoviti.fsf@ca-mkp.ca.oracle.com> <CAK=zhgq-5CNQObiwDutLPGG3CbmpAbj+RbDGX-xGu6mVP_WZYw@mail.gmail.com>
 <yq1r1rvqxqe.fsf@ca-mkp.ca.oracle.com> <CAK=zhgpg754D6J6k3s+xmyxH+2MGWjuNb44Tfccq2z+gFuLPRA@mail.gmail.com>
In-Reply-To: <CAK=zhgpg754D6J6k3s+xmyxH+2MGWjuNb44Tfccq2z+gFuLPRA@mail.gmail.com>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Thu, 3 Sep 2020 19:11:03 +0530
Message-ID: <CAK=zhgqtgcOSAhBzUgaQ3B0FKgvy3QFn1nB9vbG+v_oZ6tErNA@mail.gmail.com>
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

Hi Martin,

Please let us know if any further information is needed for acceptance
of this patch.

Thanks,
Sreekanth

On Wed, Aug 26, 2020 at 9:53 PM Sreekanth Reddy
<sreekanth.reddy@broadcom.com> wrote:
>
> On Tue, Aug 25, 2020 at 7:45 AM Martin K. Petersen
> <martin.petersen@oracle.com> wrote:
> >
> >
> > Sreekanth,
> >
> > > As explained in description the purpose of disabling support for thes=
e
> > > devices in the driver is to avoid interacting with any firmware which
> > > is not secured/signed by Broadcom.
> >
> > I understand, but that should be a user decision.
> >
> > What are these devices you want to disable support for? Why is their
> > firmware not signed?
>
> The scenario that we are discussing here is a scenario where the
> device is showing evidence that someone has attempted to physically
> tamper with the device and has attempted to put it into a state where
> security could be compromised.
>
> Broadcom adapters participate in a Secure Boot process, where every
> piece of FW is digitally signed by Broadcom and is checked for a valid
> signature.  If any piece of our adapter FW fails this signature check,
> it is possible the FW has been tampered with and the adapter should
> not be used.  Our driver should not make any additional access to the
> =E2=80=9Cinvalid/tampered=E2=80=9D adapter because the FW is not valid (c=
ould be
> malicious FW). This type of detection is added into latest Aero and
> Sea family adapters h/w.
>
> Thanks,
> Sreekanth
>
>
> >
> > --
> > Martin K. Petersen      Oracle Linux Engineering
