Return-Path: <SRS0=gVs6=XW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D6C5C388F3
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Sep 2019 15:39:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 247D2217D9
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Sep 2019 15:39:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m7jFLR0D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727934AbfI0PjE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Sep 2019 11:39:04 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:36802 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727207AbfI0PjE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Sep 2019 11:39:04 -0400
Received: by mail-wr1-f53.google.com with SMTP id y19so3542143wrd.3;
        Fri, 27 Sep 2019 08:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=57IhBJyef1fR/FRADa/1UwQsGQlMxqvGVBiiCpQwIqk=;
        b=m7jFLR0Del8V/jHv+RvdbJmXMac0aO0Q0joIoDHiDG84oXYYEfhOoy/KVWHC5pxjOE
         QYqp/AId6qBCgDMNVdWYVCY7P8PzxYJuxjASqCmthvRxyyVC3tlkxUR7CUVZS8AA6S9v
         YM34EO8ubqKasw+PXhg2epK0kCtOHW8HvgnlIIjYrgo8O7pQZRVyZFwW7Me7uZIVITfJ
         4d9fVTFkANNx9924ep7WK4TPlS2EmOr1p/mEEx4kyYHgVe7mNlz/qtmwmOHaB08CE7Ip
         HRXiz67OxDLW6G0WsCozy7NcuELNpglsNfFlwyXdqmi5btXyeP6tc9tpoCkMyhyXXBfy
         YEMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=57IhBJyef1fR/FRADa/1UwQsGQlMxqvGVBiiCpQwIqk=;
        b=nCAEuocWA0oHpwoiefogpXPcFPSBWWnc48HA7CX8mB8wtlpDfkUuI+vTk+Iyw1RHHa
         BkHY5hDQ4FmQdFIwyUxl5/eur+p8dMQvAwsWwThIkpbVmSaIdENbeLwL3aZc4a4EPo3I
         X4dYplaCLoWw7D+opGl7XdHz4sn73GUKeiLvrb29CNch0dB8p74xW63djWrYeaiuowQ3
         iKIHWtqrb6K7elBxyftaOItQLlsCdV8vY9gPHhBlbL61gE9NnJRGXgfQaLE4RvhBzeZr
         btLwZZFoj73TDALqfe1tybgoU1CvIcmnieB3FZbLnXlsODFMEzpI7amKg7k+NG3XlMSH
         1o8Q==
X-Gm-Message-State: APjAAAWHnWuvUO897x+K0Jjf14CwJ6vvJZQDziW22+9KIxygueg7XGJ6
        JSJPmjYiZ/iVvOktTbV3Iso4khAla3llgP/pBt2unKG4UmE=
X-Google-Smtp-Source: APXvYqxDV8sMU5SQznT74ajo8QblefGao1hVZEK2w6azCI3vZmIw7UR3vijg/vNNHL+NjxsHb4skXmcfgqTwwSmT5Yw=
X-Received: by 2002:a5d:5352:: with SMTP id t18mr3693775wrv.72.1569598741857;
 Fri, 27 Sep 2019 08:39:01 -0700 (PDT)
MIME-Version: 1.0
From:   Richard Weinberger <richard.weinberger@gmail.com>
Date:   Fri, 27 Sep 2019 17:38:50 +0200
Message-ID: <CAFLxGvw0HF9dxars5737Vgi+-ufXoBXgMmR_uqtVWyAs3vYyHg@mail.gmail.com>
Subject: st: EIO upon almost full tape?
To:     Kai.Makisara@kolumbus.fi
Cc:     linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi!

Recently I got access to a tape library and as a side project I try to
turn it into something useful.
First tests showed that it seems to work fine until it tried to fill a tape:

dd if=/dev/urandom of=/dev/st0 ibs=1M obs=512K

After around 1.8TiB dd terminates with EIO and in dmesg I see:
[535116.858716] st 0:0:0:0: [st0] Sense Key : Medium Error [current]
[535116.858720] st 0:0:0:0: [st0] Add. Sense: Write error
[535116.874357] st 0:0:0:0: [st0] Sense Key : Medium Error [current]
[535116.874370] st 0:0:0:0: [st0] Add. Sense: Write error
[535116.874373] st 0:0:0:0: [st0] Error on write filemark.

After a reinsert of the tape it works fine again. But any other attempt
to fill it results into EIO. Every single time after ~1.8TiB (-/+
10GiB) have been written.

I expected to terminate dd after around 2.5TiB with ENOSPC.

First I thought the tape is bad, but even with a new one I face the same issue.
Tape is LTO-6 and drive a IBM ULTRIUM-HH6.

Is my test wrong? There is a high chance that I'm doing something
horrible wrong,
I fear I'm a little too young for tape drives. ;-)

Maybe the tape drive is faulty but why is it always failing after 1.8TiB?
According to the tape library the drive is good and passes all self-tests.
And yes, I have a cleaning tape in my library too.

-- 
Thanks,
//richard
