From: "Manish Kumar Bhojasia" <mbhojasi@cisco.com>
Subject: [PATCH] iscsi driver 4.0.1.7
Date: Wed, 16 Jun 2004 21:23:46 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <FFEFJMNKOMGHNFBIAHOCKEKNDLAA.mbhojasi@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ind-iport-1-sec.cisco.com ([64.104.129.9]:23166 "EHLO
	ind-iport-1.cisco.com") by vger.kernel.org with ESMTP
	id S264076AbUFPPxz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2004 11:53:55 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: "Linux-Iscsi-Devel@Lists. Sourceforge. Net" <linux-iscsi-devel@lists.sourceforge.net>


This version of the iSCSI driver (4.0.1.7) includes the following changes:

1. Code cleanup done as per linux kernel coding guidelines.
2. Removed unnecessary volatile and memory barriers from the code.
3. Christoph's comments taken care of (few important ones mentioned here)
   - iSCSI driver was creating /dev/iscsi links from within the kernel for
     providing persistent names. iSCSI driver now uses udev to achieve the
     same.
   - Driver had procfs code and attributes. This has been changed for sysfs.
   - Removed md5 and crc from the driver and using common crypto APIs
     instead.
   - iSCSI driver had a special handling if the system was booted on
     iSCSI disk. This has been removed.
   - iSCSI driver had backward compatibility stuff for 2.4 kernels.  All
     those have now been removed.
   - Use of linked lists from lists.h
   - Many unwanted checks have been removed.
   - The driver used to have complex list walking through the HBA list,
     though it used to allocate only one HBA struct. This has now been
     simpilified. The driver supports only one HBA.
   - Use of DID_IMM_RETRY (2.6.5 kernel) has been introduced in kernel for
     error handling.
   - Sysfs one value per file violation has been taken care of.
   - Removal of PREVENT_DATA_CORRUPTION code.
   - Breakup of big iscsi.c file into many smaller files.
   - Use of TCQ from include/linux/scsi_tcq.h
4. Numerous other cleanups and minor bug-fixes.

The following items are being worked on/debated:

a) Per target probe via hotplug.
In earlier reviews, it was debated that the hotplug mechanism should be used
for target activation. Though scsi_scan_host() is exported,
scsi_scan_host_selected() isn't. So, an adapter scan is exported to LLDD
whereas anything else (target or lun scan) has to go through hotplug.
Network oriented storage like iSCSI has to deal with delays in targets
getting discovered through SendTargets discovery and poll for SLP discoveries.
It would help a lot to use scsi_scan_host_selected() in such cases and needs
to be exported for such LLDDs.

b) It was suggested to remove the portal failover feature from the LLDD.
However, we still feel that it is more of a protocol feature as opposed
to say, paths found from multiple HBAs. iSCSI protocol allows multiple
connections per session to do failover, load balancing, etc. at the iscsi
driver level. However, we do export multiple paths to a target to upper
layers drivers if user sets "multipath" in the config (/etc/iscsi.conf)
file. So, we would like to retain this feature in the driver.

c) Removal of multiple kmaps from xmit and recv. Use of sendpage in the xmit
path.

Comments on items a) and b), or any other topics, would be appreciated.

The driver was not included as a patch because the file is too big, but it
can be downloaded from:

http://sourceforge.net/project/showfiles.php?group_id=26396&package_id=106938&release_id=246287

P.S. The current driver is tested against 2.6.6 linux kernel.

Thanks,
Manish
