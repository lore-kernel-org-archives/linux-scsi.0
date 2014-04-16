From: Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>
Subject: RE: [PATCH v2 RESEND 02/23] bfa: Do not call pci_enable_msix()
 after it failed once
Date: Wed, 16 Apr 2014 09:03:47 +0000
Message-ID: <20B1A3CBD98F3845B3F5F56D8597EF59F827E4@avmb2.qlogic.org>
References: <cover.1397461652.git.agordeev@redhat.com>
 <f9c36a94438cfb19e45f95111877f6e140b98089.1397461652.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_20B1A3CBD98F3845B3F5F56D8597EF59F827E4avmb2qlogicorg_"
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <f9c36a94438cfb19e45f95111877f6e140b98089.1397461652.git.agordeev@redhat.com>
Content-Language: en-US
Sender: linux-pci-owner@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-pci <linux-pci@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

--_000_20B1A3CBD98F3845B3F5F56D8597EF59F827E4avmb2qlogicorg_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Patch look good.
Acked-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel=
.org] On Behalf Of Alexander Gordeev
Sent: 14 April 2014 13:35
To: linux-kernel
Cc: Alexander Gordeev; Anil Gurumurthy; Vijaya Mohan Guvva; linux-scsi; lin=
ux-pci
Subject: [PATCH v2 RESEND 02/23] bfa: Do not call pci_enable_msix() after i=
t failed once

Function pci_enable_msix() should not be called in case it threw a negative=
 errno from a previous call.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Anil Gurumurthy <agurumur@brocade.com>
Cc: Vijaya Mohan Guvva <vmohan@brocade.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Acked-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
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

