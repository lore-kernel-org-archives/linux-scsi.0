Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 603CCC27C76
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Jan 2023 19:57:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235776AbjAYT5g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Jan 2023 14:57:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235646AbjAYT5e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jan 2023 14:57:34 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3CF059E55
        for <linux-scsi@vger.kernel.org>; Wed, 25 Jan 2023 11:57:13 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id t12-20020a17090aae0c00b00229f4cff534so4374101pjq.1
        for <linux-scsi@vger.kernel.org>; Wed, 25 Jan 2023 11:57:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ygHMnHsIEZjcgglEGPHyaA5Q1hx5B2oeOu9DAjqK20E=;
        b=G+w4HqqT+vhbdh3murf5Z2sK3MXOwJ3H+aCJvvPArXwl7cJJ36YMmWcF8Pl6Yg24d7
         rnrMYh5QUNdVkH9ayWAxmh0wOt8cWa4A2RshRpIiqLNG3T3lZBIYnJDxlAYnO1FiuOU1
         B7NfS8Ur4lWHL5nRWyLc49qEIyK7Uu1eKyLU9OdBE6uS80Uhvd7qP1XgIrpRBFPbMBpe
         RWaXtYEp6ctAsDVdpxexhyKIbtxy7gBvOmaQm1leUm8ihyMXhX56Cy2II3eVxxXXOttN
         AjzWt3yejgu4LLEfxanv28r7gz+gn39FYg3wSpCCjs2vzkBvf9nZneBocvEdBXlhiWq5
         tmYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ygHMnHsIEZjcgglEGPHyaA5Q1hx5B2oeOu9DAjqK20E=;
        b=YqgSKUjoaylIrePSta9EbevTYxvNn4GFYEGKTqexwFgZ9V3Ygok7R9JDSpMGVkTg3o
         OmGqJpf6ll8v88VUsqTEZ9gqjnxprKNdtFRgQ+8HC7zM9U0dDwLQgDY7gGKCjHqnKhF2
         6JqyqUK+lF9aGTms6BwkCULRYUhrxCDDTqNFpkEBVcQG9t4vDd2Aq/GlGpnKbaMbgb4B
         7y1hAxecqjpvYtUv4wYROKfNyivsQV/7+0R6wvg85mV2bQizXU3ZHO01JMKOeaenCuo6
         eU21MtRDbrHTSqG9yZae8fZLTi+6+kF9fBuML9ICzWJ+bDSChMfPm6EpXJYSyak3sggR
         3/uA==
X-Gm-Message-State: AFqh2kqbC50XY+QattnGpBHhRvOXzYpnlA9B+yDKaaXJrIg+UQUD6lEh
        Owy1dhZ7CuVE/smqvLg4dGzm9eiLkZW33NCn
X-Google-Smtp-Source: AMrXdXsfvnnt1bGQQkjpCy1nk+oBh7Ww/6pIevFLRLnbb7p1/oRss9o5JN6ot9i+fqEz+ZDVqd/2vA==
X-Received: by 2002:a05:6a20:6697:b0:9d:efbe:a113 with SMTP id o23-20020a056a20669700b0009defbea113mr31043942pzh.35.1674676628538;
        Wed, 25 Jan 2023 11:57:08 -0800 (PST)
Received: from smtpclient.apple ([136.226.79.5])
        by smtp.gmail.com with ESMTPSA id d4-20020a63a704000000b0047850cecbdesm3546932pgf.69.2023.01.25.11.57.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Jan 2023 11:57:07 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.400.51.1.1\))
Subject: Re: The PQ=1 saga
From:   Brian Bunker <brian@purestorage.com>
In-Reply-To: <yq1a627l4gn.fsf@ca-mkp.ca.oracle.com>
Date:   Wed, 25 Jan 2023 11:56:55 -0800
Cc:     linux-scsi@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <446766A5-C12A-4965-85F2-49DEF5D93424@purestorage.com>
References: <yq1lelrleqr.fsf@ca-mkp.ca.oracle.com>
 <CB441742-2C22-41A4-95A3-10D251C31F5B@purestorage.com>
 <yq1a627l4gn.fsf@ca-mkp.ca.oracle.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
