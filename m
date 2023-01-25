Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2336EC38142
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Jan 2023 01:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234875AbjAYBCq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 20:02:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234311AbjAYBCm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 20:02:42 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404B351C65
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2023 17:02:29 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id b10so16944977pjo.1
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2023 17:02:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022;
        h=message-id:in-reply-to:to:references:date:subject:mime-version
         :content-transfer-encoding:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7Z6cu3V3IyRdwM/Tm21lpcemt8ezXFk3PFoqpdkkT7Y=;
        b=bj6iVHN7GuDi7RD2WS1vGF5//0QQ7mXhw6I5zMv0bQypEwHwd6DEQwtG88gytCG7OU
         CfdbGtCOGF5h3E3QbkoFloE/SGXQi8l9aBA8+zSFKehp98Of7ivR59d3scfxCUPvGvI1
         wrla5ZyNnSG6T4ZOqgqg7oDlPvJzmdZO87QQNUFQlIr+KuBPmr1L8fLJdtIKfyFGr3eA
         Eo9e1Qj35ZS8QU7QsQhdAMyNU+M0bCemAHjt4XO5qnHmCgI1MIzGSEFDdG4EKbI9k3Ua
         c/VFwD4yPCw4bMH1lBbDEA9FCz0jY8+xvN9pVTcfraQPB9Wjc1ulfw0LGMWCKfzDZ9Xl
         QTjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:in-reply-to:to:references:date:subject:mime-version
         :content-transfer-encoding:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Z6cu3V3IyRdwM/Tm21lpcemt8ezXFk3PFoqpdkkT7Y=;
        b=7WJvRARNdyIzNy72ZvM6ODxVwH6mV8nXpyAN16SwScDMkblg/FSP2LIefPs3JC3enw
         cV7F9FWh/E2aBobKpLoZeDPYcW9rRqtLjLoOEHjrxeJDSietvi9ayV4/pfstE/aTknkR
         05FEUd1KUruwGcagxhVOzPPhpKAqWel7T4zKL44vV5FMWUNHRegptrnaG8JXIe0osXUT
         LeHkRw8aGgwjqUJI9FmXKvR+TDZxeduRUYCI7ehvNpas7I1LLxa2fDbGg7+lg0tcSzgZ
         VfhQscMeby7SBqFx1rLYB+3zbc+vMjpFrUm0S+B7hzcJdItUGvdJRUxcARjmcOg57O6d
         yr3w==
X-Gm-Message-State: AFqh2kpSOwy9pUYq5URYDyGuwDWDQgl0Qm9my4zjoreWHnYwtXZ2D1fb
        6DgWiFYvJtGvW4qAKt35hG2ZUE1RQnyI6Z19
X-Google-Smtp-Source: AMrXdXvYKjh6G8At5ZjaHo23alSUdmvM+aD6xmmLnQ+6EBMA5EvSUjp8cKn1VHXwwW83MSBtfsxYUg==
X-Received: by 2002:a17:90a:19d5:b0:223:ed96:e3ca with SMTP id 21-20020a17090a19d500b00223ed96e3camr31985036pjj.28.1674608548481;
        Tue, 24 Jan 2023 17:02:28 -0800 (PST)
Received: from smtpclient.apple ([136.226.79.5])
        by smtp.gmail.com with ESMTPSA id g20-20020a17090a579400b00218a7808ec9sm178988pji.8.2023.01.24.17.02.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Jan 2023 17:02:27 -0800 (PST)
From:   Brian Bunker <brian@purestorage.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.400.51.1.1\))
Subject: Re: The PQ=1 saga
Date:   Tue, 24 Jan 2023 17:02:16 -0800
References: <yq1lelrleqr.fsf@ca-mkp.ca.oracle.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
In-Reply-To: <yq1lelrleqr.fsf@ca-mkp.ca.oracle.com>
Message-Id: <CB441742-2C22-41A4-95A3-10D251C31F5B@purestorage.com>
X-Mailer: Apple Mail (2.3731.400.51.1.1)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For a completely separate reason I would like to see PQ=3D1 expose the =
sd device.

ALUA state transitions from unavailable back to another state does not
work depending on what state devices are in when they are initially =
discovered.
In the ALUA unavailable state the peripheral qualifier of the device =
should also
be set to 001b.

If the device is not in the unavailable state when it is initially =
discovered
(PQ not 001b), it can move to and from the unavailable state with the =
expected
result like this:

/dev/sg1  7 0 1 1  0  /dev/sdb  PURE      FlashArray        8888

