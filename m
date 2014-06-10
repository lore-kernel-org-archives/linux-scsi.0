From: Sudarsana Kalluru <Sudarsana.Kalluru@qlogic.com>
Subject: RE: [PATCH 5/11] drivers/scsi/bfa/bfad_bsg.c: Remove useless return
 variables
Date: Tue, 10 Jun 2014 11:24:46 +0000
Message-ID: <C08020CBD5BE83488A998B4818797E8414288A@avmb3.qlogic.org>
References: <1401542051-3174-5-git-send-email-peter.senna@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_C08020CBD5BE83488A998B4818797E8414288Aavmb3qlogicorg_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:44827 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750840AbaFJLYu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jun 2014 07:24:50 -0400
Received: from pps.filterd (m0045602.ppops.net [127.0.0.1])
	by mx0a-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id s5ABOn63030859
	for <linux-scsi@vger.kernel.org>; Tue, 10 Jun 2014 04:24:49 -0700
Received: from avcashub1.qlogic.com (avcashub3.qlogic.com [198.70.193.117])
	by mx0a-0016ce01.pphosted.com with ESMTP id 1madc17549-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 10 Jun 2014 04:24:49 -0700
In-Reply-To: <1401542051-3174-5-git-send-email-peter.senna@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Peter Senna Tschudin <peter.senna@gmail.com>, Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>
Cc: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

--_000_C08020CBD5BE83488A998B4818797E8414288Aavmb3qlogicorg_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Thanks for the patch.
Acked-by: Sudarsana Kalluru <Sudarsana.Kalluru@qlogic.com>

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel=
.org] On Behalf Of Peter Senna Tschudin
Sent: 31 May 2014 18:44
To: Anil Gurumurthy
Cc: kernel-janitors@vger.kernel.org; Sudarsana Kalluru; James E.J. Bottomle=
y; linux-scsi; linux-kernel
Subject: [PATCH 5/11] drivers/scsi/bfa/bfad_bsg.c: Remove useless return va=
riables

This patch remove variables that are initialized with a constant, are never=
 updated, and are only used as parameter of return.
Return the constant instead of using a variable.

Verified by compilation only.

The coccinelle script that find and fixes this issue is:
// <smpl>
@@
type T;
constant C;
identifier ret;
@@
- T ret =3D C;
... when !=3D ret
    when strict
