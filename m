From: Bryan Henderson <hbryan@us.ibm.com>
Subject: RE: How to find which (physical) SCSI HBA corresponds to which ho	st n
	umber?
Date: Fri, 1 Apr 2005 09:47:21 -0800
Message-ID: <OF48E31788.A91E33AF-ON88256FD6.00605364-88256FD6.00619462@us.ibm.com>
References: <267988DEACEC5A4D86D5FCD780313FBB065A083E@exch-03.noida.hcltech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:18311 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262824AbVDARqu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2005 12:46:50 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j31Hkn2i032761
	for <linux-scsi@vger.kernel.org>; Fri, 1 Apr 2005 12:46:49 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j31HknZo088514
	for <linux-scsi@vger.kernel.org>; Fri, 1 Apr 2005 12:46:49 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j31HkmVa025586
	for <linux-scsi@vger.kernel.org>; Fri, 1 Apr 2005 12:46:49 -0500
In-Reply-To: <267988DEACEC5A4D86D5FCD780313FBB065A083E@exch-03.noida.hcltech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, "Rajat Jain, Noida" <rajatj@noida.hcltech.com>

>>proc/scsi/hba_name/host_number.
>
>This proc entry is made AFTER the device is registered with SCSI 
mid-level
>driver (scsi_mod). 

This proc entry is not related to a device.  It's the entry that describes 
the HBA, and it gets created as part of registering the HBA (host).

>after I add a SCSI device to one of the HBAs, the only
>option I have left with me is following
>
>For n = 0 to N
>Do
>                echo "scsi add-single-device n 0 ID 0" > /proc/scsi/scsi

If you and Linux could identify the host in common terms, you wouldn't 
have to do this.  But the question is open as to in what terms you 
personally identify the host to which you attached the device.  Is it the 
controller to the west?  The red one?  The new one?  The one with serial 
number 8436547?  The one at PCI address X:Y:Z?  The one that has your disk 
drives on it?

The host proc file often has a serial number in it.  Sometimes it has a 
fibre channel worldwide node name.

It seems to me that you're probably right, though: the easiest thing is 
just to try to add the bus/target/LUN to every host.  In an ideal world, 
you'd do this with hotplug.

