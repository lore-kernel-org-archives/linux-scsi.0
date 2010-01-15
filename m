From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14877] MSI/MSI-X support in 2.6.31.xx and 2.6.32.xx seems
 broken
Date: Fri, 15 Jan 2010 07:24:06 GMT
Message-ID: <201001150724.o0F7O680021798@demeter.kernel.org>
References: <bug-14877-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:51427 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab0AOHYI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jan 2010 02:24:08 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0F7O6Ud021799
	for <linux-scsi@vger.kernel.org>; Fri, 15 Jan 2010 07:24:06 GMT
In-Reply-To: <bug-14877-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=3D14877





--- Comment #5 from Oleg Gawriloff <barzog@telecom.by>  2010-01-15 07:2=
4:05 ---
15.01.2010 1:01, Andrew Morton =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> Oleg, please send that lpfc patch via emailed reply-to-all to this em=
ail.
> Include a brief description for the changelog and a Signed-off-by: as
> per Documentation/SubmittingPatches, thanks.
Signed-off-by version available at
http://marc.info/?l=3Dlinux-scsi&m=3D126342842601776&w=3D2

=46rom: George Kadianakis <desnacked {bomb} gmail {point} com>

A Gentoo bug report [1] showed that as of 2.6.31 lpfc only uses INTx=20
interrupts.
This patch restores lpfc's ability to support MSI-X/MSI interrupts that=
 the
"Addition of SLI4 Interface - Base Support" patch [2] broke.
It reestablishes MSI-X as the default interrupt method and in case MSI-=
X=20
is not
supported lpfc_sli{4,}_enable_intr fallbacks to MSI and then to INTx.

[1]: http://bugs.gentoo.org/show_bug.cgi?id=3D296319
[2]: commit da0436e915a5c17ee79e72c1bf978a4ebb1cbf4d

Signed-off-by:  George Kadianakis <desnacked {cat} gmail {dog} com>
---
  drivers/scsi/lpfc/lpfc_attr.c |    6 +++---
  1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_att=
r.c
index e1a30a1..936ecaf 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -2890,12 +2890,12 @@ LPFC_ATTR_RW(poll_tmo, 10, 1, 255,
  /*
  # lpfc_use_msi: Use MSI (Message Signaled Interrupts) in systems that
  #                  support this feature
-#       0  =3D MSI disabled (default)
+#       0  =3D MSI disabled
  #       1  =3D MSI enabled
-#       2  =3D MSI-X enabled
+#       2  =3D MSI-X enabled (default)
  # Value range is [0,2]. Default value is 0.
  */
-LPFC_ATTR_R(use_msi, 0, 0, 2, "Use Message Signaled Interrupts (1) or =
"
+LPFC_ATTR_R(use_msi, 2, 0, 2, "Use Message Signaled Interrupts (1) or =
"
                            "MSI-X (2), if possible");

  /*

--=20
Signed, Oleg Gawriloff.

--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