return
- ret
+ C
;
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/scsi/bfa/bfad_bsg.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c inde=
x 8994fb8..a6ee1cf 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -26,7 +26,6 @@ int
 bfad_iocmd_ioc_enable(struct bfad_s *bfad, void *cmd)  {
        struct bfa_bsg_gen_s *iocmd =3D (struct bfa_bsg_gen_s *)cmd;
-       int     rc =3D 0;
        unsigned long   flags;

        spin_lock_irqsave(&bfad->bfad_lock, flags); @@ -34,7 +33,7 @@ bfad_=
iocmd_ioc_enable(struct bfad_s *bfad, void *cmd)
        if (!bfa_ioc_is_disabled(&bfad->bfa.ioc)) {
                spin_unlock_irqrestore(&bfad->bfad_lock, flags);
                iocmd->status =3D BFA_STATUS_OK;
-               return rc;
+               return 0;
        }

        init_completion(&bfad->enable_comp);
@@ -43,21 +42,20 @@ bfad_iocmd_ioc_enable(struct bfad_s *bfad, void *cmd)
        spin_unlock_irqrestore(&bfad->bfad_lock, flags);
        wait_for_completion(&bfad->enable_comp);

-       return rc;
+       return 0;
 }

 int
 bfad_iocmd_ioc_disable(struct bfad_s *bfad, void *cmd)  {
        struct bfa_bsg_gen_s *iocmd =3D (struct bfa_bsg_gen_s *)cmd;
-       int     rc =3D 0;
        unsigned long   flags;

        spin_lock_irqsave(&bfad->bfad_lock, flags);
        if (bfa_ioc_is_disabled(&bfad->bfa.ioc)) {
                spin_unlock_irqrestore(&bfad->bfad_lock, flags);
                iocmd->status =3D BFA_STATUS_OK;
-               return rc;
+               return 0;
        }

        if (bfad->disable_active) {
@@ -74,7 +72,7 @@ bfad_iocmd_ioc_disable(struct bfad_s *bfad, void *cmd)
        bfad->disable_active =3D BFA_FALSE;
        iocmd->status =3D BFA_STATUS_OK;

-       return rc;
+       return 0;
 }

 static int

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in th=
e body of a message to majordomo@vger.kernel.org More majordomo info at  ht=
tp://vger.kernel.org/majordomo-info.html

________________________________

This message and any attached documents contain information from QLogic Cor=
poration or its wholly-owned subsidiaries that may be confidential. If you =
are not the intended recipient, you may not read, copy, distribute, or use =
this information. If you have received this transmission in error, please n=
otify the sender immediately by reply e-mail and then delete this message.

--_000_C08020CBD5BE83488A998B4818797E8414288Aavmb3qlogicorg_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

eJ8+Ipx7AQaQCAAEAAAAAAABAAEAAQeQBgAIAAAA5AQAAAAAAADoAAEJgAEAIQAAADgzQkMzRDdG
NUIzMDhCNDBBMjE0QTNFRDI0MDVBODc4ACQHAQ2ABAACAAAAAgACAAEFgAMADgAAAN4HBgAKAAsA
GAAuAAIASAEBIIADAA4AAADeBwYACgALABgALgACAEgBAQiABwAYAAAASVBNLk1pY3Jvc29mdCBN
YWlsLk5vdGUAMQgBBIABAE4AAABSRTogW1BBVENIIDUvMTFdIGRyaXZlcnMvc2NzaS9iZmEvYmZh
ZF9ic2cuYzogUmVtb3ZlIHVzZWxlc3MgcmV0dXJuIHZhcmlhYmxlcwDEGgEDkAYAYBMAAD8AAAAC
AX8AAQAAADoAAAA8QzA4MDIwQ0JENUJFODM0ODhBOTk4QjQ4MTg3OTdFODQxNDI4OEFAYXZtYjMu
cWxvZ2ljLm9yZz4AAAALAB8OAQAAAAIBCRABAAAAqQcAAKUHAACAEAAATFpGddX6QHVhAApmYmlk
BAAAY2PAcGcxMjUyAP4DQ/B0ZXh0AfcCpAPjAgAEY2gKwHNldDAg7wdtAoMAUBFNMgqABrQCgJZ9
CoAIyDsJYjE5DsC/CcMWcgoyFnECgBViKgmwcwnwBJBhdAWyDlADYHOibwGAIEV4EcFuGDBdBlJ2
BJAXtgIQcgDAdH0IUG4aMRAgBcAFoBtkZJogA1IgECIXslx2CJDkd2sLgGQ1HVME8AdADRdwMApx
F/Jia21rBnMBkAAgIEJNX0LgRUdJTn0K/AHxC/GfEkAZoR9QHHAFsXRoGeBFCrB0EcAuXGwLgGUR
CoBBY2sJgC1ieTI6BgB1ZBHhAHBhIIZLB0AKQHJ1IDwkB1IuJKVAcQkAZw5QLlkFoG0+IvUi9S0n
4k/vBRAmgCRwAyBNB5AkUBgwOyfjIvVGA2Ej4CMBdXhGLQTwAJAtb3cYUUAydhgwci4jgASgZWzi
LgWwZyBbAMADEBiQRjoqXyttXSBPA6BCsmUR0GxmLvAvgFASEKsbsQZgbiRxVATwaCQQlwuBIwQw
MXQj4DMxBdAIYXkgAdAxNCAxUDg6NDQi9VQswCBqQQMCRyThbQhwIlB5mSL1Q2Mj4Cu0LWoAcKpp
GJFzK147I/91NzCESmEHgkUuSi4fsO5vAkADcB5weTcwLOg5xmMrtDEWdWJqBZAxsVsAUEFUQ0gg
NS80MTEu4GQFEBoxcy8hLUIvYmZhPfJkX5hic2cmsCPgUmUEYHkaMCB1EgAecAQRCXB0+whwA6B2
CsAHMAJgB5AnDP8hoAQAIoQ/4T8jQGciQRiAPiAKwBngC4A14AcxaXp/HFED8CJQQ9Ab0h9hAjAs
70PTGFAaMT9gcCQgHEFF0fcdwEPTAiBsMjA/cUdBQgL/GHAHgBuiGTA/5SLmPwBAE+8iUkVWRBEf
YGU+YEkCP3C/C4AsQCSAQGYi5iL1VgZyzwiQHGAjwBvRbXADEBiAPmkCIEeTTR0hoEqyY2P/IxEk
wBngBPVDk05ARzJHMX1OQHhDY0HxBAEKUFOROqki9S8vJRBzTuBsJvZEQEAi9XR5cBngVPcWICME
StdDVpYN0DGRTjJvBcA/8VaWVactEkA/4iB6PVeYLltQRNAiYAOgIfdaoD/xIvUgXLFbkx9gBRDf
PCAi9T/0WbdcGCtXkCL1/1aWVKI9oFT5MRYoUBhQI6D9GTBmI7Mv3zDhJRBWUBuh5i4SADBRQGcs
cia/J8NnXEY9Pz5IIHxcsR6QIP4rabEn42b3MfBOQFFxGZQfRvEygEthG4FPQXMoKzopRdA2Z3A/
kWxELSl3ZfwN4AEgICfgJoBDwS97Z49omWJvb2iKHbEQMCBQODk5NA2wOFtQYbI2CeAxYy+AHpE2
Mtf/J+FvTz4bXzZpsHEvdp9Vc+Fu4DI2LDdpoHqRbOCfelELgFw3PkNPQGNtfFPWXwnwQKIoXUF1
PCB8FM0EICo+QkXQdm8N0H5Q9XyRKVywXAAAXFhcsn2I/T6CXxgxfjJ8c1qRfXmBSn4pfJFWllog
gCR7cYAjcttpIFqgMFaWgCZ1AIFiYi8qQAIgLEBcsGYLYGdzf1aWf75O8IGwCQAjcHxgciZxJFAa
MCgmPkItPm8+Q4oiRdCIEyk3MHpSM/I0erIzM3qxelF8L30/335Pf1B/vQaQgnAhgRKOYq0EAF8N
4UCiZIrpLo4B/il/YH+fiVuHEIomCXAfYP8FsIrfi+iUv4TVjhKX4B9hB0AQBCBaoEJGQV9TglQ8
gFVTX09LhD7/gCY/9YWwVpZfoJ0PQCKGD95cIECIj4T0NeBfTsJtJF+Xho6kozOZB3pSNI1AMvEx
8Cs0MqYAEjCNj46fv4+vkL+V/5cPmB9/vXcLcP+jIBrhoz+kTycrnX+ejZ///6F/e3+nR5L1qD9+
j5Sfgp//gb+8H4PfhO+gX4cPiB+JL/+KP6zvrf+R45JPk1+Ub5V//6uPxj/HT5m/ms+b35zvsw+/
06+gH6Evx//OY8mlXwDQ70RQGjDLKXpSN4zjAcCNX/+4D7kfqa+7ZdnveFHSFdJQ+ExTRce/0V/S
b7Hv1J//tA+1H1xG5LIOULaZJ3cy9/fCQjvgBPJiGeAchEHiIwA/H2Aj4GTxHGAiUiMCICK77Xos
6CJEESJDBuBkMjB/SREkgAeBKPIcwO1QAMBq1QWwZANwbytfTc4B81gvRBECEEPQwJFoAkBwOqtU
oCttL/NnLfXyLvaA+zmAZfxf+g/6/ED/BCDytv1HI24yMBiAAZARwBxR87D+YzQgMZEEIBvhAZBk
UfXy5xsCT0Icg1FMJnJXkAWw/nAFsE8lBcA14AQgW5AG8P9HwC2DHGDtkg3RQHFDZmVgfzIw7gEb
4U5AWEMHQDkQSf0vgHkIYEXkOUAiQ7ah70H/HFEJcFEgTvAxkUXQBgIEgs8GghZAudJlsHB5RdAN
4fldUWJ1ECBF0BihP3FTRd//+AW3EdA/QQeRZXhR72L/QfFdUFdgVOARcU9CZFE1UP0P8HJF0K/R
SEAGY26wMjD/IlLvMhuxEmD9MAOxG6BHwf9OkRZAILAyMCkgZWJHEyJRfwCAbQMK1f01IuYVQhTw
AAAAHwBCAAEAAAAkAAAAUwB1AGQAYQByAHMAYQBuAGEAIABLAGEAbABsAHUAcgB1AAAAHwBlAAEA
AAA6AAAAUwB1AGQAYQByAHMAYQBuAGEALgBLAGEAbABsAHUAcgB1AEAAcQBsAG8AZwBpAGMALgBj
AG8AbQAAAAAAHwBkAAEAAAAKAAAAUwBNAFQAUAAAAAAAAgFBAAEAAACAAAAAAAAAAIErH6S+oxAZ
nW4A3QEPVAIAAACAUwB1AGQAYQByAHMAYQBuAGEAIABLAGEAbABsAHUAcgB1AAAAUwBNAFQAUAAA
AFMAdQBkAGEAcgBzAGEAbgBhAC4ASwBhAGwAbAB1AHIAdQBAAHEAbABvAGcAaQBjAC4AYwBvAG0A
AAAfAAJdAQAAADoAAABTAHUAZABhAHIAcwBhAG4AYQAuAEsAYQBsAGwAdQByAHUAQABxAGwAbwBn
AGkAYwAuAGMAbwBtAAAAAAAfAOVfAQAAAEIAAABzAGkAcAA6AHMAdQBkAGEAcgBzAGEAbgBhAC4A
awBhAGwAbAB1AHIAdQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAAAB8AGgwBAAAAJAAAAFMAdQBk
AGEAcgBzAGEAbgBhACAASwBhAGwAbAB1AHIAdQAAAB8AHwwBAAAAOgAAAFMAdQBkAGEAcgBzAGEA
bgBhAC4ASwBhAGwAbAB1AHIAdQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAAAB8AHgwBAAAACgAA
AFMATQBUAFAAAAAAAAIBGQwBAAAAgAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgFMAdQBkAGEA
cgBzAGEAbgBhACAASwBhAGwAbAB1AHIAdQAAAFMATQBUAFAAAABTAHUAZABhAHIAcwBhAG4AYQAu
AEsAYQBsAGwAdQByAHUAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwABXQEAAAA6AAAAUwB1AGQA
YQByAHMAYQBuAGEALgBLAGEAbABsAHUAcgB1AEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAAAAHwD4
PwEAAAAkAAAAUwB1AGQAYQByAHMAYQBuAGEAIABLAGEAbABsAHUAcgB1AAAAHwAjQAEAAAA6AAAA
UwB1AGQAYQByAHMAYQBuAGEALgBLAGEAbABsAHUAcgB1AEAAcQBsAG8AZwBpAGMALgBjAG8AbQAA
AAAAHwAiQAEAAAAKAAAAUwBNAFQAUAAAAAAAAgH5PwEAAACAAAAAAAAAAIErH6S+oxAZnW4A3QEP
VAIAAACAUwB1AGQAYQByAHMAYQBuAGEAIABLAGEAbABsAHUAcgB1AAAAUwBNAFQAUAAAAFMAdQBk
AGEAcgBzAGEAbgBhAC4ASwBhAGwAbAB1AHIAdQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAAld
AQAAADoAAABTAHUAZABhAHIAcwBhAG4AYQAuAEsAYQBsAGwAdQByAHUAQABxAGwAbwBnAGkAYwAu
AGMAbwBtAAAAAAAfADFAAQAAAAIAAAAAAAAACwBAOgEAAAAfADBAAQAAAAIAAAAAAAAAHwAaAAEA
AAASAAAASQBQAE0ALgBOAG8AdABlAAAAAAADAPE/CQQAAAsAQDoBAAAAAwD9P+QEAAACAQswAQAA
ABAAAACDvD1/WzCLQKIUo+0kBah4AwAXAAEAAABAADkAANM0lZ6EzwFAAAgwJwatlZ6EzwELACkA
AAAAAAsAIwAAAAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAHgAAAGEAYwBjAGUAcAB0AGwAYQBu
AGcAdQBhAGcAZQAAAAAAAQAAAAwAAABlAG4ALQBVAFMAAAALAACACCAGAAAAAADAAAAAAAAARgAA
AAAGhQAAAAAAAB8ANwABAAAAnAAAAFIARQA6ACAAWwBQAEEAVABDAEgAIAA1AC8AMQAxAF0AIABk
AHIAaQB2AGUAcgBzAC8AcwBjAHMAaQAvAGIAZgBhAC8AYgBmAGEAZABfAGIAcwBnAC4AYwA6ACAA
UgBlAG0AbwB2AGUAIAB1AHMAZQBsAGUAcwBzACAAcgBlAHQAdQByAG4AIAB2AGEAcgBpAGEAYgBs
AGUAcwAAAB8APQABAAAACgAAAFIARQA6ACAAAAAAAAMANgAAAAAAAwAuAAAAAAAfAEIQAQAAAHIA
AAA8ADEANAAwADEANQA0ADIAMAA1ADEALQAzADEANwA0AC0ANQAtAGcAaQB0AC0AcwBlAG4AZAAt
AGUAbQBhAGkAbAAtAHAAZQB0AGUAcgAuAHMAZQBuAG4AYQBAAGcAbQBhAGkAbAAuAGMAbwBtAD4A
AAAAAAIBcQABAAAAGwAAAAEBz3zSzjswctHqRKxAkDs89wozcG6bakNawAAfAHAAAQAAAJQAAABb
AFAAQQBUAEMASAAgADUALwAxADEAXQAgAGQAcgBpAHYAZQByAHMALwBzAGMAcwBpAC8AYgBmAGEA
LwBiAGYAYQBkAF8AYgBzAGcALgBjADoAIABSAGUAbQBvAHYAZQAgAHUAcwBlAGwAZQBzAHMAIABy
AGUAdAB1AHIAbgAgAHYAYQByAGkAYQBiAGwAZQBzAAAAHwA1EAEAAAB0AAAAPABDADAAOAAwADIA
MABDAEIARAA1AEIARQA4ADMANAA4ADgAQQA5ADkAOABCADQAOAAxADgANwA5ADcARQA4ADQAMQA0
ADIAOAA4AEEAQABhAHYAbQBiADMALgBxAGwAbwBnAGkAYwAuAG8AcgBnAD4AAAAfADkQAQAAAHIA
AAA8ADEANAAwADEANQA0ADIAMAA1ADEALQAzADEANwA0AC0ANQAtAGcAaQB0AC0AcwBlAG4AZAAt
AGUAbQBhAGkAbAAtAHAAZQB0AGUAcgAuAHMAZQBuAG4AYQBAAGcAbQBhAGkAbAAuAGMAbwBtAD4A
AAAAAAMA3j+fTgAACwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAA4UAAAAAAAADAACACCAGAAAAAADA
AAAAAAAARgAAAAABhQAAAAAAAAMAgBD/////QAAHMHJTrpSehM8BCwACAAEAAAADACYAAAAAAAsA
KwAAAAAAAgFHAAEAAAAuAAAAYz1VUzthPSA7cD1RTG9naWM7bD1BVk1CMy0xNDA2MTAxMTI0NDZa
LTExNDQ2AAAAAgEQMAEAAABGAAAAAAAAAAbvima3DjtHqpAPKTtp+qQHAMCAIMvVvoNIipmLSBh5
foQAAAASLPcAAFBTm78EQZpMiRclbvImI2QAkZFgDMQAAAAAHwD6PwEAAAAkAAAAUwB1AGQAYQBy
AHMAYQBuAGEAIABLAGEAbABsAHUAcgB1AAAAAwAJWQEAAAADAACACCAGAAAAAADAAAAAAAAARgAA
AAAQhQAAAAAAAAsAAIAIIAYAAAAAAMAAAAAAAABGAAAAAA6FAAAAAAAAAwAAgAggBgAAAAAAwAAA
AAAAAEYAAAAAGIUAAAAAAAALAACACCAGAAAAAADAAAAAAAAARgAAAACChQAAAAAAAB8AAIAIIAYA
AAAAAMAAAAAAAABGAAAAANiFAAABAAAAEgAAAEkAUABNAC4ATgBvAHQAZQAAAAAAAwANNP0/AAAf
AACAhgMCAAAAAADAAAAAAAAARgEAAAAgAAAAeAAtAG0AcwAtAGgAYQBzAC0AYQB0AHQAYQBjAGgA
AAABAAAAAgAAAAAAAAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAiAAAAeAAtAG8AcgBpAGcAaQBu
AGEAdABpAG4AZwAtAGkAcAAAAAAAAQAAABgAAABbADEAMAAuADEALgA0AC4AMQAwAF0AAACQuw==

--_000_C08020CBD5BE83488A998B4818797E8414288Aavmb3qlogicorg_--
