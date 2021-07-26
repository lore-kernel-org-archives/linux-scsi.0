Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CEB0C4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 11:01:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 546D560E09
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 11:01:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232862AbhGZKVC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jul 2021 06:21:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:43234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231976AbhGZKVC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Jul 2021 06:21:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 085DF60F58
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jul 2021 11:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627297291;
        bh=SDa7dvpzzIJ9X7cfQP4g7tTjbd9M4mR1LurG2gYpSSc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=MyNwGymzo1Vfp1kF89qWE7nJuhvqSEUu+YxpHZg59Q8PVqhbS95Qf6XP3d+vb8oBP
         OiEmFQzztulTjjBIwV4tRasFUSx+DcslUHfNvqE8J3u56DJLQb2oIANJrSvh7iuw2Q
         uyiM/DjEE/f56UmIHmTsRK0U/S8Rl3R61b5VVToxrwVdH9hpcMV4tQ6LKtDRqIn1Jz
         GLRw+kQCw5Xk0E44JIH8aLOiOv6KYHNsTwB42M5x58G8f4YyfMsYmyRviEB0NgK0Xz
         uvk6VzombzXs0Ymk2kN62RALsid8EcXED4hlbu2/KsRiMm8c/1PToWgiHBq+AXg7Vp
         1WOjjssBVMxJg==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 213759] CD tray ejected on hibernate resume
Date:   Mon, 26 Jul 2021 11:01:30 +0000
X-Bugzilla-Reason: CC
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: limanyi@uniontech.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-213759-11613-4mUxXwP1fp@https.bugzilla.kernel.org/>
In-Reply-To: <bug-213759-11613@https.bugzilla.kernel.org/>
References: <bug-213759-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D213759

--- Comment #7 from limanyi@uniontech.com (limanyi@uniontech.com) ---
1. modify the file /lib/udev/rules.d/60-cdrom_id.rules:
-ENV{DISK_EJECT_REQUEST}=3D=3D"?*", RUN+=3D"cdrom_id --eject-media $devnode=
",
GOTO=3D"cdrom_end"
+#ENV{DISK_EJECT_REQUEST}=3D=3D"?*", RUN+=3D"cdrom_id --eject-media $devnod=
e",
GOTO=3D"cdrom_end"

2. systemctl restart udev.service

I find that CD tray isn`t ejected on resume. I think that the kernel should=
 not
send 'DISK_EVENT_EJECT_REQUEST' when media event code is 3.


This patch solves this problem=EF=BC=9A
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 94c254e9012e..a6d3ac0a6cbc 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -221,7 +221,7 @@ static unsigned int sr_get_events(struct scsi_device *s=
dev)
        else if (med->media_event_code =3D=3D 2)
                return DISK_EVENT_MEDIA_CHANGE;
        else if (med->media_event_code =3D=3D 3)
-               return DISK_EVENT_EJECT_REQUEST;
+               return DISK_EVENT_MEDIA_CHANGE;
        return 0;
 }

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are on the CC list for the bug.
You are watching the assignee of the bug.=
