Return-Path: <SRS0=xkU+=C3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D422C43463
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 22:07:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CFE920DD4
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 22:07:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="io92qBM4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgIRWH2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Sep 2020 18:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbgIRWH2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Sep 2020 18:07:28 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5A8C0613CE
        for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2020 15:07:28 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id k13so3706446plk.3
        for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2020 15:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=CmbesHiC7TzLsN7790TAg1oWB/VXyDpEb6oyQIaJzlk=;
        b=io92qBM49Yn+ml71ZhjbJVGYQwGm23Nxh/OUlfmPbTctOG+0gacOrjc96XqxR9WJky
         8JvR1E0GW5VL6OPtr9RNZyLUHzzQIKHD+02EfPyp4KAmyPWpGVRKWsiMaBjbn8vRx1pB
         Jt+aqOyJV2ZpsJZX/29k3WUDYhqP60d/SWvBg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=CmbesHiC7TzLsN7790TAg1oWB/VXyDpEb6oyQIaJzlk=;
        b=UWhpIRhHhGvE6b7p2nd9H6/LAN6BTeD4IDIRc5E1+mdqL4FOWrILkKUoxTTuR4fQGg
         Tch/kUyY2JyaIiYqULr2XteqbfAVeTswJcDLiDKYGmGffnzqmHatEodZNkx0PiTua0iv
         uLdg7BqG8IF/7Lrr0zW6oKiH1QY8VpK1kdsptwDzNEBMl6+w8DLQ2a6n4ZLUWRh1yISy
         prs8TNc8rjNWqCesibxmMiiWsjPlJIXmYUzb37F+00l/ZbUvOe+TonQtj7fQOBIjT4RS
         NQ+48joV8Lxt8Z6kDscoZ5+w/jaCJtATD+JYToNgHt5Nc4HZflq9v0cfd62KLvol5FeV
         zcyQ==
X-Gm-Message-State: AOAM533uiqS3YHc+caGsoj2ce6IteQ15mLsZcswt8c5Kg4J8ku1K/FTT
        BD0P3KrSdWrzKYce10NBzh9rLCdPZ6D8Q5JN
X-Google-Smtp-Source: ABdhPJzu0GMSz1JxDl9CGN8cIsLL6BKOWpFoq6WN6SkBGj4cGHwG2k7YUA2+BkEpdpb+4MgiMokKlw==
X-Received: by 2002:a17:902:8f88:b029:d0:cc03:3ba with SMTP id z8-20020a1709028f88b02900d0cc0303bamr34016497plo.40.1600466847692;
        Fri, 18 Sep 2020 15:07:27 -0700 (PDT)
Received: from localhost.localdomain ([192.30.189.3])
        by smtp.gmail.com with ESMTPSA id x9sm4043399pgi.87.2020.09.18.15.07.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Sep 2020 15:07:26 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.0.3.2.26\))
Subject: Re: [PATCH 1/1] scsi: scsi_dh_alua: do not set h->sdev to NULL before
 removing the list entry
From:   Brian Bunker <brian@purestorage.com>
In-Reply-To: <3b86ce755e3b0b2b3d9e1a2cdf8c48b742f94265.camel@redhat.com>
Date:   Fri, 18 Sep 2020 15:07:26 -0700
Cc:     linux-scsi@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D047536E-9A0E-430D-BD0C-634DC7594033@purestorage.com>
References: <8239CB66-1836-444D-A230-83714795D5DC@purestorage.com>
 <3b86ce755e3b0b2b3d9e1a2cdf8c48b742f94265.camel@redhat.com>
To:     "Ewan D. Milne" <emilne@redhat.com>
X-Mailer: Apple Mail (2.3654.0.3.2.26)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Internally we had discussions about adding a synchronize_rcu here:

--- a/scsi/drivers/scsi/device_handler/scsi_dh_alua.c   2020-09-10 =
12:29:03.000000000 -0700
+++ b/scsi/drivers/scsi/device_handler/scsi_dh_alua.c   2020-09-18 =
14:59:59.000000000 -0700
@@ -658,8 +658,6 @@
                                        rcu_read_lock();
                                        list_for_each_entry_rcu(h,
                                                &tmp_pg->dh_list, node) =
{
-                                               /* h->sdev should always =
be valid */
-                                               BUG_ON(!h->sdev);
                                                h->sdev->access_state =3D =
desc[0];
                                        }
                                        rcu_read_unlock();
