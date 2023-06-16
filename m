Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91049EB64DB
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jun 2023 03:33:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbjFPDdG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Jun 2023 23:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbjFPDdE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jun 2023 23:33:04 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557721BD6
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jun 2023 20:33:02 -0700 (PDT)
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 0107A3F182
        for <linux-scsi@vger.kernel.org>; Fri, 16 Jun 2023 03:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1686886380;
        bh=OA3uE2kgqq6B23JrgTI1uITs8Hu9BI85mK6NoVzhE/c=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=I0P2NHsWec+KQ0lc9P9pFnf6MKtUvgt0alFpwJ0bsVZdC3BAZEWQ2LzYD3WjiqpL0
         sjdztdKGMn3wdrByXkd3lXTwQFvqP14/IZ7A669+qlHNIy5ZBEVcAmJK3vKsiqzncZ
         pu+UvnbnymBIfiENrX2iA6aAl7FcnShsgW5RUtKkKRMugFRMKSUStPlKzJe1+yA6FH
         a2UyJrLSDeU2u9Xvd2bs3h0Kd/H6dfnB85krhWfYz1uo4WmgF+LPyWCnrutR7N3IAC
         gn04jzj10rOWavnAT92NdKMdyJiYrx2BL573s8QE1ismbRtF+7+UEQXAP2zu0Uxd2t
         L89XAhwRFkJpw==
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-25ea8a43649so290739a91.3
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jun 2023 20:32:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686886378; x=1689478378;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OA3uE2kgqq6B23JrgTI1uITs8Hu9BI85mK6NoVzhE/c=;
        b=fAMKiGxML9YI5JnaZzt17zxLHf3AzJQKMGkDFK78C49qc/eZo9gwS4KRWlcAICzoZo
         Shl8nbs3D3YHgc4KLvHVGdnKZU2kKCOEEcLirJTnva1DKSL+AO/y2GY2OrAUjif3TnWB
         g+ZT80ZVlTqYplOZjqhgQGQs6seyumTLGzq9CbkTkQtlMcWnzSgGrDM0E5ZTHuHZfswj
         r1eo8zkBAwzUdlX3QEayfol3wLBJCoMoccDeE4/LEV2GDyLHb2+BlFCJHTJ+JEGt0cbd
         qrB0jppgVs2V6R7ykx69LeoObqrxfdK6R0syA39dhvr8iYJdPxPFqWeToTOve30zYGKG
         KHnQ==
X-Gm-Message-State: AC+VfDxRui3bAACdOQOiYDgV59PlvU7xh0YpUwY1yUmwuPt/SkpxY0HM
        aMChO+2XwsehGokq9AdhQ9iCjcq+dcYU32REGHVtCW0zi4a/jNryUYhzAmOE9aIIZ/G4WbCWTTN
        bnrqy808SKtsU1OUWFLYq56I1gJYaFtZfZU6jdIyAZ1Tw+fLxWKXJzvk=
X-Received: by 2002:a17:90a:f185:b0:25e:8da6:74a4 with SMTP id bv5-20020a17090af18500b0025e8da674a4mr734743pjb.21.1686886377992;
        Thu, 15 Jun 2023 20:32:57 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ60IphwdfpqSc0RZmVALnszx/I2HcGwc0ar8R4dS8E/TdakaiVOxK7tfVzcVu+vNW1eW6DxXjAsRShY5hgfA4U=
X-Received: by 2002:a17:90a:f185:b0:25e:8da6:74a4 with SMTP id
 bv5-20020a17090af18500b0025e8da674a4mr734733pjb.21.1686886377604; Thu, 15 Jun
 2023 20:32:57 -0700 (PDT)
MIME-Version: 1.0
References: <20230615083326.161875-1-dlemoal@kernel.org> <b35c2137-6469-4d30-a25c-096e4932fe1b@rowland.harvard.edu>
In-Reply-To: <b35c2137-6469-4d30-a25c-096e4932fe1b@rowland.harvard.edu>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Fri, 16 Jun 2023 11:32:46 +0800
Message-ID: <CAAd53p7+-uXf+wiZkAxSPnjSY7oC6crtfKURptuWCuM7vDAMZw@mail.gmail.com>
Subject: Re: [PATCH] ata: libata-scsi: Avoid deadlock on rescan after device resume
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Hannes Reinecke <hare@suse.de>,
        "Rafael J . Wysocki" <rafael@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jun 15, 2023 at 10:50=E2=80=AFPM Alan Stern <stern@rowland.harvard.=
edu> wrote:
>
> On Thu, Jun 15, 2023 at 05:33:26PM +0900, Damien Le Moal wrote:
> > When an ATA port is resumed from sleep, the port is reset and a power
> > management request issued to libata EH to reset the port and rescanning
> > the device(s) attached to the port. Device rescanning is done by
> > scheduling an ata_scsi_dev_rescan() work, which will execute
> > scsi_rescan_device().
> >
> > However, scsi_rescan_device() takes the generic device lock, which is
> > also taken by dpm_resume() when the SCSI device is resumed as well. If
> > a device rescan execution starts before the completion of the SCSI
> > device resume, the rcu locking used to refresh the cached VPD pages of
> > the device, combined with the generic device locking from
> > scsi_rescan_device() and from dpm_resume() can cause a deadlock.
> >
> > Avoid this situation by changing struct ata_port scsi_rescan_task to be
> > a delayed work instead of a simple work_struct. ata_scsi_dev_rescan() i=
s
> > modified to check if the SCSI device associated with the ATA device tha=
t
> > must be rescanned is not suspended. If the SCSI device is still
> > suspended, ata_scsi_dev_rescan() returns early and reschedule itself fo=
r
> > execution after an arbitrary delay of 5ms.
>
> I don't understand the nature of the relationship between the ATA port
> and the corresponding SCSI device.  Maybe you could explain it more
> fully, if you have time.
>
> But in any case, this approach seems like a layering violation.  Why not
> instead call a SCSI utility routine to set a "needs_rescan" flag in the
> scsi_device structure?  Then scsi_device_resume() could automatically
> call scsi_rescan_device() -- or rather an internal version that assumes
> the device lock is already held -- if the flag is set.  Or it could
> queue a non-delayed work routine to do this.  (Is it important to have
> the rescan finish before userspace starts up and tries to access the ATA
> device again?)
>
> That, combined with a guaranteed order of resuming, would do what you
> want, right?

What you are suggesting is pretty much like my previous approach:
https://lore.kernel.org/all/20230502150435.423770-2-kai.heng.feng@canonical=
.com/

Kai-Heng

>
> Alan Stern
