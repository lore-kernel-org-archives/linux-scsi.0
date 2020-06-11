Return-Path: <SRS0=1qKe=7Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34E36C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 18:10:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A01420792
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 18:10:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oac2fZTN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbgFKSKb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Jun 2020 14:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727914AbgFKSK3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jun 2020 14:10:29 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC87C03E96F
        for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2020 11:10:29 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id q2so3930005vsr.1
        for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2020 11:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qBG61BxxBp7IlBUujng28y0PM1uk4u4KvqXRqLe/cjM=;
        b=oac2fZTNAh72q99UWVxzTVYB8BO9Offdv45H8Sw/PcQ2aNE3a1jUSrNmaGpxo7ihok
         77dsj5n++I9x0fEVPM94FqccZ4BLqhYWu6cCg0FeITl+R0J95BuRk5o08wk6RY/66xdK
         5nGUGD4SpDOWWQeECZJNPofI9J2OQFfxLagAr8yE3YBC44vHviMYhSFb785w6E7ffi7Z
         +dtwVMn+pfjSIX647qOpu1XS0ijb85vRY7VnL464d1oNvzgMYuNyFrhTa/vrp41BkrjG
         qGpqJ99wfmm7A/2TkydKCGRbJ6V6q07zcEVtWvUFprCuJTa9yHiuXQOBdVU2KBnzqsSx
         rcbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qBG61BxxBp7IlBUujng28y0PM1uk4u4KvqXRqLe/cjM=;
        b=cC7hQvFE9eV0xc4u5ipG5Wv1BSDovxhgvpsRT4STJnqLH9fBa1WLV0Hc3y+QdMiljX
         yjmdV2irFs6b8aWeGp4pZd9PI03Fi1eXE/c6+gBCzG33Int+97Vng3T0iqxZTC1eHZjH
         jhaRNUXFWGZyd23X7Mlp+DWW3Ls36yHFQ9AgVKU0k1ryF7ZagJIXgjA39BfxhFGny3AT
         N28G4E3987YARIuiJ8EudvykKkk4OiJvQWKlcAg5d6GhG/A3qvfbD1owbRMWHMRyLPJo
         QhJljoZ0SSIxW0BufXvVroYzIRi+yFlFmTS5k5IXAfgl/EDdGTiGR2g9gQ6wLnWVrVEz
         t/Ng==
X-Gm-Message-State: AOAM532sRUg6KUFNPiylR4ax7h8EpUotSxskNvpzrxC3OHRoyaTmGsQX
        AP9/qoFESJWw1MgZ0DLkeMHcrCzi6qo38DMu6W4=
X-Google-Smtp-Source: ABdhPJyceaTDUtir1+SAIFQwTinEtaT4H2OMpOJz9uN5gXj7IC0+2o92Nm4uux66tPW2Ii7SXYjF8Fi0eFiug2ymqYc=
X-Received: by 2002:a67:e0d7:: with SMTP id m23mr8194975vsl.221.1591899027902;
 Thu, 11 Jun 2020 11:10:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200514101026.10040-1-njavali@marvell.com> <20200514101026.10040-3-njavali@marvell.com>
 <927c2cbd-682f-a80e-bd2e-2e5bd012ab2d@broadcom.com> <CA+ihqdjtoA=1q7N0pg1TQDAMGo1XtNN8+XnO1qXORyqGYfpq=A@mail.gmail.com>
In-Reply-To: <CA+ihqdjtoA=1q7N0pg1TQDAMGo1XtNN8+XnO1qXORyqGYfpq=A@mail.gmail.com>
From:   Shyam S <born27thfeb@gmail.com>
Date:   Thu, 11 Jun 2020 11:10:16 -0700
Message-ID: <CA+ihqdi2oQVW7Nks3wfvN=KVhtNNhJg2yeCxZMgKt-t-qc36qw@mail.gmail.com>
Subject: Re: [PATCH 2/3] qla2xxx: SAN congestion management(SCM) implementation.
To:     James Smart <james.smart@broadcom.com>
Cc:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Resending to the reflector.

On Mon, May 18, 2020 at 4:25 PM Shyam S <born27thfeb@gmail.com> wrote:
>
>
>>
>>
>> > Q: what purpose are these shorter "meta" event structures serving ? Why
>> > hold onto (what I assume is) the last event.  Wouldn't something
>> > monitoring netlink and use of the existing fc_host_fpin_rcv() interface
>> > be enough ? it should see all events.
>
>
> The Idea was to be able to have a longer term view within the driver so that while debugging issues, correlations can be made between symptoms exhibited by the driver with these statistics.
>
> All your other comments make complete sense to me. I'll re-work the changes to move them up the stack.
>
>
> Regards
> Shyam
