Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACD37C433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 22:58:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70E1E64F8E
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 22:58:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbhCKW6Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 17:58:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhCKW5w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 17:57:52 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB941C061574
        for <linux-scsi@vger.kernel.org>; Thu, 11 Mar 2021 14:57:50 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id kk2-20020a17090b4a02b02900c777aa746fso10099355pjb.3
        for <linux-scsi@vger.kernel.org>; Thu, 11 Mar 2021 14:57:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :to;
        bh=dl24h6rvUnlGzkqonk3cydn40MXkH1vG2xIqeXvOik8=;
        b=L0sUfMxXHWGXDkgKBF7nN6nMJUtedt5bGuCPY28mZwTcMcgEgN+APQQ0SeHOraTMs7
         HaMx1W2agLBLGvSvr/AAxQ4Xqwdjf+IfROYyjplQwPY+w6Pb3iL4LQdP8Zd3AJFUOr5a
         BheN0Qw2epy9V8Qr/7vwJWtYldfMmLRqkQ4K4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:to;
        bh=dl24h6rvUnlGzkqonk3cydn40MXkH1vG2xIqeXvOik8=;
        b=f7liBDLTFbjfG5crDfUBS/Kxdcp19sbXos/rpK6R0JgdBxy9ty+EBMhATu3f7GJDNa
         bzHbEpX1bXxdHKgMncLKfzLoLQc46k58jcniFTOfxR1mXF2j6ZyfTfKJtxpFBlhjmOSy
         r7LoluzsIPJp6w2MiNfGEIqBebq3tuI5fxDujaBb4jKUIRxTEZLNYAOM5YxfIKobJGHh
         lZZMbpEpwv32zZup9oXnFArh67jjveIKAdgVTZTP8xAsJA6zX4uly/JoTUfLoeeHd4WY
         +aLEoqdqvE7ag/P7If77d07dQj3NrK4j6TYSdcvKAr1dR75arFcNGu8P8tJLq+RBC9q8
         pMag==
X-Gm-Message-State: AOAM531yc55hLDokScTZ47oBiZA3W/ydJy5jxEm/rgf9osmlari8QmsO
        IrGdsaWkujLpZmWhtnb5vO7Y8b0u3u6MZ53lASf/uANdVLe3yRGZYnj6e5Et2v7PeGKW9YYwrRK
        4p4aYIdb/muKWvcpCarvLl1AMnoVhDVcNaK+0e7wNxbOsER07WmaxDpePMXp3l/ogFXV0BjqMh6
        cYAc8=
X-Google-Smtp-Source: ABdhPJwsfhIkJxRlWRUwsL9+I6SDJX2awZjYLLiX0k6sqbQZNJhv2PVbMgbaVjAscfsJamjS3iWmIw==
X-Received: by 2002:a17:90a:f40c:: with SMTP id ch12mr10971335pjb.176.1615503469553;
        Thu, 11 Mar 2021 14:57:49 -0800 (PST)
Received: from smtpclient.apple ([192.30.189.3])
        by smtp.gmail.com with ESMTPSA id 23sm3523508pge.0.2021.03.11.14.57.48
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Mar 2021 14:57:48 -0800 (PST)
From:   Brian Bunker <brian@purestorage.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.80.0.2.41\))
Subject: ALUA state unavailable and device discovery
Message-Id: <2DB5910B-736D-4191-8645-9673EA2B2699@purestorage.com>
Date:   Thu, 11 Mar 2021 14:57:47 -0800
To:     linux-scsi@vger.kernel.org
X-Mailer: Apple Mail (2.3654.80.0.2.41)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello All,

There seems to be an incompatibility in the Linux SCSI code between SCSI =
disk
discovery and the ALUA state unavailable. =46rom the SPC specification =
if you use
ALUA state unavailable you also set the peripheral qualifier for that =
path.

While in the unavailable primary target port asymmetric access state, =
the device
server shall support those of the following commands that it supports =
while in the=20
active/optimized state:
a) INQUIRY (the peripheral qualifier (see 6.6.2) shall be set to 001b)
...

The problem with that is that it limits when the host can discover disks =
or reboot.
In order for an sd device to be created, the PQ must be 0. This seems to =
come from the
scsi_bus_match function in scsi_sysfs.c.

return (sdp->inq_periph_qual =3D=3D SCSI_INQ_PQ_CON)? 1: 0;

So it only will return 1, if the PQ is 0.=20

As a result if a SCSI device is discovered while the ALUA state for that =
path is
in the unavailable state, an sd device will not be created. An sg device =
will but
not an sd one. As a result multipath will not create a dm device. Or, if =
an existing
dm device exists, a path for this newly discovered device will not be =
created. This
means when the device moves out of unavailable to an active ALUA state, =
or even
standby, there is no device, so no path to change the state of in =
multipath's dm
device.

For this reason the ALUA state standby looks attractive since it doesn't =
have
the PQ requirement. But looking at the commands required for support in =
the standby
ALUA state, there are some that are difficult to support in the =
disconnected peer
state, most notably persistent reservations, where not having access to =
a peer
can result in an inability to keep a consistent state when and if the =
path again
becomes available. The unavailable ALUA state has the right command list =
to support
in being disconnected from the source of truth, but the PQ requirement =
is the
trade off.

Is the PQ check here because of INQUIRY requests sent to non-existent =
LUNs leading
to sd devices being created?

In response to an INQUIRY command received by an incorrect logical unit, =
the SCSI
target device shall return the INQUIRY data with the peripheral =
qualifier set to the
value defined in 6.6.2.

As a test, I changed this line to this to allow sd to create devices =
where the
peripheral qualifier is not 011b as opposed to needing to be 000b.

return (sdp->inq_periph_qual !=3D SCSI_INQ_PQ_NOT_CAP)? 1: 0;

This does allow an sd device to be created and multipath to create a =
path for it
in a dm device.

3624a93706a10c27f300a496100011010 dm-2 PURE    ,FlashArray     =20
size=3D2.0T features=3D'0' hwhandler=3D'1 alua' wp=3Drw
`-+- policy=3D'service-time 0' prio=3D0 status=3Denabled
  `- 7:0:0:1 sdb 8:16 failed undef running

It is in the failed state, but when it comes back to an online ALUA =
state, the path
will return to active. There is an inconsistency since if the device was =
in any other
state than unavailable when it was discovered and then transitions to =
the unavailable
state, the device is already created so it can be transitioned in =
multipath and all
is good.

Is there a way to handle both unintended consequence and the ALUA =
unavailable state?

Thanks,
Brian

Brian Bunker
SW Eng
brian@purestorage.com



