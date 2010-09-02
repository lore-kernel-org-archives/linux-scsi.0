From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] tcm: Add support for Extended INQUIRY Data VPD Page
Date: Wed,  1 Sep 2010 19:51:47 -0700
Message-ID: <1283395907-15547-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings all,

This small patch updates transport_generic_emulate_inquiry() to add support for
the Extended INQUIRY Data VPD Page in spc4r23 section 7.7.5.

By default, this page returns HEADSUP, ORDSUP, SIMPSUP bits enabled for
SCSI Tasks Attr emulation.  It also will set V_SUP (volatile cache supported)
when DEV_ATTRIB(dev)->emulate_write_cache is enabled for FILEIO or IBLOCK
backstores.

There is how it looks using 'sg_inq -ve $DEV' with emulate_write_cache=1:

target:/mnt/sdb/lio-core-2.6.git# sg_inq -ve /dev/sdg
VPD INQUIRY: extended INQUIRY data page
    inquiry cdb: 12 01 86 00 fc 00
    inquiry cdb: 12 01 86 3c 04 00
  SPT=0 GRD_CHK=0 APP_CHK=0 REF_CHK=0
  GRP_SUP=0 PRIOR_SUP=0 HEADSUP=1 ORDSUP=1 SIMPSUP=1
  CORR_D_SUP=0 NV_SUP=0 V_SUP=1 LUICLR=0

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ec67cb6..fbbe9fc 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4499,6 +4499,7 @@ after_tpgs:
 		buf[4] = 0x0;
 		buf[5] = 0x80;
 		buf[6] = 0x83;
+		buf[7] = 0x86;
 		len = 3;
 		break;
 	case 0x80: /* unit serial number */
@@ -4816,6 +4817,22 @@ set_len:
 		buf[2] = ((len >> 8) & 0xff);
 		buf[3] = (len & 0xff); /* Page Length for VPD 0x83 */
 		break;
+	case 0x86: /* Extended INQUIRY Data VPD Page */
+		/*
+		 * This page uses a hardcoded value of 60
+		 */
+		if (cmd->data_length < 60)
+			return 0;
+
+		buf[1] = 0x86;
+		buf[2] = 0x3c;
+		/* Set HEADSUP, ORDSUP, SIMPSUP */
+		buf[5] = 0x07;
+		/* If WriteCache emulation is enabled, set V_SUP */
+		if (DEV_ATTRIB(dev)->emulate_write_cache > 0)
+			buf[6] = 0x01;
+
+		break;
 	default:
 		printk(KERN_ERR "Unknown VPD Code: 0x%02x\n", cdb[2]);
 		return -1;
-- 
1.5.6.5
