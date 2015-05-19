From: Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>
Subject: RE: [PATCH] bfa: deinline __bfa_trc() and __bfa_trc32()
Date: Tue, 19 May 2015 10:43:45 +0000
Message-ID: <20B1A3CBD98F3845B3F5F56D8597EF590101FF45@avmb2.qlogic.org>
References: <1431940681-15915-1-git-send-email-dvlasenk@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_20B1A3CBD98F3845B3F5F56D8597EF590101FF45avmb2qlogicorg_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:14518 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752739AbbESKnr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 May 2015 06:43:47 -0400
Received: from pps.filterd (m0045602.ppops.net [127.0.0.1])
	by mx0a-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id t4JAhlXe012576
	for <linux-scsi@vger.kernel.org>; Tue, 19 May 2015 03:43:47 -0700
Received: from avcashub1.qlogic.com (avcashub1.qlogic.com [198.70.193.115])
	by mx0a-0016ce01.pphosted.com with ESMTP id 1udtwc3yg0-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 19 May 2015 03:43:47 -0700
In-Reply-To: <1431940681-15915-1-git-send-email-dvlasenk@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Denys Vlasenko <dvlasenk@redhat.com>, Vijaya Mohan Guvva <vmohan@brocade.com>
Cc: Fabian Frederick <fabf@skynet.be>, Christoph Hellwig <hch@lst.de>, Guenter Roeck <linux@roeck-us.net>, Ben Hutchings <ben@decadent.org.uk>, James Bottomley <JBottomley@Parallels.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

--_000_20B1A3CBD98F3845B3F5F56D8597EF590101FF45avmb2qlogicorg_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Patch looks good. You could remove the __bfa_trc32() routine
Thanks,
Acked-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>

-----Original Message-----
From: Denys Vlasenko [mailto:dvlasenk@redhat.com]=20
Sent: 18 May 2015 14:48
To: Vijaya Mohan Guvva
Cc: Denys Vlasenko; Fabian Frederick; Anil Gurumurthy; Christoph Hellwig; G=
uenter Roeck; Ben Hutchings; James Bottomley; linux-kernel; linux-scsi
Subject: [PATCH] bfa: deinline __bfa_trc() and __bfa_trc32()

__bfa_trc() compiles to 115 bytes of machine code.
With this .config: http://busybox.net/~vda/kernel_config
there are 1494 calls of __bfa_trc().

__bfa_trc32() is very similar, so it is uninlined too.
However, it appears to be unused, therefore this patch ifdefs it out.

Change in code size is about 130,000 bytes:

    text     data      bss       dec     hex filename
85975426 22294712 20627456 128897594 7aed23a vmlinux.before
85842882 22294584 20627456 128764922 7accbfa vmlinux

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Fabian Frederick <fabf@skynet.be>
CC: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Guenter Roeck <linux@roeck-us.net>
CC: Ben Hutchings <ben@decadent.org.uk>
CC: James Bottomley <JBottomley@Parallels.com>
CC: linux-kernel@vger.kernel.org
CC: linux-scsi@vger.kernel.org
---
 drivers/scsi/bfa/bfa_core.c | 40 ++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/bfa/bfa_cs.h   | 41 ++++-------------------------------------
 2 files changed, 44 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c inde=
