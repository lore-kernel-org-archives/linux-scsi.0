Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 497E2C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 15:15:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DC8C603E5
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Oct 2021 15:15:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbhJNPR2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Oct 2021 11:17:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231915AbhJNPR1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Oct 2021 11:17:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EA7F7603E5
        for <linux-scsi@vger.kernel.org>; Thu, 14 Oct 2021 15:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634224523;
        bh=jP3T8Nq3Uu3eD/37FfqZzMTT92Nd4CugNwg/rV+w+4A=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=pPWT+TzxSIDGFS2q3N5SRRYaVrjPvQCS//5WEfArZnl88Ax/eUru8H+RxDjYEouGK
         bzoJI2ywqw8CFBLEcl4Mjtz7KKULI/BW4sA1ki9/Ee6dAIMmKxqL+bgmbI2a7U1Nk3
         PJXDGuBqhUq5TnLq2a4i88ooaMfagfSFAGuCafDoCzxfdud9/ZaYZQCiFdBH7zL6TI
         2fz2jDu3Y/Mv8U8dXYWU38Rf2IrriHat7PieXGsQ9fixOFeiq5zAM/fWDCYv9dsyI4
         6MxRC7CQfb/uJqRn66E1huKkbUXnK7AbdftfZUmxV6srpDHt45a/lsmrcSIpUAK4Tv
         H/+fRgofTsOaQ==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214711] Information leak from kernel to user space in
 scsi_ioctl.c
Date:   Thu, 14 Oct 2021 15:15:22 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bao00065@umn.edu
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-214711-11613-0RyNo8U2qx@https.bugzilla.kernel.org/>
In-Reply-To: <bug-214711-11613@https.bugzilla.kernel.org/>
References: <bug-214711-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214711

--- Comment #2 from Andrew Bao (bao00065@umn.edu) ---
Hi Bart,
Yes, It is an information leak.

"my understanding of the C standard is that a compiler is required to
zero-initialize members that have not been mentioned in an initializer list.
From the ANSI C 202x d"raft: "The initialization shall occur in initializer
list order, each initializer provided for a particular subobject overriding=
 any
previously listed initializer for the same subobject; all subobjects that a=
re
not
initialized explicitly shall be initialized implicitly the same as objects =
that
have static storage duration."

I am wondering in what condition the compiler will zero-initialize the fiel=
d in
a struct. And what is the initializer in the context? Let say we have a str=
uct
foo:

struct foo{
       int  a;
       int b;
       int c;
};
method 1:

struct foo f;=20
f.a =3D 1;
f.b =3D 2;

In method 1, will the compiler zero-initialize the field f.c?

method 2:
struct foo f =3D {
                        .a      =3D   1
                        .b      =3D   2

                };
In method 2, will the compiler zero-initialize the field f.c?


By the way,
struct compat_cdrom_generic_command {
        unsigned char   cmd[CDROM_PACKET_SIZE];
        compat_caddr_t  buffer;
        compat_uint_t   buflen;
        compat_int_t    stat;
        compat_caddr_t  sense;
        unsigned char   data_direction;
        unsigned char   pad[3];
        compat_int_t    quiet;
        compat_int_t    timeout;
        compat_caddr_t  unused;
};
If this struct does not declare unsigned char pad[3] in order to fill with
padding, will the compiler zero-initialize 3 bytes holes for this struct?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
