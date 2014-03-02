From: Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>
Subject: RE: [PATCH v2 02/23] bfa: Do not call pci_enable_msix() after it
 failed once
Date: Sun, 2 Mar 2014 08:01:26 +0000
Message-ID: <20B1A3CBD98F3845B3F5F56D8597EF59F7A1F7@avmb2.qlogic.org>
References: <cover.1393191330.git.agordeev@redhat.com>
 <e19ade23db801b0b4310947ad2aeb3350bc1aab5.1393191330.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_20B1A3CBD98F3845B3F5F56D8597EF59F7A1F7avmb2qlogicorg_"
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <e19ade23db801b0b4310947ad2aeb3350bc1aab5.1393191330.git.agordeev@redhat.com>
Content-Language: en-US
Sender: linux-pci-owner@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-pci <linux-pci@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

--_000_20B1A3CBD98F3845B3F5F56D8597EF59F7A1F7avmb2qlogicorg_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Patch look good.
Acked-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel=
.org] On Behalf Of Alexander Gordeev
Sent: 24 February 2014 13:32
To: linux-kernel
Cc: Alexander Gordeev; Anil Gurumurthy; Vijaya Mohan Guvva; linux-scsi; lin=
ux-pci
Subject: [PATCH v2 02/23] bfa: Do not call pci_enable_msix() after it faile=
d once

Function pci_enable_msix() should not be called in case it threw a negative=
 errno from a previous call.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Anil Gurumurthy <agurumur@brocade.com>
Cc: Vijaya Mohan Guvva <vmohan@brocade.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/bfa/bfad.c |   48 ++++++++++++++++++++++---------------------=
---
 1 files changed, 23 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c index cc0fbc=
