From: "Rajat  Jain, Noida" <rajatj@noida.hcltech.com>
Subject: Hot Plugging support in 2.6??
Date: Thu, 10 Feb 2005 12:01:37 +0530
Message-ID: <267988DEACEC5A4D86D5FCD780313FBB0447FDC7@exch-03.noida.hcltech.com>
Mime-Version: 1.0
Content-Type: text/plain
Received: from ngate.noida.hcltech.com ([202.54.110.230]:27876 "EHLO
	ngate.noida.hcltech.com") by vger.kernel.org with ESMTP
	id S262037AbVBJHhs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Feb 2005 02:37:48 -0500
Received: from exch-03.noida.hcltech.com ([204.160.254.29])
	by ngate.noida.hcltech.com (8.12.5/8.12.5) with ESMTP id j1A7mCtf012088
	for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2005 13:18:13 +0530
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I'm investigating the "Hot Plugging" support in SCSI subsystem of linux
kernel 2.6.8. I am working at the LLD level. I went through the "Hot Plug
Initialisation Model" in Doumentation/scsi/scsi_mid_low_api.txt (which is
not up to date) and code and concluded that :

1) In case a new HBA is Hot plugged, the LLD needs to call
scsi_host_alloc(), scsi_add_host(), scsi_scan_host().
2) In case an existing HBA is Hot UN-plugged, the LLD needs to call
scsi_remove_host(), scsi_host_put().
3) In case a new SCSi device is hot plugged / Un plugged to an existing HBA,
LLD needs to call scsi_add_device() / scsi_remove_device() respectively.

But what is not clear to me is that how exacly I (as an LLD writer) come to
know that a new device has been detected? So where do I put these calls? Are
there any specific functions in LLD that are called when a new device / HBA
is added??  The documentation says this:

"Typically a driver will respond to a sysfs probe() callback that indicates
an HBA has been detected". 

What does this mean? Simply put, I have my own function that I want to be
called when ever a new SCSI device is detected on an existing HBA. How do I
do that? Or how can I achieve this functionality?

Any pointers are welcome. 
 

Thanks & regards,

Rajat Jain
HCL Technologies,
A-11, Sector 16, Noida-201301. 
Ph: +91-120-2510701/702/813 Extn.3019
rajatj@noida.hcltech.com
http://www.hcltech.com/
	"...one of the main causes of the fall of the Roman Empire was that,
lacking zero, they had no way to indicate successful termination of their C
programs."
	Robert Firth 
 
