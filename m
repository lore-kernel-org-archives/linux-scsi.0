From: "Zhao, Forrest" <forrest.zhao@intel.com>
Subject: Proposal to add a new sysfs attribute to SCSI device
Date: Tue, 22 Mar 2005 11:05:06 +0800
Message-ID: <8126E4F969BA254AB43EA03C59F44E8401A88416@pdsmsx404>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Received: from fmr18.intel.com ([134.134.136.17]:49841 "EHLO
	orsfmr003.jf.intel.com") by vger.kernel.org with ESMTP
	id S262341AbVCVDFO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Mar 2005 22:05:14 -0500
Received: from orsfmr101.jf.intel.com (orsfmr101.jf.intel.com [10.7.209.17])
	by orsfmr003.jf.intel.com (8.12.10/8.12.10/d: major-outer.mc,v 1.1 2004/09/17 17:50:56 root Exp $) with ESMTP id j2M35AlO026622
	for <linux-scsi@vger.kernel.org>; Tue, 22 Mar 2005 03:05:10 GMT
Received: from pdsmsxvs01.pd.intel.com (pdsmsxvs01.pd.intel.com [172.16.12.122])
	by orsfmr101.jf.intel.com (8.12.10/8.12.10/d: major-inner.mc,v 1.2 2004/09/17 18:05:01 root Exp $) with SMTP id j2M34eSU028495
	for <linux-scsi@vger.kernel.org>; Tue, 22 Mar 2005 03:05:08 GMT
Received: from pdsmsx331.ccr.corp.intel.com ([172.16.12.58])
 by pdsmsxvs01.pd.intel.com (SAVSMTP 3.1.7.47) with SMTP id M2005032211050616487
 for <linux-scsi@vger.kernel.org>; Tue, 22 Mar 2005 11:05:06 +0800
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi, list

Background: As we know, when the SCSI disk is in failure state, for
example bad sectors appear on disk or disk is surprise-removed, the SCSI
middle-layer will endless retry the failed I/O requests if SCSI
mid-layer can't get the notification from LLDD to stop the retry.
Unfortunately now *not all LLDD* can notify the mid-layer to stop the
retry when SCSI disk is in failure state. 

Let me tell you the testing experience in our lab: 
1 we install kernel 2.6.11.2 on a Tiger4 platform, 
2 there're two SCSI disks, one is sda for root fs, the other is sdb for
/mnt
3 execute "cp -r /usr/src/linux-2.6.11.2 /mnt"
4 during the process of copying, we surprise-removed sdb 
5 then system become very busy and freezing, even the user can't login
into the system whether locally or remotely
6 the error output on the screen demonstrates that SCSI mid-layer is
endless retrying the failed I/O requests

To overcome this morbid(or weird) behavior, I propose to add a new sysfs
attribute to SCSI device.
Attribute name: stop_retry_threshold
Description: user set a threshold value through this interface, so that
after SCSI mid-layer has retried "threshold" times, it'll automatically
stop the further retries to make system calm down and usable to other
users.
Usage example: user execute "echo 100 >
/sys/block/sdb/device/stop_retry_threshold" to tell SCSI mid-layer to
automatically stop the further retries after it has retries 100 times.

What's your comment about this proposal? If there's no objection, I'll
send out the patch soon.

Thanks,
Forrest
