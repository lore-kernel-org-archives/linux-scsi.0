Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 522C6C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 18:22:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A2EB61994
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 18:22:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbhCVSVt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 14:21:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230206AbhCVSVe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Mar 2021 14:21:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 41C926191C
        for <linux-scsi@vger.kernel.org>; Mon, 22 Mar 2021 18:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616437294;
        bh=ZE9bAC+W2ZoDCYmrrzue4LFw3zu8IMXBWQZu9RzPZTw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=QNWSTalGZSkaIhlON1g3TEZqMmTy0UIz3rHsdPy43Av8d2IZqw2zrI108X2ie1S59
         nVM/XUNockmSHu2eCgLysTTO61BfbvHjBrpZSNxN/vWMmRzDS6/PQYWQb7Cpz3z33y
         kwA7vb/rJFoU4e37vIXQ+Rh8Z2nAEvAYNOfFeIy2btZtxsh98DjN5fpYjncSbjn8hN
         7BGLMtC6sES0lfyCV0Im+UqLcyrmvSYFCwo2QWng4hvAKwtX9ErOLVtWe1E/Zewg7u
         qsMiLRdAkrQfnIfqf4cBAg3ir5HYegnqEFIs1AkktkY7/mx3wsxxonG6GK/nsBQDBw
         ++alYnfoKrlCA==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 212337] scsi_debug: race at module load and module unload
Date:   Mon, 22 Mar 2021 18:21:33 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mcgrof@kernel.org
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: WILL_NOT_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-212337-11613-UOtFnr8hd3@https.bugzilla.kernel.org/>
In-Reply-To: <bug-212337-11613@https.bugzilla.kernel.org/>
References: <bug-212337-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D212337

--- Comment #10 from Luis Chamberlain (mcgrof@kernel.org) ---
(In reply to Luis Chamberlain from comment #9)
> (In reply to d gilbert from comment #8)
>=20
> > >> The scsi_debug module option that is already in place is:
> > >>     tur_ms_to_ready: TEST UNIT READY millisecs before initial good
> status
> > >> (def=3D0)
> >=20
> > You asked how it works, try:
> >      modprobe scsi_debug tur_ms_to_ready=3D20000
> >=20
>=20
> That does not resolve the rmmod race against insmod:
>=20
> scsi host2: scsi_debug: version 0190 [20200710]
> [   42.213400]   dev_size_mb=3D8, opts=3D0x0, submit_queues=3D1, statisti=
cs=3D0
> [   42.217527] scsi 2:0:0:0: Direct-Access     Linux    scsi_debug=20=20=
=20=20=20=20
> 0190 PQ: 0 ANSI: 7
> [   42.223346] scsi 2:0:0:0: Attached scsi generic sg0 type 0
> [   42.282195] scsi host2: scsi_debug: version 0190 [20200710]
> [   42.282195]   dev_size_mb=3D8, opts=3D0x0, submit_queues=3D1, statisti=
cs=3D0
> [   42.288169] scsi 2:0:0:0: Direct-Access     Linux    scsi_debug=20=20=
=20=20=20=20
> 0190 PQ: 0 ANSI: 7
> [   42.292122] sd 2:0:0:0: Attached scsi generic sg0 type 0
> [   42.292244] sd 2:0:0:0: Power-on or device reset occurred
> [   42.302288] sd 2:0:0:0: [sda] Spinning up disk...
>=20
> Then we wait...
>=20
> [   44.308213] ...................ready
> [   62.748919] sd 2:0:0:0: [sda] 16384 512-byte logical blocks: (8.39
> MB/8.00 MiB)
> [   62.754265] sd 2:0:0:0: [sda] Write Protect is off
> [   62.763253] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enable=
d,
> supports DPO and FUA
> [   62.776965] sd 2:0:0:0: [sda] Optimal transfer size 524288 bytes
> [   62.883817] sd 2:0:0:0: [sda] Attached SCSI disk
>=20
> And then rmmod still fails.

Using udevadm settle (as used in blktests) after modprobe and before rmmod=
=20
fixes the issue. I tested modprobe udevadm settle; rmmod scsi_debug loop 50=
00
so far without issue.

I however note that we send uevents via kobject_uevent_net_broadcast() and
that's a no-op for kernels without CONFIG_NET, and so this is not a true gl=
obal
solution either. Udev events are sent via netlink to userspace, and udev in
userspace is in charge of handling the events. The command udevadm settle j=
ust
checks if /run/udev/queue is 0. There is currently nothing we can do on
scsi_debug to do something similar on init.

#!/bin/bash

LOOP=3D1

while true; do
        modprobe scsi_debug
        if [[ $? -ne 0 ]]; then
                echo "scsi_debug modprobe failed at count $LOOP"
                exit 1
        fi
        udevadm settle
        rmmod scsi_debug
        if [[ $? -ne 0 ]]; then
                echo "scsi_debug rmmod failed at count $LOOP"
                exit 1
        else
                echo "Loop $LOOP: OK!"
        fi
        let LOOP=3D$LOOP+1
done

I should note that this works even if one either delays async probe on sd.c,
and/or also augments the delay and delays scheduling the probe as follows:

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 9179825ff646..b9ae63c17cb6 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -1071,6 +1071,7 @@ static int __driver_attach(struct device *dev, void
*data)
        } /* ret > 0 means positive match */

        if (driver_allows_async_probing(drv)) {
+               ssleep(5);
                /*
                 * Instead of probing the device synchronously we will
                 * probe it asynchronously to allow for more parallelism.
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ed0b1bb99f08..79fc834073af 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3371,6 +3371,7 @@ static int sd_probe(struct device *dev)
        int index;
        int error;

+       ssleep(3);
        scsi_autopm_get_device(sdp);
        error =3D -ENODEV;
        if (sdp->type !=3D TYPE_DISK &&


Using wait_for_device_probe() on scsi_debug's driver init doesn't fix this
either. And so I think we're stuck with userspace having to call udevadm se=
ttle
after modprobe and before rmmod as well.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
