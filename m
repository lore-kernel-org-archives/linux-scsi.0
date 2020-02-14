Return-Path: <SRS0=bR62=4C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E65CAC3B18F
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Feb 2020 09:03:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C72BA222C4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Feb 2020 09:03:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729064AbgBNJDh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Feb 2020 04:03:37 -0500
Received: from mout.kundenserver.de ([217.72.192.74]:44313 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729048AbgBNJDh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Feb 2020 04:03:37 -0500
Received: from mail-qk1-f170.google.com ([209.85.222.170]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1Mr8O8-1jnOoj2bkE-00oIej; Fri, 14 Feb 2020 10:03:35 +0100
Received: by mail-qk1-f170.google.com with SMTP id b7so8501974qkl.7;
        Fri, 14 Feb 2020 01:03:35 -0800 (PST)
X-Gm-Message-State: APjAAAVnIzSCk5a6AcxaOAl8TnH2UCawUIWxg3YVy91JKyF2NsX3AtKx
        p6KUBIxNK9o+Ug3i2tsWjhLCwrp6s/X/pE2nDoA=
X-Google-Smtp-Source: APXvYqzxdQ3jsltSCQQ7TPNGk24YCoKgLcE6gjlvrjdbKJ+rS5vIUVzelJI8j/JXFVa5GDwyuS149BtM8Fz7+eDlgcg=
X-Received: by 2002:a37:e409:: with SMTP id y9mr1537895qkf.352.1581671014406;
 Fri, 14 Feb 2020 01:03:34 -0800 (PST)
MIME-Version: 1.0
References: <20200212164445.1171-1-merlijn@wizzup.org>
In-Reply-To: <20200212164445.1171-1-merlijn@wizzup.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 14 Feb 2020 10:03:18 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2eBrAoksG11LE0CMSKg4ZW1GYTj4N2SmJ-CYQfP1-c8A@mail.gmail.com>
Message-ID: <CAK8P3a2eBrAoksG11LE0CMSKg4ZW1GYTj4N2SmJ-CYQfP1-c8A@mail.gmail.com>
Subject: Re: [RFC PATCH] scsi: sr: get rid of sr global mutex
To:     Merlijn Wajer <merlijn@wizzup.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:vADYcuYB5RZ8TUS9STQURFbdD6Zxn/5udk+ygAXQ9Ug6KUAGvv6
 YlAjdoJGIZkLlY8zH/h00AQBQhOtoVHslHr6knGD6R+ZcaoiLkQW8iXbGvK1KdcXKFY6gqQ
 nmuwKYqHwbPdMW75ikZ/hiINnMqfPKqwAN+4FOpaa7tQcyeLCeDraRYS026hBr5zhR/tfyr
 1SztTA7DJg4NkqYFxlndQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:DEsMw8tusYk=:VT8KzzbnE1h7eVLjRBdf0/
 cswPT3mEkoyX+lLm3MoBlnrLge9n6ev2MNpCuk5LKLBQvKRSKRVEr2oArOdBWFQN5tpmMILSR
 rly1NHRrrc4UeVtWmcDECwawbmbFdF/AV0z1Hz8LRLBg0neeJiw8DJh4Pk4jnQBQsOqulCtBc
 CvdBGDiSKFN26NdNrK8FFrxVLLmyFFklKOf6WO1FdUcVdOqOj68phoOvuiOakXn5rhy2GLHeu
 f/EUUmxPBGZ/5LVxvtLLGWUX4QZaObCsIBszR6woz2HjMSXeRJR6kBG77r33eZ9SG0J9VIbnO
 9lhRN/WEm/RBvrtiJIl4mRjyxBJqKEH+HfoI+4JEJS+SUXpv9xzVeZ2Moyx0xqFKALkTDK6fJ
 yF9r8rXwkBc0Evl00KUb61NK5Gdc2QvuF0B9tVMDKGKRMEulZOF88kPCFhvPS5S5QKjRxS1wJ
 Tzvm8sc/KtogJsV0GIlezlXoxl2Ubck05vQ3Kl3uLOyRHwgSjl7oEueBAk+WiSWQ9RuhDWdLY
 lVN0xgSDYrFvPIKMhwaimILe1bSwxnCiqOySS5fy+2oGjnt6dUSToYoSmPr/qeGnmTPEiD4Fi
 0Mfd1QBi29DlVJ+bgXXQXeCQfvMZvo5/Fr9oMOsAWtKYButA7hze/ZwTF57Lwmu/iuCJiwQdX
 gWMKbsCQ+UBxtkKVg3DdD1jRvOmkkifdIcHEcmEf8fL/VsXhthpNbmvS7gYg3z9fFab/bnwhN
 ZOLqCJLEQ2HgwMPmYwx4NwPcEPce+Fh809qB+wc+ib4JzZ625q3n2V8nOc4nynavTr7+vL77x
 xSyON6g+tQjt3TXnn+/QVtifMWNO8OQixSAmrKyJe23hjW3FUk=
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Feb 12, 2020 at 5:45 PM Merlijn Wajer <merlijn@wizzup.org> wrote:
>
> When replacing the Big Kernel Lock in commit:
> <2a48fc0ab24241755dc93bfd4f01d68efab47f5a> ("block: autoconvert trivial BKL
> users to private mutex") , the lock was replaced with a sr-wide lock.
>
> This causes very poor performance when using multiple sr devices, as the
> sr driver was not able to execute more than one command to one drive at
> any given time, even when there were many CD drives available.
>
> Replace the global mutex with per-sr-device mutex.
>
> Someone tried this patch at the time, but it never made it
> upstream, due to possible concerns with race conditions, but it's not
> clear the patch actually caused those:
>
> https://www.spinics.net/lists/linux-scsi/msg63706.html
> https://www.spinics.net/lists/linux-scsi/msg63750.html
>
> Also see
>
> http://lists.xiph.org/pipermail/paranoia/2019-December/001647.html
>
> Signed-off-by: Merlijn Wajer <merlijn@wizzup.org>

This all looks reasonable to me. The conversion from BKL to a per-driver
mutex was done in a mostly automated way, and I did not attempt to make
it more fine-grained then.

I don't see any global state accessed in the open/close/ioctl functions,
so this is probably completely safe. It may even be possible to avoid
that mutex completely, but that is harder to prove.

Acked-by: Arnd Bergmann <arnd@arndb.de>
