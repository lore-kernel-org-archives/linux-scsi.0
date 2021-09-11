Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7636C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Sep 2021 18:56:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C796D6103D
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Sep 2021 18:56:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233539AbhIKS5k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Sep 2021 14:57:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233408AbhIKS5i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 11 Sep 2021 14:57:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D192B6103D
        for <linux-scsi@vger.kernel.org>; Sat, 11 Sep 2021 18:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631386585;
        bh=t+IQlmXpMAKQc83sRlQVUlT5wq8NFmMY+8Va6dh0XeI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=iWo1GjiaicQ0QyIU4O3rL2C6YfW1vuZO7SzbRCWrTcSiHyZKfQnO4GwRIZbR4utpU
         nYoc51mhJoVArsiEQOmdPRzvUnkVwdTDfvjRytq2UyZeCt6p01uFlbD/7Wl8vtOk3U
         ZfqmIX84KSgy/7enrVLYMBHQdh71yNVNOIun4JRoSRJdffvTZPAxAYs3oONnr5vgAj
         R7QXec87/Ank0mNVml7xgDp+fQ9Aix9tNWpxIavIF9s6aM9vGwPWd4GCshDMTXFmI/
         6M5vcv4NOn3GbtjuZO7jbRYlWDU37crqfmywxdMnLe4ca2LM3kIIJvJmHiXHOfQG0R
         QdL+7R9UBE3FQ==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214311] megaraid_sas - no disks detected
Date:   Sat, 11 Sep 2021 18:56:25 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: carnil@debian.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-214311-11613-UUZQP5rWtl@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214311-11613@https.bugzilla.kernel.org/>
References: <bug-214311-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214311

--- Comment #2 from Salvatore Bonaccorso (carnil@debian.org) ---
Hi,

On Sat, Sep 04, 2021 at 11:23:59AM +0000, bugzilla-daemon@bugzilla.kernel.o=
rg
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D214311
>=20
>             Bug ID: 214311
>            Summary: megaraid_sas - no disks detected
>            Product: IO/Storage
>            Version: 2.5
>     Kernel Version: 5.10.0
>           Hardware: Intel
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: blocking
>           Priority: P1
>          Component: SCSI
>           Assignee: linux-scsi@vger.kernel.org
>           Reporter: jarek@poczta.srv.pl
>         Regression: No
>=20
> Dell R340 with PERC H330 - disks not detected.
>=20
> lspci:
>=20
> 02:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS-3 3008
> [Fury] (rev 02)
>=20
> dmesg:
>=20
> megaraid_sas 0000:02:00.0: Performance mode :Latency
> megaraid_sas 0000:02:00.0: FW supports sync cache: No
> megaraid_sas 0000:02:00.0: megasas_disable_intr_fusion is called
> outband_intr_mask:0x40000009
> megaraid_sas 0000:02:00.0: Ignore DCMD timeout: megasas_get_ctrl_info 5274
> megaraid_sas 0000:02:00.0: Could not get controller info. Fail from
> megasas_init_adapter_fusion 1865
> megaraid_sas 0000:02:00.0: Failed from megasas_init_fw 6406
>=20
> This machine works OK with kernel 4.19.0. Debian 11, Clonezilla 2.7.3-19 =
does
> not detect disks.

This sounds very similar to one bug report which was reported
downstream in Debian at https://bugs.debian.org/992304

Followup to the bugzilla bug 214311
(https://bugzilla.kernel.org/show_bug.cgi?id=3D214311) suggests that it
works when booting with BIOS, not with UEFI boot.

Regards,
Salvatore

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
