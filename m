From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 7180] New: aic94xx driver locks up on IBM x366
 with Calgary IOMMU enabled
Date: Thu, 21 Sep 2006 18:23:50 -0700
Message-ID: <20060921182350.55cb2816.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:19908 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932176AbWIVBYN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Sep 2006 21:24:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Andi Kleen <ak@muc.de>, Muli Ben-Yehuda <muli@il.ibm.com>
Cc: alexisb@us.ibm.com, djwong@us.ibm.com, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>



Begin forwarded message:

Date: Thu, 21 Sep 2006 18:10:56 -0700
From: bugme-daemon@bugzilla.kernel.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 7180] New: aic94xx driver locks up on IBM x366 with Calgary IOMMU enabled


http://bugzilla.kernel.org/show_bug.cgi?id=7180

           Summary: aic94xx driver locks up on IBM x366 with Calgary IOMMU
                    enabled
    Kernel Version: 2.6.18
            Status: NEW
          Severity: normal
             Owner: djwong@us.ibm.com
         Submitter: djwong@us.ibm.com
                CC: alexisb@us.ibm.com


Most recent kernel where this bug did not occur: 2.6.17
Distribution: Ubuntu 6.06
Hardware Environment: IBM x366, 4x 3.16GHz Xeon, 8G RAM, aic94xx SAS controller,
6x 36G SAS disks, Calgary IOMMU
Software Environment: netbooted Ubuntu mutant.
Problem Description: aic94xx driver NMIs the system if calgary iommu is enabled.

Steps to reproduce:
1. Clone linux-2.6 and add in scsi-misc, scsi-rc-fixes and aic94xx from
git.kernel.org.
2. Build a netbootable "allmodconfig" kernel with attached config file.
3. Calgary IOMMU code activates
4. Subsequent loading of the aic94xx driver causes the service processor to log
a PCI SERR with a split completion timeout, followed by an NMI, followed by a
reboot.

Note that disabling the Calgary IOMMU for the bus that the SAS controller is
connected to (either via kconfig or iommu=none or calgary=disable=1) will make
the problem go away.

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