--_000_20B1A3CBD98F3845B3F5F56D8597EF59F827E4avmb2qlogicorg_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
AAAfAGQAAQAAAAoAAABTAE0AVABQAAAAAAACAUEAAQAAAHgAAAAAAAAAgSsfpL6jEBmdbgDdAQ9U
AgAAAIBBAG4AaQBsACAARwB1AHIAdQBtAHUAcgB0AGgAeQAAAFMATQBUAFAAAABBAG4AaQBsAC4A
RwB1AHIAdQBtAHUAcgB0AGgAeQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAAJdAQAAADYAAABB
AG4AaQBsAC4ARwB1AHIAdQBtAHUAcgB0AGgAeQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAAAB8A
5V8BAAAAPgAAAHMAaQBwADoAYQBuAGkAbAAuAGcAdQByAHUAbQB1AHIAdABoAHkAQABxAGwAbwBn
AGkAYwAuAGMAbwBtAAAAAAAfABoMAQAAACAAAABBAG4AaQBsACAARwB1AHIAdQBtAHUAcgB0AGgA
eQAAAB8AHwwBAAAANgAAAEEAbgBpAGwALgBHAHUAcgB1AG0AdQByAHQAaAB5AEAAcQBsAG8AZwBp
AGMALgBjAG8AbQAAAAAAHwAeDAEAAAAKAAAAUwBNAFQAUAAAAAAAAgEZDAEAAAB4AAAAAAAAAIEr
H6S+oxAZnW4A3QEPVAIAAACAQQBuAGkAbAAgAEcAdQByAHUAbQB1AHIAdABoAHkAAABTAE0AVABQ
AAAAQQBuAGkAbAAuAEcAdQByAHUAbQB1AHIAdABoAHkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAA
HwABXQEAAAA2AAAAQQBuAGkAbAAuAEcAdQByAHUAbQB1AHIAdABoAHkAQABxAGwAbwBnAGkAYwAu
AGMAbwBtAAAAAAAfAPg/AQAAACAAAABBAG4AaQBsACAARwB1AHIAdQBtAHUAcgB0AGgAeQAAAB8A
I0ABAAAANgAAAEEAbgBpAGwALgBHAHUAcgB1AG0AdQByAHQAaAB5AEAAcQBsAG8AZwBpAGMALgBj
AG8AbQAAAAAAHwAiQAEAAAAKAAAAUwBNAFQAUAAAAAAAAgH5PwEAAAB4AAAAAAAAAIErH6S+oxAZ
nW4A3QEPVAIAAACAQQBuAGkAbAAgAEcAdQByAHUAbQB1AHIAdABoAHkAAABTAE0AVABQAAAAQQBu
AGkAbAAuAEcAdQByAHUAbQB1AHIAdABoAHkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwAJXQEA
AAA2AAAAQQBuAGkAbAAuAEcAdQByAHUAbQB1AHIAdABoAHkAQABxAGwAbwBnAGkAYwAuAGMAbwBt
AAAAAAAfADFAAQAAAAIAAAAAAAAACwBAOgEAAAAfADBAAQAAAAIAAAAAAAAAHwAaAAEAAAASAAAA
SQBQAE0ALgBOAG8AdABlAAAAAAADAPE/CQQAAAsAQDoBAAAAAwD9P+QEAAACAQswAQAAABAAAAD3
a+9iJVQLQL+VKvB0DNUWAwAXAAEAAABAADkAgJuHxlJZzwFAAAgwLASKxlJZzwELACkAAAAAAAsA
IwAAAAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAHgAAAGEAYwBjAGUAcAB0AGwAYQBuAGcAdQBh
AGcAZQAAAAAAAQAAAAwAAABlAG4ALQBVAFMAAAALAACACCAGAAAAAADAAAAAAAAARgAAAAAGhQAA
AAAAAB8ANwABAAAAqAAAAFIARQA6ACAAWwBQAEEAVABDAEgAIAB2ADIAIABSAEUAUwBFAE4ARAAg
ADAAMgAvADIAMwBdACAAYgBmAGEAOgAgAEQAbwAgAG4AbwB0ACAAYwBhAGwAbAAgAHAAYwBpAF8A
ZQBuAGEAYgBsAGUAXwBtAHMAaQB4ACgAKQAgAGEAZgB0AGUAcgAgAGkAdAAgAGYAYQBpAGwAZQBk
ACAAbwBuAGMAZQAAAB8APQABAAAACgAAAFIARQA6ACAAAAAAAAMANgAAAAAAAwAuAAAAAAAfAEIQ
AQAAAJwAAAA8AGYAOQBjADMANgBhADkANAA0ADMAOABjAGYAYgAxADkAZQA0ADUAZgA5ADUAMQAx
ADEAOAA3ADcAZgA2AGUAMQA0ADAAYgA5ADgAMAA4ADkALgAxADMAOQA3ADQANgAxADYANQAyAC4A
ZwBpAHQALgBhAGcAbwByAGQAZQBlAHYAQAByAGUAZABoAGEAdAAuAGMAbwBtAD4AAAACAXEAAQAA
ABsAAAABAc9Xu253k9mwvlAaR7ro7RBq59FYmxP1p0AAHwBwAAEAAACgAAAAWwBQAEEAVABDAEgA
IAB2ADIAIABSAEUAUwBFAE4ARAAgADAAMgAvADIAMwBdACAAYgBmAGEAOgAgAEQAbwAgAG4AbwB0
ACAAYwBhAGwAbAAgAHAAYwBpAF8AZQBuAGEAYgBsAGUAXwBtAHMAaQB4ACgAKQAgAGEAZgB0AGUA
cgAgAGkAdAAgAGYAYQBpAGwAZQBkACAAbwBuAGMAZQAAAB8ANRABAAAAdAAAADwAMgAwAEIAMQBB
ADMAQwBCAEQAOQA4AEYAMwA4ADQANQBCADMARgA1AEYANQA2AEQAOAA1ADkANwBFAEYANQA5AEYA
OAAyADcARQA0AEAAYQB2AG0AYgAyAC4AcQBsAG8AZwBpAGMALgBvAHIAZwA+AAAAHwA5EAEAAADy
AAAAPABjAG8AdgBlAHIALgAxADMAOQA3ADQANgAxADYANQAyAC4AZwBpAHQALgBhAGcAbwByAGQA
ZQBlAHYAQAByAGUAZABoAGEAdAAuAGMAbwBtAD4AIAA8AGYAOQBjADMANgBhADkANAA0ADMAOABj
AGYAYgAxADkAZQA0ADUAZgA5ADUAMQAxADEAOAA3ADcAZgA2AGUAMQA0ADAAYgA5ADgAMAA4ADkA
LgAxADMAOQA3ADQANgAxADYANQAyAC4AZwBpAHQALgBhAGcAbwByAGQAZQBlAHYAQAByAGUAZABo
AGEAdAAuAGMAbwBtAD4AAAAAAAMA3j+fTgAACwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAA4UAAAAA
AAADAACACCAGAAAAAADAAAAAAAAARgAAAAABhQAAAAAAAAMAgBD/////QAAHMKzZYsVSWc8BCwAC
AAEAAAADACYAAAAAAAsAKwAAAAAAAgFHAAEAAAAvAAAAYz1VUzthPSA7cD1RTG9naWM7bD1BVk1C
Mi0xNDA0MTYwOTAzNDdaLTE4OTU1MAAAAgEQMAEAAABGAAAAAAAAAKX2ulj4lJxAl6rmQzpEVr8H
ACCxo8vZjzhFs/X1bYWX71kAAAD0jRgAAGcEMYzLcaJIpV3ex7oIX3kAS3qljZcAAAAAHwD6PwEA
AAAgAAAAQQBuAGkAbAAgAEcAdQByAHUAbQB1AHIAdABoAHkAAAADAAlZAQAAAAMAAIAIIAYAAAAA
AMAAAAAAAABGAAAAABCFAAAAAAAACwAAgAggBgAAAAAAwAAAAAAAAEYAAAAADoUAAAAAAAADAACA
CCAGAAAAAADAAAAAAAAARgAAAAAYhQAAAAAAAAsAAIAIIAYAAAAAAMAAAAAAAABGAAAAAIKFAAAA
AAAAHwAAgAggBgAAAAAAwAAAAAAAAEYAAAAA2IUAAAEAAAASAAAASQBQAE0ALgBOAG8AdABlAAAA
AAADAA00/T8AAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAACAAAAB4AC0AbQBzAC0AaABhAHMALQBh
AHQAdABhAGMAaAAAAAEAAAACAAAAAAAAAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAACIAAAB4AC0A
bwByAGkAZwBpAG4AYQB0AGkAbgBnAC0AaQBwAAAAAAABAAAAGAAAAFsAMQAwAC4AMQAuADQALgAx
ADAAXQAAAIdW

--_000_20B1A3CBD98F3845B3F5F56D8597EF59F827E4avmb2qlogicorg_--