x e3f67b0..3657a00 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -90,6 +90,46 @@ static bfa_ioc_mbox_mcfunc_t  bfa_mbox_isrs[BFI_MC_MAX] =
=3D {
=20
=20
=20
+void
+__bfa_trc(struct bfa_trc_mod_s *trcm, int fileno, int line, u64 data) {
+	int		tail =3D trcm->tail;
+	struct bfa_trc_s	*trc =3D &trcm->trc[tail];
+
+	if (trcm->stopped)
+		return;
+
+	trc->fileno =3D (u16) fileno;
+	trc->line =3D (u16) line;
+	trc->data.u64 =3D data;
+	trc->timestamp =3D BFA_TRC_TS(trcm);
+
+	trcm->tail =3D (trcm->tail + 1) & (BFA_TRC_MAX - 1);
+	if (trcm->tail =3D=3D trcm->head)
+		trcm->head =3D (trcm->head + 1) & (BFA_TRC_MAX - 1); }
+
+#if 0 /* UNUSED */
+void
+__bfa_trc32(struct bfa_trc_mod_s *trcm, int fileno, int line, u32 data)=20
+{
+	int		tail =3D trcm->tail;
+	struct bfa_trc_s *trc =3D &trcm->trc[tail];
+
+	if (trcm->stopped)
+		return;
+
+	trc->fileno =3D (u16) fileno;
+	trc->line =3D (u16) line;
+	trc->data.u32.u32 =3D data;
+	trc->timestamp =3D BFA_TRC_TS(trcm);
+
+	trcm->tail =3D (trcm->tail + 1) & (BFA_TRC_MAX - 1);
+	if (trcm->tail =3D=3D trcm->head)
+		trcm->head =3D (trcm->head + 1) & (BFA_TRC_MAX - 1); } #endif
+
 static void
 bfa_com_port_attach(struct bfa_s *bfa)
 {
diff --git a/drivers/scsi/bfa/bfa_cs.h b/drivers/scsi/bfa/bfa_cs.h index 91=
a8aa3..dd3154e 100644
--- a/drivers/scsi/bfa/bfa_cs.h
+++ b/drivers/scsi/bfa/bfa_cs.h
@@ -107,44 +107,11 @@ bfa_trc_stop(struct bfa_trc_mod_s *trcm)
 	trcm->stopped =3D 1;
 }
=20
-static inline void
-__bfa_trc(struct bfa_trc_mod_s *trcm, int fileno, int line, u64 data) -{
-	int		tail =3D trcm->tail;
-	struct bfa_trc_s	*trc =3D &trcm->trc[tail];
-
-	if (trcm->stopped)
-		return;
-
-	trc->fileno =3D (u16) fileno;
-	trc->line =3D (u16) line;
-	trc->data.u64 =3D data;
-	trc->timestamp =3D BFA_TRC_TS(trcm);
-
-	trcm->tail =3D (trcm->tail + 1) & (BFA_TRC_MAX - 1);
-	if (trcm->tail =3D=3D trcm->head)
-		trcm->head =3D (trcm->head + 1) & (BFA_TRC_MAX - 1);
-}
-
+void
+__bfa_trc(struct bfa_trc_mod_s *trcm, int fileno, int line, u64 data);
=20
-static inline void
-__bfa_trc32(struct bfa_trc_mod_s *trcm, int fileno, int line, u32 data) -{
-	int		tail =3D trcm->tail;
-	struct bfa_trc_s *trc =3D &trcm->trc[tail];
-
-	if (trcm->stopped)
-		return;
-
-	trc->fileno =3D (u16) fileno;
-	trc->line =3D (u16) line;
-	trc->data.u32.u32 =3D data;
-	trc->timestamp =3D BFA_TRC_TS(trcm);
-
-	trcm->tail =3D (trcm->tail + 1) & (BFA_TRC_MAX - 1);
-	if (trcm->tail =3D=3D trcm->head)
-		trcm->head =3D (trcm->head + 1) & (BFA_TRC_MAX - 1);
-}
+void
+__bfa_trc32(struct bfa_trc_mod_s *trcm, int fileno, int line, u32=20
+data);
=20
 #define bfa_sm_fault(__mod, __event)	do {				\
 	bfa_trc(__mod, (((u32)0xDEAD << 16) | __event));		\
--
1.8.1.4


--_000_20B1A3CBD98F3845B3F5F56D8597EF590101FF45avmb2qlogicorg_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
AAAAAAAAgSsfpL6jEBmdbgDdAQ9UAgAAAIBBAG4AaQBsACAARwB1AHIAdQBtAHUAcgB0AGgAeQAA
AFMATQBUAFAAAABBAG4AaQBsAC4ARwB1AHIAdQBtAHUAcgB0AGgAeQBAAHEAbABvAGcAaQBjAC4A
YwBvAG0AAAAfAAJdAQAAADYAAABBAG4AaQBsAC4ARwB1AHIAdQBtAHUAcgB0AGgAeQBAAHEAbABv
AGcAaQBjAC4AYwBvAG0AAAAAAB8A5V8BAAAAPgAAAHMAaQBwADoAYQBuAGkAbAAuAGcAdQByAHUA
bQB1AHIAdABoAHkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAAAAfABoMAQAAACAAAABBAG4AaQBs
ACAARwB1AHIAdQBtAHUAcgB0AGgAeQAAAB8AHwwBAAAANgAAAEEAbgBpAGwALgBHAHUAcgB1AG0A
dQByAHQAaAB5AEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAAAAHwAeDAEAAAAKAAAAUwBNAFQAUAAA
AAAAAgEZDAEAAAB4AAAAAAAAAIErH6S+oxAZnW4A3QEPVAIAAACAQQBuAGkAbAAgAEcAdQByAHUA
bQB1AHIAdABoAHkAAABTAE0AVABQAAAAQQBuAGkAbAAuAEcAdQByAHUAbQB1AHIAdABoAHkAQABx
AGwAbwBnAGkAYwAuAGMAbwBtAAAAHwABXQEAAAA2AAAAQQBuAGkAbAAuAEcAdQByAHUAbQB1AHIA
dABoAHkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAAAAfAPg/AQAAACAAAABBAG4AaQBsACAARwB1
AHIAdQBtAHUAcgB0AGgAeQAAAB8AI0ABAAAANgAAAEEAbgBpAGwALgBHAHUAcgB1AG0AdQByAHQA
aAB5AEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAAAAHwAiQAEAAAAKAAAAUwBNAFQAUAAAAAAAAgH5
PwEAAAB4AAAAAAAAAIErH6S+oxAZnW4A3QEPVAIAAACAQQBuAGkAbAAgAEcAdQByAHUAbQB1AHIA
dABoAHkAAABTAE0AVABQAAAAQQBuAGkAbAAuAEcAdQByAHUAbQB1AHIAdABoAHkAQABxAGwAbwBn
AGkAYwAuAGMAbwBtAAAAHwAJXQEAAAA2AAAAQQBuAGkAbAAuAEcAdQByAHUAbQB1AHIAdABoAHkA
QABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAAAALAEA6AQAAAB8AGgABAAAAEgAAAEkAUABNAC4ATgBv
AHQAZQAAAAAAAwDxPwkEAAALAEA6AQAAAAMA/T/kBAAAAgELMAEAAAAQAAAAvZ9A7YNpKUGRSw0U
cfEyUAMAFwABAAAAQAA5AIBGBq4gktABQAAIMAZEia4gktABCwApAAAAAAALACMAAAAAAB8AAICG
AwIAAAAAAMAAAAAAAABGAQAAAB4AAABhAGMAYwBlAHAAdABsAGEAbgBnAHUAYQBnAGUAAAAAAAEA
AAAMAAAAZQBuAC0AVQBTAAAACwAAgAggBgAAAAAAwAAAAAAAAEYAAAAABoUAAAAAAAAfADcAAQAA
AHAAAABSAEUAOgAgAFsAUABBAFQAQwBIAF0AIABiAGYAYQA6ACAAZABlAGkAbgBsAGkAbgBlACAA
XwBfAGIAZgBhAF8AdAByAGMAKAApACAAYQBuAGQAIABfAF8AYgBmAGEAXwB0AHIAYwAzADIAKAAp
AAAAHwA9AAEAAAAKAAAAUgBFADoAIAAAAAAAAwA2AAAAAAADAC4AAAAAAB8AQhABAAAAcAAAADwA
MQA0ADMAMQA5ADQAMAA2ADgAMQAtADEANQA5ADEANQAtADEALQBnAGkAdAAtAHMAZQBuAGQALQBl
AG0AYQBpAGwALQBkAHYAbABhAHMAZQBuAGsAQAByAGUAZABoAGEAdAAuAGMAbwBtAD4AAAACAXEA
AQAAABsAAAABAdCRTEpUOWl8a8j8S4QJ7X/V7DLlnYMccvAAHwBwAAEAAABoAAAAWwBQAEEAVABD
AEgAXQAgAGIAZgBhADoAIABkAGUAaQBuAGwAaQBuAGUAIABfAF8AYgBmAGEAXwB0AHIAYwAoACkA
IABhAG4AZAAgAF8AXwBiAGYAYQBfAHQAcgBjADMAMgAoACkAAAAfADUQAQAAAHgAAAA8ADIAMABC
ADEAQQAzAEMAQgBEADkAOABGADMAOAA0ADUAQgAzAEYANQBGADUANgBEADgANQA5ADcARQBGADUA
OQAwADEAMAAxAEYARgA0ADUAQABhAHYAbQBiADIALgBxAGwAbwBnAGkAYwAuAG8AcgBnAD4AAAAf
ADkQAQAAAHAAAAA8ADEANAAzADEAOQA0ADAANgA4ADEALQAxADUAOQAxADUALQAxAC0AZwBpAHQA
LQBzAGUAbgBkAC0AZQBtAGEAaQBsAC0AZAB2AGwAYQBzAGUAbgBrAEAAcgBlAGQAaABhAHQALgBj
AG8AbQA+AAAAAwDeP59OAAALAACACCAGAAAAAADAAAAAAAAARgAAAAADhQAAAAAAAAMAAIAIIAYA
AAAAAMAAAAAAAABGAAAAAAGFAAAAAAAAAwCAEP////9AAAcwzNtmrSCS0AELAAIAAQAAAAMAJgAA
AAAACwArAAAAAAACAUcAAQAAAC0AAABjPVVTO2E9IDtwPVFMb2dpYztsPUFWTUIyLTE1MDUxOTEw
NDM0NVotMTkzNQAAAAACARAwAQAAAEYAAAAAAAAApfa6WPiUnECXquZDOkRWvwcAILGjy9mPOEWz
9fVthZfvWQAAAPSNGAAAZwQxjMtxokilXd7HughfeQBLeqYuzAAAAAAfAPo/AQAAACAAAABBAG4A
aQBsACAARwB1AHIAdQBtAHUAcgB0AGgAeQAAAAMACVkBAAAAAwAAgAggBgAAAAAAwAAAAAAAAEYA
AAAAEIUAAAAAAAALAACACCAGAAAAAADAAAAAAAAARgAAAAAOhQAAAAAAAAMAAIAIIAYAAAAAAMAA
AAAAAABGAAAAABiFAAAAAAAACwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAgoUAAAAAAABAAACACCAG
AAAAAADAAAAAAAAARgAAAAC/hQAAoIE/aiCS0AEfAACACCAGAAAAAADAAAAAAAAARgAAAADYhQAA
AQAAABIAAABJAFAATQAuAE4AbwB0AGUAAAAAAAMADTT9PwAAHwAAgIYDAgAAAAAAwAAAAAAAAEYB
AAAAIAAAAHgALQBtAHMALQBoAGEAcwAtAGEAdAB0AGEAYwBoAAAAAQAAAAIAAAAAAAAAHwAAgIYD
AgAAAAAAwAAAAAAAAEYBAAAAIgAAAHgALQBvAHIAaQBnAGkAbgBhAHQAaQBuAGcALQBpAHAAAAAA
AAEAAAAYAAAAWwAxADAALgAxAC4ANAAuADEAMABdAAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAA
FgAAAGQAaQBzAGMAbABhAGkAbQBlAHIAAAAAAAEAAAAOAAAAYgB5AHAAYQBzAHMAAAAAAIch

--_000_20B1A3CBD98F3845B3F5F56D8597EF590101FF45avmb2qlogicorg_--
