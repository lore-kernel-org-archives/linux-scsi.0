From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: How to find which (physical) SCSI HBA corresponds to which host n	umber?
Date: Thu, 31 Mar 2005 15:27:19 -0800
Message-ID: <OFE5148F31.711C0D7B-ON88256FD5.007E8065-88256FD5.0080B3FC@us.ibm.com>
References: <267988DEACEC5A4D86D5FCD780313FBB065448B3@exch-03.noida.hcltech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:13278 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262572AbVCaX0k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2005 18:26:40 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j2VNQeaO026161
	for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2005 18:26:40 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j2VNQdG3224272
	for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2005 18:26:40 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j2VNQZMW023047
	for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2005 18:26:39 -0500
In-Reply-To: <267988DEACEC5A4D86D5FCD780313FBB065448B3@exch-03.noida.hcltech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Rajat Jain, Noida" <rajatj@noida.hcltech.com>
Cc: linux-scsi@vger.kernel.org

By default, Linux assigns host numbers to HBAs somewhat arbitrarily.  In 
practice, it's fairly predictable as long as you don't change anything -- 
Linux assigns them sequentially starting at zero in the order in which it 
discovers them, which is controlled first by the order in which Linux 
initializes the corresponding HBA driver.

But you can control it a little.  The 'scsihosts' module parameter of the 
SCSI midlayer driver scsi_mod reserves host numbers for specific HBA 
drivers.  It looks like "scsihosts=aic7xxx,aic7xxx,qla1280".  That means 
to reserve host numbers 0 and 1 for the aic7xxx driver and 2 for qla1280. 
The two reserved for aic7xxx are assigned in the order that the aic7xxx 
driver registers them, which is ordinarily the order in which the aic7xxx 
driver detects them.  I don't think there's usually a way to control that, 
but it should be repeatable as long as the hardware configuration stays 
the same.  But it's generally not good to rely on the hardware 
configuration staying the same.  Some day, one card will be broken or 
temporarily removed, and that will change the host number of the other 
one.

As with other SCSI numbering (LUNs, Linux device numbers), you normally 
don't try to prescribe which numbers go to which equipment, but rather 
discover afterward -- proc/scsi/hba_name/host_number.  The identifying 
information is dependent on the particular HBA type and driver, and 
sometimes doesn't exist.

