From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: mpt fusion broken sometime since 2.6.24
Date: Tue, 17 Feb 2009 18:49:48 -0800
Message-ID: <499B774C.5010705@kernel.org>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm>  <alpine.DEB.1.10.0902171343280.26625@asgard.lang.hm>  <20090217230050.GG16841@parisc-linux.org>  <alpine.DEB.1.10.0902171506500.26625@asgard.lang.hm> <86802c440902171511s1abcc0eao560df4b8fcea0e7c@mail.gmail.com> <alpine.DEB.1.10.0902171514120.26625@asgard.lang.hm> <499B46B2.5040601@kernel.org> <alpine.DEB.1.10.0902171537260.26625@asgard.lang.hm> <499B6BF7.9090300@kernel.org> <alpine.DEB.1.10.0902171803040.26625@asgard.lang.hm> <499B724A.2040408@kernel.org> <alpine.DEB.1.10.0902171832560.26625@asgard.lang.hm> <alpine.DEB.1.10.0902171839420.26625@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:50310 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbZBRCuV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2009 21:50:21 -0500
In-Reply-To: <alpine.DEB.1.10.0902171839420.26625@asgard.lang.hm>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: david@lang.hm
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com

david@lang.hm wrote:
> On Tue, 17 Feb 2009, david@lang.hm wrote:
> 
>>> do you have chance to try current tip/master
>>> http://people.redhat.com/mingo/tip.git/readme.txt
>>> or 2.6.29-rcX
>>> plus following patch?
>>
>> I will see about trying this.
> 
> does the fact that I am compiling a monolithic kernel (no modules) make
> any difference related to the patch below?

please try this patch too. wonder if your BIOS does enable the HT MSI ...


diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index baad093..7e97b90 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1981,6 +1981,9 @@ static void __devinit quirk_msi_ht_cap(struct pci_dev *dev)
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_HT2000_PCIE,
 			quirk_msi_ht_cap);
 
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_8132_BRIDGE,
+			quirk_msi_ht_cap);
+
 
 /* The nVidia CK804 chipset may have 2 HT MSI mappings.
  * MSI are supported if the MSI capability set in any of these mappings.
