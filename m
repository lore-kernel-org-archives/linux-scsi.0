Return-Path: <SRS0=cDh3=35=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A20BDC35242
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Feb 2020 02:43:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D27122464
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Feb 2020 02:43:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=delphix.com header.i=@delphix.com header.b="Gfi8920h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727636AbgBICni (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 8 Feb 2020 21:43:38 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40789 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727574AbgBICng (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Feb 2020 21:43:36 -0500
Received: by mail-pf1-f194.google.com with SMTP id q8so1844131pfh.7
        for <linux-scsi@vger.kernel.org>; Sat, 08 Feb 2020 18:43:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=delphix.com; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=XEEwa/pWXRm3ZY8rR9l7Teo2iEIQpbgXcL5RFbSunQ8=;
        b=Gfi8920h58Ne42KuYCxGbS8/vk5woV33CD3oOrsjoZhF+aGs3ZdqAEkwMSwgHtUoU5
         ip2q32MQnvGTnt3iTNryF4FskK4scVslxKmMAjRUPeQZ0QW0QahXxm3RemWthQckF4Zm
         YF4te/JeZEWeF26vvYq0CjuJjqQ4ES+D86M7c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=XEEwa/pWXRm3ZY8rR9l7Teo2iEIQpbgXcL5RFbSunQ8=;
        b=Eg6JuADleOyKkm2vnSnW2UylpLpHHCq4oNaWNrZy70jbw7g8VYwNwC8Fufu2Nia4nK
         HqCVS0kxVAldhUmOzZOSJY8BiWmrNm6rO4Ed+pDtSwd0S+8EF8ma3YhBpebagyAck4oS
         ngQySG5KiJM4+LlO9u6kffTbVv2WMDEoE44gTWXmrY1iyYw1x0BZ0KibdWrlPD6iHiQi
         GighXZvRnIGFgRrMG8JH4E53tg2XpSuX3lZln3o5Q5sPYVd1HTeoqHnmbpnNBZ501gZI
         nqgBeGYifB2i6ZgRrZPUrGwSLxuUhuaWMcoAEf9ZUbcwi40h1Jz9VuIwCy8w6LU1/fUk
         YOhw==
X-Gm-Message-State: APjAAAV5SUkDyWiHgmidXYYIrK/EmvBoYN78fl/eMd0KQ3z/hWfJ/Ft5
        IaBzK+IjcPgUogAHPlRsUQwV5Q==
X-Google-Smtp-Source: APXvYqwAaFHdq3+dqVZCYp0ga29jAsUqxx88E/AKVRppoccuP3qsE7pUXWdBt3Lf6jkuBBb+YrTUBg==
X-Received: by 2002:a63:2010:: with SMTP id g16mr7675385pgg.314.1581216214911;
        Sat, 08 Feb 2020 18:43:34 -0800 (PST)
Received: from [192.168.0.103] (modemcable127.167-81-70.mc.videotron.ca. [70.81.167.127])
        by smtp.gmail.com with ESMTPSA id l12sm7495512pgj.16.2020.02.08.18.43.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Feb 2020 18:43:34 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [LIO-target] BUG: Deleting a LUN hangs in transport_clear_lun_ref
From:   Pavel Zakharov <pavel.zakharov@delphix.com>
In-Reply-To: <a1291c13-628f-edf3-3778-56b25f02edaf@acm.org>
Date:   Sat, 8 Feb 2020 21:43:32 -0500
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <2B6C1870-457C-4754-8E1A-ECBBDFD07083@delphix.com>
References: <9A92D656-A796-4858-85CD-3750BDACFA28@delphix.com>
 <a1291c13-628f-edf3-3778-56b25f02edaf@acm.org>
To:     Bart Van Assche <bvanassche@acm.org>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

I=E2=80=99ve built linux-stable, commit =
f757165705e92db62f85a1ad287e9251d1f2cd82 and could easily reproduce the =
issue.
I=E2=80=99ve rebuilt the kernel with patch =
83f85b8ec305be9d65284de2921d8eeb6c7fcf12 reverted and that seems to fix =
the issue.

Regards,
Pavel

> On Feb 7, 2020, at 10:12 PM, Bart Van Assche <bvanassche@acm.org> =
wrote:
>=20
> On 2020-02-07 10:48, Pavel Zakharov wrote:
>> I haven=E2=80=99t yet tried rebuilding the kernel with the patch =
reverted,> but that is the next step I=E2=80=99m planning to try once I =
figure out how
>> to do it.
>=20
> Hi Pavel,
>=20
> How about verifying as follows whether that patch is the root cause:
>=20
> git clone
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
> linux-kernel &&
> cd linux-kernel &&
> git revert 83f85b8ec305
>=20
> and next configure, build and install the kernel, reboot and rerun =
your
> test.
>=20
> Thanks,
>=20
> Bart.