X-Mailer: Apple Mail (2.3731.400.51.1.1)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> On Jan 24, 2023, at 8:04 PM, Martin K. Petersen =
<martin.petersen@oracle.com> wrote:
>=20
>=20
> Brian,
>=20
>> For a completely separate reason I would like to see PQ=3D1 expose =
the
>> sd device.
>=20
> The host RAID controller case we could probably cover without relying =
on
> PQ=3D1 at all (we kind-of already do). But there are also storage =
arrays
> out there that rely on PQ=3D1 to inhibit devices being claimed.
> Historically they did this because some other operating systems =
couldn't
> handle a processor device type. So I suspect that keying off of TPGS
> alone is probably not sufficient to determine whether PQ=3D1 should =
cause
> us to attach a ULD or not in your scenario.
I had the idea to change the check in scsi_sysfs.c from:
-       return (sdp->inq_periph_qual =3D=3D SCSI_INQ_PQ_CON)? 1: 0;
+       return (sdp->inq_periph_qual !=3D SCSI_INQ_PQ_NOT_CAP)? 1: 0;

This would allow PQ=3D1 but not PQ=3D3 which I think is the right thing =
to do.
>=20
>> ALUA state transitions from unavailable back to another state does =
not
>> work depending on what state devices are in when they are initially
>> discovered.  In the ALUA unavailable state the peripheral qualifier =
of
>> the device should also be set to 001b.
>=20
> Yep, an unfortunate wrinkle in the spec (although it makes sense).
>=20
>> This hole makes the unavailable ALUA state unattractive. Allowing the
>> peripheral qualifier set to 001b to still create an sd device on
>> discovery corrects this hole.
>=20
> Does your implementation actually support READ CAPACITY etc. in
> unavailable state? Otherwise we'd end up with zero-length, read-only
> block devices with no logical block size. And we've been down that =
path
> before and that is no fun.
Yes we can support read capacity when in the unavailable state. For
us the unavailable state means that one controller or array can not
reach the other controller or array on the backend but the front end
ports are still connected. They are up from an initiator transport
perspective.
>=20
> I suspect it would be better to trigger a re-probe of the device when
> transitioning out of unavailable state. Most of the logic is already =
in
> place and we reread VPD pages, etc. I believe there are only a few
> pieces missing from being able to do a full in-place update.
Unfortunately this doesn=E2=80=99t work. This does work in other OS=E2=80=99=
s where
I can logout the connection, and when it comes back it will discover
that the LUN no longer has the PQ set and will come online fine. But
in Linux this results in (after the PLOGI and PRLI):

Jan 25 11:42:28 init72-5 kernel: scsi 7:0:0:0: scsi scan: INQUIRY pass 1 =
length 36
Jan 25 11:42:28 init72-5 kernel: scsi 7:0:0:0: scsi scan: INQUIRY =
successful with code 0x0
Jan 25 11:42:28 init72-5 kernel: scsi 7:0:0:0: scsi scan: INQUIRY pass 2 =
length 96
Jan 25 11:42:28 init72-5 kernel: scsi 7:0:0:0: scsi scan: INQUIRY =
successful with code 0x0
Jan 25 11:42:28 init72-5 kernel: scsi 7:0:0:0: scsi scan: peripheral =
device type of 31, no device added
Jan 25 11:42:28 init72-5 kernel: scsi 7:0:0:0: scsi scan: Sending REPORT =
LUNS to (try 0)
Jan 25 11:42:28 init72-5 kernel: scsi 7:0:0:0: scsi scan: REPORT LUNS =
successful (try 0) result 0x0
Jan 25 11:42:28 init72-5 kernel: scsi 7:0:0:0: scsi scan: REPORT LUN =
scan
Jan 25 11:42:28 init72-5 kernel: scsi 7:0:0:1: scsi scan: device exists =
on 7:0:0:1
Jan 25 11:42:28 init72-5 kernel: scsi 7:0:0:2: scsi scan: device exists =
on 7:0:0:2

So unless those devices are removed before the rescan, which I
cannot control from the target, an sd device will not be created on=20
the rescanning after the logout.

/dev/sg5  7 0 0 1  0  PURE      FlashArray        8888
/dev/sg6  7 0 0 2  0  PURE      FlashArray        8888

Thanks,
Brian
               =20
>=20
> --=20
> Martin K. Petersen Oracle Linux Engineering

