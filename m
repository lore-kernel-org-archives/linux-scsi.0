Return-Path: <SRS0=jwuq=XU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BBCEC432C2
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Sep 2019 10:14:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40F2521D7A
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Sep 2019 10:14:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gyX7D963"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388262AbfIYKOD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Sep 2019 06:14:03 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39898 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbfIYKOD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Sep 2019 06:14:03 -0400
Received: by mail-qt1-f196.google.com with SMTP id n7so5847225qtb.6;
        Wed, 25 Sep 2019 03:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5xfSt12DB7rzQoEf/QfKRzG2YSR3emsAMeE1VuPEUy0=;
        b=gyX7D963InhuJNIvV4dOAXQEcwwgbRbpZRMdg7EyOJI9E5NvmjkqUagEoTyvSzblSC
         HJz59Ypad/ILT/9/unz+x/G8DZIYclaxxsOSavqR5biHvDvqGyCM/gL39g59APxDG/da
         9aSbT1kRibXt4rvkGQvOrClu2JRqX/wxYRwrMbR2al3wHAENKf8iTaS7SDSk0YE7zrJB
         57Ic26ivmXOytavRAbk35fFe9C2HEKzhFSlkXc1zReh+xzGnSe1tLZprBiXOvcz5bipp
         u5Y7gFYl7PJ+9t9fTwkLyoaCzg6qXgsQ4mL7bvbd2n7PWKijz12r3szW6ZNrPbhJ+MgR
         3rZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5xfSt12DB7rzQoEf/QfKRzG2YSR3emsAMeE1VuPEUy0=;
        b=QzzvxT94bYjQWPMGKjNzg6nN+FnieuAs8932tWPc7o0CFTUm8zuMXSsyiX3TCBdEUk
         aE40cLZqKhqclngKaFmCbyGBDIYFUcb469it30OP+zwZulXmM8PLkUkdIGVr7Dl1cRce
         0hE6CqhvtIyAz2VoVdTcAqeOM2KhhxYNdxz02UQI+hoKSAo3rtJYnQ8p8Ho8g2fx4wf7
         K1Ovw7K1mZDGn7SrwG2cAPlMxHGaWjnfx7wQmLECsaFPVUYsagd7GIpQdwl6LUeH5raz
         s8mgge77Ft6WzerwRDnG7Gc9YmGZqOaiF2R5QIkuQVZHk41RoAeZKiboq1GkD+n/rEGh
         cUfQ==
X-Gm-Message-State: APjAAAUjx78Xm8fKStHx+xyeAaNrlADIHl7Jpj8P4OCNH63gZuMv7RQb
        3ILhn/NVUoXSR/zCDsc8fgXfXobTRKgYNQJYfSld1o/8jZI=
X-Google-Smtp-Source: APXvYqwmNKci8boFnyBJE+wlcKhLvqycB1RHdLQKL/HWhzNXo9OP/QBxwYRX7Re1wMGIBm9KBtxKrFmdb6mPOjs8onk=
X-Received: by 2002:ac8:7310:: with SMTP id x16mr7744986qto.382.1569406442551;
 Wed, 25 Sep 2019 03:14:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190919075548.GA112801@LGEARND20B15> <yq1o8za4e9i.fsf@oracle.com>
In-Reply-To: <yq1o8za4e9i.fsf@oracle.com>
From:   Austin Kim <austindh.kim@gmail.com>
Date:   Wed, 25 Sep 2019 19:13:57 +0900
Message-ID: <CADLLry5mbHhF8-Z1VSbdaE8x+60ubEpv=hEQPU4UwXAnzfMv2A@mail.gmail.com>
Subject: Re: [PATCH] scsi: qedf: Remove always false 'tmp_prio < 0' statement
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, QLogic-Storage-Upstream@cavium.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

2019=EB=85=84 9=EC=9B=94 24=EC=9D=BC (=ED=99=94) =EC=98=A4=EC=A0=84 11:32, =
Martin K. Petersen <martin.petersen@oracle.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=
=EC=84=B1:
>
>
> Austin,
[...]
> > So remove 'always false' statement.
>
> Applied to 5.4/scsi-fixes, thanks!
>

Good, thanks for information.

> --
> Martin K. Petersen      Oracle Linux Engineering
