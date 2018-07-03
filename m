From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] scsi: mptfusion: mark expected switch fall-throughs
Date: Tue, 3 Jul 2018 17:20:03 -0500
Message-ID: <20180703222003.GA4593@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Warning level 2 was used: -Wimplicit-fallthrough=2

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/message/fusion/mptbase.c | 3 +++
 drivers/message/fusion/mptsas.c  | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index a625ac4..c8c8186 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -642,6 +642,7 @@ mptbase_reply(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req, MPT_FRAME_HDR *reply)
 			freereq = 0;
 		if (event != MPI_EVENT_EVENT_CHANGE)
 			break;
+		/* else: fall through */
 	case MPI_FUNCTION_CONFIG:
 	case MPI_FUNCTION_SAS_IO_UNIT_CONTROL:
 		ioc->mptbase_cmds.status |= MPT_MGMT_STATUS_COMMAND_GOOD;
@@ -1886,6 +1887,7 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	case MPI_MANUFACTPAGE_DEVICEID_FC939X:
 	case MPI_MANUFACTPAGE_DEVICEID_FC949X:
 		ioc->errata_flag_1064 = 1;
+		/* fall through */
 	case MPI_MANUFACTPAGE_DEVICEID_FC909:
 	case MPI_MANUFACTPAGE_DEVICEID_FC929:
 	case MPI_MANUFACTPAGE_DEVICEID_FC919:
@@ -1930,6 +1932,7 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 			pcixcmd &= 0x8F;
 			pci_write_config_byte(pdev, 0x6a, pcixcmd);
 		}
+		/* fall through */
 
 	case MPI_MANUFACTPAGE_DEVID_1030_53C1035:
 		ioc->bus_type = SPI;
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 76a66da..b8cf265 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -4327,6 +4327,7 @@ mptsas_hotplug_work(MPT_ADAPTER *ioc, struct fw_event_work *fw_event,
 			}
 		}
 		mpt_findImVolumes(ioc);
+		/* fall through */
 
 	case MPTSAS_ADD_DEVICE:
 		memset(&sas_device, 0, sizeof(struct mptsas_devinfo));
-- 
2.7.4
