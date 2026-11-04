Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831158;
	b=oEGo7ydGifkA+f1m/Q3Qq6vq2xQWe25Yu0gKwb3fRX6qP+GoMyQbd7EdBiwwem0sPciv
	 uMr/asZZrj3UXMnXotfgxqyx7sKGbPvo0VvbetGOom2pLj7CifTV7qmMHUVVpKbEXEtuD
	 fLa+Z7goIVrzwYyxHpl9eE3U/wnWFBC2zOwWdVcevzpuYY9UgK+xvFto70HgdbBasRrPt
	 2JdSTaotHJ7BldZWCzj4gR1IuE1iDQakX4Y5pZyfkH3mmY3BgVYDEN0IZtOjTv6IPUoD5
	 ZTA73wG3L03BYTT/VOU8cuVHGFf9kV/GBhPVjZmKmQ59eoIwRZdI4NC+40+7iKmikVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831158;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:MIME-Version:Content-Transfer-Encoding:X-Scanned-By;
	bh=RqrFAViIXrjiourMrnhARQFUmFJOsUN3fk+kD/PpH0c=;
	b=iv7c8G81J+QTYeYfyOghQPK38l6aZrunc83XX1xYTcxtxxHyTQXrsFbfJmH3njKH0JFS
	 j2dcd4+JasuG+znl6OnfFBmcqZlvETbMs4nD391edwGSm8+sFo8+9GRKcjlKhEGNtwMui
	 57XejHa6iOa4gxIFPS9aY0BqrKjsY6lnu0eQ4PEP52si8nIKJpJYD4BtwD7cldoZLP7EG
	 oXefze9NsC9sjuv/UfSOGqeL2R5v0YjbK3sivGEyOO7n5yDB9NprO9VF2wjawwCV2QFxm
	 UDIyxHMD6932nh1StUjRW/tHs3vbl3qo+Jc/G5B2Bgk6jRrCmqMZL6RmUA33xQQFIBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=dZsfB+7O;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B68E606D83D
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 22:25:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9B68E606D83D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=dZsfB+7O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793831156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RqrFAViIXrjiourMrnhARQFUmFJOsUN3fk+kD/PpH0c=;
	b=dZsfB+7Of5uttp5x/CwczGi/p78VyOJJ9idj+0XF9Cfrn9xpWUZJyHM4ZawaJjnBjGehbU
	6mWLjHNa360fKeVrhMsARuatwm6uuscWnA0tW8ObkqV/puWdXWFAOWHkErMsLZvXyS1gKt
	UgjPr6q8ir95d6YKKhn8/l44wMhyo1k=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-463-ty3QX41dNgqrG3pXvAa2xg-1; Wed,
 04 Nov 2026 17:25:51 -0500
X-MC-Unique: ty3QX41dNgqrG3pXvAa2xg-1
X-Mimecast-MFC-AGG-ID: ty3QX41dNgqrG3pXvAa2xg_1793831149
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C26C41956041;
	Wed,  4 Nov 2026 22:25:48 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 904451956087;
	Wed,  4 Nov 2026 22:25:46 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: njavali@marvell.com,
	martin.petersen@oracle.com
Cc: GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	longli@microsoft.com,
	mhklinux@outlook.com,
	sbhat@linux.ibm.com,
	kmahlkuc@linux.ibm.com,
	linux-scsi@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH] scsi: qla2xxx: Use the real INTx pin for the port number on Hyper-V guests
Date: Wed,  4 Nov 2026 17:25:41 -0500
Message-ID: <20261104222541.2675051-1-loberman@redhat.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

qla2x00_set_isp_flags() derives the physical port number from
PCI_INTERRUPT_PIN, and the port number selects the per-port VPD, NVRAM,
NPIV and FCP priority flash regions.

