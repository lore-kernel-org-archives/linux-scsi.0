From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] [RFC] [SCSI] mpt fusion: add support for 0x1000/0x0055
Date: Sat, 21 Jul 2012 00:03:52 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1207210000190.21929@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34051 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173Ab2GTWEC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jul 2012 18:04:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <Eric.Moore@lsi.com>, James Bottomley <JBottomley@Parallels.com>, "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Cc: DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The device identifies itself as

0d:05.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068 PCI-X Fusion-MPT SAS (rev 01) Subsystem: NEC Corporation SAS1068

and seems to be functionally compatible with 0x0054 PID.

The request for support of this device has been raised on mailinglists several
times in the past (see [1] [2] and more), but aparently the PCI ID never made it
to mptsas_pci_table[].

[1] http://comments.gmane.org/gmane.linux.scsi/63836
[2] http://lkml.indiana.edu/hypermail/linux/kernel/0701.2/1715.html

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---


I guess the "Subsystem: NEC Corporation" is telling us some rebranding 
story, including the PID change ... ?



 drivers/message/fusion/lsi/mpi_cnfg.h |    1 +
 drivers/message/fusion/mptsas.c       |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/message/fusion/lsi/mpi_cnfg.h b/drivers/message/fusion/lsi/mpi_cnfg.h
index d9bcfba..29d54c9 100644
--- a/drivers/message/fusion/lsi/mpi_cnfg.h
+++ b/drivers/message/fusion/lsi/mpi_cnfg.h
@@ -582,6 +582,7 @@ typedef struct _MSG_CONFIG_REPLY
 #define MPI_MANUFACTPAGE_DEVID_SAS1066              (0x005E)
 #define MPI_MANUFACTPAGE_DEVID_SAS1066E             (0x005A)
 #define MPI_MANUFACTPAGE_DEVID_SAS1068              (0x0054)
+#define MPI_MANUFACTPAGE_DEVID_SAS1068_2            (0x0055)
 #define MPI_MANUFACTPAGE_DEVID_SAS1068E             (0x0058)
 #define MPI_MANUFACTPAGE_DEVID_SAS1068_820XELP      (0x0059)
 #define MPI_MANUFACTPAGE_DEVID_SAS1078              (0x0062)
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 551262e..2475f8c 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -5370,6 +5370,8 @@ static struct pci_device_id mptsas_pci_table[] = {
 		PCI_ANY_ID, PCI_ANY_ID },
 	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_SAS1068,
 		PCI_ANY_ID, PCI_ANY_ID },
+	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_SAS1068_2,
+		PCI_ANY_ID, PCI_ANY_ID },
 	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_SAS1064E,
 		PCI_ANY_ID, PCI_ANY_ID },
 	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_SAS1068E,

-- 
Jiri Kosina
SUSE Labs