@@ -705,7 +703,6 @@
                        pg->expiry =3D 0;
                        rcu_read_lock();
                        list_for_each_entry_rcu(h, &pg->dh_list, node) {
-                               BUG_ON(!h->sdev);
                                h->sdev->access_state =3D
                                        (pg->state & =
SCSI_ACCESS_STATE_MASK);
                                if (pg->pref)
@@ -1147,7 +1144,6 @@
        spin_lock(&h->pg_lock);
        pg =3D rcu_dereference_protected(h->pg, =
lockdep_is_held(&h->pg_lock));
        rcu_assign_pointer(h->pg, NULL);
-       h->sdev =3D NULL;
        spin_unlock(&h->pg_lock);
        if (pg) {
                spin_lock_irq(&pg->lock);
@@ -1156,6 +1152,7 @@
                kref_put(&pg->kref, release_port_group);
        }
        sdev->handler_data =3D NULL;
+       synchronize_rcu();
        kfree(h);
 }

We were thinking that this would allow any running readers to finish =
before the object is freed. Would
that make sense there? =46rom what I can tell the only RCU =
implementation in this kernel version in
scsi is here, so I couldn=E2=80=99t find many examples to follow.
=20
Brian Bunker
SW Eng
brian@purestorage.com



> On Sep 18, 2020, at 11:41 AM, Ewan D. Milne <emilne@redhat.com> wrote:
>=20
> On Fri, 2020-09-11 at 09:21 -0700, Brian Bunker wrote:
>> A race exists where the BUG_ON(!h->sdev) will fire if the detach
>> device handler
>> from one thread runs removing a list entry while another thread is
>> trying to
>> evaluate the target portal group state.
>>=20
>> Do not set the h->sdev to NULL in the detach device handler. It is
>> freed at the
>> end of the function any way. Also remove the BUG_ON since the
>> condition
>> that causes them to fire has been removed.
>>=20
>> Signed-off-by: Brian Bunker <brian@purestorage.com>
>> Acked-by: Krishna Kant <krishna.kant@purestorage.com>
>> ___
>> --- a/scsi/drivers/scsi/device_handler/scsi_dh_alua.c   2020-09-10
>> 12:29:03.000000000 -0700
>> +++ b/scsi/drivers/scsi/device_handler/scsi_dh_alua.c   2020-09-11
>> 09:14:15.000000000 -0700
>> @@ -658,8 +658,6 @@
>>                                        rcu_read_lock();
>>                                        list_for_each_entry_rcu(h,
>>                                                &tmp_pg->dh_list,
>> node) {
>> -                                               /* h->sdev should
>> always be valid */
>> -                                               BUG_ON(!h->sdev);
>>                                                h->sdev->access_state=20=

>> =3D desc[0];
>>                                        }
>>                                        rcu_read_unlock();
>> @@ -705,7 +703,6 @@
>>                        pg->expiry =3D 0;
>>                        rcu_read_lock();
>>                        list_for_each_entry_rcu(h, &pg->dh_list,
>> node) {
>> -                               BUG_ON(!h->sdev);
>>                                h->sdev->access_state =3D
>>                                        (pg->state &
>> SCSI_ACCESS_STATE_MASK);
>>                                if (pg->pref)
>> @@ -1147,7 +1144,6 @@
>>        spin_lock(&h->pg_lock);
>>        pg =3D rcu_dereference_protected(h->pg, lockdep_is_held(&h-
>>> pg_lock));
>>        rcu_assign_pointer(h->pg, NULL);
>> -       h->sdev =3D NULL;
>>        spin_unlock(&h->pg_lock);
>>        if (pg) {
>>                spin_lock_irq(&pg->lock);
>>=20
>=20
> We ran this change through fault insertion regression testing and
> did not see any new problems.  (Our tests didn't hit the original
> bug being fixed here though.)
>=20
> -Ewan
>=20
>=20

