From: Naveen Burmi <naveenb@cisco.com>
Subject: Linux iscsi driver update 4.0.1.9
Date: Fri, 17 Sep 2004 22:07:47 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200409172207.47253.naveenb@cisco.com>
Reply-To: naveenb@cisco.com
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:7184 "EHLO
	sj-iport-2.cisco.com") by vger.kernel.org with ESMTP
	id S269001AbUIQQiB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Sep 2004 12:38:01 -0400
Received: from naveenb-lnx.cisco.com (naveenb-lnx.cisco.com [10.77.7.56])
	by sj-core-1.cisco.com (8.12.10/8.12.6) with ESMTP id i8HGbv7Y020958
	for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2004 09:37:58 -0700 (PDT)
Received: from localhost (localhost [[UNIX: localhost]])
	by naveenb-lnx.cisco.com (8.11.6/8.11.6) id i8HGblv22841
	for linux-scsi@vger.kernel.org; Fri, 17 Sep 2004 22:07:47 +0530
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>


Folks,

Thanks to all of you for providing and reviewing patches.
Special thanks to Christopher and James Bottomley.
https://sourceforge.net/project/shownotes.php?release_id=268685

This version of the iSCSI driver (4.0.1.9) contains the following changes
since 4.0.1.8:

1)The iSCSI driver has undergone architectural changes. The driver now 
supports one HBA per transport end point( i.e., per iSCSI session).

2)Earlier the iSCSI driver had it's own code to probe LUNs. Now it uses 
SCSI-ml provided scsi_scan_host() to probe and configure LUNs.

3)Multiple kmaps from rx path have now been removed.

4)The driver used to provide persistant naming of iSCSI devices using 'udev'.
The names used to be based on bus id and target id of the session which
inturn were kept persistant across boots. The driver no longer supports this.
This is to be consistent with the rest of HBA drivers.

5)The code has been cleaned up further. We no longer have mixed case names
in the kernel files.


The following items are being worked on/debated:

a)cleanup of threading, signals, interfaces.
  removal of dead code
  cleaning up of error paths
 some cleanup of timer, ipv6,logging

b)Changes so as to be compliant with driver model.

c)Usage of mid layer provided APIs to traverse through device list instead
of using session_list link in iscsi_dev_data.

d)Usage of new timeout infrastructure to get rid  of iSCSI driver's
eh_timeout modifications.

e)Removal of portal-failover feature.

f)Usage of new TCQ APIs(yet to provided in linux 2.6) to get rid of iSCSI 
driver's mechanism to generate tags.

h)Replacement of ioctls with sysfs interface.

PS The current driver is tested against 2.6.8.1 linux kernel.

Thanks,
Naveen.
