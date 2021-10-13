Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E7B3C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 16:05:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73E4D611C2
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 16:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236821AbhJMQHz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 12:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236782AbhJMQHy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Oct 2021 12:07:54 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB19C061746
        for <linux-scsi@vger.kernel.org>; Wed, 13 Oct 2021 09:05:51 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id o83so4501155oif.4
        for <linux-scsi@vger.kernel.org>; Wed, 13 Oct 2021 09:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/rpopLFh8ojCGcqr8NWLhMV5N3onX0hCvDnlEQaTzyE=;
        b=h3qrFhA+2rg0TgahrCMTHhOw1HgJdaTVrlZjujHkW+/iJc6zdwGMb6fBSCRs2n0TPk
         yGCuLVN/Wg0YVJgBywyHEQLsK5GYS1o7R4vBd5o5iKuYWu0HRdUU+IKYWbbFy0xsMfTX
         sFRamZ1FSZ/c+Pl/YOtvayK489b8SPzJ0kTDU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/rpopLFh8ojCGcqr8NWLhMV5N3onX0hCvDnlEQaTzyE=;
        b=C78haJ9FE/OSr+Tcwxdg9uTgvumI2lqWXFp12voH7MELFvafkedZOYMax3uwjmhs/8
         MlgUA3ocdAho6foMy1d3QbKnNWaHI7tn6XUVWMAz9eehYrNAyEagTIhV2PGExq7cboLn
         HXVXWOcOweL+EXEpqUZTe+/TcnzZFA7ka/VMm6Wr6j5PHj3uSLW6az/0EU/kV80p6U2w
         qbbEBrdh2ueE0lk/zSJZ3JEG+zJ5pazayQKlmPryx69aDzwySw+ZqGOvrKr8SeK0amxA
         YHAkVvUe/yf2UfMq2WXMJTJHaHWnGzs0bh/rYgsiTryZOrIO/iZbHZ9A7qORrc4IslA+
         Xwsw==
X-Gm-Message-State: AOAM531a2ieYxnEf5Vb933cAerHI26lMWhODDS3rXWuHa8iHwrRIy+60
        pvSEjbI0QW8TOXX5rzol7WpB7dJyc+kfzP/eppA1sw==
X-Google-Smtp-Source: ABdhPJxborwmSSryJNf+y7Lh2rI3AlZYNyWpXCj/OdJxJslsqMv8BF6Ub2c+ZcfYLl4bmrZdCBy65HXkm/vBopjQkY0=
X-Received: by 2002:aca:af91:: with SMTP id y139mr1995oie.7.1634141150292;
 Wed, 13 Oct 2021 09:05:50 -0700 (PDT)
MIME-Version: 1.0
References: <20211013081656.16494-1-sreekanth.reddy@broadcom.com> <YWaXmqGGOtJaRbOk@kroah.com>
In-Reply-To: <YWaXmqGGOtJaRbOk@kroah.com>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Wed, 13 Oct 2021 21:35:39 +0530
Message-ID: <CAK=zhgo4CThfpRf37J3wufSjVByErdriBFpjMeBx2EumiRhR=A@mail.gmail.com>
Subject: Re: [PATCH] mpi3mr: Fix duplicate device entries when scan through sysfs
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Tomas Henzl <thenzl@redhat.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Oct 13, 2021 at 1:53 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Oct 13, 2021 at 01:46:56PM +0530, Sreekanth Reddy wrote:
> > When the user scans the devices through 'scan' sysfs using below
> > command then the user will observe duplicate device entries
> > in lsscsi command output.
> > echo "- - -" > /sys/class/scsi_host/host0/scan
> >
> > Fix is to set the shost's max_channel to zero.
> >
> > Cc: stable@vger.kernel.org #v5.14.11+
>
> Please tag this based on a release of Linus's, or better yet, provide a
> "Fixes:" commit so that the stable people know exactly where to backport
> it to.
Thanks, Shall I resend the patch with proper "Fixes:" commit ID.

>
> As this is, we do not take patches only for stable kernels...
This fix applies for the mainline kernel as well.

Thanks,
Sreekanth
>
> thanks,
>
> greg k-h
