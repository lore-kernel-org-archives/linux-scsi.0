Return-Path: <SRS0=SJ7r=DA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2874AC4363D
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 22:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB2F22311A
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 22:21:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="D2z/jPdm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgIWWVm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Sep 2020 18:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgIWWVm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Sep 2020 18:21:42 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3AEC0613CE
        for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2020 15:21:42 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id r19so510064pls.1
        for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2020 15:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=63j0EJUQN99G7j5vvyO5VhCww+TnWPHlWOLA8rRSbJ0=;
        b=D2z/jPdmdb1OLWvDCj/cp3htLMQAMT9eyJ9DH6ugMuUvJqns5Xu07crUz97Dk3JmFU
         CDNRUPHbOdKwQdFh5VUMoL9A8wa2mkdaU2DXgJgSefJrzsgSlCFMVbRpyUsIP4VzX0Pw
         KSoh6KqK5LufqlM7CjSZWaXh+S4G1YYTiUe40=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=63j0EJUQN99G7j5vvyO5VhCww+TnWPHlWOLA8rRSbJ0=;
        b=aMNxAoi0K2WAgie99GyD9881JlsNsxO3f6i3HzgCdjmhP7thuEefW6gagDCTU6K4NQ
         gIBNxOV103ONOa4v7EoI9wIvHtw2XBmsL4Pe6UHkgrdKsUouMFTIV+Hjv33jAq0ZNN5s
         RbwuuNmUFj1k+1e+Gl5cDpreFuMxb1mPtDaeHHI3XGzGIfvRGs7FaO+8hyvkAFRgd+UG
         PVRWpIggiAmH3QNNgST9qGDytGy2mWbf+zpiX5qBOrSy1eDCO4FqHMmZJKkUHhSnkCHS
         maoek4Gn1brrgZNy602XrDkBBJmn9negww/wWzjIdng8Z0IsOYZN+nj82kBLdob1KSzp
         jzcA==
X-Gm-Message-State: AOAM531vAI7eoS4TOBjK8O4PIIEIbw3+lf9/3QVuSCJ+oqTS8gSrIpwN
        Td5LFVEH+r6jK3iYU50Speltag==
X-Google-Smtp-Source: ABdhPJyhxseZkVVJ+YUCLlbo7QFAhK+5hX/ofFPKjsbsUyQ/GnTQnOCFT5K/SwZ2aRBpBMR6Gyxx4w==
X-Received: by 2002:a17:90a:e093:: with SMTP id q19mr1256298pjy.98.1600899701591;
        Wed, 23 Sep 2020 15:21:41 -0700 (PDT)
Received: from localhost.localdomain ([192.30.189.3])
        by smtp.gmail.com with ESMTPSA id kf10sm422144pjb.2.2020.09.23.15.21.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Sep 2020 15:21:40 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.0.3.2.33\))
Subject: Re: [PATCH 1/1] scsi: scsi_dh_alua: do not set h->sdev to NULL before
 removing the list entry
From:   Brian Bunker <brian@purestorage.com>
In-Reply-To: <be7e6061-5b10-25a7-e8bb-aa4008c04e22@suse.de>
Date:   Wed, 23 Sep 2020 15:21:38 -0700
Cc:     "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <F861B128-F3AC-4928-9B9C-14DE921F70FD@purestorage.com>
References: <8239CB66-1836-444D-A230-83714795D5DC@purestorage.com>
 <3b86ce755e3b0b2b3d9e1a2cdf8c48b742f94265.camel@redhat.com>
 <D047536E-9A0E-430D-BD0C-634DC7594033@purestorage.com>
 <be7e6061-5b10-25a7-e8bb-aa4008c04e22@suse.de>
To:     Hannes Reinecke <hare@suse.de>
X-Mailer: Apple Mail (2.3654.0.3.2.33)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We have tried with our patch here and it works. We have not tried with =
our patch at the
customer site where they hit the crash. Since they hit the BUG_ON line =
which we
can see in the logs we have, we expect that removing the race as we did=20=

