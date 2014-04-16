From: Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>
Subject: RE: [PATCH v2 RESEND 04/23] bfa: Use pci_enable_msix_exact()
 instead of pci_enable_msix()
Date: Wed, 16 Apr 2014 09:05:10 +0000
Message-ID: <20B1A3CBD98F3845B3F5F56D8597EF59F827FE@avmb2.qlogic.org>
References: <cover.1397461652.git.agordeev@redhat.com>
 <7db0ca73195c7a4b41ec8263e23ffaeb7ff4dce2.1397461652.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_20B1A3CBD98F3845B3F5F56D8597EF59F827FEavmb2qlogicorg_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avcashub1.qlogic.com ([198.70.193.115]:22804 "EHLO
	avcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaDPMLS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Apr 2014 08:11:18 -0400
In-Reply-To: <7db0ca73195c7a4b41ec8263e23ffaeb7ff4dce2.1397461652.git.agordeev@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-pci <linux-pci@vger.kernel.org>

--_000_20B1A3CBD98F3845B3F5F56D8597EF59F827FEavmb2qlogicorg_
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
Subject: [PATCH v2 RESEND 04/23] bfa: Use pci_enable_msix_exact() instead o=
f pci_enable_msix()

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers using these two in=
terfaces need to be updated to use the new pci_enable_msi_range()  or pci_e=
nable_msi_exact() and pci_enable_msix_range() or pci_enable_msix_exact() in=
terfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Anil Gurumurthy <agurumur@brocade.com>
Cc: Vijaya Mohan Guvva <vmohan@brocade.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/bfa/bfad.c |   20 ++++++--------------
 1 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c index e7e477=
4..839c81c 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -1234,29 +1234,21 @@ bfad_setup_intr(struct bfad_s *bfad)
        if ((bfa_asic_id_ctc(pdev->device) && !msix_disable_ct) ||
           (bfa_asic_id_cb(pdev->device) && !msix_disable_cb)) {

-               error =3D pci_enable_msix(bfad->pcidev, msix_entries, bfad-=
>nvec);
+               error =3D pci_enable_msix_exact(bfad->pcidev,
+                                             msix_entries, bfad->nvec);
                /* In CT1 & CT2, try to allocate just one vector */
-               if (error > 0 && bfa_asic_id_ctc(pdev->device)) {
+               if (error =3D=3D -ENOSPC && bfa_asic_id_ctc(pdev->device)) =
{
                        printk(KERN_WARNING "bfa %s: trying one msix "
                               "vector failed to allocate %d[%d]\n",
                               bfad->pci_name, bfad->nvec, error);
                        bfad->nvec =3D 1;
-                       error =3D pci_enable_msix(bfad->pcidev,
-                                               msix_entries, bfad->nvec);
+                       error =3D pci_enable_msix_exact(bfad->pcidev,
+                                                     msix_entries, 1);
                }

-               /*
-                * Only error number of vector is available.
-                * We don't have a mechanism to map multiple
-                * interrupts into one vector, so even if we
-                * can try to request less vectors, we don't
-                * know how to associate interrupt events to
-                *  vectors. Linux doesn't duplicate vectors
-                * in the MSIX table for this case.
-                */
                if (error) {
                        printk(KERN_WARNING "bfad%d: "
-                              "pci_enable_msix failed (%d), "
+                              "pci_enable_msix_exact failed (%d), "
                               "use line based.\n",
                                bfad->inst_no, error);
                        goto line_based;
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

--_000_20B1A3CBD98F3845B3F5F56D8597EF59F827FEavmb2qlogicorg_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
AABBAG4AaQBsAC4ARwB1AHIAdQBtAHUAcgB0AGgAeQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAf
AAJdAQAAADYAAABBAG4AaQBsAC4ARwB1AHIAdQBtAHUAcgB0AGgAeQBAAHEAbABvAGcAaQBjAC4A
YwBvAG0AAAAAAB8A5V8BAAAAPgAAAHMAaQBwADoAYQBuAGkAbAAuAGcAdQByAHUAbQB1AHIAdABo
AHkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAAAAfABoMAQAAACAAAABBAG4AaQBsACAARwB1AHIA
dQBtAHUAcgB0AGgAeQAAAB8AHwwBAAAANgAAAEEAbgBpAGwALgBHAHUAcgB1AG0AdQByAHQAaAB5
AEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAAAAHwAeDAEAAAAKAAAAUwBNAFQAUAAAAAAAAgEZDAEA
AAB4AAAAAAAAAIErH6S+oxAZnW4A3QEPVAIAAACAQQBuAGkAbAAgAEcAdQByAHUAbQB1AHIAdABo
AHkAAABTAE0AVABQAAAAQQBuAGkAbAAuAEcAdQByAHUAbQB1AHIAdABoAHkAQABxAGwAbwBnAGkA
YwAuAGMAbwBtAAAAHwABXQEAAAA2AAAAQQBuAGkAbAAuAEcAdQByAHUAbQB1AHIAdABoAHkAQABx
AGwAbwBnAGkAYwAuAGMAbwBtAAAAAAAfAPg/AQAAACAAAABBAG4AaQBsACAARwB1AHIAdQBtAHUA
cgB0AGgAeQAAAB8AI0ABAAAANgAAAEEAbgBpAGwALgBHAHUAcgB1AG0AdQByAHQAaAB5AEAAcQBs
AG8AZwBpAGMALgBjAG8AbQAAAAAAHwAiQAEAAAAKAAAAUwBNAFQAUAAAAAAAAgH5PwEAAAB4AAAA
AAAAAIErH6S+oxAZnW4A3QEPVAIAAACAQQBuAGkAbAAgAEcAdQByAHUAbQB1AHIAdABoAHkAAABT
AE0AVABQAAAAQQBuAGkAbAAuAEcAdQByAHUAbQB1AHIAdABoAHkAQABxAGwAbwBnAGkAYwAuAGMA
bwBtAAAAHwAJXQEAAAA2AAAAQQBuAGkAbAAuAEcAdQByAHUAbQB1AHIAdABoAHkAQABxAGwAbwBn
AGkAYwAuAGMAbwBtAAAAAAAfADFAAQAAAAIAAAAAAAAACwBAOgEAAAAfADBAAQAAAAIAAAAAAAAA
HwAaAAEAAAASAAAASQBQAE0ALgBOAG8AdABlAAAAAAADAPE/CQQAAAsAQDoBAAAAAwD9P+QEAAAC
AQswAQAAABAAAAB6msIlZWRLR40ik8v3ZnFqAwAXAAEAAABAADkAAGcA+FJZzwFAAAgw7KaL+FJZ
zwELACkAAAAAAAsAIwAAAAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAHgAAAGEAYwBjAGUAcAB0
AGwAYQBuAGcAdQBhAGcAZQAAAAAAAQAAAAwAAABlAG4ALQBVAFMAAAALAACACCAGAAAAAADAAAAA
AAAARgAAAAAGhQAAAAAAAB8ANwABAAAAtAAAAFIARQA6ACAAWwBQAEEAVABDAEgAIAB2ADIAIABS
AEUAUwBFAE4ARAAgADAANAAvADIAMwBdACAAYgBmAGEAOgAgAFUAcwBlACAAcABjAGkAXwBlAG4A
YQBiAGwAZQBfAG0AcwBpAHgAXwBlAHgAYQBjAHQAKAApACAAaQBuAHMAdABlAGEAZAAgAG8AZgAg
AHAAYwBpAF8AZQBuAGEAYgBsAGUAXwBtAHMAaQB4ACgAKQAAAB8APQABAAAACgAAAFIARQA6ACAA
AAAAAAMANgAAAAAAAwAuAAAAAAAfAEIQAQAAAJwAAAA8ADcAZABiADAAYwBhADcAMwAxADkANQBj
ADcAYQA0AGIANAAxAGUAYwA4ADIANgAzAGUAMgAzAGYAZgBhAGUAYgA3AGYAZgA0AGQAYwBlADIA
LgAxADMAOQA3ADQANgAxADYANQAyAC4AZwBpAHQALgBhAGcAbwByAGQAZQBlAHYAQAByAGUAZABo
AGEAdAAuAGMAbwBtAD4AAAACAXEAAQAAABsAAAABAc9Xu3x8NkjPoIs9RYnC0Isd2YUumxP2R3AA
HwBwAAEAAACsAAAAWwBQAEEAVABDAEgAIAB2ADIAIABSAEUAUwBFAE4ARAAgADAANAAvADIAMwBd
ACAAYgBmAGEAOgAgAFUAcwBlACAAcABjAGkAXwBlAG4AYQBiAGwAZQBfAG0AcwBpAHgAXwBlAHgA
YQBjAHQAKAApACAAaQBuAHMAdABlAGEAZAAgAG8AZgAgAHAAYwBpAF8AZQBuAGEAYgBsAGUAXwBt
AHMAaQB4ACgAKQAAAB8ANRABAAAAdAAAADwAMgAwAEIAMQBBADMAQwBCAEQAOQA4AEYAMwA4ADQA
NQBCADMARgA1AEYANQA2AEQAOAA1ADkANwBFAEYANQA5AEYAOAAyADcARgBFAEAAYQB2AG0AYgAy
AC4AcQBsAG8AZwBpAGMALgBvAHIAZwA+AAAAHwA5EAEAAADyAAAAPABjAG8AdgBlAHIALgAxADMA
OQA3ADQANgAxADYANQAyAC4AZwBpAHQALgBhAGcAbwByAGQAZQBlAHYAQAByAGUAZABoAGEAdAAu
AGMAbwBtAD4AIAA8ADcAZABiADAAYwBhADcAMwAxADkANQBjADcAYQA0AGIANAAxAGUAYwA4ADIA
NgAzAGUAMgAzAGYAZgBhAGUAYgA3AGYAZgA0AGQAYwBlADIALgAxADMAOQA3ADQANgAxADYANQAy
AC4AZwBpAHQALgBhAGcAbwByAGQAZQBlAHYAQAByAGUAZABoAGEAdAAuAGMAbwBtAD4AAAAAAAMA
3j+fTgAACwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAA4UAAAAAAAADAACACCAGAAAAAADAAAAAAAAA
RgAAAAABhQAAAAAAAAMAgBD/////QAAHMKy5X/dSWc8BCwACAAEAAAADACYAAAAAAAsAKwAAAAAA
AgFHAAEAAAAvAAAAYz1VUzthPSA7cD1RTG9naWM7bD1BVk1CMi0xNDA0MTYwOTA1MTBaLTE4OTU1
MgAAAgEQMAEAAABGAAAAAAAAAKX2ulj4lJxAl6rmQzpEVr8HACCxo8vZjzhFs/X1bYWX71kAAAD0
jRgAAGcEMYzLcaJIpV3ex7oIX3kAS3qljZkAAAAAHwD6PwEAAAAgAAAAQQBuAGkAbAAgAEcAdQBy
AHUAbQB1AHIAdABoAHkAAAADAAlZAQAAAAMAAIAIIAYAAAAAAMAAAAAAAABGAAAAABCFAAAAAAAA
CwAAgAggBgAAAAAAwAAAAAAAAEYAAAAADoUAAAAAAAADAACACCAGAAAAAADAAAAAAAAARgAAAAAY
hQAAAAAAAAsAAIAIIAYAAAAAAMAAAAAAAABGAAAAAIKFAAAAAAAAHwAAgAggBgAAAAAAwAAAAAAA
AEYAAAAA2IUAAAEAAAASAAAASQBQAE0ALgBOAG8AdABlAAAAAAADAA00/T8AAB8AAICGAwIAAAAA
AMAAAAAAAABGAQAAACAAAAB4AC0AbQBzAC0AaABhAHMALQBhAHQAdABhAGMAaAAAAAEAAAACAAAA
AAAAAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAACIAAAB4AC0AbwByAGkAZwBpAG4AYQB0AGkAbgBn
AC0AaQBwAAAAAAABAAAAGAAAAFsAMQAwAC4AMQAuADQALgAxADAAXQAAACU1

--_000_20B1A3CBD98F3845B3F5F56D8597EF59F827FEavmb2qlogicorg_--
