From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH][RFC 1/4/4/5] iSCSI-SCST's Makefile and Kconfig
Date: Tue, 13 Apr 2010 17:10:08 +0400
Message-ID: <4BC46D30.7040609@vlnb.net>
References: <4BC44A49.7070307@vlnb.net> <4BC45AFA.7060403@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4BC45AFA.7060403@vlnb.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Linus Torvalds <torvalds@linux-foundation.org>, Bart Van Assche <bart.vanassche@gmail.com>
List-Id: linux-scsi@vger.kernel.org

This patch contains iSCSI-SCST's Makefile and Kconfig.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
 Kconfig  |   25 +++++++++++++++++++++++++
 Makefile |    6 ++++++
 2 files changed, 31 insertions(+)
 
diff -uprN orig/linux-2.6.33/drivers/scst/iscsi-scst/Makefile linux-2.6.33/drivers/scst/iscsi-scst/Makefile
--- orig/linux-2.6.33/drivers/scst/iscsi-scst/Makefile
+++ linux-2.6.33/drivers/scst/iscsi-scst/Makefile
@@ -0,0 +1,6 @@
+EXTRA_CFLAGS += -Iinclude/scst
+
+iscsi-scst-y := iscsi.o nthread.o config.o digest.o \
+	conn.o session.o target.o event.o param.o
+
+obj-$(CONFIG_SCST_ISCSI) += iscsi-scst.o
diff -uprN orig/linux-2.6.33/drivers/scst/iscsi-scst/Kconfig linux-2.6.33/drivers/scst/iscsi-scst/Kconfig
--- orig/linux-2.6.33/drivers/scst/iscsi-scst/Kconfig
+++ linux-2.6.33/drivers/scst/iscsi-scst/Kconfig
@@ -0,0 +1,25 @@
+config SCST_ISCSI
+	tristate "ISCSI Target"
+	depends on SCST && INET
+	default SCST
+	help
+	  ISCSI target driver for SCST framework. The iSCSI protocol has been
+	  defined in RFC 3720. To use it you should download from
+	  http://scst.sourceforge.net the user space part of it.
+
+config SCST_ISCSI_DEBUG_DIGEST_FAILURES
+	bool "Simulate iSCSI digest failures"
+	depends on SCST_ISCSI
+	help
+	  Simulates iSCSI digest failures in random places. Even when iSCSI
+	  traffic is sent over a TCP connection, the 16-bit TCP checksum is too
+	  weak for the requirements of a storage protocol. Furthermore, there
+	  are also instances where the TCP checksum does not protect iSCSI
+	  data, as when data is corrupted while being transferred on a PCI bus
+	  or while in memory. The iSCSI protocol therefore defines a 32-bit CRC
+	  digest on iSCSI packets in order to detect data corruption on an
+	  end-to-end basis. CRCs can be used on iSCSI PDU headers and/or data.
+	  Enabling this option allows to test digest failure recovery in the
+	  iSCSI initiator that is talking to SCST.
+
+	  If unsure, say "N".
