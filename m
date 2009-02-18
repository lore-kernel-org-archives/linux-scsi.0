From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: mpt fusion broken sometime since 2.6.24
Date: Tue, 17 Feb 2009 19:47:26 -0800
Message-ID: <499B84CE.7090707@kernel.org>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm>  <alpine.DEB.1.10.0902171343280.26625@asgard.lang.hm>  <20090217230050.GG16841@parisc-linux.org>  <alpine.DEB.1.10.0902171506500.26625@asgard.lang.hm> <86802c440902171511s1abcc0eao560df4b8fcea0e7c@mail.gmail.com> <alpine.DEB.1.10.0902171514120.26625@asgard.lang.hm> <499B46B2.5040601@kernel.org> <alpine.DEB.1.10.0902171537260.26625@asgard.lang.hm> <499B6BF7.9090300@kernel.org> <alpine.DEB.1.10.0902171803040.26625@asgard.lang.hm> <499B724A.2040408@kernel.org> <alpine.DEB.1.10.0902171832560.26625@asgard.lang.hm> <alpine.DEB.1.10.0902171839420.26625@asgard.lang.hm> <499B774C.5010705@kernel.org> <alpine.DEB.1.10.0902171917420.26625@asgard.lang.hm> <499B807B.2050509@kernel.org> <alpine.DEB.1.10.0902171935110.26625@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070007070007020405030709"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:40402 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbZBRDr5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2009 22:47:57 -0500
In-Reply-To: <alpine.DEB.1.10.0902171935110.26625@asgard.lang.hm>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: david@lang.hm
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com

This is a multi-part message in MIME format.
--------------070007070007020405030709
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

please try two patches at the same time on 2.6.29-rc5.
don't apply other patch.

YH

--------------070007070007020405030709
Content-Type: text/x-patch;
 name="enable_8132_msi.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="enable_8132_msi.patch"

[PATCH] pci: enable MSI on 8132

Impact: workaround BIOS that doesn't enable that bit

David reported that LSI sas doesn't work with MSI.
it turns out that BIOS doesn't enable HT MSI
8132 does support HT MSI.
add quirk to enable it

Reported-by: David Lang <david@lang.hm>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/quirks.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/quirks.c
===================================================================
--- linux-2.6.orig/drivers/pci/quirks.c
+++ linux-2.6/drivers/pci/quirks.c
@@ -1981,7 +1981,6 @@ static void __devinit quirk_msi_ht_cap(s
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_HT2000_PCIE,
 			quirk_msi_ht_cap);
 
-
 /* The nVidia CK804 chipset may have 2 HT MSI mappings.
  * MSI are supported if the MSI capability set in any of these mappings.
  */
@@ -2032,6 +2031,9 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_S
 			 PCI_DEVICE_ID_SERVERWORKS_HT1000_PXB,
 			 ht_enable_msi_mapping);
 
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_8132_BRIDGE,
+			 ht_enable_msi_mapping);
+
 /* The P5N32-SLI Premium motherboard from Asus has a problem with msi
  * for the MCP55 NIC. It is not yet determined whether the msi problem
  * also affects other devices. As for now, turn off msi for this device.

--------------070007070007020405030709
Content-Type: text/x-patch;
 name="enable_lsi_sas_msi.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="enable_lsi_sas_msi.patch"

[PATCH] mpt: fix enable lsi sas to use msi as default

Impact: fix bug

the third param in module_param(,,) is perm instead of default value.
we still need to assign default at first.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/message/fusion/mptbase.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/message/fusion/mptbase.c
===================================================================
--- linux-2.6.orig/drivers/message/fusion/mptbase.c
+++ linux-2.6/drivers/message/fusion/mptbase.c
@@ -90,8 +90,8 @@ module_param(mpt_msi_enable_fc, int, 0);
 MODULE_PARM_DESC(mpt_msi_enable_fc, " Enable MSI Support for FC \
 		controllers (default=0)");
 
-static int mpt_msi_enable_sas;
-module_param(mpt_msi_enable_sas, int, 1);
+static int mpt_msi_enable_sas = 1;
+module_param(mpt_msi_enable_sas, int, 0);
 MODULE_PARM_DESC(mpt_msi_enable_sas, " Enable MSI Support for SAS \
 		controllers (default=1)");
 

--------------070007070007020405030709--