d..972ff8d 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -1235,33 +1235,31 @@ bfad_setup_intr(struct bfad_s *bfad)
           (bfa_asic_id_cb(pdev->device) && !msix_disable_cb)) {

                error =3D pci_enable_msix(bfad->pcidev, msix_entries, bfad-=
>nvec);
-               if (error) {
-                       /* In CT1 & CT2, try to allocate just one vector */
-                       if (bfa_asic_id_ctc(pdev->device)) {
-                               printk(KERN_WARNING "bfa %s: trying one msi=
x "
-                                      "vector failed to allocate %d[%d]\n"=
,
-                                      bfad->pci_name, bfad->nvec, error);
-                               bfad->nvec =3D 1;
-                               error =3D pci_enable_msix(bfad->pcidev,
+               /* In CT1 & CT2, try to allocate just one vector */
+               if (error > 0 && bfa_asic_id_ctc(pdev->device)) {
+                       printk(KERN_WARNING "bfa %s: trying one msix "
+                              "vector failed to allocate %d[%d]\n",
+                              bfad->pci_name, bfad->nvec, error);
+                       bfad->nvec =3D 1;
+                       error =3D pci_enable_msix(bfad->pcidev,
                                                msix_entries, bfad->nvec);
-                       }
+               }

-                       /*
-                        * Only error number of vector is available.
-                        * We don't have a mechanism to map multiple
-                        * interrupts into one vector, so even if we
-                        * can try to request less vectors, we don't
-                        * know how to associate interrupt events to
-                        *  vectors. Linux doesn't duplicate vectors
-                        * in the MSIX table for this case.
-                        */
-                       if (error) {
-                               printk(KERN_WARNING "bfad%d: "
-                                      "pci_enable_msix failed (%d), "
-                                      "use line based.\n",
-                                       bfad->inst_no, error);
-                               goto line_based;
-                       }
+               /*
+                * Only error number of vector is available.
+                * We don't have a mechanism to map multiple
+                * interrupts into one vector, so even if we
+                * can try to request less vectors, we don't
+                * know how to associate interrupt events to
+                *  vectors. Linux doesn't duplicate vectors
+                * in the MSIX table for this case.
+                */
+               if (error) {
+                       printk(KERN_WARNING "bfad%d: "
+                              "pci_enable_msix failed (%d), "
+                              "use line based.\n",
+                               bfad->inst_no, error);
+                       goto line_based;
                }

                /* Disable INTX in MSI-X mode */
--
1.7.7.6

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

--_000_20B1A3CBD98F3845B3F5F56D8597EF59F7A1F7avmb2qlogicorg_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

eJ8+IkcMAQaQCAAEAAAAAAABAAEAAQeQBgAIAAAA5AQAAAAAAADoAAEJgAEAIQAAADc5QzE3MkEy
QTMzQjAwNDQ5QzM4QUZFRjk5RTdGMDM4ADkHAQ2ABAACAAAAAgACAAEFgAMADgAAAN4HAwACAAgA
AQAaAAAADQEBIIADAA4AAADeBwMAAgAIAAEAGgAAAA0BAQiABwAYAAAASVBNLk1pY3Jvc29mdCBN
YWlsLk5vdGUAMQgBBIABAE0AAABSRTogW1BBVENIIHYyIDAyLzIzXSBiZmE6IERvIG5vdCBjYWxs
IHBjaV9lbmFibGVfbXNpeCgpIGFmdGVyIGl0IGZhaWxlZCBvbmNlAIYYAQOQBgDQFAAAPwAAAAIB
fwABAAAAOgAAADwyMEIxQTNDQkQ5OEYzODQ1QjNGNUY1NkQ4NTk3RUY1OUY3QTFGN0Bhdm1iMi5x
bG9naWMub3JnPgAAAAsAHw4BAAAAAgEJEAEAAAC4CAAAtAgAAJkVAABMWkZ1D4GVx2EACmZiaWQE
AABjY8BwZzEyNTIA/gND8HRleHQB9wKkA+MCAARjaArAc2V0MCDvB20CgwBQEU0yCoAGtAKAln0K
gAjIOwliMTkOwL8JwxZyCjIWcQKAFWIqCbBzCfAEkGF0BbIOUANgc6JvAYAgRXgRwW4YMF0GUnYE
kBe2AhByAMB0fQhQbhoxECAFwAWgG2RkmiADUiAQIheyXHYIkOR3awuAZDUdUwTwB0ANF3AwCnEX
8mJrbWsGcwGQACAgQk1fQuBFR0lOfQr8AfEL8SwgUBiAEcAgCQBva4QgZyIQZC5cbAuAImUKgEFj
awmALWJQeTogQQMCRwhwdYJtCHB0aHkgPABwSQMQLmckF0BxCQBnZQ5QLgWgbT4ipSKlLe0nUk8F
ECXwbgdABdAHkNxzYRgwJ1MipUYDYSOQMSKxdXgtBPAAkC1vkncYUUB2GDByLiMwjQSgZSTwBbBn
IFsAwBsDEBiQOinPKt1dIE/JA6BCZRHQbGYuYC7w+kEecHgAcASBI/AFsAEAPGV2IqUGYAIwI5Ay
NPAgRmViJCAKwCSQAdDCMTEwMTM6Mw7AIrSeVCwwKbUrJCKlQ2MjkQ0vXjsjrjWwVmlqYTR5YQXQ
bxmhI/F2ds5hNbAsWDgGcGMAoDBlGHViagWQMPFbUEEAVENIIHYyIDAQMi8yMy5QYmZhwSOQRG8g
bm8FQB5ROwMgOUFfCfABoB5wX23BAJB4KCkgYQGAG7E+aQVAO5ADEBxRAiBjZckmfEZ1PsB0aQIg
PI9pPZBzaAhgbBxgPAJi/xngPEIcUQuAPDESAD4CJHCvCXAH4DcwGFBnGIBpGjC+IASQBKA74ByD
NzBwCXD/HWAIYAQgPEIiljBWJ8AYUPsjUBkwZiNkL14koSJQMAP2QAlxEdB0Jio0YyPPJRX6QDFw
bx5QAQBKPjbvNzD8PHYEYBmhTM80NSxYKs6fUL85QVIPJvcipSBkBRDpGjFzLyyyLzuBVyIigBBj
IHwgV/A0OCC+K1hfWKInU1n/VcgxHHCnPmFF0RmjZCwxEDNCwYcSAAAgQCFzKCspXKGeNVZQK2AS
EF1TLSkmfPsN4AEgICdQJfAFQFdQVm99V3ViYH9XZh2xEDAb0GPKMA2wYyKALjkBwAEgxjgcYB6R
NjQ0JuhgX59XRyKlWKFh/2cuQEBf8KEOkDM1LDNc0CtqpBdbsGphV3JfEgF1cF/xC4B0cigfYCQg
OjBr1bwgKldyXsZX8W6WKDuBHl9DEA5QbIBsEGNiKGJwAQB2LT5wUQ5QZaE9kCYmICE9Ql8N4es8
83AQKT2QXAAAJotumfduk0SRBbE9QF9XcnCAOUHfcFFcoHFjMNEIgXNcoHYE+RthYykWICb1c40G
kG8wD3SDcml4/m6WLyogSbkDoENUW7BxMH0QMlygf2ywJJAYkD2gPGBQERAgIH5qRcAFQAIgGeB4
MRiSKv4ves95H29MIcBwPHqPhO8HbpdFYGyRayhLRVIwTl9XQYcgICBHIOIiO4EgJXNLEH3BC4B/
K7B/Ej1Ch8CEL4p/c4oiR39VPkV+CiVkW44AXeBcXG4iLIl/j79ziv12B18n8AeAd6pcoHo0eH/v
lL+ROngidNExk7+YH3Qv/3U/dkdntnvPfN99737/nA/5ebsgPjsAcRKCH4MvoJ//hc+G34fviP2l
j4t/jI+Nn/+b36+fkU+SX5Nrrx+Vz5ba/7OvmS+aP5tPtv+7z7cMdu/3d/+8v26UXCBAti/BDL9v
35x+w3+3DZ1gLnBsJJC4BP8scAbQG7EZMJ/mBAA9oDfgXwMQPPIilsX/xwhXGeBk/QIgJwVAEdBE
YTcwB4AZku8EAByxO+AAwHC9sEGwQBB/C1A+5sqvxwhskUSRbGB0/wQgbJE74J+4XKAZIESAGjD7
A6B58XfO38/vPDEDoJ5l/QlwcQpQn4Fb8QQgf1S+ce/TcMx005/Ur2s8AAfgQZD/B+CeogQQUBAH
MJ8x0QfS4x/RgRiQ2E/ZX9cmLiBM7yxizHEHkMyiZGxgIrCfE3/XNdz/3g9C0SRwGeAF4En+WBzA
PPIccAWxJHDJYUMC/8ov4q9/36EPeh/oT6YPpx/9qCRkrfBLEIlv7++rfEBt/T42KK3wXbHu7/S/
q3xFwP8Z4CKyO3BDESKBjn/4v/nP63YEXPF0sZBvkz/537cM9yJQnqEisl/3Q/w/wf/Bf//FDbaP
x4/In8muA8/MP81P/85eB//Q79H/0w4ML9Wf1q//174QX9pP21/cbhSP3v/gD//hHhi/46/kvxx/
516g/+nv/yIP7I/tn+6qJG/w//IP8x//KC/1v/bPro8wr/p/+48wH7/+L/89AK/C/cRvnWBEccS5
nXBOVB6wQtEegS0esI9PkF4Q57lbJjEuNz0BVjbDDVsmVK1AdTKgdf5iYQBokEIxRPMfc0qQbOD/
SxBsMEhgHjMuwy5wPxlRaPoiHgZiO5BMEAYRCgIS0LdJQAngCsNqSWE/4G9UTv9OoUnQROgeAR8w
rVBgQAmgQHR0cDovL1RdL5VE9y1Hgi5IEG1sXtzuX0ufTIxe3FTlMkRGEZD/QPARkAUgrbAe0Fww
rQEJUPZjBbDcg2MJYB7QHhFHgo5yCvBdQj+0UUxvYCD1tbBDoDBwoDBR1AaCDdHmdxYArXB5LRXQ
TjBA8P8/Im/gFsC+Qh4xR9EK8AUg/z+RUPFb0F4QbKAWwEYwOpDxgeB5b3WtUEaxFcBgQL8eQg1S
Y7FA8BIwKkBwvlD/bKBcoFeSVhJYEhIw7oBcoDlQ8HB5XKBxsb4xYnX/FzBdwKAxLoIfc1F5V0cJ
s/1ZIWVooUDyBrFssBGQCpD/BrBvoFIBHhG4A76AC4HlgT9YAiMgnoEeUUDCBeFpbe+xwFVBFzAF
EWIFIBIwC4D9BSEtCvAHEE8zHkEPcFbQnzpwnzEfc0RF5bZ9fTjQAWaAHwBCAAEAAAAgAAAAQQBu
AGkAbAAgAEcAdQByAHUAbQB1AHIAdABoAHkAAAAfAGUAAQAAADYAAABBAG4AaQBsAC4ARwB1AHIA
dQBtAHUAcgB0AGgAeQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAAAB8AZAABAAAACgAAAFMATQBU
AFAAAAAAAAIBQQABAAAAeAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgEEAbgBpAGwAIABHAHUA
cgB1AG0AdQByAHQAaAB5AAAAUwBNAFQAUAAAAEEAbgBpAGwALgBHAHUAcgB1AG0AdQByAHQAaAB5
AEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8AAl0BAAAANgAAAEEAbgBpAGwALgBHAHUAcgB1AG0A
dQByAHQAaAB5AEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAAAAHwDlXwEAAAA+AAAAcwBpAHAAOgBh
AG4AaQBsAC4AZwB1AHIAdQBtAHUAcgB0AGgAeQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAAAB8A
GgwBAAAAIAAAAEEAbgBpAGwAIABHAHUAcgB1AG0AdQByAHQAaAB5AAAAHwAfDAEAAAA2AAAAQQBu
AGkAbAAuAEcAdQByAHUAbQB1AHIAdABoAHkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAAAAfAB4M
AQAAAAoAAABTAE0AVABQAAAAAAACARkMAQAAAHgAAAAAAAAAgSsfpL6jEBmdbgDdAQ9UAgAAAIBB
AG4AaQBsACAARwB1AHIAdQBtAHUAcgB0AGgAeQAAAFMATQBUAFAAAABBAG4AaQBsAC4ARwB1AHIA
dQBtAHUAcgB0AGgAeQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAAFdAQAAADYAAABBAG4AaQBs
AC4ARwB1AHIAdQBtAHUAcgB0AGgAeQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAAAB8A+D8BAAAA
IAAAAEEAbgBpAGwAIABHAHUAcgB1AG0AdQByAHQAaAB5AAAAHwAjQAEAAAA2AAAAQQBuAGkAbAAu
AEcAdQByAHUAbQB1AHIAdABoAHkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAAAAfACJAAQAAAAoA
AABTAE0AVABQAAAAAAACAfk/AQAAAHgAAAAAAAAAgSsfpL6jEBmdbgDdAQ9UAgAAAIBBAG4AaQBs
ACAARwB1AHIAdQBtAHUAcgB0AGgAeQAAAFMATQBUAFAAAABBAG4AaQBsAC4ARwB1AHIAdQBtAHUA
cgB0AGgAeQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAAldAQAAADYAAABBAG4AaQBsAC4ARwB1
AHIAdQBtAHUAcgB0AGgAeQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAAAB8AMUABAAAAAgAAAAAA
AAALAEA6AQAAAB8AMEABAAAAAgAAAAAAAAAfABoAAQAAABIAAABJAFAATQAuAE4AbwB0AGUAAAAA
AAMA8T8JBAAACwBAOgEAAAADAP0/5AQAAAIBCzABAAAAEAAAAHnBcqKjOwBEnDiv75nn8DgDABcA
AQAAAEAAOQAAjyGc7TXPAUAACDA1F7ac7TXPAQsAKQAAAAAACwAjAAAAAAAfAACAhgMCAAAAAADA
AAAAAAAARgEAAAAeAAAAYQBjAGMAZQBwAHQAbABhAG4AZwB1AGEAZwBlAAAAAAABAAAADAAAAGUA
bgAtAFUAUwAAAAsAAIAIIAYAAAAAAMAAAAAAAABGAAAAAAaFAAAAAAAAHwA3AAEAAACaAAAAUgBF
ADoAIABbAFAAQQBUAEMASAAgAHYAMgAgADAAMgAvADIAMwBdACAAYgBmAGEAOgAgAEQAbwAgAG4A
bwB0ACAAYwBhAGwAbAAgAHAAYwBpAF8AZQBuAGEAYgBsAGUAXwBtAHMAaQB4ACgAKQAgAGEAZgB0
AGUAcgAgAGkAdAAgAGYAYQBpAGwAZQBkACAAbwBuAGMAZQAAAAAAHwA9AAEAAAAKAAAAUgBFADoA
IAAAAAAAAwA2AAAAAAADAC4AAAAAAB8AQhABAAAAnAAAADwAZQAxADkAYQBkAGUAMgAzAGQAYgA4
ADAAMQBiADAAYgA0ADMAMQAwADkANAA3AGEAZAAyAGEAZQBiADMAMwA1ADAAYgBjADEAYQBhAGIA
NQAuADEAMwA5ADMAMQA5ADEAMwAzADAALgBnAGkAdAAuAGEAZwBvAHIAZABlAGUAdgBAAHIAZQBk
AGgAYQB0AC4AYwBvAG0APgAAAAIBcQABAAAAGwAAAAEBzzE5ATLavKGZkP9Ovor+KGXMOo2azXhK
QAAfAHAAAQAAAJIAAABbAFAAQQBUAEMASAAgAHYAMgAgADAAMgAvADIAMwBdACAAYgBmAGEAOgAg
AEQAbwAgAG4AbwB0ACAAYwBhAGwAbAAgAHAAYwBpAF8AZQBuAGEAYgBsAGUAXwBtAHMAaQB4ACgA
KQAgAGEAZgB0AGUAcgAgAGkAdAAgAGYAYQBpAGwAZQBkACAAbwBuAGMAZQAAAAAAHwA1EAEAAAB0
AAAAPAAyADAAQgAxAEEAMwBDAEIARAA5ADgARgAzADgANAA1AEIAMwBGADUARgA1ADYARAA4ADUA
OQA3AEUARgA1ADkARgA3AEEAMQBGADcAQABhAHYAbQBiADIALgBxAGwAbwBnAGkAYwAuAG8AcgBn
AD4AAAAfADkQAQAAAPIAAAA8AGMAbwB2AGUAcgAuADEAMwA5ADMAMQA5ADEAMwAzADAALgBnAGkA
dAAuAGEAZwBvAHIAZABlAGUAdgBAAHIAZQBkAGgAYQB0AC4AYwBvAG0APgAgADwAZQAxADkAYQBk
AGUAMgAzAGQAYgA4ADAAMQBiADAAYgA0ADMAMQAwADkANAA3AGEAZAAyAGEAZQBiADMAMwA1ADAA
YgBjADEAYQBhAGIANQAuADEAMwA5ADMAMQA5ADEAMwAzADAALgBnAGkAdAAuAGEAZwBvAHIAZABl
AGUAdgBAAHIAZQBkAGgAYQB0AC4AYwBvAG0APgAAAAAAAwDeP59OAAALAACACCAGAAAAAADAAAAA
AAAARgAAAAADhQAAAAAAAAMAAIAIIAYAAAAAAMAAAAAAAABGAAAAAAGFAAAAAAAAAwCAEP////9A
AAcwVZafm+01zwELAAIAAQAAAAMAJgAAAAAACwArAAAAAAACAUcAAQAAAC8AAABjPVVTO2E9IDtw
PVFMb2dpYztsPUFWTUIyLTE0MDMwMjA4MDEyNlotMTQ4NTg4AAACARAwAQAAAEYAAAAAAAAApfa6
WPiUnECXquZDOkRWvwcAILGjy9mPOEWz9fVthZfvWQAAAPSNGAAAZwQxjMtxokilXd7HughfeQBL
eqWMygAAAAAfAPo/AQAAACAAAABBAG4AaQBsACAARwB1AHIAdQBtAHUAcgB0AGgAeQAAAAMACVkB
AAAAAwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAEIUAAAAAAAALAACACCAGAAAAAADAAAAAAAAARgAA
AAAOhQAAAAAAAAMAAIAIIAYAAAAAAMAAAAAAAABGAAAAABiFAAAAAAAACwAAgAggBgAAAAAAwAAA
AAAAAEYAAAAAgoUAAAAAAAAfAACACCAGAAAAAADAAAAAAAAARgAAAADYhQAAAQAAABIAAABJAFAA
TQAuAE4AbwB0AGUAAAAAAAMADTT9PwAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAIAAAAHgALQBt
AHMALQBoAGEAcwAtAGEAdAB0AGEAYwBoAAAAAQAAAAIAAAAAAAAAHwAAgIYDAgAAAAAAwAAAAAAA
AEYBAAAAIgAAAHgALQBvAHIAaQBnAGkAbgBhAHQAaQBuAGcALQBpAHAAAAAAAAEAAAAYAAAAWwAx
ADAALgAxAC4ANAAuADEAMABdAAAAClA=

--_000_20B1A3CBD98F3845B3F5F56D8597EF59F7A1F7avmb2qlogicorg_--
