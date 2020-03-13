Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1D0AC10DCE
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 14:45:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 754BB206FA
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 14:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584110704;
	bh=WdFv2gQlv7nTeMNZuL05RFAyNdL9qkEWV9UYdOnc75Y=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:List-ID:From;
	b=VodXR/OTd2UOCohaWTiki2Uuf2oXurjgqraT4rERuINfTDMaS99CJn+K53vOOqAox
	 ObsNxvzJMgq5PfjdaxsolXNX6ndB58JZjm0wYBdVxLemsZ0a4ySHK9c5Okcs3pUqKq
	 Jm0uJinRu89vlSJ+xyXXFiTXXIECjjJxzbxQlDpI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgCMOpE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Mar 2020 10:45:04 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37015 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgCMOpD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Mar 2020 10:45:03 -0400
Received: by mail-lj1-f193.google.com with SMTP id r24so10826600ljd.4
        for <linux-scsi@vger.kernel.org>; Fri, 13 Mar 2020 07:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=zVJiEyQwMquLoYw8fQkdRceUbhA2Hi0rvdjcWfvwzGU=;
        b=JB4hJWX6LE4F1cNPKxpsZZMh8sTLImvr7sL1YZNtxjJyJV7lHwVrZTy7sz3mYy3Wv9
         LcZJ3Yi/5/TlBk+/jQR4cLUDshQfmGGcIl6HDQVnuYm8Yb3W9j9QNpT9E0b1P9Les/UX
         xR1NXgsQS9T6DbM3Sy3SvApPiCzjfRzydsLwO4PoRgr3ydXJ2HJsEy/26drwC44ShwxT
         7hHJYqwkanTNsC+vRZHfJtVMywAwvpkKx9m9Sed3Nhzadf6tr1VYfnJoxAtAKpNS2nao
         ywFu5CBLyxRKoCAR3xgu+MeDwbZmACAOcfdkPbGrstS9tFzlPcrkr2CwnrpC6N7uKnsu
         JeFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :date:message-id:mime-version;
        bh=zVJiEyQwMquLoYw8fQkdRceUbhA2Hi0rvdjcWfvwzGU=;
        b=HGE3iqLB2N7tPUluahwf9N3DV1cP+ad8YojxUmLMCcl4vsPUDa0pnPoZxusCSdg2XI
         MlZjShd/NiFpaBxsARFozyrAbHnu987lChMrAac3pf1622mQAQRGb2GcN8ze55MYnhY9
         FBMl0yM5IP4XgOXa/UJXJ+vhkLHz0/DxtTi6ipYJsPau0bWhC4eKdlajtAThpHqL+F7J
         a8P3aqNF7xIZe+J5D4E4VRo5Ms8vDv8fyJW3ElbQqR3zffN8BTpbTQRGZPbfPFqGi/hF
         DhFDDx/xKympU5Uti85KFBB1S32csAzonUU5CPrtUCCykBKo94iW+0L0P5TO5GTgid4Z
         5+VQ==
X-Gm-Message-State: ANhLgQ2MIaBm/FXei4Y8R1X4FukjQ/bKc2J+g389Qyy5om8PLF6asjK4
        vYM5ZodjwtUybw0oYj+pUvQ=
X-Google-Smtp-Source: ADFU+vuqzMtFVe8z4+tD9uGDTHoRE/CS5Y7UXBPWb/6L00Ytxjc2o/kTYfRZAsja5nip2rha3ouoHg==
X-Received: by 2002:a05:651c:1058:: with SMTP id x24mr4637946ljm.248.1584110701613;
        Fri, 13 Mar 2020 07:45:01 -0700 (PDT)
Received: from saruman (88-113-215-213.elisa-laajakaista.fi. [88.113.215.213])
        by smtp.gmail.com with ESMTPSA id x13sm16936098lfq.97.2020.03.13.07.45.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 13 Mar 2020 07:45:00 -0700 (PDT)
From:   Felipe Balbi <balbi@kernel.org>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@fb.com>,
        Harvey Harrison <harvey.harrison@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 3/5] treewide: Consolidate {get,put}_unaligned_[bl]e24() definitions
In-Reply-To: <20200313023718.21830-4-bvanassche@acm.org>
References: <20200313023718.21830-1-bvanassche@acm.org> <20200313023718.21830-4-bvanassche@acm.org>
Date:   Fri, 13 Mar 2020 16:44:56 +0200
Message-ID: <87v9n8fh5j.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Bart Van Assche <bvanassche@acm.org> writes:

> Move the get_unaligned_be24(), get_unaligned_le24() and
> put_unaligned_le24() definitions from various drivers into
> include/linux/unaligned/generic.h. Add a put_unaligned_be24()
> implementation.
>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Keith Busch <kbusch@kernel.org>
> Cc: Sagi Grimberg <sagi@grimberg.me>
> Cc: Jens Axboe <axboe@fb.com>
> Cc: Felipe Balbi <balbi@kernel.org>
> Cc: Harvey Harrison <harvey.harrison@gmail.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/nvme/host/rdma.c                     |  8 ----
>  drivers/nvme/target/rdma.c                   |  6 ---
>  drivers/usb/gadget/function/f_mass_storage.c |  1 +
>  drivers/usb/gadget/function/storage_common.h |  5 ---

for drivers/usb/gadget:

Acked-by: Felipe Balbi <balbi@kernel.org>

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl5rnGgACgkQzL64meEa
mQaWmg//a+dj07jIlxYYNBoC7+XeZAov8dJbiuTF6daxD/2VivdQ3RAz/EfberYb
Kd0S+JwxdEC7tRCMn4SJxL81AwYO7yxHSj3qqSB179zJ06YKz8hzAHjkA4VBfXFx
738oz8Y8EQ3Nw2OldmgngnUMbAaDN5greF4gM7av/7LL4+ouBLrkC0ObqYFFen8W
eRhHW6guFTI76yLBPTrVaaO65LurHJoXXBgY3WZ/EaFDr5nfykEaZrZwr70Lne3y
kZMNbNetEt/uJostri+inBo+acXasLjIA6jQmDqgkOMDvwOr7AsfhFDmzlngB3m9
m8J1bm+fSSnhGv7wrXkTj7O3Ayt2DIr5/HeYy/vqvYhSdPQpkrLkysKYh9a5Pstb
zlLq30m5V24bABw/9EjP/09JbrWpi9l/aNde8TaFiruMyYryQ8D2bvI0WDdULHDQ
ASuiAfe6md299FXG/LqPOafACF/fHOlnYak7mPCPgcqPdvFOlixj1CkJ5Mf6BINF
QgIXPj2aRGGgk4OUqmkA89S/cXJVIHWM+4YE1t6oZjtNtIMA1c9F6vv8Nj/djGha
zyoeezF4K+GOfL8MO46OvJMwARGyIFhl+UHcXZzoHobbEtPIXI9eaeM9gaK4GQcf
bb83rKnXvoq3jGaM04RC9DNsYfRZWCBLzqPmIhNdCEvndvsOrFI=
=uz0E
-----END PGP SIGNATURE-----
--=-=-=--
