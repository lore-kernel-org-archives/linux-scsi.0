Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9121EDA09;
	Thu, 20 Feb 2025 09:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740042904; cv=none; b=sReSv8tkgx5bQv9yTHTyvbgUF6kf+82lzCLQu7RSfQudlh70IP2klHeiu8d/KppgaUyQR5Qo8s6mdrEkIEJhDAUhTF8glHg21Hv90UnNawJIB+0Ka9xl3OEoKW++MKEKrlMl/dlORUirEFTkVEXn42gxF6yPKwPI0X9x1HDklhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740042904; c=relaxed/simple;
	bh=9V8oQvtLpvzEkG6QZxSvXecP++MBYn5SP5iJGzoscsw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rfO3RUq0hQk5YQJNCMmRmJY4uQ5Rcj90wjPFEooYkFXSADNaiF0jLR/WKVOgPQl5lJrQ8zjUhr1K4+B/GT9BpROp7ymthB0KDuSKURKsuKvJqSC1B7n1JtM5yOMx7suYokCAUtHi1X8Rpbkyt78KJJ5qc5CFmin+FrrvtTmlcso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=FtzDu7gx; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="FtzDu7gx"
Received: from fedora.intra.ispras.ru (unknown [10.10.165.14])
	by mail.ispras.ru (Postfix) with ESMTPSA id 027F8407853D;
	Thu, 20 Feb 2025 09:14:57 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 027F8407853D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1740042897;
	bh=EoITuU5uD8vALEDDpECccHLtngcOKWIXTq101VPMvdo=;
	h=From:To:Cc:Subject:Date:From;
	b=FtzDu7gx/s5fzkMWTlVlV4aIQ4QyCmZAPTgS8Rorlm6G8X2cFdXEmQn2sH3DajxN4
	 QMksAR3KuY+TVxVl45ak6EQ0EhnyZ66hIlfelJyw04NYLSDppEJvnqELK7as2fwpKV
	 LsBWMTvS838bBTzmvzhaMZpP9WZaoomfau/KvBtM=
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Fedor Pchelkin <pchelkin@ispras.ru>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Eric Moore <eric.moore@lsil.com>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	"Bart Van Assche" <bvanassche@acm.org>,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	stable@vger.kernel.org,
	Aleksandr Mishin <amishin@t-argos.ru>
Subject: [PATCH] scsi: message: fusion: Fix out-of-bounds shift in phy bitmask calculation
Date: Thu, 20 Feb 2025 12:14:35 +0300
Message-ID: <20250220091436.17412-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In mptsas_setup_wide_ports() the calculation of phy bitmask is a subject
to undefined behavior when phy index exceeds the width of type 'int', but
is still less than 64.

Utilize BIT_ULL macro to fix this.

Found by Linux Verification Center (linuxtesting.org) with SVACE static
analysis tool.

Fixes: 547f9a218436 ("[SCSI] mptsas: wide port support")
Cc: stable@vger.kernel.org
Co-developed-by: Aleksandr Mishin <amishin@t-argos.ru>
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
struct mptsas_portinfo_details::phy_bitmask is used only in various
logging printks throughout the driver. Another option would be to drop
this field completely if it is considered a more appropriate solution..

 drivers/message/fusion/mptsas.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 7e79da9684ed..cd95655f1592 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -43,6 +43,7 @@
 */
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 
+#include <linux/bits.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
@@ -880,7 +881,7 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info)
 		    "%s: [%p]: deleting phy = %d\n",
 		    ioc->name, __func__, port_details, i));
 		port_details->num_phys--;
-		port_details->phy_bitmask &= ~ (1 << phy_info->phy_id);
+		port_details->phy_bitmask &= ~BIT_ULL(phy_info->phy_id);
 		memset(&phy_info->attached, 0, sizeof(struct mptsas_devinfo));
 		if (phy_info->phy) {
 			devtprintk(ioc, dev_printk(KERN_DEBUG,
@@ -915,7 +916,7 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info)
 			port_details->port_info = port_info;
 			if (phy_info->phy_id < 64 )
 				port_details->phy_bitmask |=
-				    (1 << phy_info->phy_id);
+					BIT_ULL(phy_info->phy_id);
 			phy_info->sas_port_add_phy=1;
 			dsaswideprintk(ioc, printk(MYIOC_s_DEBUG_FMT "\t\tForming port\n\t\t"
 			    "phy_id=%d sas_address=0x%018llX\n",
@@ -957,7 +958,7 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info)
 			phy_info_cmp->port_details = port_details;
 			if (phy_info_cmp->phy_id < 64 )
 				port_details->phy_bitmask |=
-				(1 << phy_info_cmp->phy_id);
+					BIT_ULL(phy_info_cmp->phy_id);
 			port_details->num_phys++;
 		}
 	}
-- 
2.48.1