On Hyper-V guests, pci-hyperv returns 0 for byte and word reads of
PCI_INTERRUPT_PIN since commit fea93a3e5d5e ("PCI: hv: Return zero, not
garbage, when reading PCI_INTERRUPT_PIN"). Commit 7268e509b43a ("scsi:
qla2xxx: Handle INTx not connected while passing through") then falls
back to PCI_FUNC(). With Discrete Device Assignment (DDA), each function
of a multi-port HBA is presented as function 0 in its own PCI domain, so
every port gets port_no 0. All ports read port 0's NVRAM, pass the
checksum and register the same WWPN, and nothing is logged.

Without that commit, port_no underflows to 255, no flash region is
selected and every port fails with "Inconsistent NVRAM checksum" and
falls back to the default WWPN.

pci-hyperv only zeroes byte and word accesses within 0x3c-0x3d. A dword
read at PCI_INTERRUPT_LINE reaches the device's config space and returns
the real pin in bits 15:8. On Hyper-V guests, use that when the byte
read returns 0, and warn if the pin is still 0 so that duplicate WWPNs
are not silent. Bare metal, KVM/vfio and other hypervisors are
unchanged.

Tested with an equivalent change on a RHEL 9 (5.14-based) guest with a
dual-port QLE2692 (ISP2261) assigned through DDA (Hyper-V host
10.0.17763):

  before: both ports "Inconsistent NVRAM checksum=0xffffffc0 id=NGKP",
          both WWPN 0x210000e08b1c5586
  after:  port_no 1 and 0, NVRAM valid, WWPN 0x210034800d7065bd and
          0x210034800d7065bc, fabric login and FC-NVMe localport
          registration on both ports

Also tested on bare metal (ISP2031): the new path is not taken and port
numbers and WWPNs are unchanged.

Signed-off-by: Laurence Oberman <loberman@redhat.com>
---
RFC: this relies on pci-hyperv not virtualizing dword reads at 0x3c,
which is an implementation detail rather than an interface. It is posted
as the smallest working fix and to start the discussion. Feedback wanted
on cleaner alternatives:

 - Hyper-V (linux-hyperv): could pci-hyperv expose the real
   PCI_INTERRUPT_PIN, or provide the physical function number, for DDA
   devices? Some drivers use the pin for port identity, not only for
   interrupt routing.

 - Marvell: is there a firmware or register source for the physical
   port that does not depend on PCI config space? CSRX_FUNCTION in
   ctrl_status is a single bit and would not cover quad-port
   27xx/28xx/29xx.

 - The check is x86-only (hypervisor_is_type()). pci-hyperv also
   supports arm64 guests; a better way to detect a pci-hyperv bus is
   welcome.

This has not yet been tested on a 7.3 kernel in the DDA guest; testing
was on a RHEL 9.8 backport. The upstream behaviour without this patch
(duplicate WWPNs with no warning) follows from the code and has not yet
been reproduced on 7.3.

 drivers/scsi/qla2xxx/qla_os.c | 40 ++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3c412c7fb6fe..4180d3f15231 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -24,6 +24,10 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_fc.h>
 
+#ifdef CONFIG_X86
+#include <asm/hypervisor.h>
+#endif
+
 #include "qla_target.h"
 
 /*
@@ -2704,6 +2708,40 @@ static struct isp_operations qla29xx_isp_ops = {
 	.initialize_adapter	= qla2x00_initialize_adapter,
 };
 
+/*
+ * Read the INTx pin used to derive the physical port number.
+ *
+ * pci-hyperv hard-wires byte and word reads of PCI_INTERRUPT_PIN to zero.
+ * With Hyper-V Discrete Device Assignment every function is also presented
+ * as function 0 in its own PCI domain, so the PCI_FUNC() fallback gives
+ * port 0 for every port and they all report port 0's WWPN. A dword read at
+ * PCI_INTERRUPT_LINE is not virtualized by pci-hyperv and returns the
+ * device's pin in bits 15:8, so use that on Hyper-V guests.
+ */
+static u8
+qla2x00_get_intx_pin(struct qla_hw_data *ha)
+{
+	u8 pin;
+
+	pci_read_config_byte(ha->pdev, PCI_INTERRUPT_PIN, &pin);
+#ifdef CONFIG_X86
+	if (!pin && hypervisor_is_type(X86_HYPER_MS_HYPERV)) {
+		u32 val = 0;
+
+		pci_read_config_dword(ha->pdev, PCI_INTERRUPT_LINE, &val);
+		pin = (val >> 8) & 0xff;
+		if (pin)
+			ql_log_pci(ql_log_info, ha->pdev, 0xffff,
+				   "Hyper-V: INTx pin reads 0, config dword 0x%08x gives pin %u.\n",
+				   val, pin);
+		else
+			ql_log_pci(ql_log_warn, ha->pdev, 0xffff,
+				   "Hyper-V: unable to determine physical port, ports may report duplicate WWPNs.\n");
+	}
+#endif
+	return pin;
+}
+
 static inline void
 qla2x00_set_isp_flags(struct qla_hw_data *ha)
 {
@@ -2887,7 +2925,7 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
 		ha->port_no = ha->portnum & 1;
 	else {
 		/* Get adapter physical port no from interrupt pin register. */
-		pci_read_config_byte(ha->pdev, PCI_INTERRUPT_PIN, &ha->port_no);
+		ha->port_no = qla2x00_get_intx_pin(ha);
 		if (ha->port_no == 0) {
 			/* None of INT[A|B|C|D] may be virtualized by vfio */
 			ha->port_no = PCI_FUNC(ha->pdev->devfn);
-- 
2.56.0