would avoid the crash. We also remove the BUG_ON=E2=80=99s in our patch =
so it can=E2=80=99t hit
the same crash. If there is another similar race a null pointer =
deference could still
happen in our patch. I saw you had a patch to only use the value if the =
pointer is not
null. That would also work to stop the crash, but it would hide the race =
where the
BUG_ON was helpful in finding it.

Trying our fix at the customer site for us would be more difficult since =
the operating
system crash belongs to Oracle. That is why you see their patch for the =
same
issue. Our interest in getting this fixed goes beyond this customer =
since more
Linux vendors as they move forward in kernel version inherit this code, =
and
we are reliant on ALUA. We hope to catch it here.

Should I put together a patch with the h->sdev set to null removed from =
the
detach function along the syncrhronize_rcu and removing the BUG_ON, or
did you want me to diff against your checkin where you have already =
removed
the BUG_ON?

Thanks,
Brian

Brian Bunker
SW Eng
brian@purestorage.com



> On Sep 23, 2020, at 1:23 AM, Hannes Reinecke <hare@suse.de> wrote:
>=20
> On 9/19/20 12:07 AM, Brian Bunker wrote:
>> Internally we had discussions about adding a synchronize_rcu here:
>> --- a/scsi/drivers/scsi/device_handler/scsi_dh_alua.c   2020-09-10 =
12:29:03.000000000 -0700
>> +++ b/scsi/drivers/scsi/device_handler/scsi_dh_alua.c   2020-09-18 =
14:59:59.000000000 -0700
>> @@ -658,8 +658,6 @@
>>                                         rcu_read_lock();
>>                                         list_for_each_entry_rcu(h,
>>                                                 &tmp_pg->dh_list, =
node) {
>> -                                               /* h->sdev should =
always be valid */
>> -                                               BUG_ON(!h->sdev);
>>                                                 h->sdev->access_state =
=3D desc[0];
>>                                         }
>>                                         rcu_read_unlock();
>> @@ -705,7 +703,6 @@
>>                         pg->expiry =3D 0;
>>                         rcu_read_lock();
>>                         list_for_each_entry_rcu(h, &pg->dh_list, =
node) {
>> -                               BUG_ON(!h->sdev);
>>                                 h->sdev->access_state =3D
>>                                         (pg->state & =
SCSI_ACCESS_STATE_MASK);
>>                                 if (pg->pref)
>> @@ -1147,7 +1144,6 @@
>>         spin_lock(&h->pg_lock);
>>         pg =3D rcu_dereference_protected(h->pg, =
lockdep_is_held(&h->pg_lock));
>>         rcu_assign_pointer(h->pg, NULL);
>> -       h->sdev =3D NULL;
>>         spin_unlock(&h->pg_lock);
>>         if (pg) {
>>                 spin_lock_irq(&pg->lock);
>> @@ -1156,6 +1152,7 @@
>>                 kref_put(&pg->kref, release_port_group);
>>         }
>>         sdev->handler_data =3D NULL;
>> +       synchronize_rcu();
>>         kfree(h);
>>  }
>> We were thinking that this would allow any running readers to finish =
before the object is freed. Would
>> that make sense there? =46rom what I can tell the only RCU =
implementation in this kernel version in
>> scsi is here, so I couldn=E2=80=99t find many examples to follow.
>>  That actually looks quite viable (if the intendation gets fixed :-)
> Initially I was thinking of using 'h->sdev =3D NULL' as a marker for =
the other code to figure out that the device has about to be deleted; =
that worked, but with rather unintended consequences.
>=20
> Have you tried with your patch?
>=20
> Cheers,
>=20
> Hannes
> --=20
> Dr. Hannes Reinecke                Kernel Storage Architect
> hare@suse.de                              +49 911 74053 688
> SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> HRB 36809 (AG N=C3=BCrnberg), Gesch=C3=A4ftsf=C3=BChrer: Felix =
Imend=C3=B6rffer