root@init106-1 class]# sg_inq /dev/sdb
standard INQUIRY: [qualifier indicates no connected LU]
PQual=3D1  Device_type=3D0  RMB=3D0  version=3D0x06  [SPC-4]
[AERC=3D0]  [TrmTsk=3D0]  NormACA=3D1  HiSUP=3D1  Resp_data_format=3D2
SCCS=3D1  ACC=3D0  TPGS=3D1  3PC=3D1  Protect=3D0  [BQue=3D0]
EncServ=3D0  MultiP=3D1 (VS=3D0)  [MChngr=3D0]  [ACKREQQ=3D0]  Addr16=3D0
RelAdr=3D0]  WBus16=3D0  Sync=3D0  Linked=3D0  [TranDis=3D0]  CmdQue=3D1
[SPI: Clocking=3D0x0  QAS=3D0  IUS=3D0]
length=3D96 (0x60)   Peripheral device type: disk
Vendor identification: PURE
Product identification: FlashArray
Product revision level: 8888
Unit serial number: 1D6DB146171D4E32000113E6

If, however, the device is already in this state when it is initially
discovered, no sd device is created like this:

/dev/sg2  7 0 1 1  0  PURE      FlashArray        8888

Since no sd device is ever created, when the ALUA state changes and the
peripheral qualifier is set back to 0, manual intervention is required.
The devices peripheral qualifier is correct after another rescan,
but no sd device is created.

[root@init106-1 ~]# sg_inq /dev/sg2
standard INQUIRY:
PQual=3D0  Device_type=3D0  RMB=3D0  version=3D0x06  [SPC-4]
[AERC=3D0]  [TrmTsk=3D0]  NormACA=3D1  HiSUP=3D1  Resp_data_format=3D2
SCCS=3D1  ACC=3D0  TPGS=3D1  3PC=3D1  Protect=3D0  [BQue=3D0]
EncServ=3D0  MultiP=3D1 (VS=3D0)  [MChngr=3D0]  [ACKREQQ=3D0]  Addr16=3D0
[RelAdr=3D0]  WBus16=3D0  Sync=3D0  Linked=3D0  [TranDis=3D0]  CmdQue=3D1
[SPI: Clocking=3D0x0  QAS=3D0  IUS=3D0]
length=3D96 (0x60)   Peripheral device type: disk
Vendor identification: PURE
Product identification: FlashArray
Product revision level: 8888
Unit serial number: 1D6DB146171D4E32000113E6

The existing device must first be removed for another initial
rediscovery to correct the issue.

This hole makes the unavailable ALUA state unattractive. Allowing
the peripheral qualifier set to 001b to still create an sd device
on discovery corrects this hole.

Thanks,
Brian

On Tue, Jan 24, 2023 at 4:02 PM Martin K. Petersen =
<martin.petersen@oracle.com> wrote:
>=20
>=20
> I would like to revert commit 948e922fc446 ("scsi: core: map PQ=3D1,
> PDT=3Dother values to SCSI_SCAN_TARGET_PRESENT").
>=20
> I have been spending quite a bit of time digging through old SCSI and
> controller specs. As far as I can tell the original Linux behavior was
> correct. Recent SPC specs are very abstract in this department =
resulting
> in unfortunate ambiguity. But originally PQ=3D1 meant "LUN supports =
this
> peripheral device type but no physical device is currently connected".
>=20
> Based on this original definition, PQ=3D1 has been widely used =
throughout
> the industry as a means to avoid associating an ULD driver with a
> device. The LUN is accessible (primary commands, etc.) but no media is
> present (no physical device connected).
>=20
> Our original algorithm, which I would like to reinstate, is =
essentially
> the following (in slightly unrolled form):
>=20
>        if (PQ =3D=3D 3)
>            /* Don't expose device */
>        else if ((PQ =3D=3D 1 || sdev->pdt_1f_for_no_lun) && PDT =3D=3D =
0x1f)
>            /* Don't expose device */
>        else if (PQ =3D=3D 1) {
>            /* Expose device, don't bind ULD */
>        } else /* PQ =3D=3D 0 */
>            /* Expose device, bind ULD if PDT is supported */
>=20
> I would like to understand why -- in the case of the IBM 2145 --
> exposing the sg device caused problems. Li: Can you shed some light on
> the problems caused by 2145 LUNs reporting PQ=3D1?
>=20
> Thanks!
>=20
> --
> Martin K. Petersen      Oracle Linux Engineering
