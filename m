From: "Mr. Berkley Shands" <bshands@exegy.com>
Subject: Adaptec SC4100 AltEvo reports 64 bits of LUN - kernel panics (2.6.9-2.6.12)
Date: Fri, 18 Mar 2005 12:26:48 -0600
Message-ID: <423B1D68.5050503@exegy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from [207.150.135.24] ([207.150.135.24]:20240 "EHLO
	HANAFORD.eng.exegy.net") by vger.kernel.org with ESMTP
	id S262023AbVCRS0y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Mar 2005 13:26:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have an Adaptec 12 bay U320 scsi disk array. It is divided in this 
case into 2 sections
of 6 drives each. Each string of drives reports a "Processor" on unit #15.
Why would the scsi layer scan unit #15 for LUN's? it reports a HUGE 
number of LUN's,
many times more than 511. 0x908789244a030402 LUNs in some cases. The 
scsi layer then
attempts to ask each of these LUNS what it is doing, overruns the 
allocated space, and
panics the kernel. This is independent of the controller. AIC79XX 
(39320A-R) or LSI Fusion
(LSI22320) all see this device, duly report it to the scsi layer, which 
75% of the time panics
and then panics during the panic, or OOPSes and then panics in the OOPS.

Mar 18 12:01:11 typhoon kernel:   Vendor: ADAPTEC   Model: AltEvo 
U320       Rev: 0028
Mar 18 12:01:11 typhoon kernel:   Type:   
Processor                          ANSI SCSI revision: 03

If the reported LUN count is odd, don't bother scanning it. If the 
reported unit is NOT a disk,
don't scan it. drivers/scsi/scsi_scan.c happily scans ALL the given 
units, and walks over itself.
I used a redhat es4.0 base on an AMD64 dual opteron with vanilla 2.6.9 - 
2.6.12-rc1, all will
crash with this hardware being present.

details are available via email.
