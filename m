From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 1/2] xhci: Add broken-streams quirk for Fresco Logic FL1000G xhci controllers
Date: Fri,  5 Dec 2014 11:11:28 +0100
Message-ID: <1417774289-15025-1-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Mathias Nyman <mathias.nyman@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: =?UTF-8?q?Marcin=20Zaj=C4=85czkowski?= <mszpak@wp.pl>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Streams do not work reliabe on Fresco Logic FL1000G xhci controllers,
trying to use them results in errors like this:

21:37:33 kernel: xhci_hcd 0000:04:00.0: ERROR Transfer event for disabl=
ed endpoint or incorrect stream ring
21:37:33 kernel: xhci_hcd 0000:04:00.0: @00000000368b3570 9067b000 0000=
0000 05000000 01078001
21:37:33 kernel: xhci_hcd 0000:04:00.0: ERROR Transfer event for disabl=
ed endpoint or incorrect stream ring
21:37:33 kernel: xhci_hcd 0000:04:00.0: @00000000368b3580 9067b400 0000=
0000 05000000 01038001

As always I've ordered a pci-e addon card with a Fresco Logic controlle=
r for
myself to see if I can come up with a better fix then the big hammer, i=
n
the mean time this will make uas devices work again (in usb-storage mod=
e)
for FL1000G users.

Reported-by: Marcin Zaj=C4=85czkowski <mszpak@wp.pl>
Cc: stable@vger.kernel.org # 3.15
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/host/xhci-pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 9a69b1f..e1071ce 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -82,6 +82,8 @@ static void xhci_pci_quirks(struct device *dev, struc=
t xhci_hcd *xhci)
 				"must be suspended extra slowly",
 				pdev->revision);
 		}
+		if (pdev->device =3D=3D PCI_DEVICE_ID_FRESCO_LOGIC_PDK)
+			xhci->quirks |=3D XHCI_BROKEN_STREAMS;
 		/* Fresco Logic confirms: all revisions of this chip do not
 		 * support MSI, even though some of them claim to in their PCI
 		 * capabilities.
--=20
2.1.0
