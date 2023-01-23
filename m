Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7A3FC25B50
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Jan 2023 23:27:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbjAWX1J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Jan 2023 18:27:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjAWX1I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2023 18:27:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA1D2728
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2023 15:27:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BECCB60FC0
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2023 23:27:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2EDC5C433D2
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2023 23:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674516426;
        bh=EMM3qH5wpyN60PhRn4w4KuniPnojOTiEj2cLLNJrXho=;
        h=From:To:Subject:Date:From;
        b=Uo/8sZwlDZbI58S+27yJ/K41kbfdww5xSmUWQltDEZ6YpsubbVsKsLYDvHF9Ppv8a
         ZbFaMLP71BXn0qA0h3crS67DnYe4YSP6AaPM7UB5xFJmxVqvnH1AM1Qz791Q7K77Yc
         ETNUWHpqCx6EthQonwwDC2TTQEDbrhBUJFAbgoTXNz/rxq4WLray83OTkF65ZrQB0G
         KtZaJE2sX6VY6ctyEd4UFJIzx5FUMSQfgJixwtZj1beSpB9qRSNQhpoExUy6KGLIn+
         hcNgm5m/UhBvnQlPGhwgAv1s6/1mpcuvXnIYj2jzP/gv39UKrZwg02o9yhyHynak9w
         NT6GntorgVE9g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 19A7BC43142; Mon, 23 Jan 2023 23:27:06 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 216964] New: LSI SAS1068 logical volume caching mode not
 detected (with patch)
Date:   Mon, 23 Jan 2023 23:27:05 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: michal.ruza@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-216964-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216964

            Bug ID: 216964
           Summary: LSI SAS1068 logical volume caching mode not detected
                    (with patch)
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 5.15.58
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: michal.ruza@gmail.com
        Regression: No

Created attachment 303641
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D303641&action=3Dedit
Patch to use fixed size buffer for the buggy MODE SENSE command

Hardware:
   HBA card: Broadcom / LSI SAS1068 PCI-X Fusion-MPT SAS
PCI VID:PID: 1000:0054

Problem: Caching mode of logical volumes managed by the controller in quest=
ion
is not detected.

Relevant kernel messages:
[   19.642388] scsi 8:1:0:0: Direct-Access     LSILOGIC Logical Volume   30=
00
PQ: 0 ANSI: 2
[   19.649179] sd 8:1:0:0: Attached scsi generic sg6 type 0
[   19.649390] sd 8:1:0:0: [sdd] 583983104 512-byte logical blocks: (299 GB=
/278
GiB)
[   19.649625] sd 8:1:0:0: [sdd] Write Protect is off
[   19.649629] sd 8:1:0:0: [sdd] Mode Sense: 03 00 00 08
[   19.649837] sd 8:1:0:0: [sdd] No Caching mode page found
[   19.649853] sd 8:1:0:0: [sdd] Assuming drive cache: write through
[   19.666881]  sdd: sdd1 sdd2 sdd3
[   19.667776] sd 8:1:0:0: [sdd] Attached SCSI disk

Cause of the problem:
The SCSI MODE SENSE command is broken for the logical volumes managed by the
controller in question in that it does not set the length field in the retu=
rned
response to the length of the entire response but rather only to the length=
 of
the portion of the response actually written to the provided buffer (which =
is
obviously limited by the length of the provided buffer). This breaks the lo=
gic
in sd_read_cache_type [1] which first tries to determine the size of the en=
tire
response by executing the MODE SENSE command with a small buffer and then u=
ses
the length field from the partial response to size the buffer for the entire
response appropriately. This does not work for the logical volumes managed =
by
the controller in question as for them the reported response length is never
greater than the length of the provided buffer (in fact it is always 3 as
evidenced by the first byte in the "Mode Sense:" log message - which is the
length of the small buffer provided to the MODE SENSE command less the leng=
th
byte itself), so the response is never received in its entirety, which lead=
s to
the caching mode detection failure.

The problem can be demonstrated by the sg_modes command:
- invoked on the misbehaving logical volume:
# sg_modes -6 -p 8 -m 4 -d -H /dev/sdd
    LSILOGIC  Logical Volume    3000   peripheral_type: disk [0x0]
 00     03 00 00 00
- invoked on a correctly behaving disk:
# sg_modes -6 -p 8 -m 4 -d -H /dev/sda
    ATA       WDC WD4003FFBX-6  0A83   peripheral_type: disk [0x0]
 00     17 00 00 00
Notice the difference in the length field - the first byte of the response.

Nevertheless the misbehaving logical volume _does_ report the caching mode
correctly when the relevant MODE SENSE command is executed with large enough
buffer. Again this can be demonstrated by the sg_modes command:
# sg_modes -6 -p 8 -m 192 -d -H /dev/sdd
    LSILOGIC  Logical Volume    3000   peripheral_type: disk [0x0]
 00     17 00 00 00 08 12 04 00  ff ff 00 00 ff 00 ff ff
 10     00 0f 00 00 00 00 00 00

Possible fix:
It turns out there is already a flag in struct scsi_device which forces the
relevant MODE SENSE command to be executed with a 192 bytes long buffer (wh=
ich
is long enough to hold the entire response): use_192_bytes_for_3f [2].
When this flag is set for the misbehaving disk/logical volume (together with
the skip_ms_page_8 flag), the caching mode detection works correctly. This =
has
been verified by applying the attached patch.
With the patch applied, the relevant kernel messages look like this:
[   19.263001] scsi 8:1:0:0: Direct-Access     LSILOGIC Logical Volume   30=
00
PQ: 0 ANSI: 2
[   19.263190] sd 8:1:0:0: Attached scsi generic sg6 type 0
[   19.263413] sd 8:1:0:0: [sdd] 583983104 512-byte logical blocks: (299 GB=
/278
GiB)
[   19.263690] sd 8:1:0:0: [sdd] Write Protect is off
[   19.263694] sd 8:1:0:0: [sdd] Mode Sense: 67 00 00 08
[   19.263970] sd 8:1:0:0: [sdd] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[   19.279922]  sdd: sdd1 sdd2 sdd3
[   19.280904] sd 8:1:0:0: [sdd] Attached SCSI disk


[1]
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/drive=
rs/scsi/sd.c?h=3Dv5.15.58#n2687
    https://elixir.bootlin.com/linux/v5.15.58/source/drivers/scsi/sd.c#L2687

[2]
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/inclu=
de/scsi/scsi_device.h?h=3Dv5.15.58#n184
=20=20=20
https://elixir.bootlin.com/linux/v5.15.58/source/include/scsi/scsi_device.h=
#L184

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
