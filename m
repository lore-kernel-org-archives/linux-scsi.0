From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 98261] New: Misleading indentation in
 drivers/scsi/bfa/bfa_ioc.c: bfa_cb_sfp_state_query
Date: Wed, 13 May 2015 18:26:55 +0000
Message-ID: <bug-98261-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:58532 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbbEMS07 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 May 2015 14:26:59 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7CD2F20437
	for <linux-scsi@vger.kernel.org>; Wed, 13 May 2015 18:26:57 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id B9B512041C
	for <linux-scsi@vger.kernel.org>; Wed, 13 May 2015 18:26:55 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D98261

            Bug ID: 98261
           Summary: Misleading indentation in drivers/scsi/bfa/bfa_ioc.=
c:
                    bfa_cb_sfp_state_query
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 4.0.3
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: dmalcolm@redhat.com
        Regression: No

In linux-4.0.3/drivers/scsi/bfa/bfa_ioc.c: bfa_cb_sfp_state_query, the
indentation doesn't reflect the actual block structure:

  3659  static void
  3660  bfa_cb_sfp_state_query(struct bfa_sfp_s *sfp)
  3661  {
  3662          bfa_trc(sfp, sfp->portspeed);
  3663          if (sfp->media) {
  3664                  bfa_sfp_media_get(sfp);
  3665                  if (sfp->state_query_cbfn)
  3666                          sfp->state_query_cbfn(sfp->state_query_=
cbarg,
  3667                                          sfp->status);
  3668                          sfp->media =3D NULL;
  3669                  }
  3670 =20
  3671                  if (sfp->portspeed) {
  3672                          sfp->status =3D bfa_sfp_speed_valid(sfp=
,
sfp->portspeed);
  3673                          if (sfp->state_query_cbfn)
  3674                                =20
sfp->state_query_cbfn(sfp->state_query_cbarg,
  3675                                                  sfp->status);
  3676                                  sfp->portspeed =3D
BFA_PORT_SPEED_UNKNOWN;
  3677                  }
  3678 =20
  3679                  sfp->state_query_lock =3D 0;
  3680                  sfp->state_query_cbfn =3D NULL;
  3681  }

Note how the "if" at line 3665 does not have an opening brace.  Lines 3=
666-3668
are indented as if guarded by it, but only lines 3666-3667 are.  The cl=
osing
brace at line 3669 looks from the indentation as if it relates to line =
3665,
but it actually relates to line 3663.

Hence although lines 3671 onwards are indented as if guarded by the "if=
" at
line 3663, they are not.

There's also an issue at line 3676, which is indented as if guarded by =
the "if"
at line 3673, but isn't.

Seen via an experimental new gcc warning I'm working on for gcc 6,
-Wmisleading-indentation, using gcc r223098 adding
-Werror=3Dmisleading-indentation" to KBUILD_CFLAGS in Makefile, where t=
he
experimental gcc emits these errors:

drivers/scsi/bfa/bfa_ioc.c: In function =E2=80=98bfa_cb_sfp_state_query=
=E2=80=99:
drivers/scsi/bfa/bfa_ioc.c:3668:4: error: statement is indented as if i=
t were
guarded by... [-Werror=3Dmisleading-indentation]
    sfp->media =3D NULL;
    ^
drivers/scsi/bfa/bfa_ioc.c:3665:3: note: ...this =E2=80=98if=E2=80=99 c=
lause, but it is not
   if (sfp->state_query_cbfn)
   ^
drivers/scsi/bfa/bfa_ioc.c:3676:5: error: statement is indented as if i=
t were
guarded by... [-Werror=3Dmisleading-indentation]
     sfp->portspeed =3D BFA_PORT_SPEED_UNKNOWN;
     ^
drivers/scsi/bfa/bfa_ioc.c:3673:4: note: ...this =E2=80=98if=E2=80=99 c=
lause, but it is not
    if (sfp->state_query_cbfn)
    ^

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
