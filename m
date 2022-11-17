Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CB3DC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Nov 2022 04:17:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239234AbiKQER5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Nov 2022 23:17:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239239AbiKQERV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Nov 2022 23:17:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2155EFA4
        for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2022 20:17:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77FF8B81F7E
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 04:17:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 339B1C433D6
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 04:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668658636;
        bh=SwtfLTdgh1xsZ/oXDn/srEedqgioOY7S9upEbwQdfw4=;
        h=From:To:Subject:Date:From;
        b=Kx5AaCRE/E+Rcs96V1lFV5j0ezreo7Fsbl0PaNZvcJtj6N6uLnruu0Yvxogb92KPj
         bqIFF26hNajWzZzZLBpkgMuZr7vYMIdDXsBfgOj27FZmGZiNSONNOnAZfsd/6Fy6Mg
         qHTeFqa+WsYNYqTSkKlrPGkV0QM2t4wx8cnG6mIvK3oDn/tdendL6TQW4LbD87ZOGg
         mleDdmAdJ54fuiEMtuDYmkCRaypc3NmGwR98OlQnJ0DhCIlClpUql8bIFh+w7KLzDH
         sXFqVuF4G/6mH5mTvR46xmyCXEUe6YfhoU+oY1wkfoz5q6jdIy2XD7WH/vxmE/LJzE
         z5x9UR1dk5Beg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 1F23DC433E6; Thu, 17 Nov 2022 04:17:16 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 216696] New: Linux unusable upon plugging encrypted SanDisk
 Extreme 55AE USB 3.0 SSD, causes xHCI controller crash and drops USB
 keyboard/mouse
Date:   Thu, 17 Nov 2022 04:17:15 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: kylek389@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-216696-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216696

            Bug ID: 216696
           Summary: Linux unusable upon plugging encrypted SanDisk Extreme
                    55AE USB 3.0 SSD, causes xHCI controller crash and
                    drops USB keyboard/mouse
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 6.0
          Hardware: AMD
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: kylek389@gmail.com
        Regression: No

Created attachment 303189
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D303189&action=3Dedit
dmesg

Plugging in an encrypted 2TB SanDisk Extreme 55AE USB 3.0 Type-C SSD causes
xHCI controller crash and dropping USB keyboard/mouse and any other USB dev=
ice
connected to the computer. dmesg gets spammed with following errors:

[    3.359704] sd 1:0:0:0: [sda] Sense Key : Data Protect [current]=20
[    3.359706] sd 1:0:0:0: [sda] Add. Sense: Logical unit access not author=
ized
[    3.378662] sd 1:0:0:0: [sda] tag#2 FAILED Result: hostbyte=3DDID_OK
driverbyte=3DDRIVER_OK cmd_age=3D0s
[    3.378664] sd 1:0:0:0: [sda] tag#2 Sense Key : Data Protect [current]=20
[    3.378666] sd 1:0:0:0: [sda] tag#2 Add. Sense: Logical unit access not
authorized
[    3.378667] sd 1:0:0:0: [sda] tag#2 CDB: Read(10) 28 00 00 00 00 00 00 0=
0 08
00
[    3.378667] critical target error, dev sda, sector 0 op 0x0:(READ) flags=
 0x0
phys_seg 8 prio class 0

and finally:
[    8.371890] xhci_hcd 0000:0b:00.3: AMD-Vi: Event logged [IO_PAGE_FAULT
domain=3D0x0018 address=3D0xffcf0000 flags=3D0x0020]
[   13.669065] xhci_hcd 0000:0b:00.3: xHCI host not responding to stop endp=
oint
command.
[   13.669070] xhci_hcd 0000:0b:00.3: USBSTS: 0x00000005 HCHalted HSE
[   13.669074] xhci_hcd 0000:0b:00.3: xHCI host controller not responding,
assume dead
[   13.669086] xhci_hcd 0000:0b:00.3: HC died; cleaning up
[   13.669116] usb 4-3: cmd cmplt err -108
[   13.669119] usb 4-3: cmd cmplt err -108
[   13.669124] usb 3-2: USB disconnect, device number 2
[   13.669184] usb 4-3: USB disconnect, device number 2

Having the said drive plugged in when booting the Linux or booting a live u=
sb
distro such as Fedora 37 causes the xHCI controller to crash and drops
important USB devices such as keyboard & mouse strangling the user from bei=
ng
able to type or login to tty or DE.

SanDisk Extreme features a drive encryption, it works fine out of the box on
Windows or MacOS, it comes with its own read-only UDF partition where
unlock.exe resides that can be launched to unlock (decrypt) the drive revea=
ling
a ~2TB exFAT partition.

Please see attached dmesg log file. If this is not the right subsystem to f=
ile
the bug let me know. I really would like to get my system booting Linux aga=
in
since I have the SanDisk Extreme plugged in 24/7. Thanks

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
