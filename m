From: Arvind Kumar <arvindkumar@vmware.com>
Subject: RE: [PATCH v2 RESEND 23/23] vmw_pvscsi: Use pci_enable_msix_exact()
 instead of pci_enable_msix()
Date: Wed, 16 Jul 2014 18:23:23 +0000
Message-ID: <9424d275bdc34133a03a68877ab253d0@EX13-MBX-025.vmware.com>
References: <cover.1405533479.git.agordeev@redhat.com>,<c27a72eaa07631ca182bfdb71d0d3d7f9f280b26.1405533479.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <c27a72eaa07631ca182bfdb71d0d3d7f9f280b26.1405533479.git.agordeev@redhat.com>
Content-Language: en-US
Sender: linux-pci-owner@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "pv-drivers@vmware.com" <pv-drivers@vmware.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Alexander,

This looks fine to me.

Acked-by: Arvind Kumar <arvindkumar@vmware.com>

Thanks!
Arvind
________________________________________
From: Alexander Gordeev <agordeev@redhat.com>
Sent: Wednesday, July 16, 2014 11:05 AM
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev; Arvind Kumar; pv-drivers@vmware.com; linux-scsi@vger.kernel.org; linux-pci@vger.kernel.org
Subject: [PATCH v2 RESEND 23/23] vmw_pvscsi: Use pci_enable_msix_exact() instead of pci_enable_msix()

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range()  or pci_enable_msi_exact()
and pci_enable_msix_range() or pci_enable_msix_exact()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Arvind Kumar <arvindkumar@vmware.com>
Cc: pv-drivers@vmware.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Acked-by: Arvind Kumar <arvindkumar@vmware.com>
---
 drivers/scsi/vmw_pvscsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index c88e146..598f65e 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -1194,7 +1194,7 @@ static int pvscsi_setup_msix(const struct pvscsi_adapter *adapter,
        struct msix_entry entry = { 0, PVSCSI_VECTOR_COMPLETION };
        int ret;

-       ret = pci_enable_msix(adapter->dev, &entry, 1);
+       ret = pci_enable_msix_exact(adapter->dev, &entry, 1);
        if (ret)
                return ret;

--
1.7.7.6
