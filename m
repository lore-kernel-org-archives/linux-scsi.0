Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4F8FC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 18:43:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74E4964FE0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 18:43:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhCKSmt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 13:42:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:35974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230137AbhCKSmo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Mar 2021 13:42:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 5C14C64DEE
        for <linux-scsi@vger.kernel.org>; Thu, 11 Mar 2021 18:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615488164;
        bh=J/326Z5F+TLnIDvzpLWG1y3I4FM1LoHdUndQeowGCwA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=bFI8DCNa2Qama8SspGhS3fMwZtFNUoCbJqqKN/DP9MJmES8b3I/TKHIHqOvLlQCCw
         E9kAUXOm3AsZtA/5j27vFmPCmuM/C2YfWNG8lKK2N0p34l5uRUuFCS3hAuVBEq9WHx
         e4mV3D5LPO5yB2iAYhZJ6kqjyM3apea7YXpEYLvf+i0HS5PDeNmHZcFU+Hj0wpTyBp
         4ZzD1qE1A3LxyCpJrRkdlzY0IhA7ycNHwEffvfRYsB2jC3oufBYFDU+0fBW4BwL9cM
         CE5aLUtKfL0kN0e3o/Cgq5Rnuw8JqSXnObECIRYsJzK9/bmNIylt4XkCXSud+BuDg2
         WfZthRlvVzNjw==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 212183] st read statistics inaccurate when requested and
 physical block mismatch
Date:   Thu, 11 Mar 2021 18:42:44 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: low
X-Bugzilla-Who: kai.makisara@kolumbus.fi
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-212183-11613-dbRt4d1VIG@https.bugzilla.kernel.org/>
In-Reply-To: <bug-212183-11613@https.bugzilla.kernel.org/>
References: <bug-212183-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D212183

--- Comment #1 from Kai M=C3=A4kisara (kai.makisara@kolumbus.fi) ---
> On 9. Mar 2021, at 16.34, bugzilla-daemon@bugzilla.kernel.org wrote:
>=20
> https://bugzilla.kernel.org/show_bug.cgi?id=3D212183
>=20
>            Bug ID: 212183
>           Summary: st read statistics inaccurate when requested and
>                    physical block mismatch
>           Product: IO/Storage
>           Version: 2.5
>    Kernel Version: 5.3.1
>          Hardware: All
>                OS: Linux
>              Tree: Mainline
>            Status: NEW
>          Severity: low
>          Priority: P1
>         Component: SCSI
>          Assignee: linux-scsi@vger.kernel.org
>          Reporter: etienne.mollier@cgg.com
>        Regression: No
>=20
> Created attachment 295769
>  --> https://bugzilla.kernel.org/attachment.cgi?id=3D295769&action=3Dedit
> st.c patch working around stats issue when blocks size mismatch
>=20
> Greetings,
>=20
> when reading from tape with requested blocks larger than physical, statis=
tics
> go wrong as using the requested size for the calculation, instead of the
> actual

=E2=80=A6

The code around your suggested patch looks like this:

                if (scsi_req(req)->result) {
                        atomic64_add(atomic_read(&STp->stats->last_read_siz=
e)
                                - STp->buffer->cmdstat.residual,
                                &STp->stats->read_byte_cnt);
                        if (STp->buffer->cmdstat.residual > 0)
                                atomic64_inc(&STp->stats->resid_cnt);
                } else
                        atomic64_add(atomic_read(&STp->stats->last_read_siz=
e),
                                &STp->stats->read_byte_cnt);

Your patch makes the else branch look like the first command in the
if branch. If the SILI option bit is not set, the command result should be
non-zero when the read block is shorter than the requested size. If the
SILI bit is set, this is not considered error and the else part is executed.
Your patch applies to this case?

If we trust that the residual (resid_len) is set correctly, the conditional
branches could be omitted and the residual could be subtracted always:
-----
-diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 841ad2fc369a..4f1f2abfbca3 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -498,15 +498,11 @@ static void st_do_stats(struct scsi_tape *STp, struct
request *req)
                atomic64_add(ktime_to_ns(now), &STp->stats->tot_read_time);
                atomic64_add(ktime_to_ns(now), &STp->stats->tot_io_time);
                atomic64_inc(&STp->stats->read_cnt);
-               if (scsi_req(req)->result) {
-                       atomic64_add(atomic_read(&STp->stats->last_read_siz=
e)
-                               - STp->buffer->cmdstat.residual,
-                               &STp->stats->read_byte_cnt);
-                       if (STp->buffer->cmdstat.residual > 0)
-                               atomic64_inc(&STp->stats->resid_cnt);
-               } else
-                       atomic64_add(atomic_read(&STp->stats->last_read_siz=
e),
-                               &STp->stats->read_byte_cnt);
+               atomic64_add(atomic_read(&STp->stats->last_read_size)
+                            - STp->buffer->cmdstat.residual,
+                            &STp->stats->read_byte_cnt);
+               if (STp->buffer->cmdstat.residual > 0)
+                       atomic64_inc(&STp->stats->resid_cnt);
        } else {
                now =3D ktime_sub(now, STp->stats->other_time);
                atomic64_add(ktime_to_ns(now), &STp->stats->tot_io_time);
----

Opinions? (I don=E2=80=99t nowadays have access to any reasonable SCSI tape=
 drive to
test
this.)

Thanks,
Kai

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
